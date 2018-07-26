## MySql database backup

Shell script to backup mysql database.

## Requirements

- mydumper

## Cronjob setup

You can also setup cron job to backup mysql database everyday. Add this line in crontab file 

```bash
@daily /bin/sh <PATH TO BACKUP FOLDER>/db_backup.sh
```

## Install mydumper

Example to install `mydumper` in CentOS 7

```bash
# install depend
yum install glib2-devel mysql-devel zlib-devel pcre-devel openssl-devel cmake

# download
wget https://launchpad.net/mydumper/0.9/0.9.1/+download/mydumper-0.9.1.tar.gz

# make and install
tar -zxvf mydumper-0.9.1.tar.gz
cd mydumper-0.9.1
cmake .
make && make install

# mydumper, myloader will be in /usr/local/bin

# check
mydumper --help
```

## Example
```bash
# create backup folder
mkdir /home/work/workplace/backup/db/data -p
mkdir /home/work/workplace/backup/db/log

# modify config
vi <PATH TO BACKUP FOLDER>/db_backup.sh

# change permissions
chmod +x <PATH TO BACKUP FOLDER>/db_backup.sh

# execute
<PATH TO BACKUP FOLDER>/db_backup.sh
```

## License
The MIT License (MIT). Please see [License File](LICENSE.md) for more information.