create database bank
 
CREATE TABLE Customers (
  CustomerId INT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  Address VARCHAR(255) NOT NULL,
  PhoneNumber VARCHAR(20) NOT NULL,
  Email VARCHAR(100) NOT NULL UNIQUE,
  DateOfBirth DATE NOT NULL,
  AccountOpeningDate DATE NOT NULL
);

insert into Customers values(100, 'Sumit', 'Kamothe', 9137705219, 'sumit@gmail.com', '2002-04-29', '2024-08-08')
insert into Customers values(101, 'Ramprakash', 'Raigad', 9122334459, 'rayozin@gmail.com', '2002-01-08', '2024-09-08')
insert into Customers values(102, 'Prathemesh', 'Kalyan', 9133778890, 'prathamesh@gmail.com', '2002-04-29', '2024-08-08')
insert into Customers values(103, 'Vedant', 'Kalyan', 9137705219, 'vedant@gmail.com', '2002-01-01', '2024-08-29 ')
 
CREATE TABLE Accounts (
  AccountId INT PRIMARY KEY,
  CustomerId INT NOT NULL,
  AccountType VARCHAR(20) NOT NULL,
  Balance MONEY NOT NULL DEFAULT 0.00,
  DateOpened DATE NOT NULL,
  FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
  CHECK (Balance >= 0)
);
 
CREATE TABLE Transactions (
  TransactionId INT PRIMARY KEY,
  AccountId INT NOT NULL,
  TransactionType VARCHAR(20) NOT NULL,
  Amount MONEY NOT NULL,
  TransactionDate DATE NOT NULL,
  FOREIGN KEY (AccountId) REFERENCES Accounts(AccountId)
);
 
CREATE TABLE Loans (
  LoanId INT PRIMARY KEY, 
  CustomerId INT NOT NULL,
  LoanType VARCHAR(20) NOT NULL,
  LoanAmount MONEY NOT NULL,
  InterestRate DECIMAL(5, 2) NOT NULL,
  LoanStartDate DATE NOT NULL,
  LoanEndDate DATE NOT NULL,
  FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
  CHECK (LoanEndDate >= LoanStartDate)
);
 
CREATE TABLE Branches (
  BranchId INT PRIMARY KEY,
  BranchName VARCHAR(100) NOT NULL,
  BranchAddress VARCHAR(255) NOT NULL,
  BranchPhoneNumber VARCHAR(20) NOT NULL
);
 
CREATE TABLE AccountBranches (
  AccountBranchId INT PRIMARY KEY,
  AccountId INT NOT NULL,
  BranchId INT NOT NULL,
  FOREIGN KEY (AccountId) REFERENCES Accounts(AccountId),
  FOREIGN KEY (BranchId) REFERENCES Branches(BranchId)
);
select * from Customers
CREATE OR ALTER PROCEDURE AddCustomer(
	@customerId INT,

)