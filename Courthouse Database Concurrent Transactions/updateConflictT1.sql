USE [courthouse]
GO

-- Create a scenario that reproduces the update conflict under an optimistic isolation level. (grade 10)

-- COURTROOM
SELECT * FROM [courtroom]

ALTER DATABASE [courthouse] SET ALLOW_SNAPSHOT_ISOLATION ON

-- UPDATE CONFLICT T1
WAITFOR DELAY '00:00:10'
BEGIN TRAN
UPDATE [courtroom] SET [address] = '1 Monroe Avenue' WHERE [roomid] = 5
-- address is now 1 Monroe Avenue
WAITFOR DELAY '00:00:10'
COMMIT TRAN

-- ALTER DATABASE [courthouse] SET ALLOW_SNAPSHOT_ISOLATION OFF
