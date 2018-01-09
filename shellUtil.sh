#line count wc -l
sed -n '$=' file

#get specific excerpt from file
sed -n 100,125p file

#count columns in a tsv/csv file
cat file | head | awf -F'\t' '{print NF}'

#add up numbers in a specific coulumn of file
cat file | awk '{print $3}' | awk '{sum += $1} END {print sum}'

#check numeric values in specific column of file and add
awk '$3 ~ /^1$|^2$|^5$|^6$/' file awk '{sum += $1} END {print sum}'|  

#sort file based on count of words
cat file | uniq -u | sort -nr | uniq -c

#total lines in dir (all files)
find . -type f -print0| xargs -0 wc -l

#find multiple instances of file across system
locate file.conf
