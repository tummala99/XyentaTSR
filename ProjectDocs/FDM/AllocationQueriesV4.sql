	/*
		
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

	*/

	DECLARE @AllocationGroup VARCHAR(255),@AllocationCode VARCHAR(255)
		SET @AllocationGroup = 'US Premium'
		SET @AllocationCode = 'USPREM'

	/******************************************************************************
	Generate Row hash for source allocation data by grouping all columns excepts percentage
	*******************************************************************************/

	IF(OBJECT_ID('tempdb..#AllocationRules_Staging') IS NOT NULL)
		DROP TABLE #AllocationRules_Staging

	SELECT  MAX(AllocationRulesStageId) AS AllocationRulesStageId
		 , AllocationGroup,AllocationUser,AllocationCode,StepCode,GranularityFlag
		 , AccountDest,TrifocusDest,EntityDest,LocationDest,ProjectDest,YOADest,ProcessDest,TargetPeriodDest,TargetEntityDest,TargetCurrencyDest
		 , AccountFrom,AccountTo,TrifocusFrom,TrifocusTo,EntityFrom,EntityTo,LocationFrom,LocationTo,ProjectFrom,ProjectTo
		 , YOAFrom,YOATo,ProcessFrom,ProcessTo,TargetEntityFrom,TargetEntityTo
		 , SUM(AllocationPercent) AS AllocationPercent		
		 , RowHash = HASHBYTES('SHA2_512',CONCAT(AccountFrom, 
								'§~§', AccountTo, 
								'§~§', TrifocusFrom, 
								'§~§', TrifocusTo, 
								'§~§', EntityFrom, 
								'§~§', EntityTo, 
								'§~§', LocationFrom, 
								'§~§', LocationTo, 
								'§~§', ProjectFrom, 
								'§~§', ProjectTo, 
								'§~§', YOAFrom, 
								'§~§', YOATo, 
								'§~§', ProcessFrom, 
								'§~§', ProcessTo, 
								'§~§', TargetEntityFrom, 
								'§~§', TargetEntityTo,
								'§~§',GranularityFlag,
								'§~§',AccountDest,
								'§~§',TrifocusDest,
								'§~§',EntityDest,
								'§~§',LocationDest,
								'§~§',ProjectDest,
								'§~§',YOADest,
								'§~§',ProcessDest,
								'§~§',TargetPeriodDest,
								'§~§',TargetEntityDest,
								'§~§',TargetCurrencyDest,
								'§~§'))
	  INTO #AllocationRules_Staging
	  FROM staging_agresso.dbo.AllocationRulesStage_POC 
	 WHERE AllocationGroup = @AllocationGroup
	   AND AllocationCode = @AllocationCode
	 GROUP BY AllocationGroup,AllocationUser,AllocationCode,StepCode,GranularityFlag
		 , AccountDest,TrifocusDest,EntityDest,LocationDest,ProjectDest,YOADest,ProcessDest,TargetPeriodDest,TargetEntityDest,TargetCurrencyDest
		 , AccountFrom,AccountTo,TrifocusFrom,TrifocusTo,EntityFrom,EntityTo,LocationFrom,LocationTo,ProjectFrom,ProjectTo
		 , YOAFrom,YOATo,ProcessFrom,ProcessTo,TargetEntityFrom,TargetEntityTo
	--SELECT * FROM #AllocationRules_Staging

	/******************************************************************************
	Generate Row hash for Dim allocation data by grouping all columns excepts percentage
	*******************************************************************************/

	IF(OBJECT_ID('tempdb..#DimAllocationRules') IS NOT NULL)
		DROP TABLE #DimAllocationRules

	SELECT MAX(PK_AllocationRules) AS PK_AllocationRules
		 , AllocationGroup,AllocationUser,AllocationCode,StepCode,GranularityFlag
		 , AccountDest,TrifocusDest,EntityDest,LocationDest,ProjectDest,YOADest,ProcessDest,TargetPeriodDest,TargetEntityDest,TargetCurrencyDest
		 , AccountFrom,AccountTo,TrifocusFrom,TrifocusTo,EntityFrom,EntityTo,LocationFrom,LocationTo,ProjectFrom,ProjectTo
		 , YOAFrom,YOATo,ProcessFrom,ProcessTo,TargetEntityFrom,TargetEntityTo
		 , MAX(AllocationGroupCodeVersion) AS AllocationGroupCodeVersion,MAX(AllocationGroupCodeSubVersion) AS AllocationGroupCodeSubVersion
		 , SUM(AllocationPercent) AS AllocationPercent		
		 , RowHash = HASHBYTES('SHA2_512',CONCAT(AccountFrom, 
								'§~§', AccountTo, 
								'§~§', TrifocusFrom, 
								'§~§', TrifocusTo, 
								'§~§', EntityFrom, 
								'§~§', EntityTo, 
								'§~§', LocationFrom, 
								'§~§', LocationTo, 
								'§~§', ProjectFrom, 
								'§~§', ProjectTo, 
								'§~§', YOAFrom, 
								'§~§', YOATo, 
								'§~§', ProcessFrom, 
								'§~§', ProcessTo, 
								'§~§', TargetEntityFrom, 
								'§~§', TargetEntityTo,
								'§~§',GranularityFlag,
								'§~§',AccountDest,
								'§~§',TrifocusDest,
								'§~§',EntityDest,
								'§~§',LocationDest,
								'§~§',ProjectDest,
								'§~§',YOADest,
								'§~§',ProcessDest,
								'§~§',TargetPeriodDest,
								'§~§',TargetEntityDest,
								'§~§',TargetCurrencyDest,
								'§~§'))
	  INTO #DimAllocationRules
	  FROM dbo.DimAllocationRules_POC
	 WHERE AllocationGroup = @AllocationGroup
	   AND AllocationCode = @AllocationCode 
	   AND IsCurrent = 1
	 GROUP BY AllocationGroup,AllocationUser,AllocationCode,StepCode,GranularityFlag
		 , AccountDest,TrifocusDest,EntityDest,LocationDest,ProjectDest,YOADest,ProcessDest,TargetPeriodDest,TargetEntityDest,TargetCurrencyDest
		 , AccountFrom,AccountTo,TrifocusFrom,TrifocusTo,EntityFrom,EntityTo,LocationFrom,LocationTo,ProjectFrom,ProjectTo
		 , YOAFrom,YOATo,ProcessFrom,ProcessTo,TargetEntityFrom,TargetEntityTo
	--SELECT * FROM #DimAllocationRules

	
	--SELECT * FROM #AllocationRules_Staging WHERE AllocationRulesStageId IN (5,6,140)
	--SELECT * FROM #DimAllocationRules WHERE PK_AllocationRules IN (2427028,2427029,2427155)
	/******************************************************************************
	Find and log the allocation rules which are not changed
	*******************************************************************************/

	--SELECT * FROM #AllocationRules_Staging
	--SELECT * FROM #DimAllocationRules

	IF(OBJECT_ID('tempdb..#AllocationRulesTemp') IS NOT NULL)
		DROP TABLE #AllocationRulesTemp

	SELECT A.AllocationRulesStageId,B.PK_AllocationRules,A.AllocationGroup,A.AllocationUser,A.AllocationCode,A.StepCode,A.GranularityFlag
		 , A.AccountDest,A.TrifocusDest,A.EntityDest,A.LocationDest,A.ProjectDest,A.YOADest,A.ProcessDest,A.TargetPeriodDest,A.TargetEntityDest,A.TargetCurrencyDest
		 , A.AccountFrom,A.AccountTo,A.TrifocusFrom,A.TrifocusTo,A.EntityFrom,A.EntityTo,A.LocationFrom,A.LocationTo,A.ProjectFrom,A.ProjectTo
		 , A.YOAFrom,A.YOATo,A.ProcessFrom,A.ProcessTo,A.TargetEntityFrom,A.TargetEntityTo
		 , B.AllocationGroupCodeVersion,B.AllocationGroupCodeSubVersion
		 , A.AllocationPercent
		 , ChangeType = CAST('No Change' AS VARCHAR(50))
	  INTO #AllocationRulesTemp
	  FROM #AllocationRules_Staging A
	 INNER JOIN #DimAllocationRules B
	    ON A.AllocationGroup = B.AllocationGroup
	   AND A.AllocationCode = B.AllocationCode
	   AND A.StepCode = B.StepCode	   	
	 WHERE A.RowHash = B.RowHash
	 ORDER BY B.PK_AllocationRules -- 135

	--SELECT * FROM #AllocationRulesTemp
			
	/******************************************************************************
	Find and log the allocation rules which are not in dim allocations as new rules
	*******************************************************************************/
	INSERT INTO #AllocationRulesTemp(AllocationRulesStageId,PK_AllocationRules,AllocationGroup,AllocationUser,AllocationCode,StepCode,GranularityFlag
				, AccountDest,TrifocusDest,EntityDest,LocationDest,ProjectDest,YOADest,ProcessDest,TargetPeriodDest,TargetEntityDest,TargetCurrencyDest
				, AccountFrom,AccountTo,TrifocusFrom,TrifocusTo,EntityFrom,EntityTo,LocationFrom,LocationTo,ProjectFrom,ProjectTo
				, YOAFrom,YOATo,ProcessFrom,ProcessTo,TargetEntityFrom,TargetEntityTo
				, AllocationGroupCodeVersion,AllocationGroupCodeSubVersion
				, AllocationPercent,ChangeType)			
	
	SELECT A.AllocationRulesStageId,CAST(0 AS INT) AS PK_AllocationRules,A.AllocationGroup,A.AllocationUser,A.AllocationCode,A.StepCode,A.GranularityFlag
		 , A.AccountDest,A.TrifocusDest,A.EntityDest,A.LocationDest,A.ProjectDest,A.YOADest,A.ProcessDest,A.TargetPeriodDest,A.TargetEntityDest,A.TargetCurrencyDest
		 , A.AccountFrom,A.AccountTo,A.TrifocusFrom,A.TrifocusTo,A.EntityFrom,A.EntityTo,A.LocationFrom,A.LocationTo,A.ProjectFrom,A.ProjectTo
		 , A.YOAFrom,A.YOATo,A.ProcessFrom,A.ProcessTo,A.TargetEntityFrom,A.TargetEntityTo
		 , CAST(0 AS INT) AS AllocationGroupCodeVersion,CAST(0 AS INT) AS AllocationGroupCodeSubVersion
		 , A.AllocationPercent
		 , ChangeType = CAST('New' AS VARCHAR(50))	  
	  FROM #AllocationRules_Staging A
	  LEFT JOIN #DimAllocationRules B
	    ON A.AllocationGroup = B.AllocationGroup
	   AND A.AllocationCode = B.AllocationCode
	   AND A.StepCode = B.StepCode	  
	--AND A.RowHash = B.RowHash
	 WHERE B.PK_AllocationRules IS NULL		  
	 ORDER BY B.PK_AllocationRules

	--SELECT * FROM #AllocationRulesTemp
	/******************************************************************************
	Find and log the allocation rules which are  changed in meta data
	*******************************************************************************/
	INSERT INTO #AllocationRulesTemp(AllocationRulesStageId,PK_AllocationRules,AllocationGroup,AllocationUser,AllocationCode,StepCode,GranularityFlag
				, AccountDest,TrifocusDest,EntityDest,LocationDest,ProjectDest,YOADest,ProcessDest,TargetPeriodDest,TargetEntityDest,TargetCurrencyDest
				, AccountFrom,AccountTo,TrifocusFrom,TrifocusTo,EntityFrom,EntityTo,LocationFrom,LocationTo,ProjectFrom,ProjectTo
				, YOAFrom,YOATo,ProcessFrom,ProcessTo,TargetEntityFrom,TargetEntityTo
				, AllocationGroupCodeVersion,AllocationGroupCodeSubVersion
				, AllocationPercent,ChangeType)
	SELECT A.AllocationRulesStageId,B.PK_AllocationRules,A.AllocationGroup,A.AllocationUser,A.AllocationCode,A.StepCode,A.GranularityFlag
		 , A.AccountDest,A.TrifocusDest,A.EntityDest,A.LocationDest,A.ProjectDest,A.YOADest,A.ProcessDest,A.TargetPeriodDest,A.TargetEntityDest,A.TargetCurrencyDest
		 , A.AccountFrom,A.AccountTo,A.TrifocusFrom,A.TrifocusTo,A.EntityFrom,A.EntityTo,A.LocationFrom,A.LocationTo,A.ProjectFrom,A.ProjectTo
		 , A.YOAFrom,A.YOATo,A.ProcessFrom,A.ProcessTo,A.TargetEntityFrom,A.TargetEntityTo
		 , B.AllocationGroupCodeVersion,B.AllocationGroupCodeSubVersion
		 , A.AllocationPercent
		 , ChangeType = 'Meta Data Change'
		--, B.TrifocusTo
	  FROM #AllocationRules_Staging A
	 INNER JOIN #DimAllocationRules B
	    ON A.AllocationGroup = B.AllocationGroup
	   AND A.AllocationCode = B.AllocationCode
	   AND A.StepCode = B.StepCode	   	
	   AND A.AccountDest = B.AccountDest
	   AND A.TrifocusDest = B.TrifocusDest
	   AND A.EntityDest	= B.EntityDest
	   AND A.LocationDest = B.LocationDest
	   AND A.ProjectDest = B.ProjectDest
	   AND A.YOADest = B.YOADest
	   AND A.ProcessDest = B.ProcessDest
	   AND A.TargetPeriodDest = B.TargetPeriodDest
	   AND A.TargetEntityDest = B.TargetEntityDest
	 WHERE A.RowHash != B.RowHash
	   AND A.AllocationRulesStageId NOT IN (SELECT AllocationRulesStageId FROM #AllocationRulesTemp)
	   AND B.PK_AllocationRules NOT IN (SELECT PK_AllocationRules FROM #AllocationRulesTemp)
	 ORDER BY B.PK_AllocationRules


	--SELECT * FROM #AllocationRulesTemp WHERE AllocationRulesStageId IN (5,6,140)
	--SELECT * FROM #AllocationRulesTemp WHERE PK_AllocationRules IN (2427028,2427029,2427155)

	
	/******************************************************************************
	Find and log the allocation rules which are need to delete from dim allocations 
	*******************************************************************************/
	INSERT INTO #AllocationRulesTemp(AllocationRulesStageId,PK_AllocationRules,AllocationGroup,AllocationUser,AllocationCode,StepCode,GranularityFlag
				, AccountDest,TrifocusDest,EntityDest,LocationDest,ProjectDest,YOADest,ProcessDest,TargetPeriodDest,TargetEntityDest,TargetCurrencyDest
				, AccountFrom,AccountTo,TrifocusFrom,TrifocusTo,EntityFrom,EntityTo,LocationFrom,LocationTo,ProjectFrom,ProjectTo
				, YOAFrom,YOATo,ProcessFrom,ProcessTo,TargetEntityFrom,TargetEntityTo
				, AllocationGroupCodeVersion,AllocationGroupCodeSubVersion
				, AllocationPercent,ChangeType)
	SELECT 0 AS AllocationRulesStageId,B.PK_AllocationRules,B.AllocationGroup,B.AllocationUser,B.AllocationCode,B.StepCode,B.GranularityFlag
		 , B.AccountDest,B.TrifocusDest,B.EntityDest,B.LocationDest,B.ProjectDest,B.YOADest,B.ProcessDest,B.TargetPeriodDest,B.TargetEntityDest,B.TargetCurrencyDest
		 , B.AccountFrom,B.AccountTo,B.TrifocusFrom,B.TrifocusTo,B.EntityFrom,B.EntityTo,B.LocationFrom,B.LocationTo,B.ProjectFrom,B.ProjectTo
		 , B.YOAFrom,B.YOATo,B.ProcessFrom,B.ProcessTo,B.TargetEntityFrom,B.TargetEntityTo
		 , B.AllocationGroupCodeVersion,B.AllocationGroupCodeSubVersion
		 , B.AllocationPercent
		 , ChangeType = 'Deleted'	  
	  FROM #AllocationRules_Staging A
	 RIGHT JOIN #DimAllocationRules B
	    ON A.AllocationGroup = B.AllocationGroup
	   AND A.AllocationCode = B.AllocationCode
	   AND A.StepCode = B.StepCode	   
	--AND A.RowHash = B.RowHash
	 WHERE A.AllocationRulesStageId IS NULL
	 ORDER BY B.PK_AllocationRules
	
	/******************************************************************************
	Find and log the allocation rules where percentage changed 
	*******************************************************************************/
	INSERT INTO #AllocationRulesTemp(AllocationRulesStageId,PK_AllocationRules,AllocationGroup,AllocationUser,AllocationCode,StepCode,GranularityFlag
				, AccountDest,TrifocusDest,EntityDest,LocationDest,ProjectDest,YOADest,ProcessDest,TargetPeriodDest,TargetEntityDest,TargetCurrencyDest
				, AccountFrom,AccountTo,TrifocusFrom,TrifocusTo,EntityFrom,EntityTo,LocationFrom,LocationTo,ProjectFrom,ProjectTo
				, YOAFrom,YOATo,ProcessFrom,ProcessTo,TargetEntityFrom,TargetEntityTo
				, AllocationGroupCodeVersion,AllocationGroupCodeSubVersion
				, AllocationPercent,ChangeType)
	SELECT A.AllocationRulesStageId,B.PK_AllocationRules,A.AllocationGroup,A.AllocationUser,A.AllocationCode,A.StepCode,A.GranularityFlag
		 , A.AccountDest,A.TrifocusDest,A.EntityDest,A.LocationDest,A.ProjectDest,A.YOADest,A.ProcessDest,A.TargetPeriodDest,A.TargetEntityDest,A.TargetCurrencyDest
		 , A.AccountFrom,A.AccountTo,A.TrifocusFrom,A.TrifocusTo,A.EntityFrom,A.EntityTo,A.LocationFrom,A.LocationTo,A.ProjectFrom,A.ProjectTo
		 , A.YOAFrom,A.YOATo,A.ProcessFrom,A.ProcessTo,A.TargetEntityFrom,A.TargetEntityTo
		 , B.AllocationGroupCodeVersion,B.AllocationGroupCodeSubVersion
		 , A.AllocationPercent
		 , ChangeType = 'Percentage change'
		 --, B.TrifocusTo
	  FROM #AllocationRules_Staging A
	 INNER JOIN #DimAllocationRules B
	    ON A.AllocationGroup = B.AllocationGroup
	   AND A.AllocationCode = B.AllocationCode
	   AND A.StepCode = B.StepCode	   	
	 WHERE A.RowHash = B.RowHash
	   AND A.AllocationPercent != B.AllocationPercent
	   AND A.AllocationRulesStageId NOT IN (SELECT AllocationRulesStageId FROM #AllocationRulesTemp)
	   AND B.PK_AllocationRules NOT IN (SELECT PK_AllocationRules FROM #AllocationRulesTemp)
	 ORDER BY B.PK_AllocationRules

	SELECT * FROM #AllocationRulesTemp ORDER BY ChangeType

	/**************Test script*********************/
	/*
	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC WHERE AllocationRulesStageId IN (5,9,10)
	SELECT * FROM dbo.DimAllocationRules_POC WHERE PK_AllocationRules IN ( 2427032,2427033,2427028)

	/************Test script tp update existing data in dim table**************************/
	UPDATE dbo.DimAllocationRules_POC
	   SET TrifocusTo = 'Test1'--'Test1' --FRZZZZZZ
	 WHERE PK_AllocationRules = 2427028

	 UPDATE dbo.DimAllocationRules_POC
	   SET AccountFrom = '10110'--'10110' --10100
	 WHERE PK_AllocationRules = 2427029

	 UPDATE dbo.DimAllocationRules_POC
	   SET EntityFrom = 'USBICI_1'--'USBICI_1' --USBICI
	 WHERE PK_AllocationRules = 2427155

	 /**************script to rollback changes*************************/
	 UPDATE dbo.DimAllocationRules_POC
	   SET TrifocusTo = 'FRZZZZZZ'--'Test1' --FRZZZZZZ
	 WHERE PK_AllocationRules = 2427028

	 UPDATE dbo.DimAllocationRules_POC
	   SET AccountFrom = '10100'--'10110' --10100
	 WHERE PK_AllocationRules = 2427029

	 UPDATE dbo.DimAllocationRules_POC
	   SET EntityFrom = 'USBICI'--'USBICI_1' --USBICI
	 WHERE PK_AllocationRules = 2427155
	*/