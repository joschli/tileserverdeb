#!/bin/bash

NEW_PATH="/srv/postgresql"
OLD_PATH="/var/lib/postgresql/9.4/main"
FILE_PATH="/etc/postgresql/9.4/main/postgresql.conf"

# REMOVE OLD DIRS
rm -rf /srv/postgresql

# STOP SERVICES
systemctl stop postgresql

# CHANGE POSTGRES DIRECTORY
sed -i "s|$OLD_PATH|$NEW_PATH|g" $FILE_PATH

# CREATE STRUCTURE
mkdir -p /srv/postgresql

# COPY POSTGRESQL
cp -r $OLD_PATH/. $NEW_PATH/

# FIX PERMISSIONS
chown -R postgres:postgres /srv/postgresql/
chmod 700 /srv/postgresql/



# START SERVICES
systemctl start postgresql


