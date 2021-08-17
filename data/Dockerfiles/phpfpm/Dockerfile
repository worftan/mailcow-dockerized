FROM php:8.1.0beta2-fpm-alpine3.14
LABEL maintainer "Andre Peters <andre.peters@servercow.de>"

ENV APCU_PECL 5.1.20
ENV  DOCUMENT_ROOT="/data/websites/vmail" \
      FPM_USER="postfix" \
      FPM_GROUP="postfix" \
      FPM_GID=1000 \
      FPM_UID=1000

ENV IMAGICK_PECL 3.5.1
# Mailparse is pulled from master branch
#ENV MAILPARSE_PECL 3.0.2
ENV MEMCACHED_PECL 3.1.5
ENV REDIS_PECL 5.3.4

RUN sed -i "s@http://dl-cdn.alpinelinux.org/@https://mirrors.huaweicloud.com/@g" /etc/apk/repositories \
    && sed -i "s@https://dl-cdn.alpinelinux.org/@https://mirrors.huaweicloud.com/@g" /etc/apk/repositories \
    && apk add -U --no-cache autoconf \
  aspell-dev \
  aspell-libs \
  bash \
  shadow \
  c-client \
  cyrus-sasl-dev \
  freetype \
  freetype-dev \
  g++ \
  git \
  gettext-dev \
  gmp-dev \
  gnupg \
  icu-dev \
  icu-libs \
  imagemagick \
  imagemagick-dev \
  imap-dev \
  jq \
  libjpeg-turbo \
  libjpeg-turbo-dev \
  libmemcached-dev \
  libpng \
  libpng-dev \
  libressl \
  libressl-dev \
  librsvg \
  libtool \
  libwebp-dev \
  libxml2-dev \
  libxpm-dev \
  libzip-dev \
  make \
  mysql-client \
  openldap-dev \
  pcre-dev \
  re2c \
  nghttp2 \
  nghttp2-dev \
  openssl \
  openssl-dev \
  redis \
  samba-client \
  zlib-dev \
  tzdata \
 # && userdel -r www-data \
  && mkdir -p ${DOCUMENT_ROOT} \
  && addgroup -g $FPM_GID -S $FPM_GROUP \
  && useradd -d $DOCUMENT_ROOT -r -N -u $FPM_UID -g $FPM_GROUP $FPM_USER \
  && git clone https://github.com/php/pecl-mail-mailparse \
  && cd pecl-mail-mailparse \
  && pecl install package.xml \
  && cd .. \
  && rm -r pecl-mail-mailparse \
  && pecl install redis-${REDIS_PECL} memcached-${MEMCACHED_PECL}  imagick-${IMAGICK_PECL} \
  && docker-php-ext-enable  imagick memcached mailparse redis \
  && pecl clear-cache \
  && docker-php-ext-configure intl \
  && docker-php-ext-configure exif \
  && docker-php-ext-configure gd --with-freetype=/usr/include/ \  
    --with-jpeg=/usr/include/ \
  && docker-php-ext-install -j 4 exif gd gettext intl ldap opcache pcntl pdo pdo_mysql pspell soap sockets zip bcmath gmp \
  && docker-php-ext-configure imap --with-imap --with-imap-ssl \
  && docker-php-ext-install -j 4 imap \
  && curl --silent --show-error https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer \
#add swoole
#	&& mkdir -p /usr/src/swoole/swoole-src \
#	&& cd /usr/src/swoole \
#	&& curl -o ./swoole.tar.gz https://github.com/swoole/swoole-src/archive/master.tar.gz -L \
#	&& tar -xf swoole.tar.gz -C /usr/src/swoole/swoole-src --strip-components=1  \
#	&& docker-php-ext-configure /usr/src/swoole/swoole-src \
 # --enable-swoole \
#	--enable-openssl \
#	--enable-http2 \
#	&& docker-php-ext-install /usr/src/swoole/swoole-src \
 # && rm -rf /usr/src/swoole \
  && apk del --purge autoconf \
    aspell-dev \
    cyrus-sasl-dev \
    freetype-dev \
    g++ \
    icu-dev \
    nghttp2 \
    nghttp2-dev \
    openssl \
    openssl-dev \
    imagemagick-dev \
    imap-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libressl-dev \
    libwebp-dev \
    libxml2-dev \
    make \
    pcre-dev \
    zlib-dev

COPY ./docker-entrypoint.sh /

WORKDIR ${DOCUMENT_ROOT} 

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]
