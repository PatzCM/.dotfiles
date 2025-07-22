#############
# MY INTROS #
#############
#
#!/bin/bash
###############
### General ###
###############
# Correct wrong spellings
setopt correct


#######################
### Patz's Aliases ###
#######################
alias spoticlean='rm -rf ~/.var/app/com.spotify.Client/cache/spotify'
 alias chrome='rm -rf ~/.config/google-chrome/Singleton*'
 alias docker='docker start 3e61f8892a99a72262e435529068857bc95104472dbce236170bdfba0795833f'
 alias francinette=~/francinette/francinette-image/run.sh
 alias fr='francinette'
alias paco=/home/palexand/francinette/francinette-image/run.sh
alias ccw='cc -Wall -Wextra -Werror -g'
# 42 Norm Check
alias nn='norminette'
 
# Franinette alias
 alias francinette=~/francinette/francinette-image/run.sh
 alias fr='francinette'
alias v='nvim'
alias vc='vim | lolcat'
alias clear_nvim='rm -rf ~/.local/share/nvim'
alias ga='git add'
alias gst='git status'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gcb='git checkout -b'
alias glgg='git log --graph --oneline --decorate'
alias glgs='git log --graph --oneline --decorate | head -n 7'
alias gm='git merge --stat --log'

if [[ $USER == "palexand" ]]; then
	alias kitty=~/.local/kitty.app/bin/kitty
fi

alias k='kitty --start-as=fullscreen & disown; exit'
alias icat='kitty +kitten icat'
alias kdiff='kitty +kitten diff'
alias	kt='kitty --start-as=fullscreen tmux & disown; exit'
# Glow Markdown Renderer
alias glow=~/bin/glow/glow

# Load colors
autoload -U colors && colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
   eval $COLOR='$fg_no_bold[${(L)COLOR}]'
   eval BOLD_$COLOR='$fg_bold[${(L)COLOR}]'
done
eval NC='$reset_color'

##################
### Completion ###
##################

# Load and initialise completion system
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/.zshcompdump-$ZSH_VERSION"
_comp_options+=(globdots)

#######################
### Vim Mode Config ###
#######################

# bindkey -v
# export KEYTIMEOUT=7
#
# # Use vim keys in tab complete menu:
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'j' vi-down-line-or-history
# bindkey -v '^?' backward-delete-char
#
##########################
### Zap Plugin Manager ###
##########################

[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "hlissner/zsh-autopair"
plug "zsh-users/zsh-history-substring-search"
plug "MichaelAquilina/zsh-you-should-use"
plug "zap-zsh/completions"
plug "zap-zsh/sudo"
plug "web-search"
plug "zap-zsh/fzf"
plug "zap-zsh/web-search"
plug "jeffreytse/zsh-vi-mode"


#################
### Greetings ###
#################


# Loading message
echo "Loading your awesome ASCII art..." | lolcat
sleep 1  # Give a brief delay before showing content

# Use stdbuf to prevent buffering and print each line with a small delay
stdbuf -oL cat ~/beautify/patz.txt | while IFS= read -r line; do
    # Output the line with color (purple)
    echo -e "\e[35m$line\e[0m"

    # Sleep a bit to simulate a loading effect
    sleep 0.1  # Adjust to control the loading speed
done

echo -e "\nLoading Complete!" | lolcat # End message after the loop
# Afogonca's lil gift

echo "Don't forget to take your meds"
echo "Don't forget to git push"
echo "-Afogonca + Jpatrici"

################
### Keyboard ###
################

eval "setxkbmap us"

# File system Navigation
# cd || zoxide
if command -v zoxide > /dev/null 2>&1; then
	eval "$(zoxide init --cmd cd zsh)"
	# echo "[Running ${GREEN}zoxide${NC}! 📂]"
else
	# echo "[Running ${YELLOW}cd${NC}! 📂]"
fi
# ls || eza
if command -v eza > /dev/null 2>&1; then
	# echo "[Running ${GREEN}eza${NC}! 📊]"
	alias ls='echo adoro-te; ls'
	alias ll='ls -al'
	alias llx='eza -laZ --total-size'
	alias llg='eza -laZ --total-size --git --git-repos'
else
	echo "[Running ${YELLOW}ls${NC}! ]"
	alias ll='ls -al --color'
fi

# Load Cowsay
if command -v lolcat > /dev/null 2>&1; then
	eval "zshcow" | lolcat
else
	eval "zshcow"
fi

############################
### Load Starship Prompt ###
############################
    eval "$(starship init zsh)"

#################################
########## HOMEBREW #############
#################################


# Load Homebrew config script
source $HOME/.brewconfig.zsh
export PATH="/sgoinfre/palexand/.brew/bin:$PATH"
export XDG_DATA_DIRS="/sgoinfre/palexand/.brew/share:$XDG_DATA_DIRS"

# Define a function to run fzf
fzf-file-widget() {
  LBUFFER="${LBUFFER}$(fzf)"
  local ret=$?
  zle reset-prompt
  return $ret
}

zle -N fzf-file-widget

