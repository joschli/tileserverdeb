#!/bin/bash

chmod +x setup_user_postgis.sh
chmod +x move_postgres.sh
chmod +x setup_styles.sh
chmod +x setup_dataset.sh
chmod +x setup_apache.sh
chmod +x load_mod_tile.sh

echo "Do you want to setup a postgis user (algogis) and the gis db?(y/n):"
read postgis
if [ $postgis == "y" ]; then
	./setup_user_postgis.sh
fi

echo "Do you want to move your postgres dir to /srv/postgresql/?(y/n):"
read move
if [ $move == "y" ]; then
	./move_postgres.sh
fi

echo "Do you want to compile the osm-bright style?(y/n):"
read osmbright
if [ $osmbright == "y" ]; then
	./setup_styles.sh
fi

echo "Do you want to download and install a dataset?(y/n):"
read dataset
if [ $dataset == "y" ]; then
	./setup_dataset.sh
fi

echo "Do you want to change the renderd.conf and create a mod_tile.conf?(y/n):"
read renderd
if [ $renderd == "y" ]; then
	./setup_apache.sh
fi

echo "Do you want to change your apache2 config (may overwrite existing config) and start renderd?(y/n)"
read start
if [ $start == "y" ]; then
	./load_mod_tile.sh
fi
