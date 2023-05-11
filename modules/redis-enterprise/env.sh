#!/bin/bash

while [[ -z $DB_PASSWORD ]]
do
  DB_PASSWORD=$(kubectl get secrets -n redis redb-redis-enterprise-database \
  -o jsonpath="{.data.password}" | base64 --decode)
  sleep 1 # wait for 1 second before checking again
done

cat <<EOF
{
  "db_password": "$DB_PASSWORD"
}
EOF
