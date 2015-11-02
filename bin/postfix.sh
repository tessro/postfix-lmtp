#!/bin/bash

set -e

tls_cert_path=$(find /etc/postfix/certs -iname *.crt)
tls_key_path=$(find /etc/postfix/certs -iname *.key)
domainkeys_private_key_path=$(find /etc/opendkim/domainkeys -iname *.private)

function escape_path {
  echo $1 | sed -e 's/\//\\\//g'
}

#
# Runtime configuration
#

sed -iE "s/MAIL_DOMAIN_PLACEHOLDER/$maildomain/g" \
  /etc/postfix/main.cf \
  /etc/opendkim/KeyTable \
  /etc/opendkim/SigningTable \
  /etc/opendkim/TrustedHosts

sed -iE \
  -e "s/^virtual_transport = .*$/virtual_transport = lmtp:inet:$LMTP_PORT_24_TCP_ADDR:$LMTP_PORT_24_TCP_PORT/" \
  -e "s/TLS_CERT_PATH_PLACEHOLDER/$(escape_path $tls_cert_path)/" \
  -e "s/TLS_KEY_PATH_PLACEHOLDER/$(escape_path $tls_key_path)/" \
  /etc/postfix/main.cf

sed -iE "s/DOMAINKEYS_PRIVATE_KEY_PATH_PLACEHOLDER/$(escape_path $domainkeys_private_key_path)/" \
  /etc/opendkim/KeyTable

chmod 400 /etc/postfix/certs/*.* $domainkeys_private_key_path
chown opendkim:opendkim $domainkeys_private_key_path

#
# / Runtime configuration
#

service postfix start
tail -f /var/log/mail.log
