#!/bin/sh
# TODO: dependencies check (asciidoc)
REV=$1
BASE_SOURCE_PATH=/usr/src/
SOURCE_PATH="${BASE_SOURCE_PATH}git/"
PREFIX=/opt/git-${REV}/

cd ${SOURCE_PATH} || {
	die "the source code repository doesn't exist at '$SOURCE_PATH', clone it at 'git://github.com/git/git.git' or use --bootstrap" 1
}


die() {
	echo -e "fatal: $1"
	exit $2
}

update() {
    git fetch
}

usage() {
    echo "$0 [--update | --bootstrap | revision]"

}

if [ -z "$1" ]
then
	echo "I need a revision (e.g. a tag like 'v1.7.10.1')"
    usage
	exit 1
fi

if [ "$1" == "--update" ]
then
    update
    exit 0
fi

if [ "$1" == '--bootstrap' ]
then
    (
    cd "${BASE_SOURCE_PATH}" && \
        wget https://github.com/git/git/archive/v1.8.1.tar.gz && \
        tar zxvf v1.8.1.tar.gz && \
        cd v1.8.1
    )
else
    git checkout -f $REV || exit 1
fi

make configure
./configure --prefix=$PREFIX || exit 1
make -j 2 && \
	make install && \
	make -j 2 doc && \
	make install-doc && \
    (test -d contrib/subtree && cd contrib/subtree && make prefix=$PREFIX && make prefix=$PREFIX install) && \
	cd /opt/ && unlink git;
# TODO: check if is the first installation and avoid unlink above
ln -s git-${REV} git
cp ${SOURCE_PATH}/contrib/completion/git-completion.bash ${PREFIX}
