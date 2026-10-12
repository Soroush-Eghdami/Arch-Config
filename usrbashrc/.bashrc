#
# ~/.bashrc — modern, cool, fast
# Arch Linux / bash 5.x / Nerd Font ready (Iosevka NF detected on this box)
# Works with zero dependencies, auto-enhances if you install:
#   starship, eza, bat, fzf, zoxide, fastfetch
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ── 0. Compat ──────────────────────────────────────────────
# keep your old shortcut working
alias neofetch='fastfetch -c examples/13 2>/dev/null || fastfetch 2>/dev/null || true'

# ── 1. Basics: history, options, env ───────────────────────
HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT='%F %T '
HISTIGNORE='ls:ll:la:l:cd:pwd:exit:clear:history*:bg:fg'
shopt -s histappend checkwinsize extglob globstar cdspell dirspell checkjobs
stty -ixon 2>/dev/null # disable ctrl-s freeze

export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export PAGER=less
export LESS='-R --use-color -Dd+r$Du+b$'
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export QT_QPA_PLATFORMTHEME=qt5ct 2>/dev/null

# truecolor for supporting terms
case "$TERM" in
  xterm-kitty|alacritty|wezterm|xterm-256color|screen-256color|tmux-256color)
    export COLORTERM=truecolor 2>/dev/null
    ;;
esac

# ── 2. Colors + ls ─────────────────────────────────────────
if command -v dircolors >/dev/null 2>&1; then
  if [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

# eza > exa > lsd > ls — use best available
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=auto --group-directories-first --icons'
  alias ll='eza -lh --group-directories-first --icons --git --time-style=relative'
  alias la='eza -lah --group-directories-first --icons --git'
  alias l='eza -1 --icons'
  alias tree='eza --tree --icons'
elif command -v exa >/dev/null 2>&1; then
  alias ls='exa --color=auto --group-directories-first'
  alias ll='exa -lh --group-directories-first --git'
  alias la='exa -lah --group-directories-first --git'
  alias l='exa -1'
elif command -v lsd >/dev/null 2>&1; then
  alias ls='lsd --group-directories-first'
  alias ll='lsd -lh --group-directories-first'
  alias la='lsd -lah --group-directories-first'
  alias l='lsd -1'
else
  alias ls='ls --color=auto --group-directories-first -F'
  alias ll='ls -lh --color=auto --group-directories-first'
  alias la='ls -lah --color=auto --group-directories-first'
  alias l='ls -CF --color=auto'
  alias tree='tree -C --dirsfirst 2>/dev/null || find . -print | head -50'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# ── 3. Safety + ergonomics ─────────────────────────────────
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv --one-file-system'
alias ln='ln -iv'
alias mkdir='mkdir -pv'
alias chmod='chmod -c'
alias chown='chown -c'
alias df='df -hT -x tmpfs -x devtmpfs'
alias du='du -h'
alias free='free -h'
alias psmem='ps -eo pid,comm,%mem,rss --sort=-%mem | head -20'
alias pscpu='ps -eo pid,comm,%cpu --sort=-%cpu | head -20'
alias ports='ss -tulpn'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ..'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias week='date +%V'

# cat / less upgrades if present
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never --style=plain'
  alias less='bat --paging=always'
elif command -v batcat >/dev/null 2>&1; then
  alias cat='batcat --paging=never --style=plain'
  alias bat='batcat'
fi

# ── 4. Arch / yay / systemd ────────────────────────────────
alias pac='sudo pacman'
alias pacs='pacman -Ss'
alias paci='pacman -Si'
alias pacq='pacman -Q'
alias up='sudo pacman -Syu'
alias unlock='sudo rm -f /var/lib/pacman/db.lck'
alias orphans='pacman -Qtdq'
alias rmorphans='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null || echo "no orphans"'
alias cleanpac='sudo pacman -Sc --noconfirm && paccache -rk2 2>/dev/null || sudo pacman -Sc'

if command -v yay >/dev/null 2>&1; then
  alias yayup='yay -Syu --devel --timeupdate'
  alias yayclean='yay -Sc --noconfirm && yay -Yc --noconfirm'
  alias upall='yay -Syu --devel --timeupdate'
else
  alias upall='sudo pacman -Syu'
fi

alias ctl='systemctl'
alias ctlu='systemctl --user'
alias jctl='journalctl'
alias jctlerr='journalctl -p 3 -xb'
alias svc='sudo systemctl'
alias bootmsg='journalctl -b -p err..warning'

# ── 5. Git (you have git 2.56) ─────────────────────────────
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a -m'
alias gp='git push'
alias gpl='git pull --rebase --autostash'
alias gl='git log --oneline --graph --decorate -15'
alias gll='git log --graph --pretty="%C(yellow)%h%Creset %C(cyan)%ad%Creset %s %C(green)[%an]%Creset %C(magenta)%d%Creset" --date=short -20'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch -vv'
alias gco='git checkout'
alias gsw='git switch'
alias gst='git stash -u'
alias gstp='git stash pop'
alias grb='git rebase'
alias grc='git rebase --continue'
alias gundo='git reset --soft HEAD~1'
alias groot='cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"'

# ── 6. Tools: nvim, fastfetch, btop, fzf, zoxide ───────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias ff='fastfetch'
alias ffc='fastfetch -c examples/13 2>/dev/null || fastfetch'
alias top='btop 2>/dev/null || htop 2>/dev/null || top'
alias htop='btop 2>/dev/null || htop'

# fzf: better history + file search if installed
if command -v fzf >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  [[ -f /usr/share/fzf/key-bindings.bash ]] && . /usr/share/fzf/key-bindings.bash
  [[ -f /usr/share/fzf/completion.bash ]] && . /usr/share/fzf/completion.bash
  [[ -f ~/.fzf.bash ]] && . ~/.fzf.bash
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --inline-info --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'
  command -v fd >/dev/null 2>&1 && export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  alias fzfprev='fzf --preview "bat --style=numbers --color=always {} 2>/dev/null || cat {}"'
fi

# zoxide: smarter cd if installed
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash --cmd cd)"
fi

# starship: if you ever install it, it takes over prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
  # skip our custom prompt below
  return 0 2>/dev/null || exit 0
fi

# ── 7. Functions ───────────────────────────────────────────
mkcd() { mkdir -p -- "$1" && cd -P -- "$1" || return; }
upn() { local n=${1:-1}; local p=; for ((i=0;i<n;i++)); do p="../$p"; done; cd "$p" || return; }
extract() {
  if [[ ! -f $1 ]]; then echo "'$1' is not a file"; return 1; fi
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.txz)     tar xJf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.7z)      7z x "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.xz)      unxz "$1" ;;
    *.zst)     unzstd "$1" ;;
    *) echo "don't know how to extract '$1'" ;;
  esac
}
serve() { local p=${1:-8000}; python3 -m http.server "$p" 2>/dev/null || python -m http.server "$p"; }
myip() { curl -s --max-time 5 ifconfig.me; echo; }
localip() { ip -brief -color address show | grep -v lo; }
weather() { curl -s --max-time 5 "wttr.in/${1:-}?format=3"; echo; }
cheat() { curl -s --max-time 10 "cheat.sh/$1"; }
backup() { cp -av -- "$1" "$1.bak.$(date +%Y%m%d-%H%M%S)"; }
biggest() { du -h -x -d1 "${1:-.}" 2>/dev/null | sort -rh | head -20; }
ffind() { find . -iname "*$1*" 2>/dev/null; }
killport() { [[ -z $1 ]] && { echo "usage: killport <port>"; return 1; }; fuser -k "$1/tcp" 2>/dev/null || sudo fuser -k "$1/tcp"; }

# fast, dependency-free git prompt helper
__git_ps1_custom() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
  local branch dirty=""
  branch=$(git symbolic-ref --short -q HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
  git diff --quiet 2>/dev/null || dirty="*"
  git diff --cached --quiet 2>/dev/null || dirty="${dirty}+"
  [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]] && dirty="${dirty}?"
  printf ' %s' "$branch$dirty"
}

# ── 8. THE PROMPT — modern 2-line, Nerd Font ───────────────
# Line 1: ╭─ user@host  cwd  git  | time
# Line 2: ╰─ ❯  (green ok / red fail)
# Falls back gracefully if font/unicode missing.

__prompt_command() {
  local exit_code=$?
  local reset='\[\e[0m\]'

  # palette (Tokyo Night-ish)
  local c_user='\[\e[38;5;75m\]'    # blue
  local c_host='\[\e[38;5;189m\]'   # lavender
  local c_path='\[\e[38;5;113m\]'   # green
  local c_git='\[\e[38;5;213m\]'    # pink
  local c_time='\[\e[38;5;244m\]'   # grey
  local c_ok='\[\e[38;5;114m\]'
  local c_err='\[\e[38;5;203m\]'
  local c_sym='\[\e[38;5;75m\]'

  local arrow='❯'
  local prompt_char_color="$c_ok"
  [[ $exit_code -ne 0 ]] && prompt_char_color="$c_err"

  local ssh_flag=""
  [[ -n $SSH_CONNECTION ]] && ssh_flag="󰣀 "

  local git_info=""
  local g
  g=$(__git_ps1_custom 2>/dev/null)
  if [[ -n $g ]]; then
    git_info=" ${c_git}${g}${reset}"
  fi

  # root user = red name
  local user_color="$c_user"
  [[ $EUID -eq 0 ]] && user_color='\[\e[38;5;203m\]'

  # venv / toolbox hint
  local venv_info=""
  [[ -n $VIRTUAL_ENV ]] && venv_info=" $(basename "$VIRTUAL_ENV")"

  PS1="╭─${user_color} \u${reset}@${c_host}${ssh_flag}\h${reset} ${c_path}󰉋 \w${reset}${git_info} ${c_time} \t${reset}${venv_info}\n╰─${prompt_char_color}${arrow}${reset} "
  # terminal title
  printf '\e]0;%s@%s: %s\a' "$USER" "${HOSTNAME:-arch}" "$PWD" >/dev/tty 2>/dev/null || true
}
PROMPT_COMMAND=__prompt_command
PROMPT_DIRTRIM=3

# ── 9. Completion ──────────────────────────────────────────
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi
# pacman/yay completion niceties
command -v yay >/dev/null 2>&1 && complete -o default -F _pacman yay 2>/dev/null || true

# ── 10. Quality of life extras ─────────────────────────────
# less colors
[[ -f ~/.lessfilter ]] && export LESSOPEN='| ~/.lessfilter %s'

# auto cd into oxwm project? no — just shortcut
alias ox='cd ~/oxwm'

# editor fallback if nvim missing (it exists here, but safe)
command -v nvim >/dev/null 2>&1 || { command -v vim >/dev/null 2>&1 && export EDITOR=vim VISUAL=vim || export EDITOR=nano VISUAL=nano; }

# welcome: only on login terminals, never on dumb/scp, never twice in tmux nesting
if [[ $- == *i* ]] && [[ $TERM != dumb ]] && [[ -z $BASHRC_WELCOMED ]] && shopt -q login_shell 2>/dev/null; then
  export BASHRC_WELCOMED=1
fi

# local overrides (machine-specific, not tracked)
[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local

true
