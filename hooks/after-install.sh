#!/bin/bash

##-- Install Mapnik & Mod_tile
cd install_pkg
cd mapnik
make install
ldconfig
cd ..
cd mod_tile
make install
make install-mod_tile
ldconfig
cd ../../
rm -rf install_pkg

