# ~/.bashrc: add by KeluLinuxKit
export EDITOR="/usr/bin/vim" # crontab 编辑器
export CLICOLOR=1 # for color
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
export LSCOLORS='gxfxcxdxbxegedabagacad'
# grep
alias grep='grep --color=always'
HISTFILESIZE=200000 #最大命令历史记录数
# HISTCONTROL=erasedups #去掉重复条目，默认为ignoreboth（没想通为什么不是erased ups）
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias vi='vim'
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -alh'
alias la='last | head'
alias p='netstat -antp'
alias pp='pstree -a'
alias lastn='last | grep -vn "^[i]" | grep -v "root" | grep -v "reboot" | grep -v "surface"'
alias ta='tail -f /var/log/syslog'
alias tapp='tail -f /var/log/pptpd.warn.log'
alias dr='/etc/kelu/dropbox.py'
alias lnmp='/etc/kelu/lnmp'
alias dudir='du --max-depth=1 -ah 2> /dev/null | sort -hr | head '
alias gitcm='/etc/kelu/gitCommit.sh'
alias kstatics='/etc/kelu/keluStatics.sh'
alias kreal='/etc/kelu/keluReal.sh'
# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
umask 022

alias cdh='cd ~'
alias cdkelu='cd /home/wwwroot/kelu.org'
alias cddr='cd /root/Dropbox'
alias cdlog='cd /var/log'
alias cdgit='cd /home/github/kelvinblood.github.com/draft/Linux'
alias cdt='cd /test'
alias sour='source ~/.bashrc'

ip() {
  iptables -F;
  iptables-restore < /etc/iptables.test.rules;
  iptables-save > /etc/iptables.up.rules;
  iptables -L;
}

alias tn='tmux new -s'
alias tll='tmux ls'
alias tt='tmux attach -t'
alias tk='tmux kill-session -t'
