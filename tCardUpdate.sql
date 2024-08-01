USE WorkingTime
GO
CREATE OR ALTER TRIGGER CardUpdate ON CardEmployeeRelation AFTER INSERT
AS
  SET NOCOUNT ON

  UPDATE CardEmployeeRelation
  SET ValidTo = GETDATE()
		FROM CardEmployeeRelation CER
		INNER JOIN inserted I ON CER.CardID = I.CardID 
			WHERE CER.ValidTo IS NULL




