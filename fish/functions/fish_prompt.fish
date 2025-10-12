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

    function jj_prompt
      if not command -sq jj
        return 1
      end
      if jj root > /dev/null 2> /dev/null
        printf " %s(jj)%s" (set_color brmagenta) (set_color normal)
      end
    end

    printf "%s%s%s%s%s%s " (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (jj_prompt) (is_ssh) (nix_shell_info)

    if not test $last_status -eq 0
      set_color $fish_color_error
    end
    echo -n '> '
    set_color normal
end
