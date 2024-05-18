#!/bin/bash
export MYSQL_USER=ulabelbase
export MYSQL_DATABASE=labelbase
export MYSQL_ROOT_PASSWORD=labelbase
export MYSQL_PASSWORD=labelbase
export MYSQL_PWD=labelbase

echo "Executing run.sh in 15 seconds."
mysqld -uroot --initialize --init-file="/docker-entrypoint-initdb.d/init.sql"&
nginx -g 'daemon off;'
sleep 15
#python manage.py make_config
python3 manage.py makemigrations --noinput
python3 manage.py migrate --noinput
python3 manage.py collectstatic --noinput
python3 manage.py process_tasks &
gunicorn labellabor.wsgi:application -b 0.0.0.0:8000 --reload &