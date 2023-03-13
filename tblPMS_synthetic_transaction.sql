/* Synthetic transaction / automated wrapper Stored Procedure */
USE INFO430_Group6
GO

/* Synthetic Transaction to populate tblPERSON_MEMBERSHIP_STATUS */
CREATE OR ALTER PROCEDURE Group6_getStatusID
@StatusName VARCHAR(100),
@StatusID INT OUTPUT
AS 

SET @StatusID = (
    SELECT StatusID 
    FROM tblSTATUS
    WHERE StatusName = @StatusName)
GO 
CREATE OR ALTER PROCEDURE Group6_getMembershipID
@MembershipName VARCHAR(100),
@MembershipID INT OUTPUT
AS 
SET @MembershipID = (
    SELECT MembershipID 
    FROM tblMEMBERSHIP
    WHERE MembershipName = @MembershipName)
GO 

-- get Person ID stored procedure
CREATE OR ALTER PROCEDURE Group6_getPersonID
@F VARCHAR(50),
@L VARCHAR(50),
@DOB DATE,
@PersonID INT OUTPUT
AS 
SET @PersonID = (SELECT PersonID FROM tblPERSON
        WHERE FirstName = @F AND LastName = @L AND DateOfBirth = @DOB)
GO 
-- base stored procedure to insert into tblMEMBERSHIP_STATUS
CREATE OR ALTER PROCEDURE Group6_INSERT_INTO_tblPersonMembershipStatus
@StatName VARCHAR(100),
@MemName VARCHAR(100),
@First VARCHAR(50),
@Last VARCHAR(50),
@Birth DATE,
@BDate DATE
AS 

DECLARE @S_ID INT, @M_ID INT, @P_ID INT

EXEC Group6_getStatusID
@StatusName = @StatName,
@StatusID = @S_ID OUTPUT
IF @S_ID IS NULL 
    BEGIN
        PRINT '@S_ID is null, please check again';
        THROW 50001, '@S_ID cannot be null', 1;
    END 

EXEC Group6_getMembershipID 
@MembershipName = @MemName,
@MembershipID = @M_ID OUTPUT
IF @M_ID IS NULL 
    BEGIN
        PRINT '@M_ID is null, please check again';
        THROW 50002, '@M_ID cannot be null', 1;
    END 

EXEC Group6_getPersonID 
@F = @First,
@L = @Last,
@DOB = @Birth,
@PersonID = @P_ID OUTPUT
IF @P_ID IS NULL 
    BEGIN
        PRINT '@P_ID is null, please check again';
        THROW 50003, '@P_ID cannot be null', 1;
    END 

BEGIN TRANSACTION T1
INSERT INTO tblPERSON_MEMBERSHIP_STATUS (MembershipID, PersonID, StatusID, BeginDate)
VALUES (@M_ID, @P_ID, @S_ID, @BDate)

IF @@ERROR <> 0 
    BEGIN 
        PRINT 'Transaction T1 failed'
        ROLLBACK TRANSACTION T1
    END 
ELSE
    COMMIT TRANSACTION T1 
GO

-- wrapper stored procedure for synthetic transaction, 
-- @RUN is how many times we want to insert into tblPersonMembershipStatus
CREATE OR ALTER PROCEDURE Group6_wrapper_INSERT_INTO_tblPersonMembershipStatus
@RUN INT 
AS

DECLARE @MembershipRowCount INT = (SELECT COUNT(*) FROM tblMEMBERSHIP)
DECLARe @PersonRowCount INT = (SELECT COUNT(*) FROM tblPERSON)
DECLARE @StatusN VARCHAR(100), @MembN VARCHAR(100), @BD DATE, @cancelOrExpiredBD DATE,
@Birthy DATE, @Fname VARCHAR(50), @Lname VARCHAR(50)
DECLARE @Status_PK INT, @Membership_PK INT, @Person_PK INT

WHILE @RUN > 0 
BEGIN

SET @Membership_PK = (SELECT RAND() * @MembershipRowCount + 1)
SET @Person_PK = (SELECT RAND() * @PersonRowCount + 1)

SET @MembN = (SELECT MembershipName FROM tblMEMBERSHIP WHERE MembershipID = @Membership_PK)
SET @Birthy = (SELECT DateOfBirth FROM tblPERSON WHERE PersonID = @Person_PK)
SET @Fname = (SELECT FirstName FROM tblPERSON WHERE PersonID = @Person_PK)
SET @Lname = (SELECT LastName FROM tblPERSON WHERE PersonID = @Person_PK)

SET @BD = (SELECT DATEADD(DAY, -RAND()*10000, GETDATE()))

    EXEC Group6_INSERT_INTO_tblPersonMembershipStatus
    @StatName = 'Active',
    @MemName = @MembN,
    @First = @Fname,
    @Last = @Lname,
    @Birth = @Birthy,
    @BDate = @BD

DECLARE @RAND_NUM INT = (SELECT FLOOR(RAND() * 6)) -- generate a random int number between 0 and 5, inclusive
-- if @RAND_NUM = 0: this person will purchase an active membership, but it will cancel at some point
-- if @RAND_NUM = 1: this person will purchase an active membership, but it will expire at some point
-- if @RAND_NUM is other numbers: this person will hold an active membership until now (so more people have active memberships)

SET @cancelOrExpiredBD = (SELECT DateADD(Day, (SELECT RAND() * 1000), @BD))

IF @RAND_NUM = 0
BEGIN
    EXEC Group6_INSERT_INTO_tblPersonMembershipStatus
    @StatName = 'Canceled',
    @MemName = @MembN,
    @First = @Fname,
    @Last = @Lname,
    @Birth = @Birthy,
    @BDate = @cancelOrExpiredBD
END 

IF @RAND_NUM = 1
BEGIN
    EXEC Group6_INSERT_INTO_tblPersonMembershipStatus
    @StatName = 'Expired',
    @MemName = @MembN,
    @First = @Fname,
    @Last = @Lname,
    @Birth = @Birthy,
    @BDate = @cancelOrExpiredBD
END 

SET @RUN = @RUN - 1
END
GO

EXEC Group6_wrapper_INSERT_INTO_tblPersonMembershipStatus 1000 


SELECT * FROM tblPERSON_MEMBERSHIP_STATUS