# db_test_tools
Stored Procedures for Testing SQL Databases

This project presents concepts and working examples of useful SQL for database analysis and verification. 
The main idea is to make useful tools availabe to dev and qa users for all databases on the server, while minimizing the technical expertise requreid to access these tools. And, since the tools are kept in a central location, they do not alter the data or structures inside of the application under test.

The examples were created using Microsoft SQL Server 2016. High level items in this project include:

1. Create a common database to house stored procedures for analysis and verification of application databases.
  - run anywhere in SSMS via dynmaic SQL (no need to select target database before running)
  - require user to input certain parameters to identify the application database
  - useful for scenarios where there are multiple (test) application databases on one server
  - useful to seperate analysis and verification objects so that they are outside of the application
2. Stored Proc: Count History
  - common *count* table for all tables in an application database
  - param to allow user to tag a given count, example: before process X, after process Y
  - param to allow user to reset count
  - param to allow user to query history without changing it
  - param to allow user to filter query results
  - the history table includes all application databases, but the stored proc only exposes one at a time
    -- advanced users can query the common table to compare multiple databases
3. Stored Proc: Entity Analysis
  - let user find all tables+columns based on search term
  - used for impact analysis and test planning
4. Stored Proc Library
  - table to maintain listing of analysis and verification tools
  - includes link to web site to open a tool
  - includes comments on how to use the tool
  - includes instructions how to set SSMS toolbar to access a website with the SQL files to run a stored proc, including comments on usage

  

