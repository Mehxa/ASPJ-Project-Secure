from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

# connection name = secureblogconn
db = mysql.connector.connect(
    host="localhost",
    user="secureASPJuser",
    password="P@ssw0rd",
    database="secureblogdb"
)

mycursor =db.cursor()
mycursor.execute("SHOW TABLES")
print(mycursor)

app = Flask(__name__)


@app.route("/", methods=["GET", "POST"])
def home():
    return render_template("home.html")


if __name__ == "__main__":
    app.run(debug=True)
