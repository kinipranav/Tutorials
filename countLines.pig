//count lines from files that make hive table (or HDFS)

files = LOAD 'hdfs://hostname:port/apps/hive/warehouse/user.db/$table/*';
gp = group files all;
line_count = foreach gp generate count(files);
dump line_count;
