USE [WorkingTime]
GO
/****** Object:  UserDefinedFunction [dbo].[TimeDifference]    Script Date: 2022.06.24. 22:51:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER FUNCTION [dbo].[TimeDifference] (@FromTime smalldatetime, @ToTime smalldatetime)
RETURNS TIME(0)
AS BEGIN
    DECLARE @Diff INT = DATEDIFF(SECOND, @FromTime, @ToTime)

    DECLARE @DiffHours INT = @Diff / 3600;
    DECLARE @DiffMinutes INT = (@Diff % 3600) / 60;
    DECLARE @DiffSeconds INT = ((@Diff % 3600) % 60);
    DECLARE @ResultTime time

    DECLARE @ResultString VARCHAR(10)

    SET @ResultString = RIGHT('00' + CAST(@DiffHours AS VARCHAR(2)), 2) + ':' +
                        RIGHT('00' + CAST(@DiffMinutes AS VARCHAR(2)), 2) + ':' +
                        RIGHT('00' + CAST(@DiffSeconds AS VARCHAR(2)), 2)

    SET @ResultTime = CAST(@ResultString AS time)
    
    RETURN @ResultTime
END   

