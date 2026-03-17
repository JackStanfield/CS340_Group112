-- Citation for this file:
-- Originality: Entirely original work based on project schema. Subquery syntax applied based on rubric requirements mainly.
-- Scope: Database definition and sample data population.

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
START TRANSACTION;

DROP TABLE IF EXISTS SpellCategories;
DROP TABLE IF EXISTS Spells;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Chronicles;
DROP TABLE IF EXISTS Wizards;

CREATE TABLE Wizards (
    wizardID INT(11) AUTO_INCREMENT UNIQUE PRIMARY KEY,
    wizardName VARCHAR(255) NOT NULL,
    beardLengthCm INT(11) NULL,
    wizardAge INT(11) NULL,
    masterID INT(11) NULL,
    FOREIGN KEY (masterID) REFERENCES Wizards(wizardID) ON DELETE SET NULL
);

CREATE TABLE Chronicles (
    chronicleID INT(11) AUTO_INCREMENT UNIQUE PRIMARY KEY,
    chronicleTitle VARCHAR(255) UNIQUE NOT NULL,
    description TEXT NULL,
    publicationDate DATE NULL,
    wizardID INT(11) NULL,
    FOREIGN KEY (wizardID) REFERENCES Wizards(wizardID) ON DELETE SET NULL
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
    FOREIGN KEY (chronicleID) REFERENCES Chronicles(chronicleID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SpellCategories (
    spellCategoryID INT AUTO_INCREMENT UNIQUE PRIMARY KEY,
    spellID INT(11) NOT NULL,
    categoryID INT(11) NOT NULL,
    UNIQUE(spellID, categoryID),
    FOREIGN KEY (spellID) REFERENCES Spells(spellID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (categoryID) REFERENCES Categories(categoryID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- This is For Populating Sample Data Using Subqueries
INSERT INTO Wizards (wizardName, beardLengthCm, wizardAge, masterID) VALUES 
('Reginald Stringly', 12, 186, NULL), 
('Hurckle', 15, 85, NULL), 
('Merlin', 10, 630, NULL), 
('The Dark Lord', 0, NULL, NULL);

INSERT INTO Chronicles (chronicleTitle, description, publicationDate, wizardID) VALUES 
('Ancient Text I', 'The oldest written collection of spells...', NULL, NULL), 
('Dark Arts Unveiled', 'An in-depth look into dark magic.', '1232-12-25', (SELECT wizardID FROM Wizards WHERE wizardName = 'The Dark Lord'));

INSERT INTO Categories (categoryName) VALUES 
('Transfiguration'), 
('Dark Arts'), 
('Healing'), 
('Elemental Magic');

INSERT INTO Spells (spellName, castingInstruction, chronicleID) VALUES 
('Fireball', 'Raise your hand toward the target...', (SELECT chronicleID FROM Chronicles WHERE chronicleTitle = 'Ancient Text I')), 
('Dark Bind', 'Speak a harsh binding incantation...', (SELECT chronicleID FROM Chronicles WHERE chronicleTitle = 'Dark Arts Unveiled'));

INSERT INTO SpellCategories (spellID, categoryID) VALUES 
((SELECT spellID FROM Spells WHERE spellName = 'Fireball'), (SELECT categoryID FROM Categories WHERE categoryName = 'Elemental Magic')), 
((SELECT spellID FROM Spells WHERE spellName = 'Dark Bind'), (SELECT categoryID FROM Categories WHERE categoryName = 'Dark Arts'));

COMMIT;
SET FOREIGN_KEY_CHECKS=1;