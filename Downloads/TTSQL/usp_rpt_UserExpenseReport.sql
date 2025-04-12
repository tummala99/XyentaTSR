IF OBJECT_ID ('dbo.usp_rpt_UserExpenseReport') IS NOT NULL
    DROP PROCEDURE dbo.usp_rpt_UserExpenseReport
GO

CREATE PROCEDURE [dbo].[usp_rpt_UserExpenseReport]  --'53','1/1/1900','1/1/1900','myclinicaltrial_dev'
@User INT=0,  
@StartDate datetime = '1900-01-01 00:00:00',  
@EndDate datetime = GETDATE,  
@DBName varchar(100)    
AS  
/********************************************************************************/
/* Copyright @2016 CSSI                               							*/
/* 			 																	*/
/* Author	        : Srinivas Tummala											*/
/* CreationDate	    : 2016-04-27												*/
/* Description	    : Gets User Expense Details									*/
/*		  								                                        */
/* InPut Params	    : 															*/
/* Output params    : None														*/
/* Return params    : Returns User Expense Details								*/
/* Note		        : 															*/
/********************************************************************************/

/*
	DECLARE @UserID INT=0
		  , @StartDate datetime
		  , @EndDate datetime
		  , @DBName varchar(100) 
			  
	SELECT @UserID = 0,@StartDate = null,@EndDate = null,@DBName = 'myclinicaltrial_QA'
	EXEC dbo.usp_rpt_UserExpenseReport @UserID,@StartDate,@EndDate,@DBName
	
	exec usp_UserExpenseReport @UserId=N'201',@StartDate=null,@EndDate=null,@DBName=N'myclinicaltrial_QA'	
	exec usp_rpt_UserExpenseReport @User=201,@StartDate='1900-01-01 00:00:00',@EndDate='2016-04-28 00:00:00',@DBName=N'myclinicaltrial_qa'
	
	exec usp_rpt_UserExpenseReport @User=N'0',@StartDate='1900-01-01 00:00:00',@EndDate='2016-04-26 00:00:00',@DBName=N'myclinicaltrial_dev'
	exec usp_rpt_UserExpenseReport @User=N'97',@StartDate='1900-01-01 00:00:00',@EndDate='2016-04-26 00:00:00',@DBName=N'myclinicaltrial_dev'
	exec usp_rpt_UserExpenseReport @User=N'0',@StartDate='1900-01-01 00:00:00',@EndDate='2016-04-26 00:00:00',@DBName=N'myclinicaltrial_dev'
	exec usp_UserExpenseReport @UserId=N'0',@StartDate='1900-01-01 00:00:00',@EndDate='2016-04-26 00:00:00',@DBName=N'myclinicaltrial_dev'
	
	exec usp_rpt_UserExpenseReport @User=N'97',@StartDate='1900-01-01 00:00:00',@EndDate='2016-04-26 00:00:00',@DBName=N'myclinicaltrial_dev'
	exec usp_UserExpenseReport @UserID=97,@StartDate='1900-01-01 00:00:00',@EndDate='1900-01-01 00:00:00',@DBName=N'MyClinicalTrial_Dev'
	SELECT * FROM dbo.[User] WHERE UserId IN (97,53)
	
	exec usp_rpt_UserExpenseReport @User=53,@StartDate='1900-01-01 00:00:00',@EndDate='1900-01-01 00:00:00',@DBName=N'myclinicaltrial_dev'
*/  
BEGIN
SET NOCOUNT ON  
   
   
IF(@StartDate = '1900-01-01 00:00:00')  
   SET @StartDate = null  
    
IF(@EndDate = '1900-01-01 00:00:00')  
   SET @EndDate = null   
   
    
declare @sql nvarchar(max)  
  
IF(OBJECT_ID('tempdb..##Projects') IS NOT NULL)  
 DROP TABLE tempdb..##Projects  
  
--CREATE TABLE ##Projects (ProjectId INT, ProjectName VARCHAR(200))  
  
SET @sql = 'Select ProjectId,ProjectName INTO ##Projects from ['+ @DBName +'].[dbo].Project'   
  
--SELECT @sql  
EXEC (@sql)  
  
--SELECT * FROM ##Projects  
  
 Select DISTINCT  REx.ReportsExpenseID AS ExpenseID,REx.CreatedDate,Al.Project,REx.Amount,  
 (SELECT CASE   
    WHEN REx.Status = 6 THEN 'Not submitted'    
    WHEN REx.Status = 7 THEN 'Pending'   
    WHEN REx.Status = 1   THEN 'Approved'   
    WHEN REx.Status = 3   THEN 'Approved'   
    WHEN REx.Status = 2 THEN 'Rejected'  
    WHEN REx.Status = 4 THEN 'Rejected'   
    WHEN REx.Status IS NULL THEN ' '    
       
  END  
) AS Status  
  
    
 from ReportsExpense REx  
 join ExpenseReport ExR on ExR.ExpenseReportID=REx.ExpenseReportID  
 LEFT JOIN ExpenseCategory EC ON EC.ExpenseCategoryID= REx.ExpenseCategoryID
 LEFT JOIN ExpenseDepartment ED ON ED.ExpenseDepartmentID=EC.ExpenseDepartmentID 
 LEFT JOIN Department D on D.DepartmentID=ED.DepartmentID  

 OUTER APPLY  
 (  
   SELECT Al.AllocationID,Al.ReportsExpenseID,Al.ProjectID,Al.SiteID,Al.PT,Al.Percentage,  
   (  SELECT CASE  
     WHEN D.MCTDepartment = 1 THEN   
      (Select ProjectName from ##Projects P WHERE P.ProjectID=Al.ProjectID)   
      ELSE (Select (C.ClientName +'-'+TSP.ProjectName) AS ProjectName from [dbo].[Project] TSP left JOIN client c on c.ClientID = TSP.ClientID WHERE TSP.ProjectID=Al.ProjectID )-- AND TSP.DepartmentID=D.DepartmentID)   
                  
    END  
    ) AS Project  
     
   FROM Allocation Al  
   WHERE AL.ReportsExpenseID=REx.ReportsExpenseID   
  
 )Al  
   
 WHERE (@User =0 OR REx.CreatedBy= @User)  AND ( (REx.CreatedDate >= @StartDate OR @StartDate IS NULL)   
        AND (REx.CreatedDate < DATEADD(day,1,@EndDate) OR @EndDate IS NULL)
        AND REx.IsDeleted != 1  
    )  
  ORDER BY REx.ReportsExpenseID ,CreatedDate ,Project 
  
END  
  
  
--Select * from Timesheet_Dev.[dbo].Project P WHERE P.ProjectID=Al.ProjectID  
  
--Select ProjectName from @DBName.[dbo].Project  
   
GO
IF OBJECT_ID('dbo.usp_rpt_UserExpenseReport') IS NOT NULL
    PRINT 'ALTERED PROCEDURE usp_rpt_UserExpenseReport'
ELSE
    PRINT 'FAILED CREATING PROCEDURE usp_rpt_UserExpenseReport'
GO   
