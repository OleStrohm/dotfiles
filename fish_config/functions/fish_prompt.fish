function fish_prompt
    set -l last_status $status

    function is_ssh
      if test -n "$SSH_CONNECTION"
        printf " %s[ssh]%s" (set_color yellow) (set_color normal)
      end
    end

    function nix_shell_info
      if test -z "$ORIG_SHLVL"
        set -gx ORIG_SHLVL $SHLVL
      end
      if test "$SHLVL" -gt "$ORIG_SHLVL"
        printf " %s<nix shell>%s" (set_color cyan) (set_color normal)
      end
    end

    if not set -q __fish_git_prompt_color_branch
        set -g __fish_git_prompt_color_branch brmagenta
    end
    if not set -q __fish_git_prompt_showdirtystate
        set -g __fish_git_prompt_showdirtystate 1
    end
    set -g ___fish_git_prompt_color_dirtystate (set_color red)
    set -g ___fish_git_prompt_color_dirtystate_done (set_color normal)
    if not set -q __fish_git_prompt_color_stagedstate
        set -g __fish_git_prompt_color_stagedstate yellow
    end
    if not set -q __fish_git_prompt_color_invalidstate
        set -g __fish_git_prompt_color_invalidstate red
    end
    if not set -q __fish_git_prompt_color_cleanstate
        set -g __fish_git_prompt_color_cleanstate brgreen
    end

    printf "%s%s%s%s%s%s " (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (fish_git_prompt) (is_ssh) (nix_shell_info)

    if not test $last_status -eq 0
      set_color $fish_color_error
    end
    echo -n '> '
    set_color normal
end
