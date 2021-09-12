1. open MYSQL workbench, create 2 schemas, 'data' and 'datawarehouse'. 'Datawarehouse' for star schema. 
   'Data' for master and transaction tables data.

2. run Transaction_and_MasterData_Generator.sql scipt file of data sources (to load transactions and masterdata)
   on the 'Data' schema.

3. run CreateDW.sql script file to make dw schema on the 'Datawarehouse' schema for star schema.

4. Open the meshjoin java project file.

5. In the 'dbcon.java' file, enter the credentials for your MYSQL workbench connectivity 
   as well as schema name for MASTER and TRANSACTION DATA.

6. In the dbconDW.java file, enter the credentials for your MYSQL workbench connectivity 
   as well as schema name for STAR SCHEMA.

7. Run the project file and wait till you see the message, "Done. All the tables have been populated." This will fill the warehouse tables.

8. run QueriesDW.sql script to run queries in dw. This will help to analyze the warehouse
