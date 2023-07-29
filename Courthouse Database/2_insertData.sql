USE [courthouse]
GO

-- insert data into tables

-- person(personid, ssn, first_name, last_name, birth_date, gender, address, email, phone, occupation, record)
INSERT INTO [person]([ssn], [first_name], [last_name], [birth_date], [gender], [address], [email], [phone], [occupation], [record]) 
     VALUES ('520226657', 'Alma', 'Cruz', '1990-04-12', 'female', '3175 Railroad Street', 'alma.cruz@gmail.com', '445552195619', 'dentist', 'clean'),
	    ('248797268', 'Brian', 'Green', '1989-07-20', 'male', '2590 Capitol Avenue', 'brian.green@gmail.com', '447397379386', 'librarian', 'drug possession, insurance fraud'),
	    ('430909520', 'Henry', 'Elliot', '1985-11-09', 'male', '4379 Newton Street', 'henry.elliot@gmail.com', '441273173073', 'engineer', 'vandalism, first-degree murder'),
	    ('268269894', 'Sophia', 'Castillo', '1987-10-10', 'female', '485 Irving Road', 'sophia.castillo@gmail.com', '445579065917', 'bartender', 'clean'),
	    ('487087449', 'Alice', 'Marshall', '1980-03-06', 'female', '4117 Payne Street', 'alice.marshall@gmail.com', '442087647671', 'nurse', 'driving while intoxicated'),
	    ('221342586', 'Mark', 'Gomez', '1972-12-18', 'male', '4114 College View', 'mark.gomez@gmail.com', '447068986164', 'psychiatrist', 'robbery'),
	    ('34296042', 'George', 'Mccarthy', '1998-01-27', 'male', '3068 Oak Lane', 'george.mccarthy@gmail.com', '447206755974', 'paramedic', 'money laundering'),
	    ('478094043', 'Hailey', 'Tucker', '1993-05-29', 'female', '2475 Pearl Street', 'hailey.tucker@gmail.com', '442040399454', 'secretary', 'clean'),
	    ('468270021', 'Jamie', 'Rollins', '1971-08-14', 'male', '3713 North Street', 'jamie.rollins@gmail.com', '443350788821', 'musician', 'aggravated assault, car theft'),
	    ('521893332', 'Jack', 'Larson', '1968-04-11', 'male', '4108 Ersel Street', 'jack.larson@gmail.com', '441923673574', 'archaeologist', 'second-degree murder, arson, kidnapping')

-- person_status(statusid, person_type)
INSERT INTO [person_status]([person_type])
	 VALUES ('defendant'), 
		('plaintiff')

-- judge(judgeid, ssn, first_name, last_name, birth_date, gender, address, email, phone, lawschool, office, years_of_practice, salary)
INSERT INTO [judge]([ssn], [first_name], [last_name], [birth_date], [gender], [address], [email], [phone], [lawschool], [years_of_practice], [salary]) 
     VALUES ('521227890', 'David', 'Clooney', '1976-09-14', 'male', '3123 Flower Street', 'david.clooney@gmail.com', '445582997588', 'Harvard University', 12, 205100),
	    ('409802269', 'Adelaine', 'Becker', '1987-08-20', 'female', '4534 Joyce Street', 'adelaine.becker@gmail.com', '447753022199', 'Oxford University', 4, 120050),
	    ('517980591', 'Rylie', 'Valdez', '1996-02-10', 'male', '1450 Ritter Avenue', 'rylie.valdez@gmail.com', '441737649175', 'Cambridge University', 3, 120050),
	    ('417644663', 'Serena', 'Fleming', '1973-09-18', 'female', '93 Davis Avenue', 'serena.fleming@gmail.com', '447846185451', 'Stanford University', 10, 195000),
	    ('506471521', 'Jeffery', 'Lewis', '1961-05-19', 'male', '2973 Grim Avenue', 'jeffery.lewis@gmail.com', '447438563066', 'Yale University', 25, 285005),
	    ('507488901', 'Mary', 'Winefield', '1969-04-28', 'female', '1801 Chapel Street', 'mary.winefield@gmail.com', '447456788900', 'Standford University', 20, 220000),
	    ('546242827', 'Louis', 'Garfield', '1970-01-02', 'male', '119 Allison Avenue', 'louis.garfield@gmail.com', '447324567895', 'Columbia University', 17, 220000)

-- prosecutor(prosecutorid, ssn, first_name, last_name, birth_date, gender, address, email, phone, lawschool, office, years_of_practice, salary)
INSERT INTO [prosecutor]([ssn], [first_name], [last_name], [birth_date], [gender], [address], [email], [phone], [lawschool], [years_of_practice], [salary]) 
     VALUES ('505419780', 'Dustin', 'Hunter', '1976-10-12', 'male', '3123 Flower Street', 'dustin.hunter@gmail.com', '447031144488', 'Stanford University', 12, 205100),
	    ('212596077', 'Taylor', 'Bennett', '1985-09-22', 'male', '4534 Joyce Street', 'taylor.bennnett@gmail.com', '447712732431', 'Chicago University', 4, 145000),
	    ('408622819', 'Sarah', 'Thompson', '1972-02-17', 'female', '1450 Ritter Avenue', 'sarah.thompson@gmail.com', '447410885850', 'Harvard University', 1, 120050),
	    ('441666139', 'Roland', 'Pierce', '1959-04-19', 'male', '93 Davis Avenue', 'roland.pierce@gmail.com', '447400091521', 'Stanford University', 10, 195000),
            ('409971115', 'Alexis', 'Cooke', '1964-11-24', 'female', '2973 Fried Avenue', 'alexis.cooke@gmail.com', '442885900540', 'Columbia University', 25, 285005),
	    ('506471521', 'Alexander', 'Russ', '1986-09-04', 'male', '3642 Laurel Lee', 'alexander.russ@gmail.com', '447936583099', 'Imperial College', 19, 230000),
	    ('509771521', 'Ellie', 'Marrison', '1983-08-07', 'female', '3242 Russell Street', 'ellie.marrison@gmail.com', '447902363096', 'Cambridge University', 22, 270000)

-- attorney(attorneyid, ssn, first_name, last_name, birth_date, gender, address, email, phone, type, lawschool, office, years_of_practice, salary)
INSERT INTO [attorney]([ssn], [first_name], [last_name], [birth_date], [gender], [address], [email], [phone], [type], [lawschool], [years_of_practice], [salary]) 
     VALUES ('502080780', 'Dylan', 'Hardy', '1988-02-14', 'male', '229 Hillside Drive', 'dylan.hardy@gmail.com', '443068719809', 'employed', 'Columbia University', 7, 160500),
	    ('576375529', 'Coby', 'Owen', '1996-01-07', 'male', '4178 Bloomfield Way', 'coby.owen@gmail.com', '447932046799', 'court-appointed', 'Minnesota University', 2, 125000),
	    ('540251363', 'Turner', 'Buckley', '1956-09-23', 'male', '2011 Sunny Lane', 'turner.buckley@gmail.com', '441740487427', 'court-appointed', 'New York University', 17, 240000),
	    ('304145459', 'Ellen', 'Barron', '1989-02-05', 'female', '2525 Charles Street', 'ellen.barron@gmail.com', '445525584684', 'employed', 'Pennsylvania University', 5, 150000),
	    ('247484108', 'India', 'Wilkerson', '1988-12-18', 'female', '162 Indiana Avenue', 'india.wilkerson@gmail.com', '442016266748', 'court-appointed', 'Stanford University', 6, 160500),
	    ('247488808', 'Lary', 'Larson', '1984-11-12', 'male', '234 WestSide Avenue', 'lary.larson@gmail.com', '442027276748', 'employed', 'Yale University', 15, 240000),
	    ('247654108', 'Jacob', 'Medley', '1991-10-08', 'male', '293 Glory Road', 'jacob.medley@gmail.com', '442034567898', 'employed', 'Harvard University', 9, 195000)

-- courtroom(roomid, address, capacity, schedule)
INSERT INTO [courtroom]([address], [capacity], [no_trials], [schedule])
	 VALUES ('3438 Richards Avenue', 5100, 22, '10-18'),
		('1155 Forest Drive', 5200, 17, '9-14'),
		('2115 Armory Road', 5050, 80, '10-20'),
		('3243 Carolina Avenue', 5300, 20, '12-16'),
		('3294 Lyndon Street', 5400, 10, '08-18'),
		('3931 Brownton Road', 5150, 12, '09-15'),
		('1190 Big Elm', 5250, 8, '08-17')

-- court_case(caseid, case_type, case_status, crime, start_date, end_date)
INSERT INTO [court_case]([case_type], [case_status], [crime], [no_victims], [start_date], [end_date])
	 VALUES ('criminal', 'ongoing', 'first-degree murder', 2, '2017-10-10', ''),
		('civil', 'solved', 'insurance fraud', 100,'2012-11-18', '2014-07-06'),
		('criminal', 'ongoing', 'robbery', 5,  '2020-06-07', ''),
		('criminal', 'solved', 'second-degree murder', 6,  '2008-11-13', '2022-09-25'),
		('criminal', 'ongoing', 'drug trafficking', 4,  '2015-11-07', ''),
		('civil', 'ongoing', 'tax evasion', 33,  '2019-06-16', ''),
		('criminal', 'ongoing', 'vehicular homicide', 2,  '2021-04-18', ''),
		('civil', 'solved', 'blackmail', 7,  '2009-02-07', '2011-11-11'),
		('civil', 'ongoing', 'money laundering', 25,  '2020-12-19', ''),
		('criminal', 'solved', 'arson', 20,  '2010-08-11', '2015-12-12'),
		('criminal', 'ongoing', 'burglary', 18,  '2005-08-11', '')

-- lawsuit(personid, caseid, attorneyid, person_status, salary_claim)
INSERT INTO [lawsuit]([personid], [caseid], [attorneyid], [person_status], [salary_claim])
	 VALUES (5, 5, 2, 1, 10000),
		(2, 1, 1, 2, 15000),
		(1, 1, 3, 1, 25000),
		(3, 7, 5, 1, 10000),
		(4, 7, 4, 2, 30000),
		(9, 9, 2, 1, 30000),
		(10, 6, 1, 1, 20000),
		(8, 3, 5, 2, 10000),
		(6, 3, 4, 1, 40000),
		(1, 4, 1, 1, 50000),
		(10, 6, 5, 1, 10000),
		(5, 8, 4, 2, 15000),
		(6, 4, 4, 2, 25000),
		(4, 2, 4, 1, 30000)

-- trial(trialid, caseid, roomid, trial_status, date, time, sentence,remarks)
INSERT INTO [trial]([caseid], [roomid], [trial_status], [date], [time], [sentence], [remarks])
	 VALUES (1, 1, 'ongoing', '2022-08-08', '09:00:00', '', 'defendant pleaded not guilty'),
		(2, 5, 'ended', '2014-03-15', '11:30:00', '2 years imprisonment', 'sentence to be serverd immediately'),
		(3, 3, 'ongoing', '2021-07-01', '10:45:00', '', 'defendant pleaded guilty'),
		(4, 2, 'ended', '2022-05-10', '10:30:00', 'life imprisonment', 'defendant found guilty'),
		(5, 4, 'ongoing', '2020-06-08', '10:00:00', '', 'found substantial evidence'),
		(6, 5, 'ongoing', '2020-12-19', '09:00:00', '', 'defendant pleaded not guilty'),
            	(7, 1, 'ongoing', '2021-04-18', '10:00:00', '', 'defendant pleaded not guilty'),
            	(8, 2, 'ended', '2011-11-11', '11:30:00', '3 years imprisonment', 'sentence to be serverd immediately'),
            	(9, 3, 'ongoing', '2020-12-19', '10:45:00', '', 'defendant pleaded guilty'),
            	(10, 4, 'ended', '2021-05-10', '10:30:00', '30 years imprisonment', 'defendant pleaded guilty')

-- case_staff(caseid, judgeid, prosecutorid)
INSERT INTO [case_staff]([caseid], [judgeid], [prosecutorid], [salary])
	 VALUES (1, 3, 4, 140000),
		(2, 5, 1, 150000),
		(3, 4, 2, 120000),
		(4, 1, 2, 110000),
		(5, 4, 1, 140000),
		(6, 4, 3, 150000),
		(7, 5, 5, 120000),
		(8, 1, 4, 130000),
		(9, 3, 4, 160000),
		(10, 2, 2, 200000)

INSERT INTO [case_staff]([caseid], [judgeid], [prosecutorid])
	 VALUES (10, 30, 40), (10, 1, 2)

-- evidence(evidenceid, caseid, type, date, description)
INSERT INTO [evidence]([caseid], [type], [date], [description])
	 VALUES (1, 'forensic', '2022-08-08', 'blood sample'),
            (1, 'physical', '2022-09-09', 'murder weapon'),
            (2, 'circumstantial', '2014-03-15', 'eye witness'),
            (2, 'physical', '2014-02-11', 'fake documents'),
            (3, 'forensic', '2021-07-01', 'fingerprints'),
            (3, 'physical', '2021-09-02', 'house damage'),
            (4, 'physical', '2022-05-10', 'murder weapon'),
            (5, 'physical', '2020-06-08', 'footprints'),
            (6, 'physical', '2018-02-11', 'fake documents'),
            (8, 'statement', '2020-12-19', 'testimony'),
            (7, 'foresic', '2021-04-18', 'DNA'),
            (7, 'circumstatial', '2021-04-18', 'tire tracks'),
            (3, 'physical', '2011-11-11', 'gunshot residue'),
            (4, 'physical', '2011-10-10', 'blood sample'),
            (5, 'forensic', '2020-12-19', 'hair'),
            (9, 'digital', '2020-10-19', 'computer folders'),
            (10, 'forensic', '2011-05-10', 'fingerprints'),
            (10, 'physical', '2011-05-11', 'ashes')

INSERT INTO [evidence]([caseid], [type], [description])
	 VALUES (2, 'forensic', 'paint'),
            (3, 'physical', 'powder')

-- conviction(convictionid, caseid, date, penalty, counts)
INSERT INTO [conviction]([caseid], [date], [penalty], [counts])
	 VALUES (2, '2014-08-08', '2 years imprisonment', 2),
                (4, '2022-03-15', 'life imprisonment', 3),
                (8, '2011-07-01', '3 years imprisonment', 1),
                (10, '2015-05-10', '30 years imprisonment', 2),
		(1, '2022-08-08', 'life imprisonment', 5),
		(5, '2020-08-08', '4 years imprisonment', 6)


-- insert data that violates referential integrity constraints
-- INSERT INTO [trial]([caseid], [roomid], [trial_status], [date], [time], [sentence], [remarks])
--	    VALUES (20, 18, 'ongoing', '2021-08-08', '17:00:00', '', 'suspended')
