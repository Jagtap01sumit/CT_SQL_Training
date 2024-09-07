CREATE DATABASE Bank
 
USE Bank
GO

use bank;
 
CREATE TABLE CustomersInfo(
	CustomerId INT NOT NULL,
	UserName VARCHAR(16) NOT NULL,
	UserAddress VARCHAR(25) NOT NULL,
	PhoneNumber VARCHAR(12) NOT NULL,
	Email VARCHAR(25) NOT NULL UNIQUE,
	DateOfBirth DATE NOT NULL,
	AccountOpeningDate DATE NOT NULL,
	CONSTRAINT PK_CUSTOMERID PRIMARY KEY(CustomerId)
)
 
/*
   - Accounts: Stores account details for customers.
     - AccountId 
     - CustomerId 
     - AccountType (Savings, Current, etc.)
     - Balance
     - DateOpened
*/
CREATE TABLE AccountsInfo(
	AccountId INT NOT NULL,
	CustomerId INT NOT NULL,
	AccountType VARCHAR(25) ,
	Balance MONEY ,
	DateOpened DATE,
	CONSTRAINT PK_ACCOUNTID PRIMARY KEY(AccountId),
	CONSTRAINT FK_ACCOUNTINFO_CUSTOMERID FOREIGN KEY(CustomerId) REFERENCES CustomersInfo(CustomerId),
	CONSTRAINT CK_BALANCE CHECK(Balance>=0))
 

 
CREATE TABLE Transactions(
	TransactionId INT NOT NULL,
	AccountId INT NOT NULL,
	TransactionType VARCHAR(25) NOT NULL,
	Amount MONEY NOT NULL,
	TransactionDate DATE,
	CONSTRAINT PK_ACCOUNTID_TRANSACTION PRIMARY KEY(TransactionId),
	--CONSTRAINT FK_TRANSACTIONS_ACCOUNTID FOREIGN KEY(AccountId) REFERENCES AccountsInfo(AccountId),
	CONSTRAINT CK_AMOUNT CHECK(Amount > 0)
)
 drop table transactions

CREATE TABLE LoansInfo(
	LoanId INT NOT NULL UNIQUE,
	CustomerId INT NOT NULL,
	LoanType VARCHAR(25) NOT NULL,
	LoanAmount MONEY,
	InterestRate DECIMAL(5, 2),
	LoanStartDate DATE,
	LoanEndDate DATE,
	CONSTRAINT PK_LOANID PRIMARY KEY(LoanId),
	CONSTRAINT FK_ACCOUNTINFO_CUSTOMERID_LOAN FOREIGN KEY(CustomerId) REFERENCES CustomersInfo(CustomerId),
	CONSTRAINT CK_LOAN_DATES CHECK(LoanEndDate > LoanStartDate)
)
 
/*
	- Branches: Stores branch details.
     - BranchId  
     - BranchName
     - BranchAddress
     - BranchPhoneNumber
*/
 
CREATE TABLE Branch(
	BranchId INT,
	BranchName VARCHAR(100) NOT NULL,
	BranchAddress VARCHAR(200) NOT NULL,
	BranchPhoneNumber VARCHAR(25) NOT NULL,
	CONSTRAINT PK_BRANCHID PRIMARY KEY (BranchId)
)
 
/*
- AccountBranches: Relationship between accounts and branches.
     - AccountBranchId  
     - AccountId  
     - BranchId  
*/
 
CREATE TABLE AccountBranches(
	AccountBranchId INT NOT NULL,
	AccountId INT NOT NULL,
	BranchId INT NOT NULL,
	CONSTRAINT PK_ACCOUNTBRANCHID PRIMARY KEY (AccountBranchId),
	CONSTRAINT FK_ACCOUNTINFO_CUSTOERID FOREIGN KEY(AccountId) REFERENCES AccountsInfo(AccountId),
	CONSTRAINT FK_BRANCHINFO_CUSTOERID FOREIGN KEY(BranchId) REFERENCES Branch(BranchId)
)
 
CREATE TABLE CounterTable(
	Id VARCHAR(24) PRIMARY KEY NOT NULL,
	SeedValue INT NOT NULL,
	CurrentValue INT NOT NULL
)

 
INSERT INTO CounterTable(Id,SeedValue,CurrentValue) VALUES('Customer', 400, 0)
INSERT INTO CounterTable(Id,SeedValue,CurrentValue) VALUES('Account', 2341, 0)
INSERT INTO CounterTable(Id,SeedValue,CurrentValue) VALUES('Transaction', 4441, 0)
INSERT INTO CounterTable(Id,SeedValue,CurrentValue) VALUES('Loans', 4441, 0)
 
----DROP TABLE CounterTable
select * from CounterTable

create or alter function empsale(@salary int)
return int 
as 
begin
	return @salary +@salary*10%
	end

CREATE OR ALTER PROCEDURE AddCustomer(
	@CustomerId INT OUTPUT,
	@UserName VARCHAR(24),
	@UserAddress VARCHAR(24),
	@PhoneNo VARCHAR(12),
	@EmailId VARCHAR(24),
	@DOB DATE,
	@AOD DATE,

	@AccountId INT OUTPUT
)
AS
BEGIN
	BEGIN TRAN

	BEGIN TRY
		UPDATE CounterTable SET CurrentValue = CurrentValue + 1 WHERE Id='Customer'
		SELECT @CustomerId = SeedValue + CurrentValue FROM CounterTable WHERE Id='Customer'
		UPDATE CounterTable SET CurrentValue = CurrentValue + 1 WHERE Id='Account'
		SELECT @AccountId = SeedValue+CurrentValue FROM CounterTable WHERE Id = 'Account'
			IF EXISTS(SELECT 1 FROM CustomersInfo WHERE Email=@EmailId)
				BEGIN
					RAISERROR('ERROR: Customer already exists!', 16, 1) WITH NOWAIT;
				END
			IF EXISTS(SELECT 1 FROM AccountsInfo WHERE AccountId=@AccountId)
				BEGIN
					RAISERROR('ERROR:SOMETHING WENT WRONG',16,1)
				END
			ELSE
				BEGIN
					INSERT INTO CustomersInfo VALUES(@CustomerId, @UserName, @UserAddress, @PhoneNo, @EmailId, @DOB, GETDATE())
				INSERT INTO AccountsInfo(AccountId,CustomerId) VALUES(@AccountId,@CustomerId);
				END
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS 'ERR_MESSAGE'
		SELECT ERROR_NUMBER() AS 'ERR_NUMBER'
	END CATCH
	IF @@ERROR = 0 
	BEGIN
		COMMIT
	END
	ELSE
	BEGIN
		ROLLBACK
		SET @CustomerId = 0
		SET @AccountId=0
	END
END

BEGIN
	DECLARE @customerid INT
	DECLARE @AccountId INT
	DECLARE @CurrentDate DATE = GETDATE()
	EXEC AddCustomer @customerid OUTPUT, 'prajakta', 'vikroli', '81432205219', 'prajakta@gmail.com', '2002-06-03', @CurrentDate, @AccountId OUTPUT;
	

	SELECT @customerid;
END

CREATE OR ALTER PROCEDURE MakeTransaction(
    @TransactionId INT OUTPUT,
    @AccountId INT,
    @TransactionType VARCHAR(25),
    @Amount MONEY,
    @TransactionDate DATE
) AS 
BEGIN
    BEGIN TRAN
        BEGIN TRY
            UPDATE CounterTable SET CurrentValue = CurrentValue + 1 WHERE Id='Transaction'
            SELECT @TransactionId = SeedValue + CurrentValue FROM CounterTable WHERE Id='Transaction'
            
            IF EXISTS(SELECT 1 FROM Transactions WHERE TransactionId=@TransactionId)
                BEGIN
                    RAISERROR('ERROR: Something went wrong!', 16, 1) WITH NOWAIT;
                END
            
            ELSE
                IF EXISTS (
                    SELECT 1
                    FROM AccountsInfo
                    WHERE AccountId = @AccountId
                    AND (AccountId IS NULL OR CustomerId IS NULL OR AccountType IS NULL OR Balance IS NULL)
                )
                    BEGIN
                        RAISERROR('ERROR:Please fill complete Account details',16,1)
                    END
				ELSE 
					INSERT INTO transactions(TransactionId,AccountId,TransactionType,Amount,TransactionDate)
                    VALUES (@TransactionId, @AccountId, @TransactionType, @Amount, @TransactionDate)
              
        END TRY
        BEGIN CATCH
            SELECT ERROR_MESSAGE() AS 'ERR_MESSAGE'
            SELECT ERROR_NUMBER() AS 'ERR_NUMBER'
        END CATCH
        IF @@ERROR = 0 
            BEGIN
                COMMIT
            END
        ELSE
            BEGIN
                ROLLBACK
                SET @TransactionId = 0
            
            END
END
BEGIN
    DECLARE @TransactionId INT
 
    DECLARE @CurrentDate DATE = GETDATE()
    EXEC MakeTransaction @TransactionId OUTPUT, 2345, 'Deposit', 3000, @CurrentDate;
    
    SELECT @TransactionId;
END
BEGIN
    DECLARE @TransactionId INT
 
    DECLARE @CurrentDate DATE = GETDATE()
    EXEC MakeTransaction @TransactionId OUTPUT, 2345, 'Withdrawal', -4000, @CurrentDate;
    
    SELECT @TransactionId;
END
select * from transactions
select * from AccountsInfo


UPDATE AccountsInfo
SET AccountType = 'SAVING', Balance = 5000
WHERE AccountId = 2342;
UPDATE AccountsInfo
SET AccountType = 'SAVING', Balance =38062
WHERE AccountId = 2345;
 --start a trasfer fund
CREATE OR ALTER PROCEDURE TransferFund(
    @SenderAccountId INT,
    @ReceiverAccountId INT,
    @Amount MONEY,
    @TransactionDate DATE,
    @TransactionId INT OUTPUT
) AS 
BEGIN
    BEGIN TRAN
        BEGIN TRY
            UPDATE CounterTable SET CurrentValue = CurrentValue + 1 WHERE Id='Transaction'
            SELECT @TransactionId = SeedValue + CurrentValue FROM CounterTable WHERE Id='Transaction'
            
            IF EXISTS(SELECT 1 FROM Transactions WHERE TransactionId=@TransactionId)
                BEGIN
                    RAISERROR('ERROR: Something went wrong!', 16, 1) WITH NOWAIT;
                END
            
            ELSE
                IF NOT EXISTS (
                    SELECT 1
                    FROM AccountsInfo
                    WHERE AccountId = @SenderAccountId
                    AND CustomerId IS NOT NULL
                    AND AccountType IS NOT NULL
                    AND Balance IS NOT NULL
                )
                    BEGIN
                        RAISERROR('ERROR:Please fill complete Sender Account details',16,1)
                    END
                ELSE IF NOT EXISTS (
                    SELECT 1
                    FROM AccountsInfo
                    WHERE AccountId = @ReceiverAccountId
                    AND CustomerId IS NOT NULL
                    AND AccountType IS NOT NULL
                    AND Balance IS NOT NULL
                )
                    BEGIN
                        RAISERROR('ERROR:Please fill complete Receiver Account details',16,1)
                    END
				ELSE 
					INSERT INTO transactions(TransactionId,AccountId,TransactionType,Amount,TransactionDate)
                    VALUES (@TransactionId, @ReceiverAccountId, 'Deposit', @Amount, @TransactionDate )
					INSERT INTO transactions(TransactionId,AccountId,TransactionType,Amount,TransactionDate)
                    VALUES (@TransactionId, @SenderAccountId, 'Withdrawal', @Amount, @TransactionDate )
              
        END TRY
        BEGIN CATCH
            SELECT ERROR_MESSAGE() AS 'ERR_MESSAGE'
            SELECT ERROR_NUMBER() AS 'ERR_NUMBER'
            ROLLBACK
            SET @TransactionId = 0
        END CATCH
        IF @@TRANCOUNT > 0 
            BEGIN
                COMMIT
            END
END
GO
 --end a transfer fund 
--balancd not be a negative.
CREATE TRIGGER Prevent_Balance_Not_be_negative
ON Transactions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AccountId INT, @Amount MONEY, @TransactionType VARCHAR(25);

    SELECT @AccountId = i.AccountId, @Amount = i.Amount, @TransactionType = i.TransactionType 
    FROM inserted i;

    BEGIN TRY
        IF @TransactionType = 'Deposit'
            IF(@Amount <= 0)
                RAISERROR('ERROR: amount must be greater than zero!!', 16, 1);
            ELSE
                UPDATE a SET a.Balance = a.Balance + @Amount 
                FROM AccountsInfo a 
                WHERE a.AccountId = @AccountId;
        ELSE IF @TransactionType = 'Withdrawal'
            IF(@Amount <= 0)
                RAISERROR('ERROR: amount must be greater than zero!!', 16, 1);
            ELSE
                IF @Amount > (SELECT a.Balance FROM AccountsInfo a WHERE a.AccountId = @AccountId)
                    RAISERROR('ERROR: balance is less than the amount you are trying to withdraw!!', 16, 1);
                ELSE
                    UPDATE a SET a.Balance = a.Balance - @Amount 
                    FROM AccountsInfo a 
                    WHERE a.AccountId = @AccountId;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS 'ERR_MESSAGE';
        SELECT ERROR_NUMBER() AS 'ERR_NUMBER';
    END CATCH
END;
GO

BEGIN
    DECLARE @TransactionId INT
	
    DECLARE @CurrentDate DATE = GETDATE()
   EXEC TransferFund 
    @SenderAccountId = 2342, 
    @ReceiverAccountId = 2345, 
    @Amount = 3000, 
    @TransactionDate = @CurrentDate, 
    @TransactionId = @TransactionId OUTPUT;
    SELECT @TransactionId;
END
select * from transactions;
drop table counter
select * from accountsinfo
--practices 
--practices

DROP TRIGGER TRG_AddDeposit;
CREATE or alter FUNCTION TotalBalanceForCustomer(@CustomerId INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @TotalBalance MONEY = 0
 
    SELECT @TotalBalance =SUM(isnull(Balance,0))
    FROM Accountsinfo
    WHERE CustomerId = @  CustomerId
 
    RETURN @TotalBalance
END
SELECT dbo.TotalBalanceForCustomer(401)
select * from AccountsInfo

 CREATE OR ALTER PROCEDURE CreateLoan
(
    @LoanId INT OUTPUT,
    @CustomerId INT,
    @LoanType VARCHAR(20),
    @LoanAmount MONEY,
    @InterestRate MONEY,
    @LoanStartDate DATE,
    @LoanEndDate DATE
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN
		UPDATE CounterTable SET CurrentValue = CurrentValue + 1 WHERE Id = 'Loans'
        SELECT @LoanId = SeedValue + CurrentValue FROM CounterTable WHERE Id = 'Loans'
			
			IF NOT EXISTS (SELECT 1 FROM CustomersInfo WHERE CustomerId = @CustomerId)
			BEGIN
				RAISERROR('Customer does not exist', 16, 1)
				ROLLBACK TRAN
				RETURN
			END
 
			
			IF @LoanType NOT IN ('Personal', 'Mortgage', 'Auto', 'Student','Saving')
			BEGIN
				RAISERROR('Invalid loan type', 16, 1)
				ROLLBACK TRAN
				RETURN
			END
 
		
			IF @LoanAmount <= 0
			BEGIN
				RAISERROR('Loan amount must be greater than zero', 16, 1)
				ROLLBACK TRAN
				RETURN
			END
 
			
			IF @InterestRate <= 0
			BEGIN
				RAISERROR('Interest rate must be greater than zero', 16, 1)
				ROLLBACK TRAN
				RETURN
			END
 
			IF @LoanStartDate < GETDATE()
			BEGIN
				RAISERROR('Loan start date cannot be in the past', 16, 1)
				ROLLBACK TRAN
				RETURN
			END
 
			IF @LoanEndDate < @LoanStartDate
			BEGIN
				RAISERROR('Loan end date must be after loan start date', 16, 1)
				ROLLBACK TRAN
				RETURN
			END
       
        INSERT INTO LoansInfo(LoanId, CustomerId, LoanType, LoanAmount, InterestRate, LoanStartDate, LoanEndDate)
        VALUES (@LoanId, @CustomerId, @LoanType, @LoanAmount, @InterestRate, @LoanStartDate, @LoanEndDate)
 
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        DECLARE @ErrorMessage NVARCHAR(4000)
        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR (@ErrorMessage, 16, 1)
    END CATCH
END
 
BEGIN
    DECLARE @LoanId INT
    EXEC CreateLoan @LoanId OUTPUT,401,'SAVING',10000.00, 5.00,'2024-09-09','2025-01-01'
    SELECT @LoanId
END
CREATE FUNCTION CalculateTotalInterest (@LoanId INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @TotalInterest MONEY
    DECLARE @LoanAmount MONEY
    DECLARE @InterestRate MONEY
    DECLARE @LoanDuration INT
 
    SELECT @LoanAmount = LoanAmount, @InterestRate = InterestRate, 
           @LoanDuration = DATEDIFF(YEAR, LoanStartDate, LoanEndDate)
    FROM LoansInfo WHERE LoanId = @LoanId
 
    SET @TotalInterest  = (@LoanAmount * @InterestRate  * @LoanDuration)/100
 
    RETURN @TotalInterest 
END
select * from loansInfo
 
SELECT dbo.CalculateTotalInterest(4442)




----DROP TABLE CustomersInfo
----DROP TABLE AccountsInfo
----DROP TABLE Transactions
----DROP TABLE LoansInfo
----DROP TABLE AccountBranches
 
SELECT * FROM CustomersInfo
 select * from AccountsInfo
SELECT * FROM CounterTable
select * from Transactions
select * from LoansInfo

--assignment
--1) Write a query to list all customers along with their account details, including account type and balance.
select ci.CustomerId, ci.UserName,ci.UserAddress,ci.PhoneNumber,ci.Email,ci.DateOfBirth,ai.AccountId,ai.AccountType,ai.Balance from CustomersInfo ci , AccountsInfo ai where ci.CustomerId=ai.CustomerId

--2) Write a query to list all transactions, including the customer name and account type associated with each transaction.
SELECT 
    ci.CustomerId, 
    ci.Username, 
    ai.AccountType, 
    ti.TransactionType, 
    ti.Amount, 
    ti.TransactionDate
FROM 
    CustomersInfo ci
INNER JOIN 
    AccountsInfo ai ON ci.CustomerId = ai.CustomerId
INNER JOIN 
    Transactions ti ON ai.AccountId = ti.AccountId;
	select * from accountsInfo
--5) Write a query to list all customers who have made a transaction in the last month.
--select AccountId from Transactions where MONTH(transactionDate)= MONTH(MONTH(GETDATE())-1);
--MONTH(DATEADD(mm, -1, GETDATE())); -- its correct => because it only correct this years last month transaction not only last month from every year
select AccountId from Transactions where MONTH(transactionDate)= 08;
--6) Write a query to find all customers who have a balance greater than the average balance of all accounts.
select AccountId from AccountsInfo as subquery where balance > (select avg(balance) from accountsInfo);

--8) Write a CTE to list all customers along with their loan details if they have any.
select * from LoansInfo;
select * from CustomersInfo c INNER JOIN  LoansInfo l ON  c.CustomerId=l.CustomerId 

--10) Write a query to rank customers based on the total balance of their accounts.
SELECT a.CustomerId,a.balance,b.UserName, DENSE_RANK() OVER (ORDER BY a.Balance DESC) AS Dense_Rank FROM AccountsInfo a INNER JOIN CustomersInfo b ON a.CustomerId=b.CustomerId

--11) Write a query to find the top 5 accounts with the highest balances.
SELECT TOP 5 AccountId,Balance FROM AccountsInfo;

--13) Write a query to find all customers who have taken out a loan and also have a savings account with a balance greater than 50,000.
select CustomerId,LoanAmount from LoansInfo where LoanType='SAVING';
select * from LoansInfo

--16) Write a query to list all customers who have made more than 10 transactions in any given month.
select AccountId, MONTH(TransactionDate) from transactions group by MONTH(transactionDate)
select * from transactions
use bank;
select * from CustomersInfo
--select * from Transactions
--SELECT 
--    c.CustomerId, 
--    c.UserName, 
--    MONTH(t.TransactionDate) AS Month, 
--    COUNT(t.TransactionId) AS NumTransactions
--FROM 
--    CustomersInfo c
--JOIN 
--    Transactions t ON c.AccountId = t.AccountId
--GROUP BY 
--    c.CustomerId, c.UserName, MONTH(t.TransactionDate)
--HAVING 
--    COUNT(t.TransactionId) > 10;

-----------------------------------+++++++assignment++++++++=----------------------------------------------------------
/*

3) Write a query to find all branches where customers have accounts, including the branch name and address.

4) Write a query to find the total number of accounts each customer has.


7) Write a CTE to find the total balance of all accounts for each customer.

9) Write a CTE to find all branches with the total number of accounts opened in each branch.

10) Write a query to rank customers based on the total balance of their accounts.
12) Write a query to rank branches based on the total number of accounts opened in each branch.

14) Write a query to list all transactions where the customer has both a savings and a current account, and the transaction amount is more than 10000.
15) Write a query to list all branches and the number of customers who have accounts at each branch, including those branches with zero customers.
*/