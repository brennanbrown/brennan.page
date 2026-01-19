FROM ubuntu:24.04

ENV TGTDIR=/usr/local/bin

RUN env LANG=C LC_ALL=C apt update
RUN env DEBIAN_FRONTEND=noninteractive LANG=C LC_ALL=C apt-get -y full-upgrade
RUN env DEBIAN_FRONTEND=noninteractive LANG=C LC_ALL=C apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install wget curl

VOLUME /zims
VOLUME /data

COPY ./scripts/*.sh $TGTDIR/
RUN chmod +x $TGTDIR/*.sh
RUN provision.sh

EXPOSE 8080

ENTRYPOINT ["entrypoint.sh"]
