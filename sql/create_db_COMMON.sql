/*	
Copyright (C) 2017  Steven Jones aka testmonger
See https://github.com/testmonger/db_test_tools
*/
USE master;

IF  NOT EXISTS (SELECT * FROM sys.databases WHERE name like 'CommonTools' )
	CREATE DATABASE [CommonTools];

GO
