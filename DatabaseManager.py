import mysql.connector
import os

db = mysql.connector.connect(
    host="localhost",
    user=os.environ["DB_USERNAME"],
    password=os.environ["DB_PASSWORD"],
    database="secureblogdb"
)

tupleCursor = db.cursor(buffered=True)
dictCursor = db.cursor(buffered=True, dictionary=True)

def insert_post_vote(userID, postID, vote):
    sql = 'INSERT INTO post_votes (UserID, PostID, Vote) VALUES (%s, %s, %s)'
    val = (userID, postID, vote)
    tupleCursor.execute(sql, val)
    db.commit()

def delete_post_vote(userID, postID):
    sql = "DELETE FROM post_votes"
    sql += " WHERE UserID=%s AND PostID=%s"
    val = (userID, postID)
    tupleCursor.execute(sql, val)
    db.commit()

def update_post_vote(newVote, userID, postID):
    sql = "UPDATE post_votes SET"
    sql += " Vote=%s"
    sql += " WHERE UserID=%s AND PostID=%s"
    val = (newVote, userID, postID)
    tupleCursor.execute(sql, val)
    db.commit()

def update_overall_post_vote(upvoteChange, downvoteChange, postID):
    sql = "UPDATE post SET"
    sql += " Upvotes= Upvotes + %s"
    sql += ", Downvotes= Downvotes + %s"
    sql += " WHERE PostID=%s"
    val = (upvoteChange, downvoteChange, postID)
    tupleCursor.execute(sql, val)
    db.commit()

def calculate_updated_post_votes(postID):
    sql = "SELECT Upvotes, Downvotes FROM post"
    sql += " WHERE PostID=%s"
    val = (postID,)
    dictCursor.execute(sql, val)
    postVotes = dictCursor.fetchone()
    db.commit()
    return postVotes['Upvotes'] - postVotes['Downvotes']

def get_user_vote(userID, postID):
    sql = "SELECT Vote FROM post_votes WHERE "
    sql += " UserID = %s"
    sql += " AND PostID = %s"
    val = (userID, postID)
    dictCursor.execute(sql, val)
    currentVote = dictCursor.fetchone()
    return currentVote

# Comments
def insert_comment_vote(userID, commentID, vote):
    sql = 'INSERT INTO comment_votes (UserID, CommentID, Vote) VALUES'
    sql += " (%s, %s, %s)"
    val = (userID, commentID, vote)
    tupleCursor.execute(sql, val)
    db.commit()

def delete_comment_vote(userID, commentID):
    sql = "DELETE FROM comment_votes"
    sql += " WHERE UserID=%s"
    sql += " AND CommentID=%s"
    val = (userID, commentID)
    tupleCursor.execute(sql, val)
    db.commit()

def update_comment_vote(newVote, userID, commentID):
    sql = "UPDATE comment_votes SET"
    sql += " Vote=%s"
    sql += " WHERE UserID=%s"
    sql += " AND CommentID=%s"
    val = (newVote, userID, commentID)
    tupleCursor.execute(sql, val)
    db.commit()

def update_overall_comment_vote(upvoteChange, downvoteChange, commentID):
    sql = "UPDATE comment SET"
    sql += " Upvotes= Upvotes + %s"
    sql += ", Downvotes= Downvotes + %s"
    sql += " WHERE CommentID=%s"
    val = (upvoteChange, downvoteChange, commentID)
    tupleCursor.execute(sql, val)
    db.commit()

def calculate_updated_comment_votes(commentID):
    sql = "SELECT Upvotes, Downvotes FROM comment"
    sql += " WHERE CommentID=%s"
    val = (commentID,)
    dictCursor.execute(sql, val)
    commentVotes = dictCursor.fetchone()
    db.commit()
    return commentVotes['Upvotes'] - commentVotes['Downvotes']

def get_user_comment_vote(userID, commentID):
    sql = "SELECT Vote FROM comment_votes WHERE "
    sql += " UserID = %s"
    sql += " AND CommentID = %s"
    val = (userID, commentID)
    dictCursor.execute(sql, val)
    currentVote = dictCursor.fetchone()
    return currentVote
