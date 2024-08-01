USE [WorkingTime]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROC [dbo].[ImportCSV]
  @FilePath varchar(100) = NULL,
  @TargetTable varchar(100) = NULL,
  @CodePage varchar(10) = 1250,
  @FirstRow varchar(10) = 2,
  @FieldTerminator varchar(5) = ';',
  @RowTerminator varchar(5) = '0x0a'

AS
BEGIN
	SET NOCOUNT oN
	
	IF OBJECT_ID(@TargetTable, 'U') IS NOT NULL
       BEGIN
	   DECLARE @bulk_cmd VARCHAR(1000)
       SET @bulk_cmd = 'BULK INSERT '+ @TargetTable +' FROM ''' + @FilePath + ''' 
	   WITH (  CodePage = ' + @CodePage + ',
               FirstRow = ' + @FirstRow + ',
               FieldTerminator = ''' + @FieldTerminator + ''',
               RowTerminator = ''' +@RowTerminator + '''
            )'

		  		  
	   EXEC(@bulk_cmd)
	   END
    ELSE
	   RETURN 1
END