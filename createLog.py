import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    user="secureASPJuser",
    password="P@ssw0rd",
    database="secureblogdb"
)

tupleCursor = db.cursor(buffered=True)
dictCursor = db.cursor(buffered=True, dictionary=True)

def log_error(route, errorCode, details):
    sql = 'INSERT INTO errorlog (route, errorCode, details) VALUES (%s, %s, %s)'
    val = (route, errorCode, details)
    tupleCursor.execute(sql, val)
    db.commit()
