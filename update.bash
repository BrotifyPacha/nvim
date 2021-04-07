#!/bin/bash
cd ~
git clone https://github.com/BrotifyPacha/nvim
rm -rf .vim
mv nvim .vim
mv .vim/init.vim .vim/vimrc

