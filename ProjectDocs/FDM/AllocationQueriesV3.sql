	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC -- 144
	SELECT 144 - 136

	SELECT AllocationGroup
		,AllocationUser
		,AllocationCode
		,StepCode

		,AccountDest
		,TrifocusDest
		--,EntityDest
		--,LocationDest
		--,ProjectDest
		--,YOADest
		--,ProcessDest		
		--,TargetPeriodDest
		--,TargetEntityDest

		,AccountFrom
		,AccountTo
		,TrifocusFrom
		,TrifocusTo
		,EntityFrom
		,EntityTo
		,LocationFrom
		,LocationTo
		,ProjectFrom
		,ProjectTo
		,YOAFrom
		,YOATo
		,ProcessFrom
		,ProcessTo
		,TargetEntityFrom
		,TargetEntityTo
		 ,SUM(CONVERT(DECIMAL(19,4),AllocationPercent)) AS AllocationPercent
	  FROM staging_agresso.dbo.AllocationRulesStage_POC
	 GROUP BY
		AllocationGroup
		,AllocationUser
		,AllocationCode
		,StepCode
		,GranularityFlag
		,AccountDest
		,TrifocusDest
		--,EntityDest
		--,LocationDest
		--,ProjectDest
		--,YOADest
		--,ProcessDest
		--,TargetPeriodDest
		--,TargetEntityDest
		--TargetCurrencyDest

		,AccountFrom
		,AccountTo
		,TrifocusFrom
		,TrifocusTo
		,EntityFrom
		,EntityTo
		,LocationFrom
		,LocationTo
		,ProjectFrom
		,ProjectTo
		,YOAFrom
		,YOATo
		,ProcessFrom
		,ProcessTo
		,TargetEntityFrom
		,TargetEntityTo -- 44

		DECLARE @AllocationGroup VARCHAR(255),@AllocationCode VARCHAR(255)
		SET @AllocationGroup = 'US Premium'
		SET @AllocationCode = 'USPREM'

		 SELECT A.*,'New' AS ChangeType 
			FROM staging_agresso.dbo.AllocationRulesStage_POC A
		    LEFT JOIN dbo.DimAllocationRules_POC B
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
			 AND B.IsCurrent = 1
		   WHERE B.PK_AllocationRules IS NULL
		     AND A.AllocationGroup = @AllocationGroup
			 AND A.AllocationCode = @AllocationCode 
		
		SELECT A.*,'Allocation Percent change' AS ChangeType 
			FROM staging_agresso.dbo.AllocationRulesStage_POC A
		   INNER JOIN dbo.DimAllocationRules_POC B
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
		   WHERE A.AllocationPercent != B.AllocationPercent
		     AND B.IsCurrent = 1

		SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC ORDER BY AccountFrom
		SELECT * FROM dbo.DimAllocationRules_POC WHERE AllocationGroup = 'US Premium' AND AllocationCode ='USPREM' AND IsCurrent = 1 ORDER BY AccountFrom
		


		SELECT A.*,'DELETE' AS ChangeType 
			FROM staging_agresso.dbo.AllocationRulesStage_POC A
		   RIGHT JOIN dbo.DimAllocationRules_POC B
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
			 
		   WHERE A.AllocationRulesStageId IS NULL
		     AND B.IsCurrent = 1
			 AND B.AllocationGroup = 'US Premium'

		DECLARE @AllocationGroup VARCHAR(255),@AllocationCode VARCHAR(255)
		SET @AllocationGroup = 'US Premium'
		SET @AllocationCode = 'USPREM'
			
	SELECT * 
	 FROM 				
		(SELECT MAX(AllocationRulesStageId) AS AllocationRulesStageId
		,AllocationGroup
		,AllocationUser
		,AllocationCode
		,StepCode
		--,EntityDest
		, SUM(AllocationPercent) AS AllocationPercent
		  ,RowHash = HASHBYTES('SHA2_512',CONCAT(AccountFrom, 
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
	   FROM staging_agresso.dbo.AllocationRulesStage_POC 
	   WHERE AllocationGroup = @AllocationGroup
	     AND AllocationCode = @AllocationCode
	   GROUP BY
		AllocationGroup
		,AllocationUser
		,AllocationCode
		,StepCode
		,GranularityFlag
		,AccountDest
		,TrifocusDest
		,EntityDest
		,LocationDest
		,ProjectDest
		,YOADest
		,ProcessDest
		,TargetPeriodDest
		,TargetEntityDest
		,TargetCurrencyDest

		,AccountFrom
		,AccountTo
		,TrifocusFrom
		,TrifocusTo
		,EntityFrom
		,EntityTo
		,LocationFrom
		,LocationTo
		,ProjectFrom
		,ProjectTo
		,YOAFrom
		,YOATo
		,ProcessFrom
		,ProcessTo
		,TargetEntityFrom
		,TargetEntityTo) AS Stag

	FULL JOIN 
	
	(SELECT MAX(PK_AllocationRules) AS PK_AllocationRules
		,AllocationGroup
		,AllocationUser
		,AllocationCode
		,StepCode
		--,EntityDest
		, SUM(AllocationPercent) AS AllocationPercent
		  ,RowHash = HASHBYTES('SHA2_512',CONCAT(AccountFrom, 
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
	   FROM dbo.DimAllocationRules_POC
	   WHERE AllocationGroup = @AllocationGroup
	     AND AllocationCode = @AllocationCode 
	     AND IsCurrent = 1
	   GROUP BY
			AllocationGroup
			,AllocationUser
			,AllocationCode
			,StepCode
			,GranularityFlag
			,AccountDest
			,TrifocusDest
			,EntityDest
			,LocationDest
			,ProjectDest
			,YOADest
			,ProcessDest
			,TargetPeriodDest
			,TargetEntityDest
			,TargetCurrencyDest

			,AccountFrom
			,AccountTo
			,TrifocusFrom
			,TrifocusTo
			,EntityFrom
			,EntityTo
			,LocationFrom
			,LocationTo
			,ProjectFrom
			,ProjectTo
			,YOAFrom
			,YOATo
			,ProcessFrom
			,ProcessTo
			,TargetEntityFrom
			,TargetEntityTo) AS dim

		--ON Stag.RowHash != dim.RowHash
		--WHERE Stag.AllocationGroup = dim.AllocationGroup
		--AND Stag.AllocationCode = dim.AllocationCode
		--AND Stag.StepCode = dim.StepCode 

		 ON Stag.RowHash = dim.RowHash
		AND Stag.AllocationGroup = dim.AllocationGroup
		AND Stag.AllocationCode = dim.AllocationCode
		AND Stag.StepCode = dim.StepCode 	   
	  --WHERE Stag.RowHash = dim.RowHash
	  ORDER BY Stag.AllocationRulesStageId


	
		SELECT * FROM dbo.DimAllocationRules_POC
	   WHERE AllocationGroup = 'US Premium' AND AllocationCode ='USPREM' AND IsCurrent = 1
		

	/*

			DECLARE @AllocationGroup VARCHAR(255),@AllocationCode VARCHAR(255)
		SET @AllocationGroup = 'US Premium'
		SET @AllocationCode = 'USPREM'

	SELECT DISTINCT *
			 --, B.AllocationGroup,B.AllocationCode,B.AllocationGroupCodeVersion 
			 --,'Allocation Meta Data change' AS ChangeType 
		  FROM staging_agresso.dbo.AllocationRulesStage_POC A
		 INNER JOIN dbo.DimAllocationRules_POC B
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

		  AND A.GranularityFlag = B.GranularityFlag
		  AND A.BatchID = B.BatchID
		  AND A.TargetCurrencyDest = B.TargetCurrencyDest
		  			 
		WHERE B.IsCurrent = 1
		  AND B.AllocationGroup = @AllocationGroup
		  AND B.AllocationCode = @AllocationCode
		   AND (A.AccountFrom	!= B.AccountFrom
				OR A.AccountTo	!= B.AccountTo
				OR A.TrifocusFrom	!= B.TrifocusFrom
				OR A.TrifocusTo	!= B.TrifocusTo
				OR A.EntityFrom	!= B.EntityFrom
				OR A.EntityTo	!= B.EntityTo
				OR A.LocationFrom	!= B.LocationFrom
				OR A.LocationTo	!= B.LocationTo		 
				OR A.ProjectFrom	!= B.ProjectFrom
				OR A.ProjectTo	!= B.ProjectTo
				OR A.YOAFrom	!= B.YOAFrom
				OR A.YOATo	!= B.YOATo
				OR A.ProcessFrom	!= B.ProcessFrom
				OR A.ProcessTo	!= B.ProcessTo	
				OR A.TargetEntityFrom != B.TargetEntityFrom
				OR A.TargetEntityTo  != B.TargetEntityTo					
			)
		ORDER BY A.AllocationRulesStageId


	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC WHERE AllocationRulesStageId IN (5,9,10)
	--SELECT * FROM dbo.DimAllocationRules_POC WHERE PK_AllocationRules IN ( 2427032,2427033,2427028)
	SELECT * FROM dbo.DimAllocationRules_POC WHERE PK_AllocationRules IN ( 2427028,2427029,	2427155)

	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC WHERE AllocationRulesStageId IN (5)
	SELECT * FROM dbo.DimAllocationRules_POC WHERE PK_AllocationRules IN ( 2427032,2427033,2427028)
	
	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC WHERE AllocationRulesStageId IN (5,9,10)
	--SELECT * FROM dbo.DimAllocationRules_POC WHERE PK_AllocationRules IN ( 2427032,2427033,2427028)
	UPDATE dbo.DimAllocationRules_POC
	   SET TrifocusTo = 'Test1'--'Test1' --FRZZZZZZ
	 WHERE PK_AllocationRules = 2427028

	 UPDATE dbo.DimAllocationRules_POC
	   SET AccountFrom = '10110'--'10110' --10100
	 WHERE PK_AllocationRules = 2427029

	 UPDATE dbo.DimAllocationRules_POC
	   SET EntityFrom = 'USBICI_1'--'USBICI_1' --USBICI
	 WHERE PK_AllocationRules = 2427155

	SELECT * FROM dbo.DimAllocationRules_POC WHERE AllocationGroup = 'US Premium' AND AllocationCode = 'USPREM' and IsCurrent = 1
	2427028
	2427029
	2427155

	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC WHERE AllocationRulesStageId = 7
	SELECT * FROM dbo.DimAllocationRules_POC WHERE PK_AllocationRules IN (2427036,2427037,2427050,2427056,2427057)







	*/

	