USE [WorkingTime]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE dbo.InsertEmployee
  @EmployeeName varchar(30),
  @JobID tinyint,
  @EntryDate date
 
 AS
 
  SET NOCOUNT ON
  
  IF @EmployeeName IS NULL OR LEN(@EmployeeName) > 30 OR @JobID IS NULL OR @EntryDate > GETDATE()
     RETURN 1
  ELSE
     INSERT dbo.Employee (EmployeeName, JobID, EntryDate)
	   VALUES (@EmployeeName, @JobID, @EntryDate)
  