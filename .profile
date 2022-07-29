# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# vars
export TERMINAL="kitty"
export SHORTCUTS=$HOME/shortcuts
export SCRIPTS=$HOME/scripts
export ANKI_NOHIGHDPI=1
export PROJECTS=$HOME/Projects
export FINANCES=$HOME/.finances
export PRODUCTIVITY=$HOME/.productivity
export TASKS=$HOME/.todo
export WALLPAPERS=$HOME/Pictures/Wallpapers
export PATH=$HOME/.rvm/bin

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx   # remove the exec to remain logged in when your wm ends
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
