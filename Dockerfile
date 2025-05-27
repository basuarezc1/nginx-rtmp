#Elegimos base
FROM debian:bookworm-slim

#Instalamos herramientas de compilación y librerías
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential ca-certificates wget git \
    libpcre3-dev zlib1g-dev libssl-dev

#Variables que usaremos 
ENV NGINX_VERSION=1.27.5 \
    RTMP_COMMIT=master

#Carpeta de trabajo temporal
WORKDIR /tmp

#Descarga codigo de Nginx y modulo RTMP
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar xzf nginx-${NGINX_VERSION}.tar.gz && \
    git clone --depth 1 https://github.com/arut/nginx-rtmp-module.git

#Entramos a la carpeta de Nginx
WORKDIR /tmp/nginx-${NGINX_VERSION}

#Cofiguración y compilación de Nginx con RTMP
RUN ./configure --with-http_ssl_module \
    --add-module=/tmp/nginx-rtmp-module && \
    make && make install

#Se limpia para hacer más ligera la imagen 
RUN apt-get purge -y build-essential git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*



