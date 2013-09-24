#!/bin/bash
# usage: bin/compile <build-dir> <cache-dir>

set -eo pipefail

mkdir -p "$1" "$2"
build=$(cd "$1/" && pwd)
cache=$(cd "$2/" && pwd)
ver=${MOSQUITTOVERSION:-1.2.1}
file=${MOSQUITTOFILE:mosquitto$ver.tar.gz}
url = http://mosquitto.org/files/source/$file

if test -e $build/bin && ! test -d $build/bin
then
    echo >&2 " !     File bin exists and is not a directory."
    exit 1
fi

if test -d $cache/mosquitto-$ver
then
    echo "-----> Using Mosquitto $ver"
else
    rm -rf $cache/* # be sure not to build up cruft
    mkdir -p $cache/mosquitto-$ver
    cd $cache/mosquitto-$ver
    echo -n "-----> Installing Mosquitto $ver..."
    curl -sO $url
    tar -zxf $file
    rm -f $file
    echo " done"
fi


#assumes following packages installed already
#openssl
#libssl-dev
#g++
#python

cd $cache/mosquitto-$ver/mosquitto-$ver
make
sudo make install

