USE [TechnicalHubDB]
GO
/****** Object:  StoredProcedure [stg].[usp_EarningCalculatePercentages]    Script Date: 30-01-2020 19:41:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=======================================================================================================
Does:		Uses geometric area calculations to calculate earning percentages in the specified earning
			Pattern. 
Caller:		FactEarnings.dtsx
Parameters:	@FK_earningPattern(T=Trapezioidal, L=Linear)
=======================================================================================================*/
ALTER   PROCEDURE [stg].[usp_EarningCalculatePercentages]
AS
BEGIN
	BEGIN TRY
		
		/*=======================================================================================================
		Calculate earning percentages
		=======================================================================================================*/
		--Calculate cumulative zone area for each period
		UPDATE	de
		SET		
				ZoneAEarning =	IIF(PolicyAge <= de.[ZoneALength], POWER(de.PolicyAge, 2), POWER(de.[ZoneALength], 2)) / 2,
				ZoneBEarning =	CASE	WHEN de.PolicyAge <= de.[ZoneALength] THEN 0
										WHEN de.PolicyAge BETWEEN de.[ZoneALength] AND de.ZoneABLength THEN (de.PolicyAge - de.[ZoneALength]) * de.[ZoneALength]
										WHEN de.PolicyAge > ZoneABLength THEN de.ZoneBLength * de.[ZoneALength]
								END,
				ZoneCEarning = IIF(PolicyAge <= ZoneABLength, 0, (POWER([ZoneALength], 2) - POWER(de.ZoneABCLength - de.PolicyAge, 2))/2)
		FROM	stg.EarningPercentage de
		WHERE	de.FK_earningPAttern = 'T' -- 1161004;

		RAISERROR('binder: %i', 0, 0, @@rowcount) WITH NOWAIT;

		UPDATE	de
		SET		ZoneAEarning =	IIF(PolicyAge <= de.[ZoneALength], de.PolicyAge/de.[ZoneALength], 1)
		FROM	stg.EarningPercentage de
		WHERE	de.FK_earningPAttern = 'L'
			AND PolicyAge > 0;

		RAISERROR('premium: %i', 0, 0, @@rowcount) WITH NOWAIT;


		--Calculate running differences
		WITH	AreaCalcs
		AS		(
					SELECT	pk_EarningPercentage,
							pk_Period,
							ClosingPeriod,
							PolicyAge,
							PolicyLength,
							ZoneABCLength,
							[ZoneALength],
							ZoneAEarning,
							ZoneBEarning,
							ZoneCEarning,
							ISNULL(LAG(ZoneAEarning) OVER (PARTITION BY fk_policy ORDER BY pk_Period), 0) AS PrevMZoneAEarnings,
							ISNULL(LAG(ZoneBEarning) OVER (PARTITION BY fk_policy ORDER BY pk_Period), 0) AS PrevMZoneBEarnings,
							ISNULL(LAG(ZoneCEarning) OVER (PARTITION BY fk_policy ORDER BY pk_Period) , 0) AS PrevMZoneCEarnings
					FROM	stg.EarningPercentage
				)
		UPDATE	ec
		SET		PrevMZoneAEarnings = c.PrevMZoneAEarnings,
				PrevMZoneBEarnings = c.PrevMZoneBEarnings,
				PrevMZoneCEarnings = c.PrevMZoneCEarnings,
				EarningValue = (c.ZoneAEarning + c.ZoneBEarning + c.ZoneCEarning - c.PrevMZoneAEarnings - c.PrevMZoneBEarnings - c.PrevMZoneCEarnings) / (IIF(FK_earningPattern	= 'T', 365 * c.PolicyLength, 1.00000) )
		FROM	AreaCalcs c
		JOIN	stg.EarningPercentage ec ON ec.pk_EarningPercentage = c.pk_EarningPercentage
		WHERE	c.pk_Period <> c.ClosingPeriod 
			AND	c.PolicyAge <= c.ZoneABCLength

		RAISERROR('running differences: %i', 0, 0, @@rowcount) WITH NOWAIT;

		--RETURN
		--Produce last value. Caters for rounding issue caused by precision limitations on DECIMAL data type
		UPDATE	ec
		SET		ec.EarningValue = ISNULL(ec.EarningValue, 0) + IIF(ec.pk_EarningPercentage = ISNULL(DIFF.FirstNullValue, DIFF.LastValue), 1 - DIFF.TotalEarningValue, 0)
		--select *, ISNULL(ec.EarningValue, 0) + IIF(ec.pk_EarningPercentage = ISNULL(DIFF.FirstNullValue, DIFF.LastValue), 1 - DIFF.TotalEarningValue, 0)
		FROM	stg.EarningPercentage ec
		JOIN	(
					SELECT	SUM(ISNULL(mec.EarningValue,0)) AS TotalEarningValue, --Added 
							MIN(IIF(mec.EarningValue IS NULL, mec.pk_EarningPercentage, NULL)) AS FirstNullValue,
							MAX(mec.pk_EarningPercentage) AS LastValue,
							mec.fk_policy
					FROM	stg.EarningPercentage mec
					GROUP BY mec.fk_policy
				) DIFF	ON DIFF.fk_policy = ec.fk_policy
		WHERE	diff.TotalEarningValue <> 1
		RAISERROR('rounding: %i', 0, 0, @@rowcount) WITH NOWAIT;

		IF EXISTS	(
						SELECT		SUM(EarningValue),
									fk_policy
						FROM		stg.EarningPercentage
						GROUP BY	fk_policy
						HAVING		SUM(EarningValue) <> 1
					)
		RAISERROR	('!!!!!!!!!!!!!!!!!!!!!!!!!!Earning Percentages don''t sum to 100%!!!!!!!!!!!!!!!!!!!!!!!!!!', 16, 1)
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END