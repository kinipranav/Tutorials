--start drill on windows
sqlline.bat -u "jdbc:drill:zk-local"

--switch to a schema (these are plugins to data sources, configured under storage on console)
use dfs.root

select * from dfs.`c:\\Users\\pranav\\Desktop\\apache-drill-1.11.0\\sample-data\\nation.parquet` limit 10
select * from dfs.`c:\\Users\\pranav\\Desktop\\apache-drill-1.11.0\\sample-data\\donuts.json` limit 10
select topping[1] from dfs.`c:\\Users\\pranav\\Desktop\\apache-drill-1.11.0\\sample-data\\donuts.json` limit 10
select topping[1].type from dfs.`c:\\Users\\pranav\\Desktop\\apache-drill-1.11.0\\sample-data\\donuts.json` limit 10
select * from dfs.`c:\\Users\\pranav\\Desktop\\apache-drill-1.11.0\\sample-data\\TextFile.txt`

create table dfs.tmp.parquetTable as select * from dfs.`c:\\Users\\pranav\\Desktop\\apache-drill-1.11.0\\sample-data\\donuts.json`

--catalogue queries
select hostname from sys.drillbits where `current` = true
select version from sys.version
show files from dfs.`c:\\Users\\pranav\\Desktop\\apache-drill-1.11.0\\sample-data`
show tables from dfs.`c:\\Users\\pranav\\Desktop\\apache-drill-1.11.0\\sample-data`
show databases
show schemas
alter session set `store.format` = 'parquet' --to create parquet files

--console URLs
--http://localhost:8047
--http://localhost:8047/query
--http://localhost:8047/storage
