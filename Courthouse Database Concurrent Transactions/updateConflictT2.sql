USE [courthouse]
GO

-- Create a scenario that reproduces the update conflict under an optimistic isolation level. (grade 10)

-- COURTROOM
SELECT * FROM [courtroom]

-- UPDATE CONFLICT T2
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRAN
SELECT * FROM [courtroom] WHERE [roomid] = 5
-- value '3294 Lyndon Street' is returned because T1 has not yet reached the update because of the 10s delay
WAITFOR DELAY '00:00:10'
SELECT * FROM [courtroom] WHERE [roomid] = 5
-- now when trying to update the same resource that T1 has updated and obtained a lock on, =
UPDATE [courtroom] SET [address] = '2 Monroe Avenue' WHERE [roomid] = 5
-- process will block
-- process will receive Error 3960
COMMIT TRAN
