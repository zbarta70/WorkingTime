USE WorkingTime

CREATE TABLE dbo.BlockEvent	(
	BlockEventID smallint NOT NULL IDENTITY (1, 1),
	BlockTime smalldatetime NOT NULL,
	BlockTypeID tinyint NOT NULL,
	CardID smallint NOT NULL   )
ALTER TABLE dbo.BlockEvent ADD CONSTRAINT PK_BlockEvent_BlockEventID PRIMARY KEY (BlockEventID)
ALTER TABLE dbo.BlockEvent ADD CONSTRAINT CHK_BlockEvent_BlockTime_NotFuture CHECK (BlockTime <= SYSDATETIME())

CREATE TABLE dbo.BlockType	(
	BlockTypeID tinyint NOT NULL IDENTITY (1, 1),
	BlockTypeName varchar(20) NOT NULL	)
ALTER TABLE dbo.BlockType ADD CONSTRAINT PK_BlockType_BlockTypeID PRIMARY KEY (BlockTypeID)

CREATE TABLE dbo.BlockingCard (
	CardID smallint NOT NULL IDENTITY (1, 1),
	CardNumber char(16) NOT NULL,
	CardTypeID tinyint NOT NULL,
	ValidFrom smalldatetime NOT NULL,
	ValidTo smalldatetime NULL	) 
ALTER TABLE dbo.BlockingCard ADD CONSTRAINT CHK_BlockingCard_CardNumberIsHexadecimal CHECK (CardNumber LIKE '%[^0-9A-F]%')
ALTER TABLE dbo.BlockingCard ADD CONSTRAINT PK_BlockingCard_CardID PRIMARY KEY (CardID)

CREATE TABLE dbo.CardType (
	CardTypeID tinyint NOT NULL IDENTITY (1, 1),
	CardTypeName varchar(20) NOT NULL   )  
ALTER TABLE dbo.CardType ADD CONSTRAINT PK_CardType_CardTypeID PRIMARY KEY (CardTypeID)
	
CREATE TABLE dbo.CardEmployeeRelation (
	CardID smallint NOT NULL,
	EmployeeID smallint NOT NULL,
	ValidFrom smalldatetime NOT NULL,
	ValidTo smalldatetime NULL	)  
ALTER TABLE dbo.CardEmployeeRelation ADD CONSTRAINT PK_CardEmployeeRelation_CardID_EmployeeID PRIMARY KEY (CardID,	EmployeeID)

CREATE TABLE dbo.Department	(
	DepartmentID tinyint NOT NULL IDENTITY (1, 1),
	DepartmentName varchar(30) NOT NULL,
	ModifiedDate smalldatetime NOT NULL	) 
ALTER TABLE dbo.Department ADD CONSTRAINT PK_Department_DepartmentID PRIMARY KEY (DepartmentID)

CREATE TABLE dbo.Employee (
	EmployeeID smallint NOT NULL IDENTITY (1, 1),
	EmployeeName varchar(30) NOT NULL,
	JobID tinyint NOT NULL,
	EntryDate smalldatetime NOT NULL,
	ExitDate smalldatetime NULL	)  
ALTER TABLE dbo.Employee ADD CONSTRAINT	CK_Employee_DateControl CHECK (ExitDate >= EntryDate)
ALTER TABLE dbo.Employee ADD CONSTRAINT	PK_Employee_EmployeeID PRIMARY KEY (EmployeeID)

CREATE TABLE dbo.AbsenceType (
	AbsenceTypeID tinyint NOT NULL IDENTITY (1, 1),
	AbsenceTypeName varchar(30) NOT NULL   )
ALTER TABLE dbo.AbsenceType ADD CONSTRAINT PK_AbsenceType_AbsenceTypeID PRIMARY KEY (AbsenceTypeID)

CREATE TABLE dbo.ProcessingResult	(
	ProcessingID smallint NOT NULL IDENTITY (1, 1),
	EmployeeID smallint NOT NULL,
	ProcessingDate date NOT NULL,
	IsMissingBlockEvent bit NOT NULL,
	AbsenceTypeID tinyint NULL,
	WorkScheduleID tinyint NOT NULL,
	CalculatedWorkingTime time(0) NULL,
	AccountedWorkingTime time(0) NULL,
	DailyBalance time(0) NULL,
	MonthlyBalance smallint NULL,
        NextDayAbsence tinyint NULL,
        CardID smallint NULL)
	 
ALTER TABLE dbo.ProcessingResult ADD CONSTRAINT	PK_ProcessingResult_ProcessingID PRIMARY KEY (ProcessingID)

CREATE TABLE dbo.WorkSchedule	(
	WorkScheduleID tinyint NOT NULL IDENTITY (1, 1),
	WorkScheduleName varchar(20) NOT NULL   )
ALTER TABLE dbo.WorkSchedule ADD CONSTRAINT PK_WorkSchedule_WorkScheduleID PRIMARY KEY (WorkScheduleID)

CREATE TABLE dbo.Job	(
	JobID tinyint NOT NULL IDENTITY (1, 1),
	JobName varchar(40) NOT NULL,
	DepartmentID tinyint NOT NULL,
	WorkScheduleID tinyint NOT NULL
	) 
ALTER TABLE dbo.Job ADD CONSTRAINT PK_Job_JobID PRIMARY KEY CLUSTERED (JobID)