-- ------------------------------------------------------
-- NOTE: DO NOT REMOVE OR ALTER ANY LINE FROM THIS SCRIPT
-- ------------------------------------------------------

select 'Query 00' as '';
-- Conform to standard group by constructs
set session sql_mode = 'ONLY_FULL_GROUP_BY';

-- Write the queries that return the information below.

select 'Query 01' as '';
-- the salary and name of the employees whose commission is specified
select SAL as SALARY, ENAME as NAME
from EMP
where not (COMM is null);

      
select 'Query 02' as '';
-- the number of departments with at least one employee
select count(distinct DID) as DEPT_WITH_EMPLOYEES
from EMP;

select 'Query 03' as '';
-- the name and total salary of the employees
select ENAME, SAL + coalesce(COMM, 0.0) as TOTAL_SALARY
from EMP;


select 'Query 04' as '';
-- the job of the employees who did a mission (at least one)
select distinct JOB
from EMP natural join MISSION;


select 'Query 05' as '';
-- the name of the employees, followed by the name of their manager
select e.ENAME as EMPLOYEE, m.ENAME as MANAGER
from EMP e left outer join EMP m on e.MGR = m.EID;

