# if there's a .secrets file with environment options, source it
if [ -f $HOME/.secrets ]; then
	source $HOME/.secrets
fi

path_prepend ()
{
	if [[ -d $1 ]] ; then 
		PATH=${PATH//":$1"/} #delete any instances in the middle or at the end
		PATH=${PATH//"$1:"/} #delete any instances at the beginning
		export PATH="$1:$PATH" #prepend to beginning
	fi
}

if [[ -d ~/google-cloud-sdk/ ]] ; then
    # The next line updates PATH for the Google Cloud SDK.
    source ~/google-cloud-sdk/path.bash.inc
    # The next line enables bash completion for gcloud.
    source ~/google-cloud-sdk/completion.bash.inc
fi

path_prepend /usr/local/share/npm      # for node
path_prepend /usr/local/lib            # for python
path_prepend /usr/local/heroku/bin     # for heroku
path_prepend $HOME/.rvm/bin            # for rvm
path_prepend /Applications 
path_prepend /usr/texbin 
path_prepend /Applications/Postgres.app/Contents/Versions/9.3/bin
path_prepend /usr/local/bin

# sync bash history with multiple sessions
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

if [ `which lesspipe.sh` ] ; then
	export LESSOPEN="|lesspipe.sh %s"
fi

# ALWAYS VIM
export EDITOR=vim
if [ `which mvim` ] ; then
	#export EDITOR="mvim -f --nomru -c 'au VimLeave * !open -a $TERM_PROGRAM'"
	export EDITOR=`which vim`
	alias vim=mvim

fi
set -o emacs

# source my xmodmap
[[ -f ~/.xmodmap ]] && xmodmap ~/.xmodmap 2>/dev/null

# git bash autocomplete
BREW=`which brew`
if [[ "$BREW" && -f $( $BREW --prefix )/etc/bash_completion ]] ; then 
	source $( $BREW --prefix )/etc/bash_completion
elif [[ -f /etc/bash_completion ]] ; then 
	source /etc/bash_completion
else
	echo "Can't find bash_completion"
fi

# set prompt
function short_pwd() {
	echo -n $(pwd | perl -F/ -ane 'print join( "/", map { $i++ < @F - 1 ?  substr $_,0,1 : $_ } @F)')
}
# set prompt to be a short-hand path with git_ps1
#export PS1="\$(short_pwd)\$(__git_ps1 | tr -d ' ')$ "

# 256 colors in tmux
alias tmux="tmux -2"

# shortcuts for tmux
alias tls="tmux list-sessions"
alias tas="tmux attach-session -t"
# reattach to previous session (if using tmux as a login shell
# if [ $"(tmux ls | grep 0: )" ]; then
        # tmux switch -t 0
        # tmux kill-session -a -t 0 
# fi

# Just for Chartbeat
# ------------------
export CB_REPO=~/cb
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
export PYTHONPATH=$CB_REPO:$PYTHONPATH

# the worst things in the world to find in our repo
export FUCKING_GLOBAL_CONFS=$CB_REPO/private/puppet/modules/chartbeat/templates/globalconf/
export NODES_LOCAL=$CB_REPO/private/puppet/manifests/nodes_local.pp

# set where virutal environments will live
export WORKON_HOME=$HOME/.virtualenvs
# ensure all new environments are isolated from the site-packages directory
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
# use the same directory for virtualenvs as virtualenvwrapper
export PIP_VIRTUALENV_BASE=$WORKON_HOME
# makes pip detect an active virtualenv and install to it
export PIP_RESPECT_VIRTUALENV=true
if [[ -r /usr/local/bin/virtualenvwrapper.sh ]]; then
    if [[ -z "$VIRTUAL_ENV" ]] ; then 
        source /usr/local/bin/virtualenvwrapper.sh
    fi
fi
# Setup a new virtualenv and activate it
if [[ ! -d $WORKON_HOME/base ]] ; then
	mkvirtualenv base > /dev/null 2>&1
fi
workon base 2>/dev/null

# spin up a new VM
new_vm() {
	$CB_REPO/external/vmutils/create_vagrant_vm.py -H $@.chartbeat.net -G $CB_REPO/ -v3 --distro=precise
	cd $HOME/vagrant/$@
	vagrant up
}

# get the server list for a type
gsl() {
	$CB_REPO/external/tools/get_server_list.py $@
}

# polysh into all servers of a type
psh() {
	local hosts=`gsl $1`
    shift
	local server
	
	# remove the existing entries in ~/.ssh/known_hosts
	for server in $hosts
	do
		ssh-keygen -H -R $server > /dev/null 2>&1
	done

	# rescan and add them to known_hosts
	ssh-keyscan -H $hosts >> $HOME/.ssh/known_hosts 2> /dev/null
	
	# ssh into them simulaneously
	polysh $hosts $*
}

if [[ `which fortune` ]] ; then
#  ,__,
#  (oo)____
#  (__)    )\
#     ||--|| *
	fortune -s | cowsay $(perl -e '@a=qw/b d g p s t w y/; print q/-/, $a[int(rand(scalar @a))]')
fi
