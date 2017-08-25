#/bin/sh
set -e
echo "Enabling the science team to read from /secret/database"
vault policy-write readonly config/readonly.policy
vault write auth/github/map/teams/admin value=readonly
