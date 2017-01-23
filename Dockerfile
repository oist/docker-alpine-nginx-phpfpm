FROM alpine:edge

# Create user and groups
# Based on http://git.alpinelinux.org/cgit/aports/tree/main/nginx-initscripts/nginx-initscripts.pre-install
RUN addgroup -S -g 82 www-data && \
    addgroup -S nginx && \
    adduser -S -D -H -h /var/www/localhost/htdocs -s /sbin/nologin -G nginx -g nginx nginx && \
    addgroup nginx www-data

# Install nginx
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache --upgrade musl musl-utils && \
    apk --update add \
        nginx \
        ca-certificates \
        bash \
        ruby && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /tmp/nginx && \
    mkdir -p /etc/nginx/sites-enabled

# COPY the configuration files
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf.erb /etc/nginx/conf.d/default.conf.erb
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 80
CMD ["/usr/sbin/nginx"]
