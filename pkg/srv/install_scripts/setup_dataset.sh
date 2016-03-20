#!/bin/bash
if [ -d "/srv/planet/" ]; then
	echo "A dataset already exists at /srv/planet/ this action could overwrite the existing dataset. Do you want to proceed?(y/n)"
	read proceed
	if [ ! $proceed == "y" ]; then
		exit 1;
	fi

fi
mkdir -p /srv/planet
cd /srv/planet
echo "Planet (p), Hamburg (h) or Germany (g) dataset ?:"
read dataset
file=""
file_name=""
if [ $dataset == "p" ]; then
	file="http://planet.openstreetmap.org/pbf/planet-latest.osm.pbf"
	file_name="planet-latest.osm.pbf"
elif [ $dataset == "g" ]; then
	file="http://download.geofabrik.de/europe/germany-latest.osm.pbf"
	file_name="germany-latest.osm.pbf"
elif [ $dataset == "h" ]; then
	file="http://download.geofabrik.de/europe/germany/hamburg-latest.osm.pbf"
	file_name="hamburg-latest.osm.pbf"
fi
if [ ! $file == "" ] && [ ! $file_name == "" ]; then
	if [ ! -f "/srv/planet/$file_name" ]; then
		wget $file
	fi
else 
	exit 1;
fi 
chown -R algogis /srv/planet/
echo "Do you want to use fast and slowspace ?(y/n)"
read fast

if [ $fast == "y" ]; then
	exit 1;
else 
	sudo -u algogis osm2pgsql --verbose --unlogged --cache-strategy dense --create --slim --drop -d gis -C 4096 --number-processes 2 --disable-parallel-indexing --flat-nodes /srv/planet/nodes.flat $file_name
fi	


