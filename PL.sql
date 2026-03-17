-- Citations:
-- Originality: Adapted from CS340 starter code.
-- Scope: All stored procedures used for CUD and Reset operations.

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

DROP PROCEDURE IF EXISTS ResetDatabase;
DROP PROCEDURE IF EXISTS AddSpell;
DROP PROCEDURE IF EXISTS DeleteSpell;
DROP PROCEDURE IF EXISTS AddSpellCategory;
DROP PROCEDURE IF EXISTS UpdateSpellCategory;
DROP PROCEDURE IF EXISTS DeleteSpellCategory;

DELIMITER //

-- 1. RESET DB PROCEDURE
CREATE PROCEDURE ResetDatabase()
BEGIN
    DROP TABLE IF EXISTS SpellCategories;
    DROP TABLE IF EXISTS Spells;
    DROP TABLE IF EXISTS Categories;
    DROP TABLE IF EXISTS Chronicles;
    DROP TABLE IF EXISTS Wizards;

    CREATE TABLE Wizards (
        wizardID INT(11) AUTO_INCREMENT PRIMARY KEY,
        wizardName VARCHAR(255) NOT NULL,
        beardLengthCm INT(11) NULL,
        wizardAge INT(11) NULL,
        masterID INT(11) NULL,
        FOREIGN KEY (masterID) REFERENCES Wizards(wizardID) ON DELETE SET NULL
    );

    CREATE TABLE Chronicles (
        chronicleID INT(11) AUTO_INCREMENT PRIMARY KEY,
        chronicleTitle VARCHAR(255) UNIQUE NOT NULL,
        description TEXT NULL,
        publicationDate DATE NULL,
        wizardID INT(11) NULL,
        FOREIGN KEY (wizardID) REFERENCES Wizards(wizardID) ON DELETE SET NULL
    );

    CREATE TABLE Categories (
        categoryID INT(11) AUTO_INCREMENT PRIMARY KEY,
        categoryName VARCHAR(255) UNIQUE NOT NULL
    );

    CREATE TABLE Spells (
        spellID INT(11) AUTO_INCREMENT PRIMARY KEY,
        spellName VARCHAR(255) UNIQUE NOT NULL,
        castingInstruction TEXT NULL,
        chronicleID INT(11) NOT NULL,
        FOREIGN KEY (chronicleID) REFERENCES Chronicles(chronicleID) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE SpellCategories (
        spellCategoryID INT AUTO_INCREMENT PRIMARY KEY,
        spellID INT(11) NOT NULL,
        categoryID INT(11) NOT NULL,
        UNIQUE(spellID, categoryID),
        FOREIGN KEY (spellID) REFERENCES Spells(spellID) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (categoryID) REFERENCES Categories(categoryID) ON DELETE CASCADE ON UPDATE CASCADE
    );

    INSERT INTO Wizards (wizardName, beardLengthCm, wizardAge, masterID) VALUES ('Reginald Stringly', 12, 186, NULL), ('Hurckle', 15, 85, NULL), ('Merlin', 10, 630, NULL), ('The Dark Lord', 0, NULL, NULL);
    INSERT INTO Chronicles (chronicleTitle, description, publicationDate, wizardID) VALUES ('Ancient Text I', 'The oldest written collection of spells...', NULL, NULL), ('Dark Arts Unveiled', 'An in-depth look into dark magic.', '1232-12-25', 4);
    INSERT INTO Categories (categoryName) VALUES ('Transfiguration'), ('Dark Arts'), ('Healing'), ('Elemental Magic');
    INSERT INTO Spells (spellName, castingInstruction, chronicleID) VALUES ('Fireball', 'Raise your hand toward the target...', 1), ('Dark Bind', 'Speak a harsh binding incantation...', 2);
    INSERT INTO SpellCategories (spellID, categoryID) VALUES (1,4), (2,2);
END //

-- 2. CREATE PROCEDURES
CREATE PROCEDURE AddSpell(IN p_spellName VARCHAR(255), IN p_castingInstruction TEXT, IN p_chronicleID INT)
BEGIN
    INSERT INTO Spells (spellName, castingInstruction, chronicleID) 
    VALUES (p_spellName, p_castingInstruction, p_chronicleID);
END //

CREATE PROCEDURE AddSpellCategory(IN p_spellID INT, IN p_categoryID INT)
BEGIN
    INSERT INTO SpellCategories (spellID, categoryID) VALUES (p_spellID, p_categoryID);
END //

-- 3. UPDATE PROCEDURE (M:N)
CREATE PROCEDURE UpdateSpellCategory(IN p_spellCategoryID INT, IN p_spellID INT, IN p_categoryID INT)
BEGIN
    UPDATE SpellCategories 
    SET spellID = p_spellID, categoryID = p_categoryID 
    WHERE spellCategoryID = p_spellCategoryID;
END //

-- 4. DELETE PROCEDURES
CREATE PROCEDURE DeleteSpell(IN p_spellID INT)
BEGIN
    DELETE FROM Spells WHERE spellID = p_spellID;
END //

CREATE PROCEDURE DeleteSpellCategory(IN p_spellID INT, IN p_categoryID INT)
BEGIN
    DELETE FROM SpellCategories WHERE spellID = p_spellID AND categoryID = p_categoryID;
END //

DELIMITER ;
COMMIT;
SET FOREIGN_KEY_CHECKS=1;