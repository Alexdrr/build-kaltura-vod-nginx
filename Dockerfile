ARG DEBIAN_VERSION='10.7'
FROM debian:${DEBIAN_VERSION}
ENV DEBIAN_FRONTEND noninteractive
ARG DEBIAN_CODENAME='buster'

RUN apt-get update && \
    apt-get install -y \
    fakeroot \
    build-essential \
    curl \
    git \
    gnupg2 \ 
    fakeroot \
    debhelper \
    ca-certificates

RUN cd /etc/apt/sources.list.d/ && \ 
    echo "deb http://nginx.org/packages/debian ${DEBIAN_CODENAME} nginx" >> nginx.list && \
    echo "deb-src http://nginx.org/packages/debian ${DEBIAN_CODENAME} nginx" >> nginx.list && \
    curl -fsSL https://nginx.org/keys/nginx_signing.key |  apt-key add - && \
    apt-get update

ARG VOD_VERSION='1.27'
RUN mkdir /root/modules && \
    cd /root/modules && \
    git clone https://github.com/kaltura/nginx-vod-module.git && \
    mv nginx-vod-module nginx-vod-module-${VOD_VERSION} && \
    cd nginx-vod-module-${VOD_VERSION} && \    
    git checkout ${VOD_VERSION}

ARG AKAMAI_TOKEN_VERSION='1.1'
RUN cd /root/modules && \
    git clone https://github.com/kaltura/nginx-akamai-token-validate-module.git && \
    mv nginx-akamai-token-validate-module  nginx-akamai-token-validate-module-${AKAMAI_TOKEN_VERSION} && \
    cd nginx-akamai-token-validate-module-${AKAMAI_TOKEN_VERSION} && \
    git checkout ${AKAMAI_TOKEN_VERSION}

ARG SECURE_TOKEN_VERSION='1.4'
RUN cd /root/modules && \
    git clone https://github.com/kaltura/nginx-secure-token-module.git && \  
    mv nginx-secure-token-module nginx-secure-token-module-${SECURE_TOKEN_VERSION} && \
    cd nginx-secure-token-module-${SECURE_TOKEN_VERSION} && \
    git checkout ${SECURE_TOKEN_VERSION}

ARG NGINX_VERSION="1.18.0"
ARG NGINX_DEB_VERSION="${NGINX_VERSION}-2~${DEBIAN_CODENAME}"
WORKDIR /root
RUN apt-get build-dep nginx -y && \
    apt-get source nginx=${NGINX_DEB_VERSION} && \
    sed -i "s@--with-stream_ssl_preread_module@--with-stream_ssl_preread_module --add-module=/root/modules/nginx-secure-token-module-${SECURE_TOKEN_VERSION} --add-module=/root/modules/nginx-akamai-token-validate-module-${AKAMAI_TOKEN_VERSION} --add-module=/root/modules/nginx-vod-module-${VOD_VERSION}@"  /root/nginx-${NGINX_VERSION}/debian/rules && \
    cd /root/nginx-${NGINX_VERSION} && \
    dpkg-buildpackage -b
