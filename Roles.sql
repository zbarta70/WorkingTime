USE [WorkingTime]
GO
CREATE ROLE [RoleManager]
GO
USE [WorkingTime]
GO
ALTER ROLE [RoleManager] ADD MEMBER [Manager]
GO
use [WorkingTime]
GO
GRANT CONNECT TO [RoleManager]
GO
use [WorkingTime]
GO
GRANT EXECUTE TO [RoleManager]
GO
use [WorkingTime]
GO
GRANT SELECT TO [RoleManager]
GO

USE [WorkingTime]
GO
CREATE ROLE [RoleEmployee]
GO
USE [WorkingTime]
GO
ALTER ROLE [RoleEmployee] ADD MEMBER [WebEmployee]
GO
use [WorkingTime]
GO
GRANT CONNECT TO [RoleEmployee]
GO
use [WorkingTime]
GO
GRANT EXECUTE TO [RoleEmployee]
GO

USE [WorkingTime]
GO
CREATE APPLICATION ROLE [RoleWeb] WITH DEFAULT_SCHEMA = [dbo], PASSWORD = N'Pa55w.rd'
GO
USE [WorkingTime]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_datareader] TO [RoleWeb]
GO
