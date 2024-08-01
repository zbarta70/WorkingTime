USE [WorkingTime]
GO

CREATE OR ALTER FUNCTION dbo.Processing_a_Day_1st_Step( @CardID smallint, @ProcessingDate date, @RowNumber1 tinyint, @RowNumber2 tinyint)
    RETURNS TIME(0)  AS

BEGIN
   
   DECLARE @datetime1 smalldatetime
   DECLARE @datetime2 smalldatetime
   DECLARE @TimeDifference time(0)
   
   SELECT @datetime1 = BlockTime FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = @RowNumber1
   SELECT @datetime2 = BlockTime FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = @RowNumber2
   
   SELECT @TimeDifference = dbo.TimeDifference (@datetime1, @datetime2)
   RETURN @TimeDifference

 END  
/*   
   
   SELECT *
   FROM BlockEvent E
   INNER JOIN CardEmployeeRelation CER ON E.CardID = CER.CardID
   WHERE CER.EmployeeID = @EmployeeID AND CAST(E.BlockTime as date) = @ProcessingDate AND BlockTypeID = 1 
   
   SET @TimeDifference = dbo.TimeDifference(@ProcessingDate,@EmployeeID)
   PRINT @TimeDifference
  END




DECLARE @datetime1 smalldatetime
DECLARE @datetime2 smalldatetime
DECLARE @datetimediff time(0)
SELECT @datetime1 = BlockTime FROM dbo.One_Card_One_Day_Event(1, '2022-05-23') WHERE Sorszám =1
SELECT @datetime2 = BlockTime FROM dbo.One_Card_One_Day_Event(1, '2022-05-23') WHERE Sorszám =2
SELECT @datetimediff = dbo.TimeDifference (@datetime1, @datetime2)
PRINT @datetimediff */