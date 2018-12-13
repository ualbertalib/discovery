#!/bin/sh
#
# This is for docker! Customized script for our discovery project.
# As discovery needs yaz installed as a dependency for zoom
git clone https://github.com/indexdata/yaz.git
cd yaz/
apt-get -y install autoconf automake libtool gcc bison tclsh xsltproc docbook docbook-xml docbook-xsl libxslt1-dev libreadline-dev libwrap0-dev pkg-config libicu-dev make
./buildconf.sh
./configure --enable-shared
make
make check
make install
