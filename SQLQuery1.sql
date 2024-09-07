USE payroll;
BEGIN TRANSACTION
select * from emp;

INSERT INTO EMP VALUES
        (1, 'JACK', 'CLERK',     1,
        '2024-01-23', 1300, NULL, 10);
INSERT INTO EMP VALUES
        (2, 'JACK', 'CLERK',     1,
        '2024-01-23', 1300, NULL, 10);
INSERT INTO EMP VALUES
        (3, 'JACK', 'CLERK',     1,
        '2024-01-23', 1300, NULL, 10);


Delete from emp where empno=1;
select * from emp;
EXEC sp_help 'emp'


INSERT INTO emp(empno,ename) VALUES(1,'A');
SAVE TRANSACTION T1

INSERT INTO emp(empno,ename) VALUES(2,'B');
SAVE TRANSACTION T2

INSERT INTO emp(empno,ename) VALUES(3,'C');
SAVE TRANSACTION T3


ROLLBACK TRANSACTION T2;

SELECT ENAME + ' ' + ename from emp; -- ename + ename
SELECT CONCAT (ename , ' ', ename ) FROM emp; --same using concat
SELECT UPPER(ename) FROM emp;

update emp set ename=LOWER(ename) WHERE empno = 1;
--LTREIM & RtRINN=> REMOVE EXTRA SPACE FROM START AND END


select * from emp;

SELECT SUBSTRING(ename, 0,3) FROM emp;  --return first two char of name

SELECT * FROM emp WHERE SOUNDEX(ename) = SOUNDEX('KEENG') ;

SELECT ROUND(999.99,2,-3); FROM emp;

SELECT  CEILING(999.99) ; --RETURN 1000
SELECT FLOOR(945.90)

SELECT SIGN(-12) -- IF NUM GREATER THAN 0 RETURN 1 , NUM =0 THEN RETURN 0 , NUM SAMLL THAN 0 REUTRN -1;

SELECT GETDATE();
SELECT YEAR(GETDATE());

SELECT ename,empno, DATEDIFF(year,hiredate,GETDATE()) as experiance from emp;

update emp set comm =100 where empno =1;
select * from emp;


select empno , sal ,comm, sal + comm FROM emp;

select empno, deptno from emp ;
SELECT deptno,
CASE 
    WHEN deptno = 10 THEN 'Training'
    WHEN deptno = 20 THEN 'Exporting'
    WHEN deptno = 30 THEN 'Marketing'
	
    ELSE 'Production'
END AS training
FROM emp;

SELECT count(*) as CountSal ,min(sal) as minSalary, max(sal) as maxSalary, avg(sal) as avgSalary from emp;

select deptno from emp group by deptno having sum(sal) > 5000;
select sum(sal) from emp where empno= 7788

select deptno, sum(sal) from emp group by deptno;

--Group by works in following steps:
	--Brings all row from servers harddisks to servers ram (create an single array)
	--Sorting takes place in servers ram.
	--Create separete array for the departments ( sum each array).
	--only those rows those are group will be send to the client.

select deptno from emp 
group by deptno 
having sum(sal) > 5000

--SELECT => FROM => GROUP BY => HAVING => ORDER BY