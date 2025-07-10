--Voivodeship_Expenditure_Income


--Requirements:
--Microsoft SQL Server Management Studio 13.0
--data_for_sql.xlsx file



--Following is a presentation of SQL Sever skills
--Data loaded into this database originally comes from GUS BDL (https://bdl.stat.gov.pl/bdl/dane/podgrup/temat)
--Raw data has been previously converted using Excel and Python
--Data presents expenditures and incomes of every voivodeship in Poland plus data for Poland itself
--Data not only presents expenditure/income but also expenditure/income per capita and divided into budget categories


--Creating new database (created and scripted with New Database function)
--Change the FILENAME path to Your SQL Server DATA file


CREATE DATABASE [Voivodeship_budget]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Voivodeship_budget', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Voivodeship_budget.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Voivodeship_budget_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Voivodeship_budget_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Voivodeship_budget] SET COMPATIBILITY_LEVEL = 130
GO
ALTER DATABASE [Voivodeship_budget] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET ARITHABORT OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [Voivodeship_budget] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Voivodeship_budget] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Voivodeship_budget] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Voivodeship_budget] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Voivodeship_budget] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Voivodeship_budget] SET  READ_WRITE 
GO
ALTER DATABASE [Voivodeship_budget] SET RECOVERY FULL 
GO
ALTER DATABASE [Voivodeship_budget] SET  MULTI_USER 
GO
ALTER DATABASE [Voivodeship_budget] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Voivodeship_budget] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Voivodeship_budget] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Voivodeship_budget]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [Voivodeship_budget]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [Voivodeship_budget] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO


--Opening the new database


USE Voivodeship_budget
GO


--Importing data with SQL Server Importand Export Wizard (from data_for_sql.xlsx file) / data inspection


SELECT * FROM Dochody_budżetów_województw$
SELECT * FROM Dochody_na_1_mieszkańca$
SELECT * FROM Dochody_ogółem_Klasyfikacja$
SELECT * FROM Wydatki_na_1_mieszkańca$
SELECT * FROM Wydatki_ogółem_Klasyfikacja$
SELECT * FROM Wydatki_z_budżetu$


--Adding column headers


EXEC sp_rename 'dbo.dochody_budżetów_województw$.F1', 'Code', 'COLUMN';
EXEC sp_rename 'dbo.dochody_budżetów_województw$.F2', 'Voivodeship', 'COLUMN';
EXEC sp_rename 'dbo.dochody_budżetów_województw$.F3', 'Year', 'COLUMN';
EXEC sp_rename 'dbo.dochody_budżetów_województw$.F4', 'Budget_income', 'COLUMN';

EXEC sp_rename 'dbo.Dochody_na_1_mieszkańca$.F1', 'Code', 'COLUMN';
EXEC sp_rename 'dbo.Dochody_na_1_mieszkańca$.F2', 'Voivodeship', 'COLUMN';
EXEC sp_rename 'dbo.Dochody_na_1_mieszkańca$.F3', 'Year', 'COLUMN';
EXEC sp_rename 'dbo.Dochody_na_1_mieszkańca$.F4', 'Income_per_capita', 'COLUMN';

EXEC sp_rename 'dbo.Dochody_ogółem_Klasyfikacja$.F1', 'Code', 'COLUMN';
EXEC sp_rename 'dbo.Dochody_ogółem_Klasyfikacja$.F2', 'Voivodeship', 'COLUMN';
EXEC sp_rename 'dbo.Dochody_ogółem_Klasyfikacja$.F3', 'Year', 'COLUMN';
EXEC sp_rename 'dbo.Dochody_ogółem_Klasyfikacja$.F4', 'Income_total_classification', 'COLUMN';
EXEC sp_rename 'dbo.Dochody_ogółem_Klasyfikacja$.F5', 'Budget_category', 'COLUMN';

EXEC sp_rename 'dbo.Wydatki_na_1_mieszkańca$.F1', 'Code', 'COLUMN';
EXEC sp_rename 'dbo.Wydatki_na_1_mieszkańca$.F2', 'Voivodeship', 'COLUMN';
EXEC sp_rename 'dbo.Wydatki_na_1_mieszkańca$.F3', 'Year', 'COLUMN';
EXEC sp_rename 'dbo.Wydatki_na_1_mieszkańca$.F4', 'Expenditure_per_capita', 'COLUMN';

EXEC sp_rename 'dbo.Wydatki_ogółem_Klasyfikacja$.F1', 'Code', 'COLUMN';
EXEC sp_rename 'dbo.Wydatki_ogółem_Klasyfikacja$.F2', 'Voivodeship', 'COLUMN';
EXEC sp_rename 'dbo.Wydatki_ogółem_Klasyfikacja$.F3', 'Year', 'COLUMN';
EXEC sp_rename 'dbo.Wydatki_ogółem_Klasyfikacja$.F4', 'Expenditure_total_classification', 'COLUMN';
EXEC sp_rename 'dbo.Wydatki_ogółem_Klasyfikacja$.F5', 'Budget_category', 'COLUMN';

EXEC sp_rename 'dbo.Wydatki_z_budżetu$.F1', 'Code', 'COLUMN';
EXEC sp_rename 'dbo.Wydatki_z_budżetu$.F2', 'Voivodeship', 'COLUMN';
EXEC sp_rename 'dbo.Wydatki_z_budżetu$.F3', 'Year', 'COLUMN';
EXEC sp_rename 'dbo.Wydatki_z_budżetu$.F4', 'Budget_expenditure', 'COLUMN';


-- Turning "0" and "-" into NULLs


UPDATE dbo.Dochody_ogółem_Klasyfikacja$
   SET Income_total_classification = NULL
 WHERE Income_total_classification = '-' or Income_total_classification = '0,00' or Income_total_classification = '0'
GO
SELECT * FROM Dochody_ogółem_Klasyfikacja$

UPDATE dbo.Wydatki_ogółem_Klasyfikacja$
   SET Expenditure_total_classification = NULL
 WHERE Expenditure_total_classification = 0
GO
SELECT * FROM Wydatki_ogółem_Klasyfikacja$


--Changing data types


ALTER TABLE Dochody_budżetów_województw$
ALTER COLUMN Code int; 
ALTER TABLE Dochody_budżetów_województw$
ALTER COLUMN [Year] int; 
ALTER TABLE Dochody_budżetów_województw$
ALTER COLUMN Budget_income bigint; 
SELECT * FROM Dochody_budżetów_województw$

ALTER TABLE Dochody_na_1_mieszkańca$
ALTER COLUMN Code int; 
ALTER TABLE Dochody_na_1_mieszkańca$
ALTER COLUMN [Year] int; 
ALTER TABLE Dochody_na_1_mieszkańca$
ALTER COLUMN Income_per_capita int; 
SELECT * FROM Dochody_na_1_mieszkańca$

ALTER TABLE Dochody_ogółem_Klasyfikacja$
ALTER COLUMN Code int; 
ALTER TABLE Dochody_ogółem_Klasyfikacja$
ALTER COLUMN [Year] int; 
UPDATE Dochody_ogółem_Klasyfikacja$
SET Income_total_classification = REPLACE(Income_total_classification,',','.') FROM Dochody_ogółem_Klasyfikacja$
ALTER TABLE Dochody_ogółem_Klasyfikacja$
ALTER COLUMN Income_total_classification real; 
SELECT * FROM Dochody_ogółem_Klasyfikacja$
SELECT Income_total_classification FROM Dochody_ogółem_Klasyfikacja$ WHERE Income_total_classification = 14104017367.88 

ALTER TABLE Wydatki_na_1_mieszkańca$
ALTER COLUMN Code int; 
ALTER TABLE Wydatki_na_1_mieszkańca$
ALTER COLUMN [Year] int; 
ALTER TABLE Wydatki_na_1_mieszkańca$
ALTER COLUMN Expenditure_per_capita int; 
SELECT * FROM Wydatki_na_1_mieszkańca$

ALTER TABLE Wydatki_ogółem_Klasyfikacja$
ALTER COLUMN Code int; 
ALTER TABLE Wydatki_ogółem_Klasyfikacja$
ALTER COLUMN [Year] int; 
UPDATE Wydatki_ogółem_Klasyfikacja$
SET Expenditure_total_classification = REPLACE(Expenditure_total_classification,',','.') FROM Wydatki_ogółem_Klasyfikacja$
ALTER TABLE Wydatki_ogółem_Klasyfikacja$
ALTER COLUMN Expenditure_total_classification real; 
SELECT * FROM Wydatki_ogółem_Klasyfikacja$
SELECT Expenditure_total_classification FROM Wydatki_ogółem_Klasyfikacja$ WHERE Expenditure_total_classification < 13002732460.09

ALTER TABLE Wydatki_z_budżetu$
ALTER COLUMN Code int; 
ALTER TABLE Wydatki_z_budżetu$
ALTER COLUMN [Year] int; 
ALTER TABLE Wydatki_z_budżetu$
ALTER COLUMN Budget_expenditure bigint; 
SELECT * FROM Wydatki_z_budżetu$


--Creating primary keys for tables / ADD


ALTER TABLE Dochody_budżetów_województw$
ADD ExInID int IDENTITY(1,1)
ALTER TABLE Dochody_budżetów_województw$
ADD CONSTRAINT PK_Dochody_budżetów_województw$_ExInID PRIMARY KEY CLUSTERED (ExInID)

ALTER TABLE Wydatki_z_budżetu$
ADD ExInID int IDENTITY(1,1)
ALTER TABLE Wydatki_z_budżetu$
ADD CONSTRAINT PK_Wydatki_z_budżetu$_ExInID PRIMARY KEY CLUSTERED (ExInID)

ALTER TABLE Dochody_na_1_mieszkańca$
ADD Ex1In1ID int IDENTITY(1,1)
ALTER TABLE Dochody_na_1_mieszkańca$
ADD CONSTRAINT PK_Dochody_na_1_mieszkańca$_Ex1In1ID PRIMARY KEY CLUSTERED (Ex1In1ID)

ALTER TABLE Wydatki_na_1_mieszkańca$
ADD Ex1In1ID int IDENTITY(1,1)
ALTER TABLE Wydatki_na_1_mieszkańca$
ADD CONSTRAINT PK_Wydatki_na_1_mieszkańca$_Ex1In1ID PRIMARY KEY CLUSTERED (Ex1In1ID)

ALTER TABLE Dochody_ogółem_Klasyfikacja$
ADD ExClInClID int IDENTITY(1,1)
ALTER TABLE Dochody_ogółem_Klasyfikacja$
ADD CONSTRAINT PK_Dochody_ogółem_Klasyfikacja$_ExClInClID PRIMARY KEY CLUSTERED (ExClInClID)

ALTER TABLE Wydatki_ogółem_Klasyfikacja$
ADD ExClInClID int IDENTITY(1,1)
ALTER TABLE Wydatki_ogółem_Klasyfikacja$
ADD CONSTRAINT PK_Wydatki_ogółem_Klasyfikacja$_ExClInClID PRIMARY KEY CLUSTERED (ExClInClID)


--Second data inspection


SELECT TOP(10) * FROM Dochody_budżetów_województw$
SELECT TOP(10) * FROM Dochody_na_1_mieszkańca$
SELECT TOP(10) * FROM Dochody_ogółem_Klasyfikacja$
SELECT TOP(10) * FROM Wydatki_na_1_mieszkańca$
SELECT TOP(10) * FROM Wydatki_ogółem_Klasyfikacja$
SELECT TOP(10) * FROM Wydatki_z_budżetu$


--JOIN / ORDER BY


SELECT dbw.ExInID, dbw.Voivodeship, dbw.Year, dbw.Budget_income, wzb.Budget_expenditure, dbw.Budget_income - wzb.Budget_expenditure AS Budget_status
FROM Dochody_budżetów_województw$ AS dbw
JOIN Wydatki_z_budżetu$ AS wzb ON wzb.ExInID = dbw.ExInID
WHERE dbw.Voivodeship = 'POLSKA'
ORDER BY Budget_status DESC


--LIKE


SELECT * FROM Dochody_ogółem_Klasyfikacja$
WHERE Budget_category LIKE '%Kul%'

SELECT * FROM Wydatki_ogółem_Klasyfikacja$
WHERE Budget_category LIKE 'Dział 0__ -%'


--ADD / INSERT INTO / VALUES / DELETE / DROP COLUMN


ALTER TABLE Dochody_na_1_mieszkańca$
ADD ModifiedDate DATETIME
GO

UPDATE Dochody_na_1_mieszkańca$ SET ModifiedDate = GETDATE() WHERE ModifiedDate IS NULL
GO

INSERT INTO Dochody_na_1_mieszkańca$
([Code],[Voivodeship],[Year],[Income_per_capita],[ModifiedDate]) VALUES (3400000,'SEVENTEENTH VOIVODESHIP',2024,999,GETDATE())

DELETE FROM Dochody_na_1_mieszkańca$ WHERE Income_per_capita = 999

ALTER TABLE Dochody_na_1_mieszkańca$
DROP COLUMN ModifiedDate

SELECT * FROM Dochody_na_1_mieszkańca$


--IN / OR / AND / NOT / BETWEEN


SELECT * FROM Wydatki_na_1_mieszkańca$
WHERE Expenditure_per_capita IN(115, 439) OR Voivodeship IN('POLSKA', 'WIELKOPOLSKIE')

SELECT * FROM Wydatki_na_1_mieszkańca$
WHERE Code >= 1000000 AND Year <= 2010

SELECT * FROM Wydatki_na_1_mieszkańca$
WHERE NOT Voivodeship LIKE 'P%'

SELECT * FROM Wydatki_na_1_mieszkańca$
WHERE Expenditure_per_capita BETWEEN 100 AND 150
ORDER BY Expenditure_per_capita ASC


--DAY / MONTH / YEAR / DATEPART / DATEFIRST


ALTER TABLE Wydatki_na_1_mieszkańca$
ADD ModifiedDate DATETIME

UPDATE Wydatki_na_1_mieszkańca$ SET ModifiedDate = GETDATE() WHERE ModifiedDate IS NULL
SELECT * FROM  Wydatki_na_1_mieszkańca$

ALTER TABLE Wydatki_na_1_mieszkańca$
DROP COLUMN ModifiedDate

SET DATEFIRST 1
SELECT DAY(ModifiedDate) AS [Day], MONTH(ModifiedDate) AS [Month], YEAR(ModifiedDate) AS [Year], DATEPART(dw,ModifiedDate) AS 'WeekDay_MondayFirst'
FROM Wydatki_na_1_mieszkańca$


--DECLARE / SET / IF / PRINT / CAST


DECLARE @PopulationPL2002 bigint
DECLARE @PopulationPL2023 bigint
DECLARE @IncomePL2002 bigint
DECLARE @IncomePL2023 bigint
DECLARE @IncomePersonPL2002 bigint
DECLARE @IncomePersonPL2023 bigint

SET @PopulationPL2002 = 38218531
SET @PopulationPL2023 = 37636508
SET @IncomePL2002 = (SELECT Budget_income FROM Dochody_budżetów_województw$ WHERE Voivodeship = 'POLSKA' AND [Year] = 2002)
SET @IncomePL2023 = (SELECT Budget_income FROM Dochody_budżetów_województw$ WHERE Voivodeship = 'POLSKA' AND [Year] = 2023)
SET @IncomePersonPL2002 = (SELECT Income_per_capita FROM Dochody_na_1_mieszkańca$ WHERE Voivodeship = 'POLSKA' AND [Year] = 2002)
SET @IncomePersonPL2023 = (SELECT Income_per_capita FROM Dochody_na_1_mieszkańca$ WHERE Voivodeship = 'POLSKA' AND [Year] = 2023)

IF @IncomePL2002/@PopulationPL2002 = @IncomePersonPL2002
	BEGIN
		PRINT 'Data on population and total expenditure obtained from the GUS BDL when divided returns the result of expenditure per capita value from GUS BDL'
		PRINT 'Data on expenditure per capita from GUS BDL is correct'
	END
ELSE
	BEGIN
		PRINT 'Data for 2002 on population and total expenditure obtained from the GUS BDL when divided DOES NOT return the result of expenditure per capita value from GUS BDL.'
		PRINT 'Data for 2002 on expenditure per capita from GUS BDL is incorrect.'
		PRINT 'The difference between own calculations and the 2002 GUS BDL data = ' + CAST(((@IncomePL2002/@PopulationPL2002) - @IncomePersonPL2002) AS VARCHAR)
	END

IF @IncomePL2023/@PopulationPL2023 = @IncomePersonPL2023
	BEGIN
		PRINT 'Data for 2023 on population and total expenditure obtained from the GUS BDL when divided returns the result of expenditure per capita value from GUS BDL'
		PRINT 'Data for 2023 on expenditure per capita from GUS BDL is CORRECT'
	END
ELSE
	BEGIN
		PRINT 'Data on population and total expenditure obtained from the GUS BDL when divided DOES NOT return the result of expenditure per capita value from GUS BDL.'
		PRINT 'Data on expenditure per capita from GUS BDL is INCORRECT.'
		PRINT 'The difference between own calculations and the 2023 GUS BDL data = ' + CAST(((@IncomePL2023/@PopulationPL2023) - @IncomePersonPL2023) AS VARCHAR)
	END


--CEILING / FLOOR / ABS / RAND / ROUND


SELECT CEILING(1.5), CEILING(2.3), CEILING(-0.5), CEILING(-2.5)

SELECT FLOOR(1.5), FLOOR(2.3), FLOOR(-0.5), FLOOR(-2.5)

SELECT ABS(100), ABS(-100)

DECLARE @random float
SET @random = RAND()*10
SELECT @random, ROUND(@random,0)


--Temporary table / MAX / MIN / AVG / SUM / COUNT


CREATE TABLE #Example(Id INT IDENTITY PRIMARY KEY, [Name] NVARCHAR(10), Random FLOAT, ModifiedDate DATETIME)
INSERT INTO #Example ([Name], [Random], [ModifiedDate]) VALUES ('First', ROUND(RAND()*100,0), GETDATE())
INSERT INTO #Example ([Name], [Random], [ModifiedDate]) VALUES ('Second', ROUND(RAND()*100,0), GETDATE())
INSERT INTO #Example ([Name], [Random], [ModifiedDate]) VALUES ('Third', ROUND(RAND()*100,0), GETDATE())
INSERT INTO #Example ([Name], [Random], [ModifiedDate]) VALUES ('Fourth', ROUND(RAND()*100,0), GETDATE())
INSERT INTO #Example ([Name], [Random], [ModifiedDate]) VALUES ('Fifth', ROUND(RAND()*100,0), GETDATE())
SELECT * FROM #Example
SELECT MAX(Random) AS 'Max' FROM #Example 
SELECT MIN(Random) AS 'Min' FROM #Example
SELECT AVG(Random) AS 'Avg' FROM #Example
SELECT SUM(Random) AS 'Sum' FROM #Example
SELECT COUNT(Random) AS 'Count' FROM #Example
DROP TABLE #Example


--CASE / WHEN / ELSE / CONVERT / IIF / OR


ALTER TABLE Wydatki_ogółem_Klasyfikacja$
ADD Voivodeship_eng NVARCHAR(20)
UPDATE Wydatki_ogółem_Klasyfikacja$
SET Voivodeship_eng = 
	CASE
		WHEN CONVERT(NVARCHAR(20), Code) = '200000' THEN 'Lower Silesian'
		WHEN CONVERT(NVARCHAR(20), Code) = '400000' THEN 'Kuyavian-Pomeranian'
		WHEN CONVERT(NVARCHAR(20), Code) = '600000' THEN 'Lublin'
		WHEN CONVERT(NVARCHAR(20), Code) = '800000' THEN 'Lubusz'
		WHEN CONVERT(NVARCHAR(20), Code) = '1000000' THEN 'Łódź'
		WHEN CONVERT(NVARCHAR(20), Code) = '1200000' THEN 'Lesser Poland'
		WHEN CONVERT(NVARCHAR(20), Code) = '1400000' THEN 'Masovian'
		WHEN CONVERT(NVARCHAR(20), Code) = '1600000' THEN 'Opole'
		WHEN CONVERT(NVARCHAR(20), Code) = '1800000' THEN 'Subcarpathian'
		WHEN CONVERT(NVARCHAR(20), Code) = '2000000' THEN 'Podlaskie'
		WHEN CONVERT(NVARCHAR(20), Code) = '2200000' THEN 'Pomeranian'
		WHEN CONVERT(NVARCHAR(20), Code) = '2400000' THEN 'Silesian'
		WHEN CONVERT(NVARCHAR(20), Code) = '2600000' THEN 'Holy Cross'
		WHEN CONVERT(NVARCHAR(20), Code) = '2800000' THEN 'Warmian-Masurian'
		WHEN CONVERT(NVARCHAR(20), Code) = '3000000' THEN 'Greater Poland'
		WHEN CONVERT(NVARCHAR(20), Code) = '3200000' THEN 'West Pomeranian'
		ELSE 'Poland'
	END
SELECT * FROM Wydatki_ogółem_Klasyfikacja$

ALTER TABLE Wydatki_ogółem_Klasyfikacja$
ADD Poland_region NVARCHAR(20)
UPDATE Wydatki_ogółem_Klasyfikacja$
SET Poland_region = 
	IIF(Code = 0, 'Poland', IIF(Code = 200000 OR Code = 400000 OR Code = 800000 OR Code = 1600000 OR Code = 2200000 OR Code = 3000000 OR Code = 3200000, 'West_Poland','East_Poland'))
SELECT * FROM Wydatki_ogółem_Klasyfikacja$

ALTER TABLE Wydatki_ogółem_Klasyfikacja$
DROP COLUMN Voivodeship_eng, Poland_region
SELECT * FROM Wydatki_ogółem_Klasyfikacja$


--CHOOSE


SELECT [Year], Income_per_capita, Voivodeship, CHOOSE((
	CASE
		WHEN Code = '0' THEN 1
		WHEN Code = '200000' THEN 2
		WHEN Code = '400000' THEN 3
		WHEN Code = '600000' THEN 4
		WHEN Code = '800000' THEN 5
		WHEN Code = '1000000' THEN 6
		WHEN Code = '1200000' THEN 7
		WHEN Code = '1400000' THEN 8
		WHEN Code = '1600000' THEN 9
		WHEN Code = '1800000' THEN 10
		WHEN Code = '2000000' THEN 11
		WHEN Code = '2200000' THEN 12
		WHEN Code = '2400000' THEN 13
		WHEN Code = '2600000' THEN 14
		WHEN Code = '2800000' THEN 15
		WHEN Code = '3000000' THEN 16
		WHEN Code = '3200000' THEN 17
	END
), 'pl', 'ds', 'kp', 'lube', 'lubu', 'lod', 'mal', 'maz', 'op', 'podk', 'podl', 'pom', 'sl', 'sw', 'wm', 'wi', 'za') AS Voivodeship_abbreviation
FROM Dochody_na_1_mieszkańca$


--GROUP BY / HAVING


SELECT [Year], COUNT(*) AS Number_of_regions
FROM Dochody_na_1_mieszkańca$
GROUP BY [Year]
ORDER BY [Year] ASC

SELECT [Year], MAX(Income_per_capita) AS Max_Income_per_capita, MIN(Income_per_capita) AS Min_Income_per_capita, AVG(Income_per_capita) AS Avg_Income_per_capita
FROM Dochody_na_1_mieszkańca$
GROUP BY [Year]

SELECT Budget_category, SUM(Expenditure_total_classification) AS Expenditure_total_classification_10yearSum_Poland_2010to2020, SUM(Expenditure_total_classification)/10 AS Expenditure_total_classification_10yearSum_Poland_2010to2020_Avg
FROM Wydatki_ogółem_Klasyfikacja$
WHERE Voivodeship = 'Polska' AND [Year] >=2010 AND [Year] <=2020
GROUP BY Budget_category
HAVING Budget_category LIKE 'Dział 7%'

SELECT Voivodeship, Budget_category, SUM(Expenditure_total_classification) AS Sum_of_expenditure_total_classification_AllYears
FROM Wydatki_ogółem_Klasyfikacja$
WHERE NOT Voivodeship = 'POLSKA'
GROUP BY Voivodeship, Budget_category
ORDER BY Voivodeship, Budget_category


--ROLLUP / CUBE


SELECT Voivodeship, Budget_category, SUM(Income_total_classification) AS Sum_of_icome_total_classification_AllYears
FROM Dochody_ogółem_Klasyfikacja$
WHERE NOT Voivodeship = 'POLSKA' AND NOT Budget_category = 'ogółem'
GROUP BY ROLLUP (Voivodeship, Budget_category)
ORDER BY Voivodeship, Budget_category

SELECT Voivodeship, Budget_category, SUM(Income_total_classification) AS Sum_of_icome_total_classification_AllYears
FROM Dochody_ogółem_Klasyfikacja$
WHERE NOT Voivodeship = 'POLSKA' AND NOT Budget_category = 'ogółem'
GROUP BY CUBE (Voivodeship, Budget_category)
ORDER BY Voivodeship, Budget_category


--OUTER LEFT JOIN / FULL JOIN / SELECT INTO / MODULO


SELECT * INTO Dochody_na_1_mieszkańca$_EvenYears FROM Dochody_na_1_mieszkańca$
DELETE FROM Dochody_na_1_mieszkańca$_EvenYears WHERE [Year] % 2 = 1

SELECT w.Ex1In1ID, w.Code, w.Voivodeship, w.[Year], w.Expenditure_per_capita, d.Income_per_capita 
FROM Wydatki_na_1_mieszkańca$ AS w
LEFT JOIN Dochody_na_1_mieszkańca$_EvenYears AS d 
ON w.Ex1In1ID = d.Ex1In1ID

SELECT w.Ex1In1ID, w.Code, w.Voivodeship, w.[Year], w.Expenditure_per_capita, d.Income_per_capita 
FROM Wydatki_na_1_mieszkańca$ AS w
FULL JOIN Dochody_na_1_mieszkańca$_EvenYears AS d 
ON w.Ex1In1ID = d.Ex1In1ID

DROP TABLE Dochody_na_1_mieszkańca$_EvenYears


--CONNECTING MANY TABLES (MULTIPLE JOIN)


SELECT * INTO Dochody_na_1_mieszkańca$_RandomColumn FROM Dochody_na_1_mieszkańca$
ALTER TABLE Dochody_na_1_mieszkańca$_RandomColumn
DROP COLUMN Income_per_capita

ALTER TABLE Dochody_na_1_mieszkańca$_RandomColumn
ADD RandomColumn INT
UPDATE Dochody_na_1_mieszkańca$_RandomColumn SET RandomColumn = (RAND()*10) * Ex1In1ID

SELECT w.Ex1In1ID, w.Code, w.Voivodeship, w.[Year], w.Expenditure_per_capita, d.Income_per_capita, r.RandomColumn
FROM Wydatki_na_1_mieszkańca$ AS w
JOIN Dochody_na_1_mieszkańca$ AS d ON w.Ex1In1ID = d.Ex1In1ID
JOIN Dochody_na_1_mieszkańca$_RandomColumn AS r ON d.Ex1In1ID = r.Ex1In1ID

DROP TABLE Dochody_na_1_mieszkańca$_RandomColumn


--BEGIN TRANSACTION / ROLLBACK / COMMIT / COMMIT (with a mistake) / OVER


BEGIN TRANSACTION
	DELETE FROM Dochody_budżetów_województw$ WHERE NOT Voivodeship = 'POLSKA'
	SELECT [Year], Voivodeship, SUM(Budget_income) OVER (ORDER BY exinid) FROM Dochody_budżetów_województw$
ROLLBACK

BEGIN TRANSACTION
	ALTER TABLE Dochody_budżetów_województw$
	ADD Budget_income_thousands BIGINT
	ALTER TABLE Dochody_budżetów_województw$
	ADD Budget_income_millions BIGINT
	ALTER TABLE Dochody_budżetów_województw$
	ADD Budget_income_billions BIGINT
	GO
	UPDATE Dochody_budżetów_województw$
	SET Budget_income_thousands = Budget_income/1000
	UPDATE Dochody_budżetów_województw$
	SET Budget_income_millions = Budget_income/1000000
	UPDATE Dochody_budżetów_województw$
	SET Budget_income_billions = Budget_income/1000000000
	GO
	SELECT [Year], Voivodeship, 
	SUM(Budget_income) OVER (ORDER BY exinid) AS Budget_income_increment, 
	SUM(Budget_income_thousands) OVER (ORDER BY exinid) AS Budget_income_thousands_increment, 
	SUM(Budget_income_millions) OVER (ORDER BY exinid) AS Budget_income_millions_increment, 
	SUM(Budget_income_billions) OVER (ORDER BY exinid)AS Budget_income_billions_increment  
	FROM Dochody_budżetów_województw$
	WHERE Voivodeship = 'POLSKA'
COMMIT

ALTER TABLE Dochody_budżetów_województw$
DROP COLUMN Budget_income_thousands, Budget_income_millions, Budget_income_billions
SELECT * FROM Dochody_budżetów_województw$

BEGIN TRANSACTION
	INSERT INTO Dochody_budżetów_województw$
	([Code],[Voivodeship],[Year],[Budget_income]) VALUES (3400000,'SEVENTEENTH VOIVODESHIP',2024,999)
	UPDATE Dochody_budżetów_województw$
	SET Budget_income = 111 WHERE Voivodeship = 'SEVENTEENTH VOIVODESHIP'
	--Mistake below (no UPDATE)
	SET Voivodeship = '17 VOIVODESHIP' WHERE Budget_income = 111
	SELECT * FROM Dochody_budżetów_województw$
COMMIT


--Subqueries / EXISTS / ALL / SOME / ANY


SELECT * FROM Wydatki_na_1_mieszkańca$ AS w
WHERE w.Ex1In1ID IN (SELECT Ex1In1ID FROM Dochody_na_1_mieszkańca$ WHERE Income_per_capita < 100 AND NOT Voivodeship = 'POLSKA')

ALTER TABLE Wydatki_na_1_mieszkańca$
ADD Voivodeship_Year NVARCHAR(255)
GO
UPDATE Wydatki_na_1_mieszkańca$
SET Voivodeship_Year = 'Voivodeship_' + CAST([Year] AS NVARCHAR(255))
GO
ALTER TABLE Wydatki_z_budżetu$
ADD Voivodeship_Year NVARCHAR(255)
GO
UPDATE Wydatki_z_budżetu$
SET Voivodeship_Year = 'Voivodeship_' + CAST([Year] AS NVARCHAR(255))
GO

SELECT COUNT(*) FROM Wydatki_na_1_mieszkańca$ AS m
WHERE EXISTS (SELECT * FROM Wydatki_z_budżetu$ AS b WHERE m.Voivodeship_Year = b.Voivodeship_Year)

SELECT * FROM Wydatki_na_1_mieszkańca$ AS m
WHERE m.Expenditure_per_capita > ALL (SELECT m.Expenditure_per_capita FROM Wydatki_na_1_mieszkańca$ WHERE m.Voivodeship = 'POLSKA')

SELECT * FROM Wydatki_na_1_mieszkańca$ AS m
WHERE m.Expenditure_per_capita <= SOME (SELECT m.Expenditure_per_capita FROM Wydatki_na_1_mieszkańca$ WHERE m.Voivodeship = 'POLSKA')

SELECT * FROM Wydatki_na_1_mieszkańca$ AS m
WHERE m.Expenditure_per_capita <= ANY (SELECT m.Expenditure_per_capita FROM Wydatki_na_1_mieszkańca$ WHERE m.Voivodeship = 'POLSKA')

ALTER TABLE Wydatki_na_1_mieszkańca$
DROP COLUMN Voivodeship_Year
ALTER TABLE Wydatki_z_budżetu$
DROP COLUMN Voivodeship_Year
SELECT * FROM Wydatki_na_1_mieszkańca$
SELECT * FROM Wydatki_z_budżetu$


--UNION / UNION ALL / INTERSECT / EXCEPT


SELECT *
INTO Wydatki_ogółem_Klasyfikacja$_2008_to_2012
FROM Wydatki_ogółem_Klasyfikacja$

SELECT *
INTO Wydatki_ogółem_Klasyfikacja$_2013_to_2023
FROM Wydatki_ogółem_Klasyfikacja$

DELETE FROM Wydatki_ogółem_Klasyfikacja$_2008_to_2012 WHERE [Year] > 2012
DELETE FROM Wydatki_ogółem_Klasyfikacja$_2013_to_2023 WHERE [Year] <= 2012

SELECT * FROM Wydatki_ogółem_Klasyfikacja$_2008_to_2012
UNION
SELECT * FROM Wydatki_ogółem_Klasyfikacja$_2013_to_2023
ORDER BY [Year] ASC

SELECT *
INTO Wydatki_ogółem_Klasyfikacja$_2008_to_2013
FROM Wydatki_ogółem_Klasyfikacja$

SELECT *
INTO Wydatki_ogółem_Klasyfikacja$_2011_to_2023
FROM Wydatki_ogółem_Klasyfikacja$

DELETE FROM Wydatki_ogółem_Klasyfikacja$_2008_to_2013 WHERE [Year] > 2013
DELETE FROM Wydatki_ogółem_Klasyfikacja$_2011_to_2023 WHERE [Year] <= 2011

SELECT * FROM Wydatki_ogółem_Klasyfikacja$_2008_to_2013
UNION ALL
SELECT * FROM Wydatki_ogółem_Klasyfikacja$_2011_to_2023
ORDER BY [Year] ASC

SELECT * FROM Wydatki_ogółem_Klasyfikacja$_2008_to_2013
INTERSECT
SELECT * FROM Wydatki_ogółem_Klasyfikacja$_2011_to_2023
ORDER BY [Year] ASC

SELECT * FROM Wydatki_ogółem_Klasyfikacja$_2008_to_2013
EXCEPT
SELECT * FROM Wydatki_ogółem_Klasyfikacja$_2011_to_2023
ORDER BY [Year] ASC

DROP TABLE Wydatki_ogółem_Klasyfikacja$_2008_to_2013
DROP TABLE Wydatki_ogółem_Klasyfikacja$_2011_to_2023
DROP TABLE Wydatki_ogółem_Klasyfikacja$_2008_to_2012
DROP TABLE Wydatki_ogółem_Klasyfikacja$_2013_to_2023


--WHILE / NOCOUNT / BEGIN / END


SELECT *
INTO Dochody_budżetów_województw$_NoYear
FROM Dochody_budżetów_województw$

UPDATE Dochody_budżetów_województw$_NoYear
SET [Year] = NULL

SET NOCOUNT ON
DECLARE @y INT = 1999
DECLARE @count INT = 1
WHILE NOT @count = (SELECT COUNT(*) FROM Dochody_budżetów_województw$_NoYear)
BEGIN
	UPDATE Dochody_budżetów_województw$_NoYear
	SET [Year] = @y WHERE ExInID = @count
	IF NOT @count % 17 = 0
		BEGIN
			SET @count += 1
		END
	ELSE
		BEGIN
			SET @y += 1
			SET @count += 1
		END
END
PRINT @count
PRINT @y
SELECT * FROM Dochody_budżetów_województw$_NoYear

DROP TABLE Dochody_budżetów_województw$_NoYear
