-- OBOL.DDMRP
-- create the database role
IF NOT EXISTS(select 1 from sys.database_principals where type = 'R' and (principal_id >0 and principal_id < 16384) and name ='ddmrp_developer')
BEGIN
	-- create the database role
	PRINT N'Creating Role'
	CREATE ROLE ddmrp_developer AUTHORIZATION db_securityadmin;
	-- grant access rights to a specific schema in the database
	PRINT N'Granting access to Role'
      GRANT 
            SELECT, INSERT, UPDATE, DELETE, ALTER 
      ON SCHEMA::ddmrp
            TO ddmrp_developer;
END
ELSE
	PRINT N'Role already exists'

IF NOT EXISTS(SELECT 1 FROM sys.database_principals WHERE name ='GG OBOL DDMRP Developer')
BEGIN
	-- create database user from AAD group
	PRINT N'Creating User'
      --CREATE USER [GG OBOL DDMRP Developer] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[ddmrp];
	CREATE USER [GG OBOL DDMRP Developer] WITH DEFAULT_SCHEMA=[ddmrp], SID = 0xF28D56705FE5E44C80B10CEEF32E2E55, TYPE = E;
END
ELSE
	PRINT N'User already exists'

IF IS_ROLEMEMBER('ddmrp_developer','GG OBOL DDMRP Developer') = 0
BEGIN
	-- add the user to the new role created 
	PRINT N'Adding role to user'	
      EXEC sp_addrolemember 'ddmrp_developer', 'GG OBOL DDMRP Developer';
END
ELSE
	PRINT N'Role already assigned to user'


IF NOT EXISTS(select 1 from sys.database_principals where type = 'R' and (principal_id >0 and principal_id < 16384) and name ='ddmrp_datareader')
BEGIN
	-- create the database role
	PRINT N'Creating Role'
	CREATE ROLE ddmrp_datareader AUTHORIZATION db_securityadmin;
	-- grant access rights to a specific schema in the database
	PRINT N'Granting access to Role'
      GRANT 
            SELECT
      ON SCHEMA::ddmrp
            TO ddmrp_datareader;
END
ELSE
	PRINT N'Role already exists'

IF NOT EXISTS(SELECT 1 FROM sys.database_principals WHERE name ='GG OBOL DDMRP User')
BEGIN
	-- create database user from AAD group
	PRINT N'Creating User'	
      --CREATE USER [GG OBOL DDMRP User] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[ddmrp];
	CREATE USER [GG OBOL DDMRP User] WITH DEFAULT_SCHEMA=[ddmrp], SID = 0xC1D01E6EABDB1A438A2B599FA29C94AE, TYPE = E;	
END
ELSE
	PRINT N'User already exists'

IF IS_ROLEMEMBER('ddmrp_datareader','GG OBOL DDMRP User') = 0
BEGIN
	-- add the user to the new role created 
	PRINT N'Adding role to user'
      EXEC sp_addrolemember 'ddmrp_datareader', 'GG OBOL DDMRP User';
END
ELSE
	PRINT N'Role already assigned to user'
