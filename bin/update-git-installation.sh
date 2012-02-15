#!/bin/sh

if [ -z "$1" ]
then
	echo "I need a revision"
	exit 1
fi

REV=$1
SOURCE_PATH=/usr/src/git/

cd ${SOURCE_PATH} || exit 1
git fetch
git checkout -f $REV || exit 1
make configure
./configure --prefix=/opt/git-${REV} || exit 1
make -j 2 && make install && make -j 2 doc && make install-doc && \
	cd /opt/ && unlink git && ln -s git-${REV} git
