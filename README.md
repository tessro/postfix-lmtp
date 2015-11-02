# postfix-lmtp

[![Docker Repository on Quay.io](https://quay.io/repository/paulrosania/postfix-lmtp/status "Docker Repository on Quay.io")](https://quay.io/repository/paulrosania/postfix-lmtp)

postfix-lmtp is a Docker container that runs postfix hooked up to LMTP (on port
24), with TLS and OpenDKIM.

## Installation

    docker pull quay.io/paulrosania/postfix-lmtp

## Usage

0. Generate keys:

    TLS:
    For testing, follow the instructions at:
    http://www.rtcquickstart.org/tls-certificate-creation

    DKIM:
    ```bash
    docker run --rm -v $PWD:/certs -w /certs \
      quay.io/paulrosania/postfix-lmtp \
      opendkim-genkey -t -s mail -d <your mail domain>
    ```
    (This generates a `.txt` and `.private` file in the current directory)

1. Configure keys:

    * Save your DKIM private key with a `.private` extension in /path/to/domainkeys
    * Save your TLS keypair with `.key` and `.crt` extensions in /path/to/certs

2. Run the image:

    ```bash
    docker run -p 25:25 -e maildomain=<your mail domain> \
      --link <lmtp container>:lmtp \
      -v /path/to/domainkeys:/etc/opendkim/domainkeys \
      -v /path/to/certs:/etc/postfix/certs \
      --name postfix -d quay.io/paulrosania/postfix-lmtp
    ```

## Thanks

* Minghou Ye, for the original [docker-postfix](https://github.com/catatnight/docker-postfix)
  container. This instance is loosely based on it.

## License

MIT
