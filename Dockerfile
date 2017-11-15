FROM debian:jessie
MAINTAINER kelvinblood <admin@kelu.org>

# Docker Build Arguments
ENV RESTY_VERSION="1.9.7.1" \
    RESTY_CONFIG_OPTIONS=" \
	--prefix=/usr/share/openresty \
	--with-pcre-jit \
	--with-http_postgres_module  \
	--with-http_iconv_module  \
	--with-http_stub_status_module" \
    RESTY_DATA_DIR="/var/local/nginx/conf/vhost/" \
    RESTY_LOG_DIR="/var/local/log/nginx/"


COPY assets/sources.list /etc/apt/sources.list

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y zip vim locales curl wget net-tools\
	libperl4-corelibs-perl libreadline-dev libpcre3-dev libssl-dev libpq-dev gcc libc6-dev make\
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 && locale-gen en_US.UTF-8 \
 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales \
 && cd /tmp \
    && wget https://openresty.org/download/ngx_openresty-${RESTY_VERSION}.tar.gz \
    && tar -xzvf ngx_openresty-${RESTY_VERSION}.tar.gz \
    && cd ngx_openresty-${RESTY_VERSION}/ \
    && ./configure ${RESTY_CONFIG_OPTIONS} \
    && make \ 
    && make install \
    && mkdir -p /var/local/log/nginx \
    && mkdir -p /var/local/nginx/fastcgi_cache/one_hour \
    && cp -R /usr/share/openresty/nginx /var/local \
    && mkdir -p /var/local/nginx/conf/vhost \
    && apt-get clean\
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/ngx_openresty-${RESTY_VERSION} \ 
    && rm /tmp/ngx_openresty-${RESTY_VERSION}.tar.gz 

COPY assets/nginx/conf/nginx.conf /var/local/nginx/conf/nginx.conf
COPY assets/nginx/conf/vhost/www.conf /var/local/nginx/conf/vhost/www.conf

EXPOSE 80/tcp

VOLUME ["${RESTY_DATA_DIR}", "${RESTY_LOG_DIR}"]
# ENTRYPOINT /usr/share/openresty/nginx/sbin/nginx -c /var/local/nginx/conf/nginx.conf -g 'daemon off;'
CMD ["/usr/share/openresty/nginx/sbin/nginx","-c","/var/local/nginx/conf/nginx.conf","-g","daemon off;"]
