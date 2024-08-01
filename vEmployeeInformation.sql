CREATE OR ALTER VIEW dbo.vEmployeeInformation AS
  SELECT E.EmployeeID, E.EmployeeName, J.JobID, J.JobName, D.DepartmentID, D.DepartmentName, W.WorkScheduleID, W.WorkScheduleName,
     BC.CardID, BC.CardNumber,  E.EntryDate, E.ExitDate
  FROM Employee E
     INNER JOIN Job J ON E.JobID = J.JobID
     INNER JOIN WorkSchedule W ON J.WorkScheduleID = W.WorkScheduleID
     INNER JOIN  Department D ON J.DepartmentID = D.DepartmentID
     INNER JOIN CardEmployeeRelation CER ON CER.EmployeeID = E.EmployeeID
     INNER JOIN BlockingCard BC ON BC.CardID = CER.CardID