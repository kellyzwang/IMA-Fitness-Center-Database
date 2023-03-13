

USE INFO430_Group6


/* Synthetic Transaction to populate tblEVENT */

GO
CREATE OR ALTER PROCEDURE Group6_GetActivityID
@ActivityName varchar(100),
@ActivityID INT OUTPUT
AS
SET @ActivityID = (SELECT ActivityID 
                FROM tblACTIVITY WHERE ActivityName = @ActivityName)
GO

CREATE OR ALTER PROCEDURE Group6_GetEventTypeID
@EventTypeName varchar(100),
@EventTypeID INT OUTPUT
AS
SET @EventTypeID = (SELECT EventTypeID 
                FROM tblEVENT_TYPE WHERE EventTypeName = @EventTypeName)
GO

CREATE OR ALTER PROCEDURE Group6_GetPersonMembershipStatusID
@MembershipName varchar(50),
@StatusName VARCHAR(100),
@F VARCHAR(50),
@L VARCHAR(50),
@DOB DATE,
@B_Date DATE,
@PersonMembershipStatusID INT OUTPUT
AS
SET @PersonMembershipStatusID = (SELECT PersonMembershipStatusID 
                FROM tblPERSON_MEMBERSHIP_STATUS PMS 
                JOIN tblPERSON P ON P.PersonID = PMS.PersonID 
                JOIN tblMEMBERSHIP M ON M.MembershipID = PMS.MembershipID 
                JOIN tblSTATUS S ON S.StatusID = PMS.StatusID
                WHERE M.MembershipName = @MembershipName
                AND P.FirstName = @F AND P.LastName = @L AND P.DateOfBirth = @DOB 
                AND S.StatusName = @StatusName AND PMS.BeginDate = @B_Date)
GO

CREATE OR ALTER PROCEDURE Group6_GetLocationID
@LocationName VARCHAR(50),
@LocationID INT OUTPUT
AS
SET @LocationID = (SELECT LocationID 
                FROM tblLOCATION WHERE LocationName = @LocationName)
GO

-- create a temp table for Registration eventNames 
CREATE TABLE #tmp_RegistrationeventName
(EventNameID INT IDENTITY(1,1) PRIMARY KEY,
EventName VARCHAR(100))
GO
INSERT INTO #tmp_RegistrationeventName
VALUES ('Check In'), ('Check Out')

-- create a temp table for Space Reservation eventNames 
CREATE TABLE #tmp_SpaceReservationeventName
(EventNameID INT IDENTITY(1,1) PRIMARY KEY,
EventName VARCHAR(100))
GO
INSERT INTO #tmp_SpaceReservationeventName
VALUES ('Reserve Space'), ('Cancel Space Reservation')

-- create a temp table for Equipment Rental eventNames 
CREATE TABLE #tmp_EquipmentRentaleventName
(EventNameID INT IDENTITY(1,1) PRIMARY KEY,
EventName VARCHAR(100))
GO
INSERT INTO #tmp_EquipmentRentaleventName
VALUES ('Rent Equipment'), ('Return Equipment')

-- create a temp table for Class Registration eventNames 
CREATE TABLE #tmp_ClassRegistrationeventName
(EventNameID INT IDENTITY(1,1) PRIMARY KEY,
EventName VARCHAR(100))
GO
INSERT INTO #tmp_ClassRegistrationeventName
VALUES ('Register for a class'), ('Cancel Class Registration')

GO 
-- create the base stored procedure --> INSERT into tblEVENT
CREATE OR ALTER PROCEDURE Group6_base_sproc_INSERT_INTO_tblEVENT
@Event_DateTime DATETIME,
@Activity_Name VARCHAR(100),
@EventType_Name VARCHAR(100),
@Membership_Name varchar(50),
@Status_Name VARCHAR(100),
@First VARCHAR(50),
@Last VARCHAR(50),
@Birth DATE,
@Beg_Date DATE,
@Location_Name VARCHAR(100)
AS
DECLARE @ET_ID INT, @PMS_ID INT, @A_ID INT, @L_ID INT, 
@Event_NamePK INT, @Event_Name VARCHAR(100)

EXEC Group6_GetEventTypeID
@EventTypeName = @EventType_Name,
@EventTypeID = @ET_ID OUTPUT
IF @ET_ID IS NULL
    BEGIN
        PRINT '@ET_ID is empty';
        THROW 65541, '@ET_ID cannot be null; process is terminating',1;
    END

IF @ET_ID = (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = 'Registration')
BEGIN 
    SET @Event_NamePK = (SELECT FLOOR(RAND() * (SELECT COUNT(*) FROM #tmp_RegistrationeventName) + 1))
    SET @Event_Name = (SELECT eventName FROM #tmp_RegistrationeventName WHERE EventNameID = @Event_NamePK)
END 

IF @ET_ID = (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = 'Space Reservation')
BEGIN 
    SET @Event_NamePK = (SELECT FLOOR(RAND() * (SELECT COUNT(*) FROM #tmp_SpaceReservationeventName) + 1))
    SET @Event_Name = (SELECT eventName FROM #tmp_SpaceReservationeventName WHERE EventNameID = @Event_NamePK)
END 

IF @ET_ID = (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = 'Equipment Rental')
BEGIN 
    SET @Event_NamePK = (SELECT FLOOR(RAND() * (SELECT COUNT(*) FROM #tmp_EquipmentRentaleventName) + 1))
    SET @Event_Name = (SELECT eventName FROM #tmp_EquipmentRentaleventName WHERE EventNameID = @Event_NamePK)
END 

IF @ET_ID = (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = 'Class Registration')
BEGIN 
    SET @Event_NamePK = (SELECT FLOOR(RAND() * (SELECT COUNT(*) FROM #tmp_ClassRegistrationeventName) + 1))
    SET @Event_Name = (SELECT eventName FROM #tmp_ClassRegistrationeventName WHERE EventNameID = @Event_NamePK)
END 

EXEC Group6_GetActivityID
@ActivityName = @Activity_Name,
@ActivityID = @A_ID OUTPUT
IF @A_ID IS NULL
    BEGIN
        PRINT '@A_ID is empty';
        THROW 65542, '@A_ID cannot be null; process is terminating',1;
    END


EXEC Group6_GetPersonMembershipStatusID
@MembershipName = @Membership_Name,
@StatusName = @Status_Name,
@F = @First,
@L = @Last,
@DOB = @Birth,
@B_Date = @Beg_Date,
@PersonMembershipStatusID = @PMS_ID OUTPUT
IF @PMS_ID IS NULL
    BEGIN
        PRINT '@PMS_ID is empty';
        THROW 65543, '@PMS_ID cannot be null; process is terminating',1;
    END

EXEC Group6_GetLocationID
@LocationName = @Location_Name,
@LocationID = @L_ID OUTPUT
IF @L_ID IS NULL
    BEGIN
        PRINT '@L_ID is empty';
        THROW 65544, '@L_ID cannot be null; process is terminating',1;
    END

BEGIN TRANSACTION T1
    INSERT INTO tblEVENT (EventTypeID, PersonMembershipStatusID, ActivityID, LocationID, EventName, EventDateTime)
    VALUES (@ET_ID, @PMS_ID, @A_ID, @L_ID, @Event_Name, @Event_DateTime)
IF @@ERROR <>0 OR @@TRANCOUNT <> 1
    BEGIN 
        PRINT 'Something failed at the very end'
        ROLLBACK TRANSACTION T1
    END
ELSE 
    COMMIT TRANSACTION T1

GO

-- now write the wrapper --> the synthetic side

CREATE OR ALTER PROCEDURE Group6_WRAPPER_INSERT_INTO_tblEVENT_synthetic_transaction
@RUN INT
AS
DECLARE @EventTypeRowCount INT = (SELECT COUNT(*) FROM tblEVENT_TYPE)
DECLARE @PMSRowCount INT = (SELECT COUNT(*) FROM tblPERSON_MEMBERSHIP_STATUS) -- create a temp table for just active membership data???
DECLARE @ActivityRowCount INT = (SELECT COUNT(*) FROM tblACTIVITY)
DECLARE @LocationRowCount INT = (SELECT COUNT(*) FROM tblLOCATION)
DECLARE @PersonRowCount INT = (SELECT COUNT(*) FROM tblPERSON)

DECLARE @Event_DateTime2 DATETIME,
@Activity_Name2 VARCHAR(100),
@EventType_Name2 VARCHAR(100),
@Membership_Name2 varchar(50),
@Status_Name2 VARCHAR(100),
@First2 VARCHAR(50),
@Last2 VARCHAR(50),
@Birth2 DATE,
@Beg_Date2 DATE,
@Location_Name2 VARCHAR(100)

-- get PK variables to hold PK value for each loop
DECLARE @EventTypePK INT, @PMSPK INT, @ActivityPK INT, @LocationPK INT, @PersonID INT

WHILE @RUN > 0
BEGIN
SET @EventTypePK = (SELECT RAND() * @EventTypeRowCount + 1)
SET @PMSPK = (SELECT RAND() * @PMSRowCount + 1)
SET @ActivityPK = (SELECT RAND() * @ActivityRowCount + 1)
SET @LocationPK = (SELECT RAND() * @LocationRowCount + 1)

-- find the personID in this loop
SET @PersonID = (SELECT PersonID FROM tblPERSON_MEMBERSHIP_STATUS
                WHERE PersonMembershipStatusID = @PMSPK)

-- determine the Active membership duration for @PersonID
DECLARE @ActiveMemDuration INT = (SELECT DATEDIFF(day, 
    (SELECT TOP 1 PMS.BeginDate AS ActiveStartDate
    FROM tblPERSON_MEMBERSHIP_STATUS PMS 
    JOIN tblSTATUS S ON S.StatusID = PMS.StatusID
    WHERE PersonID = @PersonID AND S.StatusName = 'Active'), 
    COALESCE((SELECT TOP 1 PMS.BeginDate AS NotActiveStartDate
    FROM tblPERSON_MEMBERSHIP_STATUS PMS 
    JOIN tblSTATUS S ON S.StatusID = PMS.StatusID
    WHERE PersonID = @PersonID AND S.StatusName <> 'Active'), GETDATE()))) 


    SET @First2 = (SELECT FirstName FROM tblPERSON P 
                JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON PMS.PersonID = P.PersonID
                WHERE PersonMembershipStatusID = @PMSPK)
    SET @Last2 = (SELECT LastName FROM tblPERSON P 
                JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON PMS.PersonID = P.PersonID
                WHERE PersonMembershipStatusID = @PMSPK)
    SET @Birth2 = (SELECT DateOfBirth FROM tblPERSON P 
                JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON PMS.PersonID = P.PersonID
                WHERE PersonMembershipStatusID = @PMSPK)

    SET @Membership_Name2 = (SELECT MembershipName 
                        FROM tblMEMBERSHIP M
                        JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON PMS.MembershipID = M.MembershipID
                        WHERE PersonMembershipStatusID = @PMSPK)
    SET @Status_Name2 = (SELECT StatusName 
                    FROM tblSTATUS S 
                    JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON PMS.StatusID = S.StatusID
                    WHERE PersonMembershipStatusID = @PMSPK)
    SET @Beg_Date2 = (SELECT BeginDate FROM tblPERSON_MEMBERSHIP_STATUS 
                WHERE PersonMembershipStatusID = @PMSPK) -- problem, Beg_Date2 might not be the begindate for an active membership


    -- to make EvenDateTime realistic, make sure @Event_DateTime2 is after the BeginDate in tblPMS  
    -- and membership status is active

    SET @Event_DateTime2 = (SELECT DATEADD(Day, (SELECT RAND() * @ActiveMemDuration), @Beg_Date2)) 


    SET @Activity_Name2 = (SELECT ActivityName FROM tblACTIVITY WHERE ActivityID = @ActivityPK)
    SET @EventType_Name2 = (SELECT EventTypeName FROM tblEVENT_TYPE WHERE EventTypeID = @EventTypePK)
    SET @Location_Name2 = (SELECT LocationName FROM tblLOCATION WHERE LocationID = @LocationPK)

    EXEC Group6_base_sproc_INSERT_INTO_tblEVENT
    @Event_DateTime = @Event_DateTime2,
    @Activity_Name = @Activity_Name2,
    @EventType_Name = @EventType_Name2,
    @Membership_Name = @Membership_Name2,
    @Status_Name = @Status_Name2,
    @First = @First2,
    @Last = @Last2,
    @Birth = @Birth2,
    @Beg_Date = @Beg_Date2,
    @Location_Name = @Location_Name2
    
SET @RUN = @RUN - 1
END
GO

EXEC Group6_WRAPPER_INSERT_INTO_tblEVENT_synthetic_transaction 1000000 -- 1 million event data 