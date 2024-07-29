FROM mysql:8

ENV MYSQL_USER=ulabelbase
ENV MYSQL_DATABASE=labelbase
ENV MYSQL_ROOT_PASSWORD=labelbase
ENV MYSQL_PASSWORD=labelbase
ENV MYSQL_PWD=labelbase

RUN \
    # Explicitly disable PHP to suppress conflicting requests error
    microdnf -y module disable php \
    && \
    microdnf -y module enable nginx:1.22 && \
    # Install stuff
    microdnf -y install \
	gcc \
	mysql-devel \
	pkg-config \
	nginx \
	python3.11 python3.11-pip python3.11-setuptools python3.11-wheel \
    && \
    rm -rf /var/cache/dnf \
    && \
    # forward request and error logs to container engine log collector
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

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
RUN ln -sf /usr/bin/python3.11 /usr/bin/python
RUN python -m pip install --upgrade pip
RUN python -m pip install --no-cache-dir --break-system-packages -r /app/requirements.txt

COPY ./run.sh /app/run.sh
RUN chmod +x /app/run.sh

