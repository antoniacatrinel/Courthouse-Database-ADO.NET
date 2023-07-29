USE [courthouse]
GO

-- Create 4 scenarios that reproduce the following concurrency issues under pessimistic isolation
-- levels: dirty reads, non-repeatable reads, phantom reads, and a deadlock; you can use stored
-- procedures and / or stand-alone queries; find solutions to solve / workaround the concurrency
-- issues. (grade 9)

-- COURTROOM
SELECT * FROM [courtroom]

-- COURT_CASE
SELECT * FROM [court_case]

-- DEADLOCK T2
SET DEADLOCK_PRIORITY LOW
BEGIN TRAN
UPDATE [court_case] SET [crime] = 'bribery' WHERE [caseid] = 1
-- this transaction has exclusively lock on table court_case
WAITFOR DELAY '00:00:10'
UPDATE [courtroom] SET [address] = '2 Sixteen Avenue' WHERE [roomid] = 1
-- this transaction will be blocked because transaction 1 has exclusively lock on table Books, so, both of the transactions are blocked
COMMIT TRAN
-- after some seconds transaction 2 will be chosen as a deadlock victim and terminates with an error
-- in tables courtroom and court_case will be the values from transaction 1


-- solution : choose T1 as the victim by increasing T2's priority
-- For deadlock, the priority has to be set (LOW, NORMAL, HIGH, or from -10 to 10). Implicit
-- is NORMAL (0). For example, here we set the DEADLOCK_PRIORITY to HIGH for T2, so that T1 be chosen as a
-- deadlock victim (T1 will have a lower priority than T2 and it will finish first).
SET DEADLOCK_PRIORITY HIGH
BEGIN TRAN 
UPDATE [court_case] SET [crime] = 'bribery' WHERE [caseid] = 1
WAITFOR DELAY '00:00:10'
UPDATE [courtroom] SET [address] = '2 Sixteen Avenue' WHERE [roomid] = 1
COMMIT TRAN
-- this transaction has the higher priority level from here (set to HIGH)
-- transaction 1 finishes with an error, and the results are the ones from this transaction (transaction 2)

-- another possible solution for Deadlock is to execute the statements in the same order in both of the transactions.