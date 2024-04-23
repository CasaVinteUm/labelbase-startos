FROM python:3.11@sha256:db07fba48daaf1c68c03676aadc73866414d25b4c278029f9873c784517613bf AS final

ARG PLATFORM

RUN apt-get update && \
    apt-get install -y \
        default-libmysqlclient-dev \
        build-essential \
        cron vim logrotate \
        libpcre3-dev \
        default-mysql-client \
        default-mysql-server \
        nginx \
    && rm -rf /var/lib/apt/lists/*

# TODO
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

# Start MySQL
# NOTE: Don't know why this is MariaDB (Oh yes python docker is based on Debian)
RUN /etc/init.d/mariadb start

# TODO: Debug remove it
RUN sed -i 's/15/1/' run.sh

# ARG ARCH
# ADD ./hello-world/target/${ARCH}-unknown-linux-musl/release/hello-world /usr/local/bin/hello-world
# RUN chmod +x /usr/local/bin/hello-world
# ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
# RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
