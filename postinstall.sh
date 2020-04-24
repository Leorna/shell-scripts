#!/bin/bash

##---------- Variables ----------##

first_lock="/var/lib/dpkg/lock-frontend"
second_lock="/var/cache/apt/archives/lock"

dowloads_dir="$HOME/Downloads/programs"

url_google_chrome="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
url_stacer="https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb"

url_node="https://deb.nodesource.com/setup_12.x"
urls_yarn=(
    "https://dl.yarnpkg.com/debian/pubkey.gpg"
    "deb https://dl.yarnpkg.com/debian/ stable main"
)

snap_programs=(
    code #--classic
    discord
    telegram-desktop
    pycharm-community
    insomnia
)

apt_programs=(
    gnome-tweaks
    snapd
    nodejs
    apache2
    mysql-server
    php
    php-mysqli
    mysql-workbench
    python3-pip
)



##---------- Removing apt's locks ----------##

if [ -s "$first_lock" ]; then
    sudo rm "$first_lock"
fi

if [ -s $second_lock ]; then
    sudo rm "$second_lock"
fi



##---------- Updating repositories ----------##

echo "Updating repositories..."

if ! sudo apt-get update; then
    echo "Coudn't update. 
Check your file /etc/apt/sources.list or run this file as root"
    exit 1   
else
    echo "Repositories updated"
fi



mkdir "$dowloads_dir"



##---------- Installing google chrome ----------##

## getting chrome.deb
wget -c "$url_google_chrome" -P "$dowloads_dir"
wget -c "$url_stacer" -P "$downloads_dir"

## installing chrome and stacer
sudo dpkg -i $dowloads_dir/*.deb



##---------- Installing apt apps ----------##

for program in ${apt_programs[@]}; do
    ## if programs is not installed
    if ! dpkg -l | grep -q $program; then
        if [ "$program" = "nodejs" ]; then
            sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
            curl -sL "$url_node" | sudo -E bash - 
        elif [ "$program" = "yarn" ]; then
            curl -sS ${urls_yarn[0]} | sudo apt-key add -
            echo ${urls_yarn[1]} | sudo tee /etc/apt/sources.list.d/yarn.list
        fi

        sudo apt-get install "$program" -y

        if [ "$program" = "mysql-server" ]; then
            sudo mysql_secure_installation utility
            sudo ufw enable
            sudo ufw allow mysql
            sudo systemctl start mysql
            sudo systemctl enable mysql
            sudo systemctl restart mysql
        fi
    else ## if is installed
        echo "$program is installed"
    fi
done



##---------- Installing snap apps ----------##

for program in ${snap_programs[@]}; do
    if [ "$program" = "code" -o "$program" = "insomnia" -o "$program" = "pycharm-community" ]; then
        sudo snap install "$program" --classic
    else
        sudo snap install "$program"
    fi
done