#!/bin/bash
 DOCUMENT_ROOT=${DOCUMENT_ROOT:-"/data/websites/vmail"}
 PHP_DIR="/usr/local/etc";
 CUSTOM_FPM_CONF_DIR="php-fpm-custom.d";
 SOCKET_DIR="/dev/shm/php/$FPM_USER"

  if [[ ! -d "${SOCKET_DIR}" ]]; then
      echo -e "create soket dir ${SOCKET_DIR}\n"
      mkdir -p $SOCKET_DIR && chown -R $FPM_USER.$FPM_GROUP $SOCKET_DIR
  fi

   if [[ -f "${PHP_DIR}/php-fpm.conf" ]]; then
         mkdir -p ${PHP_DIR}/${CUSTOM_FPM_CONF_DIR};
         echo "include=etc/${CUSTOM_FPM_CONF_DIR}/*.conf" >> ${PHP_DIR}/php-fpm.conf;
   fi

   if [ -f "${PHP_DIR}/php-fpm.d/www.conf" ]; then
         sed -i "s@^listen@;listen@"   ${PHP_DIR}/php-fpm.d/www.conf;
         sed -i "s/^user.*$/user = $(echo $FPM_USER)/"  ${PHP_DIR}/php-fpm.d/www.conf;
         sed -i "s/^group.*$/group = $(echo $FPM_GROUP)/"  ${PHP_DIR}/php-fpm.d/www.conf;
   fi

  

if [[ ! -d "$DOCUMENT_ROOT" ]]; then
   echo -e "create dir ${DOCUMENT_ROOT}\n"
   mkdir -p $DOCUMENT_ROOT
fi

# Run hooks
for file in /hooks/*; do
  if [ -x "${file}" ]; then
    echo "Running hook ${file}"
    "${file}"
  fi
done

exec "$@"