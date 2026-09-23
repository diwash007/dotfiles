export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:/opt/homebrew/bin:$HOME/.cargo/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/build-tools/33.0.0:$PATH"

# Helper functions local to script
_check_and_install() {
  local cmd=$1
  local pkg=$2

  if ! command -v $cmd &> /dev/null; then
    echo "$cmd could not be found. Installing $pkg..."
    if [[ $(uname) == "Darwin" ]]; then
      brew install $pkg
    else
      sudo apt-get update
      sudo apt-get install -y $pkg
    fi
  fi
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ $(uname) == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- nvm: lazy-loaded ----------------------------------------------------
# Sourcing nvm.sh directly costs several hundred ms on every new shell.
# Stub the commands that need it and only pay that cost the first time one
# of them is actually used.
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
  unset -f nvm node npm npx yarn corepack 2>/dev/null
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}
for _cmd in nvm node npm npx yarn corepack; do
  eval "${_cmd}() { _load_nvm; ${_cmd} \"\$@\"; }"
done
unset _cmd

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Set the directory for zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's absent
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Powerlevel10k theme - needed synchronously, before the prompt draws
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Adds completion definitions to fpath - cheap, keep synchronous so
# compinit below actually picks them up.
zinit light zsh-users/zsh-completions

# Completion: only rebuild the dump when it's more than a day old. -C skips
# the compaudit security scan (which stats every directory in fpath) and
# just reuses the existing dump - this is normally the single biggest
# compinit cost on every-launch runs.
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Heavier runtime plugins: load these asynchronously, right after the
# prompt is drawn, instead of blocking shell startup.
zinit wait lucid for \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-autosuggestions \
  Aloxaf/fzf-tab

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Install necessary tools (only touches brew/apt the first time, if missing)
_check_and_install fzf fzf
_check_and_install zoxide zoxide

# Completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias si='open -a simulator'
alias ip='ipconfig getifaddr en0'


# Shell Integrations
# Assumes a reasonably current fzf (>=0.48, e.g. anything from Homebrew),
# which supports `fzf --zsh` directly - this drops the old version-check
# + curl-the-completion-scripts dance that used to run on every launch.
# If you're stuck on an old fzf without --zsh support, you'll need the
# legacy fallback back (ask and I'll add it).
eval "$(fzf --zsh 2>/dev/null)"

if [[ $(uname) == "Darwin" ]]; then
  eval "$(zoxide init zsh)"
else
  eval "$(zoxide init zsh --cmd j)"
fi


# Remove script specific functions
unset -f _check_and_install



# GIT STUFF
# Aliases
alias g='git'
compdef g=git
alias gst='git status'
compdef _git gst=git-status
alias gl='git pull'
compdef _git gl=git-pull
alias gup='git fetch && git rebase'
compdef _git gup=git-fetch
alias gp='git push'
compdef _git gp=git-push
gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff
alias gc='git commit -v'
compdef _git gc=git-commit
alias gca='git commit -v -a'
compdef _git gca=git-commit
alias gco='git checkout'
compdef _git gco=git-checkout
alias gcm='git checkout master'
alias gb='git branch'
compdef _git gb=git-branch
alias gba='git branch -a'
compdef _git gba=git-branch
alias gcount='git shortlog -sn'
compdef gcount=git
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
alias glg='git log --stat --max-count=5'
compdef _git glg=git-log
alias glgg='git log --graph --max-count=5'
compdef _git glgg=git-log
alias gss='git status -s'
compdef _git gss=git-status
alias ga='git add'
compdef _git ga=git-add
alias gm='git merge'
compdef _git gm=git-merge
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias glum='git pull upstream master'
alias glom='git pull origin master'
alias gr='git remote'
alias merge='gh pr merge --rebase --delete-branch'

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git

alias gsr='git svn rebase'
alias gsd='git svn dcommit'
#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function current_repository() {

  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo $(git remote -v | cut -d':' -f 2)
}

# these aliases take advantage of the previous function
alias ggpull='git pull origin $(current_branch)'
compdef ggpull=git
alias ggpush='git push origin $(current_branch)'
compdef ggpush=git
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
compdef ggpnp=git
alias glog='g log'

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced #(for dark backgrounds)
export LSCOLORS=ExFxBxDxCxegedabagacad #(for light background)

bindkey "\e[1;3D" backward-word     # ⌥←
  bindkey "\e[1;3C" forward-word      # ⌥→
#  bindkey "^[[1;9D" beginning-of-line # cmd+←
#  bindkey "^[[1;9C" end-of-line       # cmd+→


alias la='ls -lah'

# --- pyenv: lazy-loaded ---------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
_load_pyenv() {
  unset -f pyenv python python3 pip pip3 2>/dev/null
  eval "$(pyenv init - zsh)"
}
for _cmd in pyenv python python3 pip pip3; do
  eval "${_cmd}() { _load_pyenv; ${_cmd} \"\$@\"; }"
done
unset _cmd

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# --- jenv: lazy-loaded -----------------------------------------------------
export PATH="$HOME/.jenv/bin:$PATH"
_load_jenv() {
  unset -f jenv java javac 2>/dev/null
  eval "$(jenv init -)"
}
for _cmd in jenv java javac; do
  eval "${_cmd}() { _load_jenv; ${_cmd} \"\$@\"; }"
done
unset _cmd

export PATH="/Applications/Godot 4.app/Contents/MacOS:$PATH"

# export PYTHON=/opt/homebrew/bin/python3.9

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

export EDITOR=vim
export VISUAL="$EDITOR"
# eval "$(rbenv init - zsh)"

# opencode
export PATH=$HOME/.opencode/bin:$PATH
