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

# let vundle install Plugins
vim +PluginInstall +qall

# source bashrc
source ~/.bashrc
