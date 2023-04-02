/*
 * Manushi Parajuli
*/ 
/*
Number of people 25 and over in Denton County, Terrant County and Dallas county, TX have completed an 
Associate’s Degree, Bachelor’s Degree, Master’s Degree, or Doctorate Degree.
*/
SELECT Geo_QName, ACS18_5yr_B15003021+ACS18_5yr_B15003022+ACS18_5yr_B15003023+ACS18_5yr_B15003025 AS DentonCountyInfo 
FROM b15003
WHERE Geo_QName='Denton County, Texas';

SELECT Geo_QName, ACS18_5yr_B15003021+ACS18_5yr_B15003022+ACS18_5yr_B15003023+ACS18_5yr_B15003025 AS DallasCountyInfo 
FROM b15003
WHERE Geo_QName='Dallas County, Texas';

SELECT Geo_QName, ACS18_5yr_B15003021+ACS18_5yr_B15003022+ACS18_5yr_B15003023+ACS18_5yr_B15003025 AS TarrantCountyInfo 
FROM b15003
WHERE Geo_QName='Tarrant County, Texas';
/*
--------------------------------------------------------------------------------------
County with the highest proportion of individuals 25 or over who have completed a Doctorate Degree.
*/
SELECT Geo_QName,(ACS18_5yr_B15003025/ACS18_5yr_B15003001::NUMERIC) AS proportiondocs
FROM B15003
WHERE ACS18_5yr_B15003025/ACS18_5yr_B15003001::NUMERIC IN(
SELECT MAX(ACS18_5yr_B15003025/ACS18_5yr_B15003001::NUMERIC)
FROM B15003);

/*
--------------------------------------------------------------------------------------
Number of people (age 25 and over) in the U.S. have not attained 
education past the 2nd grade.
*/
SELECT SUM(ACS18_5yr_B15003002+ACS18_5yr_B15003003+ACS18_5yr_B15003004+ACS18_5yr_B15003005+ACS18_5yr_B15003006) AS numbelowthird from b15003;



/*
-------------------------------------------------------------------------------------
State with the highest ratio of people who have not completed any schooling.
*/
WITH temporaryTable AS (
SELECT Geo_STUSAB AS myState, SUM(ACS18_5yr_B15003002)::NUMERIC/SUM(ACS18_5yr_B15003001) AS mySum
FROM b15003
GROUP BY Geo_STUSAB
)
SELECT myState, mySum
FROM temporaryTable
WHERE mySum IN
(
SELECT MAX(mySum) FROM temporaryTable)
ORDER BY mySum DESC;

/*
 * Name: Manushi Parajuli
*/ 
/*
For each state (Geo_STUSAB), list the counties where the number of 
Professional School Degrees (PSD) (B15003024) is less than the average number of
PSD *for that state*.  Show Geo_QName and the number of PSD for that county.
Order by state, then county (Geo_NAME).
*/
WITH temporaryTable AS(
SELECT Geo_STUSAB, AVG(ACS18_5yr_B15003024) AS HI 
FROM b15003
GROUP BY Geo_STUSAB)
SELECT b15003.Geo_QName,ACS18_5yr_B1500302
FROM b15003, temporaryTable
WHERE hi>b15003.ACS18_5yr_B15003024 
AND b15003.Geo_STUSAB = temporarytable.Geo_STUSAB
ORDER BY b15003.Geo_STUSAB, b15003.Geo_NAME;
/*
 List the counties where the ratio of Professional School Degrees (PSD) to the 
 county's population is less than the average ratio of the state's PSD *for that state*.  
*/
WITH temporaryTable AS (
  SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003024::NUMERIC )/ SUM(ACS18_5yr_B15003001) AS avg_ratio
  FROM b15003
  GROUP BY Geo_STUSAB
),ratio AS (
  SELECT Geo_STUSAB, Geo_QNAME, ACS18_5yr_B15003024::NUMERIC / ACS18_5yr_B15003001 AS hello
  FROM b15003
)
SELECT ratio.Geo_QNAME, ratio.Geo_STUSAB, ratio.hello
FROM ratio, temporaryTable
WHERE ratio.hello < temporaryTable.avg_ratio AND ratio.Geo_STUSAB = temporaryTable.Geo_STUSAB 
GROUP BY ratio.Geo_STUSAB,ratio.Geo_QName, ratio.hello
order by ratio.Geo_STUSAB;

/*
 List the counties (Geo_QName) where the number of people with a high school diploma         
 (ACS18_5yr_B15003017) is above the average for their state.  Show Geo_QName and 
  ACS18_5yr_B15003017.  Order by Geo_STUSAB, Geo_QName with both *DESCENDING*. 
*/
WITH temporaryTable AS(
SELECT Geo_STUSAB, AVG(ACS18_5yr_B15003017) AS HI 
FROM b15003
GROUP BY Geo_STUSAB)
SELECT b15003.Geo_QName,ACS18_5yr_B15003017
FROM b15003, temporaryTable
WHERE hi<b15003.ACS18_5yr_B15003017 
AND b15003.Geo_STUSAB = temporarytable.Geo_STUSAB
ORDER BY b15003.Geo_STUSAB DESC, b15003.Geo_NAME DESC;
/*
 List the county names (Geo_NAME) and their respective counts where there are duplicate 
 county names (more than one) in any state.
*/
Select Distinct Geo_Name, COUNT(Geo_Name) AS HI 
From b15003 
GROUP BY Geo_Name 
HAVING COUNT(Geo_Name)>1;



    
