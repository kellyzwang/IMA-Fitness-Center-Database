CREATE DATABASE INFO430_Group6
GO
USE INFO430_Group6

CREATE TABLE tblMEMBERSHIP
(MembershipID INTEGER IDENTITY(1,1) PRIMARY KEY,
MembershipName VARCHAR(50) NOT NULL,
MembershipDescr VARCHAR(500) NULL)
GO
CREATE TABLE tblBRAND 
(BrandID INTEGER IDENTITY(1,1) PRIMARY KEY,
BrandName VARCHAR(50) NOT NULL,
BrandDescr VARCHAR(500) NULL)
GO
CREATE TABLE tblEQUIPMENT_TYPE 
(EquipmentTypeID INTEGER IDENTITY(1,1) PRIMARY KEY,
EquipmentTypeName VARCHAR(50) NOT NULL,
EquipmentTypeDescr VARCHAR(500) NULL)
GO
CREATE TABLE tblSTATUS 
(StatusID INTEGER IDENTITY (1,1) PRIMARY KEY,
StatusName VARCHAR(100) NOT NULL,
StatusDescr VARCHAR(500) NULL)
GO
CREATE TABLE tblCONDITION 
(ConditionID INTEGER IDENTITY(1,1) PRIMARY KEY,
ConditionName VARCHAR(50) NOT NULL,
ConditionDescr VARCHAR(500) NULL)
GO
CREATE TABLE tblEVENT_TYPE
(EventTypeID INTEGER IDENTITY(1,1) PRIMARY KEY,
EventTypeName VARCHAR(100) NOT NULL,
EventTypeDescr VARCHAR(500) NULL)
GO 
CREATE TABLE tblACTIVITY_TYPE 
(ActivityTypeID INTEGER IDENTITY(1,1) PRIMARY KEY,
ActivityTypeName VARCHAR(50) NOT NULL,
ActivityTypeDescr VARCHAR(500) NULL)
GO 
CREATE TABLE tblLOCATION_TYPE
(LocationTypeID INTEGER IDENTITY(1,1) PRIMARY KEY,
LocationTypeName VARCHAR(100) NOT NULL,
LocationTypeDescr VARCHAR(500) NULL)
GO 
CREATE TABLE tblPERSON
(PersonID INTEGER IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
DateOfBirth DATE NOT NULL,
Email VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(50) NOT NULL)
GO 
CREATE TABLE tblLOCATION
(LocationID INTEGER IDENTITY(1,1) PRIMARY KEY, 
LocationTypeID INT FOREIGN KEY REFERENCES tblLOCATION_TYPE (LocationTypeID) NOT NULL,
LocationName VARCHAR(50) NOT NULL,
LocationDescr VARCHAR(500) NULL,
LocationShortName VARCHAR(50) NULL)
GO 
CREATE TABLE tblACTIVITY
(ActivityID INTEGER IDENTITY(1,1) PRIMARY KEY,
ActivityTypeID INT FOREIGN KEY REFERENCES tblACTIVITY_TYPE (ActivityTypeID) NOT NULL,
ActivityName VARCHAR(100) NOT NULL,
ActivityDescr VARCHAR(500) NULL)
GO 
CREATE TABLE tblPERSON_MEMBERSHIP_STATUS
(PersonMembershipStatusID INTEGER IDENTITY(1,1) PRIMARY KEY,
MembershipID INT FOREIGN KEY REFERENCES tblMEMBERSHIP (MembershipID) NOT NULL,
PersonID INT FOREIGN KEY REFERENCES tblPERSON (PersonID) NOT NULL,
StatusID INT FOREIGN KEY REFERENCES tblSTATUS (StatusID) NOT NULL,
BeginDate DATE NOT NULL)
GO 
CREATE TABLE tblEQUIPMENT
(EquipmentID INTEGER IDENTITY(1,1) PRIMARY KEY,
BrandID INT FOREIGN KEY REFERENCES tblBRAND(BrandID) NOT NULL,
EquipmentTypeID INT FOREIGN KEY REFERENCES tblEQUIPMENT_TYPE (EquipmentTypeID) NOT NULL, 
EquipmentShortName VARCHAR(50) NULL,
EquipmentName VARCHAR(50) NOT NULL)
GO 
CREATE TABLE tblEVENT
(EventID INTEGER IDENTITY(1,1) PRIMARY KEY,
EventTypeID INT FOREIGN KEY REFERENCES tblEVENT_TYPE(EventTypeID) NOT NULL,
PersonMembershipStatusID INT FOREIGN KEY REFERENCES tblPERSON_MEMBERSHIP_STATUS (PersonMembershipStatusID) NOT NULL, 
ActivityID INT FOREIGN KEY REFERENCES tblACTIVITY (ActivityID) NOT NULL, 
LocationID INT FOREIGN KEY REFERENCES tblLOCATION (LocationID) NOT NULL, 
EventName VARCHAR(100),
EventDateTime DATETIME NOT NULL)
GO
CREATE TABLE tblEVENT_EQUIP
(EventEquipID INTEGER IDENTITY(1,1) PRIMARY KEY,
EventID INT FOREIGN KEY REFERENCES tblEVENT (EventID) NOT NULL,
ConditionID INT FOREIGN KEY REFERENCES tblCONDITION (ConditionID) NOT NULL,
EquipmentID INT FOREIGN KEY REFERENCES tblEQUIPMENT (EquipmentID) NOT NULL)



-- INSERT statements to populate look-up tables

INSERT INTO tblSTATUS
VALUES ('Expired', 'no longer valid'),
('Active', 'currently running and entitle their members to membership participation and benefits'),
('Canceled', 'have been canceled and are no longer active')
GO
SELECT * FROM tblSTATUS


INSERT INTO tblLOCATION_TYPE
VALUES ('Parking Lot', 'an area used for the parking of motor vehicles'),
('Main Lobby', 'the ground floor lobby of the building'),
('Gym', 'a place for indoor physical workout and activities, used for approved activities only i.e., basketball, volleyball, badminton'),
('Cardio Area', 'an area for cardiovascular exercise'),
('Studio', 'a space for activities related to physical well-being such as dance, martial arts, yoga, and other forms of physical exercise'),
('Mat Room', 'a room whose floor surface area can be completely covered by mat, shoes are not permitted on the mats'),
('Archery Room', 'a room used for archery activities, archery is allowed during Archery Club practices and Friday Night Archery only'),
('Swimming Pool', 'a tank or large basin that is filled with water and intended for recreational or competitive swimming or diving'),
('Locker Room', 'a room used for the storage and safekeeping of personal belongings'),
('Weight Room', 'a large room where people lift weights and exercise'),
('First Aid Room', 'a room at the worksite that is used exclusively for the purposes of administering first aid'),
('Indoor Track', 'an indoor track that is 1/9th of a mile'),
('Handball/Racquetball Court', 'a court for handball or racquetball'),
('Tennis Court', 'the venue where the sport of tennis is played'),
('Squash Court', 'a four-walled court used for playing squash')
GO
SELECT * FROM tblLOCATION_TYPE

 

INSERT INTO tblACTIVITY_TYPE
VALUES ('Friday Night Activities', 'Activities include Archery and Roller Skating. Admission is free for Rec members and all equipment is provided. Friday Night Activities are very popular and are first come first serve.'),
('UWild Adventures', 'Come join us in any way that works for you; whether that’s a class, trip, renting gear, climbing at the Crags, paddling at the Waterfront, or joining a club. Everyone needs some time outdoors, and we’re here to help make that happen.'),
('Golf Range', 'A great place to hit a bucket or two of balls.'),
('Massage', 'We know that stress can take its toll on the body and we want to provide you with a healthy way to relax and unwind!'),
('Intramural Sports', 'IMLeagues provides access to unlimited intramural activities for the quarter.'),
('Mindfulness, Yoga, and Meditation','Classes are designed to increase attention span, amplify focus, build resiliency to stress, and promote compassion for self and others.'),
('Personal Training', 'One-on-one fitness instruction that incorporates exercise screening, goal-setting and health education.'),
('Sports Skills and Martial Arts', 'Sports Skills and Martial Arts Classes are a way for individuals to enhance or learn new skills.'),
('Waterfront Activities', 'Come solo, with a group of friends, or with the family and experience a paddle around the Union Bay Natural Area admiring the wildlife such as bald eagles, osprey (also known as seahawks), and various types waterfowl. Paddle to the Washington Arboretum and enjoy the protected waterways and hiking trails that provide spectacular animal and people watching.'),
('Rec Clubs Program', 'Comprised of various student organizations focused on a particular sport.'),
('Rec Class', 'Dozens of fitness and mindfulness classes hosted by our friendly, knowledgeable instructors.'),
('Group Fitness', 'Our fitness and dance classes are designed to celebrate and inspire all.'),
('Crags Climbing', 'Crags Climbing Center offers over 5,000 square feet of climbing area with 23 top rope stations up to 44 feet in height with ~15 configured for lead climbing.'),
('Student Club Activity', 'Activities organized by on campus student clubs.'),
('Individual Student Activity', 'Individual Activities in the IMA building. Checked in with a Husky card or membership card.')
GO
SELECT * FROM tblACTIVITY_TYPE


INSERT INTO tblBRAND (BrandName, BrandDescr)
VALUES  ('Nike','Top 1 brand for sports equipment'),
        ('Adidas','High ranking sports equipment company'),
        ('Amer Sports','Finnish sporting goods company founded in 1950.'),
        ('Puma','Who does not like Puma'),
        ('Under Armour','slightly more expensive than others'),
        ('Fischer Sports','Has great ice hockey and skiing equipments'),
        ('Salomon','Has great snowboarding and skiing equipments'),
        ('Wilson Sporting Goods','Offers racquets and all kinds of balls in good quality'),
        ('Babolat','Has very good tennis equipments'),
        ('Uhlsport','Provide fine quality football')
GO
SELECT * FROM tblBRAND


INSERT INTO tblCONDITION (ConditionName, ConditionDescr)
VALUES  ('Very Good','in excellent condition capable of being used to its fully specified utilization for its designated purpose'),
        ('Good','equipment being used at or near their fully specified utilization'),
        ('Fair','equipment being used at some point below their fully specified utilization.'),
        ('Poor','equipment at some point well below their fully specified utilization. Need extensive repairs and/or replacement of major elements in the very near future'),
        ('Scrap','equipment no longer serviceable ')
GO
SELECT * FROM tblCONDITION


INSERT INTO tblMEMBERSHIP (MembershipName, MembershipDescr)
VALUES  ('Student Husky Card Membership', NULL),
('Faculty Husky Card Membership', NULL),
('Summer Quarter Rec Memberhip', NULL),
('Autumn Quarter Rec Memberhip', NULL),
('Winter Quarter Rec Memberhip', NULL),
('Spring Quarter Rec Memberhip', NULL),
('Annual Rec Membership', NULL)
SELECT * FROM tblMEMBERSHIP


INSERT INTO tblEQUIPMENT_TYPE(EquipmentTypeName, EquipmentTypeDescr)
VALUES
('Women''s Basketball', '28.5 Women''s basketball'),
('Men''s Basketball', '29.5 Men''s basketball'),
('Volleyball', 'Wilson Indoor Volleyball'),
('Tennis Racquet', 'adult size Tennis Racquet'),
('Tennis Ball', 'regular Tennis balls'),
('Badminton Racquet', 'adult size Badminton Racquet'),
('Badminton Nylon Birdies', 'green, Nylon Birdies that no one likes'),
('Badminton Feather Birdies', 'White, feather Birdies perfect for speed'),
('Soccer Ball', 'Regular practice Soccer Ball'),
('Soccer Goalkeeper Gloves', 'Adult size Soccer Goalkeeper Gloves')
SELECT * FROM tblEQUIPMENT_TYPE


INSERT INTO tblEVENT_TYPE(EventTypeName, EventTypeDescr)
VALUES ('Registration', 'Includes the process of checking in and checking out of IMA'),
('Space Reservation', 'Reserve a space in the IMA'),
('Equipment Rental', 'Process of renting and checking in equipments'),
('Class Registration', 'Register for fitness classes')
SELECT * FROM tblEVENT_TYPE


-- imported MOCK_DATA.csv using import wizard
SELECT * FROM MOCK_DATA 

INSERT INTO tblPERSON (FirstName, LastName, DateOfBirth, Email, PhoneNumber)
SELECT first_name, last_name, DateOfBirth, Email, PhoneNumber FROM MOCK_DATA

SELECT * FROM tblPERSON


-- check to see populated data 
SELECT * FROM tblMEMBERSHIP
SELECT * FROM tblSTATUS 
SELECT * FROM tblPERSON -- imported mock person data to insert 1000 fake people
SELECT * FROM tblLOCATION_TYPE 
SELECT * FROM tblLOCATION -- use stored procedure to populate
SELECT * FROM tblACTIVITY_TYPE 
SELECT * FROM tblACTIVITY -- use stored procedure to populate
SELECT * FROM tblEVENT_TYPE
SELECT * FROM tblCONDITION 
SELECT * FROM tblEQUIPMENT_TYPE 
SELECT * FROM tblEQUIPMENT -- use stored procedure to populate

-- use synthetic transactions to populate
SELECT * FROM tblPERSON_MEMBERSHIP_STATUS
SELECT * FROM tblEVENT
SELECT * FROM tblEVENT_EQUIP

