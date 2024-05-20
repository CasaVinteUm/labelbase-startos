FROM mysql:8.0-debian@sha256:1579fe3a97a436cc10824fc771a07fcedc92213e7ab7604eb5d2976ca419abc8

ENV MYSQL_USER=ulabelbase
ENV MYSQL_DATABASE=labelbase
ENV MYSQL_ROOT_PASSWORD=labelbase
ENV MYSQL_PASSWORD=labelbase
ENV MYSQL_PWD=labelbase

RUN apt-get update && \
    apt-get install -y \
        default-libmysqlclient-dev \
        build-essential pkg-config gcc \
        cron vim logrotate \
        libpcre3-dev \
        python3-dev python3-pip \
        #default-mysql-client \
        nginx \
    && rm -rf /var/lib/apt/lists/* 

# Cleanup to reduce image size
RUN apt-get purge -y --auto-remove build-essential

# Copy configs/migrations
COPY ./Labelbase/mysql/init.sql /docker-entrypoint-initdb.d/init.sql
COPY ./Labelbase/nginx/nginx.conf /etc/nginx/

ENV PYTHONUNBUFFERED 1

EXPOSE 8000

VOLUME /var/lib/mysql
VOLUME /run/mysqld
VOLUME /docker-entrypoint-initdb.d

WORKDIR /app

COPY ./Labelbase/django /app/

# Python deps
RUN pip install --upgrade pip --break-system-packages
RUN pip install --no-cache-dir --break-system-packages -r /app/requirements.txt

COPY ./run.sh /app/run.sh
RUN chmod +x /app/run.sh
