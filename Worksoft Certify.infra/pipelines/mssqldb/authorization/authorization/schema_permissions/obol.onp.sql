-- OBOL.ONP
-- create the database role
IF NOT EXISTS(select 1 from sys.database_principals where type = 'R' and (principal_id >0 and principal_id < 16384) and name ='onp_developer')
BEGIN
	-- create the database role
	PRINT N'Creating Role'
	CREATE ROLE onp_developer AUTHORIZATION db_securityadmin;
	-- grant access rights to a specific schema in the database
	PRINT N'Granting access to Role'
	GRANT 
		SELECT, INSERT, UPDATE, DELETE, ALTER, EXECUTE
	ON SCHEMA::onp
		TO onp_developer;
END
ELSE
	PRINT N'Role already exists'

-- create database user from AAD group
IF NOT EXISTS(SELECT 1 FROM sys.database_principals WHERE name ='GG OBOL ONP Developer')
BEGIN
	-- create database user from AAD group
	PRINT N'Creating User'
	--CREATE USER [GG OBOL ONP Developer] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[onp];
	CREATE USER [GG OBOL ONP Developer] WITH DEFAULT_SCHEMA=[onp], SID = 0x437B0D566E05FA41B681C031E3C7F972, TYPE = E;
END
ELSE
	PRINT N'User already exists'

IF IS_ROLEMEMBER('onp_developer','GG OBOL ONP Developer') = 0
BEGIN
	-- add the user to the new role created 
	PRINT N'Adding role to user'
	EXEC sp_addrolemember 'onp_developer', 'GG OBOL ONP Developer';
END
ELSE
	PRINT N'Role already assigned to user'


IF NOT EXISTS(select 1 from sys.database_principals where type = 'R' and (principal_id >0 and principal_id < 16384) and name ='onp_datawriter')
BEGIN
	-- create the database role
	PRINT N'Creating Role'
	CREATE ROLE onp_datawriter AUTHORIZATION db_securityadmin;
	-- grant access rights to a specific schema in the database
	PRINT N'Granting access to Role'
      GRANT 
            SELECT, INSERT, UPDATE, DELETE, EXECUTE, ALTER
      ON SCHEMA::onp
            TO onp_datawriter;
END
ELSE
	PRINT N'Role already exists'

IF NOT EXISTS(SELECT 1 FROM sys.database_principals WHERE name ='GG OBOL ONP User')
BEGIN
	-- create database user from AAD group
	PRINT N'Creating User'	
	--CREATE USER [GG OBOL ONP User] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[onp];
	CREATE USER [GG OBOL ONP User] WITH DEFAULT_SCHEMA=[onp], SID = 0xC7FE08D1BCDCA14A9029C616DEB2A050, TYPE = E;	
END
ELSE
	PRINT N'User already exists'

IF IS_ROLEMEMBER('onp_datawriter','GG OBOL ONP User') = 0
BEGIN
	-- add the user to the new role created 
	PRINT N'Adding role to user'
	EXEC sp_addrolemember 'onp_datawriter', 'GG OBOL ONP User';
END
ELSE
	PRINT N'Role already assigned to user'