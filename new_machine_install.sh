#!/bin/sh

print_usage() {
  printf "Usage: -m should be either personal or work."
}

unset -v machine
while getopts 'm:' opt; do
  case $opt in
    m) machine=$OPTARG;;
    *) print_usage
       exit 1
  esac
done

if [[ "$machine" != work && "$machine" != personal ]]; then
    print_usage;
    exit 1;
fi

echo "Installing homebrew..."
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 


echo "Installing 1Password..."
brew install 1password

# https://github.com/ryanoasis/nerd-fonts#option-4-homebrew-fonts
echo "Installing fonts from homebrew..."
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
brew install font-fira-code-nerd-font

echo "Sign in to iCloud, Log in to 1Password, and do the new SSH key thing for github! Go here: "
echo "https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent"
echo ""

read -p "Press enter to continue"

echo "Cloning dotfiles repo..."
git clone git@github.com:dslittle22/.dotfiles.git

echo "Making symlinks..."
ln -s ~/.dotfiles/.zshenv ~/.zshenv 
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.zshrc ~/.zsh/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/karabiner.edn ~/.config/karabiner.edn
ln -s ~/.dotfiles/karabiner.json ~/.config/karabiner/karabiner.json

echo "Installing tpope/surround and tpope/commentary..."
mkdir ~/.vim/pack/plugins/start;
cd ~/.vim/pack/plugins/start;
git clone https://tpope.io/vim/surround.git;
git clone https://tpope.io/vim/commentary.git;
git clone --depth 1 https://github.com/sainnhe/sonokai.git

vim -u NONE -c "helptags surround/doc" -c q;
vim -u NONE -c "helptags commentary/doc" -c q;
vim -u NONE -c "helptags sonokai/doc" -c q;

echo "Installing from brewfile..."

read -p "Installing ${machine} machine profile. Press enter to continue"

if [ "$machine" == work ]; then
    brew bundle --file=./Brewfile-work
  else 
    brew bundle --file=./Brewfile-private
fi

echo "Go setup Karabiner permissions!"
read -p "Press enter to continue"

goku

echo "Remaining things to do:"
echo "[ ] configure firefox userchrome (https://www.userchrome.org/how-create-userchrome-css.html) and symlink: ln -s ~/.dotfiles/userChrome.css ~/Library/Application Support/Firefox/Profiles/\`weird string\`.default-release/chrome/userChrome.css"
echo "[ ] Import rectangle settings"
echo "[ ] Install wavelink and import settings"
echo "[ ] ITerm2: Preferences -> General -> Preferences -> Load preferences from a custom folder or URL: ~/.dotfiles. \
Then, import color scheme (~/.dotfiles/material-ui-colors)"
echo "[ ] Get tinkertool (http://www.bresink.com/osx/TinkerToolOverview.html), import settings"
echo "[ ] Set MacOS shortcuts (f4 to DND)"
