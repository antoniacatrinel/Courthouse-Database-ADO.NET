USE [courthouse]
GO

-- Create a stored procedure that inserts data in tables that are in a m:n relationship; if an insert fails,
-- try to recover as much as possible from the entire operation: for example, if the user wants to add
-- a book and its authors, succeeds creating the authors, but fails with the book, the authors should
-- remain in the database. (grade 5)

CREATE OR ALTER PROCEDURE AddCourtroomTransactional @address VARCHAR(20), @capacity INT, @no_trials INT, @schedule VARCHAR(20) 
AS
BEGIN	
    DECLARE @errors VARCHAR(MAX)
    SET @errors = dbo.uf_ValidateCourtroom(@address, @capacity, @no_trials, @schedule)

	BEGIN TRAN
	BEGIN TRY
		IF(@errors IS NOT NULL AND @errors <> '')
		BEGIN
			RAISERROR('%s', 14, 1, @errors)
		END

		INSERT INTO [courtroom] ([address], [capacity], [no_trials], [schedule]) VALUES (@address, @capacity, @no_trials, @schedule)

		COMMIT TRAN
		SELECT 'Transaction committed'
		INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'courtroom', 'commited', GETDATE())
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Transaction rollbacked' + ERROR_MESSAGE() as ErrorMessage
		INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'courtroom', 'rollbacked', GETDATE())
		RETURN
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE AddCourtCaseTransactional @case_type VARCHAR(20), @case_status VARCHAR(20), @crime VARCHAR(20), @no_victims INT, @start_date DATE, @end_date DATE
AS
BEGIN	
    DECLARE @errors VARCHAR(MAX)
    SET @errors = dbo.uf_ValidateCourtCase(@case_type, @case_status, @crime, @no_victims, @start_date, @end_date)
	
	BEGIN TRAN
	BEGIN TRY
		IF(@errors IS NOT NULL AND @errors <> '')
		BEGIN
			RAISERROR('%s', 14, 1, @errors)
		END

		INSERT INTO [court_case] ([case_type], [case_status], [crime], [no_victims], [start_date], [end_date]) VALUES (@case_type, @case_status, @crime, @no_victims, @start_date, @end_date)

		COMMIT TRAN
		SELECT 'Transaction committed'
		INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'court_case', 'commited', GETDATE())
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Transaction rollbacked' + ERROR_MESSAGE() as ErrorMessage
		INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'court_case', 'rollbacked', GETDATE())
		RETURN
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE AddTrialTransactional @trial_status VARCHAR(20), @date DATE, @time TIME, @sentence VARCHAR(50), @remarks VARCHAR(50) 
AS
BEGIN
    DECLARE @errors VARCHAR(MAX)
    SET @errors = dbo.uf_ValidateTrial(@trial_status, @date, @time, @sentence, @remarks)
	
	BEGIN TRAN
	BEGIN TRY
		IF(@errors IS NOT NULL AND @errors <> '')
		BEGIN
			RAISERROR('%s', 14, 1, @errors)
		END

		DECLARE @caseid INT = (SELECT MAX(caseid) FROM [court_case])
		DECLARE @roomid INT = (SELECT MAX(roomid) FROM [courtroom])

		INSERT INTO [trial] ([caseid], [roomid], [trial_status], [date], [time], [sentence], [remarks]) VALUES (@caseid, @roomid, @trial_status, @date, @time, @sentence, @remarks)

		COMMIT TRAN
		SELECT 'Transaction committed'
		INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'trial', 'commited', GETDATE())
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Transaction rollbacked' + ERROR_MESSAGE() as ErrorMessage
		INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'trial', 'rollbacked', GETDATE())
		RETURN
	END CATCH
END
GO

-- testing scenarios
CREATE OR ALTER PROCEDURE SuccessfullInsertNoRollback AS
BEGIN
	EXEC AddCourtroomTransactional '33 Honey Street', 500, 10, '10-18'
	EXEC AddCourtCaseTransactional 'civil', 'ongoing', 'robbery', 3, '2020-02-03', ''
	EXEC AddTrialTransactional 'ended', '2003-05-05', '16:00:00', '6 years imprisonment', 'defendant pleaded guilty'
END
GO

CREATE OR ALTER PROCEDURE FailedInsertNoRollback AS
BEGIN
	EXEC AddCourtroomTransactional '30 Marlyn Street', 400, 5, '10-12'
	EXEC AddCourtCaseTransactional 'type', 'done', '', -4, '2017-10-10', '2016-10-10'
	EXEC AddTrialTransactional 'done', '2021-09-08', '05:00:00', '', ''
END
GO

SELECT * FROM [LogTable]
SELECT * from [courtroom]
SELECT * from [court_case]
SELECT * from [trial]

EXEC SuccessfullInsertNoRollback
EXEC FailedInsertNoRollback

SELECT * FROM [LogTable]
SELECT * from [courtroom]
SELECT * from [court_case]
SELECT * from [trial]
