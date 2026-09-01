FROM debian:12

RUN apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chmod 755 /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY --chmod=755 tools/init.sh /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["init.sh"]
CMD ["mariadbd", "--user=mysql"]