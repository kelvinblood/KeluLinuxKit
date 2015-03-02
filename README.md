# KeluLinuxKit
a tools to setup your dev environment on Debian. Now we are developing on the way, be careful and don't try it for your working environment.

## Waht's in it
* personal .bashrc
* iptables
* mutt & msmtp
* system backup cron with dropbox
* Maximum Awesome for Linux
* tmux-powerline
* PPTP
* dropbox
* transmission
* xrdp
* github
* lnmp(optional)

## Install
## Customize
## Uninstall
## Contribute

echo "-- Almost done ------------------------------------------------------"
echo "Install KeluLinuxKit 0.1 completed! enjoy it."
echo "You have install those things: .bashrc .input.rc tmux iptables PPTP iftop"
echo " dropbox transmission xrdp mutt&msmtp cron github"
echo "But still, you need to follow these steps with manual work."
echo "1. dropbox authorized, by running ~/.dropbox-dist/dropboxd and then running /etc/kelu/dropbox.py start to sync"
echo "2. adding plugin: Supertab neocomplcache. seeing more about how to manage plugin by Bundle."
echo "3. edit your email account on $HOME/.msmtprc and $HOME/.muttrc if you havent add secret foler."
echo "4. check your github account by: ssh -T git@github.com"
echo "5. start tmux by running tn XXX, and attach by tt XXX, kill by tk XXX"
echo "6. edit your own iptables on /etc/iptables.test.rules and then running ip"
