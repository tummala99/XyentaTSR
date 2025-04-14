	IF(OBJECT_ID('tempdb..#Modules') IS NOT NULL)
		DROP TABLE #Modules

	SELECT MH.TreeLevel
		 , M.FK_Orchestration
		 , M.ModuleName
		 , MT.ModuleType
		 , M.ModuleRoutine
		 , M.DestinationServer
		 , M.DestinationDatabase
		 , MH.FK_ChildModule
		 , MH.FK_ParentModule		  
		 --, FK_ChildModule,MH.TreeLevel 
	  INTO #Modules
	  FROM [etl].[Module] M
	 INNER JOIN [etl].[ModuleHierarchy] MH
	    ON M.PK_module = MH.FK_ChildModule
       AND M.FK_Orchestration = MH.FK_Orchestration 
	 INNER JOIN etl.ModuleType MT
	    ON MT.PK_ModuleType = M.FK_ModuleType
	 WHERE MH.FK_Orchestration = 5

	SELECT * FROM #Modules

	SELECT DISTINCt A.TreeLevel		 
		 , A.FK_Orchestration
		 , ISNULL(B.ModuleName,'NO Parent') AS ParentModule
		 , A.ModuleName
		 , A.FK_ChildModule AS ModuleId
		 , A.FK_ParentModule AS ParentModuleId
		 , A.ModuleType
		 , A.ModuleRoutine
		 , A.DestinationServer
		 , A.DestinationDatabase
		 , A.FK_ChildModule		 
	  FROM #Modules A
	  LEFT JOIN #Modules B
	    ON A.FK_ParentModule = B.FK_ChildModule 
	 ORDER BY A.TreeLevel,A.FK_Orchestration,ParentModule,A.FK_ChildModule