USE INFO430_Group6

-- Popolate tblEQUIPMENT
GO
CREATE OR ALTER PROCEDURE getBrandID
@BrandName VARCHAR(70),
@BrandID INT OUTPUT 
AS 

SET @BrandID = (
    SELECT BrandID
    FROM tblBRAND
    WHERE BrandName = @BrandName
)
GO 

CREATE OR ALTER PROCEDURE getEquipmentTypeID 
@EquipmentTypeName VARCHAR(70),
@EquipmentTypeID INT OUTPUT
AS 

SET @EquipmentTypeID = (
    SELECT EquipmentTypeID 
    FROM tblEQUIPMENT_TYPE
    WHERE EquipmentTypeName = @EquipmentTypeName
)
GO

CREATE OR ALTER PROCEDURE INSERT_EQUIPMENT 
@BN VARCHAR(70),
@ETN VARCHAR(70),
@EQSN VARCHAR(40),
@EQN VARCHAR(70)
AS

DECLARE @B_ID INT, @ET_ID INT

EXEC getBrandID
@BrandName = @BN,
@BrandID = @B_ID OUTPUT 
IF @B_ID IS NULL 
BEGIN 
    PRINT '@B_ID cannot be null';
    THROW 50001, '@B_ID cannot be null', 1;
END 

EXEC getEquipmentTypeID 
@EquipmentTypeName = @ETN,
@EquipmentTypeID =  @ET_ID OUTPUT
IF @ET_ID IS NULL 
BEGIN 
    PRINT '@ET_ID cannot be null';
    THROW 50002, '@ET_ID cannot be null', 1;
END 

BEGIN TRANSACTION T1 
INSERT INTO tblEQUIPMENT (EquipmentTypeID, BrandID, EquipmentShortName, EquipmentName)
VALUES (@ET_ID, @B_ID, @EQSN, @EQN)

IF @@ERROR <> 0
    BEGIN
        PRINT 'Transaction T1 failed'
        ROLLBACK TRANSACTION T1 
    END 
ELSE
    COMMIT TRANSACTION T1
GO


SELECT * FROM tblBRAND
SELECT * FROM tblEQUIPMENT_TYPE

EXEC INSERT_EQUIPMENT 
@BN = 'Nike',
@ETN = 'Volleyball',
@EQSN = 'VB1',
@EQN = 'Volleyball 1'

EXEC INSERT_EQUIPMENT 
@BN = 'Amer Sports',
@ETN = 'Tennis Racquet',
@EQSN = 'TR1',
@EQN = 'Tennis Racquet 1'

EXEC INSERT_EQUIPMENT 
@BN = 'Fischer Sports',
@ETN = 'Tennis Ball',
@EQSN = 'TB1',
@EQN = 'Tennis Ball 1'

EXEC INSERT_EQUIPMENT 
@BN = 'Babolat',
@ETN = 'Badminton Feather Birdies',
@EQSN = 'BadFB1',
@EQN = 'Badminton Feather Birdies 1'

EXEC INSERT_EQUIPMENT 
@BN = 'Nike',
@ETN = 'Soccer Ball',
@EQSN = 'SocB1',
@EQN = 'Soccer Ball 1'

EXEC INSERT_EQUIPMENT 
@BN = 'Babolat',
@ETN = 'Soccer Goalkeeper Gloves',
@EQSN = 'SGG1',
@EQN = 'Soccer Goalkeeper Gloves 1'

EXEC INSERT_EQUIPMENT 
@BN = 'Puma',
@ETN = 'Badminton Racquet',
@EQSN = 'BadRac 1',
@EQN = 'Badminton Racquet 1'

EXEC INSERT_EQUIPMENT 
@BN = 'Adidas',
@ETN = 'Women''s Basketball',
@EQSN = 'WBasketB1',
@EQN = 'Women''s Basketball 1'

SELECT * FROM tblEQUIPMENT