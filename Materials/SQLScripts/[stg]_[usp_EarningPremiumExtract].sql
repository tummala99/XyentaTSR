USE [TechnicalHubDB]
GO
/****** Object:  StoredProcedure [stg].[usp_EarningPremiumExtract]    Script Date: 30-01-2020 19:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*=======================================================================================================
Does:	Extracts newly loaded Premium data in preparation of earning percentage generation and 
		application
Caller:	FactEarnings.dtsx
=======================================================================================================*/
ALTER   PROCEDURE [stg].[usp_EarningPremiumExtract]
AS
BEGIN
	SET NOCOUNT ON
	
	/*=======================================================================================================
	Initialisation & metadata
	=======================================================================================================*/
	SELECT	PK_AccountingPeriod, 
			DATEFROMPARTS(ap.AccountingYear, ap.AccountingMonth, 1) AS AccountingPeriodDate
	INTO	#AccountingPeriod
	FROM	dim.AccountingPeriod ap
	WHERE	ap.AccountingMonth BETWEEN 1 AND 12

	RAISERROR('#AccountingPeriod: %i', 0, 0, @@rowcount) WITH NOWAIT;

	CREATE UNIQUE CLUSTERED INDEX ix_#AccountingPeriod ON #AccountingPeriod (PK_AccountingPeriod)

	/*=======================================================================================================
	Selection
	=======================================================================================================*/
	BEGIN TRY

		INSERT	stg.EarningBatchFilter(PK_FTH, RowHash, FK_Policy, FK_earningPAttern)
		SELECT	tr.PK_FTH
				,tr.Rowhash
				,tr.FK_Policy
				,FK_earningPAttern = 'L' 
		FROM	fct.TechnicalResult tr
		JOIN	dim.Policy p			ON p.PK_Policy = tr.FK_Policy
		JOIN	dim.Entity	e			ON e.PK_Entity = tr.FK_Entity
		WHERE	tr.fk_Batch > (SELECT ISNULL(MAX(tr.fk_Batch), 0) FROM fct.TechnicalResult tr WHERE tr.FK_Process = 'IE')
				AND tr.FK_Account = 'P-GP-P'
				AND p.InceptionDate <= p.ExpiryDate
				AND	YEAR(p.InceptionDate) <= p.PolicyYOA + 2
				AND tr.FK_YOA >= 2015;
		
		RAISERROR('stg.EarningBatchFilter: %i', 0, 0, @@rowcount) WITH NOWAIT;

		IF NOT EXISTS (SELECT * FROM stg.EarningBatchFilter WHERE FK_earningPAttern = 'L')
			RETURN

		--US & EB Premium, linear earned so all "length" fields are set to Zone A
		INSERT		stg.EarningPercentage(fk_policy, InceptionDate, ExpiryDate, YOA, pk_Period, PolicyLength, PolicyAge, ClosingPeriod, ZoneALength, ZoneBLength, ZoneABLength, ZoneABCLength, FK_earningPAttern)
		SELECT		bf.FK_Policy
		,			p.InceptionDate
		,			p.ExpiryDate
		,			YOA					= p.PolicyYOA
		,			pk_Period			= ap.PK_AccountingPeriod
		,			PolicyLength		= DATEDIFF(D, p.InceptionDate, p.ExpiryDate) + IIF(p.IsUSPolicy = 1, 0, 1)
		,			PolicyAge			= DATEDIFF(D, p.InceptionDate, EOMONTH(ap.AccountingPeriodDate)) + IIF(p.IsUSPolicy = 1, 0, 1)
		,			ClosingPeriod		= CAST((p.PolicyYOA + 2) * 100 + 12 AS NVARCHAR)
		,			ZoneALength			= DATEDIFF(D, p.InceptionDate, p.ExpiryDate) + IIF(p.IsUSPolicy = 1, 0, 1)
		,			ZoneBLength			= 0
		,			ZoneABLength		= DATEDIFF(D, p.InceptionDate, p.ExpiryDate) + IIF(p.IsUSPolicy = 1, 0, 1)
		,			ZoneABCLength		= DATEDIFF(D, p.InceptionDate, p.ExpiryDate) + IIF(p.IsUSPolicy = 1, 0, 1)
		,			bf.FK_earningPAttern
		FROM		(SELECT	DISTINCT fk_Policy ,FK_earningPAttern FROM	stg.EarningBatchFilter WHERE FK_earningPAttern = 'L') bf			
		JOIN		dim.Policy			p	ON	p.PK_Policy = bf.FK_Policy
		JOIN		#AccountingPeriod	ap	ON	(
														ap.AccountingPeriodDate <= p.MaxEarningDate
														AND	ap.AccountingPeriodDate BETWEEN p.InceptionDate AND p.ExpiryDate
												)
											OR	(
													p.InceptionDate > p.MaxEarningDate 
													AND ap.AccountingPeriodDate = p.MaxEarningDate
													AND	DATEDIFF(YY, p.InceptionDate, p.ExpiryDate) <= 15
												)
		UNION
		SELECT		bf.FK_Policy
		,			p.InceptionDate
		,			p.ExpiryDate
		,			YOA					= p.PolicyYOA
		,			pk_Period			= ap.PK_AccountingPeriod
		,			PolicyLength		= DATEDIFF(D, p.InceptionDate, p.ExpiryDate) + IIF(p.IsUSPolicy = 1, 0, 1)
		,			PolicyAge			= DATEDIFF(D, p.InceptionDate, EOMONTH(ap.AccountingPeriodDate)) + IIF(p.IsUSPolicy = 1, 0, 1)
		,			ClosingPeriod		= CAST((p.PolicyYOA + 2) * 100 + 12 AS NVARCHAR)
		,			ZoneALength			= DATEDIFF(D, p.InceptionDate, p.ExpiryDate) + IIF(p.IsUSPolicy = 1, 0, 1)
		,			ZoneBLength			= 0
		,			ZoneABLength		= DATEDIFF(D, p.InceptionDate, p.ExpiryDate) + IIF(p.IsUSPolicy = 1, 0, 1)
		,			ZoneABCLength		= DATEDIFF(D, p.InceptionDate, p.ExpiryDate) + IIF(p.IsUSPolicy = 1, 0, 1)
		,			bf.FK_earningPAttern
		FROM		(SELECT	DISTINCT fk_Policy ,FK_earningPAttern FROM	stg.EarningBatchFilter WHERE FK_earningPAttern = 'L') bf			
		JOIN		dim.Policy			p	ON	p.PK_Policy = bf.FK_Policy
		JOIN		#AccountingPeriod	ap	ON	(
														ap.AccountingPeriodDate <= p.MaxEarningDate
														AND ap.AccountingPeriodDate NOT BETWEEN p.InceptionDate AND p.ExpiryDate  
														AND datediff(M,InceptionDate,ExpiryDate)  = 0  and p.InceptionDate <> ap.AccountingPeriodDate 
														AND SUBSTRING(convert(varchar(10),P.InceptionDate,112),1,6)  = PK_AccountingPeriod
												 
												)
											OR	(
													p.InceptionDate > p.MaxEarningDate 
													AND ap.AccountingPeriodDate = p.MaxEarningDate
													AND	DATEDIFF(YY, p.InceptionDate, p.ExpiryDate) <= 15
												)

		RAISERROR('stg.EarningPercentage: %i', 0, 0, @@rowcount) WITH NOWAIT;

	END TRY
	BEGIN CATCH
		--Call to logging framework needed here
		THROW;
	END CATCH
END