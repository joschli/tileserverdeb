#!/bin/bash

file_name="/usr/local/etc/renderd.conf"

sed -i "s|;socketname=/var/run/renderd/renderd.sock|socketname=/var/run/renderd/renderd.sock|g" $file_name

sed -i "s|plugins_dir=/usr/lib/mapnik/input|plugins_dir=/usr/local/lib/mapnik/input|g" $file_name

sed -i "s|font_dir=/usr/share/fonts/truetype|font_dir=/usr/share/fonts/truetype/ttf-dejavu|g" $file_name

sed -i "s|XML=/home/jburgess/osm/svn.openstreetmap.org/applications/rendering/mapnik/osm-local.xml|XML=/srv/styles/OSMBright/OSMBright.xml|g" $file_name

sed -i "s|HOST=tile.openstreetmap.org|HOST=localhost|g" $file_name
echo "changed config file /usr/local/etc/renderd.conf" 
if [ ! -d "/var/run/renderd" ] && [ ! -d "/var/lib/mod_tile" ]; then
	mkdir /var/run/renderd
	mkdir /var/lib/mod_tile
	chown algogis /var/run/renderd
	chown algogis /var/lib/mod_tile
	echo "renderd dir created at /var/run/renderd"
	echo "mod_tile dir created at  /var/lib/mod_tile"
fi
if [ ! -f "/etc/apache2/conf-available/mod_tile.conf" ]; then
	echo "LoadModule tile_module /usr/lib/apache2/modules/mod_tile.so" >> /etc/apache2/conf-available/mod_tile.conf
	echo "Mod_tile config created at /etc/apache2/conf-available/"
fi
