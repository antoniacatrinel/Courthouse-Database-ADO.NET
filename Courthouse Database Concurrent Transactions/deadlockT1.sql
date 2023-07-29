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

-- DEADLOCK – T1: update on table A + delay + update on table B, T2: update on table B + delay + update on table A
-- We update on table A (from T1 – that exclusively lock on table A), update on table B (from T2 – that
-- exclusively lock on table B), try to update from T1 table B (but this transaction will be blocked because
-- T2 has already been locked on table B), try to update from T2 table A (but this transaction will be
-- blocked because T1 has already been locked on table A). So, both of the transactions are blocked. After
-- some seconds T2 will be chosen as a deadlock victim and terminates with an error. After that, T1 will
-- finish also. In table A and table B will be the values from T1.
-- The transaction that is chosen as a deadlock victim, is the one that has the deadlock_priority lower. If
-- both of the transactions have the same deadlock_priority, the deadlock victim is the one less expensive
-- at rollback. Otherwise, the deadlock victim is chosen random.

-- DEADLOCK T1
BEGIN TRAN
UPDATE [courtroom] SET [address] = '1 Sixteen Avenue' WHERE [roomid] = 1
-- this transaction has exclusively lock on table courtroom
WAITFOR DELAY '00:00:10'
UPDATE [court_case] SET [crime] = 'kidnapping' WHERE [caseid] = 1
-- this transaction will be blocked because transaction 2 has already blocked our lock on table crime
COMMIT TRAN
-- this transaction is chose as a deadlock, because it has the lowest priority level here (normal)
