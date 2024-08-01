USE [WorkingTime]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION dbo.One_Card_One_Day_Event(@CardID int, @day date) 
		RETURNS TABLE AS RETURN
		SELECT TOP 10 ROW_NUMBER() OVER(PARTITION BY CardID ORDER BY CAST(BlockTime as date)) RowNumber, BlockEventID, BlockTime, BlockTypeID, CardID
		FROM dbo.BlockEvent
		WHERE CardID = @CardID AND CAST(BlockTime as date) = @day
		ORDER BY 1
	GO
