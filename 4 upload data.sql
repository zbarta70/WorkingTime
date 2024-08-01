USE WorkingTime

BULK INSERT dbo.AbsenceType
FROM 'C:\Vizsgaremek\BZ\AbsenceType.csv'
WITH (
CODEPAGE = 1250,
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '0x0a'  )
-------------------------------
BULK INSERT dbo.BlockEvent
FROM 'C:\Vizsgaremek\BZ\BlockEvent.csv'
WITH (
CODEPAGE = 1250,
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '0x0a'  )
------------------------------
BULK INSERT dbo.BlockingCard
FROM 'C:\Vizsgaremek\BZ\BlockingCard.csv'
WITH (
CODEPAGE = 1250,
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '0x0a'  )
------------------------------
BULK INSERT dbo.BlockType
FROM 'C:\Vizsgaremek\BZ\BlockType.csv'
WITH (
CODEPAGE = 1250,
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '0x0a'  )
------------------------------
BULK INSERT dbo.CardEmployeeRelation
FROM 'C:\Vizsgaremek\BZ\CardEmployeeRelation.csv'
WITH (
CODEPAGE = 1250,
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '0x0a'  )
------------------------------
BULK INSERT dbo.CardType
FROM 'C:\Vizsgaremek\BZ\CardType.csv'
WITH (
CODEPAGE = 1250,
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '0x0a'  )
------------------------------
BULK INSERT dbo.Department
FROM 'C:\Vizsgaremek\BZ\Department.csv'
WITH (
CODEPAGE = 1250,
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '0x0a'  )
------------------------------
BULK INSERT dbo.Employee
FROM 'C:\Vizsgaremek\BZ\Employee.csv'
WITH (
CODEPAGE = 1250,
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '0x0a'  )
------------------------------
BULK INSERT dbo.Job
FROM 'C:\Vizsgaremek\BZ\Job.csv'
WITH (
CODEPAGE = 1250,
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '0x0a'  )
------------------------------
BULK INSERT dbo.WorkSchedule
FROM 'C:\Vizsgaremek\BZ\WorkSchedule.csv'
WITH (
CODEPAGE = 1250,
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '0x0a'  )
