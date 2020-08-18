import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    user=os.environ["DB_USERNAME"],
    password=os.environ["DB_PASSWORD"],
    database="secureblogdb"
)

tupleCursor = db.cursor(buffered=True)
dictCursor = db.cursor(buffered=True, dictionary=True)

def log_error(route, errorCode, details):
    sql = 'INSERT INTO errorlog (route, errorCode, details) VALUES (%s, %s, %s)'
    val = (route, errorCode, details)
    tupleCursor.execute(sql, val)
    db.commit()

def log_user_activity(userID, username, activityCode):
    sql = 'INSERT INTO useractivitylog (UserID, username, activityCode) VALUES (%s, %s, %s)'
    val = (userID, username, activityCode)
    tupleCursor.execute(sql, val)
    db.commit()
