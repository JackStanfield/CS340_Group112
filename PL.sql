-- I mad this to demonstrate the RESET functionality, 
-- it should work by deleting a specific entity
DROP PROCEDURE IF EXISTS DeleteDarkLord;

DELIMITER //

CREATE PROCEDURE DeleteDarkLord()
BEGIN
    DELETE FROM Wizards WHERE wizardName = 'The Dark Lord';
END //

DELIMITER ;