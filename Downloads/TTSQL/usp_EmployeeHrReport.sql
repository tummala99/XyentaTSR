IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_EmployeeHrReport]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_EmployeeHrReport]
GO
    
CREATE PROCEDURE [dbo].[usp_EmployeeHrReport] --exec usp_EmployeeHrReport @Startdate='2015-10-27 00:00:00',@EndDate='2016-02-25 00:00:00',@UserId='6,12,2,4,7,3,118,53,42,70',@Status='Not Submitted',@StaffType='All'    
	(                      
		@Startdate datetime,                      
		@EndDate datetime,                      
		@UserId varchar(500),                      
		@Status varchar(100),            
		@StaffType varchar(100)                           
	)                      
AS                   
/*
	DECLARE @Startdate datetime,                      
		@EndDate datetime,                      
		@UserId varchar(500),                      
		@Status varchar(100),            
		@StaffType varchar(100)
		
	SET @Startdate = '2016-05-01 00:00:00'
	SET @EndDate = '2016-05-31 00:00:00'
	SET @UserId = '0'		
	SET @Status = 'Not Submitted'
	SET @StaffType = 'All'	
	EXEC [dbo].[usp_EmployeeHrReport] @Startdate,@EndDate,@UserId,@Status,@StaffType 
	
	--exec usp_EmployeeHrReport @Startdate='2016-05-01 00:00:00',@EndDate='2016-05-31 00:00:00',@UserId='',@Status='Not Submitted',@StaffType='All'    
	exec usp_EmployeeHrReport @Startdate='2016-05-01 00:00:00',@EndDate='2016-05-31 00:00:00',@UserId='201,204,4,5,6,53,61,70,99,148,177,187',@Status='Not Submitted,Submitted Approved',@StaffType='All'
	exec usp_EmployeeHrReport @Startdate='2016-06-01 00:00:00',@EndDate='2016-06-30 00:00:00',@UserId='61',@Status='Not Submitted,Submitted Approved',@StaffType='All'
	
*/
BEGIN        

	/**************************************************************************
	* Get selected date range dates into temp table						  *
	***************************************************************************/
	DECLARE @CurrentDate Date		 
	SET @CurrentDate = @Startdate 	
	
	IF(OBJECT_ID('tempdb..#DateList') IS NOT NULL )
		DROP TABLE #DateList
	CREATE TABLE #DateList(ID INT IDENTITY(1,1),TimeSheetDate DATE,DayOfCurrentWeek INT,DayNameOfWeek VARCHAR(50))	
		
	WHILE (@EndDate>=@CurrentDate)
	BEGIN
		IF(DATENAME (DW ,@CurrentDate) != 'Sunday' AND DATENAME (DW ,@CurrentDate) != 'Saturday')
		BEGIN
			INSERT INTO #DateList (TimeSheetDate,DayOfCurrentWeek,DayNameOfWeek)
			SELECT @CurrentDate,DATEPART (DW ,@CurrentDate),DATENAME (DW ,@CurrentDate) 
		END
		
		SET @CurrentDate = DATEADD (D,1,@CurrentDate)
	END
	
	--SELECT * FROM #DateList

	/**************************************************************************
	* Get Selected Employee type ids into temp table						  *
	***************************************************************************/	        

	IF(OBJECT_ID('tempdb..#StaffTypeList') IS NOT NULL )
		DROP TABLE #StaffTypeList
	CREATE TABLE #StaffTypeList (EmployeeTypeId INT)		
	
	IF (@StaffType <> 'All') 
	BEGIN	
		INSERT INTO #StaffTypeList (EmployeeTypeId)
		SELECT timesheetlistlovid                
		  FROM TIMESHEETLISTLOV                
		 WHERE TimesheetListTypeName = 'EmployeeType'                
		   AND Name = @StaffType
	END
	ELSE
	BEGIN
		INSERT INTO #StaffTypeList (EmployeeTypeId)
		SELECT timesheetlistlovid                
		  FROM TIMESHEETLISTLOV                
		 WHERE TimesheetListTypeName = 'EmployeeType'                		   		
	END			   			
	
	/**************************************************************************
	* Get all active Employees and their Manager into temp table											  *
	***************************************************************************/
	IF(OBJECT_ID('tempdb..#Employeeslist') IS NOT NULL )
		DROP TABLE #Employeeslist
	CREATE TABLE #Employeeslist (UserId INT,UserName VARCHAR(255),EmployeeTypeId INT, ManagerId INT,ManagerName VARCHAR(255))
	
	IF (@UserId <> '' AND @UserId <> '0')
	BEGIN
		INSERT INTO #Employeeslist(UserId,UserName,EmployeeTypeId,ManagerId,ManagerName)		
		SELECT U.UserId AS UserId, (U.FirstName +' '+ U.LastName) AS UserName, U.EmployeeType
			 , Mgr.UserId AS ManagerId, (Mgr.FirstName +' '+ Mgr.LastName) AS ManagerName  
		  FROM dbo.[User] U
		  LEFT JOIN dbo.[User] Mgr
			ON U.Manager = Mgr.UserId
		 WHERE ISNULL(U.InactiveDate,'') = ''
		   AND U.EmployeeType IN (SELECT EmployeeTypeId FROM #StaffTypeList)
		   AND Mgr.UserId IN (SELECT ITEMS FROM DBO.[fnSplit](@UserId,','))
	END 
	ELSE
	BEGIN
		INSERT INTO #Employeeslist(UserId,UserName,EmployeeTypeId,ManagerId,ManagerName)
		SELECT U.UserId AS UserId, (U.FirstName +' '+ U.LastName) AS UserName, U.EmployeeType
			 , Mgr.UserId AS ManagerId, (Mgr.FirstName +' '+ Mgr.LastName) AS ManagerName  
		  FROM dbo.[User] U
		  LEFT JOIN dbo.[User] Mgr
			ON U.Manager = Mgr.UserId
		 WHERE ISNULL(U.InactiveDate,'') = ''
		   AND U.EmployeeType IN (SELECT EmployeeTypeId FROM #StaffTypeList)		   
	END 
	
	--SELECT * FROM #Employeeslist	
	
	/**************************************************************************
	* Assign Selected date range dates to selected Employees				  *
	***************************************************************************/
	IF(OBJECT_ID('tempdb..#EmpTimeSheetlistToBe') IS NOT NULL )
		DROP TABLE #EmpTimeSheetlistToBe
	
	SELECT *
	  INTO #EmpTimeSheetlistToBe 
	  FROM #DateList DL
	 CROSS APPLY #Employeeslist EL
	 --2046
		
	/**************************************************************************
	* Get user entered time sheet data by date range selected into temp table *
	***************************************************************************/
	
	IF(OBJECT_ID('tempdb..#TimeSheetlist') IS NOT NULL )
		DROP TABLE #TimeSheetlist
	CREATE TABLE #TimeSheetlist (UserId INT,TimeSheetforDate Date,Workhours VARCHAR(50), TimeSheetStatus VARCHAR(255))
	
	INSERT INTO #TimeSheetlist(UserId ,TimeSheetforDate ,Workhours , TimeSheetStatus)
	SELECT TS.UserID,TimeSheetforDate,Workhours,TimeSheetStatus 
	  FROM dbo.vw_TimeSheet TS
	 INNER JOIN #Employeeslist EL
	    ON TS.UserID = EL.UserId
	 WHERE TimeSheetforDate BETWEEN @Startdate AND @EndDate--'2016-05-01 00:00:00' AND '2016-05-31 00:00:00' --
	 
	/**************************************************************************
	* Get timesheet hours according to selected timesheet Status 			  *
	***************************************************************************/	 
	 
	IF(OBJECT_ID('tempdb..#UserTimeSheetTemp') IS NOT NULL )
		DROP TABLE #UserTimeSheetTemp
	CREATE TABLE #UserTimeSheetTemp (UserId INT,TimeSheetforDate Date,Workhours VARCHAR(50), TimeSheetStatus VARCHAR(255))		
			 
	IF (@Status = 'Not Submitted' OR CHARINDEX('Not Submitted',@Status) > 0)
	BEGIN		
		
		--SELECT * FROM #EmpTimeSheetlistToBe -- 2883
		--SELECT * FROM #TimeSheetlist -- 8
		
		INSERT INTO #UserTimeSheetTemp(UserId ,TimeSheetforDate ,Workhours , TimeSheetStatus)
		SELECT DL.UserId,DL.TimeSheetDate,'08:00' AS WorkHours,'Not Submitted' AS TimeSheetStatus
		  FROM #EmpTimeSheetlistToBe DL
		  LEFT JOIn #TimeSheetlist TS
		    ON DL.TimeSheetDate = TS.TimeSheetforDate
		   AND DL.UserId = TS.UserId
		 WHERE TS.UserID IS NULL 
		UNION 
		SELECT * FROM #TimeSheetlist WHERE TimeSheetStatus IN (select parsedValue from dbo.SplitString_FNC(@Status))
		
	END
	ELSE
	BEGIN
		INSERT INTO #UserTimeSheetTemp(UserId ,TimeSheetforDate ,Workhours , TimeSheetStatus)
		SELECT * 
		  FROM #TimeSheetlist
		 WHERE TimeSheetStatus in (select parsedValue from dbo.SplitString_FNC(@Status)) 
		
	END
	
	/**************************************************************************
	* Update Work hours from non time format to time format if exists 		  *
	***************************************************************************/	
	UPDATE #UserTimeSheetTemp
	   SET Workhours = '0:00' 
	 WHERE Workhours = '0.00' 
	--SELECT * FROM #UserTimeSheetTemp
	
	/************************************************************************************************************
	* Convert work hours from hours to minutes and getting Sum of Minutes by grouping user and timesheet status *
	*************************************************************************************************************/
	IF(OBJECT_ID('tempdb..#UserTimeSheetFinal') IS NOT NULL )
		DROP TABLE #UserTimeSheetFinal
		
	SELECT UserId,TimeSheetStatus,SUM(CAST(LTRIM(DATEDIFF(MINUTE, 0, Workhours))AS INT)) AS WorkMinuts
	  INTO #UserTimeSheetFinal
	  FROM #UserTimeSheetTemp
	 GROUP BY UserId,TimeSheetStatus 
	  
	  
	--SELECT * FROM #Employeeslist 
	/**************************************************************************************
	* Return final result with users and their managers alogn with Work Hours and status  *
	***************************************************************************************/ 
	SELECT CAST(WorkMinuts/60 AS INT) AS HoursWorked
		 , CAST(right('0' + CAST(WorkMinuts%60 As VARCHAR(20)),2)AS INT) AS MinutesWorked 
		 , EL.UserName
	     , UTS.TimeSheetStatus
	     , ISNULL(CAST(WorkMinuts/60 AS VARCHAR(6))+ ':' + right('0' + CAST(WorkMinuts%60 As VARCHAR(20)),2),0) AS WorkHours
	     , EL.ManagerName 
	  FROM #UserTimeSheetFinal UTS
	 INNER JOIN #Employeeslist EL
	    ON UTS.UserId = EL.UserId 
	 ORDER BY ManagerName,UserName  
		               
END      
  