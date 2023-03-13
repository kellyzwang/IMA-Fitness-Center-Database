USE INFO430_Group6
/* Insert some data into tblACTIVITY using stored procedure*/
GO
CREATE OR ALTER PROCEDURE getActivityTypeID
@ActivityType_Name VARCHAR(50),
@ActivityTypeID INT OUTPUT
AS
SET @ActivityTypeID = (SELECT ActivityTypeID 
            FROM tblACTIVITY_TYPE 
            WHERE ActivityTypeName = @ActivityType_Name)
GO

CREATE OR ALTER PROCEDURE Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName VARCHAR(50),
@AName VARCHAR(100),
@ADescr VARCHAR(500)
AS 
DECLARE @AT_ID INT 

EXEC getActivityTypeID
@ActivityType_Name = @ActivityTypeName,
@ActivityTypeID = @AT_ID OUTPUT 

IF @AT_ID IS NULL
   BEGIN
       PRINT '@AT_ID came back empty;';
       THROW 54321, '@AT_ID cannot be null; process is terminating',1;
   END
BEGIN TRAN T1
    INSERT INTO tblACTIVITY (ActivityTypeID, ActivityName, ActivityDescr)
    VALUES (@AT_ID, @AName, @ADescr)
IF @@ERROR <> 0
    BEGIN 
        PRINT 'Something broke?'
        ROLLBACK TRAN T1 
    END 
ELSE 
    COMMIT TRAN T1
GO


EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Friday Night Activities',
@AName = 'Autumn 2022 Friday Roller Skating',
@ADescr = 'Autumn 2022: Fridays, September 30 – December 9 7:00pm – 10:15pm, Skate rentals are free.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Friday Night Activities',
@AName = 'Autumn 2022 Friday Archery',
@ADescr = 'Autumn 2022: Fridays, September 30 – December 9, 6:00pm – 9:15pm, IMA Archery Room'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Massage',
@AName = '25-minute Massage Session',
@ADescr = '25-minute massages are conveniently held in the Fitness and Wellness Office of the IMA (booking ahead is required).'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Rec Class',
@AName = 'Bollywood Dance',
@ADescr = 'A Bollywood-inspired dance class that combines dynamic movements with fun music from around the world.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Rec Class',
@AName = 'CYCLE 101',
@ADescr = 'Learn proper riding technique and how to find comfort on the bike — while still having a blast and riding to fun music!'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Rec Class',
@AName = 'Barre Burn',
@ADescr = 'This core and leg focused class combines elements of Pilates and strength training! You will feel stronger, healthier and more balanced after this class!'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Rec Class',
@AName = 'Electro Cycle',
@ADescr = 'Unlike any cycling class you have taken before! This high energy "night" ride features uniquely crafted playlists, visuals and movements in sync with the beat that will leave you sweating and ready for more!'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Mindfulness, Yoga, and Meditation',
@AName = 'Flow and Glow Yoga',
@ADescr = 'End the day with endurance focused flow yoga. Engage your inner muscles and develop postural control and cultivate balance in and out of the studio. Unique lighting will be used.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Mindfulness, Yoga, and Meditation',
@AName = 'Rejuvenating Yoga',
@ADescr = 'Awaken the body with low-impact yoga and organic movements meant to get you ready for the rest of the day.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Mindfulness, Yoga, and Meditation',
@AName = 'Revitalize and Restore Yoga',
@ADescr = 'Let go of the stress from the previous week and ease into the new one. With calm, moderate standing flows and floor asanas (poses), you will revitalize your body, unwind your mind, and lower tension while improving your strength, flexibility, and breath capacity.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Rec Clubs Program',
@AName = 'Hip Hop & Choreography',
@ADescr = 'Hip Hop Dance will provide you with step by step instruction to a new weekly song that will make you feel like a dance pro!'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Rec Clubs Program',
@AName = 'STREET JAZZ',
@ADescr = 'Come dance, de-stress, and shake it out with this one hour dance party!'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Golf Range',
@AName = 'Golf Lesson',
@ADescr = 'Come learn golf!'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Personal Training',
@AName = 'Customized Exercise Program',
@ADescr = 'A personal 4-week training schedule (not in-person training sessions), focusing on you and your goals. Whether your goal is weight loss, strength gain, improved athletic performance, or stress relief, our experienced trainers can create a personalized exercise program to meet your needs.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Personal Training',
@AName = 'Personal Training - 01 Session',
@ADescr = 'Personal training is one-on-one instruction, focusing on you and your goals.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Personal Training',
@AName = 'Personal Training - 04 Sessions',
@ADescr = 'Personal training is one-on-one instruction, focusing on you and your goals.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Personal Training',
@AName = 'Personal Training - 08 Sessions',
@ADescr = 'Personal training is one-on-one instruction, focusing on you and your goals.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Personal Training',
@AName = 'Personal Training - 12 Sessions',
@ADescr = 'Personal training is one-on-one instruction, focusing on you and your goals.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Personal Training',
@AName = 'Virtual Personal Training - 01 Session',
@ADescr = 'Personal training is one-on-one instruction, focusing on you and your goals.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Individual Student Activity',
@AName = 'Indoor Tennis',
@ADescr = NULL
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'Individual Student Activity',
@AName = 'Outdoor Tennis',
@ADescr = NULL
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'UWild Adventures',
@AName = 'Basic Climbing',
@ADescr = 'This beginner friendly class covers the basic skills of climbing for an affordable price.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'UWild Adventures',
@AName = 'Full Moon Kayaking',
@ADescr = 'Enjoy the calm waters of Lake Washington with a moonlit paddle right from campus. Before getting on the water, UWILDs experienced trip leaders will provide essential safety and technique instructions to make sure you have a great experience.'
GO

EXEC Group6_INSERT_INTO_tblACTIVITY
@ActivityTypeName = 'UWild Adventures',
@AName = 'Hike with UWild',
@ADescr = 'Hiking is a great way to get a break from your busy life in Seattle without having to be gone an entire weekend. On day hikes with UWILD, you will experience the beauty of the PNW while you meet new friends!'
GO

SELECT * FROM tblACTIVITY