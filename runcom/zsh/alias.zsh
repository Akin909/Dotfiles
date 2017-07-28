# ================================================================================
# Aliases
# ================================================================================
alias x="exit" # Exit Terminal
alias dots="cd ~/Dotfiles"
alias code="cd ~/Desktop/Coding"
alias l="lsp"
alias la='ls -aG'
alias v='vim'
alias nv='nvim'
alias cl='clear'
alias o='a -e xdg-open' # quick opening files with xdg-open
alias b='source ~/Dotfiles/bin/fzf-chrome.rb'
alias rn='ranger'
alias gbs="git branch | fzf-tmux -d 15"
alias restart='exec zsh'
alias src='. ~/.zshrc'
alias gphm='git push heroku master'
alias ea='vim ~/Dotfiles/runcom/zsh/alias.zsh'
alias ez="vim ~/.zshrc"
alias nez="vim ~/.zshrc"
alias ev="vim ~/.vimrc"
alias et="vim ~/.tmux.conf"
alias nev="nvim ~/.vimrc"
alias net="nvim ~/.tmux.conf"

#alias ctags if you used homebrew
alias ctags="`brew --prefix`/bin/ctags"
alias lip="lsof -Pn -i4"
alias ports=" _ lsof -i -P | grep -i 'listen'"
alias sesh="vim -S"
alias tmux="tmux -2"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tls="tmux ls"
alias tkill="tmux kill-session -t"

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'
# Silence or turn up the volume
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"
# Open google chrome from terminal
alias chrome="/Applications/Google\\ \\Chrome.app/Contents/MacOS/Google\\ \\Chrome"

alias -s js=nvim
alias -s html=nvim
alias -s css=nvim
alias -s py=nvim

# alias tmux="tmux -CC"
# alias attach="tmux -CC attach"
alias browse="browser-sync start --server"
alias ctags="`brew --prefix`/bin/ctags"
#Git aliases
alias serve='python -m SimpleHTTPServer'
