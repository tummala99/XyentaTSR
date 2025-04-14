--CREATE TABLE dbo.Employee
--(
--  [EmployeeID] int NOT NULL PRIMARY KEY CLUSTERED
--  , [Name] nvarchar(100) NOT NULL
--  , [Position] varchar(100) NOT NULL
--  , [Department] varchar(100) NOT NULL
--  , [Address] nvarchar(1024) NOT NULL
--  , [AnnualSalary] decimal (10,2) NOT NULL
--  , [ValidFrom] datetime2 GENERATED ALWAYS AS ROW START
--  , [ValidTo] datetime2 GENERATED ALWAYS AS ROW END
--  , PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
-- )
--WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory));

--	SELECT * FROM dbo.Employee
--	SELECT * FROM dbo.EmployeeHistory

--	SELECT * FROM Employee
--  FOR SYSTEM_TIME
--    BETWEEN '2014-01-01 00:00:00.0000000' AND '2015-01-01 00:00:00.0000000'
--      WHERE EmployeeID = 1000 ORDER BY ValidFrom;



	CREATE TABLE dbo.AuditWithTemporalTable   
	(    
		Emp_ID INT IDENTITY PRIMARY KEY
	  , EMP_FirstName NVARCHAR (50)
	  , EMP_LastName NVARCHAR (50)
	  , EMP_PhoneNumber NVARCHAR (50)
	  , Emp_adress NVARCHAR (MAX)
	  , TimeStart datetime2 (2) GENERATED ALWAYS AS ROW START NOT NULL
	  , TimeEnd datetime2 (2) GENERATED ALWAYS AS ROW END NOT NULL 
	  , PERIOD FOR SYSTEM_TIME (TimeStart, TimeEnd)  
	 )    
	 WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.AuditWithTemporalTableHistory));


	 INSERT INTO [dbo].[AuditWithTemporalTable]
			   ([EMP_FirstName]
			   ,[EMP_LastName]
			   ,[EMP_PhoneNumber]
			   ,[Emp_adress])
		  VALUES          ('Adam','Jack','965874555','AAABBBCCC'),
					 ('John','Rock','965874444','DDDEEEFFF'),
		   ('Faisal','Zaki','965874333','GGGHHHIII'),
		   ('Lamis','Oth','965874222','JJJKKKLLL'),
		   ('Ken','Yas','965874111','MMMNNNOOO')
		GO

	SELECT * FROM [dbo].[AuditWithTemporalTable]
	SELECT * FROM [dbo].[AuditWithTemporalTableHistory]


	UPDATE [dbo].[AuditWithTemporalTable]
	SET [EMP_LastName]='Othman1'
	WHERE [EMP_LastName]='Othman'
	GO
	UPDATE [dbo].[AuditWithTemporalTable]
	SET [EMP_PhoneNUmber]='Othman1'
	WHERE [Emp_ID]=5
	GO


	UPDATE [dbo].[AuditWithTemporalTable]
	SET [EMP_PhoneNUmber]='1514444'
	WHERE [Emp_ID]=5
	GO

	DELETE FROM [dbo].[AuditWithTemporalTable] 
	WHERE [EMP_ID]=3

	DECLARE   @StartTime datetime2 =   '2020-05-09 14:09:48.39'
	DECLARE   @EndTime datetime2 =   '2020-05-09 15:15:03.34'
	SELECT * FROM [dbo].[AuditWithTemporalTable]
	FOR SYSTEM_TIME FROM   @StartTime TO @EndTime
	ORDER BY EMP_ID