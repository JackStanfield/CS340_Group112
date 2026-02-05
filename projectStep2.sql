 -- Converted ER diagram to SQL and addition of sample data
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
START TRANSACTION;

--Use create or replace table statements
DROP TABLE IF EXISTS SpellCategories;
DROP TABLE IF EXISTS Spells;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Chronicles;
DROP TABLE IF EXISTS Wizards;


CREATE TABLE Wizards (
    wizardID INT AUTO_INCREMENT PRIMARY KEY,
    wizardName VARCHAR(255) NOT NULL,
    beardLength INT NULL,
    wizardAge INT NULL,
    masterID INT NULL,
    FOREIGN KEY (masterID) REFERENCES Wizards(wizardID)
);

CREATE TABLE Chronicles (
    chronicleID INT AUTO_INCREMENT PRIMARY KEY,
    chronicleTitle VARCHAR(255) UNIQUE NOT NULL,
    description TEXT NULL,
    publicationDate DATE NULL,
    wizardID INT NULL,
    FOREIGN KEY (wizardID) REFERENCES Wizards(wizardID)
);

CREATE TABLE Categories (
    categoryID INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Spells (
    spellID INT AUTO_INCREMENT PRIMARY KEY,
    spellName VARCHAR(255) UNIQUE NOT NULL,
    castingInstruction TEXT NULL,
    chronicleID INT NOT NULL,
    FOREIGN KEY (chronicleID) REFERENCES Chronicles(chronicleID)
);

CREATE TABLE SpellCategories (
    spellCategoryID INT AUTO_INCREMENT PRIMARY KEY,
    spellID INT NOT NULL,
    categoryID INT NOT NULL,
    UNIQUE(spellID, categoryID),
    FOREIGN KEY (spellID) REFERENCES Spells(spellID)
    on DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (categoryID) REFERENCES Categories(categoryID)
    on DELETE CASCADE ON UPDATE CASCADE
    );


INSERT INTO Wizards (wizardName, beardLength, wizardAge, masterID) VALUES
('Reginald Stringly', 12, 186, NULL),
('Hurckle', 15, 85, NULL),
('Merlin', 10, 630, NULL),
('The Dark Lord', 0, NULL, NULL),
('Gary Barton', 1, 20, 1),
('Nate Friendly', 0, 18, 1),
('Sam Washings', 0, 19, 1);

INSERT INTO Chronicles (chronicleTitle, description, publicationDate, wizardID) VALUES
('Ancient Text I', 'The oldest written collection of spells theorized to date back to the year 250. Text is crudely constructed, author is unknown.', NULL, NULL),
('Dark Arts Unveiled', 'An in-depth look into dark magic.', '1232-12-25', 4),
('Learning Wizardry: A Modern Approach', 'A fresh perspective on developing core competencies of wizarding from an up-and-coming young wizard.', '1635-01-20', 2);

    
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

INSERT INTO Spells (spellName, castingInstruction, chronicleID) VALUES
('Fireball', 'Raise your hand toward the target, fingers spread. Maintain focus and speak "fireball".', 1),
('Invisibility Cloak', 'Close your eyes and slowly trace an outline of your body.', 1),
('Healing Touch', 'Place both hands on the injured area and recite a healing incantation.', 3),
('Levitation', 'Perform a controlled upward sweeping motion with your hand while maintaining visual focus on the target.', 3),
('Dark Bind', 'Speak a harsh binding incantation and close your fist toward the target.', 2);

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