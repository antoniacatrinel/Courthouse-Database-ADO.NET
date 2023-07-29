USE [courthouse]
GO


-- a table with a single-column primary key and no foreign keys: court_case
CREATE OR ALTER PROCEDURE [addCourtCase](@n INT) 
AS
BEGIN
	DECLARE @i INT = 0
	WHILE @i < @n
	BEGIN
		INSERT INTO [court_case]([case_type], [case_status], [crime], [no_victims], [start_date], [end_date]) 
			 VALUES ('criminal', 'ongoing', CONCAT('Crime ', @i), @i, '2021-11-11', '')
		SET @i = @i + 1
	END	
END
GO


CREATE OR ALTER PROCEDURE [deleteCourtCase] 
AS
BEGIN
	DELETE FROM [court_case]
	WHERE [crime] like 'Crime %'
END
GO


-- a table with a single-column primary key and at least one foreign key: conviction
CREATE OR ALTER PROCEDURE [addConviction](@n INT) 
AS
BEGIN
	DECLARE @startid INT = (
				  SELECT TOP 1 [C].[caseid] 
				    FROM [court_case] [C] 
				   WHERE [crime] like 'Crime %'
			)
	DECLARE @i INT = 0

	WHILE @i < @n 
	BEGIN
		INSERT INTO [conviction]([caseid], [date], [penalty], [counts])
			 VALUES (@startid, '2017-03-10', CONCAT('Penalty ', @i), @i)
		SET @i = @i + 1
	END	
END
GO


CREATE OR ALTER PROCEDURE [deleteConviction] 
AS
BEGIN
	DELETE FROM [conviction]
	WHERE [penalty] like 'Penalty %'
END
GO


-- a table with a multicolumn primary key: case_staff
CREATE OR ALTER PROCEDURE [addCaseStaff](@n INT) 
AS
BEGIN
	DECLARE @caseid INT
	DECLARE @judgeid INT
	DECLARE @prosecutorid INT

	DECLARE [curs] CURSOR
		FOR
		 SELECT [t].[caseid], [J].[judgeid], [P].[prosecutorid]
		   FROM (
			  SELECT [CC].[caseid]
			    FROM [court_case] [CC]
			   WHERE [crime] like 'Crime %'
				) [t]
     CROSS JOIN [judge] [J]
     CROSS JOIN [prosecutor] [P]
	 
	OPEN [curs]
	DECLARE @i INT = 0

	WHILE @i < @n 
	BEGIN
		FETCH NEXT FROM [curs] INTO  @caseid, @judgeid, @prosecutorid
		INSERT INTO [case_staff]([caseid], [judgeid], [prosecutorid], [salary])
			 VALUES (@caseid, @judgeid, @prosecutorid, -10 * (@i + 1))
		SET @i = @i + 1
	END	
	CLOSE [curs]
	DEALLOCATE [curs]
END
GO


CREATE OR ALTER PROCEDURE [deleteCaseStaff] 
AS
BEGIN
	DELETE FROM [case_staff]
	WHERE [salary] < 0
END
GO


-- a view with a SELECT statement operating on one table
CREATE OR ALTER VIEW [dbo].[convictionView] 
AS
	SELECT *
	  FROM [conviction]
GO


-- a view with a SELECT statement that operates on at least 2 different tables and contains at least one JOIN operator
CREATE OR ALTER VIEW [dbo].[caseStaffView] 
AS
	SELECT [P].[first_name], [P].[last_name], [P].[years_of_practice]
	  FROM [case_staff] [CS]
 LEFT JOIN [prosecutor] [P]
		ON [P].[prosecutorid] = [CS].[prosecutorid]
GO


-- a view with a SELECT statement that has a GROUP BY clause, operates on at least 2 different tables and contains at least one JOIN operator
CREATE OR ALTER VIEW [dbo].[courtCaseView] 
AS
	SELECT [CC].[case_type], [CC].[case_status], [CC].[crime]
	  FROM [court_case] [CC]
 LEFT JOIN [conviction] [C]
		ON [CC].[caseid] = [C].[caseid]
  GROUP BY [CC].[case_type], [CC].[case_status], [CC].[crime]
GO


CREATE OR ALTER PROCEDURE [selectView](@name VARCHAR(100)) 
AS
BEGIN
	DECLARE @sql VARCHAR(250) = 'SELECT * FROM ' + @name
	EXECUTE(@sql)
END
GO

-- Tests – holds data about different tests;
-- Tables – holds data about tables that can take part in tests;
-- TestTables – junction table between Tests and Tables (which tables take part in which tests);
-- Views – holds data about a set of views from the database, used to assess the performance of certain SQL queries;
-- TestViews – junction table between Tests and Views (which views take part in which tests);
-- TestRuns – contains data about different test runs; 
-- TestRunTables – contains performance data for INSERT operations for each table in each test run;
-- TestRunViews – contains performance data for each view in each test run. 


INSERT INTO [Tests](Name) 
     VALUES ('addCourtCase'), ('deleteCourtCase'), ('addConviction'), ('deleteConviction'), ('addCaseStaff'), ('deleteCaseStaff'), ('selectView')


INSERT INTO [Tables](Name) 
     VALUES ('court_case'), ('conviction'), ('case_staff')


INSERT INTO [Views](Name) 
     VALUES ('courtCaseView'), ('convictionView'), ('caseStaffView')


SELECT * 
  FROM [Tests]


SELECT * 
  FROM [Tables]


INSERT INTO [TestViews]([TestID], [ViewID])
	 VALUES (7, 1), (7, 2), (7, 3)


INSERT INTO [TestTables]([TestID], [TableID], [NoOfRows], [Position])
	 VALUES (6, 3, 100, 1),    -- deletes
		(4, 2, 150, 2),
		(2, 1, 200, 3),
		(1, 1, 250, 1),    -- inserts
		(3, 2, 300, 2),
		(5, 3, 350, 3)


SELECT *
FROM [TestTables]

SELECT *
FROM [TestViews]


GO 
CREATE OR ALTER PROCEDURE [deleteTest](@testRunID INT) 
AS
BEGIN
	DECLARE @noOfRows INT
	DECLARE @tableID INT
	DECLARE @startTime DATETIME
	DECLARE @endTime DATETIME
	DECLARE @name VARCHAR(100)

	DECLARE [testDeleteCursor] CURSOR
		FOR
		 SELECT [TableID], [Name], [NoOfRows]
	       FROM [Tests] INNER JOIN [TestTables] ON [Tests].[TestID] = [TestTables].[TestID]
	      WHERE [Name] LIKE 'delete%' 
	   ORDER BY [Position] 

	OPEN [testDeleteCursor]
	
	FETCH NEXT FROM [testDeleteCursor] INTO @tableID, @name, @noOfRows

	PRINT 'Started delete test'

	SET @startTime = GETDATE()

	UPDATE [TestRuns]
	   SET [StartAt] = @startTime
	 WHERE [TestRunID] = @testRunID AND YEAR([StartAt]) = 2000

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Running ' + @name
		EXEC(@name) 

		FETCH NEXT FROM [testDeleteCursor] INTO @tableID, @name, @noOfRows
	END

	PRINT 'Ended delete test'

	CLOSE [testDeleteCursor]
	DEALLOCATE [testDeleteCursor]
END


GO 
CREATE OR ALTER PROCEDURE [insertTest](@testRunID INT) AS
BEGIN
	DECLARE @noOfRows INT
	DECLARE @tableID INT
	DECLARE @startTime DATETIME
	DECLARE @endTime DATETIME
	DECLARE @name VARCHAR(100)

	DECLARE [testInsertCursor] CURSOR
		FOR
		 SELECT [TableID], [Name], [NoOfRows]
	       FROM [Tests] INNER JOIN [TestTables] ON [Tests].[TestID] = [TestTables].[TestID]
	      WHERE [Name] LIKE 'add%' 
	   ORDER BY [Position] 

	OPEN [testInsertCursor]

	FETCH NEXT FROM [testInsertCursor] INTO @tableID, @name, @noOfRows

	PRINT 'Started insert test'

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @startTime = GETDATE()

		PRINT 'Running ' + @name
		EXEC @name @noOfRows
		
		SET @endTime = GETDATE()

		INSERT INTO [TestRunTables] VALUES (@testRunID, @tableID, @startTime, @endTime)

		FETCH NEXT FROM [testInsertCursor] INTO @tableID, @name, @noOfRows
	END

	PRINT 'Ended insert test'

	CLOSE [testInsertCursor]
	DEALLOCATE [testInsertCursor]
END


GO 
CREATE OR ALTER PROCEDURE [viewsTest](@testRunID INT) 
AS
BEGIN
	DECLARE @startTime DATETIME
	DECLARE @endTime DATETIME
	DECLARE @viewID INT
	DECLARE @viewName VARCHAR(100)

	DECLARE [testViewCursor] CURSOR
		FOR 
		 SELECT [ViewID], [Name]
		   FROM [Views] 

	OPEN [testViewCursor]

	FETCH NEXT FROM [testViewCursor] INTO @viewID, @viewName

	PRINT 'Started views test'

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @startTime = GETDATE()

		PRINT 'View name ' + @viewName
		EXEC [selectView] @viewName

		SET @endTime = GETDATE()

		INSERT INTO [TestRunViews] VALUES (@testRunID, @viewID, @startTime, @endTime)

		FETCH NEXT FROM [testViewCursor] INTO @viewID, @viewName
	END

	UPDATE [TestRuns]
	   SET [EndAt] = @endTime
	 WHERE [TestRunID] = @testRunID

	PRINT 'Ended views test'

	CLOSE [testViewCursor]
	DEALLOCATE [testViewCursor]
END


GO
CREATE OR ALTER PROCEDURE [mainTest] 
AS
BEGIN
	INSERT INTO [TestRuns] VALUES ('', '2000', '2000')

	DECLARE @testRunID INT
	SET @testRunID = (
			   SELECT MAX([TestRunID])
			     FROM [TestRuns]
			 )

	PRINT 'Started test with id ' + CONVERT(VARCHAR, @testRunID)

	UPDATE [TestRuns]
	   SET [Description] = 'test' + CONVERT(VARCHAR, @testRunID)
	 WHERE [TestRunID] = @testRunID 

	-- delete tests

	EXEC [deleteTest] @testRunID

	-- insert tests

	EXEC [insertTest] @testRunID

	-- view tests

	EXEC [viewsTest] @testRunID

	PRINT 'Ended test with id ' + CONVERT(VARCHAR, @testRunID)
	
END
GO


CREATE OR ALTER PROCEDURE [runTests](@n INT) 
AS
BEGIN
	DECLARE @i INT = 0
	WHILE @i < @n
	BEGIN
		EXEC [mainTest]
		SET @i = @i + 1
	END
END
GO


EXEC [runTests] 5


SELECT * 
  FROM [TestRunTables]

SELECT * 
  FROM [TestRunViews]

SELECT *
  FROM [TestRuns] 
