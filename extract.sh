#!/usr/bin/env bash
VERSION_FILE=~/.dotversion
INTERNAL_VERSION_FILE=~/.dotfiles/version
INSTALLHOOKFILE=INSTALLHOOK
PKG_PATH=~/.dotfiles/pkgs
BASH=`which bash`

get_installed_version() {
    local line
    read line < $VERSION_FILE
    echo $line
}

get_pkg_version() {
    git rev-parse --verify HEAD
}

do_install() {

    for pkg in `ls $PKG_PATH`; do
        for file in `ls $PKG_PATH/$pkg`; do
            if [ "$file" = "$INSTALLHOOKFILE" ]; then
                echo "$PKG_PATH/$pkg/$file is an install-hook execing"
                $BASH $PKG_PATH/$pkg/$file
            else
                ln -Tis $PKG_PATH/$pkg/$file ~/.$file
            fi
        done
    done

    cp $INTERNAL_VERSION_FILE $VERSION_FILE
}

if [ -f "$VERSION_FILE" ] && [ `get_pkg_version` == `get_installed_version` ]; then
    echo "Dotfiles are already at the newest version!"
    exit 1
else
    echo "Installing Dotfiles"
    do_install
fi
