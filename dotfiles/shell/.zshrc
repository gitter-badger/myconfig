# Path to your oh-my-zsh installation.
  export ZSH=/home/mhuber/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
# gallifrey

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git rake ruby zsh-syntax-highlighting)
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# User configuration

# if [ -d "/nix/var/nix" ]; then
#   export PATH="/home/mhuber/bin:/var/setuid-wrappers:/home/mhuber/.nix-profile/bin:/home/mhuber/.nix-profile/sbin:/home/mhuber/.nix-profile/lib/kde4/libexec:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/nix/var/nix/profiles/default/lib/kde4/libexec:/run/current-system/sw/bin:/run/current-system/sw/sbin:/run/current-system/sw/lib/kde4/libexec"
# # else
# #   export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
# fi
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

###############################################################################
# vi key bindings
bindkey -v
export KEYTIMEOUT=1
bindkey '^r' history-incremental-search-backward
# bindkey '^P' up-history
# bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

###############################################################################
###############################################################################
###############################################################################
###############################################################################

[[ -f ~/.aliasrc ]] && source ~/.aliasrc
[[ -f ~/.aliasrc-private ]] && source ~/.aliasrc-private
[[ -d $HOME/bin ]] && {
  export PATH=$HOME/bin:$PATH
  [[ -d $HOME/bin/stolen ]] && export PATH=$PATH:$HOME/bin/stolen
}
[[ -d $HOME/.perl/bin ]] && export PATH=$HOME/.perl/bin:$PATH
# [[ -d $HOME/perl5/bin ]] && export PATH=$HOME/perl5/bin:$PATH
[[ -d $HOME/.cabal/bin ]] && export PATH=$HOME/.cabal/bin:$PATH
[[ -d $HOME/.local/bin ]] && export PATH=$HOME/.local/bin:$PATH
[[ -d $HOME/.gem/ruby/2.3.0/bin ]] && {
    export PATH=$PATH:$HOME/.gem/ruby/2.3.0/bin
} || {
    [[ -d $HOME/.gem/ruby/2.2.0/bin ]] && export PATH=$PATH:$HOME/.gem/ruby/2.2.0/bin
}

[[ -d $HOME/nixpkgs ]] && export NIXPKGS=$HOME/nixpkgs

PATH="$HOME/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

[[ "$JAVA_HOME" ]] || JAVA_HOME=$(readlink -f $(which java) | sed "s:bin/java::")

###############################################################################
ZDOTDIR=${ZDOTDIR:-${HOME}}
ZSHDDIR="${HOME}/.config/zsh.d"
#HISTFILE="${ZDOTDIR}/.zsh_history"
HISTSIZE=10000
SAVEHIST="${HISTSIZE}"
# export EDITOR="/usr/bin/vim"
export EDITOR="vim"
export VISUAL="vim -p -X"
export TMP="$HOME/tmp"
[[ ! -d "${TMP}" ]] && mkdir "${TMP}"
export TEMP="$TMP"
export TMPDIR="$TMP"
export TMPPREFIX="${TMPDIR}/zsh"
## Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

#Python virtualenvs
export WORKON_HOME=~/workspace/python/virtualenvs

#paralleles compilieren mit haskell
export ncpus=3

###############################################################################
alias -s tex=vim

alias -s pdf=zathura
alias -s ps=zathura
alias -s djvu=zathura

###############################################################################
[[ -f ~/.zshrc.private ]] && source ~/.zshrc.private
[[ -d /nix/store/k1v2g5784sas2fc9fp6flq50fvsck5w7-taskwarrior-2.5.1/share/doc/task/scripts/zsh/ ]] &&
    fpath=(/nix/store/k1v2g5784sas2fc9fp6flq50fvsck5w7-taskwarrior-2.5.1/share/doc/task/scripts/zsh/ $fpath)

###############################################################################
# Start tmux on ssh
if [ "$PS1" != "" -a "${SSH_TTY:-x}" != x ]; then
  if test -z $TMUX && [[ $TERM != "screen" ]]; then
    ( (tmux has-session -t remote && tmux attach-session -t remote) \
      || (tmux -2 new-session -s remote) ) && exit 0
    echo "tmux failed to start"
  else
    export DISPLAY=:0
  fi
fi