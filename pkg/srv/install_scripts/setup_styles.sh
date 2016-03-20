#!/bin/bash

MASTER_STYLE="https://github.com/mapbox/osm-bright/archive/master.zip"
SIMPLIFIED_POLY="http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip"
LAND_POLY="http://data.openstreetmapdata.com/land-polygons-split-3857.zip"
SIMPLIFIED_SHAPE_NEW="\"/srv/osm-bright-master/shp/simplified-land-polygons-complete-3857/simplified-land-polygons-complete-3857.shp\", \"type\": \"shape\""

SIMPLIFIED_SHAPE_OLD="\"http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip\""

SPLIT_SHAPE_OLD="\"http://data.openstreetmapdata.com/land-polygons-split-3857.zip\""

SPLIT_SHAPE_NEW="\"/srv/osm-bright-master/shp/land-polygons-split-3857/land-polygons-split-3857.shp\", \"type\": \"shape\""

PROJECT_FILE="/srv/styles/osm-bright-master/osm-bright/osm-bright.osm2pgsql.mml"
# DOWNLOAD STYLES
mkdir /srv/styles
cd /srv/styles
wget $MASTER_STYLE
wget $SIMPLIFIED_POLY
wget $LAND_POLY

# UNZIP & MOVE
unzip '*.zip'
rm -rf /srv/styles/*.zip
mkdir osm-bright-master/shp
mv land-polygons-split-3857 osm-bright-master/shp/
mv simplified-land-polygons-complete-3857 osm-bright-master/shp/

# INDEX SHAPES
cd osm-bright-master/shp/land-polygons-split-3857
shapeindex land_polygons.shp
cd ../simplified-land-polygons-complete-3857/
shapeindex simplified_land_polygons.shp
cd ../..

# REPLACE SHAPE FILES & REMOVE POPULATED
sed -i "s|$SIMPLIFIED_SHAPE_OLD|$SIMPLIFIED_SHAPE_NEW|g" $PROJECT_FILE
sed -i "s|$SPLIT_SHAPE_OLD|$SPLIT_SHAPE_NEW|g" $PROJECT_FILE
sed -i '401,413 d' $PROJECT_FILE
# Configure style
cp /srv/styles/osm-bright-master/configure.py.sample /srv/styles/osm-bright-master/configure.py

sed -i 's/osm\"/gis\"/' /srv/styles/osm-bright-master/configure.py
sed -i 's|~/Documents/MapBox/project|/srv/styles|' srv/styles/osm-bright-master/configure.py

# Compile style
cd /srv/styles/osm-bright-master/
./make.py 
pushd ../OSMBright
sh -c "carto project.mml > OSMBright.xml"
popd

# Set permissions
chown -R algogis /srv/styles
 
