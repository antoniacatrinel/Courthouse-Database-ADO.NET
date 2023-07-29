USE [courthouse]
GO

-- create a versioning mechanism that allows you to easily switch between database versions

-- SQL scripts

-- modify the type of a column 

-- do
CREATE OR ALTER PROCEDURE [setCountsFromConvictionTinyInt] 
AS
	ALTER TABLE [conviction] ALTER COLUMN [counts] TINYINT
GO

-- undo
CREATE OR ALTER PROCEDURE [setCountsFromConvictionInt] 
AS
	ALTER TABLE [conviction] ALTER COLUMN [counts] INT
GO


-- add/remove a column

-- do
CREATE OR ALTER PROCEDURE [addAgeToPerson]
AS
	ALTER TABLE [person] ADD [age] TINYINT
GO

-- undo
CREATE OR ALTER PROCEDURE [removeAgeFromPerson]
AS
	ALTER TABLE [person] DROP COLUMN [age]
GO


-- add/remove a default constraint

-- do
CREATE OR ALTER PROCEDURE [addDefaultToCountsFromConviction] 
AS
	ALTER TABLE [conviction] ADD CONSTRAINT [DEFAULT_COUNTS] DEFAULT(0) FOR [counts]
GO

-- undo
CREATE OR ALTER PROCEDURE [removeDefaultFromCountsFromConviction] 
AS
	ALTER TABLE [conviction] DROP CONSTRAINT [DEFAULT_COUNTS]
GO


-- create/drop table

-- do
CREATE OR ALTER PROCEDURE [addPrisonTable]
AS
	CREATE TABLE [prison]
	(
		[prisonid] INT NOT NULL,
		[name] VARCHAR(20) NOT NULL,
		[security_class] VARCHAR(20) NOT NULL,
		[wardenid] INT NOT NULL,
		[open_date] DATE NOT NULL,
		[location] VARCHAR(20) NOT NULL,
		[capacity] INT NOT NULL,
		[number_of_inmates] INT NOT NULL,
		[schedule] VARCHAR(20) NOT NULL,
		CONSTRAINT [pk_Prison] PRIMARY KEY([prisonid])
	)
GO

-- undo
CREATE OR ALTER PROCEDURE [dropPrisonTable]
AS
	DROP TABLE [prison]
GO


-- add/remove primary key

-- do
CREATE OR ALTER PROCEDURE [addNameAndSecurityClassPrimaryKeyToPrison]
AS
	ALTER TABLE [prison]
		DROP CONSTRAINT [pk_Prison]

	ALTER TABLE [prison]
		ADD CONSTRAINT [pk_Prison] PRIMARY KEY([name], [security_class])
GO

-- undo
CREATE OR ALTER PROCEDURE [removeNameAndSecurityClassPrimaryKeyFromPrison]
AS
	ALTER TABLE [prison]
		DROP CONSTRAINT [pk_Prison]

	ALTER TABLE [prison]
		ADD CONSTRAINT [pk_Prison] PRIMARY KEY([prisonid])
GO


-- add/remove a candidate key

-- do
CREATE OR ALTER PROCEDURE [addCandidateKeyToPerson]
AS
	ALTER TABLE [person]
		ADD CONSTRAINT [ck_Person] UNIQUE([personid], [ssn])
GO 

-- undo
CREATE OR ALTER PROCEDURE [removeCandidateKeyFromPerson]
AS
	ALTER TABLE [person]
		DROP CONSTRAINT [ck_Person]
GO


-- add/remove a foreign key

-- do
CREATE OR ALTER PROCEDURE [addForeignKeyToPrison]
AS
	ALTER TABLE [prison]
		ADD CONSTRAINT [fk_Prison] FOREIGN KEY([wardenid]) REFERENCES [judge]([judgeid]) 
GO

-- undo
CREATE OR ALTER PROCEDURE [removeForeignKeyFromPrison]
AS
	ALTER TABLE [prison]
		DROP CONSTRAINT [fk_Prison]
GO


-- create a table that contains the current version of the database

CREATE TABLE [version_table]
(
	[version] INT
)


-- insert into version_table the initial version

INSERT INTO [version_table] 
     VALUES (1)


-- create a table that contains the initial version, the version after the execution of the procedure 
-- and the name of the procedure that was called to modify the table 

CREATE TABLE [procedure_table]
(
	[initial_version] INT,
	[final_version] INT,
	[procedure_name] VARCHAR(MAX),
	PRIMARY KEY([initial_version], [final_version])
)


INSERT INTO [procedure_table]
	 VALUES (1, 2, 'setCountsFromConvictionTinyInt'),
		(2, 1, 'setCountsFromConvictionInt'),
		(2, 3, 'addAgeToPerson'),
		(3, 2, 'removeAgeFromPerson'),
		(3, 4, 'addDefaultToCountsFromConviction'),
		(4, 3, 'removeDefaultFromCountsFromConviction'),
		(4, 5, 'addPrisonTable'),
		(5, 4, 'dropPrisonTable'),
		(5, 6, 'addNameAndSecurityClassPrimaryKeyToPrison'),
		(6, 5, 'removeNameAndSecurityClassPrimaryKeyFromPrison'),
		(6, 7, 'addCandidateKeyToPerson'),
		(7, 6, 'removeCandidateKeyFromPerson'),
		(7, 8, 'addForeignKeyToPrison'),
		(8, 7, 'removeForeignKeyFromPrison')
			

-- main procedure to switch between database versions

GO
CREATE OR ALTER PROCEDURE [goToVersion](@new_version INT) 
AS
	DECLARE @current_version INT
	DECLARE @procedure_name VARCHAR(MAX)
	 SELECT @current_version = [version] FROM [version_table]

	IF (@new_version > (SELECT MAX([final_version]) FROM [procedure_table]) OR @new_version < 1)
	BEGIN
		PRINT('Invalid version!')
		RETURN
	END	
	
	IF @new_version = @current_version
		PRINT('You are already in this version!')
	ELSE
	BEGIN
		WHILE @new_version < @current_version 
		BEGIN
			 SELECT @procedure_name = [procedure_name] 
			   FROM [procedure_table] 
			  WHERE [initial_version] = @current_version AND [final_version] = @current_version - 1

			 PRINT('Executing ' + @procedure_name)
			 EXECUTE(@procedure_name)
			 SET @current_version = @current_version - 1
		END

		WHILE @new_version > @current_version 
		BEGIN
			 SELECT @procedure_name = [procedure_name] 
			   FROM [procedure_table] 
			  WHERE [initial_version] = @current_version AND [final_version] = @current_version + 1

			 PRINT('Executing ' + @procedure_name)
			 EXECUTE(@procedure_name)
			 SET @current_version = @current_version + 1
		END
	END

	UPDATE [version_table] 
	   SET [version] = @new_version


SELECT *
  FROM [procedure_table]	
	

SELECT *
  FROM [version_table]

EXECUTE [goToVersion] 1
EXECUTE [goToVersion] 2
EXECUTE [goToVersion] 3
EXECUTE [goToVersion] 4
EXECUTE [goToVersion] 5
EXECUTE [goToVersion] 6
EXECUTE [goToVersion] 7
EXECUTE [goToVersion] 8

SELECT *
  FROM [version_table]
