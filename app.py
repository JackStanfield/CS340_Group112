from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
import os

app = Flask(__name__)

app.config['MYSQL_HOST'] = 'classmysql.engr.oregonstate.edu'
app.config['MYSQL_USER'] = 'cs340_albrecau'
app.config['MYSQL_PASSWORD'] = '1900'
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


<<<<<<< Updated upstream
@app.route("/spells")
def spells():
    return render_template("spells.j2")
=======
@app.route("/spells", methods=["GET", "POST"])
def spells():
    dbConnection = db.connectDB()
    try:
        # Handle Add Spell (Create)
        if request.method == "POST":
            spellName = request.form.get("spellName")
            castingInstruction = request.form.get("castingInstruction")
            chronicleID = request.form.get("chronicleID")

            query = "INSERT INTO Spells (spellName, castingInstruction, chronicleID) VALUES (%s, %s, %s)"
            db.query(dbConnection, query, (spellName, castingInstruction, chronicleID))
            return redirect("/spells")

        # Handle GET (Read)
        query1 = """
            SELECT
                s.spellID,
                s.spellName,
                s.castingInstruction,
                s.chronicleID,
                c.chronicleTitle
            FROM Spells s
            JOIN Chronicles c
                ON s.chronicleID = c.chronicleID
            ORDER BY s.spellID;
        """

        query2 = """
            SELECT chronicleID, chronicleTitle
            FROM Chronicles
            ORDER BY chronicleTitle;
        """

        spells = db.query(dbConnection, query1).fetchall()
        chronicles = db.query(dbConnection, query2).fetchall()

        return render_template("spells.j2", spells=spells, chronicles=chronicles)

    except Exception as e:
        print(f"Error executing queries for /spells: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()
>>>>>>> Stashed changes

@app.route("/delete-spell/<int:spellID>", methods=["POST"])
def delete_spell(spellID):
    dbConnection = db.connectDB()
    try:
        query = "DELETE FROM Spells WHERE spellID = %s"
        db.query(dbConnection, query, (spellID,))
        return redirect("/spells")
    except Exception as e:
        print(f"Error executing CUD operation: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()


@app.route("/categories")
def categories():
    return render_template("categories.j2")


<<<<<<< Updated upstream
@app.route("/spell-categories")
def spell_categories():
    return render_template("spell-categories.j2")

=======
@app.route("/spell-categories", methods=["GET", "POST"])
def spell_categories():
    dbConnection = db.connectDB()
    try:
        # Handle Add M:M Association (Create)
        if request.method == "POST":
            spellID = request.form.get("spellID")
            categoryID = request.form.get("categoryID")
            
            query = "INSERT INTO SpellCategories (spellID, categoryID) VALUES (%s, %s)"
            db.query(dbConnection, query, (spellID, categoryID))
            return redirect("/spell-categories")

        # Handle GET (Read)
        query1 = """
            SELECT
                sc.spellCategoryID,
                sc.spellID,
                s.spellName,
                sc.categoryID,
                c.categoryName
            FROM SpellCategories sc
            JOIN Spells s
                ON sc.spellID = s.spellID
            JOIN Categories c
                ON sc.categoryID = c.categoryID
            ORDER BY sc.spellCategoryID;
        """

        query2 = """
            SELECT spellID, spellName
            FROM Spells
            ORDER BY spellName;
        """

        query3 = """
            SELECT categoryID, categoryName
            FROM Categories
            ORDER BY categoryName;
        """

        spell_categories = db.query(dbConnection, query1).fetchall()
        spells = db.query(dbConnection, query2).fetchall()
        categories = db.query(dbConnection, query3).fetchall()

        return render_template(
            "spell-categories.j2",
            spell_categories=spell_categories,
            spells=spells,
            categories=categories
        )

    except Exception as e:
        print(f"Error executing queries for /spell-categories: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route("/delete-spell-category/<int:spellID>/<int:categoryID>", methods=["POST"])
def delete_spell_category(spellID, categoryID):
    dbConnection = db.connectDB()
    try:
        query = "DELETE FROM SpellCategories WHERE spellID = %s AND categoryID = %s"
        db.query(dbConnection, query, (spellID, categoryID))
        return redirect("/spell-categories")
    except Exception as e:
        print(f"Error executing CUD operation: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route("/reset-db", methods=["GET"])
def reset_db():
    try:
        dbConnection = db.connectDB()
        query = "CALL ResetDatabase();"
        db.query(dbConnection, query)
        return redirect("/")
    except Exception as e:
        print(f"Error resetting database: {e}")
        return "An error occurred while resetting the database.", 500
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route("/delete-demo", methods=["GET"])
def delete_demo():
    try:
        dbConnection = db.connectDB()
        query = "CALL DeleteDarkLord();"
        db.query(dbConnection, query)
        return redirect("/wizards")
    except Exception as e:
        print(f"Error executing CUD operation: {e}")
        return "An error occurred while executing the PL/SQL.", 500
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

# ########################################
# ########## LISTENER
>>>>>>> Stashed changes

# -------------------------
# Run server
# -------------------------
if __name__ == "__main__":
    port = int(os.environ.get('PORT', 1718))
    app.run(port=port, host='0.0.0.0', debug=True)