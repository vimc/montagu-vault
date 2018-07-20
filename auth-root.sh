#!/usr/bin/env bash
set -e
echo -n "Root token: "
read -s TOKEN
vault login $TOKEN > /dev/null
echo "Authorised"
