import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    user="ASPJuser",
    password="P@55w0rD",
    database="blogdb"
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
    sql += " WHERE UserID='" + userID + "'"
    sql += " AND PostID='" + postID + "'"
    tupleCursor.execute(sql)
    db.commit()

def update_post_vote(newVote, userID, postID):
    sql = "UPDATE post_votes SET"
    sql += " Vote='" + newVote + "'"
    sql += " WHERE UserID='" + userID + "'"
    sql += " AND PostID='" + postID + "'"
    tupleCursor.execute(sql)
    db.commit()

def update_overall_post_vote(upvoteChange, downvoteChange, postID):
    sql = "UPDATE post SET"
    sql += " Upvotes= Upvotes + " + upvoteChange
    sql += ", Downvotes= Downvotes + " + downvoteChange
    sql += " WHERE PostID='" + postID + "'"
    tupleCursor.execute(sql)
    db.commit()

def calculate_updated_post_votes(postID):
    sql = "SELECT Upvotes, Downvotes FROM post"
    sql += " WHERE PostID='" + postID + "'"
    dictCursor.execute(sql)
    postVotes = dictCursor.fetchone()
    db.commit()
    return postVotes['Upvotes'] - postVotes['Downvotes']

def get_user_vote(userID, postID):
    sql = "SELECT Vote FROM post_votes WHERE "
    sql += " UserID = '" + userID + "'"
    sql += " AND PostID = '" + postID + "'"
    dictCursor.execute(sql)
    currentVote = dictCursor.fetchone()
    return currentVote
