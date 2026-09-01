FROM debian:12

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

COPY tools/init.sh /usr/local/bin/init.sh
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN chmod 755 /usr/local/bin/init.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["nginx", "-g", "daemon off;"]