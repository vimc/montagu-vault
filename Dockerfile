FROM vault:1.0.2
RUN apk add --update openssl curl

COPY vault.conf /vault/config/
COPY certs/support.montagu.crt /vault/config/ssl_certificate

WORKDIR /app
COPY scripts/*.sh ./
COPY ssl-key/ssl_private_key.enc /vault/config/ssl_private_key.enc

ENTRYPOINT /app/entrypoint.sh
