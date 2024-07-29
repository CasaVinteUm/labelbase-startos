#!/bin/bash

echo "Running mysql"
mysqld &

echo "Running Labelbase"
/app/run.sh &

echo "Running nginx"
nginx -g 'daemon off;'

