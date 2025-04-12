IF OBJECT_ID ('dbo.usp_ProductivityReport') IS NOT NULL
    DROP PROCEDURE dbo.usp_ProductivityReport
GO       
CREATE PROCEDURE [dbo].[usp_ProductivityReport]                                  
 @Department VARCHAR(MAX) = '(Select All)',
 @User VARCHAR(MAX) = '(Select All)',                                
 @StartDate DATETIME,                                
 @EndDate DATETIME,                                
 @DBName VARCHAR(100),
 @UserID INT = null                           
AS                   
BEGIN  
/*
		DECLARE @Department VARCHAR(MAX),
		 @User VARCHAR(MAX),           
		 @StartDate DATETIME,                                
		 @EndDate DATETIME,                                
		 @DBName VARCHAR(100)
	SELECT @Department = 25,@User=202,@StartDate = '2010-01-01',@EndDate = '2016-05-01'
	EXEC [dbo].[usp_ProductivityReport]  @Department,@User,@StartDate,@EndDate,null		 
	
	MyClinicalTrial_QA
	
	exec dbo.usp_ProductivityReport @Department=N'25,26,27,34,35,44,46,47,48,49,50,51,52,53,54',@User=N'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,116,117,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208'
	,@StartDate='2010-03-18 00:00:00',@EndDate='2016-05-18 00:00:00',@DBName=N'MyClinicalTrial_PROd',@UserID=53
		
	exec dbo.usp_ProductivityReport @Department=N'47',@User=N'202',@StartDate='2016-05-09 00:00:00',@EndDate='2016-05-10 00:00:00',@DBName=N'myclinicaltrial_DEV',@UserID=53
	
		
*/

	DECLARE @StartDt Date
		  , @EndDt Date
		  
	SET @StartDt = CAST(@StartDate AS DATE)		                                
	SET @EndDt = CAST(@EndDate AS DATE)
	
	IF(OBJECT_ID('tempdb..#UserList') IS NOT NULL)
		DROP TABLE #UserList
	
	SELECT items AS UserId INTO #UserList FROM dbo.fnSplit(@User,',')
	
	IF(OBJECT_ID('tempdb..#DeptList') IS NOT NULL)
		DROP TABLE #DeptList
	
	SELECT items As DepartmentId INTO #DeptList FROM dbo.fnSplit(@Department,',')
	
	IF(OBJECT_ID('tempdb..#TimesheetDetailsTemp') IS NOT NULL)
		DROP TABLE #TimesheetDetailsTemp
	
	SELECT DISTINCT TS.TimeSheetID
		 , TS.UserID		 
		 , TS.TimeSheetForDate,TS.Timesheetstatus
		 , TSD.StartTime,TSD.EndTime--,CONVERT(varchar(5), DATEADD(minute, DATEDIFF(minute, TSD.StartTime, TSD.EndTime), 0), 114) TimeSpentHours		 
		 , DATEDIFF(minute, TSD.StartTime, TSD.EndTime) TimeSpentMinutes
		 , TSD.ProjectID		 
		 , TSD.LineItem
		 , TSD.Task,T.TaskName,TSL.Name AS TaskType
		 --, DT.DepartmentID
	  INTO #TimesheetDetailsTemp	    
	  FROM dbo.TimeSheet TS (NOLOCK)
	 INNER JOIN dbo.TimeSheetDetails TSD (NOLOCK)
	    ON TS.TimeSheetID = TSD.TimeSheetID	 
	 INNER JOIN dbo.Task T (NOLOCK)
	    ON T.TaskID = TSD.Task	 
	 INNER JOIN dbo.TimeSheetListLov TSL (NOLOCK)
	    ON TSL.TimeSheetListLovID = T.TaskType
	   AND TSL.Name IN ('Non billable','billable')
	 INNER JOIN dbo.Project P
	    ON P.ProjectID = TSD.ProjectID               
	 --INNER JOIN dbo.DepartmentTask DT (NOLOCk)
	 --   ON DT.TaskID = T.TaskID
	 --INNER JOIN dbo.UserDepartment UD (NOLOCk)
	 --   ON UD.DepartmentId = DT.DepartmentID       
	 --  AND UD.UserId = TS.UserID      
	 WHERE CAST(TS.TimeSheetForDate AS DATE) BETWEEN @StartDt AND @EndDt --'2016-05-02' AND '2016-05-04'--@StartDt AND @EndDt
	   AND TS.UserId IN (SELECT UserId FROM #UserList)--(22)--(201)--
	   AND P.DepartmentID IN (SELECT DepartmentId FROM #DeptList)--(25) 
	   AND TSD.IsDeleted = 0
	   
	
	--SELECT top 100 * FROM #TimesheetDetailsTemp	
	IF(OBJECT_ID('tempdb..#TimesheetDetailsMin') IS NOT NULL)
		DROP TABLE #TimesheetDetailsMin
		
	SELECT UserID
		 , ProjectID
	     , CASE WHEN TaskType = 'billable' 
				THEN TimeSpentMinutes 				
		   END AS BillableMinutes
		 , CASE WHEN TaskType = 'non billable' AND TaskName NOT IN ('Leave','Vacation')
				THEN TimeSpentMinutes 				
		   END AS NonBillableMinutes		
		 , CASE WHEN TaskType = 'non billable' AND (TaskName IN ('Leave','Vacation'))
				THEN TimeSpentMinutes		
		   END AS LeaveMinutes
	  INTO #TimesheetDetailsMin	    
	  FROM #TimesheetDetailsTemp
	  
	  
	CREATE INDEX IX_#TimesheetDetailsMin_UserID ON #TimesheetDetailsMin (UserID)
	 INCLUDE(ProjectID) 
	--SELECT * FROM #TimesheetDetailsTemp --WHERE TaskName = 'Vacation'	   
	
	IF(OBJECT_ID('tempdb..#TimesheetDetails') IS NOT NULL)
		DROP TABLE #TimesheetDetails
		
	SELECT UserID		 
		 , ProjectID		 
	     , SUM(BillableMinutes) AS BillableMinutes
	     , SUM(NonBillableMinutes) AS NonBillableMinutes
	     , SUM(LeaveMinutes) AS LeaveMinutes	     
	  INTO #TimesheetDetails   
	  FROM #TimesheetDetailsMin
	 GROUP BY UserID,ProjectID
	 
	SELECT TSD.UserID		 
		 , (U.FirstName +' '+U.LastName) AS UserName
		 , TSD.ProjectID
		 --, P.ProjectName
		 , (C.ClientName +' - '+ P.ProjectName) AS ProjectName
		 , BillableMinutes,NonBillableMinutes,LeaveMinutes	     
		 --, '' AS BillableHours
		 --, '' AS NonBillableHours
		 --, '' AS LeaveHours
	     , ISNULL(CAST(BillableMinutes/60 AS VARCHAR(6))+ ':' + right('0' + CAST(BillableMinutes%60 As VARCHAR(20)),2),0) AS BillableHours 
	     , ISNULL(CAST(NonBillableMinutes/60 AS VARCHAR(6))+ ':' + right('0' + CAST(NonBillableMinutes%60 As VARCHAR(20)),2),0) AS NonBillableHours
	     , ISNULL(CAST(LeaveMinutes/60 AS VARCHAR(6))+ ':' + right('0' + CAST(LeaveMinutes%60 As VARCHAR(20)),2),0) AS LeaveHours
	  FROM #TimesheetDetails TSD
	 INNER JOIN dbo.[User] U (NOLOCk) 
	    ON U.UserId = TSD.UserID
	 INNER JOIN dbo.Project P (NOLOCk)
	    ON P.ProjectID = TSD.ProjectID
	 INNER JOIN dbo.Client C
	    ON C.ClientId = P.ClientId   	   
	 ORDER BY (U.FirstName +' '+U.LastName)  
	
	IF(OBJECT_ID('tempdb..#TimesheetDetailsTemp') IS NOT NULL)
		DROP TABLE #TimesheetDetailsTemp
		
	IF(OBJECT_ID('tempdb..#TimesheetDetailsMin') IS NOT NULL)
		DROP TABLE #TimesheetDetailsMin		
			  
	IF(OBJECT_ID('tempdb..#TimesheetDetails') IS NOT NULL)
		DROP TABLE #TimesheetDetails	
	/*		
	*/		  	 
                            
END             
  
GO
IF OBJECT_ID('dbo.usp_ProductivityReport') IS NOT NULL
    PRINT 'ALTERED PROCEDURE usp_ProductivityReport'
ELSE
    PRINT 'FAILED CREATING PROCEDURE usp_ProductivityReport'
GO