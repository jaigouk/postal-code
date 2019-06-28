#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=${DIR%"/bin"}
PRIV_DIR="$ROOT_DIR/priv"
DATA_DIR="$ROOT_DIR/priv/libpostal_data"
echo $PRIV_DIR
mkdir -p $DATA_DIR
cd $PRIV_DIR

sudo apt-get install curl autoconf automake libtool pkg-config
git clone https://github.com/openvenues/libpostal
cd libpostal
./bootstrap.sh
./configure --datadir=$DATA_DIR
make -j4
sudo make install
sudo ldconfig
