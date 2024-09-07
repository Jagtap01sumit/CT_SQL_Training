use payroll;
 select * from emp;

select ename ,dname from emp, DEPT;

for(int i=1;i<=4;++i){
	for(int j=1;j<=14;++j){
	read employee data;
	}
}

select * from emp, DEPT; 
SELECT dname , ename FROM emp, DEPT WHERE DEPT.DEPTNO=emp.deptno;
SELECT dept.DEPTNO, ename , dname FROM emp , DEPT WHERE DEPT.DEPTNO=emp.deptno;
--it make query more readeble

--SELECT DNAME TOATL SALARY WHERE THE TOTAL SALARY IS GREATER THAN 5000
SELECT dname ,sum(sal) As "Total Salary" from DEPT,emp  WHERE DEPT.DEPTNO=emp.deptno group by dname having sum(sal) > 5000;

--NOTE
--The join based on equality coditions is called as EQUI JOIN (Natural join)
--a != within a join makes it non equi or InEqui join (Majorly used for Exception Reports)

--displays matching rows of both the tables
SELECT dept.DEPTNO, emp.ename , dept.dname FROM EMP, DEPT


--LEFT OUTER JOIN
select dept.DEPTNO, ename , dname FROM emp LEFT OUTER JOIN dept ON DEPT.DEPTNO = emp.deptno;

--FULL OUER JOIN
select DEPT.DEPTNO , ename , dname FROM emp FULL OUTER JOIN DEPT ON DEPT.DEPTNO= emp.deptno
 --cartesian JOIN (CROSS JOIN)
 -- A Join without and where clause is called as cartesian join
 --Just because you take cross product of two tables , it is also called Cross join

 select dname ,ename FROM emp , DEPT

 --SELF JOIN
 SELECT * FROM emp;

 --create two copies of emp
 --emp1      emp2
 select * INTO emp1 FROM emp
 select * INTO emp2 FROM emp

 SELECT * FROM emp1;
 SELECT * FROM emp2


 --ans
 select a.ename , b.ename FROM emp b, emp a where a.mgr= b.empno;

 --the table are created in the server's ram
 -- once the data is selected the temp tables are deleted
 --slowest JOIN as teh entire table is copied in the server's ram
 --*****ALIAS for table names should be only gives when there is a SELF JOIN



 select ename , min(sal) from emp ;





 SELECT * FROM EMP WHERE ENAME != 'SMITH' AND DEPTNO = (SELECT DEPTNO FROM emp WHERE ENAME = 'SMITH'
 delete from emp where job =(select job from emp where ename = 'smite';
 -- update a deptno where the 

 update emp set sal =10000 where deptno = (select deptno from emp where ename = 'SMITH');

 select * from emp where sal = ANY(select sal from emp where job = 'MANAGER');
 BEGIN TRANSACTION
 --find all the emp who's salary is greater than any of the salarite sin dpt 20;
 select * from emp where sal > any (select sal from emp where deptno =20);


 select min(sal) from emp where sal>= (select min(sal) from emp where job = 'MANAGER');

 --emp who's sal is greater than max sal of manager

 select * from emp where sal>(select max(sal) from emp where job='MANAGER')
 select * from emp;
 select * from dept
 select * from dept where DEPTNO IN (select distinct deptno from emp);
 --IN take a value with the particular values;



 --USE OF ANY
-- select pno from product where price < any(select price from products where categoryId = 204)
 


 --when u have retreve data from two tables and u are using distinct then instent of use join use exists (subquery);

 --select dept.deptno from emp ,dept where dept.deptno = emp.deptno;
 select dname from dept where exists (select deptno from emp where deptno = emp.deptno) --more flexible

 --select dname from dept

 --why we goes for exists:=> when there is join and distinct both. then go for exists because there is join + sorting .
 --because of exiest ... the main query execute first rather than subquery

 --with EXIST only when the first occurrence is found the loop is broken
 --No full table scan unless there non matchingrow;
 --