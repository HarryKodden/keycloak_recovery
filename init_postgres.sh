#!/bin/bash

# this script is run when the docker container is built
# it imports the base database structure and create the database for the tests

echo "Mount backup storage..."
mount ~/backup

DATABASE_NAME="keycloak"
DB_DUMP_LOCATION=`ls -t /var/lib/postgresql/backup/dump* | head -n 1`

echo "Copy file: $DB_DUMP_LOCATION..."
cat $DB_DUMP_LOCATION >/tmp/data
umount ~/backup

echo "Restoring into $DATABASE_NAME..."
cat /tmp/data | psql $DATABASE_NAME

echo "Ready !"
