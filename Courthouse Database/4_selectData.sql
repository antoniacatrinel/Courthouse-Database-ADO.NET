USE [courthouse]
GO

-- select data
-- a. 2 queries with the union operation; use UNION [ALL] and OR

-- find the full names of the case staff members who have more than 5 years of practice and are male
SELECT [J].[first_name], [J].[last_name]
  FROM [judge] [J]
 WHERE [J].[years_of_practice] > 5 AND [J].[gender] = 'male'
 UNION ALL
SELECT [P].[first_name], [P].[last_name]
  FROM [prosecutor] [P]
 WHERE [P].[years_of_practice] > 5 AND [P].[gender] = 'male'
 UNION ALL 
SELECT [A].[first_name], [A].[last_name]
  FROM [attorney] [A]
 WHERE [A].[years_of_practice] > 5 AND [A].[gender] = 'male'


-- find the ids of the top 3 judges and prosecutors who have studied at Stanford University
SELECT TOP 3 [J].[judgeid] AS [ID]
  FROM [judge] [J]
 WHERE [J].[lawschool] = 'Stanford University'
 UNION
SELECT TOP 3 [P].[prosecutorid] AS [ID]
  FROM [prosecutor] P
 WHERE [P].[lawschool] = 'Stanford University'


-- find the case id and the description of all evidence which is of type 'physical' or 'forensic'
  SELECT [E].[caseid], [E].[description]
    FROM [evidence] [E]
   WHERE [E].[type] = 'physical' OR  [E].[type] = 'forensic'
ORDER BY [E].[caseid]


-- b. 2 queries with the intersection operation; use INTERSECT and IN

-- find the ids of the persons who are of status 'defendant' in at least one lawsuit
   SELECT [P].[personid]
     FROM [person] [P]
INTERSECT 
   SELECT [L].[personid]
     FROM [lawsuit] [L]
	WHERE [L].[person_status] = 1


-- find the ids of the prosecutors who are involved in at least one case 
   SELECT [P].[prosecutorid]
     FROM [prosecutor] [P]
INTERSECT 
   SELECT [C].[prosecutorid]
     FROM [case_staff] [C]


-- find the id and address of the courtrooms which are not open bewteen 10-18 or 12-16
SELECT [CR].[roomid], [CR].[address]
  FROM [courtroom] [CR]
 WHERE [CR].[schedule] NOT IN ('10-18', '12-16')


-- c. 2 queries with the difference operation; use EXCEPT and NOT IN

-- find the ids of the employed attorneys who are not involved in any lawsuit
SELECT [A].[attorneyid]
  FROM [attorney] [A]
 WHERE [A].[type] = 'employed'
EXCEPT
SELECT [L].[attorneyid]
  FROM [lawsuit] [L]


-- find the case id of the trials in which the defendant did not plead guilty or the sentence does not have to be served immediately
SELECT [C].[caseid]
  FROM [court_case] [C]
EXCEPT
SELECT [T].[caseid]
  FROM [trial] [T]
 WHERE [T].[remarks] NOT IN ('defendant pleaded guilty', 'sentence to be serverd immediately')


-- d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN (one query per operator)
-- one query will join at least 3 tables, while another one will join at least two many-to-many relationships;

-- 2 m:n relations
-- find for each case in which there is evidence the full name, years of practice and salary of the judge it has
    SELECT [J].[first_name], [J].[last_name], [J].[years_of_practice], [J].[salary]
      FROM ((([judge] [J]
INNER JOIN [case_staff] [CS]
        ON [CS].[judgeid] = [J].[judgeid])
INNER JOIN [court_case] [CC]
		ON [CC].[caseid] = [CS].[caseid])
INNER JOIN [evidence] [E]
		ON [CC].[caseid] = [E].[caseid])


-- 3 tables
-- find the full name, type and salary of the attorneys that are involved in at least one lawsuit for which there is a trial; include the trial id
   SELECT [A].[first_name], [A].[last_name], [A].[type], [A].[salary], [T].[trialid]
     FROM (([attorney] [A]
LEFT JOIN [lawsuit] [L]
	   ON [A].[attorneyid] = [L].[attorneyid])
LEFT JOIN [trial] [T]
	   ON [L].[caseid] = [T].[caseid])


-- find the id, crime and the status of all cases for which there has been given a conviction; include the conviction id
    SELECT [CC].[caseid], [CC].[crime], [C].[convictionid]
	  FROM ([court_case] [CC]
RIGHT JOIN [conviction] [C]
        ON [C].[caseid] = [CC].[caseid])


-- find the name and record of the top 5 persons who are involved in at least one lawsuit, ordered by name
   SELECT DISTINCT TOP 5 [P].[first_name], [P].[last_name], [P].[record]
     FROM ([person] [P] 
FULL JOIN [lawsuit] [L] 
       ON [P].[personid] = [L].[personid])
 ORDER BY [P].[first_name], [P].[last_name]
    

-- e. 2 queries with the IN operator and a subquery in the WHERE clause
-- in at least one case, the subquery must include a subquery in its own WHERE clause

-- find the address, schedule and capacity * 2 of the courtrooms which are scheduled for at least one ongoing trial
SELECT [CR].[address], [CR].[capacity] * 2, [CR].[schedule]
  FROM [courtroom] [CR]
 WHERE [CR].[roomid] IN (
			SELECT [T].[roomid]
			  FROM [trial] [T]
			 WHERE [T].[trial_status] = 'ongoing'
			)


-- find the case type, crime and start date of the cases which have a ended trial and have also 'physical' evidence 
SELECT [C].[case_type], [C].[crime], [C].[start_date]
  FROM [court_case] [C]
 WHERE [C].[caseid] IN (
			SELECT [T].[caseid]
			  FROM [trial] [T]
			 WHERE [T].[trial_status] = 'ended' AND [C].[caseid] IN (
										SELECT [E].[caseid]
										  FROM [evidence] [E]
										 WHERE [E].[type] = 'physical' 
										)
			)


-- f. 2 queries with the EXISTS operator and a subquery in the WHERE clause

-- find the full name, email and phone number of the attorneys who are currently involved in lawsuits
SELECT [A].[first_name], [A].[last_name], [A].[email], [A].[phone]
  FROM [attorney] [A]
 WHERE EXISTS (
        SELECT *
          FROM [lawsuit] [L]
         WHERE [A].[attorneyid] = [L].[attorneyid]
 )


-- find the id, address and lawschool of the prosecutors who are part of case with id between 1 and 3
SELECT [P].[prosecutorid], [P].[address], [P].[lawschool]
  FROM [prosecutor] [P]
 WHERE EXISTS ( 
		SELECT *
	      FROM [case_staff] [CS]
		 WHERE [P].[prosecutorid] = [CS].[prosecutorid] AND ([CS].[caseid] BETWEEN 1 AND 3)
 )


-- g. 2 queries with a subquery in the FROM clause

-- find the id, address and schedule of all court rooms with capacity of at least 100 which are scheduled for ongoing trials 
SELECT [R].[roomid], [R].[address], [R].[schedule]
  FROM (
	  SELECT [CR].[roomid], [CR].[address], [CR].[schedule], [CR].[capacity]
	    FROM [courtroom] [CR]
  INNER JOIN [trial] [T] 
		  ON [CR].[roomid] = [T].[roomid]
	   WHERE [T].[trial_status] = 'ongoing'
	   ) AS [R]
 WHERE [R].[capacity] >= 100


 -- find the full name and salary of the judges who are involved in at least one case and whose salary is greater or equal than the average salary

SELECT [JJ].[first_name], [JJ].[last_name], [JJ].[salary]
  FROM (
	  SELECT [J].[first_name], [J].[last_name], [J].[salary], AVG([J].[salary]) as average_salary
	    FROM [judge] [J]
   LEFT JOIN [case_staff] [CS] 
	      ON [CS].[judgeid] = [J].[judgeid]
	GROUP BY [J].[first_name], [J].[last_name], [J].[salary]
	   ) AS [JJ]
WHERE [JJ].[salary] >= [JJ].[average_salary] 


-- h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 2 of the latter will also have a subquery in the HAVING clause
-- use the aggregation operators: COUNT, SUM, AVG, MIN, MAX

-- find the full name of the attorney who has at least 5 years of practice and is involved in at least 2 lawsuits
  SELECT [A].[first_name], [A].[last_name] 
    FROM [attorney] [A]
   WHERE [A].[years_of_practice] >= 5
GROUP BY [A].[years_of_practice], [A].[attorneyid], [A].[first_name], [A].[last_name]
  HAVING 2 <= (
			SELECT COUNT(*)
			  FROM [lawsuit] [L]
			 WHERE [L].[attorneyid] = [A].[attorneyid]
			)


-- find the id and full name of the prosecutors with the biggest number of lawsuits
    SELECT [P].[prosecutorid], [P].[first_name], [P].[last_name], COUNT(*) AS [number_of_lawsuits]
      FROM [prosecutor] [P] 
INNER JOIN [case_staff] [CS] 
        ON [P].[prosecutorid] = [CS].[prosecutorid]
  GROUP BY [P].[prosecutorid], [P].[first_name], [P].[last_name]
    HAVING COUNT(*) = (
			SELECT MAX([t].[C])
			  FROM (
				SELECT COUNT(*) [C]
				  FROM [prosecutor] [P] 
			    INNER JOIN [case_staff] [CS] 
				    ON [P].[prosecutorid] = [CS].[prosecutorid]
			      GROUP BY [P].[prosecutorid], [P].[first_name], [P].[last_name]
			       ) [t]
		       )


-- find the salaries * 3 of the judges and for each salary the number of judges
  SELECT [J].[salary] * 3, COUNT(*) as [number_of_judges]
    FROM [judge] [J]
GROUP BY [J].[salary]


-- find the id, type and crime of all the cases for which there is more evidence than average
    SELECT [CC].[caseid], [CC].[case_type], [CC].[crime], COUNT(*) AS [number_of_evidence]
      FROM [court_case] [CC]
INNER JOIN [evidence] [E]
        ON [E].[caseid] = [CC].[caseid]
  GROUP BY [CC].[caseid], [CC].[case_type], [CC].[crime]
    HAVING COUNT(*) >= (
			SELECT AVG([t].[C])
			  FROM (
				SELECT COUNT(*) [C]
				  FROM [court_case] [CC]
                            INNER JOIN [evidence] [E]
                                    ON [E].[caseid] = [CC].[caseid]
                              GROUP BY [CC].[caseid], [CC].[case_type], [CC].[crime]
				 ) [t]
			)


-- i. 4 queries using ANY and ALL to introduce a subquery in the WHERE clause (2 queries per operator)
-- rewrite 2 of them with aggregation operators, and the other 2 with IN / [NOT] IN.

-- find the full name and years of practice of all judges with more experience than all court-appointed attorneys
SELECT DISTINCT [J].[first_name], [J].[last_name], [J].[years_of_practice]
  FROM [judge] [J]
 WHERE [J].[years_of_practice] > ALL (
    SELECT [A].[years_of_practice]
      FROM [attorney] [A]
     WHERE [A].[type] = 'court-appointed'
 )


-- find the full name and years of practice of all judges with more experience than all court-appointed attorneys (aggregation operator)
SELECT DISTINCT [J].[first_name], [J].[last_name], [J].[years_of_practice]
  FROM [judge] [J]
 WHERE [J].[years_of_practice] > (
    SELECT MAX([A].[years_of_practice])
      FROM [attorney] [A]
     WHERE [A].[type] = 'court-appointed'
 )


-- find the full name and salary of the prosecutors whose salary is greater than any of the prosecutors with at least 5 years of practice
SELECT DISTINCT [P].[first_name], [P].[last_name], [P].[salary]
  FROM [prosecutor] [P]
 WHERE [P].[salary] > ANY (
	SELECT [P2].[salary]
	  FROM [prosecutor] [P2]
	 WHERE [P2].[years_of_practice] >= 5
	)


-- find the full name and salary of the prosecutors whose salary is greater than any of the prosecutors with at least 5 years of practice (aggregation operator)
SELECT DISTINCT [P].[first_name], [P].[last_name], [P].[salary]
  FROM [prosecutor] [P]
 WHERE [P].[salary] > (
	SELECT MIN([P2].[salary])
	  FROM [prosecutor] [P2]
	 WHERE [P2].[years_of_practice] >= 5
	)


-- find the id, full name and salary + 10000 of all attorneys who have different salary than all attorneys with at least 3 years of practice
SELECT [A].[attorneyid], [A].[first_name], [A].[last_name], [A].[salary] + 10000
  FROM [attorney] [A]
 WHERE [A].[salary] <> ALL (
     SELECT [A2].[salary] 
	   FROM [attorney] [A2]
	  WHERE [A2].[years_of_practice] >= 3
	 )


-- find the id, full name and salary + 10000 of all attorneys who have different salary than all attorneys with at least 3 years of practice (not in)
SELECT [A].[attorneyid], [A].[first_name], [A].[last_name], [A].[salary] + 10000
  FROM [attorney] [A]
 WHERE [A].[salary] NOT IN (
     SELECT [A2].[salary] 
	   FROM [attorney] [A2]
	  WHERE [A2].[years_of_practice] >= 3
	 )


-- find the full name of the attorneys who are involved in lawsuits in which they are paid at least 20000
SELECT [A].[first_name], [A].[last_name]  
  FROM [attorney] [A]
 WHERE [A].[attorneyid] = ANY (
     SELECT [L].[attorneyid]  
       FROM [lawsuit] [L]
      WHERE [L].[salary_claim] >= 20000
	 )


-- find the full name of the attorneys who are involved in lawsuits in which they are paid at least 20000 (in)
SELECT [A].[first_name], [A].[last_name]  
  FROM [attorney] [A]
 WHERE [A].[attorneyid] IN (
     SELECT [L].[attorneyid]  
       FROM [lawsuit] [L]
      WHERE [L].[salary_claim] >= 20000
	 )
