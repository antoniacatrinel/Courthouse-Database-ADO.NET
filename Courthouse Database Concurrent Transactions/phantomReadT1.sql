USE [courthouse]
GO

-- Create 4 scenarios that reproduce the following concurrency issues under pessimistic isolation
-- levels: dirty reads, non-repeatable reads, phantom reads, and a deadlock; you can use stored
-- procedures and / or stand-alone queries; find solutions to solve / workaround the concurrency
-- issues. (grade 9)

-- COURTROOM
SELECT * FROM [courtroom]

-- PHANTOM READS – T1: delay + insert + commit, T2: select + delay + select -> see the inserted
-- value only at the second select from T2, T1 finish first. The result will contain the previous row
-- version; the same number of rows (before the finish of the transaction – for example, 5 not 6).
-- Isolation level: Repeatable Read / Serializable (solution)

-- PHANTOM READS T1
BEGIN TRAN
WAITFOR DELAY '00:00:04'
INSERT INTO [courtroom] ([address], [capacity], [no_trials], [schedule]) 
VALUES ('45 Flower Avenue', 1200, 10, '10-16')
COMMIT TRAN

--DELETE FROM [courtroom] WHERE [roomid]=14