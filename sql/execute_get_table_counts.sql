/* ------------------------------------------------------------------------------------
Copyright (C) 2017  Steven Jones aka testmonger
See https://github.com/testmonger/db_test_tools

  Purpose: Get counts for each table in an application database, 
    and maintain a history to repeat multiple times as needed.
	This is a common table for all databases on the db server.
  
  Example: Set comment to 'First step', then execute this procedure. 
	Then do something in he application to change data.
	Then set comment to 'Second step', execute this procedure. 
	Repeat as needed.
  
  How to Use:
  1. @apphost, @appname: Enter application server name and application instance 
	in the first two input parmaters (using single quotes).
  
  2. @comment: Enter a comment - this is free form text, use whatever makes sense 
     for your process step, but keep it brief.
  
  3. @reset: Optional: If you want to delete all the prior counts, set @reset = 'Y'.
	  Note: Generally, you should reset the counts after you create a new application instance.	  
  
  4. @tabname: Optional: If you want to filter the counts that are returned to
     just a subset of tables, enter a string in @tabname. 
	  Example: @tabname = 'invoice' returns counts for tables named invoice
	  If you want to search with wild card, add the % symbol before/after/both.
 	  Example: @tabname = '%invoice%' returns counts for tables named 
	  Invoice, InvoiceItem, InvoiceVendor.
	  Note: counts are still kept for all tables even if you use @tabname.
  
  5. @queryonly: Optional: If you only want to query existing history records
     without adding any new ones, set @queryonly = 'Y'. You can also combine this
	  with @tabname.
  
  Notes: 
    SQL is not case sensitive.
	 The history table is named [CommonTools].dbo.qa_TABCOUNTHIST
  ------------------------------------------------------------------------------------ */

EXEC	[CommonTools].[dbo].[get_count_all_tables]
		@apphost	= 'LoudCloud', -- application server name
		@appname	= 'BrownCow' , -- application instance name
		@comment	= 'Provide fresh water',
		@reset		= 'Y', -- set to Y if you want to reset the counts for all instances of this server+app
		@tabname	= '%', -- default = all tables. if needed, add table name keywords to limit results, like %water%
		@queryonly	= ''   -- if Y then don't add more counts, just retrun existing counts, and filter by tabname if specified


/* Change Log
*/