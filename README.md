# Courthouse Database ADO.NET

# [Courthouse Database](https://github.com/antoniacatrinel/Courthouse-Database-ADO.NET/tree/main/Courthouse%20Database)

TSQL database used for managing a courthouse (judges, prosecutors, attorneys, court rooms, trails, cases, lawsuits, evidence, staff etc.). 
For more details, check: [Courthouse Database TSQL](https://github.com/antoniacatrinel/Courthouse-Database-TSQL).

# [Courthouse Database ADO.NET](https://github.com/antoniacatrinel/Courthouse-Database-ADO.NET/tree/main/Courthouse%20WindowsForms%20ADO.NET)

Create a **C# Windows Forms** application that uses **ADO.NET** to interact with your database. The application must contain a form allowing the user to manipulate data in 2 tables that are in a 1:n relationship (parent table and child table). The application must provide the following functionalities:
- display all the records in the parent table;
- display the child records for a specific (i.e., selected) parent record;
- `add` / `remove` / `update` child records for a specific parent record.

The application should dynamically create the master-detail windows form. The form caption and stored procedures / queries used to access and manipulate data will be set in a configuration file.

The two different scenarios handling data from two different 1:n relationships can be found in the configuration file.

The form should be generic enough such that switching between scenarios (i.e., updating the application to handle data from another 1:n relationship) can be achieved by simply updating the configuration file.

# [Courthouse Database Concurrent Transactions](https://github.com/antoniacatrinel/Courthouse-Database-ADO.NET/tree/main/Courthouse%20Database%20Concurrent%20Transactions)

Prepare the following scenarios for your database:

- create a stored procedure that inserts data in tables that are in a m:n relationship; if one insert fails, all the operations performed by the procedure must be rolled back;
- create a stored procedure that inserts data in tables that are in a m:n relationship; if an insert fails, try to recover as much as possible from the entire operation: for example, if the user wants to add a book and its authors, succeeds creating the authors, but fails with the book, the authors should remain in the database;
- reproduce the following **concurrency issues** under pessimistic isolation levels: `dirty reads`, `non-repeatable reads`, `phantom reads`, and a `deadlock` (4 different scenarios); you can use stored procedures and / or stand-alone queries; find solutions to solve / workaround the concurrency issues;
reproduce the update conflict under an optimistic isolation level.

Prepare test cases covering both the happy scenarios and the ones with errors (this applies to stored procedures).

Don’t use IDs as input parameters for your stored procedures. Validate all parameters (try to use functions when needed).

Setup a logging system to track executed actions for all scenarios and handle all errors.
