ARG ARCH=${ARCH}
ARG NGINX_VERSION=${NGINX_VERSION}

FROM --platform=${ARCH} nginx:${NGINX_VERSION}
LABEL maintainer="Joao Arquimedes"

RUN apk update \
    && apk upgrade \
    && apk add --no-cache openssl \
    && mkdir /etc/nginx/ssl \
    && chmod 770 /etc/nginx/ssl

COPY --chown=root.root --chmod=664 ./conf/openssl.cnf /etc/nginx/ssl/openssl.cnf
RUN openssl req -x509 -newkey rsa:2048 -config /etc/nginx/ssl/openssl.cnf -keyout /etc/nginx/ssl/cert.key -out /etc/nginx/ssl/cert.pem -days 7300 -nodes \
    && openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048 \
    && rm -rf /etc/nginx/ssl/openssl.cnf

COPY --chown=root.root --chmod=664 ./conf/nginx.conf /etc/nginx/nginx.conf

WORKDIR /var/www/html/
EXPOSE 80 443
STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
