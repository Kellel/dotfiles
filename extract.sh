#!/usr/bin/env bash
VERSION_FILE=~/.dotversion

get_installed_version() {
    read line < $VERSION_FILE
    return $line
}

get_pkg_version() {
    read line < ~/.dotfiles/version
    return $line
}

do_install() {
    # Start with vim items
    ln -is ~/.dotfiles/vim/vimrc ~/.vimrc
    ln -is ~/.dotfiles/vim/vim ~/.vim
    # Do bash
    ln -is ~/.dotfiles/bashrc ~/.bashrc

    cp ~/.dotfiles/version $VERSION_FILE
}

if [ -f "$VERSION_FILE" ]; then
    if [[ "$(get_pkg_version)" == "$(get_installed_version)" ]]
    then
        echo "Dotfiles are already at the newest version!"
        exit 1
    fi
else
    do_install
fi
