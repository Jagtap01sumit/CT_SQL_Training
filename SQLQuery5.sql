use shop;

select * from OrderDetail
select * from Counters
CREATE OR ALTER PROCEDURE PlaceOrder(
	@CustomerId VARCHAR(16),
	@ProductNo INT,
	@Quantity INT,
	@OrderId INT OUTPUT
)
AS 
BEGIN
	BEGIN TRAN
	UPDATE Counters SET CurrentValue=CurrentValue+1 WHERE Id='order';
	SELECT @orderId=SeedValue+CurrentValue FROM Counters WHERE Id='order'
	INSERT INTO OrderDetail VALUES(@OrderId,GETDATE(),@CustomerId,@ProductNo,@Quantity)
	IF @@ERROR=0 COMMIT TRAN
	ELSE 
	BEGIN
		ROLLBACK TRAN
		SET @OrderId=0
	END
END

select * from Counters ; select * from OrderDetail

BEGIN
DECLARE @orderNo INT
EXEC PlaceOrder 'CU204',204,24,@orderNo OUTPUT
SELECT @orderNo
END

SELECT GETDATE();

SELECT * FROM ProductInfo;
SELECT * FROM Counters
SELECT * FROM OrderDetail

CREATE OR ALTER FUNCTION GetProductPriceById(@id INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @price MONEY
	SELECT @price = price FROM ProductInfo WHERE ProductNo=@id
	RETURN @price
END

SELECT dbo.GetProductPriceById(202)


--TABLE FUNCTION

CREATE OR ALTER FUNCTION GetProductByStock(@stock INT)
RETURNS TABLE
RETURN SELECT ProductNo,Price ,Stock FROM ProductInfo WHERE stock > @stock

SELECT * FROM dbo.GetProductByStock(40);



select * from OrderDetail


SELECT * INTO OrderDeleted FROM OrderDetail WHERE 2>5;
select * from OrderDeleted

CREATE OR ALTER TRIGGER TRG_OrderDeleted 
ON OrderDetail
AFTER DELETE
AS
BEGIN
    INSERT INTO OrderDeleted
    SELECT *
    FROM Deleted;
	PRINT 'Order Deleted'
END;

select * from OrderDeleted
select * from OrderDetail;
DELETE FROM OrderDetail WHERE OrderNo = 2010;



use payroll;

--Common Table Expression(CTE)
--CTE is a temporary result set which is used on a particular query for a specific perpose
---Once the related query is fired the CTE no more exists

WITH AverageCount AS(
SELECT deptno, COUNT(*) "emp_count" FROM emp WHERE YEAR(hiredate)='1981' GROUP BY deptno
) SELECT AVG(EMP_COUNT) FROM AverageCount;

select * from emp;


--the emp whose sal is greater than avg sal of these dept
SELECT deptno, sal FROM emp e WHERE sal > (SELECT AVG(sal) FROM emp WHERE deptno = e.deptno) ORDER BY deptno, sal;

WITH AverageSalary As(Select deptno, AVG(sal) "AvgSal" FROM emp GROUP BY deptno ) SELECT emp.empno,emp.ename,emp.sal,AverageSalary.deptno,AverageSalary.AvgSal
FROM emp JOIN AverageSalary ON emp.deptno=AverageSalary.deptno WHERE emp.sal>AverageSalary.AvgSal;



