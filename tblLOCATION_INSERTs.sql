USE INFO430_Group6
/* Insert some data into tblLOCATION using stored procedure*/
GO
CREATE OR ALTER PROCEDURE getLocationTypeID
@LocationType_Name VARCHAR(50),
@LocationTypeID INT OUTPUT
AS
SET @LocationTypeID = (SELECT LocationTypeID 
            FROM tblLOCATION_TYPE 
            WHERE LocationTypeName = @LocationType_Name)

GO
CREATE OR ALTER PROCEDURE Group6_INSERT_INTO_tblLOCATION
@LocationTypeName VARCHAR(100),
@LName VARCHAR(100),
@LDescr VARCHAR(500),
@LShortName VARCHAR(50)
AS 
DECLARE @LT_ID INT 

EXEC getLocationTypeID
@LocationType_Name = @LocationTypeName,
@LocationTypeID = @LT_ID OUTPUT

IF @LT_ID IS NULL
   BEGIN
       PRINT '@LT_ID came back empty;';
       THROW 54322, '@LT_ID cannot be null; process is terminating',1;
   END
BEGIN TRAN T1
    INSERT INTO tblLOCATION (LocationTypeID, LocationName, LocationDescr, LocationShortName)
    VALUES (@LT_ID, @LName, @LDescr, @LShortName)
IF @@ERROR <> 0
    BEGIN 
        PRINT 'Something broke?'
        ROLLBACK TRAN T1 
    END 
ELSE 
    COMMIT TRAN T1
GO


EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Parking Lot',
@LName = 'Parking Lot E18',
@LDescr = 'large parking lot to the north of the IMA and Field #1 (across Wahkiakum Rd)',
@LShortName = 'P L E18'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Parking Lot',
@LName = 'Parking Lot E1',
@LDescr = 'large parking lot to the north of Lot E18: $7.28/day paid by swiping credit card on the way in.  Entrances to E1 are through the E18 parking lot, on Walla Walla Rd from Montlake Blvd NE or on NE Clark Rd from Mary Gates Memorial Dr. NE',
@LShortName = 'P L E1'
GO 

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Main Lobby',
@LName = 'IMA Main Lobby/Entrance',
@LDescr = 'main lobby: member services and dawg bites',
@LShortName = 'ML'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Gym',
@LName = 'Gym D',
@LDescr = 'Located on the 2nd floor.',
@LShortName = 'Gym D'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Gym',
@LName = 'Gym B (Badminton)',
@LDescr = 'Located on the 2nd floor.',
@LShortName = 'Gym B'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Gym',
@LName = 'Gym C (Volleyball)',
@LDescr = 'Located on the 2nd floor.',
@LShortName = 'Gym C'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Cardio Area',
@LName = 'Cardio Area 1',
@LDescr = 'Located on the 2nd floor. Next to the strength training area.',
@LShortName = 'CA 1'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Studio',
@LName = 'Studio 216',
@LDescr = 'Located on the 2nd floor.',
@LShortName = 'S 216'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Studio',
@LName = 'Studio 111',
@LDescr = 'Located on the 1st floor.',
@LShortName = 'S 111'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Mat Room',
@LName = 'Mat Room A',
@LDescr = 'Located on the 1st floor.',
@LShortName = 'MR A'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Mat Room',
@LName = 'Mat Room B',
@LDescr = 'Located on the 1st floor.',
@LShortName = 'MR B'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Locker Room',
@LName = 'Men Locker Room',
@LDescr = 'Located on the 1st floor.',
@LShortName = NULL
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Locker Room',
@LName = 'Women Locker Room',
@LDescr = 'Located on the 1st floor.',
@LShortName = NULL
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Locker Room',
@LName = 'Universal Locker Room',
@LDescr = 'Located on the 1st floor.',
@LShortName = NULL
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Handball/Racquetball Court',
@LName = 'Handball/Racquetball Court #10',
@LDescr = 'IMA Handball/Racquetball Court #10',
@LShortName = 'RB/HB Court #10'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Handball/Racquetball Court',
@LName = 'Handball/Racquetball Court #9',
@LDescr = 'IMA Handball/Racquetball Court #09',
@LShortName = 'RB/HB Court #09'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Handball/Racquetball Court',
@LName = 'Handball/Racquetball Court #8',
@LDescr = 'IMA Handball/Racquetball Court #08',
@LShortName = 'RB/HB Court #08'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Handball/Racquetball Court',
@LName = 'Handball/Racquetball Court #7',
@LDescr = 'IMA Handball/Racquetball Court #07',
@LShortName = 'RB/HB Court #07'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Handball/Racquetball Court',
@LName = 'Handball/Racquetball Court #6',
@LDescr = 'IMA Handball/Racquetball Court #06',
@LShortName = 'RB/HB Court #06'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Squash Court',
@LName = 'International Squash Court #1',
@LDescr = 'IMA International Squash Court #1',
@LShortName = 'SQ Intl Court #1'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Squash Court',
@LName = 'International Squash Court #2',
@LDescr = 'IMA International Squash Court #2',
@LShortName = 'SQ Intl Court #2'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Squash Court',
@LName = 'International Squash Court #3',
@LDescr = 'IMA International Squash Court #3',
@LShortName = 'SQ Intl Court #3'
GO


EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Squash Court',
@LName = 'International Squash Court #4',
@LDescr = 'IMA International Squash Court #4',
@LShortName = 'SQ Intl Court #4'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Squash Court',
@LName = 'North American Squash Court #1',
@LDescr = 'IMA North American Squash Court #1',
@LShortName = 'SQ NA Court #1'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Squash Court',
@LName = 'North American Squash Court #2',
@LDescr = 'IMA North American Squash Court #2',
@LShortName = 'SQ NA Court #2'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Tennis Court',
@LName = 'IMA South Tennis Court #1',
@LDescr = 'IMA South Tennis CT #1',
@LShortName = 'TN South Court #1'
GO

EXEC Group6_INSERT_INTO_tblLOCATION
@LocationTypeName = 'Tennis Court',
@LName = 'IMA South Tennis Court #2',
@LDescr = 'IMA South Tennis CT #2',
@LShortName = 'TN South Court #2'
GO



SELECT * FROM tblLOCATION

