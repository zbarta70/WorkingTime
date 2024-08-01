USE [WorkingTime]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[Processing_a_Day]
  @CardID smallint,
  @ProcessingDate date
 
 AS
 
  SET NOCOUNT ON
  
  DECLARE @NoofRows int
  DECLARE @EmployeeID smallint
  DECLARE @WorkScheduleID tinyint
  DECLARE @CalculatedWorkingTime time(0)  --blokkolás szerint számolt munkaidő
  DECLARE @AccountedWorkingTime time(0) = '08:00:00'  --elszámolt munkaidő
  DECLARE @DailyBalance time(0) = '00:00:00'   --túlóra
  DECLARE @NextDayAbsence tinyint

  SELECT @NoofRows = COUNT(RowNumber) FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate)

  IF @NoofRows IS NULL
       Return 1 -- Adott dolgozónak aznapra nincs blokkolása

  ELSE IF @NoofRows > 4
       Return 2 -- Adott dolgozónak aznapra túl sok blokkolása van
 
  ELSE IF @NoofRows % 2 = 1
       Return 3 -- Adott dolgozónak aznap hiányzik blokkolása

  ELSE IF (SELECT BlockTypeID FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = 1) <> 1
       Return 4 -- Hibás blokkolás, adott dolgozónak aznap az 1. blokkolása nem Belépés 

  ELSE IF (@NoofRows IN (2,4)) AND ((SELECT BlockTypeID FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = 2) IN (1,5))
       Return 4 -- Hibás blokkolás, rossz blokkolás típus

  ELSE IF (@NoofRows = 4) AND ((SELECT BlockTypeID FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = 2) IN (1,3,4))
       Return 4 -- Hibás blokkolás, rossz blokkolás típus
 
  ELSE IF (@NoofRows = 4) AND ((SELECT BlockTypeID FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = 3) <> 1)
       Return 4 -- Hibás blokkolás, rossz blokkolás típus
 
  ELSE IF (@NoofRows = 4) AND ((SELECT BlockTypeID FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = 4) IN (1,5))
       Return 4 -- Hibás blokkolás, rossz blokkolás típus

  ELSE IF (@NoofRows = 2)  --csak 2 db blokkolás
    BEGIN
       SELECT @EmployeeID = EmployeeID FROM vEmployeeInformation WHERE CardID = @CardID
	   SELECT @WorkScheduleID = WorkScheduleID FROM vEmployeeInformation WHERE CardID = @CardID
	   SELECT @CalculatedWorkingTime = dbo.Processing_a_Day_1st_Step( @CardID, @ProcessingDate, 1, 2) 
	   IF @CalculatedWorkingTime > @AccountedWorkingTime --túlóra számítás
	       SET @DailyBalance = dbo.TimeDifference(@AccountedWorkingTime, @CalculatedWorkingTime) 

	   IF (SELECT BlockTypeID FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = 2) = 2 -- 2. blokkolás: Kilépés
	        
			IF @WorkScheduleID = 1 	--kötetlen
			    INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, CardID)
			        VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @AccountedWorkingTime, @CardID) 
			ELSE IF @WorkScheduleID = 2  -- rugalmas
			    INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, DailyBalance, CardID)
			        VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @CalculatedWorkingTime, @DailyBalance, @CardID)
            ELSE  -- műszakos
			    INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, CardID)
			        VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @CalculatedWorkingTime, @CardID) 
			
	    ELSE -- 2. blokkolás: Szabadság vagy Kiküldetés
	         BEGIN
			      IF (SELECT BlockTypeID FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = 2) = 3  --2. blokkolás: Szabadság
				       SET @NextDayAbsence = 1
                  ELSE SET @NextDayAbsence = 4   --2. blokkolás: Kiküldetés
				  IF @WorkScheduleID = 1 --kötetlen
				        INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, NextDayAbsence, CardID)
			              VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @AccountedWorkingTime,@NextDayAbsence, @CardID)
			      ELSE IF @WorkScheduleID = 2  -- rugalmas
			            INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, DailyBalance, NextDayAbsence, CardID)
			              VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @CalculatedWorkingTime, @DailyBalance, @NextDayAbsence, @CardID)
			      ELSE  -- műszakos
			            INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, NextDayAbsence, CardID)
			              VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @CalculatedWorkingTime, @NextDayAbsence, @CardID)
             END
        RETURN 0
	END
	
  ELSE IF (@NoofRows = 4)  --4 db blokkolás
    BEGIN
	   SELECT @EmployeeID = EmployeeID FROM vEmployeeInformation WHERE CardID = @CardID
	   SELECT @WorkScheduleID = WorkScheduleID FROM vEmployeeInformation WHERE CardID = @CardID
	   IF (SELECT BlockTypeID FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = 2) = 2 -- 2. blokkolás: Kilépés, a kint töltött idő nem munkaidő
             SET @CalculatedWorkingTime = dbo.TimeDifference(dbo.Processing_a_Day_1st_Step(@CardID, @ProcessingDate, 1, 4), dbo.Processing_a_Day_1st_Step(@CardID, @ProcessingDate, 2, 3))
	   ELSE SELECT @CalculatedWorkingTime = (dbo.Processing_a_Day_1st_Step( @CardID, @ProcessingDate, 1, 4)) -- 2. blokkolás: Hivatalos, a kint töltött idő is munkaidő
       
	   IF @CalculatedWorkingTime > @AccountedWorkingTime --túlóra számítás
	       SET @DailyBalance = dbo.TimeDifference(@AccountedWorkingTime, @CalculatedWorkingTime)  

       IF (SELECT BlockTypeID FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = 4) = 2 -- 4. blokkolás: Kilépés
	            IF @WorkScheduleID = 1 	--kötetlen
                        INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, CardID)
			              VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @AccountedWorkingTime, @CardID) 
			    ELSE IF @WorkScheduleID = 2  -- rugalmas
			            INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, DailyBalance, CardID)
			              VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @CalculatedWorkingTime, @DailyBalance, @CardID) 
			    ELSE  -- műszakos
			            INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, CardID)
			              VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @CalculatedWorkingTime, @CardID) 
			
       ELSE -- 4. blokkolás: Szabadság vagy Kiküldetés
	       BEGIN
			   IF (SELECT BlockTypeID FROM dbo.One_Card_One_Day_Event(@CardID, @ProcessingDate) WHERE RowNumber = 4) = 3  --4. blokkolás: Szabadság
				       SET @NextDayAbsence = 1
               ELSE SET @NextDayAbsence = 4   --4. blokkolás: Kiküldetés
			   IF @WorkScheduleID = 1 	--kötetlen
				    INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, NextDayAbsence, CardID)
			            VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @AccountedWorkingTime,@NextDayAbsence, @CardID) 
			   ELSE IF @WorkScheduleID = 2  -- rugalmas
			        INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, DailyBalance, NextDayAbsence, CardID)
			            VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @CalculatedWorkingTime, @DailyBalance, @NextDayAbsence, @CardID) 
			   ELSE  -- műszakos
			            INSERT INTO dbo.ProcessingResult(EmployeeID, ProcessingDate, IsMissingBlockEvent, WorkScheduleID, CalculatedWorkingTime, AccountedWorkingTime, NextDayAbsence, CardID)
			            VALUES (@EmployeeID, @ProcessingDate, 0, @WorkScheduleID, @CalculatedWorkingTime, @CalculatedWorkingTime, @NextDayAbsence, @CardID) 
		    END
       RETURN 0
	END
