#!/bin/sh

DOTPATH=~/dotfiles

for f in .??*
do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".bash" ] && continue
    ln -snfv "$DOTPATH/$f" "$HOME"/"$f"
    #unlink "$HOME"/"$f"
done
