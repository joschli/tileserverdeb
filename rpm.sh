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
#-- Compile the things

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
cd ..
#-- copy things to pkg
rm -rf pkg/
mkdir pkg
cp -r mapnik pkg/
cp -r mod_tile pkg/
cp osm2pgsql/build/osm2pgsql pkg/osm2pgsql
chmod +x pkg/osm2pgsql/osm2pgsql
chmod +x hooks/after-install.sh

#-- Package all the things
rm -f *.deb
fpm -C pkg \
    -s dir \
    -t deb \
    --name tileserver \
    --version 1.0.0  \
    --description "TileServer setup (mapnik, osm2pgsql, mod_tile)" \
    --after-install hooks/after-install.sh \
    .


