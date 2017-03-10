export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export SSH_KEY_PATH="~/.ssh/admin@kelu.org"
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL=


alias vi='vim'
alias dd='df -h'
alias dudir='du --max-depth=1 -ah 2> /dev/null | sort -hr | head '
alias p='netstat -antp'
alias pp='pstree -a'
alias ta='tail -f /var/log/syslog'
alias cdlog='cd /var/log'
alias ss='ssserver -c /etc/kelu/shadowsocksConfig.json -d'
alias k='/etc/kelu/keluReal.sh'
alias rm0='find / -type f -name "0" | xargs -i  rm -fr "{}"'
alias grepall='grep -D skip -nRe'
alias sour='source ~/.zshrc'

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


function collapse_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
  git branch >/dev/null 2>/dev/null && echo '±' && return
  hg root >/dev/null 2>/dev/null && echo '?' && return
  echo 'YUKI.N >'
}

function battery_charge {
  echo `$BAT_CHARGE` 2>/dev/null
}

function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function hg_prompt_info {
  hg prompt --angle-brackets "\
< on %{$fg[magenta]%}<branch>%{$reset_color%}>\
< at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
$(virtualenv_info)$(prompt_char) '

RPROMPT='$(battery_charge)'

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# export LANG="zh_CN.UTF-8"
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL=""
HOSTNAME=$(hostname)




export LOG_HOME=/var/local/log
export DATA_HOME=/var/local/data
export UPLOAD_HOME=/var/local/upload

export PHP_HOME=/usr/share/php5.6
export FPM_POOL_HOME=/var/local/fpm-pools

export OPENRESTY_HOME=/usr/share/openresty
export NGINX_HOME=/usr/share/openresty/nginx
export LD_LIBRARY_PATH=/usr/share/lib

export JAVA_HOME=/usr/share/jdk1.8
export CLASSPATH=.:/usr/share/jdk1.8/lib

export JETTY_HOME=/usr/share/jetty9.3

export SSADMIN_HOME=/var/local/ss-bash




alias vi='vim'
alias dd='df -h'
alias bot='cd /var/local/hubot/slack && HUBOT_SLACK_TOKEN=xoxb-127727276277-zvowbS9yPxisxvrr5EArFs2F ./bin/hubot --adapter slack --name slack 2>&1'
alias wx='cd /var/local/hubot/wechat && ./bin/hubot --adapter weixin --name weixin 2>&1'
alias dudir='du --max-depth=1 -ah 2> /dev/null | sort -hr | head '
alias p='netstat -antup | grep -v "python"| grep -v "server_linux_"| grep -v "TIME_WAIT" | grep -v "CLOSE_WAIT" '
alias ppp='netstat -antp'
alias pp='pstree -a'
alias pk='pkill -kill -t'
alias ta='tail -f /var/log/syslog'
alias tw='tail -f /var/local/fpm-pools/wechat/www/storage/logs/laravel.log'
alias cdlog='cd /var/log'
alias cdwww='cd /home/wwwroot/kelu.org'
alias s='/etc/kelu/keluStatics.sh'
alias k='/etc/kelu/keluReal.sh'
alias rm0='find / -type f -name "0" | xargs -i  rm -fr "{}"'
alias grepall='grep -D skip -nRe'
alias dr='python /root/Dropbox/bin/dropbox.py'
alias baidu='/root/bpcs_uploader/bpcs_uploader.php upload'
alias bb='/root/bpcs_uploader/bpcs_uploader.php uploadbig'
alias drstart='dropbox start -i'
#alias ss='/var/local/ss-bash/ssadmin.sh'
alias sour='source ~/.zshrc'
alias ssip='iptables -nvx -L ssinput | cat -A - | grep'

ipt() {
  iptables -F;
  iptables-restore < /etc/iptables.test.rules;
  iptables-save > /etc/iptables.up.rules;
  iptables -L;
}

alias tn='tmux new -s'
alias tll='tmux ls'
alias tt='tmux attach -t'
alias tk='tmux kill-session -t'

gitInit() {
ssh-agent zsh;
ssh-agent -s;
ssh-add ~/.ssh/admin@kelu.org;
}
# Some useful commands to use docker.
# Author: yeasy@github
# Created:2014-09-25

alias docker-pid="sudo docker inspect --format '{{.State.Pid}}'"
alias docker-ip="sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

#the implementation refs from https://github.com/jpetazzo/nsenter/blob/master/docker-enter
function docker-enter() {
    #if [ -e $(dirname "$0")/nsenter ]; then
    #Change for centos bash running
    if [ -e $(dirname '$0')/nsenter ]; then
        # with boot2docker, nsenter is not in the PATH but it is in the same folder
        NSENTER=$(dirname "$0")/nsenter
    else
        # if nsenter has already been installed with path notified, here will be clarified
        NSENTER=$(which nsenter)
        #NSENTER=nsenter
    fi
    [ -z "$NSENTER" ] && echo "WARN Cannot find nsenter" && return

    if [ -z "$1" ]; then
        echo "Usage: `basename "$0"` CONTAINER [COMMAND [ARG]...]"
        echo ""
        echo "Enters the Docker CONTAINER and executes the specified COMMAND."
        echo "If COMMAND is not specified, runs an interactive shell in CONTAINER."
    else
        PID=$(sudo docker inspect --format "{{.State.Pid}}" "$1")
        if [ -z "$PID" ]; then
            echo "WARN Cannot find the given container"
            return
        fi
        shift

        OPTS="--target $PID --mount --uts --ipc --net --pid"

        if [ -z "$1" ]; then
            # No command given.
            # Use su to clear all host environment variables except for TERM,
            # initialize the environment variables HOME, SHELL, USER, LOGNAME, PATH,
            # and start a login shell.
            #sudo $NSENTER "$OPTS" su - root
            sudo $NSENTER --target $PID --mount --uts --ipc --net --pid su - root
        else
            # Use env to clear all host environment variables.
            sudo $NSENTER --target $PID --mount --uts --ipc --net --pid env -i $@
        fi
    fi
}

prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}
