#!/bin/bash
###############################
#
#  THIS SCRIPT IS UNTESTED
#
###############################
SRCROUTINE_ROOT="/usr/src"
LFS_SOURCES="/sources"
MOVE_LFS=1 # whether or not to organize /sources dir into SRCROUTINE_ROOT; assumes kernel sources and patches are in LFS_SOURCES like LFS documents
BIN_DIR="/usr/local/bin"

# generate file structures
mkdir -p $SRCROUTINE_ROOT/{lib,tars/linux,patches/lfs,routines/{lfs,linux}}

# if enabled, convert LFS structure to srcroutine structure 
if [[ "$MOVE_LFS" == 1 ]]; then
	mv $LFS_SOURCES $SRCROUTINE_ROOT/tars/lfs
	mv $SRCROUTINE_ROOT/tars/lfs/linux* $SRCROUTINE_ROOT/tars/linux/
	mv $SRCROUTINE_ROOT/tars/lfs/*.patch $SRCROUTINE_ROOT/patches/lfs
fi

# copy over scripts
cp ./bin/srcroutine $BIN_DIR/bin
cp ./lib/env $SRCROUTINE_ROOT/lib/env

# replace placeholders with vars from headers
sed -i s/BOOTSTRAP_SRCROUTINE_ROOT_PLACEHOLDER/$SRCROUTINE_ROOT/g $SRCROUTINE_ROOT/lib/env
sed -i s/BOOTSTRAP_SRCROUTINE_ROOT_PLACEHOLDER/$SRCROUTINE_ROOT/g $BIN_DIR/srcroutine
