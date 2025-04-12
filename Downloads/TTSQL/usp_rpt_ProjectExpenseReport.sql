IF OBJECT_ID ('dbo.usp_rpt_ProjectExpenseReport') IS NOT NULL
    DROP PROCEDURE dbo.usp_rpt_ProjectExpenseReport
GO       
CREATE PROCEDURE [dbo].[usp_rpt_ProjectExpenseReport]                                  
 @CompanyID NVARCHAR(20) = 0,                                
 @ProjectID INT = 0,                       
 @PT NVARCHAR(5) = null,
 @Status INT,                                
 @StartDate DATETIME = '1900-01-01 00:00:00',                                
 @EndDate DATETIME = GETDATE,                       
 @ExpenseUserID VARCHAR(1000),         
 @DBName VARCHAR(100),                              
 @UserID INT                          
AS      
/********************************************************************************/
/* Copyright @2016 CSSI                               							*/
/* 			 																	*/
/* Author	        : Srinivas Tummala											*/
/* CreationDate	    : 2016-04-28												*/
/* Description	    : Gets User Expense Details									*/
/*		  								                                        */
/* InPut Params	    : 															*/
/* Output params    : None														*/
/* Return params    : Returns User Expense Details								*/
/* Note		        : 															*/
/********************************************************************************/

/*
	DECLARE @CompanyID NVARCHAR(20)
		  , @ProjectID INT
		  , @PT NVARCHAR(5)
		  , @Status INT
		  , @StartDate datetime
		  , @EndDate datetime
		  , @DBName varchar(100) 
		  , @UserID INT=0
			  
	SELECT @CompanyID = 0,@ProjectID = 0,@PT = 0,@Status=0,@StartDate = null,@EndDate = null,@DBName = 'myclinicaltrial_Prod',@UserID = 53,@ExpenseUserID VARCHAR(1000)
	EXEC dbo.usp_rpt_ProjectExpenseReport @CompanyID,@ProjectID,@PT,@Status,@StartDate,@EndDate,@DBName,@UserID
	
	exec usp_rpt_ProjectExpenseReport @CompanyID=N'0',@ProjectID=0,@PT='-1',@StartDate='2016-05-01 00:00:00',@Status=1,@EndDate='2016-06-27 00:00:00',@DBName=N'myclinicaltrial_qa',@UserID=53,@ExpenseUserID=N'97,6,13,2,4,112,102,96,44,103,98,113,61,95,76,53,100,99,108'
	
	--EXEC dbo.usp_ProjectExpenseReport @CompanyID,@ProjectID,@PT,@StartDate,@EndDate,@DBName,@UserID
	
	usp_SelectAllocationDepartment 0
	
	exec usp_rpt_ProjectExpenseReport @CompanyID=N'0',@ProjectID=0,@PT=N'0',@StartDate='1900-01-01 00:00:00',@Status=1,@EndDate='1900-01-01 00:00:00',@DBName=N'myclinicaltrial_dev',@UserID=53
	
	SELECT * FROM Allocation WHERE ReportsExpenseID IN (81,82)
	exec usp_rpt_ProjectExpenseReport @CompanyID=N'0',@ProjectID=0,@PT=N'-1',@StartDate='2016-01-01 00:00:00',@Status=0,@EndDate='2016-05-11 00:00:00',@DBName=N'myclinicaltrial_QA',@UserID=201
	
	Sp_Helptext usp_ProjectExpenseReport
	SELECT * FROM Allocation
		
*/                           
                                
BEGIN                                
          
 DECLARE @SQLQuery NVARCHAR(MAX)          
 DECLARE @RoleName VARCHAR(100)                                  
    
	IF(OBJECT_ID('tempdb..#ExpenseUserList') IS NOT NULL)
		DROP TABLE #ExpenseUserList
		
	SELECT items AS UserId INTO #ExpenseUserList FROM dbo.fnSplit(@ExpenseUserID,',')		                   
		
				                            
   
	IF(OBJECT_ID('tempdb..##ExpenseDetailsTemp') IS NOT NULL)
		DROP TABLE ##ExpenseDetailsTemp                              
          
    SET @SQLQuery = 'SELECT DISTINCT REx.ReportsExpenseID,REx.Date, U.FirstName + '' '' + U.LastName AS FullName, REx.PaymentType, CASE WHEN (AL.Value IS NULL OR AL.value = 0) THEN Rex.Amount ELSE Rex.Amount END AS Amount, EC.GLCode, Rex.InvoiceNumber, --AL.GLCode, AL.InvoiceNumber,        
     REx.Description, al.SiteID, REx.Merchant, ec.ExpenseCategoryName,             
     (SELECT CASE WHEN ED.PT =''1''  THEN ''Yes'' ELSE ''No'' END) AS PT,
      REx.Status as [Status]
		, Case when REx.Status=''1'' then REx.UpdatedDate 		  
		  when REx.Status=''3'' then REx.UpdatedDate
		  --ELSE null 		  
		end as ApprovedDate
		, D.MCTDepartment
		, AL.ProjectID
		, D.DepartmentID
	 INTO ##ExpenseDetailsTemp	                         
     FROM ReportsExpense REx           
     INNER JOIN ExpenseCategory ec ON ec.ExpenseCategoryID = REx.ExpenseCategoryID                             
     INNER JOIN ExpenseReport ExR on ExR.ExpenseReportID=REx.ExpenseReportID                                  
     LEFT JOIN Allocation AL ON AL.ReportsExpenseID=REx.ReportsExpenseID                                 
     INNER JOIN [User] U on u.userID=REx.CreatedBy                                    
  LEFT JOIN ExpenseDepartment ED ON ED.ExpenseDepartmentID=EC.ExpenseDepartmentID         
  LEFT JOIN Department D on D.DepartmentID=ED.DepartmentID                                   
    WHERE (' + convert(nvarchar(100),@CompanyID) +' = 0 OR D.DepartmentID= ' + convert(nvarchar(100),@CompanyID) + ')        
      AND (' +convert(nvarchar(100),@ProjectID) +' = 0 OR Al.ProjectID= ' + convert(nvarchar(100),@ProjectID) + ')
      AND REx.IsDeleted !=1 '
      

SET @SQLQuery = @SQLQuery + ' AND REx.CreatedBy IN (SELECT UserId FROM #ExpenseUserList)'
	                            
            
  IF @StartDate <> '1900-01-01 00:00:00'          
    SET @SQLQuery = @SQLQuery + ' AND REx.Date >= ''' + CONVERT(VARCHAR(10), @StartDate, 101) + ''''          
              
  IF @EndDate <> '1900-01-01 00:00:00'          
    SET @SQLQuery = @SQLQuery + ' AND REx.Date <= ''' + CONVERT(VARCHAR(10), DATEADD(DAY, 1, @EndDate), 101) + ''''          
             
IF @PT <> '-1'      
BEGIN 
	SET @SQLQuery = @SQLQuery + ' AND ISNULL(ED.PT,0) = '+@PT+'  '           	     
END      

IF(@Status != 0)
	SET @SQLQuery = @SQLQuery + ' AND REx.Status = '+CAST(@Status AS VARCHAR)+'  '   
	
	
	        	
         
  SELECT @RoleName = RoleName FROM Roles r INNER JOIN userrole ur ON ur.RoleId = r.RoleID WHERE UserId = @UserID AND RoleName = 'Manager'                            
  -- Override Manager role with IT Admin role as IT Admin role ahould have the access to all the expenses          
  SELECT @RoleName = RoleName FROM Roles r INNER JOIN userrole ur ON ur.RoleId = r.RoleID WHERE UserId = @UserID AND RoleName = 'IT Admin'           
  IF @RoleName = 'Manager'                            
    SET @SQLQuery = @SQLQuery + ' AND (u.Manager = '+convert(nvarchar(100), @UserID)+' or REx.CreatedBy = '+convert(nvarchar(100), @UserID)+')'                            
                                
  SET @SQLQuery = @SQLQuery + ' ORDER BY FullName , REx.Date'                               
                             
  print @SQLQuery                              
  exec (@SQLQuery) 
  
  --SELECT * FROM ##ExpenseDetailsTemp
  
  DECLARE @SqlStr VARCHAR(MAX)
	IF(OBJECT_ID('tempdb..##ExpenseDetails') IS NOT NULL)
		DROP TABLE ##ExpenseDetails
		
	SET @SqlStr = ' SELECT ED.* ,P.ProjectName, P.AcctCode,S.SiteName ,j.PIName
	                  INTO ##ExpenseDetails
					  FROM ##ExpenseDetailsTemp ED
					  LEFT JOIN '+@DBName+'.dbo.Project P
						ON ED.ProjectID = P.ProjectId					   
					  LEFT JOIN '+@DBName+'.dbo.[Site] S
						ON ED.SiteId = S.SiteId					  	
					  LEFT JOIN ' + @DBName + '.DBO.ProjectOrganization po 
					   ON po.EntityID=ED.SiteID AND P.ProjectID = po.ProjectID                         	
					  OUTER APPLY(                                         
						   SELECT (LastName + '','' + FirstName) as PIName        
						   FROM ' + @DBName + '.DBO.EntityContact                                         
						    INNER JOIN ' + @DBName + '.DBO.EntityContactType on EntityContact.EntityContactTypeID = EntityContactType.EntityContactTypeID and EntityContactTypeName=''PI''                                
						    INNER JOIN ' + @DBName + '.DBO.Contact on EntityContact.ContactID = Contact.ContactID                                         
						   WHERE EntityContact.EntityType = ''ProjectOrganization'' and EntityContact.EntityID = PO.ProjectOrganizationID and CurrentContact=1)j		    
					 WHERE MCTDepartment = 1					    
					 UNION
					SELECT ED.*,(C.ClientName +''-''+P.ProjectName) AS ProjectName,'''' AS AcctCode, '''' AS SiteName,'''' AS  PIName
					  FROM ##ExpenseDetailsTemp ED
					  LEFT JOIN dbo.Project P
						ON ED.ProjectId = P.ProjectId
					   --AND ED.DepartmentID = P.DepartmentID
					  left JOIN client c on c.ClientID =p.ClientID
					 WHERE MCTDepartment != 1
					 ' 
	 
	Print @SqlStr 
	EXEC (@SqlStr)
	
	SELECT DISTINCT ReportsExpenseID
		 , [Date]
		 , FullName
		 , PaymentType
		 , Amount
		 , GLCode
		 , InvoiceNumber
		 , [Description]
		 , ProjectName
		 , AcctCode
		 , PIName
		 , NULLIF(SiteID,0) AS SiteID
		 , SiteName		 
		 , Merchant
		 , ExpenseCategoryName
		 , PT
		 , Case when [Status] = '1' then 'HR Approved' 
			    when [Status] = '2' then 'HR Rejected' 
			    when [Status] = '3' then 'Manager Approved' 
			    when [Status] = '4' then 'Manager Rejected' 
			    when [Status] = '5' then 'New' 
			    when [Status] = '6' then 'Not Submitted' 
			    when [Status] = '7' then 'Pending' 
			    when [Status] = '8' then 'Submitted to HR' 
			    when [Status] = '9' then 'Submitted to Manager' 
		   end as [Status]
		 , ApprovedDate  
      FROM ##ExpenseDetails
  
  --SELECT * FROM ##ExpenseDetails
  
	IF(OBJECT_ID('tempdb..##ExpenseDetailsTemp') IS NOT NULL)
		DROP TABLE ##ExpenseDetailsTemp 
	
	IF(OBJECT_ID('tempdb..##ExpenseDetails') IS NOT NULL)
		DROP TABLE ##ExpenseDetails	
                             
END             
  
GO
IF OBJECT_ID('dbo.usp_rpt_ProjectExpenseReport') IS NOT NULL
    PRINT 'ALTERED PROCEDURE usp_rpt_ProjectExpenseReport'
ELSE
    PRINT 'FAILED CREATING PROCEDURE usp_rpt_ProjectExpenseReport'
GO