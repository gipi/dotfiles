# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# add some paths
export PATH=~/dotfiles/bin/:~/bin/:~/.local/bin:/opt/git/bin/:$PATH

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias lld="ls -lUd */"
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# git PS1 stuffs
export GIT_PS1_SHOWDIRTYSTATE=1
if [ -f /usr/src/git/contrib/completion/git-completion.bash ]; then
    . /usr/src/git/contrib/completion/git-completion.bash
fi  # in order to show the brach in which you are
hash git && PS1+='$(__git_ps1 "(%s) ")'

envcreate() {
    ENV_ROOT='./.env3'
    test -n "$1" && ENV_ROOT="$1"/
    python3 -m venv "${ENV_ROOT}"
    source "${ENV_ROOT}"/bin/activate
    pip install pip-tools pipdeptree
}

envactivate() {
    test -n "$1" && ENV_ROOT="$1"/
    ENV_PATH="${ENV_ROOT:-.virtualenv}/bin/activate"

    if [ ! -f "${ENV_PATH}" ]
    then
        echo "virtualenv not found in '${ENV_PATH}'"
        return 1
    fi

    source "${ENV_PATH}"
}

cs() {
    test -z "$1" && echo 'usage: cs <dev> <name>' && return
    cryptsetup luksOpen $1 $2 && mount /dev/mapper/$2 /mnt/$2
}

decs() {
    test -z "$1" && echo 'usage: decs <name>' && return
    umount /mnt/$1
    cryptsetup remove $1
}

cl() {
    test  $# -eq 2 || {
        echo 'usage: clone <local dir> <git repository URL>'
        exit 1
    }
    set -o pipefail
    readonly LOCAL_DIR="$1"
    readonly GIT_URL="$2"
    readonly LOCAL_REPO_PATH="$(echo ${GIT_URL} | sed -e 's/\.git$//' -e 's/^.\+\///')"
    cd "${LOCAL_DIR}" && git clone "${GIT_URL}" && cd "${LOCAL_REPO_PATH}"
}

# symlink executable into your bin directory
xinstall() {
    FILENAME=${1?usage: xinstall <path>}
    # use the absolute path as destination link
    FILENAME=$(readlink -f ${FILENAME})
    DEST=~/bin/$(basename "${FILENAME}")
    echo ${DEST}
    test -L "${DEST}" && echo 'previous link point to '$(readlink -m "${DEST}") && unlink "${DEST}"
    ( cd ~/bin/ && ln -s "${FILENAME}" )
}

cdscreen() {
    cd $1 && screen
}
. ~/dotfiles/liquidprompt/liquidprompt


dockertor() {
    # launch a container (wo detaching) with tor
    docker run -v /etc/localtime:/etc/localtime:ro -p 9050:9050 jess/tor-proxy
}

curltor() {
    curl --socks http://localhost:9050 "$@"
}

pdf2booklet() {
    local readonly INPUT="${1:?usage: pdf2booklet <input file> [output file]}"
    local BASENAME="$(basename $1 .pdf)"
    local readonly OUTPUT="${2:-$BASENAME-booklet.pdf}"
    pdftops -level3 "${INPUT}" - | psbook | psnup -2 | ps2pdf - "${OUTPUT}"
}

# use "gem install --user <gem>" that Ruby is a mountain of shit
export PATH="$(ruby -rrubygems -e 'puts Gem.user_dir')/bin:$PATH"
