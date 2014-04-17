# TODO: insert this below
# <command> | curl -F 'sprunge=<-' http://sprunge.us
alias envcreate='virtualenv --no-site-packages env/'
alias triforce="echo -e '\x20\xe2\x96\xb2\x0a\xe2\x96\xb2\x20\xe2\x96\xb2\x20'"
alias debchange="zless /usr/share/doc/$0/changelog.Debian.gz"
alias genpasswrd="cat /dev/urandom | LC_ALL=C tr -cd '[a-zA-Z0-9]' | head -c 12"
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias xbackup='rsync --update  --archive --xattrs --verbose'
