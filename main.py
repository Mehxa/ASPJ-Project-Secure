from flask import Flask, render_template, request, redirect, url_for, flash, jsonify, make_response, abort, json
from flask_bcrypt import *
import mysql.connector, re, random
from datetime import datetime, timedelta, date
from functools import wraps
import Forms, DatabaseManager, createLog

# Flask mail
import os
from flask_mail import Mail, Message
import sys
import asyncio
from threading import Thread

# Logging
import flask_monitoringdashboard as dashboard
import logging, logging.config, yaml

# Graphing
import json, plotly
import pandas as pd
import numpy as np
import plotly.graph_objs as go

import requests
import secrets


db = mysql.connector.connect(
    host="localhost",
    user=os.environ["DB_USERNAME"],
    password=os.environ["DB_PASSWORD"],
    database="secureblogdb"
)

tupleCursor = db.cursor(buffered=True)
dictCursor = db.cursor(buffered=True, dictionary=True)
tupleCursor.execute("SHOW TABLES")
print(tupleCursor)

app = Flask(__name__)
app.logger.disabled = True
log = logging.getLogger('werkzeug')
log.disabled = True

dashboard.config.init_from(file='config.cfg')
dashboard.bind(app)
app.config.update(
    MAIL_SERVER= 'smtp.office365.com',
    MAIL_PORT= 587,
    MAIL_USE_TLS= True,
    MAIL_USE_SSL= False,
	MAIL_USERNAME = 'deloremipsumonlinestore@outlook.com',
	MAIL_PASSWORD = os.environ["MAIL_PASSWORD"],
	MAIL_DEBUG = True,
	MAIL_SUPPRESS_SEND = False,
    MAIL_ASCII_ATTACHMENTS = True,
    # Directory for admins to refer files (Files)
    UPLOAD_FOLDER = "templates\Files"
	)

app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'
app.config['RECAPTCHA_PUBLIC_KEY'] = '6LdVRrYZAAAAAMn5_QZZrsMfqEG8KmC7nhPwu8X1'
app.config['RECAPTCHA_PRIVATE_KEY'] = '6LdVRrYZAAAAAM-F0Ur8eLAgwjvp3OqpZwAhQHby'

mail = Mail(app)
bcrypt = Bcrypt(app)
""" For testing purposes only. To make it convenient cause I can't remember all the account names.
Uncomment the account that you would like to use. To run the program as not logged in, run the first one."""
global sessionID
sessionID = 0
sessions={}
sessionInfo = {'login': False, 'currentUserID': 0, 'username': '', 'isAdmin': 0}
# sessionInfo = {'login': True, 'currentUserID': 1, 'username': 'NotABot', 'isAdmin': 1}
# Password: NotABot123
# sessionInfo = {'login': True, 'currentUserID': 2, 'username': 'CoffeeGirl', 'isAdmin': 1}
# Password: CoffeeGirl123
# sessionInfo = {'login': True, 'currentUserID': 3, 'username': 'Mehxa', 'isAdmin': 1}
# Password: Mehxa123
# sessionInfo = {'login': True, 'currentUserID': 4, 'username': 'Kobot', 'isAdmin': 1}
# Password: Kobot123
# sessionInfo = {'login': True, 'currentUserID': 5, 'username': 'MarySinceBirthButStillSingle', 'isAdmin': 0}
# Password: MaryTan123
# sessionInfo = {'login': True, 'currentUserID': 6, 'username': 'theauthenticcoconut', 'isAdmin': 0}
# Password: nuts@coco
# sessionInfo = {'login': True, 'currentUserID': 7, 'username': 'johnnyjohnny', 'isAdmin': 0}
# Password: hohohomerrychristmas
# sessionInfo = {'login': True, 'currentUserID': 8, 'username': 'iamjeff', 'isAdmin': 0}
# Password: iaminevitable
# sessionInfo = {'login': True, 'currentUserID': 9, 'username': 'hanbaobao', 'isAdmin': 0}
# Password: burgerking02
sessionID += 1
sessionInfo['sessionID'] = sessionID
sessions[sessionID] = sessionInfo

# captcha_key = '6LdgFLYZAAAAAC9nKyG3lnmsuVvp7Bh2xB673dSF'
# capthca_secret = '6LdgFLYZAAAAALldW3bMk_5COICxWAKHe2QFJrGd'

def login_required(function_to_wrap):
    @wraps(function_to_wrap)
    def wrap(*args, **kwargs):
        if sessionInfo['login']==True:
            return function_to_wrap(*args, **kwargs)
        else:
            flash("Please login to continue.", "warning")
            return redirect('/login')
    return wrap

def admin_required(function_to_wrap):
    @wraps(function_to_wrap)
    def wrap(*args, **kwargs):
        if sessionInfo['login']:
            if sessionInfo['isAdmin']==1:
                return function_to_wrap(*args, **kwargs)
            else:
                createLog.log_error(request.path, 403, 'Forbidden Access to Admin Page by user %s' %sessionInfo['username'])
                abort(403)
        else:
            createLog.log_error(request.path, 401, 'Unauthorized Access to Admin Page')
            abort(401)
    return wrap

def get_all_topics(option):
    sql = "SELECT TopicID, Content FROM topic ORDER BY Content"
    dictCursor.execute(sql)
    listOfTopics = dictCursor.fetchall()
    topicTuples = []
    for topic in listOfTopics:
        topicTuples.append((str(topic['TopicID']), topic['Content']))

    if option=='all':
        topicTuples.insert(0, ('0', 'All Topics'))
    return topicTuples





@app.route('/postVote', methods=["GET", "POST"])
def postVote():
    if not sessionInfo['login']:
        flash('You must be logged in to vote.', 'warning')
        return make_response(jsonify({'message': 'Please log in to vote.'}), 401)

    data = request.get_json(force=True)
    currentVote = DatabaseManager.get_user_vote(str(sessionInfo['currentUserID']), data['postID'])

    if currentVote==None:
        if data['voteValue']=='1':
            toggleUpvote = True
            toggleDownvote = False
            newVote = 1
            upvoteChange = '+1'
            downvoteChange = '0'
        else:
            toggleUpvote = False
            toggleDownvote = True
            newVote = -1
            upvoteChange = '0'
            downvoteChange = '+1'

        DatabaseManager.insert_post_vote(str(sessionInfo['currentUserID']), data['postID'], data['voteValue'])

    else: # If vote for post exists
        if currentVote['Vote']==1:
            upvoteChange = '-1'
            if data['voteValue']=='1':
                toggleUpvote = True
                toggleDownvote = False
                newVote = 0
                downvoteChange = '0'
            else:
                toggleUpvote = True
                toggleDownvote = True
                newVote = -1
                downvoteChange = '+1'

        else: # currentVote['Vote']==-1
            downvoteChange = '-1'
            if data['voteValue']=='1':
                toggleUpvote = True
                toggleDownvote = True
                newVote = 1
                upvoteChange = '+1'
            else:
                toggleUpvote = False
                toggleDownvote = True
                newVote = 0
                upvoteChange = '0'

        if newVote==0:
            DatabaseManager.delete_post_vote(str(sessionInfo['currentUserID']), data['postID'])
        else:
            DatabaseManager.update_post_vote(str(newVote), str(sessionInfo['currentUserID']), data['postID'])

    DatabaseManager.update_overall_post_vote(upvoteChange, downvoteChange, data['postID'])
    updatedVoteTotal = DatabaseManager.calculate_updated_post_votes(data['postID'])
    return make_response(jsonify({'toggleUpvote': toggleUpvote, 'toggleDownvote': toggleDownvote
    , 'newVote': newVote, 'updatedVoteTotal': updatedVoteTotal, 'postID': data['postID']}), 200)

@app.route('/')
def main():
    return redirect("/home")

@app.route('/home', methods=["GET", "POST"])
def home():
#     abort(500)
    sessionInfo['prevPage']= request.url_rule
    searchBarForm = Forms.SearchBarForm(request.form)
    searchBarForm.topic.choices = get_all_topics('all')
    if request.method == 'POST' and searchBarForm.validate():
        return redirect(url_for('searchPosts', searchQuery = searchBarForm.searchQuery.data, topic = searchBarForm.topic.data))

    sql = "SELECT post.PostID, post.Title, post.Content, post.Upvotes, post.Downvotes, post.DatetimePosted, user.Username, topic.Content AS Topic FROM post"
    sql += " INNER JOIN user ON post.UserID=user.UserID"
    sql += " INNER JOIN topic ON post.TopicID=topic.TopicID"
    sql += " ORDER BY post.PostID DESC LIMIT 6"

    dictCursor.execute(sql)
    recentPosts = dictCursor.fetchall()
    for post in recentPosts:
        if sessionInfo['login']:
            currentVote = DatabaseManager.get_user_vote(str(sessionInfo['currentUserID']), str(post['PostID']))
            if currentVote==None:
                post['UserVote'] = 0
            else:
                post['UserVote'] = currentVote['Vote']
        else:
            post['UserVote'] = 0
        post['TotalVotes'] = post['Upvotes'] - post['Downvotes']
        post['Content'] = post['Content'][:200]

    return render_template('home.html', currentPage='home', **sessionInfo, searchBarForm = searchBarForm, recentPosts = recentPosts)

@app.route('/searchPosts', methods=["GET", "POST"])
def searchPosts():
    sessionInfo['prevPage']= request.url_rule
    searchBarForm = Forms.SearchBarForm(request.form)
    searchBarForm.topic.choices = get_all_topics('all')
    if request.method == 'POST' and searchBarForm.validate():
        return redirect(url_for('searchPosts', searchQuery = searchBarForm.searchQuery.data, topic = searchBarForm.topic.data))

    searchQuery = request.args.get('searchQuery', default='')
    searchBarForm.searchQuery.data = searchQuery

    searchTopic = request.args.get('topic', default='0')
    searchBarForm.topic.data = int(searchTopic)

    sql = "SELECT post.PostID, post.Title, post.Content, post.Upvotes, post.Downvotes, post.DatetimePosted, user.Username, topic.Content AS Topic FROM post"
    sql += " INNER JOIN user ON post.UserID=user.UserID"
    sql += " INNER JOIN topic ON post.TopicID=topic.TopicID"
    sql += " WHERE post.Title LIKE %s"

    searchQuery = "%" + searchQuery + "%"

    if searchTopic!='0':
        sql += " AND topic.TopicID=%s"
        val = (searchQuery, searchTopic)
    else:
        val = (searchQuery,)

    dictCursor.execute(sql, val)
    relatedPosts = dictCursor.fetchall()
    for post in relatedPosts:
        post['TotalVotes'] = post['Upvotes'] - post['Downvotes']
        post['Content'] = post['Content'][:200]

    return render_template('searchPost.html', currentPage='search', **sessionInfo, searchBarForm=searchBarForm, postList=relatedPosts)

@app.route('/viewPost/<int:postID>/<sessionId>', methods=["GET", "POST"])
@login_required
def viewPost(postID, sessionId):
    sessionInfo['prevPage']= request.url_rule
    sql = "SELECT post.Title, post.Content, post.Upvotes, post.Downvotes, post.DatetimePosted, user.Username, topic.Content AS Topic FROM post"
    sql += " INNER JOIN user ON post.UserID=user.UserID"
    sql += " INNER JOIN topic ON post.TopicID=topic.TopicID"
    sql += " WHERE PostID=%s"
    val = (postID,)
    dictCursor.execute(sql, val)
    post = dictCursor.fetchone()
    post['TotalVotes'] = post['Upvotes'] - post['Downvotes']

    sql = "SELECT comment.CommentID, comment.Content, comment.DatetimePosted, comment.Upvotes, comment.Downvotes, comment.DatetimePosted, user.Username FROM comment"
    sql += " INNER JOIN user ON comment.UserID=user.UserID"
    sql += " WHERE comment.PostID=%s"
    val = (postID,)
    dictCursor.execute(sql, val)
    commentList = dictCursor.fetchall()
    for comment in commentList:
        comment['TotalVotes'] = comment['Upvotes'] - comment['Downvotes']

        sql = "SELECT reply.Content, reply.DatetimePosted, reply.DatetimePosted, user.Username FROM reply"
        sql += " INNER JOIN user ON reply.UserID=user.UserID"
        sql += " WHERE reply.CommentID=%s"
        val = (comment['CommentID'],)
        dictCursor.execute(sql, val)
        replyList = dictCursor.fetchall()
        comment['ReplyList'] = replyList

    commentForm = Forms.CommentForm(request.form)
    commentForm.userID.data = sessionInfo['currentUserID']
    replyForm = Forms.ReplyForm(request.form)
    replyForm.userID.data = sessionInfo['currentUserID']

    if request.method == 'POST' and commentForm.validate():
        dateTime = datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')
        sql = 'INSERT INTO comment (PostID, UserID, Content, DateTimePosted, Upvotes, Downvotes) VALUES (%s, %s, %s, %s, %s, %s)'
        val = (postID, commentForm.userID.data, commentForm.comment.data, dateTime, 0, 0)
        tupleCursor.execute(sql, val)
        db.commit()
        flash('Comment posted!', 'success')
        return redirect('/viewPost/%d/%d' %(postID,sessionInfo['sessionID']))

    if request.method == 'POST' and replyForm.validate():
        dateTime = datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')
        sql = 'INSERT INTO reply (UserID, CommentID, Content, DateTimePosted) VALUES (%s, %s, %s, %s)'
        val = (replyForm.userID.data, replyForm.repliedID.data, replyForm.reply.data, dateTime)
        tupleCursor.execute(sql, val)
        db.commit()
        flash('Comment posted!', 'success')
        return redirect('/viewPost/%d/%d' %(postID, sessionInfo['sessionID']))

    return render_template('viewPost.html', currentPage='viewPost', **sessionInfo, commentForm = commentForm, replyForm = replyForm, post = post, commentList = commentList)

@app.route('/addPost/<sessionId>', methods=["GET", "POST"])
@login_required
def addPost(sessionId):
    sessionInfo['prevPage']= request.url_rule
    sql = "SELECT TopicID, Content FROM topic ORDER BY Content"
    tupleCursor.execute(sql)
    listOfTopics = tupleCursor.fetchall()

    postForm = Forms.PostForm(request.form)
    postForm.topic.choices = get_all_topics('default')
    postForm.userID.data = sessionInfo['currentUserID']

    if request.method == 'POST' and postForm.validate():
        dateTime = datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')
        sql = 'INSERT INTO post (TopicID, UserID, DateTimePosted, Title, Content, Upvotes, Downvotes) VALUES (%s, %s, %s, %s, %s, %s, %s)'
        val = (postForm.topic.data, postForm.userID.data, dateTime, postForm.title.data, postForm.content.data, 0, 0)
        tupleCursor.execute(sql, val)
        db.commit()
        flash('Post successfully created!', 'success')
        return redirect('/home')

    return render_template('addPost.html', currentPage='addPost', **sessionInfo, postForm=postForm)

@app.route('/feedback/<sessionId>', methods=["GET", "POST"])
@login_required
def feedback(sessionId):
    sessionInfo['prevPage']= request.url_rule
    feedbackForm = Forms.FeedbackForm(request.form)
    feedbackForm.userID.data = sessionInfo['currentUserID']

    if request.method == 'POST' and feedbackForm.validate():
        dateTime = datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')
        sql = 'INSERT INTO feedback (UserID, Reason, Content, DateTimePosted, Resolved) VALUES (%s, %s, %s, %s, %s)'
        val = (feedbackForm.userID.data, feedbackForm.reason.data, feedbackForm.comment.data, dateTime, 0)
        tupleCursor.execute(sql, val)
        db.commit()
        flash('Feedback sent!', 'success')
        return redirect('/feedback/%d' %sessionInfo['sessionID'])

    return render_template('feedback.html', currentPage='feedback', **sessionInfo, feedbackForm = feedbackForm)

def is_human(captcha_response):
    secret = '6LdVRrYZAAAAAM-F0Ur8eLAgwjvp3OqpZwAhQHby'
    payload = {'response': captcha_response, 'secret':secret}
    response = requests.post( "https://www.google.com/recaptcha/api/siteverify",  payload )
    response_text = json.loads(response.text)
    return response_text['success']

global invalid_login_count
invalid_login_count = 0 #rmb to change
@app.route('/login', methods=["GET", "POST"])
def login():
    print("reloaded")
    global invalid_login_count
    sitekey = '6LdVRrYZAAAAAMn5_QZZrsMfqEG8KmC7nhPwu8X1'
    global sessionID
    loginForm = Forms.LoginForm(request.form)
    if request.method == 'POST' and loginForm.validate():
        sql = "SELECT UserID, Username, Password, Active, LoginAttempts, Email FROM user WHERE Username=%s"
        val = (loginForm.username.data,)
        dictCursor.execute(sql, val)
        findUser = dictCursor.fetchone()
        if findUser == None:
            loginForm.password.errors.append('Wrong email or password.')
            invalid_login_count += 1
            print(invalid_login_count)
        else:
            secret = secrets.token_urlsafe(16)
            if findUser['Active'] == 0:
                loginForm.password.errors.append('Your account has been locked')
            else:
                password = findUser["Password"]
                password = "$2b$12$" + password
                password = password.encode("utf8")
                valid = bcrypt.check_password_hash(password, loginForm.password.data)
                print(valid)
                if not valid:
                    invalid_login_count += 1
                    sql = "UPDATE user"
                    sql += " SET LoginAttempts=%s"
                    sql += " WHERE Username=%s"
                    val = ( findUser["LoginAttempts"] + 1,findUser["Username"])
                    tupleCursor.execute(sql, val)
                    db.commit()
                    if findUser["LoginAttempts"] >= 4:
                        createLog.log_error(request.path, 'OTHERS', 'Failed Login Attempt: UserID %s Account Locked' %(findUser["UserID"]))
                        # sql = "UPDATE user"
                        # sql += " SET LoginAttempts=%s,"
                        # sql += " Active=%s"
                        # sql += " WHERE Username=%s"
                        # val = (str(0),str(0),findUser["Username"])
                        # tupleCursor.execute(sql, val)
                        # db.commit()
                        # secret = secrets.token_urlsafe(16)
                        sql = "INSERT into reactivate"
                        sql += " VALUES (%s,%s,%s,%s)"
                        current = "SELECT NOW()"
                        tupleCursor.execute(current)
                        current = tupleCursor.fetchone()
                        current=current[0]
                        val = (secret, str(current), '168:00:00', findUser["UserID"])
                        tupleCursor.execute(sql, val)
                        db.commit()
                        try:
                            email = findUser["Email"]
                            msg = Message("Lorem Ipsum",
                                sender="deloremipsumonlinestore@outlook.com",
                                recipients=[email])
                            url = '/reactivate/' + secret
                            msg.body = "Your account has been locked"
                            msg.html = render_template('email.html', postID="account locked", username=findUser['Username'], content=0, posted=0, reply=0, url=url)
                            mail.send(msg)
                            print("\n\n\nMAIL SENT\n\n\n")
                            # sql = "UPDATE feedback "
                            # sql += "SET Resolved=1"
                            # sql += "WHERE FeedbackID = " +str(feedbackID)
                            # tupleCursor.execute(sql)
                            # db.commit()

                        except Exception as e:
                            print(e)
                            print("Error:", sys.exc_info()[0])
                            print("goes into except")
                        loginForm.password.errors.append("Your account has been locked due to multiple failed login attempts. Check your email to reactivate your account.")
                        #send email
                    else:
                        loginForm.password.errors.append('Wrong email or password.')
                else:
                    captcha_response = request.form['g-recaptcha-response']
                    if is_human(captcha_response):
                        print("human")
                    else:
                        print("U r a bot")
                    sessionInfo['login'] = True
                    sessionInfo['currentUserID'] = int(findUser['UserID'])
                    sessionInfo['username'] = findUser['Username']
                    sessionID += 1
                    sessionInfo['sessionID'] = sessionID
                    sessions[sessionID] = sessionInfo
                    sql = "SELECT * FROM admin WHERE UserID=%s"
                    val = (int(findUser['UserID']),)
                    dictCursor.execute(sql, val)
                    findAdmin = dictCursor.fetchone()
                    invalid_login_count = 0
                    sql = "UPDATE user"
                    sql += " SET LoginAttempts=%s"
                    sql += " WHERE Username=%s"
                    val = (str(0), findUser['Username'])
                    tupleCursor.execute(sql, val)
                    db.commit()
                    flash('Welcome! You are now logged in as %s.' %(sessionInfo['username']), 'success')
                    if findAdmin!=None:
                        sessionInfo['isAdmin'] = True
                        return redirect('/adminHome')
                    else:
                        sessionInfo['isAdmin'] = False

                    return redirect('/home') # Change this later to redirect to profile page

    return render_template('login.html', currentPage='login', **sessionInfo, loginForm = loginForm, sitekey=sitekey, invalid_login_count=invalid_login_count)

@app.route('/reactivate/<secret>',methods=["GET", "POST"])
def reactivate(secret):
    if request.method == 'POST':
        try:
            sql = " SELECT * FROM reactivate"
            sql += " WHERE Secret=%s"
            val = (secret,)
            tupleCursor.execute(sql,val)
            findSecret = tupleCursor.fetchone()
            sql = "SELECT HOUR(TIMEDIFF(%s,%s))"
            current = "SELECT NOW()"
            tupleCursor.execute(current)
            current = tupleCursor.fetchone()
            current=current[0]
            val = (str(current), str(findSecret['DateIssued']))
            tupleCursor.execute(sql,val)
            timePassed = tupleCursor.fetchone()
            if int(timePassed) > 168:
                flash("This link has expired")
                # return render_template('reactivate.html', resend)
            else:
                sql = "UPDATE user"
                sql += " SET Active=%s"
                sql += " ,LoginAttempts=%s"
                sql += " WHERE UserID=("
                sql += " SELECT UserID FROM reactivate"
                sql += " WHERE reactivate.Secret=%s)"
                val = (str(1),0,secret)
                tupleCursor.exectue(sql,val)
                db.commit()
                sql = "DELETE from reactivate WHERE Secret=%s"
                val = (secret,)
                tupleCursor.exectue(sql,val)
                db.commit()
        except:
            flash("Invalid link")

    return render_template('reactivate.html')

@app.route('/logout')
@login_required
def logout():
    global sessionID
    sessionInfo = sessions[sessionID]
    sessionInfo['login'] = False
    sessionInfo['currentUser'] = 0
    sessionInfo['username'] = ''
    sessions.pop(sessionID)
    return redirect('/home')

temp_signup = {}
@app.route('/signup', methods=["GET", "POST"])
def signUp():
    sitekey = '6LdVRrYZAAAAAMn5_QZZrsMfqEG8KmC7nhPwu8X1'
    global temp_signup
    signUpForm = Forms.SignUpForm(request.form)

    if request.method == 'POST' and signUpForm.validate():
        captcha_response = request.form['g-recaptcha-response']
        if is_human(captcha_response):
            print("human")
            temp_details = {}
            temp_details["Email"] = signUpForm.email.data
            temp_details["Username"] = signUpForm.username.data
            temp_details["Birthday"] = str(signUpForm.dob.data)
            temp_details["Status"] = signUpForm.status.data
            temp_details["Password"] = signUpForm.password.data
            temp_details["Resend count"] = 0
            OTP = random.randint(100000, 999999)
            link = secrets.token_urlsafe()
            temp_signup[link] = temp_details
            sql = "INSERT INTO otp (link, otp) VALUES (%s, %s)"
            val = (link, str(OTP))
            tupleCursor.execute(sql, val)
            db.commit()
            print(temp_details["Email"])
            try:
                msg = Message("Lorem Ipsum",
                    sender="deloremipsumonlinestore@outlook.com",
                    recipients=[temp_details["Email"]])
                msg.body = "OTP for Sign Up"
                msg.html = render_template('otp_email.html', OTP=OTP, username=temp_details["Username"])
                mail.send(msg)
                print("\n\n\nMAIL SENT\n\n\n")
            except Exception as e:
                print(e)
                print("Error:", sys.exc_info()[0])
                print("goes into except")
            else:
                flash('Please enter the OTP that was sent to your email.', 'warning')
                flash('The OTP will expire in 3 mins', 'warning')
                return redirect('/login/' + str(link))

        else:
            print("U r a bot")

    return render_template('signup.html', currentPage='signUp', **sessionInfo, signUpForm = signUpForm, sitekey=sitekey)

@app.route('/login/<link>', methods=["GET", "POST"])
def otp(link):
    global sessionID
    global temp_signup
    otpform = Forms.OTPForm(request.form)
    if request.method == "POST" and otpform.validate():
        sql = "SELECT otp, TIME_TO_SEC(TIMEDIFF(%s, Time_Created)) from otp WHERE link = %s"
        val = (datetime.now().strftime('%Y-%m-%d %H:%M:%S'), link)
        tupleCursor.execute(sql, val)
        otp = tupleCursor.fetchone()
        if otp is None:
            flash('Wrong OTP entered. Please try again!')
        elif otp[1] > 180:
            flash('Your OTP has expired. Please resubmit the signup form')
            temp_signup.pop(link)
            sql = "DELETE from otp WHERE link =%s"
            val = (link,)
            tupleCursor.execute(sql,val)
            db.commit()

        else:
            temp_details = temp_signup[link]
            temp_signup.pop(link)
            if str(otp[0]) == otpform.otp.data:
                password_hash = bcrypt.generate_password_hash(temp_details["Password"]).decode("utf8")
                password_hash = password_hash[7:]

                try:
                    sql = "INSERT INTO user (UserID, Email, Username, Birthday, Password) VALUES (%s, %s, %s, %s, %s)"
                    val = (1, temp_details["Email"], temp_details["Username"], temp_details["Birthday"], password_hash)
                    tupleCursor.execute(sql, val)
                    db.commit()

                except mysql.connector.errors.IntegrityError as errorMsg:
                    errorMsg = str(errorMsg)
                    if 'email' in errorMsg.lower():
                        otpForm.otp.errors.append('The email has already been linked to another account. Please use a different email.')
                    elif 'username' in errorMsg.lower():
                        otpForm.otp.errors.append('This username is already taken.')

                else:
                    print("Yes")
                    sql = "SELECT UserID, Username FROM user WHERE Username=%s AND Password=%s"
                    val = (temp_details["Username"], password_hash)
                    tupleCursor.execute(sql, val)
                    findUser = tupleCursor.fetchone()
                    sessionInfo['login'] = True
                    sessionInfo['currentUserID'] = int(findUser[0])
                    sessionInfo['username'] = findUser[1]
                    sessionID += 1
                    sessionInfo['sessionID'] = sessionID
                    sessions[sessionID] = sessionInfo
                    flash('Account successfully created! You are now logged in as %s.' %(sessionInfo['username']), 'success')
                    return redirect('/home')
            else:
                print("OTP failed")

    return render_template('otp.html', otpform = otpform)

@app.route('/profile/<username>/<sessionId>', methods=["GET", "POST"])
def profile(username, sessionId):
    # global sessionID
    sessionInfo = sessions[sessionID]
    updateEmailForm = Forms.UpdateEmail(request.form)
    updateUsernameForm = Forms.UpdateUsername(request.form)
    updateStatusForm = Forms.UpdateStatus(request.form)
    sql = "SELECT Username, Status, Email FROM user WHERE user.Username=%s"
    val = (username,)
    dictCursor.execute(sql, val)
    userData = dictCursor.fetchone()
    sql = "SELECT post.PostID, post.Title, post.Content, post.Upvotes, post.Downvotes, post.DatetimePosted, user.Username, topic.Content AS Topic FROM post"
    sql += " INNER JOIN user ON post.UserID=user.UserID"
    sql += " INNER JOIN topic ON post.TopicID=topic.TopicID"
    sql += " WHERE user.Username=%s"
    sql += " ORDER BY post.PostID DESC LIMIT 6"
    val = (str(username),)
    dictCursor.execute(sql, val)
    recentPosts = dictCursor.fetchall()
    userData['Credibility'] = 0
    if userData['Status'] == None:
        userData['Status'] = userData['Username'] + " is too lazy to add a status"
    for post in recentPosts:
        post['TotalVotes'] = post['Upvotes'] - post['Downvotes']
        userData['Credibility'] += post['TotalVotes']
        post['Content'] = post['Content'][:200]

    if request.method == "POST" and updateEmailForm.validate():
        sql = "UPDATE user "
        sql += "SET Email=%s"
        sql += "WHERE UserID=%s"
        try:
            val = (updateEmailForm.email.data, str(sessionInfo["currentUserID"]))
            tupleCursor.execute(sql, val)
            db.commit()

        except mysql.connector.errors.IntegrityError as errorMsg:
            errorMsg = str(errorMsg)
            if 'email' in errorMsg.lower():
                updateEmailForm.email.errors.append('The email has already been linked to another account. Please use a different email.')
                flash("This email has already been linked to another account. Please use a different email.", "success")
        else:
            flash('Account successfully updated!', 'success')

            return redirect('/profile/' + sessionInfo['username'] + '/' +str(sessionID))

    if request.method == "POST" and updateUsernameForm.validate():
        # password_hash = bcrypt.generate_password_hash(updateProfileForm.password.data).decode("utf8")
        # password = password_hash[7:]
        sql = "UPDATE user "
        sql += "SET Username=%s"
        sql += "WHERE UserID=%s"
        try:
            val = (updateUsernameForm.username.data, str(sessionInfo["currentUserID"]))
            tupleCursor.execute(sql, val)
            db.commit()

        except mysql.connector.errors.IntegrityError as errorMsg:
            errorMsg = str(errorMsg)
            if 'username' in errorMsg.lower():
                flash("This username is already taken!", "success")
                updateUsernameForm.username.errors.append('This username is already taken.')
        else:
            sql = "SELECT Username WHERE UserID=%s"
            val = (str(sessionInfo["currentUserID"]),)
            dictCursor.execute(sql, val)
            db.commit()
            sessionInfo['username'] = dictCursor['Username']
            sessions[sessionID] = sessionInfo
            flash('Account successfully updated! Your username now is %s.' %(sessionInfo['username']), 'success')
            return redirect('/profile/' + sessionInfo['username'] + '/' +str(sessionID))

    if request.method == "POST" and updateStatusForm.validate():
        sql = "UPDATE user "
        sql += "SET Status=%s"
        sql += "WHERE UserID=%s"
        try:
            val = (updateStatusForm.status.data, str(sessionInfo["currentUserID"]))
            tupleCursor.execute(sql, val)
            db.commit()

        except mysql.connector.errors.IntegrityError as errorMsg:
            errorMsg = str(errorMsg)
            flash("An unexpected error has occurred!", "warning")
        else:
            flash('Account successfully updated!', 'success')

            return redirect('/profile/' + sessionInfo['username'] + '/' +str(sessionID))



    return render_template('profile.html', currentPage='myProfile', **sessionInfo, userData=userData, recentPosts=recentPosts,
    updateEmailForm=updateEmailForm, updateUsernameForm=updateUsernameForm, updateStatusForm=updateStatusForm)

@app.route('/changePassword/<username>', methods=["GET"])
def changePassword(username):
    url = secrets.token_urlsafe()
    print(url)
    sql = "INSERT INTO password_url(Url) VALUES(%s)"
    val = (url,)
    tupleCursor.execute(sql, val)
    user_email = "SELECT Email FROM user WHERE user.username=%s"
    val = (username,)
    tupleCursor.execute(user_email, val)
    user_email = tupleCursor.fetchone()
    db.commit()
    abs_url = "http://127.0.0.1:5000/reset/" + url
    print(user_email)
    try:
        msg = Message("Lorem Ipsum",
            sender="deloremipsumonlinestore@outlook.com",
            recipients=[user_email[0]])
        msg.body = "Password Change"
        msg.html = render_template('email.html', postID="change password", username=username, content=0, posted=0, url=abs_url)
        mail.send(msg)
        print("\n\n\nMAIL SENT\n\n\n")
    except Exception as e:
        print(e)
        print("Error:", sys.exc_info()[0])
        print("goes into except")
    else:
        flash('A change password link has been sent to your email. Use it to update your password.', 'success')
        flash('The password link will expire in 30 mins', 'warning')
        return redirect('/profile/' + str(username) + '/' + str(sessionID))


@app.route('/reset/<url>', methods=["GET", "POST"])
def resetPassword(url):
    sql = "SELECT TIME_TO_SEC(TIMEDIFF(%s, Time_Created)) FROM password_url WHERE Url = %s"
    val = (datetime.now().strftime('%Y-%m-%d %H:%M:%S'),url)
    tupleCursor.execute(sql, val)
    reset = tupleCursor.fetchone()
    print(reset)
    if reset > 1800:
        sql = "DELETE FROM password_url WHERE Url=%s"
        val = (url,)
        flash("Your password reset link has expired, please try again!", "error")
        return redirect("/home")
    else:
        return redirect("/home")





@app.route('/topics')
def topics():
    # uncomment from here
    # sessionInfo = sessions[sessionID]
    sql = "SELECT Content,TopicID FROM topic ORDER BY Content "
    tupleCursor.execute(sql)
    listOfTopics = tupleCursor.fetchall()
    return render_template('topics.html', currentPage='topics', **sessionInfo, listOfTopics=listOfTopics)

@app.route('/indivTopic/<topicID>/<sessionId>', methods=["GET", "POST"])
def indivTopic(topicID, sessionId):
    sessionInfo = sessions[sessionID]
    sql = "SELECT post.PostID, post.Title, post.Content, post.Upvotes, post.Downvotes, post.DatetimePosted, user.Username, topic.Content AS Topic FROM post"
    sql += " INNER JOIN user ON post.UserID=user.UserID"
    sql += " INNER JOIN topic ON post.TopicID=topic.TopicID"
    sql += " WHERE topic.TopicID = " + str(topicID)

    dictCursor.execute(sql)
    recentPosts = dictCursor.fetchall()
    for post in recentPosts:
        post['TotalVotes'] = post['Upvotes'] - post['Downvotes']
        post['Content'] = post['Content'][:200]
    topic = "SELECT Content FROM topic WHERE topic.TopicID=%s"
    val = (topicID,)
    tupleCursor.execute(topic, val)
    topic=tupleCursor.fetchone()
    return render_template('indivTopic.html', currentPage='indivTopic', **sessionInfo, recentPosts=recentPosts, topic = topic[0])

@app.route('/adminProfile/<username>', methods=["GET", "POST"])
@admin_required
def adminUserProfile(username):
    sessionInfo = sessions[sessionID]
    updateEmailForm = Forms.UpdateEmail(request.form)
    updateUsernameForm = Forms.UpdateUsername(request.form)
    updateStatusForm = Forms.UpdateStatus(request.form)
    sql = "SELECT Username, Status, Email FROM user WHERE user.Username=%s"
    val = (username,)
    dictCursor.execute(sql, val)
    userData = dictCursor.fetchone()
    sql = "SELECT post.PostID, post.Title, post.Content, post.Upvotes, post.Downvotes, post.DatetimePosted, user.Username, topic.TopicID, topic.Content AS Topic FROM post"
    sql += " INNER JOIN user ON post.UserID=user.UserID"
    sql += " INNER JOIN topic ON post.TopicID=topic.TopicID"
    sql += " WHERE user.Username=%s"
    sql += " ORDER BY post.PostID DESC LIMIT 6"
    val = (str(username),)
    dictCursor.execute(sql, val)
    recentPosts = dictCursor.fetchall()
    userData['Credibility'] = 0
    if userData['Status'] == None:
        userData['Status'] = userData['Username'] + " is too lazy to add a status"
    for post in recentPosts:
        post['TotalVotes'] = post['Upvotes'] - post['Downvotes']
        userData['Credibility'] += post['TotalVotes']
        post['Content'] = post['Content'][:200]
    sql = "SELECT AdminID FROM admin WHERE UserID=(SELECT UserID FROM user WHERE Username=%s)"
    val = (username,)
    dictCursor.execute(sql, val)
    user = dictCursor.fetchone()
    if user is not None:
        admin = True
    else:
        admin = False

    if request.method == "POST" and updateEmailForm.validate():
        sql = "UPDATE user "
        sql += "SET Email=%s"
        sql += "WHERE UserID=%s"
        try:
            val = (updateEmailForm.email.data, str(sessionInfo["currentUserID"]))
            tupleCursor.execute(sql, val)
            db.commit()

        except mysql.connector.errors.IntegrityError as errorMsg:
            errorMsg = str(errorMsg)
            if 'email' in errorMsg.lower():
                updateEmailForm.email.errors.append('The email has already been linked to another account. Please use a different email.')
                flash("This email has already been linked to another account. Please use a different email.", "success")
        else:
            flash('Account successfully updated!', 'success')

            return redirect('/adminProfile/' + sessionInfo['username'])

    if request.method == "POST" and updateUsernameForm.validate():
        # password_hash = bcrypt.generate_password_hash(updateProfileForm.password.data).decode("utf8")
        # password = password_hash[7:]
        sql = "UPDATE user "
        sql += "SET Username=%s"
        sql += "WHERE UserID=%s"
        try:
            val = (updateUsernameForm.username.data, str(sessionInfo["currentUserID"]))
            tupleCursor.execute(sql, val)
            db.commit()

        except mysql.connector.errors.IntegrityError as errorMsg:
            errorMsg = str(errorMsg)
            if 'username' in errorMsg.lower():
                flash("This username is already taken!", "success")
                updateUsernameForm.username.errors.append('This username is already taken.')
        else:
            sql = "SELECT Username WHERE UserID=%s"
            val = (str(sessionInfo["currentUserID"]),)
            dictCursor.execute(sql, val)
            db.commit()
            sessionInfo['username'] = dictCursor['Username']
            sessions[sessionID] = sessionInfo
            flash('Account successfully updated! Your username now is %s.' %(sessionInfo['username']), 'success')
            return redirect('/adminProfile/' + sessionInfo['username'])

    if request.method == "POST" and updateStatusForm.validate():
        sql = "UPDATE user "
        sql += "SET Status=%s"
        sql += "WHERE UserID=%s"
        try:
            val = (updateStatusForm.status.data, str(sessionInfo["currentUserID"]))
            tupleCursor.execute(sql, val)
            db.commit()

        except mysql.connector.errors.IntegrityError as errorMsg:
            errorMsg = str(errorMsg)
            flash("An unexpected error has occurred!", "warning")
        else:
            flash('Account successfully updated!', 'success')

            return redirect('/adminProfile/' + sessionInfo['username'])


    return render_template("adminProfile.html", currentPage = "myProfile", **sessionInfo, userData = userData, recentPosts = recentPosts, admin=admin,
    updateEmailForm=updateEmailForm, updateUsernameForm=updateUsernameForm, updateStatusForm=updateStatusForm)



@app.route('/adminHome', methods=["GET", "POST"])
@admin_required
def adminHome():
    sessionInfo = sessions[sessionID]
    searchBarForm = Forms.SearchBarForm(request.form)
    searchBarForm.topic.choices = get_all_topics('all')
    if request.method == 'POST' and searchBarForm.validate():
        return redirect(url_for('searchPosts', searchQuery = searchBarForm.searchQuery.data, topic = searchBarForm.topic.data))

    sql = "SELECT post.PostID, post.Title, post.Content, post.Upvotes, post.Downvotes, post.DatetimePosted, user.Username,topic.TopicID, topic.Content AS Topic FROM post"
    sql += " INNER JOIN user ON post.UserID=user.UserID"
    sql += " INNER JOIN topic ON post.TopicID=topic.TopicID"
    sql += " ORDER BY post.PostID DESC LIMIT 6"

    dictCursor.execute(sql)
    recentPosts = dictCursor.fetchall()
    for post in recentPosts:
        post['TotalVotes'] = post['Upvotes'] - post['Downvotes']
        post['Content'] = post['Content'][:200]

    return render_template('adminHome.html', currentPage='adminHome', **sessionInfo, searchBarForm = searchBarForm,recentPosts = recentPosts)

@app.route('/adminViewPost/<int:postID>', methods=["GET", "POST"])
@admin_required
def adminViewPost(postID):
    sql = "SELECT post.Title, post.Content, post.Upvotes, post.Downvotes, post.DatetimePosted,post.TopicID,post.PostID, user.Username, topic.Content AS Topic FROM post"
    sql += " INNER JOIN user ON post.UserID=user.UserID"
    sql += " INNER JOIN topic ON post.TopicID=topic.TopicID"
    sql += " WHERE PostID=" + str(postID)
    dictCursor.execute(sql)
    post = dictCursor.fetchone()
    post['TotalVotes'] = post['Upvotes'] - post['Downvotes']

    sql = "SELECT comment.CommentID, comment.Content, comment.DatetimePosted, comment.Upvotes, comment.Downvotes, comment.DatetimePosted, user.Username FROM comment"
    sql += " INNER JOIN user ON comment.UserID=user.UserID"
    sql += " WHERE comment.PostID=" + str(postID)
    dictCursor.execute(sql)
    commentList = dictCursor.fetchall()
    for comment in commentList:
        comment['TotalVotes'] = comment['Upvotes'] - comment['Downvotes']

        sql = "SELECT reply.Content, reply.DatetimePosted, reply.DatetimePosted, user.Username FROM reply"
        sql += " INNER JOIN user ON reply.UserID=user.UserID"
        sql += " WHERE reply.CommentID=" + str(comment['CommentID'])
        dictCursor.execute(sql)
        replyList = dictCursor.fetchall()
        comment['ReplyList'] = replyList

    commentForm = Forms.CommentForm(request.form)
    commentForm.userID.data = sessionInfo['currentUserID']
    replyForm = Forms.ReplyForm(request.form)
    replyForm.userID.data = sessionInfo['currentUserID']

    if request.method == 'POST' and commentForm.validate():
        dateTime = datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')
        sql = 'INSERT INTO comment (PostID, UserID, Content, DateTimePosted, Upvotes, Downvotes) VALUES (%s, %s, %s, %s, %s, %s)'
        val = (postID, commentForm.userID.data, commentForm.comment.data, dateTime, 0, 0)
        tupleCursor.execute(sql, val)
        db.commit()
        flash('Comment posted!', 'success')
        return redirect('/adminViewPost/%d' %(postID))

    if request.method == 'POST' and replyForm.validate():
        dateTime = datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')
        sql = 'INSERT INTO reply (UserID, CommentID, Content, DateTimePosted) VALUES (%s, %s, %s, %s)'
        val = (replyForm.userID.data, replyForm.repliedID.data, replyForm.reply.data, dateTime)
        tupleCursor.execute(sql, val)
        db.commit()
        flash('Comment posted!', 'success')
        return redirect('/adminViewPost/%d' %(postID))

    return render_template('adminViewPost.html', currentPage='adminViewPost', **sessionInfo, post = post, commentList = commentList, commentForm=commentForm, replyForm=replyForm)

@app.route('/adminTopics')
@admin_required
def adminTopics():
    # uncomment from here
    sessionInfo  = sessions[sessionID]
    sql = "SELECT Content,TopicID FROM topic ORDER BY Content "
    tupleCursor.execute(sql)
    listOfTopics = tupleCursor.fetchall()
    return render_template('adminTopics.html', currentPage='adminTopics', **sessionInfo, listOfTopics=listOfTopics)

@app.route('/adminIndivTopic/<topicID>', methods=["GET", "POST"])
@admin_required
def adminIndivTopic(topicID):
    sessionInfo = sessions[sessionID]
    sql = "SELECT post.PostID, post.Title, post.Content, post.Upvotes, post.Downvotes, post.DatetimePosted, user.Username, topic.Content AS Topic FROM post"
    sql += " INNER JOIN user ON post.UserID=user.UserID"
    sql += " INNER JOIN topic ON post.TopicID=topic.TopicID"
    sql += " WHERE topic.TopicID = " + str(topicID)

    dictCursor.execute(sql)
    recentPosts = dictCursor.fetchall()
    for post in recentPosts:
        post['TotalVotes'] = post['Upvotes'] - post['Downvotes']
        post['Content'] = post['Content'][:200]
    topic = "SELECT Content FROM topic WHERE topic.TopicID=%s"
    val = (topicID,)
    tupleCursor.execute(topic, val)
    topic=tupleCursor.fetchone()
    return render_template('adminIndivTopic.html', currentPage='adminIndivTopic', **sessionInfo, recentPosts=recentPosts, topic=topic[0])

@app.route('/addTopic', methods=["GET", "POST"])
@admin_required
def addTopic():
    sessionInfo = sessions[sessionID]
    # uncomment here
    if not sessionInfo['login']:
        return redirect('/login')
    # til here
    sql = "SELECT Content FROM topic ORDER BY Content"

    tupleCursor.execute(sql)
    listOfTopics = tupleCursor.fetchall()

    topicForm = Forms.TopicForm(request.form)
    topicForm.topic.choices = listOfTopics
    # uncomment here
    if request.method == 'POST' and topicForm.validate():
        dateTime = datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')
        sql = 'INSERT INTO topic ( UserID, Content, DateTimePosted) VALUES ( %s,%s, %s)'
        val = (sessionInfo["currentUserID"],topicForm.topic.data, dateTime)
        tupleCursor.execute(sql, val)
        db.commit()
        flash('Topic successfully created!', 'success')
        return redirect('/adminHome')
        # till here


    return render_template('addTopic.html', currentPage='addTopic', **sessionInfo, topicForm=topicForm)

@app.route('/adminUsers')
@admin_required
def adminUsers():
    sessionInfo = sessions[sessionID]
    sql = "SELECT Username From user"
    tupleCursor.execute(sql)
    listOfUsernames = tupleCursor.fetchall()
    print(listOfUsernames)
    return render_template('adminUsers.html', currentPage='adminUsers', **sessionInfo, listOfUsernames = listOfUsernames)

@app.route('/adminDeleteUser/<username>', methods=['POST'])
@admin_required
def deleteUser(username):
    user_email = "SELECT Email FROM user WHERE user.username=%s"
    val = (username,)
    tupleCursor.execute(user_email, val)
    sql = "DELETE FROM user WHERE user.username=%s"
    val = (username,)
    tupleCursor.execute(sql, val)
    db.commit()
    try:
        msg = Message("Lorem Ipsum",
            sender="deloremipsumonlinestore@outlook.com",
            recipients=[user_email[0]])
        msg.body = "Your account has been terminated"
        msg.html = render_template('email.html', postID="delete user", username=username, content=0, posted=0)
        mail.send(msg)
        print("\n\n\nMAIL SENT\n\n\n")
    except Exception as e:
        print(e)
        print("Error:", sys.exc_info()[0])
        print("goes into except")

    return redirect('/adminUsers')

@app.route('/adminDeletePost/<int:postID>', methods=['POST', 'GET'])
@admin_required
def deletePost(postID):
    sql = "SELECT post.Content, post.DatetimePosted, post.postID, user.Username, user.email "
    sql += "FROM post"
    sql+= " INNER JOIN user ON post.UserID = user.UserID"
    sql += " WHERE post.PostID = %s"
    val = (postID,)
    dictCursor.execute(sql, val)
    email_info = dictCursor.fetchall()
    print(email_info)

    sql = "DELETE FROM post WHERE post.PostID=%s"
    val = (postID,)
    dictCursor.execute(sql, val)
    db.commit()
    # try:
    #     msg = Message("Lorem Ipsum",
    #         sender="deloremipsumonlinestore@outlook.com",
    #         recipients=[email_info[0]['email']])
    #     msg.body = "Your post has been deleted"
    #     for info in email_info:
    #         msg.html = render_template('email.html', postID=postID, username=info['Username'], content=info['Content'], posted=info['DatetimePosted'])
    #         mail.send(msg)
    #     print("\n\n\nMAIL SENT\n\n\n")
    # except Exception as e:
    #     print(e)
    #     print("Error:", sys.exc_info()[0])
    #     print("goes into except")

    return redirect('/adminHome')

@app.route('/adminFeedback')
@admin_required
def adminFeedback():
    sessionInfo = sessions[sessionID]
    sql = "SELECT feedback.Content, feedback.DatetimePosted, feedback.Reason,feedback.FeedbackID, user.Username, user.Email "
    sql += "FROM feedback"
    sql+= " INNER JOIN user ON feedback.UserID = user.UserID"
    sql += " WHERE feedback.Resolved = 0"
    dictCursor.execute(sql)
    feedbackList = dictCursor.fetchall()
    print(feedbackList)
    return render_template('adminFeedback.html', currentPage='adminFeedback', **sessionInfo, feedbackList=feedbackList)

@app.route('/replyFeedback/<feedbackID>',methods=["GET","POST"])
@admin_required
def replyFeedback(feedbackID):
    sessionInfo = sessions[sessionID]
    sql = "SELECT feedback.Content, feedback.DatetimePosted, feedback.Reason,feedback.FeedbackID, user.Username, user.Email "
    sql += "FROM feedback"
    sql+= " INNER JOIN user ON feedback.UserID = user.UserID"
    sql += " WHERE feedback.FeedbackID = %s"
    # sql += " AND feedback.Resolved = 0"
    val = (str(feedbackID),)
    dictCursor.execute(sql, val)
    feedbackList = dictCursor.fetchall()
    print(feedbackList)
    replyForm = Forms.ReplyFeedbackForm(request.form)
    # uncomment here
    if request.method == 'POST' and replyForm.validate():
        reply=replyForm.reply.data
        email=feedbackList[0]['Email']
        print(email)
        try:
            msg = Message("Lorem Ipsum",
                sender="deloremipsumonlinestore@outlook.com",
                recipients=[email])
            msg.body = "We love your feedback!"
            msg.html = render_template('email.html', postID="feedback reply", username=feedbackList[0]['Username'], content=feedbackList[0]['Content'], posted=feedbackList[0]['DatetimePosted'], reply=reply)
            mail.send(msg)
            print("\n\n\nMAIL SENT\n\n\n")
            # sql = "UPDATE feedback "
            # sql += "SET Resolved=1"
            # sql += "WHERE FeedbackID = " +str(feedbackID)
            # tupleCursor.execute(sql)
            # db.commit()

        except Exception as e:
            print(e)
            print("Error:", sys.exc_info()[0])
            print("goes into except")
        sql = "UPDATE feedback "
        sql += " SET Resolved=1"
        sql += " WHERE FeedbackID = %s"
        val = (str(feedbackID),)
        tupleCursor.execute(sql, val)
        db.commit()
        return redirect('/adminFeedback')
    return render_template('replyFeedback.html', currentPage='replyFeedback', **sessionInfo,replyForm=replyForm, feedbackList=feedbackList)

@app.route('/errorLog')
def errorLog():
    sql = "SELECT * FROM errorlog ORDER BY datetime DESC"
    dictCursor.execute(sql)
    log = dictCursor.fetchall()

    sql = "SELECT DISTINCT DATE(datetime) FROM errorlog ORDER BY DATE(datetime) DESC"
    dictCursor.execute(sql)
    dates = dictCursor.fetchall()

    data = {
        '401' : []
        , '403' : []
        , '404' : []
        , '500' : []
        , 'OTHERS' : []
    }

    listOfDates = []
    for x in range(7):
        dateToCheck = (date.today()-timedelta(x))
        listOfDates.append(dateToCheck)

        for error in ['401', '403', '404', '500', 'OTHERS']:
            sql = "SELECT COUNT(*) count FROM errorlog WHERE DATE(datetime)=%s AND errorCode=%s GROUP BY errorCode;"
            val = (dateToCheck, error)
            dictCursor.execute(sql, val)
            errorCount = dictCursor.fetchone()
            if errorCount==None:
                data[error].append(0)
            else:
                data[error].append(errorCount['count'])

    graph = {
            'data': [
                    go.Bar(name='Others', y=data['OTHERS'], x=listOfDates, marker_color='#ffb3f4', offsetgroup=0)
                    , go.Bar(name=500, y=data['500'], x=listOfDates, marker_color='#d1f082', offsetgroup=0)
                    , go.Bar(name=404, y=data['404'], x=listOfDates, marker_color='#c7ceea', offsetgroup=0)
                    , go.Bar(name=403, y=data['403'], x=listOfDates, marker_color='#ffdac1', offsetgroup=0)
                    , go.Bar(name=401, y=data['401'], x=listOfDates, marker_color='#ffb7b2', offsetgroup=0)
                    ]

            , 'layout': {}
            }

    errorGraph = json.dumps(graph, cls=plotly.utils.PlotlyJSONEncoder)

    return render_template('adminLog.html', currentPage='errorLog', **sessionInfo, log=log, errorGraph=errorGraph)

@app.errorhandler(400)
def error400(e):
    msg = 'Oops! We seem to have encountered an error. Head back to the home page :)'
    title = 'Error 400'
    return render_template('error.html', msg=msg, title=title)

@app.errorhandler(401)
def error401(e):
    msg = 'Erorr 401: Unauthorized'
    title = 'Unauthorized'
    return render_template('error.html', msg=msg, title=title)

@app.errorhandler(403)
def error403(e):
    msg = 'Oops! We seem to have encountered an error. Head back to the home page :)'
    title = 'Erorr 403'
    return render_template('error.html', msg=msg, title=title)

@app.errorhandler(404)
def error404(e):
    msg = 'Oops! Page not found. Head back to the home page'
    title= 'Error 404'
    createLog.log_error(request.path, 404, 'Page not found')
    admin = sessionInfo["isAdmin"]
    return render_template('error.html', msg=msg, admin=admin, title=title)

@app.errorhandler(408)
def error408(e):
    msg = 'Oops! We seem to have encountered an error. Head back to the home page :)'
    title = 'Error 408'
    return render_template('error.html', msg=msg, title=title)

@app.errorhandler(500)
def error500(e):
    msg = 'Oops! We seem to have encountered an error. Head back to the home page :)'
    createLog.log_error(request.path, 500, 'Internal Server Error')
    title = 'Error 500'
    admin = sessionInfo["isAdmin"]
    return render_template('error.html', msg=msg, admin=admin, title=title)

@app.errorhandler(501)
def error501(e):
    msg = 'Oops! We seem to have encountered an error. Head back to the home page :)'
    title = 'Error 501'
    return render_template('error.html', msg=msg, title=title)

@app.errorhandler(502)
def error502(e):
    msg = 'Oops! We seem to have encountered an error. Head back to the home page :)'
    title = 'Error 502'
    return render_template('error.html', msg=msg, title=title)

@app.errorhandler(503)
def error503(e):
    msg = 'Oops! We seem to have encountered an error. Head back to the home page :)'
    title = 'Error 503'
    return render_template('error.html', msg=msg, title=title)


@app.after_request
def after_request(response):
    response.headers['X-Content-Type-Options'] = 'NOSNIFF'
    response.headers["X-Frame-Options"] = "SAMEORIGIN"
    return response

if __name__ == "__main__":
    app.run(debug=False)
    # app.run(debug=True)
