#!/bin/bash

while true; do 
    sleep 3h; 
    nginx -s reload;
done &
exec nginx -g 'daemon off;'

