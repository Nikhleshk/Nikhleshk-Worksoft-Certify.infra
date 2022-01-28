-- Create Login:
-- USE master;
GO
CREATE LOGIN grpobolonpdev WITH password='myVeryStrongPassword';

-- create the user on the db
CREATE USER grpobolonpdev
	FOR LOGIN grpobolonpdev
	WITH DEFAULT_SCHEMA = onp
GO

EXEC sp_addrolemember 'onp_datawriter', 'grpobolonpdev'