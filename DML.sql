------------------------
--Wizards
------------------------

--Get all Wizards
SELECT wizardID, wizardName, beardLengthCm, wizardAge, masterID
FROM Wizards
ORDER BY wizardID;

--CREATE Wizard (masterID choseen via dropdown, it may be NULL)
INSERT INTO Wizards (wizardName, beardLengthCm, wizardAge, masterID)
VALUES (@wizardNameInput, @beardLengthCmInput, @wizardAgeInput, @masterIDInput);

--Update Wizard
UPDATE Wizards
SET wizardName = @wizardNameInput, 
beardLengthCm = @beardLengthCmInput,
wizardAge = @wizardAgeInput,
masterID = @masterIDInput
WHERE wizardID = @wizardIDInput;

-- Drop down table data for masterID
SELECT wizardID, wizardName
FROM Wizards
ORDER BY wizardName;

--

------------------------
--Chronicles
------------------------

--Get all Chronicles
SELECT c.chronicleID, c.chronicleTitle, c.publicationDate, wiz.wizardName
FROM Chronicles AS c
LEFT JOIN Wizards AS wiz ON c.wizardID = wiz.wizardID
ORDER BY c.chronicleID;

--CREATE Chronicle (wizardID chosen via dropdown, it may be NULL)
INSERT INTO Chronicles (chronicleTitle, publicationDate, description, wizardID)
values(@chronicleTitleInput, @publicationDateInput, @descriptionInput, @wizardIDInput);

--Update Chronicle
UPDATE Chronicles
SET chronicleTitle = @chronicleTitleInput,
publicationDate = @publicationDateInput,
description = @descriptionInput,
wizardID = @wizardIDInput
WHERE chronicleID = @chronicleIDInput;

--Drop down table data for wizardID (for chronicle creation and update)
SELECT wizardID, wizardName
FROM Wizards
ORDER BY wizardName;

--Delete a chronicle, deletes associated spells and spell category relationships
DELETE FROM Chronicles
WHERE chronicleID = @chronicleIDInput;

------------------------
--Categories
------------------------

--Get all Categories
SELECT categoryID, categoryName
FROM Categories
ORDER BY categoryID;

--CREATE Category
INSERT INTO Categories (categoryName)
VALUES (@categoryNameInput);

--Delete a category, deletes associated spell category relationships
DELETE FROM Categories
WHERE categoryID = @categoryIDInput;

--Update a category
UPDATE Categories
SET categoryName = @categoryNameInput
WHERE categoryID = @categoryIDInput;

------------------------
--Spells
------------------------

--Get all spells with their chronicle information
SELECT s.spellID, s.spellName, s.castingInstruction, c.chronicleTitle, c.chronicleID
FROM Spells AS s
LEFT JOIN Chronicles AS c ON s.chronicleID = c.chronicleID
ORDER BY s.spellID;

--CREATE Spell (chronicleID chosen via dropdown, it may NOT be NULL)
INSERT INTO Spells (spellName, castingInstruction, chronicleID)
VALUES (@spellNameInput, @castingInstructionInput, @chronicleIDInput);

--Update Spell
UPDATE Spells
SET spellName = @spellNameInput,
castingInstruction = @castingInstructionInput,
chronicleID = @chronicleIDInput
WHERE spellID = @spellIDInput;

--Drop down table data for chronicleID (for spell creation and update)
SELECT chronicleID, chronicleTitle
FROM Chronicles
ORDER BY chronicleTitle;

--Delete a spell, deletes associated spell category relationships
DELETE FROM Spells
WHERE spellID = @spellIDInput;
------------------------
--SpellCategories
------------------------

--Get all spell categories with their spell and category information
SELECT sc.spellCategoryID,s.spellID, s.spellName, cat.categoryID, cat.categoryName
FROM SpellCategories AS sc
LEFT JOIN Spells AS s ON sc.spellID = s.spellID
LEFT JOIN Categories AS cat ON sc.categoryID = cat.categoryID
ORDER BY sc.spellCategoryID;

--CREATE SpellCategory (spellID and categoryID chosen via dropdown, they may NOT be NULL)
INSERT INTO SpellCategories (spellID, categoryID)
VALUES (@spellIDInput, @categoryIDInput);

--Delete a spell category relationship
DELETE FROM SpellCategories
WHERE spellCategoryID = @spellCategoryIDInput;

--Update a relationship
UPDATE SpellCategories
SET spellID = @spellIDInput, categoryID = @categoryIDInput
WHERE spellCategoryID = @spellCategoryIDInput;