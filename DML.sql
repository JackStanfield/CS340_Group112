-- Wizards: Get all Wizards with a self-join to show the mentor's name
SELECT w1.wizardID, w1.wizardName, w1.beardLengthCm, w1.wizardAge, w2.wizardName AS mentorName 
FROM Wizards w1 
LEFT JOIN Wizards w2 ON w1.masterID = w2.wizardID;

-- Wizards: Create (masterID chosen via dropdown, can be NULL)
INSERT INTO Wizards (wizardName, beardLengthCm, wizardAge, masterID)
VALUES (:wizardNameInput, :beardLengthInput, :wizardAgeInput, :masterIDInput);

-- Wizards: Update
UPDATE Wizards 
SET wizardName = :wizardNameInput, beardLengthCm = :beardLengthInput, wizardAge = :wizardAgeInput, masterID = :masterIDInput
WHERE wizardID = :wizardIDInput;

-- Wizards: Delete
DELETE FROM Wizards WHERE wizardID = :wizardIDInput;

-- Chronicles: Get all Chronicles with a JOIN to show the author's name
SELECT chronicleID, chronicleTitle, publicationDate, description, Wizards.wizardName AS authorName 
FROM Chronicles 
LEFT JOIN Wizards ON Chronicles.wizardID = Wizards.wizardID;

-- Chronicles: Add
INSERT INTO Chronicles (chronicleTitle, publicationDate, description, wizardID) 
VALUES (:titleInput, :dateInput, :descInput, :wizardIDFromDropdown);

-- Chronicles: Update (Fixed syntax error)
UPDATE Chronicles 
SET chronicleTitle = :titleInput, publicationDate = :dateInput, description = :descInput, wizardID = :wizardIDFromDropdown
WHERE chronicleID = :chronicleIDInput;

-- Chronicles: Delete
DELETE FROM Chronicles WHERE chronicleID = :chronicleIDInput;

-- Spells: Get all spells with their chronicle name
SELECT Spells.spellID, Spells.spellName, Spells.castingInstruction, Chronicles.chronicleTitle 
FROM Spells
LEFT JOIN Chronicles ON Spells.chronicleID = Chronicles.chronicleID;

-- Spells: Add new spell
INSERT INTO Spells (spellName, castingInstruction, chronicleID) 
VALUES (:spellNameInput, :instructionInput, :chronicleIDFromDropdown);

-- Spells: Update spell
UPDATE Spells 
SET spellName = :spellNameInput, castingInstruction = :instructionInput, chronicleID = :chronicleIDFromDropdown 
WHERE spellID = :spellIDInput;

-- Spells: Delete spell
DELETE FROM Spells WHERE spellID = :spellIDInput;

-- Categories: Get all categories
SELECT categoryID, categoryName FROM Categories;

-- Categories: Add
INSERT INTO Categories (categoryName) VALUES (:categoryNameInput);

-- Categories: Update
UPDATE Categories SET categoryName = :categoryNameInput WHERE categoryID = :categoryIDInput;

-- Categories: Delete
DELETE FROM Categories WHERE categoryID = :categoryIDInput;

-- SpellCategories (M:N Intersection): Get all associations with names
SELECT SpellCategories.spellID, SpellCategories.categoryID, Spells.spellName, Categories.categoryName 
FROM SpellCategories
INNER JOIN Spells ON SpellCategories.spellID = Spells.spellID
INNER JOIN Categories ON SpellCategories.categoryID = Categories.categoryID;

-- SpellCategories: Add association
INSERT INTO SpellCategories (spellID, categoryID) VALUES (:spellIDInput, :categoryIDInput);

-- SpellCategories: Delete association
DELETE FROM SpellCategories WHERE spellID = :spellIDInput AND categoryID = :categoryIDInput;

-- Dropdown Population Queries
SELECT wizardID, wizardName FROM Wizards;
SELECT chronicleID, chronicleTitle FROM Chronicles;
SELECT categoryID, categoryName FROM Categories;
SELECT spellID, spellName FROM Spells;