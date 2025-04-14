DECLARE @FDM_CUBE_ServerName					NVARCHAR(2000) = '$(Param_Target_FDMInstance)' --SSAS FDM
DECLARE @FDM_PROCESS_ServerName					NVARCHAR(2000) = '$(Param_Target_FDMInstance)'
DECLARE @FDMServer								NVARCHAR(2000) = '$(Param_Target_FDMInstance)'
DECLARE @Staging_agressoServer					NVARCHAR(2000) = '$(Param_Target_FDMInstance)'
Declare @TDM_CUBE_ServerName					NVARCHAR(2000) = '$(Param_Target_FDMInstance)' --SSAS TDM New

Declare @TDM_CUBE_Name							NVARCHAR(2000) = 'TDM'					--TDM New

DECLARE @ClaimStageIn_ServerName                NVARCHAR(2000) = '$(Param_AgressoInstance)'		--Agresso FDM
DECLARE @AgressoUATServer_ServerName            NVARCHAR(2000) = '$(Param_AgressoInstance)'		--Agresso FDM
DECLARE @AgressoServer_ServerName               NVARCHAR(2000) = '$(Param_AgressoInstance)'		--Agresso FDM
DECLARE @RestoredAgresso_ServerName				NVARCHAR(2000) = '$(Param_AgressoInstance)'		--Agresso FDM

DECLARE @BeazleyIntelligenceODS_ServerName      NVARCHAR(2000) = '$(Param_BeazleyIntelligenceODS)' 
DECLARE @PremiumForecastSQL_ServerName          NVARCHAR(2000) = '$(Param_PremiumForecastSQL)'
DECLARE @PremiumForecastAccess_FileName         NVARCHAR(2000) = '$(Param_PremiumForecastAccessFileName)'

DECLARE @Var_XMLAWrapperForDim					NVARCHAR(4000) ='<Batch xmlns="http://schemas.microsoft.com/analysisservices/2003/engine">   <Parallel>   
																<Process xmlns="http://schemas.microsoft.com/analysisservices/2003/engine">     <Object>      <DatabaseID>##DatabaseID##</DatabaseID>     
																<DimensionID>##DimensionID##</DimensionID>     </Object>     <Type>ProcessAdd</Type>    
																<DataSourceView xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
																xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" 
																xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" 
																xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300"
																xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400"
																xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:dwd="http://schemas.microsoft.com/DataWarehouse/Designer/1.0" 
																dwd:design-time-name="d1d2d3cc-ba27-4122-8c35-c9e10753844b" xmlns="http://schemas.microsoft.com/analysisservices/2003/engine">        
																<ID>FDM DB</ID>        <Name>FDM DB</Name>    <DataSourceID>FDM DB</DataSourceID>    <Schema>    
																<xs:schema id="FDM_x0020_DB" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata"
																xmlns:msprop="urn:schemas-microsoft-com:xml-msprop">     </xs:schema>    </Schema>   </DataSourceView>    </Process>   </Parallel>  </Batch>'
		--'$(Param_XMLAWrapperForDim)'
DECLARE @Var_XMLAWrapperForMeasure				NVARCHAR(4000) = '<Batch xmlns="http://schemas.microsoft.com/analysisservices/2003/engine">   <Parallel>    
																	<Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
																	xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" 
																	xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200"
																	xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" 
																	xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300">       <Object>         <DatabaseID>##DatabaseID##</DatabaseID>  
																	<CubeID>FinanceDataMart</CubeID>  <MeasureGroupID>##MeasureGroupID##</MeasureGroupID>  <PartitionID>##PartitionID##</PartitionID>       </Object>     
																	<Type>ProcessAdd</Type>       <WriteBackTableCreation>UseExisting</WriteBackTableCreation>     </Process>   </Parallel>  <Bindings>   <Binding>    
																	<DatabaseID>##DatabaseID##</DatabaseID>    <CubeID>FinanceDataMart</CubeID>    <MeasureGroupID>##MeasureGroupID##</MeasureGroupID>    
																	<PartitionID>##PartitionID##</PartitionID>    <Source xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
																	xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" 
																	xsi:type="QueryBinding">     <DataSourceID>FDM DB</DataSourceID>     <QueryDefinition>      ##QueryDefinition##     </QueryDefinition>    </Source>  
																	</Binding>  </Bindings> </Batch>'
																			   --'$(Param_XMLAWrapperForMeasure)'

DECLARE @URL_SharepointServer					NVARCHAR(2000) = '$(Param_SharepointServer)'
DECLARE @URL_Sharepoint01_UserName				NVARCHAR(2000) = '$(Param_Sharepoint01_UserName)'
DECLARE @URL_Sharepoint01_Password				NVARCHAR(2000) = '$(Param_Sharepoint01_Password)'

DECLARE @Var_IncrementalProcess                 BIT =				1							---'$(Param_IncrementalProcess)'
DECLARE @Var_FDM_CUBE_Name						NVARCHAR(2000) ='FDM_Cube'			--'$(Param_FDM_CUBE_Name)' 
DECLARE @ExternalFeedLocation					NVARCHAR(2000) = '$(Param_ExternalFeedLocation)'
DECLARE @CAWPath_Var							NVARCHAR(2000) = '$(Param_CAWPath)'
DECLARE @DrakeServer         NVARCHAR(2000) = '$(Param_DrakeServer)' --new


/*===========================================================================================================================================
	Delete unwanted references 
	1.if the project referenced to multiple environments(different names of environments/unexpected environment)
	and 
	2.delete references if it is existing from two same name projects,two same name environments but from different catalog folders
============================================================================================================================================*/

DECLARE @ReferenceID INT =0

WHILE EXISTS	(SELECT	ER.* FROM	ssisdb.catalog.environment_references ER
							JOIN ssisdb.catalog.Projects p on ER.Project_id=p.project_id
							WHERE P.name='FDM_SSIS' AND (er.environment_name<>'FDM_SSIS' OR (er.environment_folder_name IS NOT NULL AND									                                                                    er.environment_folder_name<>'FDM') ) 
													AND ER.reference_id > @ReferenceID
				)
BEGIN
	SELECT	@ReferenceID=MIN(reference_id) 
	FROM	ssisdb.catalog.environment_references ER
	JOIN ssisdb.catalog.Projects p on ER.Project_id=p.project_id
	WHERE P.name='FDM_SSIS' AND (er.environment_name<>'FDM_SSIS' OR (er.environment_folder_name IS NOT NULL AND																															 er.environment_folder_name<>'FDM') ) 
							AND ER.reference_id > @ReferenceID
	
	EXEC SSISDB.catalog.delete_environment_reference @ReferenceID
END

/*===================================================================================================================
	Create/Map the reference(Environment) to the SSIS Project of expecting folder if not exists
====================================================================================================================*/


IF NOT EXISTS	(SELECT	reference_id 
					FROM	ssisdb.catalog.environment_references r 
					JOIN	SSISDB.Catalog.Projects P				ON p.project_id=r.project_id
					WHERE	r.environment_name ='FDM_SSIS' 
							AND P.name='FDM_SSIS'
				)
BEGIN
	EXEC [SSISDB].[catalog].[create_environment_reference] @folder_name = N'FDM', @project_name = N'FDM_SSIS', @environment_name = N'FDM_SSIS', @Reference_type = 'R', @reference_id = @ReferenceID OUTPUT
END


/*=============================================================================================================================
		Delete and re-create Environment variables if not exists for expecting EnvIronment NAME, Env variable, Env Value
===============================================================================================================================*/

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='FDM_CUBE_ServerName' AND CAST(EV.value AS NVARCHAR(500))=@FDM_CUBE_ServerName 
				) ---It will create new environment variable if the existing env value not match with expecting env value
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='FDM_CUBE_ServerName')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'FDM_CUBE_ServerName'	--Delete the EnvVariable if it doesn't consist expected env variable value
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'FDM_CUBE_ServerName',@value=@FDM_CUBE_ServerName,			@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id 
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='FDM_PROCESS_ServerName' AND CAST(EV.value AS NVARCHAR(500))=@FDM_PROCESS_ServerName
				)
BEGIN
	IF EXISTS(SELECT	variable_id
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id 
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='FDM_PROCESS_ServerName')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'FDM_PROCESS_ServerName'
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'FDM_PROCESS_ServerName',	@value=@FDM_PROCESS_ServerName,	@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='FDMServer' AND CAST(EV.value AS NVARCHAR(500))=@FDMServer
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='FDMServer')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'FDMServer'
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'FDMServer',		
		@value=@FDMServer,		@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='Staging_agressoServer' AND CAST(EV.value AS NVARCHAR(500))=@Staging_agressoServer
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='Staging_agressoServer')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'Staging_agressoServer'
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'Staging_agressoServer',		@value=@Staging_agressoServer,		@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='ClaimStageIn_ServerName' AND CAST(EV.value AS NVARCHAR(500))=@ClaimStageIn_ServerName
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='ClaimStageIn_ServerName')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'ClaimStageIn_ServerName'
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'ClaimStageIn_ServerName',			@value= @ClaimStageIn_ServerName ,			@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='AgressoUATServer'  AND CAST(EV.value AS NVARCHAR(500))=@AgressoUATServer_ServerName
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='AgressoUATServer')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'AgressoUATServer'
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'AgressoUATServer',				@value=@AgressoUATServer_ServerName,				@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='AgressoServer' AND CAST(EV.value AS NVARCHAR(500))=@AgressoServer_ServerName
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='AgressoServer')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'AgressoServer'
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'AgressoServer',		@value=@AgressoServer_ServerName,		@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='BeazleyIntelligenceODS_ServerName' AND CAST(EV.value AS NVARCHAR(500))=@BeazleyIntelligenceODS_ServerName
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='BeazleyIntelligenceODS_ServerName')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'BeazleyIntelligenceODS_ServerName'
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'BeazleyIntelligenceODS_ServerName',				@value=@BeazleyIntelligenceODS_ServerName,				@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='RestoredAgresso_ServerName' AND CAST(EV.value AS NVARCHAR(500))=@RestoredAgresso_ServerName
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='RestoredAgresso_ServerName')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'RestoredAgresso_ServerName'
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'RestoredAgresso_ServerName',			@value=@RestoredAgresso_ServerName,			@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='PremiumForecastSQL_ServerName' AND CAST(EV.value AS NVARCHAR(500))=@PremiumForecastSQL_ServerName
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='PremiumForecastSQL_ServerName')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'PremiumForecastSQL_ServerName'
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'PremiumForecastSQL_ServerName',			@value=@PremiumForecastSQL_ServerName,			@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='PremiumForecastAccess_FileName' AND CAST(EV.value AS NVARCHAR(500))=@PremiumForecastAccess_FileName
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='PremiumForecastAccess_FileName')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'PremiumForecastAccess_FileName'
	EXEC [SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS', @variable_name=N'PremiumForecastAccess_FileName',		@value=@PremiumForecastAccess_FileName,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='XMLAWrapperForDim' AND CAST(EV.value AS NVARCHAR(4000))=@Var_XMLAWrapperForDim
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='XMLAWrapperForDim')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'XMLAWrapperForDim'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'XMLAWrapperForDim',@value=@Var_XMLAWrapperForDim
		,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='XMLAWrapperForMeasure' AND CAST(EV.value AS NVARCHAR(4000))=@Var_XMLAWrapperForMeasure
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='XMLAWrapperForMeasure')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'XMLAWrapperForMeasure'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'XMLAWrapperForMeasure',@value=@Var_XMLAWrapperForMeasure,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='SharepointServer' AND CAST(EV.value AS NVARCHAR(500))=@URL_SharepointServer
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='SharepointServer')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'SharepointServer'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'SharepointServer',@value=@URL_SharepointServer,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='Sharepoint01_UserName' AND CAST(EV.value AS NVARCHAR(500))=@URL_Sharepoint01_UserName
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='Sharepoint01_UserName')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'Sharepoint01_UserName'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'Sharepoint01_UserName',@value=@URL_Sharepoint01_UserName,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='Sharepoint01_Password' AND CAST(EV.value AS NVARCHAR(500))=@URL_Sharepoint01_Password
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='Sharepoint01_Password')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'Sharepoint01_Password'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'Sharepoint01_Password',@value=@URL_Sharepoint01_Password,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='IncrementalProcess' AND CAST(EV.value AS NVARCHAR(500))=@Var_IncrementalProcess
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='IncrementalProcess')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'IncrementalProcess'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'IncrementalProcess',@value=@Var_IncrementalProcess,@data_type=N'Boolean', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='FDM_CUBE_Name' AND CAST(EV.value AS NVARCHAR(500))=@Var_FDM_CUBE_Name
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='FDM_CUBE_Name')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'FDM_CUBE_Name'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'FDM_CUBE_Name',@value=@Var_FDM_CUBE_Name,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='ExternalFeedLocation' AND CAST(EV.value AS NVARCHAR(500))=@ExternalFeedLocation
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='ExternalFeedLocation')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'ExternalFeedLocation'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'ExternalFeedLocation',@value=@ExternalFeedLocation,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END

IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='DrakeServer' AND CAST(EV.value AS NVARCHAR(500))=@DrakeServer 
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='DrakeServer')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'DrakeServer'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'DrakeServer',@value=@DrakeServer ,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END


/*===================These are not project parameters,only connection managers in FDM_SSIS Project
=================Once they converted into Project params then these will created and map
IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='TDM_CUBE_ServerName' AND CAST(EV.value AS NVARCHAR(500))=@TDM_CUBE_ServerName
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='TDM_CUBE_ServerName')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'TDM_CUBE_ServerName'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'TDM_CUBE_ServerName',@value=@TDM_CUBE_ServerName,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END
IF NOT EXISTS (SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				JOIN	SSISDB.catalog.folders F ON E.folder_id=F.folder_id
				WHERE	F.name='FDM' AND	E.name='FDM_SSIS'	AND EV.NAME='TDM_CUBE_Name' AND CAST(EV.value AS NVARCHAR(500))=@TDM_CUBE_Name
				)
BEGIN
	IF EXISTS(SELECT	variable_id	
				FROM	SSISDB.catalog.environment_variables EV
				JOIN	SSISDB.catalog.environments E	ON E.environment_id=EV.environment_id
				WHERE	E.name='FDM_SSIS'	AND EV.NAME='TDM_CUBE_Name')
	EXEC SSISDB.catalog.delete_environment_variable @folder_name =N'FDM' , @environment_name=N'FDM_SSIS' ,@variable_name =N'TDM_CUBE_Name'
	EXEC[SSISDB].[catalog].[create_environment_variable] @environment_name=N'FDM_SSIS',@variable_name=N'TDM_CUBE_Name',@value=@TDM_CUBE_Name,@data_type=N'String', @sensitive=False, @folder_name=N'FDM'
END
=========================================================================*/



/*===========================================================================================================================
	Map the Parameter values to the required parameter name of the Project
=============================================================================================================================*/

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'FDM_CUBE_ServerName',	@parameter_value=N'FDM_CUBE_ServerName'	,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'FDM_PROCESS_ServerName',			@parameter_value=N'FDM_PROCESS_ServerName'		,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'FDMServer',				@parameter_value=N'FDMServer'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'Staging_agressoServer',					@parameter_value=N'Staging_agressoServer'					,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'ClaimStageIn_ServerName',		@parameter_value=N'ClaimStageIn_ServerName'		,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'AgressoUATServer',	@parameter_value=N'AgressoUATServer'	,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'AgressoServer',						@parameter_value=N'AgressoServer'				,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'BeazleyIntelligenceODS_ServerName',			@parameter_value=N'BeazleyIntelligenceODS_ServerName'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'RestoredAgresso_ServerName',			    @parameter_value=N'RestoredAgresso_ServerName'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'PremiumForecastSQL_ServerName',			    @parameter_value=N'PremiumForecastSQL_ServerName'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'PremiumForecastAccess_FileName',			@parameter_value=N'PremiumForecastAccess_FileName'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'XMLAWrapperForDim',			    @parameter_value=N'XMLAWrapperForDim'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'XMLAWrapperForMeasure',				@parameter_value=N'XMLAWrapperForMeasure'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'SharepointServer',					@parameter_value=N'SharepointServer'					,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'Sharepoint01_UserName',		@parameter_value=N'Sharepoint01_UserName'		,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'Sharepoint01_Password',	@parameter_value=N'Sharepoint01_Password'	,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'IncrementalProcess',						@parameter_value=N'IncrementalProcess'				,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'FDM_CUBE_Name',			@parameter_value=N'FDM_CUBE_Name'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'ExternalFeedLocation',			    @parameter_value=N'ExternalFeedLocation'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'CAWPath',			    @parameter_value=N'CAWPath'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'DrakeServer',			    @parameter_value=N'DrakeServer'			,@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R

/*=======================These variables are not as project parameters of FDM_SSIS Project===========
Created Env variables but not mapped these variables to Project variable=========================================================
EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'TDM_CUBE_ServerName',@parameter_value=N'TDM_CUBE_ServerName',@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R
EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'TDM_CUBE_Name',@parameter_value=N'TDM_CUBE_Name',@object_name=N'FDM_SSIS', @folder_name=N'FDM', @project_name=N'FDM_SSIS', @value_type=R
*/
