#!/bin/sh
set -e
HERE=$(dirname $0)
cd $HERE/../ssl-key

FILE_ORIGINAL=ssl_private_key
FILE_ENC=ssl_private_key.enc
FILE_CLEAR=ssl_private_key.copy

echo "Enter symmetric key: "
echo -n "key: "
read SYMKEY
export SYMKEY
openssl aes-256-cbc -d -in $FILE_ENC -out $FILE_CLEAR -pass env:SYMKEY
echo "Wrote out the ssl private key to $FILE_CLEAR"
diff $FILE_ORIGINAL $FILE_CLEAR
