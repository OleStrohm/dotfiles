set fish_greeting
set PATH "$HOME/programs/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin" "$HOME/dotfiles/bin" "$HOME/.dotnet/tools" "$HOME/.cargo/bin" "$HOME/opt/cross/bin" "$HOME/.yarn/bin" $PATH "$HOME/workspace/sdk/1.2.148.1/x86_64/bin/"
set -Ux EDITOR "nvim"

if status is-interactive
    fish_vi_key_bindings

    zoxide init fish | source

    alias v "nvim"
    alias awesomerc "nvim ~/.config/awesome/rc.lua"
    alias picomrc "nvim ~/.config/picom/picom.conf"
    alias x "startx"
    alias X "startx"
    alias vim "nvim"
    alias v "nvim"
    alias p "pacman"
    alias exa "exa"
    alias exaa "exa -la --git"
    if type -q exa
        alias ls "exa"
    end
end
