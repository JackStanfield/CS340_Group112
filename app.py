# Citation for this file:
# Originality: Adapted from CS340 Flask Starter App.
# Scope: Flask server routes and database execution.

from flask import Flask, render_template, request, redirect
import os
import database.db_connector as db

app = Flask(__name__)

@app.route("/", methods=["GET"])
def home():
    try:
        return render_template("home.j2")
    except Exception as e:
        print(f"Error rendering page: {e}")
        return "An error occurred while rendering the page.", 500

@app.route("/wizards", methods=["GET"])
def wizards():
    try:
        dbConnection = db.connectDB()
        query1 = """
            SELECT w.wizardID, w.wizardName, w.beardLengthCm, w.wizardAge, m.wizardName AS masterName
            FROM Wizards w LEFT JOIN Wizards m ON w.masterID = m.wizardID ORDER BY w.wizardID;
        """
        query2 = "SELECT wizardID, wizardName FROM Wizards ORDER BY wizardName;"
        wizards = db.query(dbConnection, query1).fetchall()
        masters = db.query(dbConnection, query2).fetchall()
        return render_template("wizards.j2", wizards=wizards, masters=masters)
    except Exception as e:
        print(f"Error executing queries for /wizards: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection: dbConnection.close()

@app.route("/chronicles", methods=["GET"])
def chronicles():
    try:
        dbConnection = db.connectDB()
        query1 = """
            SELECT c.chronicleID, c.chronicleTitle, c.description, c.publicationDate, c.wizardID, w.wizardName
            FROM Chronicles c LEFT JOIN Wizards w ON c.wizardID = w.wizardID ORDER BY c.chronicleID;
        """
        query2 = "SELECT wizardID, wizardName FROM Wizards ORDER BY wizardName;"
        chronicles = db.query(dbConnection, query1).fetchall()
        wizards = db.query(dbConnection, query2).fetchall()
        return render_template("chronicles.j2", chronicles=chronicles, wizards=wizards)
    except Exception as e:
        print(f"Error executing queries for /chronicles: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection: dbConnection.close()

@app.route("/spells", methods=["GET", "POST"])
def spells():
    dbConnection = db.connectDB()
    try:
        if request.method == "POST":
            spellName = request.form.get("spellName")
            castingInstruction = request.form.get("castingInstruction")
            chronicleID = request.form.get("chronicleID")

            # Executing Stored Procedure for CREATE
            query = "CALL AddSpell(%s, %s, %s)"
            db.query(dbConnection, query, (spellName, castingInstruction, chronicleID))
            return redirect("/spells")

        query1 = """
            SELECT s.spellID, s.spellName, s.castingInstruction, s.chronicleID, c.chronicleTitle
            FROM Spells s JOIN Chronicles c ON s.chronicleID = c.chronicleID ORDER BY s.spellID;
        """
        query2 = "SELECT chronicleID, chronicleTitle FROM Chronicles ORDER BY chronicleTitle;"
        spells = db.query(dbConnection, query1).fetchall()
        chronicles = db.query(dbConnection, query2).fetchall()
        return render_template("spells.j2", spells=spells, chronicles=chronicles)
    except Exception as e:
        print(f"Error executing queries for /spells: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection: dbConnection.close()

@app.route("/delete-spell/<int:spellID>", methods=["POST"])
def delete_spell(spellID):
    dbConnection = db.connectDB()
    try:
        # Executing Stored Procedure for DELETE
        query = "CALL DeleteSpell(%s)"
        db.query(dbConnection, query, (spellID,))
        return redirect("/spells")
    except Exception as e:
        print(f"Error executing CUD operation: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection: dbConnection.close()

@app.route("/categories", methods=["GET"])
def categories():
    try:
        dbConnection = db.connectDB()
        query1 = "SELECT categoryID, categoryName FROM Categories ORDER BY categoryID;"
        categories = db.query(dbConnection, query1).fetchall()
        return render_template("categories.j2", categories=categories)
    except Exception as e:
        print(f"Error executing queries for /categories: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection: dbConnection.close()

@app.route("/spell-categories", methods=["GET", "POST"])
def spell_categories():
    dbConnection = db.connectDB()
    try:
        if request.method == "POST":
            spellID = request.form.get("spellID")
            categoryID = request.form.get("categoryID")
            
            # Executing Stored Procedure for CREATE M:N
            query = "CALL AddSpellCategory(%s, %s)"
            db.query(dbConnection, query, (spellID, categoryID))
            return redirect("/spell-categories")

        query1 = """
            SELECT sc.spellCategoryID, sc.spellID, s.spellName, sc.categoryID, c.categoryName
            FROM SpellCategories sc
            JOIN Spells s ON sc.spellID = s.spellID
            JOIN Categories c ON sc.categoryID = c.categoryID ORDER BY sc.spellCategoryID;
        """
        query2 = "SELECT spellID, spellName FROM Spells ORDER BY spellName;"
        query3 = "SELECT categoryID, categoryName FROM Categories ORDER BY categoryName;"

        spell_categories = db.query(dbConnection, query1).fetchall()
        spells = db.query(dbConnection, query2).fetchall()
        categories = db.query(dbConnection, query3).fetchall()

        return render_template("spell-categories.j2", spell_categories=spell_categories, spells=spells, categories=categories)
    except Exception as e:
        print(f"Error executing queries for /spell-categories: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection: dbConnection.close()

@app.route("/update-spell-category", methods=["POST"])
def update_spell_category():
    dbConnection = db.connectDB()
    try:
        spellCategoryID = request.form.get("spellCategoryID")
        spellID = request.form.get("spellID")
        categoryID = request.form.get("categoryID")
        
        # Executing Stored Procedure for UPDATE M:N
        query = "CALL UpdateSpellCategory(%s, %s, %s)"
        db.query(dbConnection, query, (spellCategoryID, spellID, categoryID))
        return redirect("/spell-categories")
    except Exception as e:
        print(f"Error executing Update M:N: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection: dbConnection.close()

@app.route("/delete-spell-category/<int:spellID>/<int:categoryID>", methods=["POST"])
def delete_spell_category(spellID, categoryID):
    dbConnection = db.connectDB()
    try:
        # Executing Stored Procedure for DELETE M:N
        query = "CALL DeleteSpellCategory(%s, %s)"
        db.query(dbConnection, query, (spellID, categoryID))
        return redirect("/spell-categories")
    except Exception as e:
        print(f"Error executing CUD operation: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection: dbConnection.close()

@app.route("/reset-db", methods=["GET"])
def reset_db():
    try:
        dbConnection = db.connectDB()
        query = "CALL ResetDatabase();"
        db.query(dbConnection, query)
        return redirect("/")
    except Exception as e:
        print(f"Error resetting database: {e}")
        return "An error occurred.", 500
    finally:
        if "dbConnection" in locals() and dbConnection: dbConnection.close()

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 1718))
    app.run(port=port, host="0.0.0.0", debug=True)