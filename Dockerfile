FROM mysql:8

ARG PLATFORM

RUN microdnf install -y \
        make automake gcc gcc-c++ pkg-config \
        mariadb105-devel \
        python3 python3-devel python3-pip \
        crontabs logrotate \
        nginx \
        && microdnf clean all

ENV MYSQL_USER=ulabelbase
ENV MYSQL_DATABASE=labelbase
ENV MYSQL_ROOT_PASSWORD=labelbase
ENV MYSQL_PASSWORD=labelbase

ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY ./Labelbase/django /app/

# Python deps
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /app/requirements.txt

# Cleanup to reduce image size
RUN apt-get purge -y --auto-remove build-essential

# Copy configs/migrations
COPY ./Labelbase/nginx/nginx.conf /etc/nginx/
COPY ./Labelbase/mysql/init.sql /docker-entrypoint-initdb.d/init.sql

RUN chmod +x /app/entrypoint.sh
