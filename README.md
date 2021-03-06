# Elgg on Docker
forked from [keviocastro](https://github.com/keviocastro)/[elgg-docker](https://github.com/keviocastro/elgg-docker)

## Requirements
* Docker
* Elgg 3.3 or later
* PHP 7.3.8-apache
* MySQL 8.0
* Postfix

## MakeProject
```
git clone https://github.com/shipwebdotjp/elgg-docker
cd elgg-docker
```

## Setting 
### Postfix
Rename postfix/.env.sample to postfix/.env 
Open .env and edit these keys: 
```
SMTP_SERVER=smtp.gmail.com(if you use gmail)
SMTP_USERNAME=yourmailaddress
SMTP_PASSWORD=yourpassword
SERVER_HOSTNAME=yourhostname
```
 If you want to use Gmail SMTP Auth server: 
 Make sure you use gmail application password. (need two-factor authentication ) 

### MySQL
Rename mysql/.env.sample to mysql/.env 
Open .env and edit password 

### msmtp
Rename php/msmtprc.sample to php/msmtprc 
Open msmtprc and edit from mailaddress 

### Elgg
- Download Elgg ZIP file from [Download page](https://elgg.org/about/download/)
- Put Zip file to php/elgg/src/
- Open Dockerfile and edit ARG Version 

## Build
```
docker-compose up -d --build
docker-compose exec web /elgg/elgg-install.sh
```
Then, Check http://localhost:5000/  

## Install
### Requirements check
 Next

### install Elgg Paramater
* Database Username
 root
* Database Password
 password
* Database Name
 elgg
* Database Host
 db
* Database Port number
 3306
* Database Table Prefix
 elgg_
* Data Directory
 /elgg/data/
* Site URL
 Your URL
* Timezone
 Your Timezone

**ATTENTION! Database Host is not localhost

## After Install Elgg
You've seen Fatal Error after install Elgg? 
It because chache directory has permission problem. 
The files must be writable by httpd. 
But cron job execute by root creates some files in chache directory. 
So, You have to change owner these files. 

You can do this command after install Elgg 
This elgg-setting.sh also Enable Memcache. 

```
docker-compose exec web /elgg/elgg-setting.sh
```

## Performance setting
```
docker-compose exec web ln -s /elgg/data/caches/views_simplecache /var/www/html/cache
```
Then, turn on Use symbolic link to simple cache directory


## Author
ship [Youtube channel](https://www.youtube.com/channel/UCne2IBkAj3JoyzNAOzXxKMg)

## License
MIT License