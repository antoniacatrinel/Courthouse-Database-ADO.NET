USE [courthouse]
GO

-- Create 4 scenarios that reproduce the following concurrency issues under pessimistic isolation
-- levels: dirty reads, non-repeatable reads, phantom reads, and a deadlock; you can use stored
-- procedures and / or stand-alone queries; find solutions to solve / workaround the concurrency
-- issues. (grade 9)

-- COURTROOM
SELECT * FROM [courtroom]

-- NON-REPEATABLE READS T2
-- different result in the two selects
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT * FROM [courtroom]
WAITFOR DELAY '00:00:05'
SELECT * FROM [courtroom]
COMMIT TRAN

-- solution: T1: insert + delay + update + commit, T2: select + delay + select -> see only the final result in
-- both of the select of T2, T1 finish first
-- only the final result in both selects
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT * FROM [courtroom]
WAITFOR DELAY '00:00:05'
SELECT * FROM [courtroom]
COMMIT TRAN
