WITH EntityTreeDetails AS 
(
SELECT        t.*, tt.pkDimEntityTree, pkDimEntityTreeParent, Description
FROM          
                     [dbo].DimEntityTree tt
LEFT JOIN     [dbo].briEntityEntityTree btt ON tt.pkDimEntityTree = btt.pkDimEntityTree 
LEFT JOIN     [dbo].DimEntity t ON btt.pk_Entity=t.pk_Entity
WHERE         TT.pkDimEntityTree LIKE '48%'
)

SELECT				de.Entitycode, 
                     de.EntityName,
					 de.platform,
                     EntityLevel1 = CASE 
									WHEN COALESCE(E8.Description, E7.Description) = E7.Description THEN E6.Description 
									WHEN COALESCE(E7.Description, E6.Description) = E6.Description THEN E5.Description
									WHEN COALESCE(E6.Description, E5.Description) = E5.Description THEN E4.Description 
									WHEN COALESCE(E5.Description, E4.Description) = E4.Description THEN E3.Description
									WHEN COALESCE(E4.Description, E3.Description) = E3.Description THEN E2.Description  
									END,
                     EntityLevel2 = CASE 
									WHEN COALESCE(E8.Description, E7.Description) = E7.Description THEN E5.Description 
									WHEN COALESCE(E7.Description, E6.Description) = E6.Description THEN E4.Description
									WHEN COALESCE(E6.Description, E5.Description) = E5.Description THEN E3.Description 
									WHEN COALESCE(E5.Description, E4.Description) = E4.Description THEN E2.Description 
									END,
                     EntityLevel3 = CASE 
									WHEN COALESCE(E8.Description, E7.Description) = E7.Description THEN E4.Description 
									WHEN COALESCE(E7.Description, E6.Description) = E6.Description THEN E3.Description
									WHEN COALESCE(E6.Description, E5.Description) = E5.Description THEN E2.Description 
									END, 
                     EntityLevel4 = CASE 
									WHEN COALESCE(E8.Description, E7.Description) = E7.Description THEN E3.Description 
									WHEN COALESCE(E7.Description, E6.Description) = E6.Description THEN E2.Description
									END,
                     EntityLevel5 = CASE WHEN COALESCE(E8.Description,E7.Description) = E7.Description THEN E2.Description END,
                     EntityLevel6 =CASE WHEN E8.Description IS NOT NULL THEN E2.Description END
FROM DimEntity       de 
LEFT JOIN     EntityTreeDetails e1 on de.EntityCode=e1.EntityCode
LEFT JOIN     EntityTreeDetails e2 ON e1.pkDimEntityTreeParent = e2.pkDimEntityTree
LEFT JOIN     EntityTreeDetails e3 ON e2.pkDimEntityTreeParent = e3.pkDimEntityTree
LEFT JOIN     EntityTreeDetails e4 ON e3.pkDimEntityTreeParent = e4.pkDimEntityTree
LEFT JOIN     EntityTreeDetails e5 ON e4.pkDimEntityTreeParent = e5.pkDimEntityTree
LEFT JOIN     EntityTreeDetails e6 ON e5.pkDimEntityTreeParent = e6.pkDimEntityTree
LEFT JOIN     EntityTreeDetails e7 ON e6.pkDimEntityTreeParent = e7.pkDimEntityTree
LEFT JOIN     EntityTreeDetails e8 ON e7.pkDimEntityTreeParent = e8.pkDimEntityTree
WHERE de.Entitycode IS NOT NULL