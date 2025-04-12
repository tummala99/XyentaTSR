IF OBJECT_ID ('dbo.usp_rpt_Reimbursement') IS NOT NULL
    DROP PROCEDURE dbo.usp_rpt_Reimbursement
GO
CREATE PROCEDURE dbo.usp_rpt_Reimbursement ( @StartDate date
											,@EndDate date
											,@PaymentType VARCHAR(255)
											,@DBName VARCHAR(255) = '' 
 )    
AS
/********************************************************************************/
/* Copyright @2016 CSSI                               							*/
/* 			 																	*/
/* Author	        : Srinivas Tummala											*/
/* CreationDate	    : 2016-04-07												*/
/* Description	    : 															*/
/*		  								                                        */
/* InPut Params	    : 															*/
/*						@StartDate,@EndDate										*/
/* Output params    : None														*/
/* Return params    : 															*/
/* Note		        : 															*/
/********************************************************************************/

/*
	declare @StartDate date,@EndDate date,@PaymentType VARCHAR(255),@DBName VARCHAR(255)		
	SET @StartDate = '2016-01-01'
	SET @EndDate = '2016-06-08'
	SET @PaymentType = 'PersonalCash,Check,PersonalCreditCard'
	SET @DBName = 'MyClinicalTrial_QA'			
	EXEC dbo.usp_rpt_Reimbursement @StartDate,@EndDate,@PaymentType,@DBName
	
	SELECT * FROM Allocation WHERE ReportsExpenseID = 461
	SELECT * FROM dbo.Department WHERE MCTDepartment = 1 
	SELECT * FROM dbo.ReportsExpense WHERE ReportsExpenseID = 461
	--110
	
*/
BEGIN
	SET FMTONLY ON
	SET NOCOUNT ON
		
	IF 1=0 BEGIN
		SET FMTONLY OFF
	END
	
	IF(OBJECT_ID('tempdb..#ExpenseDetailsTemp') IS NOT NULL)
		DROP TABLE #ExpenseDetailsTemp

	SELECT DISTINCT RE.ReportsExpenseID
	     --, ER.CreatedBy
	     --, RE.CreatedBy
	     , RE.[Date] AS ExpenseDate
	     , (U.FirstName +' '+ U.LastName) AS UserName
	     , RE.Merchant
	     , D.DepartmentName AS Company
	     , ED.ExpenseDepartmentName AS Department	     
	     , D.DepartmentName
	     , EC.GLCODE
	     , D.MCTDepartment
	     , EC.ExpenseCategoryName
	     , RE.Amount
	     , RE.PaymentType
	     , AL.ProjectID-- AS Project
	     , AL.SiteID --AS  Site	     
	  INTO #ExpenseDetailsTemp   
	  FROM dbo.ExpenseReport ER
	 INNER JOIN dbo.ReportsExpense RE
		ON ER.ExpenseReportID = RE.ExpenseReportID
	 INNER JOIN dbo.ExpenseCategory EC
	    ON EC.ExpenseCategoryID = RE.ExpenseCategoryID
	  LEFT JOIN dbo.ExpenseDepartment ED
	    ON ED.ExpenseDepartmentID = EC.ExpenseDepartmentID
	  LEFT JOIN dbo.Department D
	    ON D.DepartmentID = ED.DepartmentID  
	  LEFT JOIN Allocation AL
	    ON AL.ReportsExpenseID = RE.ReportsExpenseID
	  LEFT JOIN dbo.[User] U     	
	    ON U.UserId = RE.CreatedBy
	 WHERE CAST(ER.CreatedDate AS DATE) BETWEEN @StartDate AND @EndDate --'2015-01-01' AND '2016-04-08'   
	   AND RE.PaymentType IN (SELECT items FROM dbo.fnSplit(@PaymentType,','))--('PersonalCash','Check','PersonalCreditCard') 
	   AND RE.IsDeleted !=1
	 
	--SELECT * FROM #ExpenseDetailsTemp	 
	
	DECLARE @SqlStr VARCHAR(MAX)
	IF(OBJECT_ID('tempdb..##ExpenseDetails') IS NOT NULL)
		DROP TABLE ##ExpenseDetails
		
	SET @SqlStr = ' SELECT ED.* ,P.ProjectName AS Project,S.SiteName AS Site
	                  INTO ##ExpenseDetails
					  FROM #ExpenseDetailsTemp ED
					  LEFT JOIN '+@DBName+'.dbo.Project P
						ON ED.ProjectID = P.ProjectId
					  LEFT JOIN '+@DBName+'.dbo.[Site] S
						ON ED.SiteId = S.SiteId	    
					 WHERE MCTDepartment = 1 
					 UNION
					SELECT ED.*,(C.ClientName +''-''+P.ProjectName) AS ProjectName, '''' AS Site 
					  FROM #ExpenseDetailsTemp ED
					  LEFT JOIN dbo.Project P
						ON ED.ProjectId = P.ProjectId
					  LEFT JOIN client c on c.ClientID =p.ClientID	 
					 WHERE MCTDepartment != 1
					 ' 
	 
	EXEC (@SqlStr)	 
	
	SELECT ReportsExpenseID
	     , ExpenseDate
		 , UserName
		 , Merchant
		 , Company
		 , Department		 
		 , DepartmentName
		 , GLCODE
		 , ExpenseCategoryName
		 , Amount
		 , PaymentType
		 , Project
		 , [Site]		 
	  FROM ##ExpenseDetails

	IF(OBJECT_ID('tempdb..#ExpenseDetailsTemp') IS NOT NULL)
		DROP TABLE #ExpenseDetailsTemp
		
	IF(OBJECT_ID('tempdb..##ExpenseDetails') IS NOT NULL)
		DROP TABLE ##ExpenseDetails	
	
END		 