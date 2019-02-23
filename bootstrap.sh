#!/bin/bash

# root for all srcroutine files
SRCROUTINE_ROOT="/usr/src"

# where the LFS sources currently live (see below)
LFS_SOURCES="/sources"

# whether or not to organize /sources dir into SRCROUTINE_ROOT; assumes kernel sources and patches are in LFS_SOURCES like LFS documents
MOVE_LFS=1

# binary dir to install the srcroutine script
BIN_DIR="/usr/local/bin"

# whether or not to attempt to install as non-root user
FORCE=0

# begin bootstrapping code

if [[ "$EUID" != "0" ]] && [[ "$FORCE" != 1 ]]; then
	echo "bootstrap script must be run as root! to ignore this, modify the bootstrap.sh to set FORCE=1"
	exit 1
fi
echo -n "before running this script, be sure you read the variables in the header and modified if nescessary! press any key to continue, CTRL^C to exit. "
read

# generate file structures
echo "creating $SRCROUTINE_ROOT structure..."
mkdir -p $SRCROUTINE_ROOT/{lib,tars/linux,patches/lfs,routines/{lfs,linux}}

# if enabled, convert LFS structure to srcroutine structure 
if [[ "$MOVE_LFS" == 1 ]]; then
	echo "migrating $LFS_SOURCES to $SRCROUTINE_ROOT..."
	mv $LFS_SOURCES $SRCROUTINE_ROOT/tars/lfs
	mv $SRCROUTINE_ROOT/tars/lfs/linux* $SRCROUTINE_ROOT/tars/linux/
	mv $SRCROUTINE_ROOT/tars/lfs/*.patch $SRCROUTINE_ROOT/patches/lfs
fi

# copy over scripts
echo "copying binaries..."
cp ./bin/srcroutine $BIN_DIR/srcroutine
cp ./lib/env $SRCROUTINE_ROOT/lib/env

# replace placeholders with vars from headers
echo "replacing placeholder variables..."
sed -i "s~BOOTSTRAP_SRCROUTINE_ROOT_PLACEHOLDER~$SRCROUTINE_ROOT~" $SRCROUTINE_ROOT/lib/env
sed -i "s~BOOTSTRAP_SRCROUTINE_ROOT_PLACEHOLDER~$SRCROUTINE_ROOT~" $BIN_DIR/srcroutine

echo "done! you can now run the srcroutine command."
