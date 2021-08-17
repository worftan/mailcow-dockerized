   auto_tmpl() {
        local output_dir="${NGINX_TMPL_OUTPUT_DIR:-/etc/nginx}"
        local suffix="${NGINX_TMPL_SUFFIX:-conf.tmpl}"
        local template_dir=${TMPL_DIR:-"/templates"}
        /usr/local/bin/gomplate  --input-dir=$template_dir --output-map=${output_dir}/'{{ .in | strings.ReplaceAll  "conf.tmpl" "conf" }}'
   
   }
   
  auto_tmpl

