USE [WorkingTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [dbo].[vBlockEventProblem] AS

  SELECT CAST(BlockTime as date) BlockDate, E.EmployeeName, "Error message" =
     CASE 
	     WHEN COUNT(BE.CardID) = 0 THEN 'A dolgoz�nak nincs blokkol�sa'
         WHEN COUNT(BE.CardID) > 4 THEN 'A dolgoz�nak t�l sok blokkol�sa van'
		 WHEN COUNT(BE.CardID) % 2 = 1 THEN 'A dolgoz�nak hi�nyzik blokkol�sa'
		 ELSE 'Nincs hiba'
	 END
  FROM BlockEvent BE
  INNER JOIN CardEmployeeRelation CER ON BE.CardID = CER.CardID
  INNER JOIN Employee E ON CER.EmployeeID = E.EmployeeID
  GROUP BY CAST(BlockTime as date), E.EmployeeName
