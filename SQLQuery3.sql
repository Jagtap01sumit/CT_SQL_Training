use payroll;


begin transaction
-- write a query to list dpartments that have moret than 3 emp
SELECT deptno, COUNT(*) AS employeCount FROM emp GROUP BY deptno HAVING COUNT(*)>3;

--write a query to calculate the toal salary of employee grouped by the location of theri department.
SELECT loc, SUM(sal) FROM emp, dept GROUP BY loc;

--write a query to find the employee(s) with the highest salary
select ename,sal FROM emp GROUP BY ename,sal HAVING sal =(select MAX(sal) FROM emp);

--write a query tofind employees who earn the minimum salary in their respective departments;

SELECT ename,sal,deptno FROM emp WHERE sal IN (SELECT MIN(sal) FROM emp GROUP BY deptno);



select * from dept;
select * from emp



USE payroll;

--VIEWS:

CREATE VIEW emp_view AS SELECT * FROM emp;

SELECT * FROM INFORMATION_SCHEMA.TABLES;



CREATE OR ALTER VIEW emp_uppercase_ename AS SELECT UPPER(ename) "Ename",sal+ISNULL (comm,0) "Net Salary" FROM emp;

--for expresssion in the select you must create an alise for creating a view out of it.
select * from emp_uppercase_ename;


--emp num , emp name and dep name
select * from emp;

CREATE OR ALTER VIEW emp_name_num_dept_name_view AS SELECT ename , empno, dname FROM emp INNER JOIN DEPT ON DEPT.DEPTNO=emp.deptno;

select * from emp_name_num_dept_name_view;

CREATE OR ALTER VIEW ename_sal_comm_view AS SELECT ename, sal, comm FROM emp;
select * from ename_sal_comm_view

exec sp_help 'emp';

insert into ename_sal_comm_view(ename, sal , comm) VALUES('JACK', 7000, 200);
select * from emp;

CREATE SEQUENCE emp_sequence1
START WITH 1001
INCREMENT BY 1
MINVALUE 1001
MAXVALUE 5000
NO CYCLE 
CACHE 100

INSERT INTO emp(empno, ename) VALUES(NEXT VALUE FOR emp_sequence1,'B');
 
 SELECT empno,ename,sal, 
ROW_NUMBER () OVER (
ORDER BY sal DESC
) AS Rank_no 
FROM emp;

--when we use RANK() then there is rank but not sequence number : 1 1 1 1 1 6 7 8 9
--when we use ROW_NUMBER() there is rank with a sequence number : if two row having same salary then the rank is 1 2 not a 1 1


-----------------------------------------------------------------------------------------------------------------------------------------------

select empno,ename,sal from emp where sal < (select AVG(sal) from emp)


--Assignment number 4
--Create a view that displays employee details along with their department name and location
CREATE OR ALTER VIEW emp_details_with_dept_view AS  select empno, ename, sal , dname , loc from emp , dept where emp.deptno = dept.DEPTNO;
select * from emp_details_with_dept_view

--Create a sequence for generating employee numbers starting at 100 and incrementing by 5 . Use this sequence to insert a new employee.
CREATE SEQUENCE emp_sequence2
START WITH 100
INCREMENT BY 5
MINVALUE 100
MAXVALUE 5000
NO CYCLE 
CACHE 100


INSERT INTO emp(empno, ename) VALUES(NEXT VALUE FOR emp_sequence2,'B');
select * from emp;
INSERT INTO emp(empno, ename) VALUES(NEXT VALUE FOR emp_sequence2,'C');
select * from emp;

--Create a view that shows the top 3 highest-paid employees in each department
SELECT ename, deptno, sal, sal_rank
FROM (
  SELECT
    ename,
    deptno,
    sal,
    RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS sal_rank
  FROM emp
) AS subquery
WHERE sal_rank IN (1, 2, 3);

--Create a view that lists employees whose salary is above the average salary of their department.
SELECT *
FROM emp e
JOIN (
  SELECT deptno, AVG(sal) AS avg_sal
  FROM emp
  GROUP BY deptno
) d ON e.deptno = d.deptno
WHERE e.sal > d.avg_sal;

--Create a view that lists the total number of employees and the total salary sum for each department.

  SELECT e.deptno,COUNT(*) as "count",SUM(e.sal) as total_sal, d.dname
  FROM emp e , DEPT d where e.deptno = d.DEPTNO
  GROUP BY e.deptno, d.dname


-- Create a view that lists employees who were hired in the last 5 years, and rank them based on their hire date.

select * from emp;
  
SELECT YEAR(hiredate)  AS Hireing_year,hiredate,ename,empno,YEAR(hiredate)-5 as minus5
FROM emp
WHERE YEAR(hiredate) > YEAR(CURRENT_TIMESTAMP)-5 order by hiredate;

-- Create a view that lists the top 2 earners in each department along with their department name and the difference between their salary and the average salary of the department

--Create a view to identify employees with the longest tenure in their departments, ranked by their hire date.
 SELECT DATEDIFF(year,hiredate,CURRENT_TIMESTAMP) AS date_diff,ename,deptno,hiredate from emp order by hiredate;

 -- Create a view that shows the total salary, average salary, and number of employees for each department.
   SELECT e.deptno,COUNT(*) as "count",SUM(e.sal) as total_sal,AVG(e.sal), d.dname
  FROM emp e , DEPT d where e.deptno = d.DEPTNO
  GROUP BY e.deptno, d.dname

  --Create a view to find employees whose salary is in the top 10% of all salaries.
 

 --Create a view that shows the average salary for each job title within each department.

 select job,AVG(sal) from emp group by job;

 

