-- OBOL.KPI
-- create the database role
IF NOT EXISTS(select 1 from sys.database_principals where type = 'R' and (principal_id >0 and principal_id < 16384) and name ='kpi_developer')
BEGIN
	-- create the database role
	PRINT N'Creating Role'
	CREATE ROLE kpi_developer AUTHORIZATION db_securityadmin;
	-- grant access rights to a specific schema in the database
	PRINT N'Granting access to Role'
      GRANT 
            SELECT, INSERT, UPDATE, DELETE, ALTER 
      ON SCHEMA::kpi
            TO kpi_developer;

END
ELSE
	PRINT N'Role already exists'

IF NOT EXISTS(SELECT 1 FROM sys.database_principals WHERE name ='GG OBOL KPI Developer')
BEGIN
	-- create database user from AAD group
	PRINT N'Creating User'
      --CREATE USER [GG OBOL KPI Developer] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[kpi];
	CREATE USER [GG OBOL KPI Developer] WITH DEFAULT_SCHEMA=[kpi], SID = 0x6DA7FA421E78A34DB7D23A6BAF6F5E92, TYPE = E;
END
ELSE
	PRINT N'User already exists'

IF IS_ROLEMEMBER('kpi_developer','GG OBOL KPI Developer') = 0
BEGIN
	-- add the user to the new role created 
	PRINT N'Adding role to user'
	EXEC sp_addrolemember 'kpi_developer', 'GG OBOL KPI Developer';
END
ELSE
	PRINT N'Role already assigned to user'


IF NOT EXISTS(select 1 from sys.database_principals where type = 'R' and (principal_id >0 and principal_id < 16384) and name ='kpi_datareader')
BEGIN
	-- create the database role
	PRINT N'Creating Role'
	CREATE ROLE kpi_datareader AUTHORIZATION db_securityadmin;
	-- grant access rights to a specific schema in the database
	PRINT N'Granting access to Role'
      GRANT 
            SELECT
      ON SCHEMA::kpi
            TO kpi_datareader;
END
ELSE
	PRINT N'Role already exists'

IF NOT EXISTS(SELECT 1 FROM sys.database_principals WHERE name ='GG OBOL KPI User')
BEGIN
	-- create database user from AAD group
	PRINT N'Creating User'	
      --CREATE USER [GG OBOL KPI User] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[kpi];
	CREATE USER [GG OBOL KPI User] WITH DEFAULT_SCHEMA=[kpi], SID = 0x47F621D428BF0A42993AB1849DD8BB01, TYPE = E;	
END
ELSE
	PRINT N'User already exists'

IF IS_ROLEMEMBER('kpi_datareader','GG OBOL KPI User') = 0
BEGIN
	-- add the user to the new role created 
	PRINT N'Adding role to user'
      EXEC sp_addrolemember 'kpi_datareader', 'GG OBOL KPI User';
END
ELSE
	PRINT N'Role already assigned to user'






