USE [master]
GO
CREATE LOGIN [HRAdmin] WITH PASSWORD=N'Pa55w.rd', DEFAULT_DATABASE=[WorkingTime], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
ALTER SERVER ROLE [bulkadmin] ADD MEMBER [HRAdmin]
GO
use [master];
GO
USE [WorkingTime]
GO
CREATE USER [HRAdmin] FOR LOGIN [HRAdmin]
GO
USE [WorkingTime]
GO
ALTER ROLE [db_owner] ADD MEMBER [HRAdmin]
GO

USE [master]
GO
CREATE LOGIN [Manager] WITH PASSWORD=N'Pa55w.rd', DEFAULT_DATABASE=[WorkingTime], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
ALTER SERVER ROLE [bulkadmin] ADD MEMBER [Manager]
GO
USE [WorkingTime]
GO
CREATE USER [Manager] FOR LOGIN [Manager]
GO
USE [WorkingTime]
GO
ALTER ROLE [db_datareader] ADD MEMBER [Manager]
GO

USE [master]
GO
CREATE LOGIN [WebEmployee] WITH PASSWORD=N'Pa55w.rd', DEFAULT_DATABASE=[WorkingTime], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [WorkingTime]
GO
CREATE USER [WebEmployee] FOR LOGIN [WebEmployee]
GO
USE [WorkingTime]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WebEmployee]
GO
