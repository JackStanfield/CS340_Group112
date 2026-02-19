 -- Converted ER diagram to SQL and addition of sample data
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
--Use create or replace table statements
DROP TABLE IF EXISTS Wizards;
DROP TABLE IF EXISTS Chronicles;
DROP TABLE IF EXISTS Spells;
DROP TABLE IF EXISTS SpellCategories;
DROP TABLE IF EXISTS Categories;

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
    Descirpition TEXT NULL,
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


--I dont have to add ID's but for clarity sake I do
INSERT INTO Wizards (wizardName, beardLength, wizardAge, masterID) VALUES
(1,'Reginald Stringly', 12 , 186 , NULL),
(2,'Hurckle', 15 , 85 , NULL),
(3,'Merlin', 10 , 630 , NULL),
(4,'The Dark Lord', 0, NULL, NULL),
(5,'Gary Barton', 1 , 20 , 1),
(6,'Nate Friendly', 0, 18 , 1),
(7,'Sam Washings', 0, 19 , 1);

INSERT INTO Chronicles (chronicleTitle, Descirpition, publicationDate, wizardID) VALUES
(1,'Ancient Text I', 'The oldest written collection of spells theorized to
    date back to the year 250. Text is crudely constructed, Author is Unkown.', NULL , NULL),
(2,'Dark Arts Unveiled', 'An in-depth look into dark magic.', '1232-12-25', 4),
(3,'Learning Wizardy: A Modern Approach', 'A fresh perspective on 
    developing core competencies of all things wizarding from an 
    up and coming young wizard.', '1635-01-20', 2);
    
INSERT INTO Categories (categoryName) VALUES
(1,'Transfiguration'),
(2,'Dark Arts'),
(3,'Healing'),
(4,'Elemental Magic'),
(5,'Charms'),
(6,'Verbal')
(7,'Non-Verbal');
(8,'Defensive Magic');
(9,'Offensive Magic');
(10,"Somantic Cast")


INSERT INTO Spells (spellName, castingInstruction, chronicleID) VALUES
(1,'Fireball', '', 1),
(2,'Invisibility Cloak', '".', 1),
(3,'Healing Touch', '".', 3),
(4,'Levitation', '.', 3),
(5,'Dark Bind', '".', 2);



SET FOREIGN_KEY_CHECKS=1;
COMMIT;