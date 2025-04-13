----SELECT * INTO [dbo].[DimAllocationRules_POC] FROM [dbo].[DimAllocationRules] WHERE 1= 2

--SELECT count(1) FROM [dbo].[DimAllocationRules_POC] (NOLOCK) -- 2427161

--SELECT top 100 *  FROM [dbo].[DimAllocationRules_POC] (NOLOCK) WHERE AllocationGroup = 'US Premium'
--'--'expenses.prod'

--	SELECT DISTINCT AllocationGroup  FROM [dbo].[DimAllocationRules_POC]


	SELECT top 100 *  FROM [dbo].[DimAllocationRules_POC] (NOLOCK) WHERE AllocationGroup = 'US Premium'

	SELECT DISTINCT AllocationGroup
	,AllocationGroupId
	,AllocationCode
	,AllocationGroupCodeVersion 
	,IsCurrent
	--,GranularityFlag
	FROM  DimAllocationRules_POC
	WHERE 1 =1 --IsCurrent = 1
	  AND AllocationGroup = 'US Premium'
	ORDER BY AllocationGroup,AllocationGroupCodeVersion -- 1596


	SELECT DISTINCT AllocationGroup
		,AllocationGroupId
		,AllocationCode
		,AllocationGroupCodeVersion 
		,IsCurrent
		,COUNT(1)
	--,GranularityFlag
	FROM  DimAllocationRules_POC
	WHERE 1 =1 --IsCurrent = 1
	  AND AllocationGroup LIKE '%Expenses 2020 A0-A3%' --'US Premium'
	  AND IsCurrent = 1
	  GROUP BY AllocationGroup
		,AllocationGroupId
		,AllocationCode
		,AllocationGroupCodeVersion 
		,IsCurrent
	ORDER BY AllocationGroup,AllocationCode,AllocationGroupCodeVersion -- 1596

	SELECT *--AllocationCode,StepCode,SUM(AllocationPercent)
	  FROM dbo.DimAllocationRules_POC
	 WHERE 1 =1 --IsCurrent = 1
	   AND AllocationGroup LIKE '%Expenses 2020 A0-A3%' 
	   --AND AllocationCode = 'A1'
	   AND IsCurrent = 1
	   --AND AllocationPercent >0
	   --GROUP BY AllocationCode,StepCode

	--SELECT * FROM FDM_DB.dbo.FACTAllocationsV1
	   

	   /*************************************************************************************
	   Add new columns ChangeType,PK_Alt_AllocationRules to DimAllocationRules table
	   ChangeType Values are:New,Delete,Percentage Change,Metadata change
	   PK_Alt_AllocationRules will have current rule PK_AllocationRules
	   **************************************************************************************/
		IF NOT EXISTS(SELECT 1 FROM sys.columns 
						WHERE Name = N'ChangeType'
						AND Object_ID = Object_ID(N'dbo.DimAllocationRules_POC'))
		BEGIN
			ALTER TABLE dbo.DimAllocationRules_POC
			Add ChangeType VARCHAR(50)--,PK_Alt_AllocationRules INT
		END

		IF NOT EXISTS(SELECT 1 FROM sys.columns 
						WHERE Name = N'PK_Alt_AllocationRules'
						AND Object_ID = Object_ID(N'dbo.DimAllocationRules_POC'))
		BEGIN
			ALTER TABLE dbo.DimAllocationRules_POC
			Add PK_Alt_AllocationRules INT
		END
		IF NOT EXISTS(SELECT 1 FROM sys.columns 
						WHERE Name = N'AllocationGroupCodeSubVersion'
						AND Object_ID = Object_ID(N'dbo.DimAllocationRules_POC'))
		BEGIN
			ALTER TABLE dbo.DimAllocationRules_POC
			Add AllocationGroupCodeSubVersion INT
		END
		--/******************************************************************************
		--Update PK_Alt_AllocationRules with existing allocation rule id
		--*******************************************************************************/
		UPDATE dbo.DimAllocationRules_POC
		   SET PK_Alt_AllocationRules = PK_AllocationRules

		UPDATE dbo.DimAllocationRules_POC
		   SET AllocationGroupCodeSubVersion = 1

		--SELECT  COL_LENGTH('dbo.DimAllocationRules', 'PK_AllocationRules')
		--SELECT  COL_LENGTH('dbo.DimAllocationRules_POC', 'ChangeType')

		--IF COL_LENGTH('dbo.DimAllocationRules_POC', 'ChangeType') IS NOT NULL
		--	PRINT 'Column Exists'
		--ELSE
		--	PRINT 'Column doesn''t Exists'


		SELECT * FROM dbo.DimAllocationRules_POC WHERE AllocationGroup = 'Investment.2016UpdatedV1'
		SELECT * FROM dbo.DimAllocationRules_POC WHERE AllocationGroup = 'Investment.2016UpdatedV1'
		
		SELECT * FROM staging_agresso.dbo.AllocationRulesStage


		------------------------------------------------------------
	SELECT DISTINCT AllocationGroup
		,AllocationGroupId
		,AllocationCode
		,AllocationGroupCodeVersion 
		,IsCurrent
		,GranularityFlag
	FROM  DimAllocationRules
	WHERE IsCurrent = 1
	ORDER BY AllocationGroup,AllocationGroupCodeVersion -- 1596

	SELECT TOP 100 * FROM  DimAllocationRules 
	 WHERE IsCurrent = 1
	   AND AllocationGroup = 'Expenses.2016'
	   AND AllocationGroupCodeVersion = 4

	  SELECT * FROM staging_agresso.dbo.AllocationRulesStage
	  SELECT * FROM  DimAllocationRules	WHERE IsCurrent = 1 AND AllocationGroup = 'US Premium'


		  SELECT * 
			FROM staging_agresso.dbo.AllocationRulesStage A
		   INNER JOIN dbo.DimAllocationRules B
			  ON A.AllocationGroup = B.AllocationGroup
			 AND A.AllocationCode = B.AllocationCode
			 AND A.StepCode = B.StepCode
			 AND A.AccountFrom	= B.AccountFrom
			 AND A.AccountTo	= B.AccountTo
			 AND A.TrifocusFrom	= B.TrifocusFrom
			 AND A.TrifocusTo	= B.TrifocusTo
			 AND A.EntityFrom	= B.EntityFrom
			 AND A.EntityTo	= B.EntityTo
			 AND A.LocationFrom	= B.LocationFrom
			 AND A.LocationTo	= B.LocationTo		 
			 AND A.ProjectFrom	= B.ProjectFrom
			 AND A.ProjectTo	= B.ProjectTo
			 AND A.YOAFrom	= B.YOAFrom
			 AND A.YOATo	= B.YOATo
			 AND A.ProcessFrom	= B.ProcessFrom
			 AND A.ProcessTo	= B.ProcessTo
			 AND A.AccountDest	= B.AccountDest
			 AND A.TrifocusDest	= B.TrifocusDest
			 AND A.EntityDest	= B.EntityDest
			 AND A.AccountFrom	= B.AccountFrom
		   WHERE B.IsCurrent = 1

	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC WHERE AllocationRulesStageId = 5
	SELECT * FROM dbo.DimAllocationRules_POC WHERE PK_AllocationRules IN ( 2427032,2427033)

	SELECT * FROM dbo.DimAllocationRules_POC WHERE AccountFrom = 10100 
	AND TrifocusFrom IN ('FT','TRI00069')
	AND TrifocusTo IN ('TRI00067','ZZ') AND AccountDest = 10100 AND EntityDest = '2623'
	AND IsCurrent =1

	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC WHERE AllocationRulesStageId = 7
	SELECT * FROM dbo.DimAllocationRules_POC WHERE PK_AllocationRules IN (2427036,2427037,2427050,2427056,2427057)			 