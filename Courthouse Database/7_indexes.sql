USE [courthouse]
GO

/* Work on 3 tables of the form Ta(*aid, a2, …), Tb(*bid, b2, …), Tc(*cid, aid, bid, …), where:
     - aid, bid, cid, a2, b2 are integers;
     - the primary keys have *;
	 - a2 is UNIQUE in Ta;
     - aid and bid are foreign keys in Tc, referencing the primary keys in Ta and Tb, respectively.

 Ta(*aid, a2, …): table [courtroom]([roomid] INT PRIMARY KEY IDENTITY, [address] VARCHAR(20) NOT NULL, [capacity] INT NOT NULL UNIQUE, [no_trials] INT,
									[schedule] VARCHAR(20) NOT NULL)

 Tb(*bid, b2, …): table [court_case]([caseid] INT PRIMARY KEY IDENTITY, [case_type] VARCHAR(20) NOT NULL, [case_status] VARCHAR(20) NOT NULL, [crime] VARCHAR(20) NOT NULL,
                                     [no_victims] INT, [start_date] DATE NOT NULL, [end_date] DATE)

 Tc(*cid, aid, bid, …): table [trial]([trialid] INT PRIMARY KEY IDENTITY, [caseid] INT FOREIGN KEY REFERENCES [court_case]([caseid]) NOT NULL,
									  [roomid] INT FOREIGN KEY REFERENCES [courtroom]([roomid]) NOT NULL, [trial_status] VARCHAR(20) NOT NULL,
									  [date] DATE, [time] TIME, [sentence] VARCHAR(50), [remarks] VARCHAR(50))

- a clustered index was automatically created for the aid column from Ta
- a nonclustered index was automatically created for the a2 column from Ta
- a clustered index was automatically created for the bid column from Tb
- a clustered index was automatically created for the cid column from Tc
*/

-- procedure that generates and inserts random data into table courtroom
GO
CREATE OR ALTER PROCEDURE [insertIntoCourtroom](@rows INT) AS
BEGIN
	DECLARE @max INT
	SET @max = @rows * 2 + 10
	WHILE @rows > 0
	BEGIN
		INSERT INTO [courtroom]([address], [capacity], [no_trials], [schedule]) 
		     VALUES ('street', @rows, @max, '10-18')
		SET @rows = @rows - 1
		SET @max = @max - 2
	END
END


-- procedure that generates and inserts random data into table court_case
GO
CREATE OR ALTER PROCEDURE insertIntoCourtCase(@rows INT) AS
BEGIN
	WHILE @rows > 0 
	BEGIN
		INSERT INTO [court_case]([case_type], [case_status], [crime], [no_victims], [start_date], [end_date]) 
			 VALUES ('criminal', 'ongoing', 'murder', @rows, '2017-10-10', '')
		SET @rows = @rows - 1
	END
END


-- procedure that generates and inserts random data into table trial
GO
CREATE OR ALTER PROCEDURE insertIntoTrial(@rows INT) AS
BEGIN
	DECLARE @roomid INT
	DECLARE @caseid INT
	WHILE @rows > 0
	BEGIN
		SET @roomid = (SELECT TOP 1 [roomid] FROM [courtroom] ORDER BY NEWID())
		SET @caseid = (SELECT TOP 1 [caseid] FROM [court_case] ORDER BY NEWID())
		INSERT INTO [trial]([caseid], [roomid], [trial_status], [date], [time], [sentence], [remarks]) 
			 VALUES (@caseid, @roomid, 'ongoing', '2022-08-08', '09:00:00', '', 'remarks')
		SET @rows = @rows - 1
	END
END


-- insert data into tables
EXEC [insertIntoCourtroom] 5000
EXEC [insertIntoCourtCase] 6000
EXEC [insertIntoTrial] 3000

SELECT *
  FROM [courtroom]

SELECT *
  FROM [court_case]

SELECT *
  FROM [trial]

-- a. Write queries on Ta such that their execution plans contain the following operators:

-- clustered index scan -> scan the entire table
-- cost: 0.0258267

SELECT *
  FROM [courtroom]

-- clustered index seek -> return a specific subset of rows from a clustered index
-- cost: 0.0258267

SELECT *
  FROM [courtroom]
 WHERE [roomid] <= 200

-- nonclustered index scan -> scan the entire nonclustered index
-- cost: 0.0147156

  SELECT [capacity]
    FROM [courtroom]
ORDER BY [capacity]

-- nonclustered index seek -> return a specific subset of rows from a nonclustered index
-- cost: 0.0034481

SELECT [capacity]
  FROM [courtroom]
 WHERE [capacity] BETWEEN 150 AND 300

-- key lookup - nonclustered index seek + key lookup -> data is found in a nonclustered index, but additional data is needed
-- cost: 0.0065704

SELECT [address], [capacity]
  FROM [courtroom]
 WHERE [capacity] = 400

-- b. Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan.
-- Create a nonclustered index that can speed up the query. Examine the execution plan again.

-- cost: 0.0380422

SELECT *
  FROM [court_case]
 WHERE [no_victims] = 6

-- create nonclustered index

CREATE NONCLUSTERED INDEX [court_case_no_victims_index] ON [court_case]([no_victims])
DROP INDEX [court_case_no_victims_index] ON [court_case]

-- with index: cost: 0.0071014

SELECT * 
  FROM sys.indexes
 WHERE object_id = (SELECT object_id FROM sys.objects WHERE NAME = 'court_case')

-- c. Create a view that joins at least 2 tables. Check whether existing indexes are helpful; if not, reassess existing indexes / examine the cardinality of the tables.
GO
CREATE OR ALTER VIEW [NewView] 
AS
	SELECT [CR].[roomid], [CC].[caseid], [T].[trialid]
	FROM [trial] [T]
	INNER JOIN [courtroom] [CR] ON [CR].[roomid] = [T].[roomid]
	INNER JOIN [court_case] [CC] ON [CC].[caseid] = [T].[caseid]
	WHERE [CC].[no_victims] > 1 AND [CR].[no_trials] < 400
GO

SELECT *
  FROM [NewView]


-- with existing indexes(the automatically created ones + nonclustered index on [court_house]): 0.14899
-- when adding a nonclustered index on a3 to the existing indexes: 0.124264
-- without the nonclustered index on b2 and the nonclustered index on a3: 0.172617
-- automatically created indexes + nonclustered index on b2 + nonclustered index on a3 + nonclustered index on (aid, bid) from Tc: 0.139712

CREATE NONCLUSTERED INDEX [courtroom_no_trials_index] ON [courtroom]([no_trials])
DROP INDEX [courtroom_no_trials_index] ON [courtroom]

CREATE NONCLUSTERED INDEX [trial_index] ON [trial]([roomid], [caseid])
DROP INDEX [trial_index] ON [trial]
