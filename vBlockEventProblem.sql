USE [WorkingTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [dbo].[vBlockEventProblem] AS

  SELECT CAST(BlockTime as date) BlockDate, E.EmployeeName, "Error message" =
     CASE 
	     WHEN COUNT(BE.CardID) = 0 THEN 'A dolgozónak nincs blokkolása'
         WHEN COUNT(BE.CardID) > 4 THEN 'A dolgozónak túl sok blokkolása van'
		 WHEN COUNT(BE.CardID) % 2 = 1 THEN 'A dolgozónak hiányzik blokkolása'
		 ELSE 'Nincs hiba'
	 END
  FROM BlockEvent BE
  INNER JOIN CardEmployeeRelation CER ON BE.CardID = CER.CardID
  INNER JOIN Employee E ON CER.EmployeeID = E.EmployeeID
  GROUP BY CAST(BlockTime as date), E.EmployeeName
