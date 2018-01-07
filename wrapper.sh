while read name
  do
    echo "$name" > count.log
    pig -param table=$name countLines.pig >> count.log
  done < tables
  
  #tables is a file containing any list of files on HDFS
  #in this case it's a list of tables in the hive warehouse
  #hdfs dfs -ls /apps/hive/warehouse/user.db
