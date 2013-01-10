#!/bin/bash
# TODO: switch for documentation build
# TODO: dependencies check
#  apt-get install --no-install-recommends build-essential zlib1g-dev asciidoc gettext xsltproc xmlto
IS_BOOTSTRAP=0
IS_UPDATE=0

BASE_SOURCE_PATH=/usr/src/
SOURCE_PATH="${BASE_SOURCE_PATH}git/"

die() {
	echo -e "fatal: $1"
	exit $2
}

update() {
    git fetch
}


usage() {
    cat <<EOF
usage: $0 [--source-path <path>] [--update | --bootstrap | revision]
EOF
}

test -z "$1" && {
    echo -e "I need a revision (e.g. a tag like 'v1.7.10.1')\n"
    usage
    exit 1
}

while [[ $1 ]]
do
    case "$1" in
        --bootstrap)
            IS_BOOTSTRAP=1
            REV=v1.8.1
            shift
            ;;
        --update)
            IS_UPDATE=1
            shift
            ;;
        --source-path)
            BASE_SOURCE_PATH=$2
            SOURCE_PATH="$2"
            shift 2
            ;;
        *)
            #TODO: check for correctness of revision
            test -d ${SOURCE_PATH} || {
                die "the source code repository doesn't exist at '$SOURCE_PATH', clone it at 'git://github.com/git/git.git' or use --bootstrap" 1
            }
            REV=$1
            shift
            ;;
    esac
done

# FROM HERE WE ARE SURE THAT ALL THE PREREQUISITES ARE OK
bootstrap() {
    cd "${BASE_SOURCE_PATH}"
    SOURCE_PATH="${BASE_SOURCE_PATH}/git-1.8.1"
    test -d git-1.8.1 || {
        test -f v1.8.1.tar.gz || {
            wget https://github.com/git/git/archive/v1.8.1.tar.gz
        }
        tar zxvf v1.8.1.tar.gz
    }
    # check that destination directory is writable by the user
    NOT_WRITABLE=0
    mkdir /opt/DELETEME || NOT_WRITABLE=1 && rmdir /opt/DELETEME
    test $NOT_WRITABLE -eq 1 && die "destination directory ('/opt') it's not writable" 1
    cd git-1.8.1
}

checkout() {
    if [ $IS_BOOTSTRAP -eq 1 ]
    then
        bootstrap
    else
        cd "${SOURCE_PATH}" && git checkout -f ${REV-master} || exit 1
    fi
}

compile_and_install() {
    make configure
    ./configure --prefix=$PREFIX || exit 1
    make -j 2 && \
        make install && \
        make -j 2 doc && \
        make install-doc && \
        (test -d contrib/subtree && cd contrib/subtree && make prefix=$PREFIX && make prefix=$PREFIX install)
        cd /opt/ && unlink git;
    # TODO: check if is the first installation and avoid unlink above
    ln -s git-${REV} git
    cp ${SOURCE_PATH}/contrib/completion/git-completion.bash ${PREFIX}
}
PREFIX=/opt/git-${REV}/

checkout
if [ $IS_UPDATE -eq 0 ]
then
    compile_and_install
else
    update
fi
