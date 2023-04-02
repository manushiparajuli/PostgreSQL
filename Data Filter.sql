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
    