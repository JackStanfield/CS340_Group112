# ########################################
# ########## SETUP

from flask import Flask, render_template, request, redirect
import os
import database.db_connector as db

app = Flask(__name__)

# ########################################
# ########## ROUTE HANDLERS

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
            SELECT
                w.wizardID,
                w.wizardName,
                w.beardLengthCm,
                w.wizardAge,
                m.wizardName AS masterName
            FROM Wizards w
            LEFT JOIN Wizards m
                ON w.masterID = m.wizardID
            ORDER BY w.wizardID;
        """

        query2 = """
            SELECT wizardID, wizardName
            FROM Wizards
            ORDER BY wizardName;
        """

        wizards = db.query(dbConnection, query1).fetchall()
        masters = db.query(dbConnection, query2).fetchall()

        return render_template("wizards.j2", wizards=wizards, masters=masters)

    except Exception as e:
        print(f"Error executing queries for /wizards: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()


@app.route("/chronicles", methods=["GET"])
def chronicles():
    try:
        dbConnection = db.connectDB()

        query1 = """
            SELECT
                c.chronicleID,
                c.chronicleTitle,
                c.description,
                c.publicationDate,
                c.wizardID,
                w.wizardName
            FROM Chronicles c
            LEFT JOIN Wizards w
                ON c.wizardID = w.wizardID
            ORDER BY c.chronicleID;
        """

        query2 = """
            SELECT wizardID, wizardName
            FROM Wizards
            ORDER BY wizardName;
        """

        chronicles = db.query(dbConnection, query1).fetchall()
        wizards = db.query(dbConnection, query2).fetchall()

        return render_template("chronicles.j2", chronicles=chronicles, wizards=wizards)

    except Exception as e:
        print(f"Error executing queries for /chronicles: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()


@app.route("/spells", methods=["GET"])
def spells():
    try:
        dbConnection = db.connectDB()

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


@app.route("/categories", methods=["GET"])
def categories():
    try:
        dbConnection = db.connectDB()

        query1 = """
            SELECT categoryID, categoryName
            FROM Categories
            ORDER BY categoryID;
        """

        categories = db.query(dbConnection, query1).fetchall()

        return render_template("categories.j2", categories=categories)

    except Exception as e:
        print(f"Error executing queries for /categories: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()


@app.route("/spell-categories", methods=["GET"])
def spell_categories():
    try:
        dbConnection = db.connectDB()

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


# ########################################
# ########## LISTENER

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 1717))
    app.run(port=port, host="0.0.0.0", debug=True)