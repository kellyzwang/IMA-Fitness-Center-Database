/* 
Group 6
Kelly Wang | Angel Zhou | Xiao Xiao
12/02/2022
INFO 430 
IMA Database Final Project Code
*/

USE INFO430_Group6
GO

------------------------------ Stored Procedure ------------------------------

-- See other files



------------------------------ Check Constraint/Business Rules ------------------------------

/* No one with expired or canceled memberhsip status could make space reservations. (Xiao Xiao) */
CREATE OR ALTER FUNCTION check_NoExpiredMemberSpaceReservation()
RETURNS INT 
AS
BEGIN 
DECLARE @RET INT = 0
IF EXISTS (SELECT * 
        FROM tblEVENT E 
        JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON E.PersonMembershipStatusID = PMS.PersonMembershipStatusID
        JOIN tblSTATUS S ON PMS.StatusID = S.StatusID 
        JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID
        WHERE S.StatusName IN ('Expired', 'Canceled')
        AND ET.EventTypeName = 'Space Reservation')
BEGIN
    SET @RET = 1
END 
RETURN @RET 
END 
GO 

ALTER TABLE tblEVENT WITH NOCHECK
ADD CONSTRAINT ck_NoExpiredCanclesMemberSpaceReserve 
CHECK (dbo.check_NoExpiredMemberSpaceReservation() = 0)
GO




/* No equipment with condition of Poor or Scrap could be used for equipment rental (Xiao Xiao) */
CREATE OR ALTER FUNCTION check_NoPoorScrapEquipmentRental()
RETURNS INT 
AS 

BEGIN
DECLARE @RET INT = 0
IF EXISTS (
    SELECT *
    FROM tblEVENT E
        JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID
        JOIN tblEVENT_EQUIP EQ ON E.EventID = EQ.EventID
        JOIN tblCONDITION C ON EQ.ConditionID = C.ConditionID
    WHERE C.ConditionName IN ('Poor','Scrap')
        AND ET.EventTypeName = 'Equipment Rental'
)
BEGIN
    SET @RET = 1
END 
RETURN @RET 
END 
GO

ALTER TABLE tblEVENT_EQUIP WITH NOCHECK
ADD CONSTRAINT ck_DoNotRentPoorScrapEquipment
CHECK(dbo.check_NoPoorScrapEquipmentRental() = 0)
GO

/* No 'Bollywood Dance' activity in 'Tennis Court' location type (Angel) */
CREATE OR ALTER FUNCTION fn_noDanceTennis()
RETURNS INT
AS
BEGIN

DECLARE @RET INT = 0
IF EXISTS (
SELECT * 
FROM tblACTIVITY A 
JOIN tblEVENT E ON A.ActivityID = E.ActivityID
JOIN tblLOCATION L ON E.LocationID = L.LocationID
JOIN tblLOCATION_TYPE LT ON L.LocationTypeID = LT.LocationTypeID
WHERE A.ActivityName = 'Bollywood Dance'
AND LT.LocationTypeName = 'Tennis Court'
)
BEGIN
    SET @RET = 1
END
RETURN @RET
END
GO

ALTER TABLE tblEVENT WITH NOCHECK
ADD CONSTRAINT ck_noDanceTennis 
CHECK (dbo.fn_noDanceTennis() = 0)
GO


/* No Event Type 'Registration' in Location 'Men Locker Room' (Angel) */
CREATE OR ALTER FUNCTION fn_noRegLocker()
RETURNS INT
AS
BEGIN

DECLARE @RET INT = 0
IF EXISTS (
SELECT * 
FROM tblEVENT_TYPE ET
JOIN tblEVENT E ON ET.EventTypeID = E.ActivityID
JOIN tblLOCATION L ON E.LocationID = L.LocationID
WHERE ET.EventTypeName = 'Registration'
AND L.LocationName = 'Men Locker Room'
)

BEGIN
SET @RET = 1
END

RETURN @RET
END
GO

ALTER TABLE tblEVENT WITH NOCHECK
ADD CONSTRAINT ck_noRegLocker
CHECK (dbo.fn_noRegLocker() = 0)
GO

/* No activity type 'Friday Night Activities' on weekdays other than fridays (Kelly) */
CREATE OR ALTER FUNCTION check_FridayNightActivitiesOnlyOnFridays()
RETURNS INT 
AS
BEGIN 
DECLARE @RET INT = 0
IF EXISTS (
    SELECT * 
    FROM tblEVENT E 
        JOIN tblACTIVITY A ON A.ActivityID = E.ActivityID 
        JOIN tblACTIVITY_TYPE ACT ON ACT.ActivityTypeID = A.ActivityTypeID
        WHERE ACT.ActivityTypeName = 'Friday Night Activities'
        AND DATENAME(weekday, E.EventDateTime) != 'Friday'
)
BEGIN
    SET @RET = 1
END 
RETURN @RET 
END 
GO 

ALTER TABLE tblEVENT WITH NOCHECK
ADD CONSTRAINT ck_FridayNightActivitiesOnlyOnFridays
CHECK (dbo.check_FridayNightActivitiesOnlyOnFridays() = 0)
GO

/* No person younger than 18 may purchase 'Faculty Husky Card Membership' (Kelly) */
CREATE OR ALTER FUNCTION check_NoYoungerThan18FacultyMembership()
RETURNS INT 
AS
BEGIN 
DECLARE @RET INT = 0
IF EXISTS (
    SELECT * 
    FROM tblPERSON P
        JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON PMS.PersonID = P.PersonID 
        JOIN tblMEMBERSHIP M ON M.MembershipID = PMS.MembershipID
        WHERE M.MembershipName = 'Faculty Husky Card Membership'
        AND P.DateOfBirth > DATEADD(year, -18, GETDATE())
)
BEGIN
    SET @RET = 1
END 
RETURN @RET 
END 
GO 

ALTER TABLE tblPERSON_MEMBERSHIP_STATUS WITH NOCHECK 
ADD CONSTRAINT ck_NoYoungerThan18FacultyMembership
CHECK (dbo.check_NoYoungerThan18FacultyMembership() = 0)
GO



------------------------------ Computed Column ------------------------------

/* Calculate the how many people purchased each memberships (Angel) */
CREATE OR ALTER FUNCTION countMembers(@PK INT)
RETURNS INT
AS
BEGIN 

DECLARE @RET INT = (
    SELECT COUNT(*)
    FROM tblPERSON P 
    JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON P.PersonID = PMS.PersonID
    JOIN tblMEMBERSHIP M ON PMS.MembershipID = M.MembershipID
    WHERE M.MembershipID = @PK
)

RETURN @RET
END 
GO

ALTER TABLE tblMEMBERSHIP
ADD totalMembers AS (dbo.countMembers(MembershipID))
GO

/* Calculate the total number of check-in event that a person has (Angel) */
CREATE FUNCTION calc_totalCheckins(@PK INT)
RETURNS INT
AS
BEGIN 

DECLARE @RET INT = (SELECT COUNT(*)
                    FROM tblPERSON P 
                    JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON P.PersonID = PMS.PersonID 
                    JOIN tblEVENT E ON PMS.PersonMembershipStatusID = E.PersonMembershipStatusID
                    WHERE P.PersonID = @PK
                    AND E.EventName = 'Check In')
RETURN @RET
END 
GO
ALTER TABLE tblPERSON
ADD totalCheckins AS (dbo.calc_totalCheckins(PersonID))
GO

/* Calculate the total number of Space Reservation made by a specific person (Xiao Xiao) */
CREATE OR ALTER FUNCTION Calc_TotalSpaceReservation(@P_PK INT)
RETURNS INT 
AS 

BEGIN 
DECLARE @RET INT = (
    SELECT COUNT(*)
    FROM tblPERSON P 
        JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON P.PersonID = PMS.PersonID 
        JOIN tblEVENT E ON PMS.PersonMembershipStatusID = E.PersonMembershipStatusID
        JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID
    WHERE ET.EventTypeName = 'Space Reservation'
        AND P.PersonID = @P_PK
)
RETURN @RET 
END 
GO 

ALTER TABLE tblPERSON 
ADD calc_NumReservation AS (dbo.Calc_TotalSpaceReservation(PersonID))
GO 

/* Calculate the total number of rental for a specifc equipemnt type (Xiao Xiao) */
CREATE OR ALTER FUNCTION Calc_TotalRentalEquipment(@E_PK INT)
RETURNS INT 
AS 

BEGIN
DECLARE @RET INT = (
    SELECT COUNT(*)
    FROM tblEQUIPMENT_TYPE EQ_T 
        JOIN tblEQUIPMENT EQ ON EQ_T.EquipmentTypeID = EQ.EquipmentTypeID
        JOIN tblEVENT_EQUIP E_EQ ON EQ.EquipmentID = E_EQ.EquipmentID 
        JOIN tblEVENT E ON E_EQ.EventID = E.EventID
        JOIN tblEVENT_TYPE E_T ON E.EventTypeID = E_T.EventTypeID
    WHERE EQ_T.EquipmentTypeID = @E_PK
        AND E_T.EventTypeName = 'Equipment Rental'
) 
RETURN @RET 
END 
GO 

ALTER TABLE tblEQUIPMENT_TYPE 
ADD calc_NumRental AS (dbo.Calc_TotalRentalEquipment(EquipmentTypeID))
GO


/* Create a computed column to track the total number of Class Registration occurred in each location (Kelly) */
CREATE OR ALTER FUNCTION Calc_TotalClassRegistrations (@Location_ID INT)
RETURNS INT 
AS 
BEGIN

DECLARE @RET INT = (
    SELECT COUNT(*)
    FROM tblLOCATION L
    JOIN tblEVENT E ON E.LocationID = L.LocationID
    JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID
    WHERE ET.EventTypeName = 'Class Registration'
    AND L.LocationID = @Location_ID
)
RETURN @RET
END
GO
ALTER TABLE tblLOCATION 
ADD Calc_Total_Class_Registrations
AS (dbo.Calc_TotalClassRegistrations(LocationID))
GO


/* Create a computed column to track the total number of people who 
registered for a class without a husky card membership for each activity. (Kelly) */
GO
CREATE OR ALTER FUNCTION Calc_NumOfNonHuskyCardMembershipRegisteredClass (@Activity_ID INT)
RETURNS INT 
AS 
BEGIN

DECLARE @RET INT = (
    SELECT COUNT(*)
    FROM tblACTIVITY A
    JOIN tblEVENT E ON A.ActivityID = E.ActivityID
    JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID
    JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON PMS.PersonMembershipStatusID = E.PersonMembershipStatusID
    JOIN tblMEMBERSHIP M ON M.MembershipID = PMS.MembershipID
    WHERE ET.EventTypeName = 'Class Registration'
    AND M.MembershipName NOT IN ('Student Husky Card Membership', 'Faculty Husky Card Membership')
    AND A.ActivityID = @Activity_ID
)
RETURN @RET
END
GO
ALTER TABLE tblACTIVITY
ADD calc_Total_NonHuskyCardMembershipRegisteredClass
AS (dbo.Calc_NumOfNonHuskyCardMembershipRegisteredClass(ActivityID))
GO


------------------------------ View ------------------------------

/* The top 5 person to make spac reservations the most times in Gym B  (Xiao Xiao) */

CREATE OR ALTER VIEW top5GymBSpaceReservation 
AS (
SELECT P.FirstName, P.LastName, SUM(E.EventID) AS numReservation, RANK() OVER (ORDER BY SUM(E.EventID) DESC) AS ReservationRank
FROM tblPERSON P 
    JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON P.PersonID = PMS.PersonID
    JOIN tblEVENT E ON PMS.PersonMembershipStatusID = E.PersonMembershipStatusID
    JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID
    JOIN tblLOCATION L ON E.LocationID = L.LocationID 
WHERE L.LocationShortName = 'Gym B'
    AND ET.EventTypeName = 'Space Reservation'
GROUP BY P.FirstName, P.LastName
)
GO

SELECT * FROM top5GymBSpaceReservation WHERE ReservationRank < 5


/* Each equipment type's percentile in terms of number of times being rented  (Xiao Xiao) */
GO
CREATE OR ALTER VIEW EquipRentalPercentile_View
AS (
SELECT EQ_T.EquipmentTypeName, COUNT(E.EventID) AS numRental, NTILE(100) OVER (ORDER BY COUNT(E.EventID) DESC) AS Percentile
FROM tblEVENT E 
    JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID
    JOIN tblEVENT_EQUIP E_EQ ON E.EventID = E_EQ.EventID 
    JOIN tblEQUIPMENT EQ ON E_EQ.EquipmentID = EQ.EquipmentID 
    JOIN tblEQUIPMENT_TYPE EQ_T ON EQ.EquipmentTypeID = EQ_T.EquipmentTypeID
WHERE ET.EventTypeName = 'Equipment Rental'
GROUP BY EQ_T.EquipmentTypeName
)
GO

SELECT * FROM EquipRentalPercentile_View
GO


/* Create a view of the people with the most 'Registration' events (Angel) */ 
CREATE OR ALTER VIEW vwPerson_NumOfRegistrationEvents
AS
SELECT P.PersonID, P.FirstName, P.LastName, COUNT(E.EventID) AS NumOfRegistrationEvents, 
RANK() OVER (ORDER BY COUNT(E.EventID) DESC) AS RankNumOfRegistrationEvents
FROM tblPERSON P 
JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON P.PersonID = PMS.PersonID 
JOIN tblEVENT E ON PMS.PersonMembershipStatusID = E.PersonMembershipStatusID
JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID
WHERE ET.EventTypeName = 'Registration'
GROUP BY P.PersonID, P.FirstName, P.LastName
GO

SELECT * FROM vwPerson_NumOfRegistrationEvents
GO

/* create a view of top 10 students with the most 'Friday Night Activities' (Angel) */
CREATE OR ALTER VIEW vwPerson_Activity
AS
SELECT P.PersonID, P.FirstName, P.LastName, COUNT(ACT.ActivityTypeID) AS NumActivityType, 
RANK() OVER (ORDER BY COUNT(ACT.ActivityTypeID) DESC) AS RankAT
FROM tblPERSON P 
JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON P.PersonID = PMS.PersonID 
JOIN tblEVENT E ON PMS.PersonMembershipStatusID = E.PersonMembershipStatusID
JOIN tblACTIVITY A ON E.ActivityID = A.ActivityID
JOIN tblACTIVITY_TYPE ACT ON A.ActivityTypeID = ACT.ActivityTypeID
WHERE ACT.ActivityTypeName = 'Friday Night Activities'
GROUP BY P.PersonID, P.FirstName, P.LastName
GO

SELECT * FROM vwPerson_Activity
WHERE RankAT < 10
GO

/* View the 300 people who had the most membership changes or membership status changes (Kelly) */

CREATE OR ALTER VIEW vwPerson_MembershipChanges
AS
SELECT P.PersonID, P.FirstName, P.LastName, COUNT(PMS.PersonMembershipStatusID) AS NumOfMembershipChanges, 
RANK() OVER (ORDER BY COUNT(PMS.PersonMembershipStatusID) DESC) AS RankMembershipChanges
FROM tblPERSON P 
JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON P.PersonID = PMS.PersonID 
GROUP BY P.PersonID, P.FirstName, P.LastName
GO
SELECT * FROM vwPerson_MembershipChanges
WHERE RankMembershipChanges <= 300
GO

/* View the top 500 earliest active Membership BeginDates (Kelly) */

CREATE OR ALTER VIEW vwBeginDates_EarliestActiveMembership
AS
SELECT  PMS.BeginDate, 
DENSE_RANK() OVER (ORDER BY PMS.BeginDate ASC) AS RankEarliestMembership
FROM tblPERSON P 
JOIN tblPERSON_MEMBERSHIP_STATUS PMS ON P.PersonID = PMS.PersonID 
JOIN tblSTATUS S ON S.StatusID = PMS.StatusID
WHERE S.StatusName = 'Active'
GROUP BY PMS.BeginDate
GO
SELECT * FROM vwBeginDates_EarliestActiveMembership
WHERE RankEarliestMembership <= 500
GO