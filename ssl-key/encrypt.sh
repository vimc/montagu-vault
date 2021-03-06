#!/usr/bin/env bash
set -e

# https://gist.github.com/kennwhite/9918739
# https://www.bjornjohansen.no/encrypt-file-using-ssh-key
PATH_SECRET=ssl-key
FILE_CLEAR=$PATH_SECRET/ssl_private_key
FILE_ENC=$PATH_SECRET/ssl_private_key.enc
PATH_PUBKEY=$PATH_SECRET/pubkey
PATH_KEY=$PATH_SECRET/key

if [ ! -f $FILE_CLEAR ]; then
    echo "Reading ssl key from existing vault"
    export VAULT_ADDR='https://support.montagu.dide.ic.ac.uk:8200'
    if [ -z $VAULT_AUTH_GITHUB_TOKEN ]; then
        echo -n "Paste your github token: "
        read -s VAULT_AUTH_GITHUB_TOKEN
    fi
    vault login -method=github
    vault read -field=key secret/ssl/support > $FILE_CLEAR
fi

# Generate the symmetric key and encrypt our ssl private key with it
SYMKEY=$(openssl rand -hex 32)
echo "Generated symmetric key: $SYMKEY"
# If we generate and export in one step then error codes get swallowed
export SYMKEY
openssl aes-256-cbc -md md5 -in $FILE_CLEAR -out $FILE_ENC -pass "env:SYMKEY"

## Then encrypt the symmetric key with each public key:
rm -rf $PATH_KEY
mkdir -p $PATH_KEY
for KEY_NAME in $(ls -1 $PATH_PUBKEY); do
    FILE_PUBKEY="$PATH_PUBKEY/$KEY_NAME"
    echo "Creating key for $KEY_NAME"
    echo $SYMKEY |
        openssl rsautl -encrypt -oaep -pubin \
                -inkey <(ssh-keygen -e -f $FILE_PUBKEY -m PKCS8) \
                -out "$PATH_KEY/$KEY_NAME"
done

echo ""
echo "Now test that everything is working:"
echo "1) ./ssl-key/decrypt-key.sh"
echo "and check that you get the same symmetric key back out."
echo "2) ./scripts/decrypt-ssl-key-local.sh"
echo "and check there is no diff between the original key and the decrypted key"
echo "3) rm ./ssl-key/ssl_private_key ./ssl-key/ssl_private_key.copy"