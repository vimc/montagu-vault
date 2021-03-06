#/bin/sh
set -e

echo -n "Root token: "
read -s TOKEN

HERE=$(dirname $0)

vault login $TOKEN
vault auth-enable github
vault write auth/github/config organization=vimc
vault write auth/github/map/teams/development value=standard
vault policy-write standard "$HERE/../config/standard.policy"

echo "Enabled GitHub authentication for the development team in the vimc organization"
echo "You can now authenticate against the vault using"
echo "    vault login -method=github token=[GITHUB PERSONAL ACCESS TOKEN]"
echo "To obtain your GitHub personal access token see https://help.github.com/articles/creating-an-access-token-for-command-line-use/"
