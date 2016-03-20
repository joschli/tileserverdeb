#!/bin/bash

DATABASE_NAME="gis"

# SETUP USER FOR DB
sudo -u postgres createuser algogis
sudo -u postgres createdb -E UTF8 -O algogis gis
useradd -m algogis

# SETUP DB
sudo -u postgres psql $DATABASE_NAME -c 'CREATE EXTENSION postgis;ALTER TABLE geometry_columns OWNER TO algogis; ALTER TABLE spatial_ref_sys OWNER TO algogis;'
