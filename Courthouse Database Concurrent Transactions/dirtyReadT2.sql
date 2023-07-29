USE [courthouse]
GO

-- Create 4 scenarios that reproduce the following concurrency issues under pessimistic isolation
-- levels: dirty reads, non-repeatable reads, phantom reads, and a deadlock; you can use stored
-- procedures and / or stand-alone queries; find solutions to solve / workaround the concurrency
-- issues. (grade 9)

-- COURTROOM
SELECT * FROM [courtroom]

-- DIRTY READS T2
-- dirty read will happen because we can read uncommitted changes
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
SELECT * FROM [courtroom]
WAITFOR DELAY '00:00:15'
SELECT * FROM [courtroom]
COMMIT TRAN

-- solution: T1: 1 update + delay + rollback, T2: select + delay + select -> we don’t see the update (that is also rollback) – T1 finishes first
-- solution: set transaction isolation level to read commited
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT * FROM [courtroom]
WAITFOR DELAY '00:00:15'
SELECT * FROM [courtroom]
COMMIT TRAN
