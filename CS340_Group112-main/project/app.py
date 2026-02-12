from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
import os

app = Flask(__name__)

app.config['MYSQL_HOST'] = 'classmysql.engr.oregonstate.edu'
app.config['MYSQL_USER'] = 'cs340_albrecau'
app.config['MYSQL_PASSWORD'] = 'yourdbpassword'
app.config['MYSQL_DB'] = 'cs340_albrecau'
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql = MySQL(app)

# -------------------------
# Home
# -------------------------
@app.route("/")
def home():
    return render_template("home.j2")


# -------------------------
# Wizards page
# -------------------------
@app.route("/wizards")
def wizards():
    return render_template("wizards.j2")


# -------------------------
# Other pages (placeholders)
# -------------------------
@app.route("/chronicles")
def chronicles():
    return render_template("chronicles.j2")


@app.route("/spells")
def spells():
    return render_template("spells.j2")


@app.route("/categories")
def categories():
    return render_template("categories.j2")


@app.route("/spell-categories")
def spell_categories():
    return render_template("spell-categories.j2")


# -------------------------
# Run server
# -------------------------
if __name__ == "__main__":
    port = int(os.environ.get('PORT', 10201))
    app.run(port=port, debug=True)