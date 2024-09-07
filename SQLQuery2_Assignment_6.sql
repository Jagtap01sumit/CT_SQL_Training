--1. Create a CTE that lists all employees with their department names.
use payroll

select * from dept;
select e.ename, d.dname from emp e, dept d where e.deptno=d.deptno;  

select * from emp;

--2. Create a CTE to find the total salary for each department.
WITH dept_sal_sum AS(select deptno,SUM(sal) "tatal sal" from emp group by deptno)
select * from dept_sal_sum

use payroll
--3. Create a CTE to rank employees by their salary within each department.
WITH emp_rank_sal_based AS(
select ename, sal,deptno, DENSE_RANK() OVER(PARTITION BY deptno Order by sal) sal_rank from emp
) select * from emp_rank_sal_based

WITH last_year_hiring AS (
  SELECT empno, ename, deptno, hiredate
  FROM emp
  WHERE YEAR(hiredate) = 2024
)
SELECT * FROM last_year_hiring;

--5. Create a CTE to list departments that have more than 5 employees.
with emp_count_grt_5 as(select deptno  from (select deptno ,COUNT(*) "emp_count"  from emp  group by deptno)  AS subquery
WHERE emp_count > 5)

--6) Create a CTE to calculate the total salary (including commission) for each employee.
select empno, ename , sal+ISNULL(comm,0)  "total sal" from emp ;

--7) Create a CTE to find the highest salary in each department.
select * from (select ename, sal,deptno, DENSE_RANK() OVER(PARTITION BY deptno Order by sal) sal_rank from emp group by sal,deptno,ename) AS subquery where sal_rank=1;

--8) Create a CTE to find the total number of orders placed by each customer.
use shop;
select * from OrderDetail

select CustomerId, COUNT(ProductNo) "No.of Orders" from OrderDetail group by CustomerId;

--9) Create a CTE to calculate the total quantity of products ordered by each customer.
select CustomerId, COUNT(ProductNo) "No.of Orders",SUM(Quantity)"total_quantity" from OrderDetail group by CustomerId;

--10) Create a CTE to find customers who have placed orders with a total quantity above 50.
select * from (select CustomerId, COUNT(ProductNo) "No.of Orders",SUM(Quantity)"total_quantity" from OrderDetail group by CustomerId) as subquery where total_quantity>50



--11) Create a CTE to find customers who have placed more than one order on a single day.
select * from (select  OrderDate,COUNT(CustomerId) "orders_count" from OrderDetail group by OrderDate,CustomerId) as subquery where orders_count>1;

--12)Create a CTE to calculate the total quantity ordered by each customer for each month.
select MONTH(OrderDate) "month" , CustomerId, SUM(Quantity) "quantity" from OrderDetail group by  MONTH(OrderDate),CustomerId;
select * from OrderDetail

--13) Create a CTE to calculate the average quantity of products ordered for each customer.
select CustomerId, AVG(Quantity) "avg_quantity_order" from OrderDetail group by CustomerId;

--14) Create a CTE to find the top 5 customers who have ordered the most quantity of products.

SELECT TOP 5 CustomerId, SUM(Quantity) AS TotalQuantity
FROM OrderDetail
GROUP BY CustomerId
ORDER BY SUM(Quantity) ASC;

--15) Create a CTE to list all orders placed within the last 30 days.
select * from (select OrderNo,CustomerId,ProductNo, Quantity,  DATEDIFF(Day,OrderDate,'2024-08-15') "date_diff" from OrderDetail ) as subquery where date_diff <=30 ;
