FROM alpine:latest
ADD files/* /app/
RUN \
  apk add python2 pcre mysql-client bash; \
  apk add --no-cache mariadb-connector-c-dev ;\
  apk add --no-cache --virtual .build-deps \
    build-base \
    linux-headers \
    mariadb-dev \
    git \
    python-dev \
    py2-pip \
    py-virtualenv \
    pcre-dev; \
  sed -i '/st_mysql_options options;/a unsigned int reconnect;' /usr/include/mysql/mysql.h; \
  cd /tmp/; \
  git clone https://github.com/agderlan/get5-web.git; \
  cp -r get5-web/* /app/; \
  cd /app/; \
  pip install uwsgi; \
  virtualenv venv; \
  source venv/bin/activate; \
  pip install -r requirements.txt; \
  apk del .build-deps; \
  rm -rf /var/cache/apk/*; \
  addgroup -g 1000 -S app; \
  adduser -u 1000 -H -D -S app -G app; \
  chown -R app:app /app/;
EXPOSE 80

USER app
WORKDIR /app/
CMD [ "/app/start.sh" ]