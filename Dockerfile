FROM debian:wheezy
MAINTAINER Paul Rosania <paul@rosania.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    opendkim \
    opendkim-tools \
    postfix \
    rsyslog \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

#
# Configuration files
#

# Supervisor
COPY etc/supervisor/conf.d/postfix.conf /etc/supervisor/conf.d/postfix.conf

# OpenDKIM
COPY etc/opendkim.conf /etc/opendkim.conf
COPY etc/default/opendkim /etc/default/opendkim
COPY etc/opendkim/KeyTable \
     etc/opendkim/SigningTable \
     etc/opendkim/TrustedHosts \
     /etc/opendkim/

# Postfix
COPY bin/postfix.sh /usr/local/bin/postfix.sh
RUN chmod +x /usr/local/bin/postfix.sh
COPY etc/postfix /etc/postfix

EXPOSE 25

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
