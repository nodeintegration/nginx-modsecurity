FROM nginx:stable

MAINTAINER Brendan Beveridge <brendan@nodeintegration.com.au>

RUN cd /opt && \
    echo "deb-src http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -qy wget dpkg-dev apache2-dev libpcre3-dev libxml2-dev && \
    apt-get source nginx && \
    apt-get -qy build-dep nginx && \
\
    mkdir /opt/modsecurity && \
    wget -O /opt/modsecurity/modsecurity-2.9.0.tar.gz https://www.modsecurity.org/tarball/2.9.0/modsecurity-2.9.0.tar.gz && \
    cd /opt/modsecurity && tar -zxvf modsecurity-2.9.0.tar.gz && \
\
    cd /opt/modsecurity/modsecurity-2.9.0 && \
    ./configure --enable-standalone-module --disable-mlogc && \
    make && \
\
    cd /opt/nginx-* && \
    sed -i -e 's%\./configure%./configure --add-module=/opt/modsecurity/modsecurity-2.9.0/nginx/modsecurity --with-http_stub_status_module%' debian/rules && \
    dpkg-buildpackage -b && \
    dpkg -i /opt/nginx_*.deb
    

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
