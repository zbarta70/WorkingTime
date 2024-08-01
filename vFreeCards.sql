USE [WorkingTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [dbo].[vFreeCards] AS


SELECT CardID
FROM BlockingCard
WHERE ValidTo is NULL AND CardTypeID IN (1,2)
EXCEPT
SELECT CardID
FROM CardEmployeeRelation
WHERE ValidTo is NULL