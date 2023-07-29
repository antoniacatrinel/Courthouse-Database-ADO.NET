USE [courthouse]
GO

-- Create 4 scenarios that reproduce the following concurrency issues under pessimistic isolation
-- levels: dirty reads, non-repeatable reads, phantom reads, and a deadlock; you can use stored
-- procedures and / or stand-alone queries; find solutions to solve / workaround the concurrency
-- issues. (grade 9)

-- COURTROOM
SELECT * FROM [courtroom]

-- NON-REPEATABLE READS – T1: insert + delay + update + commit, T2: select + delay +
-- select -> see the insert in first select of T2 + update in the second select of T2, T1 finish first
-- Isolation level: Read Committed / Repeatable Read (solution). The result will contain the previous
-- row version (before the finish of the transaction).

-- NON-REPEATABLE READS T1
INSERT INTO [courtroom] ([address], [capacity], [no_trials], [schedule]) 
VALUES ('2002 Jacobs Avenue', 2300, 3, '10-12')
BEGIN TRAN
WAITFOR DELAY '00:00:05'
UPDATE [courtroom] SET [schedule] = '14-18' 
WHERE [address] = '2002 Jacobs Avenue'
COMMIT TRAN

--DELETE FROM [courtroom] WHERE [roomid]=11
