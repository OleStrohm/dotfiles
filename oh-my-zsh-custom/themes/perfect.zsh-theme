# Put your custom themes in this folder.
# Example:
purple="\[\033[01;35m\]"

function pointer() {
    echo "%{$FG[093]%}%{$FX[bold]%}>%{$reset_color%}"
}

function path() {
	echo $1
}

PROMPT=$'%{$fg[yellow]%}%~ $(git_prompt_info)$(pointer) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
