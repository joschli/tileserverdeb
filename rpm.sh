#!/bin/bash

#-- Install build dependencies
apt-get install make
apt-get install cmake
apt-get install g++ 
apt-get install libboost-all-dev 
apt-get install fpm
apt-get install libexpat1-dev zlib1g-dev libbz2-dev libpq-dev libgeos-dev libgeos++-dev libproj-dev lua5.2 liblua5.2-dev python
apt-get install libharfbuzz-dev libpng-dev libfreetype6-dev
apt-get install autoconf apache2-dev
apt-get install git
apt-get install postgresql postgresql-contrib postgis postgresql-9.4-postgis-2.1
#-- Compile the things
mkdir build
cd build
#-- osm2psql
git clone git://github.com/openstreetmap/osm2pgsql.git
cd osm2pgsql
mkdir build 
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j12
cd ../../

#-- mapnik
git clone -b v3.0.9 git://github.com/mapnik/mapnik
cd mapnik
./configure
JOBS=12 make 
cd ..
#-- mod_tile
git clone git://github.com/openstreetmap/mod_tile.git
cd mod_tile
./autogen.sh
./configure
make -j12
cd ../../
#-- copy things to pkg
rm -rf pkg/
mkdir -p pkg/usr/local/bin/
mkdir -p pkg/install_pkg
cp -r build/mapnik pkg/install_pkg/mapnik
cp -r build/mod_tile pkg/install_pkg/mod_tile
cp -r build/osm2pgsql/build/osm2pgsql pkg/usr/local/bin/osm2pgsql
chmod +x pkg/usr/local/bin/osm2pgsql
chmod +x hooks/after-install.sh

#-- Package all the things
rm -f *.deb
fpm -C pkg \
    -s dir \
    -t deb \
    --name tileserver \
    --version 1.0.0  \
    --depends postgresql,postgresql-contrib,postgis,postgresql-9.4-postgis-2.1,apache2,autoconf,apache2-dev,libboost-all-dev,zlib1g-dev,libfreetype6-dev,libharfbuzz-dev,libpng-dev,libproj-dev,libpq-dev,node-carto,unifont,ttf-dejavu \
    --description "TileServer setup (mapnik, osm2pgsql, mod_tile)" \
    --after-install hooks/after-install.sh \
    .


