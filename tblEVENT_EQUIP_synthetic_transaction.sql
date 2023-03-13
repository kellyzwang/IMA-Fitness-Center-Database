/* Synthetic Transaction to populate tblEVENT_EQUIP (Angel) */ -- run this after tblPMS, tblEVENT synthetic transaction are done
USE INFO430_Group6
GO
-- Individual getID procedure for condition, equipment and event
CREATE OR ALTER PROC get_ConditionID 
@CondName VARCHAR(50),
@CondID INT OUTPUT
AS 
SET @CondID = (SELECT ConditionID 
                FROM tblCONDITION
                WHERE ConditionName = @CondName)
GO

CREATE OR ALTER PROC get_EquipID
@EquipName VARCHAR(50),
@EquipID INT OUTPUT
AS 
SET @EquipID = (SELECT EquipmentID 
                FROM tblEQUIPMENT
                WHERE EquipmentName = @EquipName)
GO



-- create a temp table for equipment rental event data as a copy 
CREATE TABLE EquipmentRental_Event
(Rental_EventID INT IDENTITY(1,1) PRIMARY KEY,
EventID INT NOT NULL,
EventTypeID INT NOT NULL,
PersonMembershipStatusID INT NOT NULL, 
ActivityID INT NOT NULL, 
LocationID INT NOT NULL, 
EventName VARCHAR(100),
EventDateTime DATETIME NOT NULL)
GO

INSERT INTO EquipmentRental_Event (EventID, EventTypeID, PersonMembershipStatusID, ActivityID, LocationID, EventName, EventDateTime)
SELECT E.EventID, E.EventTypeID, E.PersonMembershipStatusID, E.ActivityID, E.LocationID, E.EventName, E.EventDateTime 
FROM tblEVENT E 
JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID 
WHERE ET.EventTypeName = 'Equipment Rental'

SELECT * FROM EquipmentRental_Event

GO
-- Nested procedure for insert into event_equip
CREATE OR ALTER PROC INSERT_EVENT_EQUIP
@CondName2 VARCHAR(50),
@EquipName2 VARCHAR(50),
@Event_ID2 INT

AS DECLARE @CondID2 INT, @EquipID2 INT, @EventID2 INT

EXEC get_ConditionID
@CondName = @CondName2,
@CondID =  @CondID2 OUTPUT
IF @CondID2 IS NULL
    BEGIN
        PRINT '@CondID2 can not be NULL';
        THROW 54160, 'bad input @CondID2', 1;
    END

EXEC get_EquipID
@EquipName = @EquipName2,
@EquipID = @EquipID2 OUTPUT
IF @EquipID2 IS NULL
    BEGIN
        PRINT '@EquipID2 can not be NULL';
        THROW 54269, 'bad input @EquipID2', 1;
    END

BEGIN TRAN T1
INSERT INTO tblEVENT_EQUIP (EventID, ConditionID, EquipmentID)
VALUES (@Event_ID2, @CondID2, @EquipID2)
IF @@ERROR <> 0
	BEGIN
		PRINT 'Something broke?'
		ROLLBACK TRANSACTION T1
	END
ELSE
	COMMIT TRANSACTION T1
GO


-- wrapper function
CREATE OR ALTER PROCEDURE wrapper_insert_event_equip
AS
DECLARE @C_PK INT, @EQ_PK INT, @MIN_PK INT, @RUN INT
DECLARE @ConditionCount INT = (SELECT COUNT(*) FROM tblCONDITION)
DECLARE @EQCount INT = (SELECT COUNT(*) FROM tblEQUIPMENT)
DECLARE @CName varchar(50), @EName varchar(50), @Event_ID INT

SET @RUN = (SELECT COUNT(*) FROM EquipmentRental_Event)

WHILE @RUN > 0
BEGIN
    SET @MIN_PK = (SELECT MIN(Rental_EventID) FROM EquipmentRental_Event)
    SET @C_PK = (SELECT RAND() * @ConditionCount + 1)
    SET @EQ_PK = (SELECT RAND() * @EQCount + 1)

    SET @CName = (SELECT ConditionName FROM tblCONDITION WHERE ConditionID = @C_PK) 
    SET @EName = (SELECT EquipmentName FROM tblEQUIPMENT WHERE EquipmentID = @EQ_PK)
    SET @Event_ID = (SELECT EventID FROM EquipmentRental_Event WHERE Rental_EventID = @MIN_PK)


    EXEC INSERT_EVENT_EQUIP
    @CondName2 = @CName,
    @EquipName2 = @EName,
    @Event_ID2 = @Event_ID

    DELETE FROM EquipmentRental_Event WHERE Rental_EventID = @MIN_PK

SET @RUN = @RUN -1
END

EXEC wrapper_insert_event_equip


SELECT count(*) FROM EquipmentRental_Event -- should be 0

SELECT * from tblEVENT_EQUIP

-- check if all EventTypeName is Equipment Rental
SELECT DISTINCT(ET.EventTypeName) from tblEVENT_EQUIP EE 
JOIN tblEVENT E ON E.EventID = EE.EventID 
JOIN tblEVENT_TYPE ET ON ET.EventTypeID = E.EventTypeID