#!/bin/sh
set -e
echo "Adding policy 'barman', which allows access to the production barman passwords"
vault policy write barman config/barman.policy

echo "Granting users in the 'standard' policy the ability to create tokens with the barman policy"
vault policy write standard config/standard.policy
vault write auth/github/map/teams/development value=standard,barman
