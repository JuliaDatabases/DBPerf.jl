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
  Insert_Query = Array(String, (number_of_datasets+2))
  if dbms=="MySQL"
    Insert_Query[1] = "CREATE TABLE Employee(ID INT NOT NULL AUTO_INCREMENT, Name VARCHAR(4000), Salary FLOAT, LastLogin DATETIME, OfficeNo TINYINT, JobType ENUM('HR', 'Management', 'Accounts'), h MEDIUMINT, n INTEGER, z BIGINT, z1 DOUBLE, z2 DOUBLE PRECISION, cha CHAR, empno SMALLINT, PRIMARY KEY (ID));"
    Insert_Query[2] = "CREATE UNIQUE INDEX id_idx ON Employee(ID);"
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
    for i=1 :(number_of_datasets)
      Insert_Query[i+2] = "INSERT INTO Employee (Name, Salary, LastLogin, OfficeNo, JobType,h, n, z, z1, z2, cha, empno) VALUES ('$(varcha[i])', $(rfloat[i]), '$(datetime[i])', $(tint[i]), '$(enume[i])', $(mint[i]), $(rint[i]), $(bint[i]), $(dfloat[i]), $(dpfloat[i]), '$(chara[i])', $(sint[i]));"
    end
    return Insert_Query, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint
  end
  if dbms=="Oracle"
    Insert_Query[1] = "CREATE TABLE $Oracle_table_name(ID INT, Name VARCHAR(4000), Salary FLOAT, LastLogin DATE, OfficeNo NUMBER(4), JobType VARCHAR2(20) CHECK( JobType IN ('HR', 'Management', 'Accounts')), h NUMBER(8), n NUMBER(11), z NUMBER(20), z1 FLOAT(25), z2 FLOAT(25), cha CHAR, empno NUMBER(6))"
    Insert_Query[2] = "create unique index id_idx on $Oracle_table_name(ID)"
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
    for i=1 :(number_of_datasets)
      Insert_Query[i+2] = "INSERT INTO $Oracle_table_name (ID, Name, Salary, LastLogin, OfficeNo, JobType,h, n, z, z1, z2, cha, empno) VALUES ($(i), '$(varcha[i])', $(rfloat[i]), TO_DATE('$(datetime[i])', 'yyyy-mm-dd hh24:mi:ss'), $(tint[i]), '$(enume[i])', $(mint[i]), $(rint[i]), $(bint[i]), $(dfloat[i]), $(dpfloat[i]), '$(chara[i])', $(sint[i]))"
    end
    return Insert_Query, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint
  end
  if dbms == "PostgreSQL"
    Insert_Query[1] = "CREATE TABLE Employee(ID bigserial, Name VARCHAR(4000), Salary decimal, LastLogin timestamp, OfficeNo smallint, JobType VARCHAR(20) CHECK( JobType IN ('HR', 'Management', 'Accounts')), h integer, n bigint, z bigint, z1 double precision, z2 double precision, cha CHAR, empno integer)"
    Insert_Query[2] = "create unique index id_idx on Employee(ID)"
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
  	for i=1 : (number_of_datasets)
		  Insert_Query[i+2] = "INSERT INTO Employee (ID, Name, Salary, LastLogin, OfficeNo, JobType,h, n, z, z1, z2, cha, empno) VALUES ($(i), '$(varcha[i])', $(rfloat[i]), '$(datetime[i])', $(tint[i]), '$(enume[i])', $(mint[i]), $(rint[i]), $(bint[i]), $(dfloat[i]), $(dpfloat[i]), '$(chara[i])', $(sint[i]));"
  	end
	  return Insert_Query, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint
  end

  if dbms == "SQLite"
    Insert_Query[1] = "CREATE TABLE $SQLite_table (ID INTEGER, Name TEXT, Salary REAL, LastLogin NUMERIC, OfficeNo INTEGER, JobType TEXT,h INTEGER, n INTEGER, z INTEGER, z1 REAL, z2 REAL, cha TEXT, empno INTEGER)"
    Insert_Query[2] = "CREATE UNIQUE INDEX index_ID ON $SQLite_table (ID)"
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
  	for i=1 : (number_of_datasets)
		  Insert_Query[i+2] = "INSERT INTO $SQLite_table (ID, Name, Salary, LastLogin, OfficeNo, JobType,h, n, z, z1, z2, cha, empno) VALUES ($(i), '$(varcha[i])', $(rfloat[i]), '$(datetime[i])', $(tint[i]), '$(enume[i])', $(mint[i]), $(rint[i]), $(bint[i]), $(dfloat[i]), $(dpfloat[i]), '$(chara[i])', $(sint[i]));"
  	end
	  return Insert_Query, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint
  end
end

function update_queries(number_of_datasets=10000,dbms="MySQL")
  if dbms=="SQLite"
    Update_Query = Array(String, (number_of_datasets))
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
    for i=1 : (number_of_datasets)
      Update_Query[i] = "UPDATE $SQLite_table SET Name='$(varcha[i])', Salary=$(rfloat[i]), LastLogin='$(datetime[i])', OfficeNo=$(tint[i]), JobType='$(enume[i])', h=$(mint[i]), n=$(rint[i]), z=$(bint[i]), z1=$(dfloat[i]), z2=$(dpfloat[i]), cha='$(chara[i])', empno=$(sint[i]) where ID = $i;"
    end
    return Update_Query, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint
  end
  if (dbms=="MySQL" || dbms=="PostgreSQL")
    Update_Query = Array(String, (number_of_datasets))
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
    for i=1 : (number_of_datasets)
      Update_Query[i] = "UPDATE Employee SET Name='$(varcha[i])', Salary=$(rfloat[i]), LastLogin='$(datetime[i])', OfficeNo=$(tint[i]), JobType='$(enume[i])', h=$(mint[i]), n=$(rint[i]), z=$(bint[i]), z1=$(dfloat[i]), z2=$(dpfloat[i]), cha='$(chara[i])', empno=$(sint[i]) where ID = $i;"
    end
    return Update_Query, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint
  elseif(dbms=="Oracle")
    Update_Query = Array(String, (number_of_datasets))
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
    for i=1 : (number_of_datasets)
      Update_Query[i] = "UPDATE $Oracle_table_name SET Name='$(varcha[i])', Salary=$(rfloat[i]), LastLogin=TO_DATE('$(datetime[i])', 'yyyy-mm-dd hh24:mi:ss'), OfficeNo=$(tint[i]), JobType='$(enume[i])', h=$(mint[i]), n=$(rint[i]), z=$(bint[i]), z1=$(dfloat[i]), z2=$(dpfloat[i]), cha='$(chara[i])', empno=$(sint[i]) where ID = $i"
    end
    return Update_Query, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint
  end
end


function mysql_benchmarks(queries,key)
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
  temp = @elapsed @time for i = 1:size(queries,1)
    mysql_execute_query(conn, queries[i])
  end
  output_string = "$output_string Time taken by MySQL wrapper for operation $key is $temp seconds\n"
  println("Time taken for retrieving all the Inserted or Updated records by MySQL wrapper is ")
  temp = @elapsed @time retrieved = MySQL.mysql_execute_query(conn, "select ID, Name, Salary, DATE_FORMAT(LastLogin, '%Y-%m-%d %H:%i:%S'), OfficeNo, JobType,h, n, z, z1, z2, cha, empno from Employee")
  output_string = "$output_string Time taken by MySQL wrapper for retrieving all the values after operation $key is $temp seconds\n"
  mysql_disconnect(conn)
  return retrieved
end

function odbc_benchmarks(queries,key,dbms)
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
      ODBC.disconnect(conn)
    catch
      println("ODBC.jl: Oracle connection failed")
      output_string = "$output_string ODBC.jl: Oracle connection failed\n"
      return
    end
    conn = ODBC.connect(Oracle_DSN,usr=Oracle_Username,pwd=Oracle_Password)
    if key == "Insert"
      delete_table("ODBC.jl",conn,Oracle_table_name)
    end
  elseif dbms == "PostGres"
    try
      conn = ODBC.connect(ODBC_PostGres_dsn,usr=ODBC_PostGres_username,pwd=ODBC_PostGres_password)
      ODBC.disconnect(conn)
    catch
      println("ODBC.jl: PostGres connection failed")
      output_string = "$output_string ODBC.jl: PostGres connection failed\n"
      return
    end
    conn = ODBC.connect(ODBC_PostGres_dsn,usr=ODBC_PostGres_username,pwd=ODBC_PostGres_password)
    if key == "Insert"
      delete_table("ODBC.jl",conn)
    end
  end
	println("Time taken by ODBC wrapper for operation $key is")
	temp = @elapsed @time for i = 1:size(queries,1)
		ODBC.query(queries[i])
	end
  output_string = "$output_string Time taken by ODBC wrapper for operation $key is $temp seconds\n"
  println("Time taken for retrieving all the Inserted or Updated records by ODBC wrapper is")
  if dbms == "MySQL"
    temp = @elapsed @time retrieved = ODBC.query("select ID, Name, Salary, DATE_FORMAT(LastLogin, '%Y-%m-%d %H:%i:%S'), OfficeNo, JobType,h, n, z, z1, z2, cha, empno from Employee")
  elseif dbms == "Oracle"
    temp = @elapsed @time retrieved = ODBC.query("select ID, Name, Salary, to_char(LastLogin, 'yyyy-mm-dd hh24:mi:ss'), OfficeNo, JobType, h, to_char(n), to_char(z), z1, z2, cha, empno from $Oracle_table_name ORDER BY ID")
  elseif dbms == "PostGres"
    temp = @elapsed @time retrieved = ODBC.query("select ID, Name, Salary, to_char(LastLogin, 'yyyy-mm-dd hh24:mi:ss'), OfficeNo, JobType,h, n, z, z1, z2, cha, empno from Employee ORDER BY ID")
  end
  output_string = "$output_string Time taken by ODBC wrapper for retrieving all the values after operation $key is $temp seconds\n"
  ODBC.disconnect(conn)
  return retrieved
end

function JDBC_init(dbms="MySQL")
  global output_string
  if dbms == "MySQL"
    try
      JavaCall.addClassPath(JDBC_MySQL_Class_Path)
      JDBC.init()
      props = Dict("user"=> JDBC_MySQL_Username, "password" => JDBC_MySQL_Password)
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
      JavaCall.addClassPath(JDBC_Oracle_Connector_Path)
      JDBC.init()
      props = Dict("user" => JDBC_Oracle_Username, "password" => JDBC_Oracle_Password)
      conn = DriverManager.getConnection(Oracle_JDBC_URL, props)
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
      rs = executeQuery(stmt, "select ID, Name, Salary, to_char(LastLogin, 'yyyy-mm-dd hh24:mi:ss'), OfficeNo, JobType, h, to_char(n), to_char(z), z1, z2, cha, empno from $Oracle_table_name ORDER BY ID")
      JDBC_retrieved = readtable(rs)
    end
    output_string = "$output_string Time taken by JDBC wrapper for retrieving all the values after operation $key is $tmp seconds\n"
    return JDBC_retrieved
  end

  if dbms == "MySQL"
    tmp=@elapsed @time begin
      rs = JDBC.executeQuery(stmt, "select ID, Name, Salary, DATE_FORMAT(LastLogin, '%Y-%m-%d %H:%i:%S'), OfficeNo, JobType,h, n, z, z1, z2, cha, empno from Employee")
      JDBC_retrieved = readtable(rs)
    end
    output_string = "$output_string Time taken by JDBC wrapper for retrieving all the values after operation $key is $tmp seconds\n"
    return JDBC_retrieved
  end
end


function postgres_benchmarks(queries, key)
  global output_string
  try
	  conn = PostgreSQL.connect(Postgres, PostGres_Host,  PostGres_Username, PostGres_Password, PostGres_Database, PostGres_Port_number)
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
	temp = @elapsed @time retrieved = fetchdf(PostgreSQL.execute(PostgreSQL.prepare(conn, "select * from Employee order by id")))
  output_string = "$output_string Time taken by PostGres wrapper for retrieving all the values after operation $key is $temp seconds\n"
	PostgreSQL.disconnect(conn)
  return retrieved
end


function delete_table(dbms_wrapper,conn,table_name="Employee")
  if dbms_wrapper=="MySQL.jl"
    try
      mysql_execute_query(conn,"drop table $(MySQL_Database).$(table_name)")
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
      stmt = PostgreSQL.prepare(conn, "drop table $table_name")
			PostgreSQL.execute(stmt)
      PostgreSQL.finish(stmt)
    catch
      return
    end
  elseif dbms_wrapper == "JDBC.jl"
    try
      JDBC.executeUpdate(conn,"drop table $table_name")
    catch
      return
    end
  elseif dbms_wrapper == "SQLite.jl"
    try
      SQLite.query(conn,"drop table $table_name")
    catch
      return
    end
  end
end

function mongo_benchmarks(user_choice="")
  global output_string
  old_output_string = output_string
  client = MongoClient(Mongo_Host,Mongo_Port)
  handle = MongoCollection(client, "temp_db","DBPerf")

  if ("MongoUpdate" in user_choice) || ("MongoUpdate" in ARGS)
    #Update
    varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
    temp=@elapsed @time for i = 1 : number_of_datasets
      Mongo.update(handle,"ID" => i,Mongo.set("ID" => i, "Name" =>(varcha[i]), "Salary" =>(rfloat[i]), "LastLogin" =>(datetime[i]), "OfficeNo" =>(tint[i]), "JobType" =>(enume[i]), "h" =>(mint[i]), "n" =>(rint[i]), "z" =>(bint[i]), "z1" =>(dfloat[i]), "z2" =>(dpfloat[i]), "cha" =>(chara[i]), "empno" =>(sint[i])))
    end
    output_string = "$output_string Time taken by Mongo.jl for Operation Update is $temp\n"
    println("Time taken by Mongo.jl for Operation Update is $temp\n")

    #Retrieving records
    Cursor = Mongo.find(handle,Mongo.query())
    Mongo_retrieved = BSONObject[]
    temp=@elapsed @time for i in Cursor
         push!(Mongo_retrieved,i)
    end

      #Cross checking the retrieved values
    Cursor = Mongo.find(handle,(Mongo.query(),Mongo.orderby("ID" => 1)))
    flag = Bool[]
    j=1
    for i in Cursor
      push!(flag,i["ID"] == j)
      push!(flag,i["Name"] == varcha[j])
      push!(flag,i["Salary"] == rfloat[j])
      push!(flag,i["LastLogin"] == datetime[j])
      push!(flag,i["OfficeNo"] ==tint[j])
      push!(flag, i["JobType"] ==enume[j])
      push!(flag, i["h"] ==mint[j])
      push!(flag, i["n"] ==rint[j])
      push!(flag, i["z"] ==bint[j])
      push!(flag, i["z1"] ==dfloat[j])
      push!(flag, i["z2"] ==dpfloat[j])
      push!(flag,  i["cha"] ==chara[j])
      push!(flag, i["empno"] ==sint[j])
      j = j+1
    end
    for i in flag
      if !i
        output_string = old_output_string
        output_string = "$output_string Mongo.jl: Operation Update failed the validation test\n"
        println("Mongo.jl: Operation Update failed the validation test")
        return
      end
    end
    println("Mongo.jl passed the Validation test on operation Update")
    output_string = "$output_string Mongo.jl passed the Validation test on operation Update\n"
    output_string = "$output_string Time taken by Mongo.jl for retrieving all the Updated records is $temp\n"
    println("Time taken by Mongo.jl for retrieving all the Updated records is $temp\n")
    return
  end

  #Delete
  Mongo.delete(handle, ())

  #Insert
  varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = create_queries(number_of_datasets)
  temp=@elapsed @time for i=1 : number_of_datasets
    Mongo.insert(handle, ("ID" => i, "Name" =>(varcha[i]), "Salary" =>(rfloat[i]), "LastLogin" =>(datetime[i]), "OfficeNo" =>(tint[i]), "JobType" =>(enume[i]), "h" =>(mint[i]), "n" =>(rint[i]), "z" =>(bint[i]), "z1" =>(dfloat[i]), "z2" =>(dpfloat[i]), "cha" =>(chara[i]), "empno" =>(sint[i])))
  end
  output_string = "$output_string Time taken by Mongo.jl for operation Insert is $temp\n"
  println("Time taken by Mongo.jl for operation Insert is $temp\n")

  #Retrieving records after Insert
  #Cursor = Mongo.find(handle,Mongo.query())
  Cursor = Mongo.find(handle,(Mongo.query(),Mongo.orderby("ID" => 1)))
  temp=@elapsed @time for i in Cursor
       Mongo_retrieved =  i
  end
  #Cross checking the retrieved values
  Cursor = Mongo.find(handle,(Mongo.query(),Mongo.orderby("ID" => 1)))
  flag = Bool[]
  j=1
  for i in Cursor
    push!(flag,i["ID"] == j)
    push!(flag,i["Name"] == varcha[j])
    push!(flag,i["Salary"] == rfloat[j])
    push!(flag,i["LastLogin"] == datetime[j])
    push!(flag,i["OfficeNo"] ==tint[j])
    push!(flag, i["JobType"] ==enume[j])
    push!(flag, i["h"] ==mint[j])
    push!(flag, i["n"] ==rint[j])
    push!(flag, i["z"] ==bint[j])
    push!(flag, i["z1"] ==dfloat[j])
    push!(flag, i["z2"] ==dpfloat[j])
    push!(flag,  i["cha"] ==chara[j])
    push!(flag, i["empno"] ==sint[j])
    j = j+1
  end

  for i in flag
    if !i
      output_string = old_output_string
      output_string = "$output_string Mongo.jl: Operation Insert failed the validation test\n"
      println("Mongo.jl: Operation Insert failed the validation test")
      return
    end
  end
  println("Mongo.jl passed the Validation test on operation Insert")
  output_string = "$output_string Mongo.jl passed the Validation test on operation Insert\n"
  output_string = "$output_string Time taken by Mongo.jl for retrieving all the Inserted records is $temp\n"
  println("Time taken by Mongo.jl for retrieving all the Inserted records is $temp\n\n")
  output_string = "$output_string \n\nNOTE:- Inorder to perform update operation on Mongo.jl, please Index the key <ID> in Mongo shell and rerun this program with following parameter: MongoUpdate\n"
  output_string = "$output_string \n\n\t\t\t Example \n\n Step 1:- \$ julia DBPerf.jl Mongo.jl \n Step 2:- Create Index for key ID in Mongo shell \n\t\t \$mongo, \n\t\t mongo> use temp_db, \n\t\t mongo> db.DBPerf.ensureIndex({ID : 1})  \n Step 3:- \$ julia DBPerf.jl MongoUpdate \n"
  output_string = "$output_string \n\n\tIf you're executing this program through Julia prompt then\n\n"
  output_string = "$output_string Step 1:- julia> DBPerf(\"Mongo.jl\") \n Step 2:- Create Index for key ID in Mongo shell \n Step 3:- julia> DBPerf(\"MongoUpdate\")  \n"
end

function sqlite_benchmarks(queries,db,user_choice="")
  global output_string
  temp=@elapsed @time for i in queries
         SQLite.query(db,i)
  end
  output_string = "$output_string Time taken by SQLite.jl for operation $user_choice is $temp Seconds\n"
  println("Time taken by SQLite.jl for operation $user_choice is $temp Seconds\n")
  println("Time taken by SQLite.jl for retrieving all the records after performing operation $user_choice is")
  temp = @elapsed @time begin
    sqlite_retrieved = SQLite.query(db,"select * from $SQLite_table")
    #Inorder to retrieve records from the DataStream, use following syntax sqlite_retrieved.data[Index_number], where Index_number can range from 1 to 13 in this case
  end
  output_string = "$output_string Time taken by SQLite.jl for retrieving all the records after performing operation $user_choice is $temp Seconds\n"
  return sqlite_retrieved
end

function display_errors(number_of_errors, retrieved_names)
  global output_string
  for i=1 : length(retrieved_names)
    if number_of_errors[i] > 0
      output_string = "$output_string Over $(number_of_errors[i]) value(s) out of $number_of_datasets values from column $(retrieved_names[i]) did not match the inserted data. \n"
      println("Over $(number_of_errors[i]) value(s) out of $number_of_datasets values from column $(retrieved_names[i]) did not match the inserted data.")
    end
  end
end

function datatype_conversions(database_and_driver, retrieved, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint)
  # DBMS's are inconsistent in maintaining the data types and data formats, hence we need to normalize the retrieved data before performing a validation test on them.
  for i =1 : number_of_datasets
     retrieved[3][i] = Float16(retrieved[3][i])
     retrieved[10][i] = Float32(retrieved[10][i])
  end
  # Oracle sends all the Integers in exponential form, so we are retrieving them as String and converting them to Integer in here for comparison
  if database_and_driver == "Oracle_JDBC.jl" || database_and_driver == "Oracle_ODBC.jl"
    temp1 = fill(0,number_of_datasets)
    temp = fill(0,number_of_datasets)
    for i=1 : number_of_datasets
      temp[i] = parse(Int,retrieved[8][i])
      temp1[i] = parse(Int,retrieved[9][i])
    end
    retrieved[8] = temp
    retrieved[9] = temp1
  end
  return retrieved, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint
end

function compare_retrieved(database_and_driver, operation, retrieved, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint, float_tolerance, double_tolerance)
  number_of_errors = fill(0,13)
  global output_string
  if database_and_driver == "SQLite.jl"
    for i=1 : number_of_datasets
      if retrieved.data[1][i].value != i
        number_of_errors[1] = number_of_errors[1] + 1
      end
      if retrieved.data[2][i].value != varcha[i]
        number_of_errors[2] = number_of_errors[2] + 1
      end
      if Float16(retrieved.data[3][i].value) != rfloat[i]
        number_of_errors[3] = number_of_errors[3] + 1
      end
      if (retrieved.data[4][i].value) != datetime[i]
        number_of_errors[4] = number_of_errors[4] + 1
      end
      if (retrieved.data[5][i].value) != tint[i]
        number_of_errors[5] = number_of_errors[5] + 1
      end
      if (retrieved.data[6][i].value) != enume[i]
        number_of_errors[6] = number_of_errors[6] + 1
      end
      if (retrieved.data[7][i].value) != mint[i]
        number_of_errors[7] = number_of_errors[7] + 1
      end
      if (retrieved.data[8][i].value) != rint[i]
        number_of_errors[8] = number_of_errors[8] + 1
      end
      if (retrieved.data[9][i].value) != bint[i]
        number_of_errors[9] = number_of_errors[9] + 1
      end
      if Float32(retrieved.data[10][i].value) != dfloat[i]
        number_of_errors[10] = number_of_errors[10] + 1
      end
      if (retrieved.data[11][i].value) != dpfloat[i]
        number_of_errors[11] = number_of_errors[11] + 1
      end
      if (retrieved.data[12][i].value) != chara[i]
        number_of_errors[12] = number_of_errors[12] + 1
      end
      if (retrieved.data[13][i].value) != sint[i]
        number_of_errors[13] = number_of_errors[13] + 1
      end
    end
    if sum(number_of_errors) == 0
      output_string = "$output_string $database_and_driver : Operation $operation passed the validation test\n"
      return true
    else
      output_string = "$output_string $database_and_driver : Operation $operation failed the validation test\n"
      println("$database_and_driver: Operation $operation failed the validation test")
      display_errors(number_of_errors, names(retrieved))
      output_string = "$output_string \n"
      return false
    end
  end
  retrieved, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = datatype_conversions(database_and_driver, retrieved, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint)
  for i=1 : number_of_datasets
      if retrieved[1][i] != i
        number_of_errors[1] = number_of_errors[1] +1
      end
      if retrieved[2][i] != varcha[i]
        number_of_errors[2] = number_of_errors[2] +1
      end
      if round(retrieved[3][i],float_tolerance) != round(rfloat[i], float_tolerance)
        number_of_errors[3] = number_of_errors[3] +1
      end
      if retrieved[4][i] != datetime[i]
        number_of_errors[4] = number_of_errors[4] +1
      end
      if retrieved[5][i] != tint[i]
        number_of_errors[5] = number_of_errors[5] +1
      end
      if retrieved[6][i] != enume[i]
        number_of_errors[6] = number_of_errors[6] +1
      end
      if retrieved[7][i] != mint[i]
        number_of_errors[7] = number_of_errors[7] +1
      end
      if retrieved[8][i] !=  rint[i]
        number_of_errors[8] = number_of_errors[8] +1
      end
      if retrieved[9][i] != bint[i]
        number_of_errors[9] = number_of_errors[9] +1
      end
      if round(retrieved[10][i],float_tolerance) != round(dfloat[i],float_tolerance)
        number_of_errors[10] = number_of_errors[10] +1
      end
      if round(retrieved[11][i], double_tolerance) != round(dpfloat[i], double_tolerance)
        number_of_errors[11] = number_of_errors[11] +1
      end
      if retrieved[12][i] != chara[i]
        number_of_errors[12] = number_of_errors[12] +1
      end
      if retrieved[13][i] != sint[i]
        number_of_errors[13] = number_of_errors[13] +1
      end
    end
    if sum(number_of_errors) == 0
      output_string = "$output_string $database_and_driver : Operation $operation passed the validation test\n"
      return true
    else
      output_string = "$output_string $database_and_driver : Operation $operation failed the validation test\n"
      println("$database_and_driver: Operation $operation failed the validation test")
      display_errors(number_of_errors, names(retrieved))
      output_string = "$output_string \n"
      return false
    end























  #=
  # Saving all the datatypes of inserted values


  if !datatype_tolerance
    for i=1 : number_of_datasets
      if retrieved[1][i] != i
        number_of_errors[1] = number_of_errors[1] +1
        expected_datatype[i] = typeof(i)
      end
      if retrieved[2][i] != varcha[i]
        number_of_errors[2] = number_of_errors[2] +1
        expected_datatype[i] = typeof(varcha[i])
      end
      if retrieved[3][i] != rfloat[i]
        number_of_errors[3] = number_of_errors[3] +1
        expected_datatype[i] = typeof(rfloat[i])
      end
      if retrieved[4][i] != datetime[i]
        number_of_errors[4] = number_of_errors[4] +1
        expected_datatype[i] = typeof(datetime[i])
      end
      if retrieved[5][i] != tint[i]
        number_of_errors[5] = number_of_errors[5] +1
        expected_datatype[i] = typeof(tint[i])
      end
      if retrieved[6][i] != enume[i]
        number_of_errors[6] = number_of_errors[6] +1
        expected_datatype[i] = typeof(enume[i])
      end
      if retrieved[7][i] != mint[i]
        number_of_errors[7] = number_of_errors[7] +1
        expected_datatype[i] = typeof(mint[i])
      end
      if retrieved[8][i] !=  rint[i]
        number_of_errors[8] = number_of_errors[8] +1
        expected_datatype[i] = typeof(rint[i])
      end
      if retrieved[9][i] != bint[i]
        number_of_errors[9] = number_of_errors[9] +1
        expected_datatype[i] = typeof(bint[i])
      end
      if retrieved[10][i] != dfloat[i]
        number_of_errors[10] = number_of_errors[10] +1
        expected_datatype[i] = typeof(dfloat[i])
      end
      if retrieved[11][i] != dpfloat[i]
        number_of_errors[11] = number_of_errors[11] +1
        expected_datatype[i] = typeof(dpfloat[i])
      end
      if retrieved[12][i] != chara[i]
        number_of_errors[12] = number_of_errors[12] +1
        expected_datatype[i] = typeof(chara[i])
      end
      if retrieved[13][i] != sint[i]
        number_of_errors[13] = number_of_errors[13] +1
        expected_datatype[i] = typeof(sint[i])
      end
    end
    if sum(number_of_errors) == 0
      output_string = "$output_string JDBC.jl: Operation Insert passed the validation test\n"
      return true
    else
      output_string = "$output_string JDBC.jl: Operation Insert failed the validation test\n"
      println("JDBC.jl: Operation Insert failed the validation test")
      display_errors(number_of_errors, error_datatype, names(retrieved), expected_datatype)
      return false
    end
  end


  for i=1 : number_of_datasets
       if retrieved[1][i] != i
          return false
       end
  end
  push!(flag,retrieved[2] == varcha)
  for i=1 : length(retrieved[3])
    if !(Float16(retrieved[3][i]) == rfloat[i])
        number_of_errors[3] = number_of_errors[3]+1
    end
  end
  push!(flag,retrieved[5] == tint)
  push!(flag,retrieved[6] == enume)
  push!(flag,retrieved[7] == mint)
  push!(flag,retrieved[8] == rint)
  push!(flag,retrieved[12] == chara)
  push!(flag,retrieved[13] == sint)

  if database_and_driver != "Oracle_ODBC.jl"
    for i=1 : length(retrieved[10])
      if !(Float32(retrieved[10][i]) == dfloat[i]) && !(Float32(retrieved[10][i]) == round(dfloat[i],8))
         return false
      end
    end
  end


  if database_and_driver == "Oracle_JDBC.jl"
    for i=1 : number_of_datasets
      datetime[i].data[11]='T'
      if datetime[i] != string(retrieved[4][i])
        return false
      end
    end
    for i=1 : number_of_datasets
      if string(bint[i]) != retrieved[9][i]
        return false
      end
    end
    for i=1 : number_of_datasets
      if retrieved[11][i] !=  Float32(dpfloat[i])
        return false
      end
    end


  end

  if database_and_driver == "MySQL_JDBC.jl"
    for i=1 : number_of_datasets
      if replace(string(retrieved[4][i]),"T"," ") != datetime[i]
        return false
      end
    end
    push!(flag,retrieved[9] == bint)
    push!(flag,retrieved[11] == dpfloat)
  end

  if database_and_driver == "Oracle_ODBC.jl"

      for i=1 : length(retrieved[10])
        if length(string(retrieved[10][i])) < 15
          rj=length(string(retrieved[10][i]))
        else
          rj = 15
        end
        if length(string(dfloat[i])) < 15
          dj=length(string(dfloat[i]))
        else
          dj = 15
        end
        if rj < dj
          j = rj
        else
          j = dj
        end
        #Adjusting to the rounding laws
        if !(string(retrieved[10][i])[1:j-1] == string(dfloat[i])[1:j-1])  && !(Float32(round(retrieved[10][i],j-2)) == round(dfloat[i],j-2))
            return false
        end
      end

     for i=1 : length(retrieved[4])
      #Removes trailing zeros, requires MySQL.jl
        if !(string(MySQL.MySQLDateTime(datetime[i])) == string(retrieved[4][i]))
            return false
        end
     end

     for i=1 : length(retrieved[9])
         if parse(BigInt,retrieved[9][i]) != bint[i]
              return false
         end
     end

     for i=1 : length(retrieved[11])
      if length(string(retrieved[11][i])) < 15
        rj=length(string(retrieved[11][i]))
      else
        rj = 15
      end
      if length(string(dpfloat[i])) < 15
        dj=length(string(dpfloat[i]))
      else
        dj = 15
      end
      if rj < dj
        j = rj
      else
        j = dj
      end

      if !(string(retrieved[11][i])[1:j] == string(dpfloat[i])[1:j])  && !(round(retrieved[11][i],j-2) == round(dpfloat[i],j-2))
          return false
      end
    end
  else
    push!(flag,retrieved[9] == bint)
  end

  if database_and_driver == ("MySQL.jl")
    for i=1 : length(retrieved[4])
      if !(MySQL.MySQLDateTime(datetime[i]) == retrieved[4][i])
          return false
      end
    end
    for i=1 : length(retrieved[11])
      if !(retrieved[11][i] == dpfloat[i])
          return false
      end
    end
  end

  if database_and_driver == "MySQL_ODBC.jl"
    for i=1 : length(retrieved[4])
      #Removes trailing zeros, requires MySQL.jl
      if !(string(MySQL.MySQLDateTime(datetime[i])) == string(retrieved[4][i]))
          return false
      end
    end
    for i=1 : length(retrieved[11])
      if !(retrieved[11][i] == dpfloat[i])
          return false
      end
    end
  end

  if database_and_driver == ("PostgreSQL.jl")
    for i=1 : length(retrieved[4])
      if !(string(datetime[i]) == retrieved[4][i])
          return false
      end
    end
    for i=1 : length(retrieved[11])
      if length(string(retrieved[11][i])) < 15
        rj=length(string(retrieved[11][i]))
      else
        rj = 15
      end
      if length(string(dpfloat[i])) < 15
        dj=length(string(dpfloat[i]))
      else
        dj = 15
      end
      if rj < dj
        j = rj
      else
        j = dj
      end

      #As per postgresql documentation, double precision type has a precision of 15 digits hence I'm trying to round off to this value while comparing.
      if !(string(retrieved[11][i])[1:j] == string(dpfloat[i])[1:j])  && !(round(retrieved[11][i],15) == round(dpfloat[i],15))
          return false
      end
    end
  end

  for i in flag
    if !i
        return i
    end
  end
  println("Validation test passed")
  return true
  =#
end
