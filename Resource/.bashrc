export PATH="~/bin:$PATH"
# ~/.bashrc: executed by bash(1) for non-login shells.
# grep
alias grep='grep --color=always'
HISTFILESIZE=200000 #最大命令历史记录数
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# alias vi='vim'
alias ls='ls -aG'
alias ll='ls -alhG'
alias lll='ls -alGhS'
alias la='last | head'
alias p='pstree'
alias dudir='du --max-depth=1 -ah 2> /dev/null | sort -hr | head '
alias gitcm='/etc/kelu/gitCommit.sh'
alias kstatics='/etc/kelu/keluStatics.sh'
alias kreal='/etc/kelu/keluReal.sh'
alias iftop='sudo /usr/local/sbin/iftop'

cdl() {
            cd "${1}";
            pwd;
            ls -G;
        }
alias cd=cdl
alias cdh='cd $HOME'
alias cdkeluMacKit='cd $HOME/Workspace/KeluMacKit'
alias sour='source ~/.bashrc'

tn()
{
    tmux new-session -s "kelu" -d -n "workspace"    # 开启一个会话
    tmux new-window -n "monitor"          # 开启一个窗口
    tmux split-window -h                # 开启一个竖屏
    tmux split-window -v "iftop"          # 开启一个横屏,并执行top命令
    tmux -2 attach-session -d           # tmux -2强制启用256color，连接已开启的tmux
}

alias tll='tmux ls'
alias tt='tmux attach -t kelu'
alias tk='tmux kill-session -t'

PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
