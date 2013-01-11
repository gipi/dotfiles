#!/bin/bash
#
# Simple script to bootstrap these dot files
#
# Check for pre-existent files and alert the user.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR=$(readlink -f ${SCRIPT_DIR}/..)

HOME_PATH="$HOME"
IS_INTERACTIVE=0
IS_DRY=0

usage() {
    cat <<EOF
usage: $0 [--no-interactive] [--dry] [--help] [/path/to/home/dir/]

Install the dot files in your home directory. Accepts some
options:

    --no-interactive    ask before overwrite [unimplemented]
    --dry               doesn't perform any action

If an argument is passed then is used as home directory.
EOF
}

exit_out() {
    test -n "$1" && PREFIX=": "
    echo $1${PREFIX}$2
    exit $3
}

die() {
    exit_out "fatal" "$1" $2
}

test $# -eq 0 && {
    usage

    echo  -en "\n\n\nI'll go to install all the things, is it this ok? (yes/no) "
    read response
    if [ "${response}" != 'yes' ]; then exit_out '' 'ok master' 0; fi
}

# check options
while [[ $1 ]]
    do
    case "$1" in
        --help)
            usage
            exit_out '' '' 0
            ;;
        --no-interactive)
            IS_INTERACTIVE=1
            shift
            ;;
        --dry)
            IS_DRY=1
            shift
            ;;
        *)
            HOME_PATH=$1
            test -d "${HOME_PATH}" || die "'"$HOME_PATH"'"' no such file or directory' 1
            shift
            ;;
    esac
done

echo Installing in "${HOME_PATH}"

while read f
do
    case "$f" in
        README|conf)
            ;;
        *)
            SRC="$(readlink -f "${DOTFILES_DIR}"/"$f")"
            PREFIX="$(test -f "$SRC" && echo ".")"
            DST="${HOME_PATH}"/${PREFIX}"$f"
            test -e "$DST" && echo " * '${DST}' exists, it'll be backuped"
            test ${IS_DRY} -eq 0 && ln -s -v --backup=numbered "${SRC}" "${DST}"
            ;;
    esac
done < <(ls "${DOTFILES_DIR}")
