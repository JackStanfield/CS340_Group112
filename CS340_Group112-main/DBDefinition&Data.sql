--Group 112
--Members: John Stanfield, Austin Albrecht
 

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
START TRANSACTION;

--Use create or replace table statements
DROP TABLE IF EXISTS SpellCategories;
DROP TABLE IF EXISTS Spells;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Chronicles;
DROP TABLE IF EXISTS Wizards;

--Create Tables in order of dependencies
CREATE TABLE Wizards (
    wizardID INT(11) AUTO_INCREMENT UNIQUE PRIMARY KEY,
    wizardName VARCHAR(255) NOT NULL,
    beardLengthCm INT(11) NULL,
    wizardAge INT(11) NULL,
    masterID INT(11) NULL,
    FOREIGN KEY (masterID) REFERENCES Wizards(wizardID)
);

CREATE TABLE Chronicles (
    chronicleID INT(11) AUTO_INCREMENT UNIQUE PRIMARY KEY,
    chronicleTitle VARCHAR(255) UNIQUE NOT NULL,
    description TEXT NULL,
    publicationDate DATE NULL,
    wizardID INT(11) NULL,
    FOREIGN KEY (wizardID) REFERENCES Wizards(wizardID)
);

CREATE TABLE Categories (
    categoryID INT(11) AUTO_INCREMENT UNIQUE PRIMARY KEY,
    categoryName VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Spells (
    spellID INT(11) AUTO_INCREMENT UNIQUE PRIMARY KEY,
    spellName VARCHAR(255) UNIQUE NOT NULL,
    castingInstruction TEXT NULL,
    chronicleID INT(11) NOT NULL,
    FOREIGN KEY (chronicleID) REFERENCES Chronicles(chronicleID)
    ON DELETE CASCADE ON UPDATE CASCADE
);
--The order of spell and categories table creation doesn't matter
--SpellCategories must come after both though

CREATE TABLE SpellCategories (
    spellCategoryID INT AUTO_INCREMENT UNIQUE PRIMARY KEY,
    spellID INT(11) NOT NULL,
    categoryID INT(11) NOT NULL,
    UNIQUE(spellID, categoryID),
    FOREIGN KEY (spellID) REFERENCES Spells(spellID)
    on DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (categoryID) REFERENCES Categories(categoryID)
    on DELETE CASCADE ON UPDATE CASCADE
    );

--Wizard entries, some with no master (NULL)
INSERT INTO Wizards (wizardName, beardLengthCm , wizardAge, masterID) VALUES
('Reginald Stringly', 12, 186, NULL),
('Hurckle', 15, 85, NULL),
('Merlin', 10, 630, NULL),
('The Dark Lord', 0, NULL, NULL),
('Gary Barton', 1, 20, 1),
('Nate Friendly', 0, 18, 1),
('Sam Washings', 0, 19, 1);

--The chroncile Ancient Text I has no known author (NULL wizardID)
INSERT INTO Chronicles (chronicleTitle, description, publicationDate, wizardID) VALUES
('Ancient Text I', 'The oldest written collection of spells theorized to date back to the year 250. Text is crudely constructed, author is unknown.', NULL, NULL),
('Dark Arts Unveiled', 'An in-depth look into dark magic.', '1232-12-25', 4),
('Learning Wizardry: A Modern Approach', 'A fresh perspective on developing core competencies of wizarding from an up-and-coming young wizard.', '1635-01-20', 2);

--Categories of spells, assigned ID's 1-10 automatically through AUTO_INCREMENT
--This order is used for reference when linking spells to categories below
INSERT INTO Categories (categoryName) VALUES
('Transfiguration'),
('Dark Arts'),
('Healing'),
('Elemental Magic'),
('Charms'),
('Verbal'),
('Non-Verbal'),
('Defensive Magic'),
('Offensive Magic'),
('Somatic Cast');

--Spells entries linked to chronicles through chronicle ID, which is auto-incremented
--and order is used to link to categories below
INSERT INTO Spells (spellName, castingInstruction, chronicleID) VALUES
('Fireball', 'Raise your hand toward the target, fingers spread. Maintain focus and speak "fireball".', 1),
('Invisibility Cloak', 'Close your eyes and slowly trace an outline of your body.', 1),
('Healing Touch', 'Place both hands on the injured area and recite a healing incantation.', 3),
('Levitation', 'Perform a controlled upward sweeping motion with your hand while maintaining visual focus on the target.', 3),
('Dark Bind', 'Speak a harsh binding incantation and close your fist toward the target.', 2);

--Link Spells to Categories, a spell can have multiple categories 
--and a category can have multiple spells
INSERT INTO SpellCategories (spellID, categoryID) VALUES
(1,4),
(1,9),
(1,10),
(1,6),
(2,1),
(2,7),
(2,10),
(3,3),
(3,5),
(3,6),
(4,5),
(4,10),
(5,2),
(5,9),
(5,10),
(5,6);

COMMIT;
SET FOREIGN_KEY_CHECKS=1;

--Test code to get all categories the fireball spell is apart of
--SELECT Categories.categoryName, Spells.spellName 
--FROM SpellCategories
--JOIN Spells ON SpellCategories.spellID = Spells.spellID 
--JOIN Categories ON Categories.categoryID = SpellCategories.categoryID WHERE Spells.spellName = "Fireball";