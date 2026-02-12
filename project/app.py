from flask import Flask, render_template

app = Flask(__name__)

PORT = 10201


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
    app.run(port=PORT, debug=True)
