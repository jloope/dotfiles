# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=1000
#HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

function bash_git_branch
{
  git branch 2> /dev/null | grep \* | python -c "print '['+raw_input()[2:]+']'" 2> /dev/null
}
function ruby_version 
{
  ruby -v 2> /dev/null | awk '{ print $2}'
}
function rvm_gemset
{
  rvm gemset name 2> /dev/null|awk '{if ($0=="") print ""; else print "@" $0 }' 2> /dev/null 
}

function lsofg()
{
    if [ $# -lt 1 ] || [ $# -gt 1 ]; then
        echo "grep lsof"
        echo "usage: losfg [port/program/whatever]"
    else
        lsof | grep -i $1 | less
    fi
}

function user_color()
{
        if [ "$UID" -eq "0" ]; then
                echo 31
        fi
        if [ "$UID" -eq "1001" ]; then
                echo 33
        fi
}

function psg()
{
    if [ $# -lt 1 ] || [ $# -gt 1 ]; then
        echo "grep running processes"
        echo "usage: psg [process]"
    else
        ps aux | grep USER | grep -v grep
        ps aux | grep -i $1 | grep -v grep
    fi
}

function wiki() {
	        dig +short txt $1.wp.dg.cx
	            }



# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1="~\$?~ {\[\033[1;\$(user_color)m\] \T \[\033[0m\]}\$(bash_git_branch)$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

set -o vi
export HISTTIMEFORMAT="[%F] [%T] "
export HISTFILESIZE=1000000000 
export HISTSIZE=1000000

export RUBYOPT=rubygems
export EDITOR=/usr/bin/vim
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

alias gam='python ~/repos/gam/gam.py'
alias v='vim'
alias pkt_trace='sudo tcpflow -i wlan0 -c'
alias ip_trace='pkt_trace ip'
alias http_trace='pkt_trace port 80'
alias xclip="xclip -selection c"

#aliases for wimax
alias wimaxon='wimaxcu ron; wimaxcu connect network 2; sudo dhclient wmx0; wimaxcu status link; wimaxcu status connect'
alias wimaxoff='wimaxcu dconnect; wimaxcu roff; sudo ip route del default; sudo ip route add default via 192.168.1.1 dev wlan0; sudo ifconfig wmx0 down'
alias fixwifi='sudo rmmod -f iwlwifi; sleep 5; sudo modprobe iwlwifi 11n_disable=1 swcrypto=1'
alias wifi='wicd-gtk --no-tray'

#for git
alias devpull='ssh -t puppet "cd /etc/puppet-dev; sudo -E git pull"'
alias prodpull='ssh -t puppet "cd /etc/puppet; sudo -E git pull"'

#for puppet
alias pparse='puppet parser validate'


# Print working directory after a cd.
cd() {
    if [[ $@ == '-' ]]; then
        builtin cd "$@" > /dev/null  # We'll handle pwd.
    else
        builtin cd "$@"
    fi
    echo -e "   \033[1;30m"`pwd`"\033[0m"
    ls
}

#autocorrect cd
shopt -s cdspell
#autocomplete ssh
#complete -W "$(echo `cat ~/.bash_history | egrep '^ssh ' | sort | uniq | sed 's/^ssh //'`;)" ssh
# Added by autojump install.sh
source /etc/profile.d/autojump.bash

#stderred
# https://github.com/sickill/stderred
export LD_PRELOAD="/usr/local/lib/stderred.so"

#Go

export PATH=$PATH:/home/jloope/repos/go/bin

source ~/.awscreds
