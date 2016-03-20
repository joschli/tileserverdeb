#!/bin/bash


if grep -q "/usr/local/etc/renderd.conf" /etc/apache2/sites-available/000-default.conf ; then
	echo "renderd was already added to apache config"
else
	sed -i "s|ServerAdmin webmaster@localhost|ServerAdmin webmaster@localhost\n\tLoadTileConfigFile /usr/local/etc/renderd.conf\n\tModTileRenderdSocketName /var/run/renderd/renderd.sock\n\tModTileRequestTimeout 0\n\tModTileMissingRequestTimeout 30|" /etc/apache2/sites-available/000-default.conf
fi

a2enconf mod_tile
service apache2 reload
sudo -u algogis renderd -f -c /usr/local/etc/renderd.conf
