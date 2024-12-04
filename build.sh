#!/bin/sh

git pull

sudo docker stop Website > /dev/null 2>&1
sudo docker rm Website > /dev/null 2>&1

sudo docker build -t website .

sudo docker run -d --name Website --restart=always  -p 81:80 website -v Website_Logs:/etc/nginx/logs
