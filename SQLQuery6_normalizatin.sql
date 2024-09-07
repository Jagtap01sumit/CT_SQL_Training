--Normalization


--empno		ename	 job	hiredate		sal		deptno	deptname	deptloc
--001		jill	cleark	'2024-02-02'  10000		10		Service		Mumbai
--002		Jack	Manager	'2023-12-25'  120000	20		Service		Mumbai
--003		Suraj	TL	    '2022-05-03'  90000		20		Service		Mumbai
--003		Amit	cleark	'2021-09-02'  30000		10		Service		Mumbai



--use payroll;

--CREATE TABLE TABLE_NAME
--(
	--COLUMN_NAME DATA_TYPE CONSTRAINT
--)
CREATE TABLE Employee(
empno INT NOT NULL,
ename VARCHAR(25) NOT NULL,
job VARCHAR(25) NOT NULL,
Hiredate DATE NOT NULL,
sal FLOAT NOT NULL,
comm FLOAT NOT NULL,
deptno INT NOT NULL,
CONSTRAINT PK_EMPLOYEE_EMPNO PRIMARY KEY(empno),
CONSTRAINT FK_EMPLOYEE_DEPARTMENT FOREIGN KEY (deptno) references Department (deptno),
CONSTRAINT CK_EMPLOYEE_SAL CHECK(sal>0)

)

CREATE TABLE Department
(
	deptno INT NOT NULL,
	dname VARCHAR(25) NOT NULL,
	dloc VARCHAR(25) NOT NULL
	CONSTRAINT PK_DEPTNO PRIMARY KEY(deptno)
)
DROP TABLE Department;
INSERT INTO Department(deptno , dname , dloc) VALUES(10,'Accounting','Mumbai');
SELECT * FROM Department;
