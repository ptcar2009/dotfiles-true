#!/bin/bash
INFO="\033"
. scripts/colors.bash

INFO_MSG="echo -e $INFO"
infomsg () {
	$INFO_MSG $*
}

if [ -f /etc/os-release ]; then
	# freedesktop.org and systemd
	. /etc/os-release
	OS=$NAME
	VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
	# linuxbase.org
	OS=$(lsb_release -si)
	VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
	# For some versions of Debian/Ubuntu without lsb_release command
	. /etc/lsb-release
	OS=$DISTRIB_ID
	VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
	# Older Debian/Ubuntu/etc.
	OS=Debian
	VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
	# Older SuSE/etc.
	...
elif [ -f /etc/redhat-release ]; then
	# Older Red Hat, CentOS, etc.
	...
else
	# Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
	OS=$(uname -s)
	VER=$(uname -r)
fi

case $OS in
	Ubuntu|Debian|Mint)
		infomsg "using apt to install packages"
		infomsg updating apt
		sudo apt update && sudo apt upgrade
		INSTALL="sudo apt install -y"
		;;
	*)
		infomsg "using yay to install packages"
		INSTALL="yay -Sy"
		;;
esac

install () {
	$INSTALL $*
}

checkinstall() {
	infomsg "checking if $1 is installed"
	if ! command -v $1 &> /dev/null
	then
		infomsg "installing git"
		if install $1
		then
			echo -e $GREEN OK
		else
			echo -e $ERROR "$1 installation returned an error"
		fi
	else
		echo -e $GREEN OK
	fi
}

checkinstall curl
checkinstall git
checkinstall zsh
checkinstall nvim
checkinstall helm
checkinstall i3
checkinstall tmux

infomsg "installing oh-my-zsh"
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh

infomsg "installing zsh-syntax highlighter"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

infomsg "installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

infomsg "creating work repository"
mkdir ~/work

if [ ! -f ~/.ssh/id_rsa ]
then
	infomsg "creating ssh key pair"
	ssh-keygen -q -t rsa -N '' <<< ""$'\n'"y" 2>&1 >/dev/null
fi


if [ ! -d $HOME/.config ]
then
	infomsg "creating configuration folder"
	mkdir $HOME/.config
fi


infomsg "copying rc files to home directory"
cp ./.zshrc ./.tmux.local.conf ./.tmux.conf ./.vimrc $HOME

# infomsg "installing vim-plug"
# sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
# 	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

infomsg "installing plugins"
nvim +PlugInstall -c wq

infomsg "checking if docker is installed"
if ! command docker
then
	case "$INSTALL" in
		"sudo apt"*)
			install dockerio
			;;
		"sudo yay"*)
			install docker
			;;
	esac
	infomsg "executing docker post installation steps"
	sudo usermod -aG docker $USER
	newgrp docker
fi


checkinstall python

infomsg "checking if gcloud is installed"
if ! command gcloud
then
	infomsg installing gcloud
	case "$INSTALL" in
		"sudo apt"*)
			echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
			curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
			sudo apt-get update && sudo apt-get install google-cloud-sdk
			;;
		"sudo yay"*)
			install google-cloud-sdk
			;;
	esac
fi

infomsg "checking if golang is installed"
if ! command go
then
	infomsg installing golang
	case "$INSTALL" in
		"sudo apt"*)
			infomsg installing golang from apt, probably old version, check how to change your environment
			install golang-go
			;;
		"sudo yay"*)
			install go
			;;
	esac
fi



checkinstall terraform
checkinstall docker-compose
checkinstall kubectl
checkinstall kubectx
checkinstall k9s
checkinstall github-cli
