set fish_greeting
set PATH "$HOME/programs/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin" "$HOME/dotfiles/bin" "$HOME/.dotnet/tools" "$HOME/.cargo/bin" "$HOME/opt/cross/bin" "$HOME/.yarn/bin" $PATH "$HOME/workspace/sdk/1.2.148.1/x86_64/bin/"
set -Ux EDITOR "nvim"

if status is-interactive
    fish_vi_key_bindings

    zoxide init fish | source

    alias v "nvim"
    alias vim "nvim"
    alias fishrc "nvim ~/.config/fish/config.fish"
    alias awesomerc "nvim ~/.config/awesome/rc.lua"
    alias picomrc "nvim ~/.config/picom/picom.conf"
    alias x "startx"
    alias X "startx"
    alias p "pacman"
    alias exaa "exa -la --git"
    alias exal "exa -l"
    if type -q exa
        alias ls "exa"
    end
    alias gs "git status"
    alias ga "git add"
    alias gd "git diff"
    alias gc "git commit"
    alias gp "git push"
end
