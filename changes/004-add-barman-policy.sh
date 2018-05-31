#!/bin/sh
set -e
echo "Adding policy 'barman', which allows access to the production barman passwords"
vault policy write barman config/barman.policy
