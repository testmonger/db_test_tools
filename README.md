# db_test_tools
A QA Tool Shed for SQL Databases

This project is about a common database on the server to provide analysis and testing tools for all databases. It uses stored procedures with dynamic SQL to make the tools more accessible to all users.

The project includes working examples of useful SQL for database analysis and verification. Since the tools are kept in a central location, they do not alter the data or structures inside of the applications under test. Likewise, since they are maintained in a centralized database, the tools do not have to be rebuilt everytime an application is restored or replaced.

Finally, this project takes advantage of the SSMS web browser widget to make it easy to find and use the tools.

The examples were created using Microsoft SQL Server 2016. High level items in this project include:

1. Create a common database to house stored procedures for analysis and verification of application databases.
  - run anywhere in SSMS via dynmaic SQL (no need to select target database before running)
  - require user to input certain parameters to identify the application database
  - useful for scenarios where there are multiple (test) application databases on one server
  - useful to seperate analysis and verification objects so that they are outside of the application
  
2. The Count Tool
  - common *count* table for all tables in application databases across the server
  - param to allow user to tag a given count, example: before process X, after process Y
  - param to allow user to reset count
  - param to allow user to query history without changing it
  - param to allow user to filter query results
  - the history table includes all application databases, but the stored proc only exposes one at a time
    -- advanced users can query the common table to compare multiple databases
    
3. The Entity Analysis Tool
  - let user find all tables+columns based on search term
  - used for impact analysis and test planning
  
4. The Tool Catalog
  - table to maintain listing of analysis and verification tools
  - includes link to web site to open a tool
  - includes comments on how to use the tool
  - includes instructions how to set SSMS toolbar to access a website with the SQL files to run a stored proc, including comments on usage
