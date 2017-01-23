#!/bin/bash

erb /etc/nginx/conf.d/default.conf.erb > /etc/nginx/conf.d/default.conf
rm /etc/nginx/conf.d/default.conf.erb

exec "$@"
