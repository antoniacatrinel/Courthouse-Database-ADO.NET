USE [courthouse]
GO

-- update data
-- update the record of the persons who have record 'clean' or 'robbery' with 'bribery'
SELECT * 
  FROM [person]

UPDATE [person]  
   SET [record] = 'bribery' 
 WHERE [record] = 'clean' OR [record] = 'robbery' 

SELECT * 
  FROM [person]


-- increase the number of years of practice by 2 for judges who have worked between 1 and 10 years
SELECT * 
  FROM [judge]

UPDATE [judge]  
   SET [years_of_practice] = [years_of_practice] + 2
 WHERE [years_of_practice] BETWEEN 1 AND 10

SELECT * 
  FROM [judge]


-- duplicate the couts for all the convictions who have at least 2 counts
SELECT * 
  FROM [conviction]

UPDATE [conviction]  
   SET [counts] = [counts] * 2
 WHERE [counts] <= 2 

SELECT * 
  FROM [conviction]


-- increase the salary claim by 1000 in all the lawsuits where the salary claim is 20000 or 10000
SELECT * 
  FROM [lawsuit]

UPDATE [lawsuit]  
   SET [salary_claim] = [salary_claim] + 1000
 WHERE [salary_claim] IN (20000, 10000)

SELECT * 
  FROM [lawsuit]


-- delete data
-- delete all convictions who have more than 5 counts
SELECT * 
  FROM [conviction]

DELETE  
  FROM [conviction]  
 WHERE [counts] >= 5

SELECT * 
  FROM [conviction]


-- delete all cases from 2005
SELECT * 
  FROM [court_case]

DELETE  
  FROM [court_case]  
 WHERE [start_date] LIKE '2005%'

SELECT * 
  FROM [court_case]


-- delete all evidence which does not have a date
SELECT * 
  FROM [evidence]

DELETE  
  FROM [evidence]  
 WHERE [date] IS NULL

SELECT * 
  FROM [evidence]
