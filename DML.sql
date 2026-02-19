------------------------
--Wizards
------------------------

--Get all Wizards
SELECT wizardID, wizardName, beardLengthCm, masterID FROM Wizards;
--ORDER BY wizardID;

--CREATE Wizard (masterID choseen via dropdown, it may be NULL)
INSERT INTO Wizards (wizardName, beardLengthCm, masterID)
VALUES (:wizardNameInput, :beardLengthInput, :masterIDInput);

--Update Wizard
UPDATE Wizards SET wizardName = :wizardNameInput, beardLengthCm = :beardLengthInput, masterID = :masterIDInput
WHERE wizardID = :wizardIDInput;

-- Delete wizard
DELETE FROM Wizards WHERE wizardID = :wizardIDInput;


------------------------
--Chronicles
------------------------

--Get all Chronicles
SELECT chronicleID, chronicleTitle, wizardID FROM Chronicles;

-- Add chronicle
INSERT INTO Chronicles (chronicleTitle, wizardID) 
VALUES (:titleInput, :wizardIDFromDropdown);

--Update Chronicle
UPDATE Chronicles SET chronicleTitle = :titleInput, wizardID = :wizardIDFromDropdownSET chronicleTitle = @chronicleTitleInput,
WHERE chronicleID = :chronicleIDInput;

-- Delete chronicle
DELETE FROM Chronicles WHERE chronicleID = :chronicleIDInput;

------------------------
--Spells
------------------------

-- Get all spells with their chronicle name
SELECT Spells.spellID, Spells.spellName, Spells.castingInstruction, Chronicles.chronicleTitle 
FROM Spells
LEFT JOIN Chronicles ON Spells.chronicleID = Chronicles.chronicleID;

-- Add new spell
INSERT INTO Spells (spellName, castingInstruction, chronicleID) 
VALUES (:spellNameInput, :instructionInput, :chronicleIDFromDropdown);

-- Update spell
UPDATE Spells SET spellName = :spellNameInput, castingInstruction = :instructionInput, chronicleID = :chronicleIDFromDropdown 
WHERE spellID = :spellIDInput;

-- Delete spell
DELETE FROM Spells WHERE spellID = :spellIDInput;

------------------------
--Categories
------------------------

-- Get all categories
SELECT categoryID, categoryName FROM Categories;

-- Add category
INSERT INTO Categories (categoryName) VALUES (:categoryNameInput);

-- Update category
UPDATE Categories SET categoryName = :categoryNameInput WHERE categoryID = :categoryIDInput;

-- Delete category
DELETE FROM Categories WHERE categoryID = :categoryIDInput;

------------------------
--SpellCategories (M:N Intersection)
------------------------

-- Get all associations with names
SELECT Spells.spellName, Categories.categoryName 
FROM SpellCategories
INNER JOIN Spells ON SpellCategories.spellID = Spells.spellID
INNER JOIN Categories ON SpellCategories.categoryID = Categories.categoryID;

-- Add association
INSERT INTO SpellCategories (spellID, categoryID) VALUES (:spellIDInput, :categoryIDInput);

-- Delete association (requires both IDs)
DELETE FROM SpellCategories WHERE spellID = :spellIDInput AND categoryID = :categoryIDInput;