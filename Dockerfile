FROM postgres

MAINTAINER harry.kodden@surfnet.nl

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y ca-certificates
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y davfs2

ARG DAV_URI
ARG DAV_USR
ARG DAV_PWD

RUN dpkg-reconfigure davfs2

RUN usermod -aG davfs2 postgres
RUN chmod u+s /usr/sbin/mount.davfs
RUN echo "$DAV_URI /var/lib/postgresql/backup davfs user,noauto,file_mode=600,dir_mode=700 0 1" >> /etc/fstab

USER postgres
WORKDIR /var/lib/postgresql

RUN mkdir .davfs2 backup
RUN echo "$DAV_URI $DAV_USR $DAV_PWD" > .davfs2/secrets
RUN chmod 600 .davfs2/secrets

USER root
WORKDIR /

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data/

COPY init_postgres.sh /docker-entrypoint-initdb.d/init_docker_postgres.sh

CMD [ "postgres" ]
