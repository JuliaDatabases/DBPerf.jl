using Faker
function create_queries(number_of_datasets=10000)
  # TINYINT
  tint = [rand(-128:127) for i=1 : number_of_datasets]
  # SMALLINT
  sint = [rand(-32768:32767) for i=1 : number_of_datasets]
  # MEDIUMINT
  mint = [rand(-8388608:8388607) for i=1 : number_of_datasets]
  # INT and INTEGER
  rint = [rand(-2147483648:2147483647) for i=1 : number_of_datasets]
  # BIGINT
  bint = [rand(-9223372036854775808:9223372036854775807) for i=1 : number_of_datasets]
  # FLOAT
  rfloat = [rand(Float16) for i=1 : number_of_datasets]
  # DOUBLE
  dfloat = [rand(Float32) for i=1 : number_of_datasets]
  # DOULBE PRECISION, REAL, DECIMAL
  dpfloat = [rand(Float64) for i=1 : number_of_datasets]
  #DATETIME, TIMESTAMP, DATE
  datetime = [Faker.date_time_ad() for i=1 : number_of_datasets]
  #CHAR
  chara = [randstring(1) for i=1 : number_of_datasets]
  #VARCHAR , VARCHAR2, TINYTEXT, TEXT
  varcha = [randstring(rand(1:4000)) for i=1 : number_of_datasets]
  #ENUM
  JobType = ["HR", "Management", "Accounts"]
  enume = [JobType[rand(1:3)] for i=1 : number_of_datasets]
  return varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint
end

function insert_queries(number_of_datasets=10000,dbms="MySQL")
  Insert_Query = Array(String, (number_of_datasets))
  if dbms=="MySQL"
    Insert_Query[1] = "CREATE TABLE Employee(ID INT NOT NULL AUTO_INCREMENT, Name VARCHAR(4000), Salary FLOAT, LastLogin DATETIME, OfficeNo TINYINT, JobType ENUM('HR', 'Management', 'Accounts'), h MEDIUMINT, n INTEGER, z BIGINT, z1 DOUBLE, z2 DOUBLE PRECISION, cha CHAR, empno SMALLINT, PRIMARY KEY (ID));"
    Insert_Query[2] = "CREATE UNIQUE INDEX id_idx ON Employee(ID);"
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
    for i=3 :(number_of_datasets)
      Insert_Query[i] = "INSERT INTO Employee (Name, Salary, LastLogin, OfficeNo, JobType,h, n, z, z1, z2, cha, empno) VALUES ('$(varcha[i])', $(rfloat[i]), '$(datetime[i])', $(tint[i]), '$(enume[i])', $(mint[i]), $(rint[i]), $(bint[i]), $(dfloat[i]), $(dpfloat[i]), '$(chara[i])', $(sint[i]));"
    end
    return Insert_Query
  end
  if dbms=="Oracle"
    Insert_Query[1] = "CREATE TABLE $Oracle_table_name(ID INT, Name VARCHAR(4000), Salary FLOAT, LastLogin DATE, OfficeNo NUMBER(4, 0), JobType VARCHAR2(20) CHECK( JobType IN ('HR', 'Management', 'Accounts')), h NUMBER(8, 0), n NUMBER(11, 0), z NUMBER(20, 0), z1 FLOAT(25), z2 FLOAT(25), cha CHAR, empno NUMBER(6, 0))"
    Insert_Query[2] = "create unique index id_idx on $Oracle_table_name(ID)"
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
    for i=3 :(number_of_datasets)
      Insert_Query[i] = "INSERT INTO $Oracle_table_name (ID, Name, Salary, LastLogin, OfficeNo, JobType,h, n, z, z1, z2, cha, empno) VALUES ($(i-2), '$(varcha[i])', $(rfloat[i]), TO_DATE('$(datetime[i])', 'yyyy-mm-dd hh24:mi:ss'), $(tint[i]), '$(enume[i])', $(mint[i]), $(rint[i]), $(bint[i]), $(dfloat[i]), $(dpfloat[i]), '$(chara[i])', $(sint[i]))"
    end
    return Insert_Query
  end
  if dbms == "PostgreSQL"
    Insert_Query[1] = "CREATE TABLE Employee(ID bigserial, Name VARCHAR(4000), Salary decimal, LastLogin DATE, OfficeNo smallint, JobType VARCHAR(20) CHECK( JobType IN ('HR', 'Management', 'Accounts')), h integer, n bigint, z bigint, z1 double precision, z2 double precision, cha CHAR, empno integer)"
    Insert_Query[2] = "create unique index id_idx on Employee(ID)"
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
  	for i=3 : (number_of_datasets)
		  Insert_Query[i] = "INSERT INTO Employee (ID, Name, Salary, LastLogin, OfficeNo, JobType,h, n, z, z1, z2, cha, empno) VALUES ($(i-2), '$(varcha[i])', $(rfloat[i]), '$(datetime[i])', $(tint[i]), '$(enume[i])', $(mint[i]), $(rint[i]), $(bint[i]), $(dfloat[i]), $(dpfloat[i]), '$(chara[i])', $(sint[i]));"
  	end
	  return Insert_Query
  end
end

function update_queries(number_of_datasets=10000,dbms="MySQL")
  if (dbms=="MySQL" || dbms=="PostgreSQL")
    number_of_datasets = number_of_datasets - 2
    Update_Query = Array(String, (number_of_datasets))
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
    for i=1 : (number_of_datasets)
      Update_Query[i] = "UPDATE Employee SET Name='$(varcha[i])', Salary=$(rfloat[i]), LastLogin='$(datetime[i])', OfficeNo=$(tint[i]), JobType='$(enume[i])', h=$(mint[i]), n=$(rint[i]), z=$(bint[i]), z1=$(dfloat[i]), z2=$(dpfloat[i]), cha='$(chara[i])', empno=$(sint[i]) where ID = $i;"
    end
    return Update_Query
  elseif(dbms=="Oracle")
    number_of_datasets = number_of_datasets - 2
    Update_Query = Array(String, (number_of_datasets))
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
    for i=1 : (number_of_datasets)
      Update_Query[i] = "UPDATE $Oracle_table_name SET Name='$(varcha[i])', Salary=$(rfloat[i]), LastLogin=TO_DATE('$(datetime[i])', 'yyyy-mm-dd hh24:mi:ss'), OfficeNo=$(tint[i]), JobType='$(enume[i])', h=$(mint[i]), n=$(rint[i]), z=$(bint[i]), z1=$(dfloat[i]), z2=$(dpfloat[i]), cha='$(chara[i])', empno=$(sint[i]) where ID = $i"
    end
    return Update_Query
  end
end


function mysql_benchmarks(queries,key,use_prepare=0)
  global output_string
  try
    conn = mysql_connect(MySQL_Host, MySQL_Username, MySQL_Password, MySQL_Database)
  catch
    println("MySQL.jl: MySQL connection failed")
    output_string = "$output_string MySQL.jl: MySQL connection failed\n"
    return
  end
  conn = mysql_connect(MySQL_Host, MySQL_Username, MySQL_Password, MySQL_Database)
  if key == "Insert"
    delete_table("MySQL.jl",conn)
  end
  println("Time taken by MySQL wrapper for operation $key is")
  if use_prepare ==1
    stmt = mysql_stmt_init(conn)
    temp = @elapsed @time for i = 1:size(queries,1)
      mysql_stmt_prepare(stmt, queries[i])
      mysql_stmt_execute(stmt)
    end
    output_string = "$output_string Time taken by MySQL wrapper for operation $key is $temp seconds\n"
    mysql_stmt_close(stmt)
  else
    temp = @elapsed @time for i = 1:size(queries,1)
      mysql_execute_query(conn, queries[i])
    end
    output_string = "$output_string Time taken by MySQL wrapper for operation $key is $temp seconds\n"
  end
  println("Time taken for retrieving all the Inserted or Updated records by MySQL wrapper is ")
  temp = @elapsed @time MySQL.mysql_execute_query(conn, "select * from Employee")
  output_string = "$output_string Time taken by MySQL wrapper for retrieving all the values after operation $key is $temp seconds\n"
  mysql_disconnect(conn)
end

function odbc_benchmarks(queries,key,dbms="MySQL")
  global output_string
  if dbms=="MySQL"
    try
      conn = ODBC.connect(MySQL_DSN, usr = MySQL_Username, pwd = MySQL_Password)
      ODBC.disconnect(conn)
    catch
      println("ODBC.jl: MySQL connection failed")
      output_string = "$output_string ODBC.jl: MySQL connection failed\n"
      return
    end
    conn = ODBC.connect(MySQL_DSN, usr = MySQL_Username, pwd = MySQL_Password)
    if key == "Insert"
      delete_table("ODBC.jl",conn)
    end
  elseif dbms == "Oracle"
    try
      conn = ODBC.connect(Oracle_DSN,usr=Oracle_Username,pwd=Oracle_Password)
    catch
      println("ODBC.jl: Oracle connection failed")
      output_string = "$output_string ODBC.jl: Oracle connection failed\n"
      return
    end
    conn = ODBC.connect(Oracle_DSN,usr=Oracle_Username,pwd=Oracle_Password)
    if key == "Insert"
      delete_table("ODBC.jl",conn,Oracle_table_name)
    end
  end
	println("Time taken by ODBC wrapper for operation $key is")
	temp = @elapsed @time for i = 1:size(queries,1)-3
		ODBC.query(queries[i])
	end
  output_string = "$output_string Time taken by ODBC wrapper for operation $key is $temp seconds\n"
  println("Time taken for retrieving all the Inserted or Updated records by ODBC wrapper is")
  temp = @elapsed @time ODBC.query("select * from $Oracle_table_name")
  output_string = "$output_string Time taken by ODBC wrapper for retrieving all the values after operation $key is $temp seconds\n"
  ODBC.disconnect(conn)
end

function JDBC_init(dbms="MySQL")
  global output_string
  if dbms == "MySQL"
    try
      JavaCall.addClassPath(JDBC_MySQL_Class_Path)
      JDBC.init()
      props = ["user"=> JDBC_MySQL_Username, "password" => JDBC_MySQL_Password]
      conn = DriverManager.getConnection(MySQL_JDBC_URL, props)
      stmt = createStatement(conn)
      delete_table("JDBC.jl",stmt)
      return stmt
    catch
      println("JDBC.jl: MySQL connection failed")
      output_string = "$output_string JDBC.jl: MySQL connection failed\n"
      return 0
    end
  elseif dbms == "Oracle"
    try
      classPath = JDBC_Oracle_Connector_Path
      url = Oracle_JDBC_URL
      JavaCall.addClassPath(classPath)
      JDBC.init()
      props = ["user" => JDBC_Oracle_Username, "password" => JDBC_Oracle_Password]
      conn = DriverManager.getConnection(url, props)
      stmt = createStatement(conn)
      delete_table("JDBC.jl",stmt, Oracle_table_name)
      return stmt
    catch
      println("JDBC.jl: Oracle connection failed")
      output_string = "$output_string JDBC.jl: Oracle connection failed\n"
      return 0
    end
  end
end

function jdbc_benchmarks(queries, key, stmt,dbms)
  global output_string
	println("Time taken by JDBC for operation $key is : ")
	temp = @elapsed @time begin
		for i = 1:size(queries,1)
			executeUpdate(stmt, queries[i])
		end
	end
  output_string = "$output_string Time taken by JDBC wrapper for operation $key is $temp seconds\n"
	println("Time taken for retrieving all the Inserted or Updated records by JDBC wrapper is")
  if dbms == "Oracle"
    tmp = @elapsed @time begin
      rs = executeQuery(stmt, "select * from $Oracle_table_name")
      JDBC_retrieved = readtable(rs)
      #JDBC.jl is not extracting floating point numbers from Oracle, hence following steps
      i=1
      for r in rs
         JDBC_retrieved[:Z2][i] = getFloat(r,"z2")
         JDBC_retrieved[:Z][i] = getFloat(r,"z")
         JDBC_retrieved[:Z1][i] = getFloat(r,"z1")
         JDBC_retrieved[:SALARY][i] = getFloat(r,"Salary")
         i=i+1
      end
    end
    output_string = "$output_string Time taken by JDBC wrapper for retrieving all the values after operation $key is $tmp seconds\n"
  end

  if dbms == "MySQL"
    tmp=@elapsed @time begin
      rs = executeQuery(stmt, "select ID, Name, Salary, LastLogin, OfficeNo, JobType,h, n, z, z1, z2, cha from Employee")
      JDBC_retrieved = readtable(rs)
      #JDBC.jl is not extracting column empno from MySQL, hence following steps
      i=1
      temp = fill(0,size(JDBC_retrieved)[1])
      rs = executeQuery(stmt, "select empno from Employee")
      for r in rs
           temp[i] = getInt(r,"empno")
           i = i+1
      end
      JDBC_retrieved[:empno] = temp
    end
    output_string = "$output_string Time taken by JDBC wrapper for retrieving all the values after operation $key is $tmp seconds\n"
  end
end


function postgres_benchmarks(queries, key)
  global output_string
  try
	  conn = PostgreSQL.connect(Postgres,PostGres_Host,  PostGres_Username, PostGres_Password, PostGres_Database, PostGres_Port_number)
  catch
    println("PostgreSQL connection failed")
    output_string = "$output_string PostgreSQL.jl: PostgreSQL connection failed\n"
    return
  end
  conn = PostgreSQL.connect(Postgres,PostGres_Host,  PostGres_Username, PostGres_Password, PostGres_Database, PostGres_Port_number)
  if key == "Insert"
      delete_table("PostgreSQL.jl",conn)
  end
	println("Time taken by PostGres for operation $key is : ")
	temp = @elapsed @time begin
		for i = 1:size(queries,1)
			stmt = PostgreSQL.prepare(conn, queries[i])
			PostgreSQL.execute(stmt)
      PostgreSQL.finish(stmt)
		end
	end
  output_string = "$output_string Time taken by PostGres for operation $key is $temp\n"
	println("Time taken for retrieving all the Inserted or Updated records by PostGres wrapper is")
	temp = @elapsed @time fetchdf(PostgreSQL.execute(PostgreSQL.prepare(conn, "select * from Employee")))
  output_string = "$output_string Time taken by PostGres wrapper for retrieving all the values after operation $key is $temp seconds\n"
	PostgreSQL.disconnect(conn)
end

number_of_datasets = number_of_datasets+2

function delete_table(dbms_wrapper,conn,table_name="Employee")
  if dbms_wrapper=="MySQL.jl"
    try
      mysql_execute_query(conn,"drop table mysqltest1.Employee")
    catch
      return
    end
  elseif dbms_wrapper == "ODBC.jl"
    try
      ODBC.query("drop table $table_name")
    catch
      return
    end
  elseif dbms_wrapper == "PostgreSQL.jl"
    try
      stmt = PostgreSQL.prepare(conn, "drop table Employee")
			PostgreSQL.execute(stmt)
      PostgreSQL.finish(stmt)
    catch
      return
    end
  elseif dbms_wrapper == "JDBC.jl"
    try
      executeUpdate(stmt,"drop table $table_name")
    catch
      return
    end
  end
end
