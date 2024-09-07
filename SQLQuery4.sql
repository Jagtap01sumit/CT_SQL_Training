use shop;


CREATE OR ALTER PROCEDURE placeOrder(
@Customer VARCHAR(25),
@Product INT,
@Quantity INT,
@OrderId INT OUTPUT  ---ITS LIKE int * ptr
)
AS 
BEGIN
	BEGIN TRAN
		UPDATE Counters SET CurrentValue = CurrentValue+1 WHERE Id='order'
		SELECT @OrderId= SeedValue+CurrentValue FROM Counters WHERE Id='order'
		INSERT INTO OrderDetail VALUES(@OrderId,GETDATE(), @Customer,@Product,@Quantity)
		IF @@ERROR =0
			COMMIT TRAN
		ELSE
		BEGIN
			ROLLBACK TRAN
			SET @OrderId=0;
		END
END

BEGIN
	DECLARE @orderNo INT
	EXEC placeOrder 'CU501',202,5,@orderNo OUTPUT
	SELECT @orderNo
END

select * from counters;
select * from OrderDetail;


use payroll;

CREATE OR ALTER PROCEDURE addEmployee(
@empno INT,
@ename VARCHAR,
@job VARCHAR(25),
@mgr INT,
@hiredate DATE,
@sal FLOAT,
@comm FLOAT,
@deptno INT
) AS 
BEGIN 
	BEGIN TRY
		IF EXISTS(SELECT 1 FROM emp WHERE empno=@empno)
			RAISERROR('ERROR:Emploee already exists',16,1)
		ELSE 
			INSERT INTO emp(empno, ename, job,mgr,hiredate,sal,comm, deptno) VALUES(@empno,@ename,@job,@mgr,@hiredate,@sal,@comm,@deptno);
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS 'ERR_NUMBER'
		SELECT ERROR_MESSAGE() AS 'ERR_MESSAGE'
	END CATCH
END

EXEC addEmployee 9001,'jack','MANAGER',7321,'2022-08-02',5000,900,10;
select * from emp;