	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC -- 144

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

		

		SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC ORDER BY AccountFrom
		SELECT * FROM dbo.DimAllocationRules_POC WHERE AllocationGroup = 'US Premium' AND AllocationCode ='USPREM' AND IsCurrent = 1 ORDER BY AccountFrom

		


	SELECT AllocationGroup,AllocationCode,AllocationGroupCodeVersion,IsCurrent,COUNT(1) FROM dbo.DimAllocationRules_POC WHERE AllocationGroup = 'US Premium'
	 GROUP BY AllocationGroup,AllocationCode,AllocationGroupCodeVersion,IsCurrent

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

	SELECT * 
	 FROM 				
		(SELECT AllocationGroup
		,AllocationUser
		,AllocationCode
		,StepCode
		--,EntityDest
		--, SUM(AllocationPercent)
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
									'§~§'))
	   FROM staging_agresso.dbo.AllocationRulesStage_POC 
	   GROUP BY
		AllocationGroup
		,AllocationUser
		,AllocationCode
		,StepCode
		--,EntityDest
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
	
	(SELECT AllocationGroup
		,AllocationUser
		,AllocationCode
		,StepCode
		,EntityDest
		--, SUM(AllocationPercent)
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
									'§~§'))
	   FROM dbo.DimAllocationRules_POC
	   WHERE AllocationGroup = 'US Premium' AND AllocationCode ='USPREM' AND IsCurrent = 1
	   GROUP BY
		AllocationGroup
		,AllocationUser
		,AllocationCode
		,StepCode
		,EntityDest
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

		ON Stag.AllocationGroup = dim.AllocationGroup
	   
	   WHERE Stag.RowHash != dim.RowHash
	     AND Stag.AllocationCode = dim.AllocationCode
		 AND Stag.StepCode = dim.StepCode
		 --AND Stag.EntityDest = dim.EntityDest


	
		SELECT * FROM dbo.DimAllocationRules_POC
	   WHERE AllocationGroup = 'US Premium' AND AllocationCode ='USPREM' AND IsCurrent = 1
		

	/*

		SELECT DISTINCT *
			 --, B.AllocationGroup,B.AllocationCode,B.AllocationGroupCodeVersion 
			 --,'Allocation Meta Data change' AS ChangeType 
		  FROM staging_agresso.dbo.AllocationRulesStage_POC A
		 INNER JOIN dbo.DimAllocationRules_POC B
			ON A.AllocationGroup = B.AllocationGroup
		   AND A.AllocationCode = B.AllocationCode
		   AND A.StepCode = B.StepCode
		   AND A.EntityDest	= B.EntityDest
		   AND A.AccountDest = B.AccountDest
		   AND A.TrifocusDest = B.TrifocusDest
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
				--OR A.AccountDest	!= B.AccountDest
				--OR A.TrifocusDest	!= B.TrifocusDest
				--OR A.EntityDest	!= B.EntityDest				
			)			 
		WHERE B.IsCurrent = 1
		ORDER BY A.AllocationRulesStageId

	*/
0x69C53ECC7C24440772DF43F6551BF1B9CAAACCF5B09364CEB1418CDC1BFC5E114632F8529B9F7E9383899304AFAECDA340A4F8F9BA3C72C89301A96A2DB66660
	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC WHERE AllocationRulesStageId = 5
	SELECT * FROM dbo.DimAllocationRules_POC WHERE PK_AllocationRules = 2427032

	SELECT * FROM staging_agresso.dbo.AllocationRulesStage_POC WHERE AllocationRulesStageId = 7
	SELECT * FROM dbo.DimAllocationRules_POC WHERE PK_AllocationRules IN (2427036,2427037,2427050,2427056,2427057)