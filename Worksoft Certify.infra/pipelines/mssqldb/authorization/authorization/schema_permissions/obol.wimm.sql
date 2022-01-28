-- OBOL.WIMM
IF NOT EXISTS(select 1 from sys.database_principals where type = 'R' and (principal_id >0 and principal_id < 16384) and name ='wimm_developer')
BEGIN
	-- create the database role
	PRINT N'Creating Role'
	CREATE ROLE wimm_developer AUTHORIZATION db_securityadmin;
	-- grant access rights to a specific schema in the database
	PRINT N'Granting access to Role'
	GRANT 
		SELECT, INSERT, UPDATE, DELETE, ALTER 
	ON SCHEMA::wimm
		TO wimm_developer;
END
ELSE
	PRINT N'Role already exists'


IF NOT EXISTS(SELECT 1 FROM sys.database_principals WHERE name ='GG OBOL WIMM Developer')
BEGIN
	-- create database user from AAD group
	PRINT N'Creating User'
	--CREATE USER [GG OBOL WIMM Developer] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[wimm];
	CREATE USER [GG OBOL WIMM Developer] WITH DEFAULT_SCHEMA=[wimm], SID = 0xE4EA2766D2697541A5D3B87356CA5DCA, TYPE = E;
END
ELSE
	PRINT N'User already exists'

IF IS_ROLEMEMBER('wimm_developer','GG OBOL WIMM Developer') = 0
BEGIN
	-- add the user to the new role created 
	PRINT N'Adding role to user'
	EXEC sp_addrolemember 'wimm_developer', 'GG OBOL WIMM Developer';
END
ELSE
	PRINT N'Role already assigned to user'


-- OBOL.WIMM
IF NOT EXISTS(select 1 from sys.database_principals where type = 'R' and (principal_id >0 and principal_id < 16384) and name ='wimm_datareader')
BEGIN
	-- create the database role
	PRINT N'Creating Role'
	CREATE ROLE wimm_datareader AUTHORIZATION db_securityadmin;
	-- grant access rights to a specific schema in the database
	PRINT N'Granting access to Role'
	GRANT 
      SELECT
	ON SCHEMA::wimm
      TO wimm_datareader;
END
ELSE
	PRINT N'Role already exists'

IF NOT EXISTS(SELECT 1 FROM sys.database_principals WHERE name ='GG OBOL WIMM User')
BEGIN
	-- create database user from AAD group
	PRINT N'Creating User'	
	--CREATE USER [GG OBOL WIMM User] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[wimm];
	CREATE USER [GG OBOL WIMM User] WITH DEFAULT_SCHEMA=[wimm], SID = 0xCA16C2EC2AFB6748832CFF79EE5FB5FF, TYPE = E;	
END
ELSE
	PRINT N'User already exists'

IF IS_ROLEMEMBER('wimm_datareader','GG OBOL WIMM User') = 0
BEGIN
	-- add the user to the new role created 
	PRINT N'Adding role to user'
	EXEC sp_addrolemember 'wimm_datareader', 'GG OBOL WIMM User';
END
ELSE
	PRINT N'Role already assigned to user'