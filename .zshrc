# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/programs/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin:$HOME/dotfiles/bin:$HOME/.dotnet/tools:$HOME/.cargo/bin:$HOME/opt/cross/bin:$HOME/.yarn/bin:$PATH:$HOME/workspace/sdk/1.2.148.1/x86_64/bin/"
export XDG_CONFIG_HOME="$HOME/.config"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/local/lib/pkgconfig"
export VULKAN_SDK_PATH="$HOME/workspace/sdk/1.2.148.1/x86_64"

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
alias awesomerc="nvim ~/.config/awesome/rc.lua"
alias picomrc="nvim ~/.config/picom/picom.conf"
alias x="startx"
alias X="startx"
alias vim="nvim"
alias v="nvim"
alias p="pacman"
alias sudo="sudo "
alias exa="exa"
alias exaa="exa -la --git"
(( $+commands[exa] )) && alias ls="exa"

(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh
