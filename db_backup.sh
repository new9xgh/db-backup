#!/usr/bin/env bash
# This is a shell for backup db

# db config
db_names="db1 db2 db3"
db_host="127.0.0.1"
db_username="root"
db_password="******"

# backup config
backup_day=30
backup_path="/home/work/workplace/backup/db/data"
log_file="/home/work/workplace/backup/db/log/backup_db_$(date +%Y%m%d).log"

new_path="$backup_path"/$(date +%Y%m%d)
old_path="$backup_path"/$(date +%Y%m%d --date="${backup_day} days ago")

# mydumper config
mydumper=/usr/local/bin/mydumper

echo "===========================================" >> ${log_file}
echo "[$(date +"%y-%m-%d %H:%M:%S")] backup script begin" >> ${log_file}

echo "[$(date +"%y-%m-%d %H:%M:%S")] backup db names: ${db_names}" >> ${log_file}

# delete old file
if [ -d ${old_path} ]
then
    rm -rf ${old_path} >> ${log_file} 2>&1
    echo "[$(date +"%y-%m-%d %H:%M:%S")] delete old backup file: ${old_path}" >> ${log_file}
else
    echo "[$(date +"%y-%m-%d %H:%M:%S")] not found old backup file: ${old_path}" >> ${log_file}
fi

# create backup file
if [ -d ${new_path} ]
then
    echo "[$(date +"%y-%m-%d %H:%M:%S")] the backup file is exists, can't backup!" >> ${log_file}
else
    mkdir -p ${new_path}

# backup db
for db_name in ${db_names}
do
    echo "[$(date +"%y-%m-%d %H:%M:%S")] begin backup [${db_name}]" >> ${log_file}

    mkdir -p ${new_path}/${db_name}
    ${mydumper} -h ${db_host} -u ${db_username} -p ${db_password} -B ${db_name} -o ${new_path}/${db_name} --long-query-guard 300 --kill-long-queries -c -t 4 -v 2

    if [ $? -ne 0 ];then
        echo "[$(date +"%y-%m-%d %H:%M:%S")] backup failed [${db_name}] " >> ${log_file}
        # TODO send mail
        # echo ${log_file} | /bin/mail -s "server mysql db ${db_name} backup failed" 244013304@qq.com
        exit 1
    else
        echo "[$(date +"%y-%m-%d %H:%M:%S")] backup success [${db_name}]" >> ${log_file}
    fi
done
fi

echo "[$(date +"%y-%m-%d %H:%M:%S")] backup script end" >> ${log_file}