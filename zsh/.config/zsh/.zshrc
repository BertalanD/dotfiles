# Config for interactive zsh

# Load common configuration. Must precede instant prompt, because that redirects .zshrc's stdin,
# and that causes an issue wity updategpgtty's $(tty) call
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shrc"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt AUTO_CD # automatically cd into typed directory

HISTSIZE=1000
SAVEHIST=0
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history" # has no effect if SAVEHIST == 0
setopt HIST_IGNORE_SPACE # do not save entries starting with a space to history
setopt HIST_IGNORE_DUPS  # do not write command to history if it's the same as the previous one

unsetopt FLOW_CONTROL  # Disable ctrl+s freezing terminal

bindkey -v #  use vim keybindings

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)

# Regenerate command completions if a package was installed or updated while the shell
# was running. See https://wiki.archlinux.org/index.php/zsh#On-demand_rehash
# A Pacman hook has to be set for it to work.
zshcache_time="$(date +%s%N)"
autoload -Uz add-zsh-hook
function rehash_precmd {
    if [[ -a /var/cache/zsh/pacman ]]; then
        local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
        rehash
        zshcache_time="$paccache_time"
        fi
    fi
}
command -v pacman >/dev/null && add-zsh-hook -Uz precmd rehash_precmd

# Set terminal title (source: oh-my-zsh)
function title {
    emulate -L zsh
    setopt prompt_subst

    [[ "$EMACS" == *term* ]] && return

    # if $2 is unset use $1 as default
    # if it is set and empty, leave it as is
    : ${2=$1}

    case "$TERM" in
        cygwin|xterm*|putty*|*rxvt*|konsole*|gnome*|alacritty*|ansi)
            print -Pn "\e]2;$2:q\a" # set window name
            print -Pn "\e]1;$1:q\a" # set tab name
            ;;
        screen*|tmux*)
            print -Pn "\ek$1:q\e\\" # set screen hardstatus
            ;;
        *)
            if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
                print -Pn "\e]2;$2:q\a" # set window name
                print -Pn "\e]1;$1:q\a" # set tab name
            else
                # Try to use terminfo to set the title
                if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
                    echoti tsl
                    print -Pn "$1"
                    echoti fsl
                fi
            fi
            ;;
    esac
}

function title_precmd {
    # tab title: 15 char left truncated pwd, window title: [user]@[host]: [dir]
    title "%15<..<%~%<<" "%n@%m: %~"
}
add-zsh-hook precmd title_precmd

function title_preexec {
    emulate -L zsh
    setopt extended_glob

    # split command into array of arguments
    local -a cmdargs
    cmdargs=("${(z)2}")
    # if running fg, extract the command from the job description
    if [[ "${cmdargs[1]}" = fg ]]; then
        # get the job id from the first argument passed to the fg command
        local job_id jobspec="${cmdargs[2]#%}"
        # logic based on jobs arguments:
        # http://zsh.sourceforge.net/Doc/Release/Jobs-_0026-Signals.html#Jobs
        # https://www.zsh.org/mla/users/2007/msg00704.html
        case "$jobspec" in
            <->) # %number argument:
                # use the same <number> passed as an argument
                job_id=${jobspec} ;;
            ""|%|+) # empty, %% or %+ argument:
                # use the current job, which appears with a + in $jobstates:
                # suspended:+:5071=suspended (tty output)
                job_id=${(k)jobstates[(r)*:+:*]} ;;
            -) # %- argument:
                # use the previous job, which appears with a - in $jobstates:
                # suspended:-:6493=suspended (signal)
                job_id=${(k)jobstates[(r)*:-:*]} ;;
            [?]*) # %?string argument:
                # use $jobtexts to match for a job whose command *contains* <string>
                job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]} ;;
            *) # %string argument:
                # use $jobtexts to match for a job whose command *starts with* <string>
                job_id=${(k)jobtexts[(r)${(Q)jobspec}*]} ;;
        esac

        # override preexec function arguments with job command
        if [[ -n "${jobtexts[$job_id]}" ]]; then
            1="${jobtexts[$job_id]}"
            2="${jobtexts[$job_id]}"
        fi
    fi

    # cmd name only, or if this is sudo or ssh, the next cmd
    local CMD=${1[(wr)^(*=*|sudo|doas|ssh|mosh|rake|-*)]:gs/%/%%}
    local LINE="${2:gs/%/%%}"

    title '$CMD' '%100>...>$LINE%<<'
}

add-zsh-hook preexec title_preexec

# Edit line in vim with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

alias zshrc="${EDITOR:-nvim} ${ZDOTDIR:-$HOME}/.zshrc" # edit this file

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh    # dependency: zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh            # dependency: zsh-autosuggestions
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme                    # dependency: zsh-theme-powerlevel10k
command -v pacman >/dev/null && source /usr/share/doc/pkgfile/command-not-found.zsh  # dependency: pkgfile [Arch]

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
