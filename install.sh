#!/bin/bash

ignore=( scripts backups install.sh README.md )

DIR=dotfiles
BACKUP_DIR=backups/

cd
cd $DIR

if [[ ! -d $BACKUP_DIR ]] ; then
	mkdir $BACKUP_DIR
fi

git submodule init
git submodule update
for filename in *
do
	# check if the file should be ignored
	shouldIgnore=false
	for ignorename in ${ignore[@]}
	do
		if [[ $filename == $ignorename ]]
		then
			shouldIgnore=true
		fi
	done
	
	# if you shouldn't ignore, and it's not already linked
	if [ $shouldIgnore == false -a ! -L ~/.$filename ]
	then

		# move old versions moved to backup dir
		if [ -e ~/.$filename ]
		then
			echo ${filename} moved to ${BACKUP_DIR}/${filename}
			mv ~/.$filename $BACKUP_DIR
		fi
		
		# create the link
		echo new link ~/.${filename} to ${BACKUP_DIR}/${filename}
		ln -s $DIR/$filename ~/.$filename
	fi
done

# Fixup gitconfig if we're running an older version that doesn't support simple push
GIT_VER=$( git --version | sed -e 's/.* //' ) 
if perl -mversion -e "exit(version->parse($GIT_VER) >= version->parse('1.7.11')) " 
then 
    git config --global push.default 
fi

VIM=`which mvim`
if [[ "$VIM" == "" ]] ; then
	VIM=`which vim`
fi
# let vundle install Plugins
# if [[ ! -h ~/.vim/vundle ]] ; then 
#     mv ~/.vim/vundle ~/.vim/vundle.bak
#     OS=$( uname -sr | sed -e 's/ /_/g' )
#     mkdir ~/.vim/vundle.$OS
#     ln -s ~/.vim/vundle.$OS ~/.vim/vundle
# fi
$VIM +PluginInstall +qall

# compile YouCompleteMe
cd ~/.vim/vundle/YouCompleteMe && ./install.sh  --clang-completer  # --omnisharp-completer for c#

# source bashrc
source ~/.bashrc
