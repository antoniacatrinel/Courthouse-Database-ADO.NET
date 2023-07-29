-- create database
USE master
GO

ALTER DATABASE [courthouse] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

DROP DATABASE IF EXISTS [courthouse]
GO

CREATE DATABASE [courthouse]
GO

USE [courthouse]
GO


-- create tables
CREATE TABLE [person]
(
	[personid] INT PRIMARY KEY IDENTITY,
	[ssn] VARCHAR(10) NOT NULL UNIQUE, 
	[first_name] VARCHAR(20) NOT NULL,
	[last_name] VARCHAR(20) NOT NULL,
	[birth_date] DATE NOT NULL,
	[gender] VARCHAR(10) NOT NULL CHECK (gender = 'male' OR gender = 'female'),
	[address] VARCHAR(20) NOT NULL,
	[email] VARCHAR(30) NOT NULL UNIQUE,
	[phone] VARCHAR(12) NOT NULL UNIQUE,
	[occupation] VARCHAR(30) NOT NULL,
	[record] VARCHAR(50) NOT NULL
)

CREATE TABLE [person_status]
(
	[statusid] INT PRIMARY KEY IDENTITY,
	[person_type] VARCHAR(20) NOT NULL
)

CREATE TABLE [judge]
(
	[judgeid] INT PRIMARY KEY IDENTITY,
	[ssn] VARCHAR(10) NOT NULL UNIQUE, 
	[first_name] VARCHAR(20) NOT NULL,
	[last_name] VARCHAR(20) NOT NULL,
	[birth_date] DATE NOT NULL,
	[gender] VARCHAR(10) NOT NULL CHECK (gender = 'male' OR gender = 'female'),
	[address] VARCHAR(20) NOT NULL,
	[email] VARCHAR(30) NOT NULL UNIQUE,
	[phone] VARCHAR(12) NOT NULL UNIQUE,
	[lawschool] VARCHAR(30) NOT NULL,
	[years_of_practice] TINYINT NOT NULL,
	[salary] INT NOT NULL
)

CREATE TABLE [prosecutor]
(
	[prosecutorid] INT PRIMARY KEY IDENTITY,
	[ssn] VARCHAR(10) NOT NULL UNIQUE, 
	[first_name] VARCHAR(20) NOT NULL,
	[last_name] VARCHAR(20) NOT NULL,
	[birth_date] DATE NOT NULL,
	[gender] VARCHAR(10) NOT NULL CHECK (gender = 'male' OR gender = 'female'),
	[address] VARCHAR(20) NOT NULL,
	[email] VARCHAR(30) NOT NULL UNIQUE,
	[phone] VARCHAR(12) NOT NULL UNIQUE,
	[lawschool] varchar(30) NOT NULL,
	[years_of_practice] TINYINT NOT NULL,
	[salary] INT NOT NULL
)

CREATE TABLE [attorney]
(
	[attorneyid] INT PRIMARY KEY IDENTITY,
	[ssn] VARCHAR(10) NOT NULL UNIQUE, 
	[first_name] VARCHAR(20) NOT NULL,
	[last_name] VARCHAR(20) NOT NULL,
	[birth_date] DATE NOT NULL,
	[gender] VARCHAR(10) NOT NULL CHECK (gender = 'male' OR gender = 'female'),
	[address] VARCHAR(20) NOT NULL,
	[email] VARCHAR(30) NOT NULL UNIQUE,
	[phone] VARCHAR(12) NOT NULL UNIQUE,
	[type] VARCHAR(20) NOT NULL,
	[lawschool] VARCHAR(30) NOT NULL,
	[years_of_practice] TINYINT NOT NULL,
	[salary] INT NOT NULL
)

CREATE TABLE [courtroom]
(
	[roomid] INT PRIMARY KEY IDENTITY,
	[address] VARCHAR(20) NOT NULL,
	[capacity] INT NOT NULL UNIQUE,
	[no_trials] INT,
	[schedule] VARCHAR(20) NOT NULL
)

CREATE TABLE [court_case]
(
	[caseid] INT PRIMARY KEY IDENTITY,
	[case_type] VARCHAR(20) NOT NULL,
	[case_status] VARCHAR(20) NOT NULL,
	[crime] VARCHAR(20) NOT NULL,
	[no_victims] INT,
	[start_date] DATE NOT NULL,
	[end_date] DATE
)

CREATE TABLE [lawsuit]
(
	[personid] INT FOREIGN KEY REFERENCES [person]([personid]) NOT NULL,
	[caseid] INT FOREIGN KEY REFERENCES [court_case]([caseid]) NOT NULL,
	[attorneyid] INT FOREIGN KEY REFERENCES [attorney]([attorneyid]) NOT NULL,
	[person_status] INT FOREIGN KEY REFERENCES [person_status]([statusid]) NOT NULL,
	[salary_claim] INT,
	CONSTRAINT [pk_Lawsuit] PRIMARY KEY(personid, caseid, attorneyid)
)


CREATE TABLE [trial]
(
	[trialid] INT PRIMARY KEY IDENTITY,
	[caseid] INT FOREIGN KEY REFERENCES [court_case]([caseid]) NOT NULL,
	[roomid] INT FOREIGN KEY REFERENCES [courtroom]([roomid]) NOT NULL,
	[trial_status] VARCHAR(20) NOT NULL,
	[date] DATE,
	[time] TIME,
	[sentence] VARCHAR(50),
	[remarks] VARCHAR(50)
)

CREATE TABLE [case_staff]
(
	[caseid] INT FOREIGN KEY REFERENCES [court_case]([caseid]) NOT NULL,
	[judgeid] INT FOREIGN KEY REFERENCES [judge]([judgeid]) NOT NULL,
	[prosecutorid] INT FOREIGN KEY REFERENCES [prosecutor]([prosecutorid]) NOT NULL,
	[salary] INT,
	CONSTRAINT [pk_Case_staff] PRIMARY KEY(caseid, judgeid, prosecutorid)
)

CREATE TABLE [evidence]
(
	[evidenceid] INT PRIMARY KEY IDENTITY,
	[caseid] INT FOREIGN KEY REFERENCES [court_case]([caseid]) NOT NULL,
	[type] VARCHAR(20) NOT NULL,
	[date] DATE,
	[description] VARCHAR(60)
)

CREATE TABLE [conviction]
(
	[convictionid] INT PRIMARY KEY IDENTITY,
	[caseid] INT FOREIGN KEY REFERENCES [court_case]([caseid]) NOT NULL,
	[date] DATE NOT NULL,
	[penalty] VARCHAR(30) NOT NULL,
	[counts] INT NOT NULL
)
