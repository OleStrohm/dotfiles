# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.dotnet/tools:$HOME/.cargo/bin:$HOME/opt/cross/bin:$HOME/.yarn/bin:$PATH:/home/ole/workspace/sdk/1.2.148.1/x86_64/bin/"
export XDG_CONFIG_HOME="/home/ole/.config"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/local/lib/pkgconfig"
export VULKAN_SDK_PATH="/home/ole/workspace/sdk/1.2.148.1/x86_64"

# oh-my-zsh folders
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/dotfiles/oh-my-zsh-custom/"

export EDITOR='nvim'

ZSH_THEME="perfect"

plugins=(
	git
	sudo
)

source $ZSH/oh-my-zsh.sh


alias zshconfig="nvim ~/.zshrc"
alias x="startx"
alias X="startx"
alias vim="nvim"
alias v="nvim"
alias p="pacman"
alias sudo="sudo "
alias exa="exa -l --git"
alias exaa="exa -la --git"

eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
