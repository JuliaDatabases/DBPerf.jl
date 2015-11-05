#Assign the variable number_of_datasets with an Integer, this will indicate the number of Insert and Update queries that will be created and executed using this program
global number_of_datasets = 100

#Feel free to comment the unused driver blocks

#DSN for ODBC connection
using ODBC
global const MySQL_DSN = "Default" #Configure the default Database for MySQL within your DSN configuration i.e odbc.ini file
#global const MySQL_Username = "root"
#global const MySQL_Password = "root"
global const Oracle_DSN = "oracle_dsn"
global const Oracle_Username = "julia"
global const Oracle_Password = "password"
global const Oracle_table_name = "Employee"

#Credentials for MySQL connection
using MySQL
global const MySQL_Host = "127.0.0.1"
global const MySQL_Username = "root"
global const MySQL_Password = "root"
global const MySQL_Database = "mysqltest1"

#Credentials for PostgreSQL credentials
using PostgreSQL, DataFrames, DBI
global const PostGres_Username = "postgres"
global const PostGres_Password = "postgres"
global const PostGres_Host = "localhost"
global const PostGres_Port_number = 5432
global const PostGres_Database = "mytest"

#Credentials for JDBC connection
using JDBC
global const JDBC_MySQL_Class_Path = "/usr/share/java/mysql-connector-java.jar"
global const JDBC_MySQL_Username = "root"
global const JDBC_MySQL_Password = "root"
global const MySQL_JDBC_URL = "jdbc:mysql://127.0.0.1/mysqltest1"
global const JDBC_Oracle_Connector_Path = "/u01/app/oracle/product/11.2.0/xe/jdbc/lib/ojdbc5.jar"
global const JDBC_Oracle_Username = "julia"
global const JDBC_Oracle_Password = "password"
global const Oracle_JDBC_URL= "jdbc:oracle:thin:@127.0.0.1:1521"
#global const Oracle_table_name = "Employee"

#Credentials for Mongo DB
using LibBSON, Mongo
global const Mongo_Host = "localhost"
global const Mongo_Port = 27017

#Credentials for SQLite
using SQLite
global const SQLite_DBname = "Benchmark.sqlite"
global const SQLite_table = "Employee"
