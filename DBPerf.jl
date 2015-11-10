global output_string = ""
include("config.jl")
include("Backend_Create_and_Execute_Dataset.jl")
function DBPerf(a1="",a2="",a3="",a4="",a5="",a6="")
  user_choice = AbstractString[]
  push!(user_choice,a1,a2,a3,a4,a5,a6)
  global output_string = ""
  if a1=="" && a2=="" && a3=="" && a4=="" && a5=="" && a6=="" && length(ARGS)<=0
    output_string = "$output_string Usage: DBPerf(<Database_Driver_1.jl>, <Database_Driver_2.jl>, ....... <Database_Driver_N.jl>, <DBMS>)\n"
    output_string = "$output_string Wherein Database_Driver.jl can be one of the following: ODBC.jl, JDBC.jl, PostgreSQL.jl, MySQL.jl, Mongo.jl, SQLite.jl\n"
    output_string = "$output_string config.jl should contain all the credentials required for a DBMS connection\n"
    output_string = "$output_string DBMS field is applicable only if you're using JDBC.jl, DBMS can be either one of the following: Oracle, MySQL\n"
    output_string = "$output_string Specifying DBMS is mandatory if JDBC.jl is selected, its not required for the rest\n"
    output_string = "\n$output_string \n Example\: DBPerf\(\"ODBC\.jl\",\"JDBC\.jl\",\"Oracle\"\)\n\n"
    output_string = "\n$output_string Above example will conduct a performance test on Database driver ODBC.jl and JDBC.jl, DBMS will be automatically selected for ODBC.jl based on the credentials provided in config.jl, whereas JDBC.jl will be tested against Oracle\n\n\n"
    println("\n\n******************   SUMMARY   ******************\n\n")
    println(output_string)
    println("\n\n******************  END OF SUMMARY   ******************\n\n")
    return
  end

  if ("MySQL.jl" in user_choice) || ("MySQL.jl" in ARGS)
    output_string = "$output_string \n\n *******  MYSQL.jl  ******* \n"
    old_output_string = output_string
    Queries, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = insert_queries(number_of_datasets,"MySQL")
    retrieved = mysql_benchmarks(Queries,"Insert","MySQL")
    println("Cross checking the correctness of retrieved values")
    if !(compare_retrieved("MySQL.jl",retrieved,varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint))
      output_string = old_output_string
      output_string = "$output_string MySQL.jl: Operation Insert failed the validation test\n"
    end

    old_output_string = output_string
    Queries, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = update_queries(number_of_datasets,"MySQL")
    retrieved = mysql_benchmarks(Queries,"Update","MySQL")
    println("Cross checking the correctness of retrieved values")
    if !(compare_retrieved("MySQL.jl",retrieved,varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint))
      output_string = old_output_string
      output_string = "$output_string MySQL.jl: Operation Update failed the validation test\n"
    end
  end

  if ("PostgreSQL.jl" in user_choice) || ("PostgreSQL.jl" in ARGS)
    output_string = "$output_string \n\n *******  PostgreSQL.jl  ******* \n"
    old_output_string = output_string
    Queries, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = insert_queries(number_of_datasets,"PostgreSQL")
    retrieved = postgres_benchmarks(Queries, "Insert")
    println("Cross checking the correctness of retrieved values")
    if !(compare_retrieved("PostgreSQL.jl",retrieved,varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint))
      output_string = old_output_string
      output_string = "$output_string PostgreSQL.jl: Operation Insert failed the validation test\n"
    end
    old_output_string = output_string
    Queries, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = update_queries(number_of_datasets,"PostgreSQL")
    retrieved = postgres_benchmarks(Queries, "Update")
    println("Cross checking the correctness of retrieved values")
    if !(compare_retrieved("PostgreSQL.jl",retrieved,varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint))
      output_string = old_output_string
      output_string = "$output_string PostgreSQL.jl: Operation Update failed the validation test\n"
    end
  end

  if ("ODBC.jl" in user_choice) || ("ODBC.jl" in ARGS)
    output_string = "$output_string \n\n *******  ODBC.jl  ******* \n"
    println("Testing ODBC.jl over MySQL Database")
    output_string = "$output_string       \nTesting ODBC.jl over MySQL Database\n\n"

    old_output_string = output_string
    Queries, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = insert_queries(number_of_datasets,"MySQL")
    retrieved = odbc_benchmarks(Queries,"Insert","MySQL")
    println("Cross checking the correctness of retrieved values")
    if !(compare_retrieved("ODBC.jl",retrieved,varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint))
      output_string = old_output_string
      output_string = "$output_string ODBC.jl: Operation Insert failed the validation test\n"
    end

    old_output_string = output_string
    Queries, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = update_queries(number_of_datasets,"MySQL")
    retrieved = odbc_benchmarks(Queries,"Update","MySQL")
    println("Cross checking the correctness of retrieved values")
    if !(compare_retrieved("ODBC.jl",retrieved,varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint))
      output_string = old_output_string
      output_string = "$output_string ODBC.jl: Operation Update failed the validation test\n"
    end

    println("Testing ODBC.jl over Oracle Database")
    output_string = "\n$output_string       \nTesting ODBC.jl over Oracle Database\n\n"

    old_output_string = output_string
    Queries, varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint = insert_queries(number_of_datasets,"Oracle")
    retrieved = odbc_benchmarks(Queries,"Insert","Oracle")
    println("Cross checking the correctness of retrieved values")
    if !(compare_retrieved("ODBC.jl",retrieved,varcha, rfloat, datetime, tint, enume, mint, rint, bint, dfloat, dpfloat, chara, sint))
      output_string = old_output_string
      output_string = "$output_string ODBC.jl: Operation Insert failed the validation test\n"
    end






    odbc_benchmarks(insert_queries(number_of_datasets,"Oracle"),"Insert","Oracle")
    odbc_benchmarks(update_queries(number_of_datasets,"Oracle"),"Update","Oracle")
  end

  if ("JDBC.jl" in user_choice) || ("JDBC.jl" in ARGS)
    output_string = "$output_string \n\n *******  JDBC.jl  ******* \n"
    if ("MySQL" in user_choice) || ("MySQL" in ARGS)
        println("Testing JDBC.jl over MySQL Database")
        output_string = "$output_string       \nTesting JDBC.jl over MySQL Database\n\n"
        stmt = JDBC_init("MySQL")
        if (stmt != 0)
          jdbc_benchmarks(insert_queries(number_of_datasets,"MySQL"),"Insert",stmt,"MySQL")
          jdbc_benchmarks(update_queries(number_of_datasets,"MySQL"),"Update",stmt,"MySQL")
        end
    elseif ("Oracle" in user_choice) || ("Oracle" in ARGS)
        println("Testing JDBC.jl over Oracle Database")
        output_string = "\n$output_string       \nTesting JDBC.jl over Oracle Database\n\n"
        stmt = JDBC_init("Oracle")
        if (stmt != 0)
          jdbc_benchmarks(insert_queries(number_of_datasets,"Oracle"),"Insert",stmt,"Oracle")
          jdbc_benchmarks(update_queries(number_of_datasets,"Oracle"),"Update",stmt,"Oracle")
        end
    else
      println("Specifying DBMS is mandatory while testing JDBC.jl, DBMS can be either one of the following: Oracle, MySQL")
      output_string = "\n$output_string       \nSpecifying DBMS is mandatory while testing JDBC.jl, DBMS can be either one of the following: Oracle, MySQL\n\n"
    end
  end

  if ("Mongo.jl" in user_choice) || ("Mongo.jl" in ARGS) || ("MongoUpdate" in user_choice) || ("MongoUpdate" in ARGS)
    output_string = "$output_string \n\n *******  Mongo.jl  ******* \n"
    mongo_benchmarks(user_choice)
  end

  if ("SQLite.jl" in user_choice) || ("SQLite.jl" in ARGS)
    output_string = "$output_string \n\n *******  SQLite.jl  ******* \n"
    db = SQLite.DB(SQLite_DBname)
    delete_table("SQLite.jl", db, SQLite_table)
    sqlite_benchmarks(insert_queries(number_of_datasets,"SQLite"), db, "Insert")
    sqlite_benchmarks(update_queries(number_of_datasets,"SQLite"), db, "Update")
  end

  println("\n\n******************   SUMMARY   ******************\n")
  println(output_string)
  println("\n\n******************  END OF SUMMARY   ******************\n\n")
end

if length(ARGS)<=0
  output_string = "$output_string \n\nUsage: DBPerf.jl <Database_Driver_1.jl> <Database_Driver_2.jl> ....... <Database_Driver_N.jl> <DBMS>\n"
  output_string = "$output_string Wherein Database_Driver.jl can be one of the following: ODBC.jl, JDBC.jl, PostgreSQL.jl, MySQL.jl, Mongo.jl, SQLite.jl\n"
  output_string = "$output_string config.jl should contain all the credentials required for a DBMS connection\n"
  output_string = "$output_string DBMS field is applicable only if you're using JDBC.jl, DBMS can be either one of the following: Oracle, MySQL\n"
  output_string = "$output_string Specifying DBMS is mandatory if JDBC.jl is selected, its not required for the rest\n"
  output_string = "$output_string \nExample: DBPerf.jl ODBC.jl JDBC.jl Oracle\n"
  output_string = "$output_string \nAbove example will conduct a performance test on Database driver ODBC.jl and JDBC.jl, DBMS will be automatically selected for ODBC.jl based on the credentials provided in config.jl, whereas JDBC.jl will be tested against Oracle\n\n\n"
  output_string = "$output_string \n\n\nIf you're running the program from Julia prompt then please use following syntax\n\n\n\n"
  output_string = "$output_string Usage: DBPerf(<Database_Driver_1.jl>, <Database_Driver_2.jl>, ....... <Database_Driver_N.jl>, <DBMS>)\n"
  output_string = "$output_string Wherein Database_Driver.jl can be one of the following: ODBC.jl, JDBC.jl, PostgreSQL.jl, MySQL.jl, Mongo.jl, SQLite.jl\n"
  output_string = "$output_string config.jl should contain all the credentials required for a DBMS connection\n"
  output_string = "$output_string DBMS field is applicable only if you're using JDBC.jl, DBMS can be either one of the following: Oracle, MySQL\n"
  output_string = "$output_string Specifying DBMS is mandatory if JDBC.jl is selected, its not required for the rest\n"
  output_string = "\n$output_string \n Example\: DBPerf\(\"ODBC\.jl\",\"JDBC\.jl\",\"Oracle\"\)\n\n"
  output_string = "\n$output_string Above example will conduct a performance test on Database driver ODBC.jl and JDBC.jl, DBMS will be automatically selected for ODBC.jl based on the credentials provided in config.jl, whereas JDBC.jl will be tested against Oracle\n\n\n"
  println("\n\n******************   SUMMARY   ******************\n")
  println(output_string)
  println("\n\n******************  END OF SUMMARY   ******************\n\n")
else
  DBPerf()
end
