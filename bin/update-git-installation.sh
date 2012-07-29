#!/bin/sh
# TODO: dependencies check (asciidoc)

die() {
	echo -e "fatal: $1"
	exit $2
}

if [ -z "$1" ]
then
	echo "I need a revision (e.g. a tag like 'v1.7.10.1')"
	exit 1
fi

REV=$1
SOURCE_PATH=/usr/src/git/
PREFIX=/opt/git-${REV}

cd ${SOURCE_PATH} || {
	die "the source code repository doesn't exist at '$SOURCE_PATH', clone it at 'git://github.com/git/git.git'" 1
}

git fetch
git checkout -f $REV || exit 1
make configure
./configure --prefix=$PREFIX || exit 1
make -j 2 && \
	make install && \
	make -j 2 doc && \
	make install-doc && \
    (test -d contrib/subtree && cd contrib/subtree && make prefix=$PREFIX && make prefix=$PREFIX install) && \
	cd /opt/ && unlink git ; ln -s git-${REV} git
