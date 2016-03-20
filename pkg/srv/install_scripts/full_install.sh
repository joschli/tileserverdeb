#!/bin/bash

chmod +x setup_user_postgis.sh
chmod +x move_postgres.sh
chmod +x setup_styles.sh
chmod +x setup_dataset.sh
chmod +x setup_apache.sh
chmod +x load_mod_tile.sh

./setup_user_postgis.sh
./move_postgres.sh
./setup_styles.sh
./setup_datset.sh
./setup_apache.sh
./load_mod_tile.sh
