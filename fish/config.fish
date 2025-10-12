set fish_greeting
#set PATH "$HOME/dotfiles/bin" #"$HOME/programs/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin" "$HOME/dotfiles/bin"# "$HOME/.dotnet/tools" "$HOME/.cargo/bin" "$HOME/opt/cross/bin" "$HOME/.yarn/bin" $PATH "$HOME/workspace/sdk/1.2.148.1/x86_64/bin/"
set -Ux EDITOR "nvim"
set -Ux BROWSER "firefox"

if status is-interactive
    fish_vi_key_bindings

    if type -q direnv
        direnv hook fish | source
    end
    if type -q zoxide
        zoxide init fish | source
    end

    alias rebuild "sudo nixos-rebuild switch --flake /home/ole/dotfiles/nixos/"

    alias v "nvim"
    alias x "set -e ORIG_SHLVL; startx"
    alias X "x"
    if type -q eza
        alias ezaa "eza -la --git"
        alias ezal "eza -l"
        alias ls "eza"
    end
end

if ! set -q DISPLAY
    if test -n "$XDG_VTNR"
        if test $XDG_VTNR -eq 1
            set -e ORIG_SHLVL
            startx
        end
    end
end
