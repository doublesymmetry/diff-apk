if brew list | (grep -q "$1"; ret=$?; cat >/dev/null; exit $ret); then
    echo "$1 is installed"
else
    echo "$1 is not installed"
    brew install "$1"
fi
