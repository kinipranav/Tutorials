create table test_table as select * from main_table;
alter table test_table add column new_field STRING;
alter table test_table rename to new_schema.test_table;

grant all on table test_table to developer;

insert into test_table values('6439','abcd','23','xyz');

select get_ddl('TABLE','test_table');
truncate test_table;
drop table test_table;
undrop table test_table;

--copy from s3 files
copy into test_table from (select F.$1, F.$2, split_part(METADATA$FILENAME, '/', -1), METADATA$FILE_ROW_NUMBER from s3://path/to/file F)
  pattern = '.*.*' FILE_FORMAT = 'ANG_BRACE' FORCE = FALSE PURGE = TRUE ON_ERROR = 'CONTINUE' VALIDATION_MODE = 'RETURN_ALL_ERRORS';
  
--File_Format
ALTER FILE_FORMAT DBNAME.SCHEMA.ANG_BRACE SET COMPRESSION = 'AUTO' FIELD_DELIMITER = '|' RECORD_DELIMITER = '\n' SKIP_HEADER = 0
FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE' TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE ESCAPE = '\1234' 
ESCAPE_UNENCLOSED_FIELD = '\1234' DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO' NULL_IF = ('') VALIDATE_UTF8 = FALSE
BINARY_FORMAT = UTF8 ENCODING = UTF8;

--select values form JSON using keys
select JSON:FIELD:key1,
       JSON:FIELD:key2,
       JSON:FIELD:key3,
       JSON:FIELD:key4,
       JSON:FIELD:key5
       from 
       test_table;
       
--split strings
update test_table set
col2 = split_part(col1,'|',2),
col3 = split_part(col1,'|',3);

--conditional operator iff
select iff(substr(col1,15,3) != '', concat('.', substr(col1,15,3)),'.bad') from teststring;

--dual & systime
select current_timestamp();
select current_sysdate();
select '4230489230948230' from dual;

--Performance
select SYSTEM$CLUSTERING_INFORMATION('test_table');
select SYSTEM$CLUSTERING_RATIO('test_table');
select SYSTEM$CLUSTERING_DEPTH('test_table');

--update with subquery
update table2 set col2 = counts from (select count(*) as counts, FILE_NAME, TABLE_NAME from table1
as tab1 where tab1.ID = '123' group by FILE_NAME, TABLE_NAME)q1 where table2.ID = '123'
and table2.FILE_NAME = q1.FILE_NAME and table2.TABLE_NAME = q1.TABLE_NAME;

--merge
merge into table table1 using (
  select col1,
  col2,
  col3
  from
  table2
  where col1 = 'smthn' and
  col2 = 'smthnelse')tab2
  on table1.ID = tab2.ID
  when matched then update set
  table1.col1 = tab2.col1,
  table1.col2 = tab2.col2,
  table1.col3 = tab2.col3
  when not matched then
  insert(
    col1,
    col2,
    col3
  )
  values(
    tab2.col1,
    tab2.col2,
    tab2.col3
  )
      
--stored proc example
create or replace procedure schema.sample_proc()
returns string
language javascript
AS
$$

var length_sql = "select count(1) from schema.table_name";
var exec_length_stmt = snowflake.createStatement( {sqlText: length_sql } );
var rs = exec_length_stmt.execute();
                                           
if (rs.next())                                           
  counts = rs.getColumnValue(1);
    
var numrows = parseInt(counts);

var sal_sql = "select max(salary) as max_salary from schema.salary";
var exec_sal_stmt = snowflake.createStatement( {sqlText: sal_sql } );
rs = execsal_stmt.execute();
    
rs.next();
var salary = rs.getColumnValueAsString('max_salary');
    
return "number of rows =" + counts;

$$
;
    
call schema.sample_proc();
    
copy into @stage/s3folder/filename from (select * from schema.table limit 2500 offset 0) file_format='csv' overwrite=True;

--return list of files written to s3 stage
select listagg(distinct metadata$filename, ',') from @stage/s3folder/;

--write dummy file to "new" s3folder 
copy into @stage/s3folder/new_folder/filename from (select ' ' from dual) file_format='csv' overwrite=True single=True;
    
--select chunks of 2500 rows from table at a time
select * from schema.table limit 2500 offset 0;    --first 2500
select * from schema.table limit 2500 offset 2500; --next 2500
select * from schema.table limit 2500 offset 5000; --so on
    
--create stage    
create or replace stage schema.stage_name url='s3://bucket_name/s3folder/'
    storage_integration = S3_INT
    file_format = csv;

show storage integrations;
show users like 'username';
    
                                           
