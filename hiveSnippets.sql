--list databases
show databases;

--list tables
show tables;

--table structure details
describe table;
show table extended like table_name; --gives partition details too

--get table DDL
show create table mytable;

--check partitions
show partitions table_name;

--create basic table
create table mytable(column1 varchar(50),column2 varchar(50),column3 varchar(50),column4 varchar(50),column5 varchar(50))
row format delimited fields terminated by '\t' stored as textfile;

--use csv serde for loading from csv files or space separated files
create table mytable(column1 varchar(50),column2 varchar(50),column3 varchar(50),column4 varchar(50),column5 varchar(50))
row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde' with SERDEPROPERTIES ("separatorChar" = " ", "quoteChar" = "\"") stored as textfile;

--load data
load data inpath '/user/hive/location/data' into table mytable;

--excluding 1st row of file while loading to table (if 1st row has headers)
create table mytable(column1 varchar(50),column2 varchar(50),column3 varchar(50),column4 varchar(50),column5 varchar(50))
row format delimited fields terminated by '\t' stored as textfile tblproperties("skip.header.line.count"="1");

--once data is loaded to hive table, it is moved from HDFS location to hive warehouse
--/apps/hive/warehouse/user.db/tablename

--create partitioned table (ex:month table with partitions per day)
create table mytable(column1 varchar(50),column2 varchar(50),column3 varchar(50),column4 varchar(50),column5 varchar(50))
partitioned by (dates string) row format delimited fields terminated by '\t' stored as textfile;

--add partitions to table
use database;alter table mytable add partition (dates='2018-01-01') location '/user/myname/myHDFSdir/2018-01-01'; --location on HDFS from where to load files
use database;alter table mytable add partition (dates='2018-01-02') location '/user/myname/myHDFSdir/2018-01-02';

--incase of partitioned tables, metadata is created but files are not moved to hive warehouse - /apps/hive/warehouse/user.db/tablename

--hive ACID table with Bucketing for greater speed and lesser warehouse space consumption
create table mytable(column1 varchar(50),column2 varchar(50),column3 varchar(50),column4 varchar(50),column5 varchar(50)) clustered by (column1)
into 5 buckets row format delimited fields terminated by '\t' stored as ORC tblproperties ('transactional' = 'true');

--Sequence Files
--when you have large number (think few thousands or more) of files that you want to load to a single hive table,
--storing as sequence files drastically improves performance
create table mytable(column1 varchar(50),column2 varchar(50),column3 varchar(50),column4 varchar(50),column5 varchar(50))
partitioned by (dates string) row format delimited fields terminated by '\t' stored as sequencefile;

--alter table to change storage type
alter table set file format orc;

--migrate DB
use olddb;alter table table1 rename to newdb.table1;
use olddb;alter table table2 rename to newdb.table2;
--put above sql for each table you want to migrate into a .hql file and run using hive -f migrate.hql

--get size of your hive warehouse
--hdfs dfs -du -h /apps/hive/warehouse/user.db

--executing hive commands from unix shell (without using hive CLI)
hive -e "use database;select * from mytable limit 5"

--executing bunch of hive commands from unix shell 
--for example you have to migrate a db (multiple tables) or add multiple partitions to a table
--create a hiveCommands.hql file with all alter commands and run:
hive -f hiveCommands.hql

--hive commands history file
--$home/.hivehistory

--config file
--hive-site.xml

--check all hive variable/conf values from CLI
set -v;

--reading snappy compressed files from linux command line
hdfs dfs -text file.snappy | head 

--get table stats
analyze table tweets compute statistics;
analyze table tweets compute statistics for columns sender, topic;

--query optimization
--use CBO, vectorization, tez, sort by (instead of order by)
set hive.vectorized.execution.enabled = true;
set hive.vectorized.execution.reduce.enabled = true;

set hive.cbo.enable=true;
set hive.compute.query.using.stats=true;
set hive.stats.fetch.column.stats=true;
set hive.stats.fetch.partition.stats=true;

--table optimization
--use partitioning, bucketing, sequencefile, orc

--orc file dump utility
hive --orcfiledump <flag> filename


--changing table location
--load data inpath vs load data local inpath
--archiving/unarchiving partitions
--indexing table (create,show,rebuild,drop)
--view
--windowing functions(lead,lag,first_value,last_value)
--over()
--analytics functions (rank,row_number,dense_rank,cume_dist,percent_rank,ntile)


