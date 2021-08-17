FROM docker.io/nginx:mainline-alpine-perl

ENV USER=mail \
    USER_ID=82 \
    GROUP_ID=82 \
    GROUP_NAME=mail \
    GOMPLATE_VERSION=3.9.0 \
    WEB_DIR=/data/websites/www


RUN set -x \
    &&  sed -i "s@http://dl-cdn.alpinelinux.org/@https://mirrors.huaweicloud.com/@g" /etc/apk/repositories \
    && apk add --no-cache bash openssh-server libmcrypt libmcrypt-dev busybox-suid \
           shadow \
            supervisor \
    && groupdel www-data \
    && sed -i -e "s@user\s*nginx@user ${USER}  ${GROUP_NAME}@" /etc/nginx/nginx.conf \
    && mkdir -p $WEB_DIR \
    && mkdir -p /etc/supervisor \
    && mkdir -p /var/log/supervisor
# Install gomplate
RUN set -xe; \
	curl -sSL https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64-slim -o /usr/local/bin/gomplate; \
	chmod +x /usr/local/bin/gomplate
ADD docker-entrypoint.sh /opt/docker-entrypoint.sh

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY stop-supervisor.sh /usr/local/sbin/stop-supervisor.sh

ENTRYPOINT ["/opt/docker-entrypoint.sh"]
WORKDIR $WEB_DIR
EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisor/supervisord.conf"]