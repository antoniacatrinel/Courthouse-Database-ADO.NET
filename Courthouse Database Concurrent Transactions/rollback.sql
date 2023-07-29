USE [courthouse]
GO

-- Create a stored procedure that inserts data in tables that are in a m:n relationship. If one insert
-- fails, all the operations performed by the procedure must be rolled back. (grade: 3)

DROP TABLE IF EXISTS LogTable 

CREATE TABLE LogTable (
	Lid INT IDENTITY PRIMARY KEY,
	TypeOperation VARCHAR(50),
	TableOperation VARCHAR(50),
	LogStatus VARCHAR(50),
	ExecutionDate DATETIME
)
GO

-- COURTROOM
CREATE FUNCTION uf_ValidateCourtroom (@address VARCHAR(20), @capacity INT, @no_trials INT, @schedule VARCHAR(20)) RETURNS VARCHAR(MAX) 
AS
BEGIN
	DECLARE @errors VARCHAR(MAX) = ''

	-- Check for presence of address
	IF (@address IS NULL OR @address = '')
	BEGIN
		SET @errors += 'Address cannot be empty.' + CHAR(13)
	END

	-- Check for length of address
	IF (LEN(@address) > 20)
	BEGIN
		SET @errors += 'Address cannot be longer than 20 characters.' + CHAR(13)
	END

	-- Check for presence of capacity
	IF (@capacity IS NULL)
	BEGIN
		SET @errors += 'Capacity cannot be empty.' + CHAR(13)
	END

	-- Check for capacity range
	IF (@capacity < 1 OR @capacity > 10000)
	BEGIN
		SET @errors += 'Capacity must be between 1 and 10000.' + CHAR(13)
	END

	-- Check for uniqueness of capacity
    IF EXISTS (
        SELECT *
        FROM [courtroom]
        WHERE [capacity] = @capacity
    )
    BEGIN
        SET @errors += 'Capacity must be unique.' + CHAR(13)
    END

	-- Check for no_trials range
	IF (@no_trials < 0 OR @no_trials > 10000)
	BEGIN
		SET @errors += 'Number of trials must be between 0 and 10000.' + CHAR(13)
	END

	-- Check for presence of schedule
	IF (@schedule IS NULL OR @schedule = '')
	BEGIN
		SET @errors += 'Schedule cannot be empty.' + CHAR(13)
	END

	-- Check for length of schedule
	IF (LEN(@schedule) > 20)
	BEGIN
		SET @errors += 'Schedule cannot be longer than 20 characters.' + CHAR(13)
	END

	-- Check for the format of schedule (hh-hh or h-hh)
    ELSE IF ((@schedule NOT LIKE '[0-9][0-9]-[0-9][0-9]' AND @schedule NOT LIKE '[0-9]-[0-9][0-9]'))
    BEGIN
        SET @errors += 'Invalid schedule format. Schedule should be in the format hh-hh.' + CHAR(13)
    END

	RETURN @errors
END
GO

CREATE OR ALTER PROCEDURE AddCourtroom @address VARCHAR(20), @capacity INT, @no_trials INT, @schedule VARCHAR(20) 
AS
BEGIN	
    DECLARE @errors VARCHAR(MAX)
    SET @errors = dbo.uf_ValidateCourtroom(@address, @capacity, @no_trials, @schedule)
	
	IF(@errors IS NOT NULL AND @errors <> '')
	BEGIN
		RAISERROR('%s', 14, 1, @errors)
	END

	INSERT INTO [courtroom] ([address], [capacity], [no_trials], [schedule]) VALUES (@address, @capacity, @no_trials, @schedule)
	INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'courtroom', 'uncommited', GETDATE())
END
GO

-- COURT_CASE
CREATE FUNCTION uf_ValidateCourtCase (@case_type VARCHAR(20), @case_status VARCHAR(20), @crime VARCHAR(20), @no_victims INT, @start_date DATE, @end_date DATE) RETURNS VARCHAR(MAX) 
AS
BEGIN
	DECLARE @errors VARCHAR(MAX) = ''

	-- Check for presence of case_type
    IF (@case_type IS NULL OR @case_type = '')
    BEGIN
        SET @errors += 'Case type cannot be empty.' + CHAR(13)
    END
	ELSE
	BEGIN
		-- Check if case_type is either criminal or civil
		IF (LOWER(@case_type) NOT IN ('criminal', 'civil'))
		BEGIN
			SET @errors += 'Case type can only be criminal or civil.' + CHAR(13)
		END
	END

    -- Check for presence of case_status
    IF (@case_status IS NULL OR @case_status = '')
    BEGIN
        SET @errors += 'Case status cannot be empty.' + CHAR(13)
    END
	ELSE
	BEGIN
		-- Check if case_status is either ongoing or solved
		IF (LOWER(@case_status) NOT IN ('ongoing', 'solved'))
		BEGIN
			SET @errors += 'Case status can only be ongoing or solved.' + CHAR(13)
		END
	END

    -- Check for presence of crime
    IF (@crime IS NULL OR @crime = '')
    BEGIN
        SET @errors += 'Crime cannot be empty.' + CHAR(13)
    END

	-- Check for length of crime
	IF (LEN(@crime) > 20)
	BEGIN
		SET @errors += 'Crime cannot be longer than 20 characters.' + CHAR(13)
	END

    -- Check for valid no_victims value
    IF (@no_victims IS NOT NULL AND @no_victims < 0)
    BEGIN
        SET @errors += 'Number of victims cannot be negative.' + CHAR(13)
    END

    -- Check for presence of start_date
    IF (@start_date IS NULL)
    BEGIN
        SET @errors += 'Start date cannot be empty.' + CHAR(13)
    END
	ELSE
	BEGIN
        -- Check that start_date is in the format yyyy-mm-dd
        IF (TRY_CONVERT(DATE, @start_date) IS NULL)
        BEGIN
            SET @errors += 'Start date must be in the format yyyy-mm-dd.' + CHAR(13)
        END
		ELSE
		BEGIN
			-- Check that start_date is in the past
			IF (@start_date > GETDATE())
			BEGIN
				SET @errors += 'Start date must be in the past.' + CHAR(13)
			END
		END
	END

    -- Check that end_date is greater than or equal to start_date if provided
    IF (@end_date IS NOT NULL AND @end_date <> '' AND @end_date < @start_date)
    BEGIN
        SET @errors += 'End date cannot be earlier than the start date.' + CHAR(13)

		-- Check that end_date is in the format yyyy-mm-dd
        IF (TRY_CONVERT(DATE, @end_date) IS NULL)
        BEGIN
            SET @errors += 'End date must be in the format yyyy-mm-dd.' + CHAR(13)
        END
    END

	RETURN @errors
END
GO

CREATE OR ALTER PROCEDURE AddCourtCase @case_type VARCHAR(20), @case_status VARCHAR(20), @crime VARCHAR(20), @no_victims INT, @start_date DATE, @end_date DATE
AS
BEGIN	
    DECLARE @errors VARCHAR(MAX)
    SET @errors = dbo.uf_ValidateCourtCase(@case_type, @case_status, @crime, @no_victims, @start_date, @end_date)
	
	IF(@errors IS NOT NULL AND @errors <> '')
	BEGIN
		RAISERROR('%s', 14, 1, @errors)
	END

	INSERT INTO [court_case] ([case_type], [case_status], [crime], [no_victims], [start_date], [end_date]) VALUES (@case_type, @case_status, @crime, @no_victims, @start_date, @end_date)
	INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'court_case', 'uncommited', GETDATE())
END
GO

-- TRIAL
CREATE FUNCTION uf_ValidateTrial (@trial_status VARCHAR(20), @date DATE, @time TIME, @sentence VARCHAR(50), @remarks VARCHAR(50)) RETURNS VARCHAR(MAX) 
AS
BEGIN
	DECLARE @errors VARCHAR(MAX) = ''

	-- Check for presence of trial_status
    IF (@trial_status IS NULL OR @trial_status = '')
    BEGIN
        SET @errors += 'Trial status cannot be empty.' + CHAR(13)
    END

	-- Check if trial_status is either ongoing or ended
	IF (LOWER(@trial_status) NOT IN ('ongoing', 'ended'))
	BEGIN
        SET @errors += 'Trial status can only be ongoing or ended.' + CHAR(13)
    END

    -- Check for presence of date
    IF (@date IS  NOT NULL)
    BEGIN
        -- Check that date is in the format yyyy-mm-dd
        IF (TRY_CONVERT(DATE, @date) IS NULL)
        BEGIN
            SET @errors += 'Date must be in the format yyyy-mm-dd.' + CHAR(13)
        END
        ELSE
		BEGIN
			-- Check that date is in the past
			IF (@date > GETDATE())
			BEGIN
				SET @errors += 'Date must be in the past.' + CHAR(13)
			END
		END
	END

    -- Check for presence of time
    IF (@time IS NOT NULL)
    BEGIN
        -- Check that time is in the format hh:mm:ss
        IF (TRY_CONVERT(TIME, @time) IS NULL)
        BEGIN
            SET @errors += 'Time must be in the format hh:mm:ss.' + CHAR(13)
        END
		ELSE
        BEGIN
            -- Check that time is between 9:00 AM and 5:00 PM
            IF (@time < '09:00:00' OR @time > '17:00:00')
            BEGIN
                SET @errors += 'Time must be between 9:00 AM and 5:00 PM.' + CHAR(13)
            END
        END
	END

    -- Check for presence of sentence
    IF (LOWER(@trial_status) = 'ended' AND (@sentence IS NULL OR @sentence = ''))
    BEGIN
        SET @errors += 'Sentence cannot be empty if trial ended.' + CHAR(13)
    END

	IF (@sentence IS NOT NULL AND LEN(@sentence) > 50)
	BEGIN
		SET @errors += 'Sentence cannot be longer than 50 characters.' + CHAR(13)
	END

	IF (@remarks IS NOT NULL AND LEN(@remarks) > 50)
	BEGIN
		SET @errors += 'Remarks cannot be longer than 50 characters.' + CHAR(13)
	END

	RETURN @errors
END
GO

CREATE OR ALTER PROCEDURE AddTrial @trial_status VARCHAR(20), @date DATE, @time TIME, @sentence VARCHAR(50), @remarks VARCHAR(50) 
AS
BEGIN
    DECLARE @errors VARCHAR(MAX)
    SET @errors = dbo.uf_ValidateTrial(@trial_status, @date, @time, @sentence, @remarks)
	
	IF(@errors IS NOT NULL AND @errors <> '')
	BEGIN
		RAISERROR('%s', 14, 1, @errors)
	END

	DECLARE @caseid INT = (SELECT MAX(caseid) FROM [court_case])
	DECLARE @roomid INT = (SELECT MAX(roomid) FROM [courtroom])

	INSERT INTO [trial] ([caseid], [roomid], [trial_status], [date], [time], [sentence], [remarks]) VALUES (@caseid, @roomid, @trial_status, @date, @time, @sentence, @remarks)
	INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'trial', 'uncommited', GETDATE())
END
GO

-- testing scenarios
CREATE OR ALTER PROCEDURE SuccessfullInsertRollback AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
		EXEC AddCourtroom '92 Harlow Street', 1000, 40, '12-14'
		EXEC AddCourtCase 'criminal', 'ongoing', 'first-degree murder', 2, '2017-10-10', ''
		EXEC AddTrial 'ongoing', '2022-08-01', '11:00:00', '', 'defendant pleaded not guilty'
		COMMIT TRAN
		SELECT 'Transaction committed'
		INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'courtroom, court_case, trial', 'commited', GETDATE())
	END TRY
	BEGIN CATCH       -- if one transaction fails, rollback everything
		ROLLBACK TRAN
		SELECT 'Transaction rollbacked' + ERROR_MESSAGE() as ErrorMessage
		INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'courtroom, court_case, trial', 'rollbacked', GETDATE())
		RETURN
	END CATCH	
END
GO

CREATE OR ALTER PROCEDURE FailedInsertRollback AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
		EXEC AddCourtroom '56 Chicago Street', 2450, 25, '11-16'
		EXEC AddCourtCase 'criminal', 'ended', 'first-degree murder', 2, '2017-10-10', ''
		EXEC AddTrial 'done', '2021-09-08', '05:00:00', '', ''
		COMMIT TRAN
		SELECT 'Transaction committed'
		INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'courtroom, court_case, trial', 'commited', GETDATE())
	END TRY
	BEGIN CATCH       -- if one transaction fails, rollback everything
		ROLLBACK TRAN
		SELECT 'Transaction rollbacked' + ERROR_MESSAGE() as ErrorMessage
		INSERT INTO [LogTable] ([TypeOperation], [TableOperation], [LogStatus], [ExecutionDate]) VALUES ('insert', 'courtroom, court_case, trial', 'rollbacked', GETDATE())
		RETURN
	END CATCH
END
GO

SELECT * FROM [LogTable]
SELECT * from [courtroom]
SELECT * from [court_case]
SELECT * from [trial]

EXEC SuccessfullInsertRollback
EXEC FailedInsertRollback

SELECT * FROM [LogTable]
SELECT * from [courtroom]
SELECT * from [court_case]
SELECT * from [trial]

