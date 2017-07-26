/*
Copyright (C) 2017  Steven Jones aka testmonger
See https://github.com/testmonger/db_test_tools
Stored proc to get counts for all tables in an application database.
Provides user several options to collect a history of counts, 
and assign names to corresponding to various functional scenarios.
Uses dynmaic sql to get counts from the target database 
while maintaining data in the common repository database.

See execute_get_table_counts.sql for more explanation.
*/
USE [CommonTools];
GO

IF OBJECT_ID('get_table_counts', 'P') IS NOT NULL
  DROP PROCEDURE [get_table_counts] 
GO

CREATE PROCEDURE [get_table_counts]
( 
  @apphost		varchar(100), -- if database name includes the application server host name
  @appname		varchar(30),  -- if database identified by the application name/version
  @comment		varchar(50),  -- example 'first part'
  @reset		varchar(1) ,  -- set to Y to remove all previous count records for this sym database
  @tabname		varchar(100),
  @queryonly	varchar(1)
)
AS
BEGIN
	DECLARE
	  @dbname varchar(100) = @apphost+'_'+@appname ,
	  @servername	varchar(100) = @@servername,
	  @counttime	VARCHAR(100) = CAST(GETDATE() AS nvarchar(30)),
	  @ExecStmt		NVARCHAR(4000),
	  @ReturnCode	INT = 1,
	  @Message		VARCHAR(200)

  SET @dbname = [CommonTools].dbo.strip_brackets(@dbname) --function to remove brackets from object name

	IF db_id(@dbname) is null --error check if db exists
	BEGIN
		SET @Message ='Database does not exist : ' + CONVERT(VARCHAR, @dbname)
		RAISERROR(@Message, 16, 1)
		RETURN (1)
	END

	SET @ExecStmt ='USE ' + quotename(@dbname) 
	EXECUTE (@ExecStmt)
	SET @ReturnCode = @@ERROR
	IF @ReturnCode <> 0
	BEGIN
		SET @Message ='Unable USE. Error Code:' + CONVERT(VARCHAR, @ReturnCode)
		RAISERROR(@Message, 16, 1)
		RETURN (1)
	END

	IF @queryonly NOT like 'Y'
	BEGIN
		IF @reset = 'Y'
		BEGIN
			PRINT 'Deleting all previous counts for database: ' + @dbname;

			DELETE [CommonTools].dbo.qa_TABCOUNTHIST
			WHERE dbname like @dbname
		END

		SELECT @counttime = CAST(GETDATE() AS nvarchar(30))
		PRINT 'Getting counts on SQL Server host: ' + @servername + ' for database: ' + @dbname + ' with comment: ' + @comment + ' at ' + @counttime ;
		
	  BEGIN
		 SET @ExecStmt ='USE ' + quotename(@dbname) + ';'
			+ ' INSERT INTO [CommonTools].dbo.qa_TABCOUNTHIST'
		+ ' SELECT '''+@servername+''','''+@dbname+''', o.name, ddps.row_count, '''+@counttime+''','''+@comment+''''
		+ ' FROM sys.indexes AS i '
		+ ' INNER JOIN sys.objects AS o ON i.OBJECT_ID = o.OBJECT_ID '
		+ ' INNER JOIN sys.dm_db_partition_stats AS ddps ON i.OBJECT_ID = ddps.OBJECT_ID '
		+ ' AND i.index_id = ddps.index_id '
		+ ' WHERE i.index_id < 2  AND o.is_ms_shipped = 0 ORDER BY o.NAME'
		 PRINT 'Executing : ' + @ExecStmt
		 EXECUTE (@ExecStmt)
	  END

		SET @ReturnCode = @@ERROR
		IF @ReturnCode <> 0
		BEGIN
		  SET @Message ='Unable INSERT COUNTS: ' + CONVERT(VARCHAR, @ReturnCode)
		  RAISERROR(@Message, 16, 1)
		  RETURN (1)
		END
	END
	-- referernce: http://stackoverflow.com/questions/2221555/how-to-fetch-the-row-count-for-all-tables-in-a-sql-server-database

  -- return history
  IF @ReturnCode = 0

  IF @tabname IS NOT NULL
	  BEGIN
		 SELECT @counttime = CAST(GETDATE() AS nvarchar(30))
		 PRINT 'Getting counts on SQL Server host: ' + @servername + ' for database: ' + @dbname + ' and table name like ' + @tabname + ' with comment: ' + @comment + ' at ' + @counttime ;
		 select * from [CommonTools].dbo.qa_TABCOUNTHIST 
		 where tabname like @tabname --'%'+@tabname+'%'
			and dbname like @dbname
		 ORDER BY TABNAME,COUNTDATETIME
	  END
  ELSE
	  BEGIN
  		 SELECT @counttime = CAST(GETDATE() AS nvarchar(30))
		 PRINT 'Getting counts on SQL Server host: ' + @servername + ' for database: ' + @dbname + ' with comment: ' + @comment + ' at ' + @counttime ;

		 select * from [CommonTools].dbo.qa_TABCOUNTHIST 
		 where  dbname like @dbname
		 ORDER BY TABNAME,COUNTDATETIME
	  END
  RETURN (0)

END
GO

GRANT EXECUTE on [get_table_counts] to PUBLIC
GO
