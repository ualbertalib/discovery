#!/bin/bash
#
# This is for docker! Customized script for our discovery project.
# As discovery needs both a development and test core.
#
# This script was mostly stolen from the official solr-precreate script:
# https://github.com/docker-solr/docker-solr/blob/master/scripts/solr-precreate
set -e

echo "Executing $0 $@"

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi

if [[ -z $SOLR_HOME ]]; then
    coresdir="/opt/solr/server/solr/mycores"
    mkdir -p $coresdir
else
    coresdir=$SOLR_HOME
fi

coredir_dev="$coresdir/discovery"
if [[ ! -d $coredir_dev ]]; then
    cp -r /myconfig/ $coredir_dev
    touch "$coredir_dev/core.properties"
    echo "created discovery core"
else
    echo "core discovery already exists"
fi

coredir_test="$coresdir/discovery-test"
if [[ ! -d $coredir_test ]]; then
    cp -r /myconfig/ $coredir_test
    touch "$coredir_test/core.properties"
    echo "created discovery-test core"
else
    echo "core discovery-test already exists"
fi
