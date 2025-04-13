--SP_Who2
--SP_Monitor

SELECT * FROM [Admin].[RunProcessConfig] WHERE pk_RunProcessConfig = 14
SELECT * FROM [Admin].[RunProcessLog] ORDER BY 1 Desc
SELECT * FROM [Admin].[PostingEngineLog]

SP_DEPENDS '[Admin].[RunProcessConfig]'


			SELECT c.FolderName+'\Pending\'+ISNULL(l.[FileName],'')
			FilePath,l.RunProcessLogID
			FROM [admin].[RunProcessConfig] c
			JOIN [admin].[RunProcessLog] l
			ON c.pk_RunProcessConfig = l.fk_RunProcessConfig
			WHERE l.RunProcessLogID IN (162211,162241,162244,162245)


			SELECT DISTINCT Module FROM [Admin].[RunProcessLog] ORDER BY 1 Desc

			SELECT * FROM  [staging_agresso].[dbo].[AllocationRulesStage]
			SELECT DISTINCT AllocationCode, AllocationGroup FROM [staging_agresso].[dbo].AllocationRulesStage

			SELECT [AllocationCode], StepCode, AllocationGroup, CAST(SUM(AllocationPercent) AS varchar) as AllocationPercent
			  FROM [dbo].[AllocationRulesStage]
			 WHERE AllocationCode = ? and AllocationGroup = ?
			 GROUP BY AllocationCode, StepCode, AllocationGroup
			HAVING cast(SUM(AllocationPercent) as decimal(18,4)) <> 0.0000



			SELECT * FROM [FDM_DB].[dbo].AllocationRulesExceptions Where AllocationGroup = ? and AllocationCode = ?
			SELECT * FROM  [staging_agresso].[dbo].AllocationRulesStage

			ISNULL(AccountDest) ==  FALSE  && AccountDest != "" && AccountDest != " "
			ISNULL(TrifocusDest) ==  FALSE  && TrifocusDest != "" && TrifocusDest != " "
			ISNULL(EntityDest) ==  FALSE  && EntityDest != " " && EntityDest != ""

			 SELECT CAST(Count(*) as varchar) + CASE Count(*) WHEN 1 THEN ' rule has an invalid ' else ' rules have and invalid ' end + ErrorColumn ErrorDesc
			 FROM [AllocationRulesExceptions]
			WHERE AllocationGroup = ? and AllocationCode = ?
			  GROUP BY ErrorColumn


			  select ISNULL(min(AllocationGroupId),0) AllocationGroupId from [FDM_DB].[dbo].DimAllocationRules where AllocationGroup = 'expenses.prod'
and AllocationGroupID > 0

		SELECT TOP 100 * FROM [FDM_DB].[dbo].DimAllocationRules WHERE IsCurrent = 1

		SELECT ISNULL(MAX(AllocationGroupID),0)+1 AllocationGroupId FROM [FDM_DB].[dbo].DimAllocationRules

		select cast(ISNULL(max(AllocationGroupCodeVersion),0) as numeric) AllocationGroupCodeVersion from [FDM_DB].[dbo].DimAllocationRules 
WHERE 
AllocationGroup = ? AND AllocationCode = ?

	UPDATE DimAllocationRules SET IsCurrent = 0
	WHERE AllocationCode = ? and AllocationGroup = ? and AllocationGroupCodeVersion = ?


	 SELECT 
      [FolderName],[FileName]
  FROM FDM_PROCESS.[admin].[RunProcessConfig] c
  JOIN FDM_PROCESS.[admin].[RunProcessLog] l
  ON c.pk_RunProcessConfig = l.fk_RunProcessConfig
  WHERE l.RunProcessLogID = ?


	SELECT '"+ @[$Package::AllocationGroup] +"' AS AllocationGroup,"
 +"'"+ @[$Package::User] +"' AS [user],"
+"'"+ @[$Package::AccountingYear] +"' AS AccountingYear,"
+"'"+ @[$Package::AccountingMonth] +"' AS AccountingMonth,"
+""+"'fdm.developers@beazley.com'"+ " AS UserEmailID, "
+"'"+ @[$Package::Client] +"' AS Client


	EXEC [dbo].[usp_GetAllocationsToRun] ?,?,?,?

	SELECT * FROM staging_Agresso.dbo.AllocationsToRun 
	SELECT *  FROM [FDM_DB].[dbo].RealTimeAllocations
	SELECT * FROM [FDM_DB].[dbo].[DimAccountingPeriod]
	SELECT TOP 1000 * FROM dbo.DimAllocationRules WHERE IsCurrent = 1 ORDER BY 1 DESC
	SELECT TOP 100 *
	  FROM [FDM_DB].[dbo].[BriExpensesTransactionDetailsV4] ORDER By AllocationGroupVersionCode DESC -- 229309064

	SELECT TOP 100 * FROM [FDM_DB].[dbo].[DimAllocationCombinations](nolock) WHERE pk_YOA = -1-- 11059950

	SELECT 229309064 - 11059950 -- 218249114

	SELECT DISTINCT AllocationCode,AllocationGroup,AllocationGroupVersionCode FROM [FDM_DB].[dbo].[BriExpensesTransactionDetailsV4] WHERE AllocationCode = 'A1' AND AllocationGroup = 'Expenses 2020 A0-A3'
	SP_DEPENDS 'BriExpensesTransactionDetailsV4'

	USE [FDM_DB]

	
	SELECT * 
	  FROM [FDM_DB].[dbo].[BriExpensesTransactionDetailsV4] b
	  JOIN	dbo.DimAllocationRules v
	    ON	b.FK_AllocationRules = v.PK_AllocationRules
		WHERE v.AllocationGroup = 'Expenses 2020 A0-A3'
		  AND IsCurrent = 1
	  --JOIN	#AllocationGroupToDelete r
	  --  ON	r.AllocationGroup = v.AllocationGroup

	
	SELECT DISTINCT [AllocationGroup],
	[AllocationCode]
  FROM [staging_agresso].[dbo].[AllocationsToRun]
  ORDER BY AllocationGroup,AllocationCode

	 SELECT * FROM [FDM_DB].[dbo].[stg_DimAllocationCombinations]
	 SELECT * FROM [FDM_DB].[dbo].DimAllocationCombinations

	SELECT	MIN(a.AccountFrom)  
	,MAX(a.AccountTo)  
	FROM	[FDM_DB].dbo.DimAllocationRules a
	WHERE		a.IsCurrent = 1
	AND		AllocationGroup = 'Expenses 2020 A0-A3' --@AllocationGroup

	SELECT * 
		,RANK() OVER (ORDER BY [AllocationCode] ASC) AS  [RunOrder]
	FROM 
	(
		SELECT	DISTINCT [AllocationCode]
		,RANK() OVER (ORDER BY [AllocationCode] ASC) AS  [RunOrder]
		FROM	dbo.DimAllocationRules
		WHERE	AllocationGroup = 'Expenses 2020 A0-A3' 
		AND		IsCurrent = 1
		--ORDER BY RunOrder
	) AS T
	ORDER BY RunOrder

		SELECT DISTINCT * FROM dbo.DimAllocationRules WHERE	AllocationGroup = 'Expenses 2020 A0-A3' 
		AND		IsCurrent = 1 AND AllocationCode = 'A0' ORDER BY PK_AllocationRules,EntityDest

		SELECT	@OrderofCurrentAllocation =  [RunOrder] 
		FROM	#AllocationOrder
		WHERE	AllocationCode = @AllocationCode

	DECLARE @RC int
	DECLARE @AllocationCode varchar(100)
	DECLARE @AllocationGroup varchar(100)
	DECLARE @IntradayFlag bit
	DECLARE @MAXTranID bigint
	DECLARE @Adhoc bit
	DECLARE @AccountingPeriod int

-- TODO: Set parameter values here.


	EXECUTE @RC = [dbo].[usp_GetAllocationsV4] 
	   @AllocationCode =?
	  ,@AllocationGroup= ?
	  ,@IntradayFlag = ?
	  ,@MAXTranID =?
	  ,@Adhoc = ?
	  ,@AccountingPeriod = 201709

	WITH RESULT SETS 
	(  ([AccountCode] [nvarchar](255) NULL,
		[ProcessCode] [nvarchar](255) NULL,
		[TriFocusCode] [nvarchar](255) NULL,
		[EntityCode] [nvarchar](255) NULL,
		[LocationCode] [nvarchar](255) NULL,
		[ProjectCode] [nvarchar](255) NULL,
					   [TargetEntity]  [nvarchar](255) NULL,
		[YOA] [nvarchar](255) NULL,
		[RuleID] [int] NULL,
		[AllocationCode] [varchar](25) NULL,
					  [AllocationGroup]  [varchar](25) NULL,
					  [AllocationGroupCodeVersion] int NULL ,
		[StepCode] [varchar](4) NULL,
		[AccountDest] [nvarchar](255) NULL,
		[TriFocusDest] [nvarchar](255) NULL,
		[EntityDest] [nvarchar](255) NULL,
					   [ProcessDest] [nvarchar](255) NULL,
		[LocationDest] [nvarchar](255) NULL,
		[ProjectDest] [nvarchar](255) NULL,
		[YOADest] [nvarchar](255) NULL,
					   [TargetEntityDest]  [nvarchar](255) NULL,
					   [TargetPeriodDest]  [nvarchar](255) NULL,
					   [TargetCurrencyDest]  [nvarchar](255) NULL,
		[AllocationPercent] [numeric](28, 8) NULL,
					   [CombinationID] int NULL
	));


	SELECT * FROM FDM_DB.dbo.BriExpensesTransactionDetailsV4
	SELECT * FROM FDM_DB.dbo.stg_DimAllocationCombinations

	SELECT	DISTINCT a.AccountCode
		,ISNULL(a.ProcessCode,'') AS ProcessCode
		,a.TriFocusCode
		,a.EntityCode
		,a.LocationCode
		,a.ProjectCode
		,CASE 
		WHEN Isnumeric(a.[YOA])=1 THEN a.[YOA]
		WHEN a.[YOA]='CALX' THEN 9999 
		WHEN a.[YOA]='NOYOA' THEN 9998
		WHEN a.[YOA]='OLD' THEN 9997
		ELSE -1 
		END  AS YOA
											 ,a.TargetEntity
			FROM	[dbo].[stg_DimAllocationCombinations](nolock) a
			LEFT JOIN [dbo].[DimAllocationCombinations](nolock) b
			ON LTRIM(RTRIM(a.AccountCode)) = LTRIM(RTRIM(b.AccountCode))
			AND LTRIM(RTRIM(ISNULL(a.ProcessCode,''))) = LTRIM(RTRIM(ISNULL(b.ProcessCode,'')))
			AND LTRIM(RTRIM(A.TriFocusCode)) = LTRIM(RTRIM(b.TriFocusCode))
			AND LTRIM(RTRIM(a.EntityCode)) = LTRIM(RTRIM(b.EntityCode))
			AND LTRIM(RTRIM(a.LocationCode)) = LTRIM(RTRIM(b.LocationCode))
			AND LTRIM(RTRIM(a.ProjectCode)) = LTRIM(RTRIM(b.ProjectCode))
			AND LTRIM(RTRIM(CASE 
								WHEN Isnumeric(a.[YOA])=1 THEN a.[YOA]
								WHEN a.[YOA]='CALX' THEN 9999 
								WHEN a.[YOA]='NOYOA' THEN 9998
								WHEN a.[YOA]='OLD' THEN 9997
								ELSE -1 
								END )) =LTRIM(RTRIM(b.YOA))
						  AND LTRIM(RTRIM(a.TargetEntity)) =LTRIM(RTRIM(b.TargetEntity)) 
			WHERE b.AccountCode IS NULL


			EXEC [usp_UpdateAllocationLog]
  @BridgeEndTime=?
  ,@BridgeCount=?
  ,@Status = 'Bridge Completed'
  ,@BatchID = ?
  ,@AllocationCode = ?


	SELECT TOP 100 *--MIN(pk_FACTAllocations) AS Seed
FROM FDM_DB.[dbo].FACTAllocationsV1


	SELECT DISTINCT [AllocationGroup],AllocationCode
  FROM [staging_agresso].[dbo].[AllocationsToRun]
  ORDER BY AllocationGroup,AllocationCode

  SELECT DISTINCT [AccountPeriod]
  FROM [staging_agresso].[dbo].[AllocationsToRun]
  ORDER BY [AccountPeriod]

  ;WITH OPTION1 AS (
	SELECT MAX(pk_FACTAllocations) AS Seed
FROM FDM_DB.[dbo].FACTAllocationsV1 b
JOIN	FDM_DB.[dbo].DimAllocationRules c
ON		c.PK_AllocationRules = b.FK_AllocationRules
WHERE	c.AllocationGroup ='Investments'
AND		fk_AccountingPeriod =201606 and fk_scenario = 0
)
,OPTION2 AS (
SELECT MIN(pk_FACTAllocations) AS Seed
FROM FDM_DB.[dbo].FACTAllocationsV1 
)
SELECT coalesce(a.Seed,b.Seed) FROM Option1 a
Cross Apply Option2 b


	-------------------------------------------------------------------------------------
	/**************************************Fact Allocations V1**************************************************/

	SELECT MIN(pk_FACTAllocations) AS Seed,MAX(pk_FACTAllocations)
	  FROM [dbo].FACTAllocationsV1

	SELECT COUNT(1) FROM [dbo].FACTAllocationsV1 WHERE pk_FACTAllocations > = -426684343 -- 101624436
	SELECT COUNT(1) FROM [dbo].FACTAllocationsV1 WHERE pk_FACTAllocations > = -426684343 AND SoftDeleteFlag = 0-- 51024925

	SELECT 101624436 - 51024925 -- 50599511
	SELECT * from DimScenario
	WHERE ScenarioCode = 'BP' or FriendlyName = 'BP'

	EXEC [dbo].[usp_UpdateDataInFactAllocationsForDelete] ?,?,?,?,?,?

	DECLARE @Adhoc AS BIT = 1
	,@IntraDay AS BIT = 0
	,@AccountingPeriod AS INT = 201506
	,@AllocationGroup AS VARCHAR(255) = 'Expenses 2020 A0-A3'

	IF OBJECT_ID('tempdb.dbo.#PeriodsToDelete', 'U') IS NOT NULL
		DROP TABLE #PeriodsToDelete;

	IF OBJECT_ID('tempdb.dbo.#AllocationGroupToDelete', 'U') IS NOT NULL
		DROP TABLE #AllocationGroupToDelete;

	CREATE TABLE #PeriodsToDelete (
			AccountPeriod VARCHAR(100)
			)
	CREATE TABLE #AllocationGroupToDelete (
			AllocationGroup VARCHAR(100)
			)

	;WITH CTE_Periods AS (
		SELECT CAST([AccountingPeriod] AS INT) AS [AccountingPeriod]
		FROM [dbo].[DimAccountingPeriod]
		WHERE AccountingMonth BETWEEN 1 AND 12 AND AccountingYear = @AccountingPeriod
		UNION 
		SELECT   CAST([AccountingPeriod] AS INT) AS  [AccountingPeriod] 
		FROM [dbo].[DimAccountingPeriod] 
		WHERE  AccountingPeriod = @AccountingPeriod
		)
		INSERT INTO #PeriodsToDelete 
		SELECT * FROM CTE_Periods

	INSERT INTO #PeriodsToDelete
	SELECT   CAST([AccountingPeriod] AS INT) AS  [AccountingPeriod]  
	FROM [dbo].[DimAccountingPeriod] 
	WHERE  AccountingPeriod = CAST(YEAR(GETDATE()) AS varchar)+CASE WHEN LEN(CAST(MONTH(GETDATE()) AS varchar)) =1 THEN '0'+CAST(MONTH(GETDATE()) AS varchar) ELSE CAST(MONTH(GETDATE()) AS varchar) END
	
	SELECT * FROM #PeriodsToDelete

	SELECT	DISTINCT AllocationGroup
	FROM	dbo.DimAllocationRules
	WHERE	[AllocationGroup] IN ('Expenses 2020 A0-A3')

	SELECT TOP 100 * FROM DimAllocationTransactionDetailsV2 WHERE ISNULL(SoftDeleteFlag,0) != 0 
	SELECT TOP 100 * FROM FACTAllocationsV1 WHERE SoftDeleteFlag IS NOT NULL
	--UPDATE  DimAllocationTransactionDetailsV2
	--SET		SoftDeleteFlag = @BatchID
	SELECT d.*
	FROM	DimAllocationTransactionDetailsV2 d
	JOIN	FACTAllocationsV1 f
	ON		d.pk_FactAllocation = f.pk_FACTAllocations
	JOIN	dbo.DimAllocationRules sv
	ON		sv.PK_AllocationRules = f.FK_AllocationRules
	JOIN	#PeriodsToDelete p
	ON		p.AccountPeriod = f.fk_AccountingPeriod
	JOIN	#AllocationGroupToDelete ag
	ON		ag.AllocationGroup = sv.AllocationGroup
	JOIN    DimClient c 
	ON		c.pk_Client = f.fk_Client
	JOIN	DimScenario on pk_Scenario = fk_Scenario
	WHERE	ScenarioCode = 'BP' or FriendlyName = 'BP'
	AND 	f.SoftDeleteFlag = 0


	--UPDATE	FACTAllocationsV1
	--SET		SoftDeleteFlag = @BatchID
	SELECT f.*
	FROM	FACTAllocationsV1 f
	JOIN	dbo.DimAllocationRules sv
	ON		sv.PK_AllocationRules = f.FK_AllocationRules
	JOIN	#PeriodsToDelete p
	ON		p.AccountPeriod = f.fk_AccountingPeriod
	JOIN	#AllocationGroupToDelete ag
	ON		ag.AllocationGroup = sv.AllocationGroup
	JOIN    DimClient c 
	ON		c.pk_Client = f.fk_Client
	JOIN	DimScenario on pk_Scenario = fk_Scenario
	WHERE	ScenarioCode = 'BP' or FriendlyName = 'BP'
	AND 	f.SoftDeleteFlag = 0

	--------------------------------------------------------------------

	SELECT * FROM dbo.FACTAllocationsV1_Internal

	SELECT pk_factAllocations
		,[pk_tempFactFDM]
      ,[Source_pk_tempFactFDM]
      ,[fk_Account]
      ,[fk_AccountingPeriod]
      ,[fk_BusinessPlan]
      ,[fk_ClaimExposure]
      ,[fk_DataStage]
      ,[fk_Entity]
      ,[fk_Expense]
      ,[fk_Holding]
      ,[fk_LloydsClassifications]
      ,[fk_Office]
      ,[fk_OriginalCurrency]
      ,[fk_PolicySection]
      ,[SectionReference]
      ,[fk_Process]
      ,[fk_Product]
      ,[fk_Project]
      ,[fk_RIPolicy]
      ,[fk_Scenario]
      ,[fk_SourceSystem]
      ,[fk_TriFocus]
      ,[fk_YOA]
      ,[fk_Client]
      ,[bk_TransactionID]
      ,[VoucherNumber]
      ,[Value]
      ,[cur_amount]
      ,[currency]
      ,[value_1]
      ,[value_2]
      ,[value_3]
      ,[fk_User]
      ,[insert_date]
      ,[insert_time]
      ,[voucher_date]
      ,[transaction_date]
      ,[tax_code]
      ,[tax_system]
      ,[fk_Location]
      ,[fk_InceptionDate]
      ,[fk_ExpiryDate]
      ,[CombinationID]
      ,[FK_AllocationRules]
      ,[AllocationPercent]
      ,[AccountDest]
      ,[LocationDest]
      ,[EntityDest]
      ,[YOADest]
      ,[ProcessDest]
      ,[ProjectDest]
      ,[TriFocusDest]
      ,[RuleApplicable]
      ,[AllocationCOde]
      ,[fk_DimEarnings]
      ,[fk_TargetEntity]
      ,[fk_TargetPeriod]
      ,[fk_PolicySectionV2]
      ,[TargetCurrencyDest]
      ,[BatchID]
      ,[gl_AccountingPeriod]
, SoftDeleteFlag
  FROM [dbo].[FACTAllocationsV1](nolock)
WHERE SoftDeleteFlag =?
AND pk_factAllocations>= ?

	 FROM [dbo].[FACTAllocationsV1_internal](nolock)
WHERE SoftDeleteFlag =?
AND pk_factAllocations>= ?


	--------------------------------------------------------------------

	SELECT [pk_tempFactFDM]
      ,[Source_pk_tempFactFDM]
      ,[fk_Account]
      ,[fk_AccountingPeriod]
      ,[fk_BusinessPlan]
      ,[fk_ClaimExposure]
      ,[fk_DataStage]
      ,[fk_Entity]
      ,[fk_Expense]
      ,[fk_Holding]
      ,[fk_LloydsClassifications]
      ,[fk_Office]
      ,[fk_OriginalCurrency]
      ,[fk_PolicySection]
      ,[SectionReference]
      ,[fk_Process]
      ,[fk_Product]
      ,[fk_Project]
      ,[fk_RIPolicy]
      ,[fk_Scenario]
      ,[fk_SourceSystem]
      ,[fk_TriFocus]
      ,[fk_YOA]
      ,[fk_Client]
      ,[bk_TransactionID]
      ,[VoucherNumber]
      ,[Value]
      ,[cur_amount]
      ,[currency]
      ,[value_1]
      ,[value_2]
      ,[value_3]
      ,[fk_User]
      ,[insert_date]
      ,[insert_time]
      ,[voucher_date]
      ,[transaction_date]
      ,[tax_code]
      ,[tax_system]
      ,[fk_Location]
      ,[fk_InceptionDate]
      ,[fk_ExpiryDate]
      ,[CombinationID]
      ,[FK_AllocationRules]
      ,[AllocationPercent]
      ,[AccountDest]
      ,[LocationDest]
      ,[EntityDest]
      ,[YOADest]
      ,[ProcessDest]
      ,[ProjectDest]
      ,[TriFocusDest]
      ,[RuleApplicable]
      ,[AllocationCOde]
      ,[fk_DimEarnings]
      ,[fk_TargetEntity]
      ,[fk_TargetPeriod]
      ,[fk_PolicySectionV2]
      ,[TargetCurrencyDest]
      ,[BatchID]
      ,[gl_AccountingPeriod]
, SoftDeleteFlag
  FROM [dbo].[FACTAllocationsV1_internal](nolock)
WHERE SoftDeleteFlag =?
AND pk_factAllocations>= ?


	SELECT TOP 100
	ROUND(cur_amount * -100,10) / 100.0000,
	ROUND(value_1 * -100,10) / 100.0000,
	ROUND(value_2 * -100,10) / 100.0000,
	ROUND(value_3 * -100,10) / 100.0000,
	ROUND(Value * -100,10) / 100.0000
	FROM [dbo].[FACTAllocationsV1](nolock)

	SELECT TOP 100 * FROM FACTAllocationsV1
	
	----------------------------------------------------------------------------

	SELECT	TOP 100 CombinationID
		,RTRIM(LTRIM(AccountCode)) AS AccountCode
		,RTRIM(LTRIM(ProcessCode)) AS ProcessCode
		,RTRIM(LTRIM(TriFocusCode)) AS TriFocusCode
		,RTRIM(LTRIM([EntityCode])) AS [EntityCode]
		,RTRIM(LTRIM([LocationCode])) AS [LocationCode]
		,RTRIM(LTRIM([ProjectCode])) AS [ProjectCode]
		,CASE 
					WHEN Isnumeric(RTRIM(LTRIM([YOA])) )<> 1 THEN [YOA] 
					WHEN RTRIM(LTRIM([YOA])) = 9999 THEN  'CALX'
					WHEN RTRIM(LTRIM([YOA])) = 9998  THEN 'NOYOA'
					WHEN RTRIM(LTRIM([YOA])) = 9997  THEN 'OLD' 
					ELSE [YOA]  END					AS [YOA]
		,RTRIM(LTRIM([TargetEntity])) AS [TargetEntity]
	FROM DimAllocationCombinations

	------------------------------------------------------

	SELECT DISTINCT [AllocationGroup],AllocationCode
	FROM [staging_agresso].[dbo].[AllocationsToRun]
	ORDER BY AllocationGroup,AllocationCode

	SELECT DISTINCT [AccountPeriod]
	FROM [staging_agresso].[dbo].[AllocationsToRun]
	ORDER BY [AccountPeriod]

	SELECT MIN(pk_FACTAllocations) AS Seed
	FROM [dbo].FACTAllocationsV1

	;WITH OPTION1 AS (
	SELECT MAX(pk_FACTAllocations) AS Seed
	FROM [dbo].FACTAllocationsV1 b
	JOIN	DimAllocationRules c
	ON		c.PK_AllocationRules = b.FK_AllocationRules
	WHERE	c.AllocationGroup ='Expenses 2020 A0-A3'
	AND		fk_AccountingPeriod =202002 and fk_scenario = 0
	)
	,OPTION2 AS (
	SELECT MIN(pk_FACTAllocations) AS Seed
	FROM [dbo].FACTAllocationsV1 
	)
	SELECT coalesce(a.Seed,b.Seed) FROM Option1 a
	Cross Apply Option2 b

	--TRUNCATE TABLE 
	SELECT * FROM dbo.DimAllocationTransactionDetailsV2_temp

	SELECT * FROM DimAllocationRules
	WHERE AllocationGroup= ?
	AND AllocationCode = ?
	AND IsCurrent = 1

	----------------------------------------------
	SELECT pk_FACTAllocations AS pk_tempFactFDM	,
	pk_tempFactFDM AS Source_pk_tempFactFDM,
	Value	,
	cur_amount	,
	currency	,
	value_1	,
	value_2	,
	value_3	,
	fk_AccountingPeriod,
	fk_Client,
	fk_scenario
	  FROM [dbo].FACTAllocationsV1(nolock) f
	 JOIN DimAllocationRules a
	  ON f.FK_AllocationRules = a.PK_AllocationRules
	WHERE RuleApplicable = 1
	AND pk_FACTAllocations >= ?
	AND fk_Accountingperiod = ?
	AND fk_scenario = ?
	AND AllocationGroup = ?
	AND f.BatchID = ?
	AND SoftDeleteFlag = 0
	AND IsCurrent = 1
	ORDER BY pk_tempFactFDM
	---------------------------------------------------------------
	EXEC [dbo].[USP_GetReAllocationData] ?,?,?,?
	WITH RESULT SETS 
	(  (pk_FactFDM BIGINT NULL,
		CombinationID INT NULL,
		AllocationCode VARCHAR(25) NULL,
		RuleID INT NULL,
		AllocationPercent NUMERIC(28,8),
		AccountDest NVARCHAR(255) NULL,	
		LocationDest NVARCHAR(255) NULL,	
		EntityDest NVARCHAR(255) NULL,	
		YOADest NVARCHAR(255) NULL,	
		ProcessDest NVARCHAR(255) NULL,	
		ProjectDest NVARCHAR(255) NULL,	
		TriFocusDest NVARCHAR(255) NULL,	
		TargetCurrencyDest NVARCHAR(255) NULL,	
		TargetEntityDest NVARCHAR(255) NULL,	
		TargetPeriodDest NVARCHAR(255) NULL,	
		RuleApplicable int null

	));

	SELECT TOP 100 * 
	--INTO #CTE1 
	FROM	[dbo].[DimAllocationTransactionDetailsV2](nolock)
	WHERE pk_FACTAllocation < -83591603  AND pk_FACTAllocation >= -426684343
	AND SoftDeleteFlag = 0

		SELECT tmp.[pk_FactAllocation]
				,comb.[CombinationID]
	  FROM [dbo].[DimAllocationTransactionDetailsV2_temp] as tmp
	  LEFT JOIN
	  [dbo].[DimAllocationCombinations] as comb
	  ON   tmp.[AccountCode]	=	comb.[AccountCode]
	  AND  tmp.[ProcessCode]	=	comb.[ProcessCode]
	  AND  tmp.[TriFocusCode]	=	comb.[TriFocusCode]
	  AND  tmp.[EntityCode]	=	comb.[EntityCode]
	  AND  tmp.[LocationCode]	=	comb.[LocationCode]
	  AND  tmp.[ProjectCode]	=	comb.[ProjectCode]
	  AND  tmp.[YOA]		=	CASE WHEN comb.[YOA] = '9999' THEN 'CALX'
										WHEN comb.[YOA] = '9998' THEN 'NOYOA' 
										WHEN comb.[YOA] = '9997' THEN 'OLD'
										ELSE comb.[YOA] END
	  AND  tmp.[TargetEntity]	=	comb.[TargetEntity]


	  SELECT * FROM dbo.DimAllocationTransactionDetailsV2_temp

	  -------------------------------------------
	  SELECT	pk_FactFDM	,
		pk_FactFDM AS Source_pk_tempFactFDM,
		Value	,
		cur_amount	,
		currency	,
		value_1	,
		value_2	,
		value_3,
		fk_AccountingPeriod,
		fk_Client,
		fk_scenario
	FROM FactFDM t(nolock)
	JOIN DimEntity e

	ON e.pk_Entity = t.fk_Entity
	LEFT JOIN (
				SELECT	DISTINCT pk_Process
				FROM	DimAllocationRules a
				JOIN	DimProcess p ON p.ProcessCode = a.ProcessDest
				WHERE	AllocationGroup = ?
				AND		IsCurrent = 1
	)		a
	ON		a.pk_Process = t.fk_Process
	JOIN (
				SELECT	min( AccountFrom) AccountFrom , Max(AccountTO) Accountto
				FROM	DimAllocationRules a
				WHERE	AllocationGroup = ?
				AND		IsCurrent = 1
	)		b
	ON		t.fk_Account BETWEEN AccountFrom AND Accountto
	JOIN (
				SELECT	min( EntityFrom) EntityFrom , Max(EntityTo) EntityTo
				FROM	DimAllocationRules a
				WHERE	AllocationGroup = ?
				AND		AllocationCode = ?
				AND		IsCurrent = 1
	)		c
	ON		e.EntityCode BETWEEN EntityFrom AND EntityTo
	WHERE	1 = 1
	AND		fk_AccountingPeriod = ?
	AND		fk_scenario = ?
	AND		a.pk_Process IS NULL
	--AND bk_transactionID<?
	ORDER BY pk_FactFDM

	SELECT	DISTINCT pk_FactFDM
		,a.CombinationID
                                      ,b.AllocationCode   
		,b.fk_AllocationRules AS RuleID
		,b.AllocationPercent AS AllocationPercent
		,RTRIM(LTRIM(b.AccountDest)) AccountDest
		,RTRIM(LTRIM(b.LocationDest)) LocationDest
		,RTRIM(LTRIM(b.EntityDest)) EntityDest
		,RTRIM(LTRIM(b.YOADest)) YOADest
		,RTRIM(LTRIM(b.ProcessDest)) ProcessDest
		,RTRIM(LTRIM(b.ProjectDest)) ProjectDest
		,RTRIM(LTRIM(b.TriFocusDest)) AS TriFocusDest
                                     ,RTRIM(LTRIM(b.TargetCurrencyDest)) AS TargetCurrencyDest
		,RTRIM(LTRIM(b.TargetEntityDest)) AS TargetEntityDest
		,RTRIM(LTRIM(b.TargetPeriodDest)) AS TargetPeriodDest
		,CASE	WHEN Applicable = 1 THEN 1
				ELSE 0
		END AS RuleApplicable
		FROM	DimTransactionDetailsV1(nolock) a
		JOIN	BriExpensesTransactionDetailsV4 b
		ON		a.CombinationID = b.CombinationID
		JOIN	DimAllocationRules c
		ON		c.PK_AllocationRules = b.FK_AllocationRules
		LEFT	JOIN	(
				SELECT	MIN(a.AccountFrom) AccountFrom 
						,MAX(a.AccountTo) AccountTo 
						,1 AS Applicable
				FROM	dbo.DimAllocationRules a
											  Where a.AccountFrom <>  'Unknown'
		) d
		ON		b.AccountDest BETWEEN d.AccountFrom and d.AccountTo 
		WHERE	b.AllocationCode = ?
		AND		a.AccountingPeriod =?
		AND		c.AllocationGroup = ?
		AND isCurrent =1
		ORDER	BY pk_FactFDM

		SELECT TOP 100 * FROM DimTransactionDetailsV1 -- 197972261
		SELECT TOP 100 * FROM BriExpensesTransactionDetailsV4 -- 229307804
		SELECT TOP 100 * FROM FACTAllocationsV1

		------------------------------------------------

		SELECT tmp.[pk_FactAllocation]
            ,comb.[CombinationID]
		  FROM [dbo].[DimAllocationTransactionDetailsV2_temp] as tmp
		  LEFT JOIN
		  [dbo].[DimAllocationCombinations] as comb
		  ON   tmp.[AccountCode]	=	comb.[AccountCode]
		  AND  tmp.[ProcessCode]	=	comb.[ProcessCode]
		  AND  tmp.[TriFocusCode]	=	comb.[TriFocusCode]
		  AND  tmp.[EntityCode]	=	comb.[EntityCode]
		  AND  tmp.[LocationCode]	=	comb.[LocationCode]
		  AND  tmp.[ProjectCode]	=	comb.[ProjectCode]
		  AND  tmp.[YOA]		=	CASE WHEN comb.[YOA] = '9999' THEN 'CALX'
											WHEN comb.[YOA] = '9998' THEN 'NOYOA' 
											WHEN comb.[YOA] = '9997' THEN 'OLD'
											ELSE comb.[YOA] END
		  AND  tmp.[TargetEntity]	=	comb.[TargetEntity]

	SELECT * FROM DimAllocationTransactionDetailsV2