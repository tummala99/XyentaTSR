USE [TechnicalHubDB]
GO
/****** Object:  StoredProcedure [stg].[usp_EarningAdjustBinderExtract]    Script Date: 30-01-2020 19:41:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*=======================================================================================================
Does:	Extracts newly loaded EB binder data in preparation of earning percentage generation and 
		application
Caller:	FactEarnings.dtsx
=======================================================================================================*/
ALTER   PROCEDURE [stg].[usp_EarningAdjustBinderExtract]
AS
BEGIN
	SET NOCOUNT ON
	
	/*=======================================================================================================
	Selection
	=======================================================================================================*/
	BEGIN TRY
		INSERT	stg.EarningBatchFilter(PK_FTH, RowHash, FK_Policy, FK_earningPAttern)
		SELECT	tr.PK_FTH
				,tr.Rowhash
				,tr.FK_Policy
				,FK_earningPAttern = 'TA' 
		FROM	fct.TechnicalResult tr
		JOIN	dim.Policy p			ON p.PK_Policy = tr.FK_Policy
		JOIN	dim.Entity	e			ON e.PK_Entity = tr.FK_Entity
		WHERE	tr.fk_Batch > (SELECT ISNULL(MAX(tr.fk_Batch), 0) FROM fct.TechnicalResult tr WHERE tr.FK_Process = 'IA')
				AND tr.FK_Account = 'P-GP-B'
				AND e.Platform = 'Synd'
				AND p.InceptionDate <= p.ExpiryDate
				AND	YEAR(p.InceptionDate) <= p.PolicyYOA + 1
				AND	DATEDIFF(YY, p.InceptionDate, p.ExpiryDate) <= 15
				AND tr.FK_YOA >= 2015;
		
		RAISERROR('stg.EarningBatchFilter: %i', 0, 0, @@rowcount) WITH NOWAIT;

		IF NOT EXISTS (SELECT * FROM stg.EarningBatchFilter WHERE FK_earningPAttern = 'T')
			RETURN


	END TRY
	BEGIN CATCH
		--Call to logging framework needed here
		THROW;
	END CATCH
END