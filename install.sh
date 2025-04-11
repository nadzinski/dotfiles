#!/bin/bash

dir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
olddir=${dir}_old

function link_file {
    file="$1"
    if [ ! -L ~/$file ]; then
        if [ -f ~/$file -a -f "$olddir/$homedir/$file" ]; then
            echo "Skipping $file: backup would be overwritten"
        else
            if [ -f ~/$file ]; then
                echo "Backing up $file"
                mkdir -p $olddir/$homedir
                mv ~/$file $olddir/$homedir
            fi
            echo "Symlinking $file"
            ln -s $dir/$homedir/$file ~/$file
        fi
    else
        echo "Skipping $file: symlink already exists" 
    fi
}

mkdir -p $olddir
cd $dir

homedir="home"
find "$dir/$homedir" -type f | while read f; do
    link_file "$( basename $f)" "$homedir"
done

./scripts/vim_plugins.sh

if [ -n "${CODESPACE_NAME}" ]; then
    ./scripts/codespaces.sh
fi
