global output_string = ""
include("config.jl")
include("Backend_Create_and_Execute_Dataset.jl")
function DBPerf(a1="",a2="",a3="",a4="",a5="")
  global output_string
  if a1=="" && a2=="" && a3=="" && a4=="" && length(ARGS)<=0
    println("Usage: DBPerf(<Database_Driver_1.jl>, <Database_Driver_2.jl>, ....... <Database_Driver_N.jl>, <DBMS>)")
    println("Wherein Database_Driver.jl can be one of the following: ODBC.jl, JDBC.jl, PostgreSQL.jl, MySQL.jl")
    println("config.jl should contain all the credentials required for a DBMS connection")
    println("DBMS field is applicable only if you're using JDBC.jl, DBMS can be either one of the following: Oracle, MySQL")
    println("Specifying DBMS is mandatory if JDBC.jl is selected, its not required for the rest")
    println("Example\: DBPerf\(\"ODBC\.jl\",\"JDBC\.jl\",\"Oracle\"\)")
    println("Above example will conduct a performance test on Database driver ODBC.jl and JDBC.jl, DBMS will be automatically selected for ODBC.jl based on the credentials provided in config.jl, whereas JDBC.jl will be tested against Oracle\n\n")

    output_string = "$output_string Usage: DBPerf(<Database_Driver_1.jl>, <Database_Driver_2.jl>, ....... <Database_Driver_N.jl>, <DBMS>)\n"
    output_string = "$output_string Wherein Database_Driver.jl can be one of the following: ODBC.jl, JDBC.jl, PostgreSQL.jl, MySQL.jl\n"
    output_string = "$output_string config.jl should contain all the credentials required for a DBMS connection\n"
    output_string = "$output_string DBMS field is applicable only if you're using JDBC.jl, DBMS can be either one of the following: Oracle, MySQL\n"
    output_string = "$output_string Specifying DBMS is mandatory if JDBC.jl is selected, its not required for the rest\n"
    output_string = "\n$output_string Example\: DBPerf\(\"ODBC\.jl\",\"JDBC\.jl\",\"Oracle\"\)\n"
    output_string = "\n$output_string Above example will conduct a performance test on Database driver ODBC.jl and JDBC.jl, DBMS will be automatically selected for ODBC.jl based on the credentials provided in config.jl, whereas JDBC.jl will be tested against Oracle\n\n\n"
    return
  end
  if a1=="MySQL.jl" || a2=="MySQL.jl" || a3=="MySQL.jl" || a4=="MySQL.jl" || ("MySQL.jl" in ARGS)
    output_string = "$output_string \n\n *******  MYSQL.jl  ******* \n"
    mysql_benchmarks(insert_queries(number_of_datasets,"MySQL"),"Insert","MySQL")
    mysql_benchmarks(update_queries(number_of_datasets,"MySQL"),"Update","MySQL")
  end

  if a1=="PostgreSQL.jl" || a2=="PostgreSQL.jl" || a3=="PostgreSQL.jl" || a4=="PostgreSQL.jl" || ("PostgreSQL.jl" in ARGS)
    output_string = "$output_string \n\n *******  PostgreSQL.jl  ******* \n"
    postgres_benchmarks(insert_queries(number_of_datasets,"PostgreSQL"), "Insert")
    postgres_benchmarks(update_queries(number_of_datasets,"PostgreSQL"), "Update")
  end

  if a1=="ODBC.jl" || a2=="ODBC.jl" || a3=="ODBC.jl" || a4=="ODBC.jl" || ("ODBC.jl" in ARGS)
    output_string = "$output_string \n\n *******  ODBC.jl  ******* \n"
    println("Testing ODBC.jl over MySQL Database")
    output_string = "$output_string       \nTesting ODBC.jl over MySQL Database\n\n"
    odbc_benchmarks(insert_queries(number_of_datasets,"MySQL"),"Insert","MySQL")
    odbc_benchmarks(update_queries(number_of_datasets,"MySQL"),"Update","MySQL")
    println("Testing ODBC.jl over Oracle Database")
    output_string = "\n$output_string       \nTesting ODBC.jl over Oracle Database\n\n"
    odbc_benchmarks(insert_queries(number_of_datasets,"Oracle"),"Insert","Oracle")
    odbc_benchmarks(update_queries(number_of_datasets,"Oracle"),"Update","Oracle")
  end

  if a1=="JDBC.jl" || a2=="JDBC.jl" || a3=="JDBC.jl" || a4=="JDBC.jl" || ("JDBC.jl" in ARGS)
    output_string = "$output_string \n\n *******  JDBC.jl  ******* \n"
    if a2=="MySQL" || a3=="MySQL" || a4=="MySQL" || a5=="MySQL" || ("MySQL" in ARGS)
        println("Testing JDBC.jl over MySQL Database")
        output_string = "$output_string       \nTesting JDBC.jl over MySQL Database\n\n"
        stmt = JDBC_init("MySQL")
        if (stmt != 0)
          jdbc_benchmarks(insert_queries(number_of_datasets,"MySQL"),"Insert",stmt,"MySQL")
          jdbc_benchmarks(update_queries(number_of_datasets,"MySQL"),"Update",stmt,"MySQL")
        end
    elseif a2=="Oracle" || a3=="Oracle" || a4=="Oracle" || a5=="Oracle" || ("Oracle" in ARGS)
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
end

if length(ARGS)<=0
  println("\n\nUsage: DBPerf.jl <Database_Driver_1.jl> <Database_Driver_2.jl> ....... <Database_Driver_N.jl> <DBMS>")
  println("Wherein Database_Driver.jl can be one of the following: ODBC.jl, JDBC.jl, PostgreSQL.jl, MySQL.jl")
  println("config.jl should contain all the credentials required for a DBMS connection")
  println("DBMS field is applicable only if you're using JDBC.jl, DBMS can be either one of the following: Oracle, MySQL")
  println("Specifying DBMS is mandatory if JDBC.jl is selected, its not required for the rest")
  println("Example: DBPerf.jl ODBC.jl JDBC.jl Oracle")
  println("Above example will conduct a performance test on Database driver ODBC.jl and JDBC.jl, DBMS will be automatically selected for ODBC.jl based on the credentials provided in config.jl, whereas JDBC.jl will be tested against Oracle\n\n")
  println("\n\n\nIf you're running the program from Julia prompt then please use following syntax\n\n\n")

  output_string = "$output_string \n\nUsage: DBPerf.jl <Database_Driver_1.jl> <Database_Driver_2.jl> ....... <Database_Driver_N.jl> <DBMS>\n"
  output_string = "$output_string Wherein Database_Driver.jl can be one of the following: ODBC.jl, JDBC.jl, PostgreSQL.jl, MySQL.jl\n"
  output_string = "$output_string config.jl should contain all the credentials required for a DBMS connection\n"
  output_string = "$output_string DBMS field is applicable only if you're using JDBC.jl, DBMS can be either one of the following: Oracle, MySQL\n"
  output_string = "$output_string Specifying DBMS is mandatory if JDBC.jl is selected, its not required for the rest\n"
  output_string = "$output_string \nExample: DBPerf.jl ODBC.jl JDBC.jl Oracle\n"
  output_string = "$output_string \nAbove example will conduct a performance test on Database driver ODBC.jl and JDBC.jl, DBMS will be automatically selected for ODBC.jl based on the credentials provided in config.jl, whereas JDBC.jl will be tested against Oracle\n\n\n"
  output_string = "$output_string \n\n\nIf you're running the program from Julia prompt then please use following syntax\n\n\n\n"
end
DBPerf()
println("\n\n******************   SUMMARY   ******************\n\n")
println(output_string)
println("\n\n******************  END OF SUMMARY   ******************\n\n")
