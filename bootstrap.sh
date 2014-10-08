#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

# z script
if [ ! -f ~/.z.sh ]; then
  curl https://raw.githubusercontent.com/rupa/z/master/z.sh > ~/.z.sh
fi

# git auto-completion
if [ ! -f ~/.git-completion.sh ]; then
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.bash
fi

# change terminal colors
open solarized.terminal

# install sublime to the home directory, add it to the path, download settings
curl http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203065.dmg > sublime.dmg
hdiutil attach sublime.dmg
cp -r /Volumes/Sublime\ Text/Sublime\ Text.app ~/Applications/Sublime/
hdiutil detach /Volumes/Sublime\ Text
rm sublime.dmg
mkdir ~/bin
ln -s ~/Applications/Sublime/Contents/SharedSupport/bin/subl ~/bin/
cp ./sublime/* ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/

# make the settings better
if [["$OSTYPE" == "darwin"*]]; then
	./osx
fi

# fix git on old linuxes
git config core.filemode false

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
