USE WorkingTime

ALTER TABLE dbo.Employee 
   ADD CONSTRAINT FK_Employee_Job_JobID FOREIGN KEY (JobID) REFERENCES dbo.Job (JobID) ON UPDATE  NO ACTION ON DELETE  NO ACTION 
GO

ALTER TABLE dbo.CardEmployeeRelation
   ADD CONSTRAINT FK_CardEmployeeRelation_Employee_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES dbo.Employee (EmployeeID) ON UPDATE NO ACTION ON DELETE NO ACTION 
GO

ALTER TABLE dbo.CardEmployeeRelation
   ADD CONSTRAINT FK_CardEmployeeRelation_BlockingCard_CardID FOREIGN KEY (CardID) REFERENCES dbo.BlockingCard (CardID) ON UPDATE NO ACTION ON DELETE NO ACTION 
GO

ALTER TABLE dbo.BlockEvent 
   ADD CONSTRAINT FK_BlockEvent_BlockType_BlockTypeID FOREIGN KEY (BlockTypeID) REFERENCES dbo.BlockType (BlockTypeID) ON UPDATE NO ACTION ON DELETE  NO ACTION 
GO

ALTER TABLE dbo.BlockEvent 
   ADD CONSTRAINT FK_BlockEvent_BlockingCard_CardID FOREIGN KEY (CardID) REFERENCES dbo.BlockingCard (CardID) ON UPDATE NO ACTION ON DELETE  NO ACTION 
GO

ALTER TABLE dbo.Job
   ADD CONSTRAINT FK_Job_Department_DepartmentID FOREIGN KEY (DepartmentID) REFERENCES dbo.Department (DepartmentID) ON UPDATE NO ACTION ON DELETE NO ACTION 
	
GO

ALTER TABLE dbo.Job
   ADD CONSTRAINT FK_Job_WorkSchedule_WorkScheduleID FOREIGN KEY (WorkScheduleID) REFERENCES dbo.WorkSchedule (WorkScheduleID) ON UPDATE NO ACTION ON DELETE NO ACTION 
	
GO

ALTER TABLE dbo.BlockingCard
   ADD CONSTRAINT FK_BlockingCard_CardType_CardTypeID FOREIGN KEY (CardTypeID) REFERENCES dbo.CardType (CardTypeID) ON UPDATE NO ACTION ON DELETE NO ACTION 
GO

ALTER TABLE dbo.ProcessingResult
   ADD CONSTRAINT FK_ProcessingResult_Employee_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES dbo.Employee (EmployeeID) ON UPDATE NO ACTION ON DELETE NO ACTION 
	
GO

ALTER TABLE dbo.ProcessingResult
   ADD CONSTRAINT FK_ProcessingResult_AbsenceType_AbsenceTypeID FOREIGN KEY (AbsenceTypeID) REFERENCES dbo.AbsenceType (AbsenceTypeID) ON UPDATE NO ACTION ON DELETE NO ACTION 
	
GO
