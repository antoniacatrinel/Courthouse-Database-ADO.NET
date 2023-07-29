USE [courthouse]
GO

-- Create 4 scenarios that reproduce the following concurrency issues under pessimistic isolation
-- levels: dirty reads, non-repeatable reads, phantom reads, and a deadlock; you can use stored
-- procedures and / or stand-alone queries; find solutions to solve / workaround the concurrency
-- issues. (grade 9)

-- COURTROOM
SELECT * FROM [courtroom]

-- DIRTY READS – T1: 1 update + delay + rollback, T2: select + delay + select -> we see the
-- update in the first select (T1 – finish first), even if it is rollback then
-- Isolation level: Read Uncommitted / Read Committed (solution)

-- DIRTY READS T1
-- try to update and rollback after a 10s delay
BEGIN TRAN
UPDATE [courtroom] SET [address] = '77 Yellow Street'
WHERE [roomid] = 7
WAITFOR DELAY '00:00:10'
ROLLBACK TRAN
