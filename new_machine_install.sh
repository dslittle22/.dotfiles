#!/bin/zsh
set -euo pipefail

ZDOTDIR="${HOME}/.zsh"

print_usage() {
  printf "Usage: -m should be either personal or work."
}

pause(){
  echo $1
  echo 'Press any key to continue...'; read -k1 -s
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


echo "Checking if homebrew is installed..."

which brew > /dev/null
if [[ $? != 0 ]] ; then
    echo "Installing homebrew..."
    /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating homebrew..."
    brew update
fi

echo "Installing 1Password through homebrew..."
brew install 1password

echo "Installing git through homebrew..."
brew install git

# https://github.com/ryanoasis/nerd-fonts#option-4-homebrew-fonts
echo "Installing fonts from homebrew..."
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
brew install font-fira-code-nerd-font


echo "Checking for .zshrc.local..."
if [ ! -f ${ZDOTDIR}/.zshrc.local ]; then
  echo "${ZDOTDIR}/.zshrc.local does not exist, creating file"
  touch "${ZDOTDIR}/.zshrc.local";
fi

echo "Checking for ~/.zshenv..."
if [ ! -f ~/.zshenv ]; then
  echo "~/.zshenv does not exist, creating file and setting ZDOTDIR"
  echo "ZDOTDIR=${ZDOTDIR}" >> ~/.zshenv;
fi

echo "Making symlinks from .dotfiles..."

if [ ! -d ~/.config ]; then
  mkdir ~/.config
fi

declare -a symlinks=("${ZDOTDIR}/.zshrc" ~/.vimrc ~/.gitconfig ~/.config/karabiner.edn)

for filepath in "${symlinks[@]}"; do
  file=${filepath##*/}
  if [ -f $filepath ]; then
    if [ ! -d ~/.dotfilesbak ]; then
      mkdir ~/.dotfilesbak
    fi
    echo "$filepath already exists, making timestamped backup in ~/.dotfilesbak and making symlink from .dotfiles..."
    mv $filepath ~/.dotfilesbak/$file.$(date +%s)
  else
    echo "$filepath does not exist, making symlink from .dotfiles..."
  fi
  ln -s ~/.dotfiles/$file $filepath
done


if [ ! -d ~/.vim/pack/plugins/start/ ]; then
  echo "Creating ~/.vim/pack/plugins/start/ directory..."
  mkdir ~/.vim/pack/plugins/start;
fi
cd ~/.vim/pack/plugins/start;

declare -a vimplugins=(https://tpope.io/vim/surround.git https://tpope.io/vim/commentary.git https://github.com/sainnhe/sonokai.git)

for ghlink in "${vimplugins[@]}"; do
  I=${ghlink##*/}
  pluginname=$(echo ${I} | cut -d. -f1)
  if [ ! -d ./$pluginname ]; then
    echo "Downloading plugin ${pluginname}..."
    git clone --depth 1 $ghlink;
    vim -u NONE -c "helptags ${pluginname}/doc" -c q;
  fi
done

cd ~/.dotfiles
pause "Sign in to iCloud to get app store apps."
pause "Installing ${machine} machine profile."

if [ "$machine" = 'work' ]; then
    brew bundle --file=./Brewfile-work
else
  brew bundle --file=./Brewfile-personal
fi

pause "Go setup Karabiner permissions!"

if [ ! -d ~/.config/karabiner ]; then
  mkdir ~/.config/karabiner
fi

if [ ! -f ~/.config/karabiner/karabiner.json ]; then
  cp ~/.dotfiles/karabiner.json ~/.config/karabiner/karabiner.json
fi

rm ~/.dotfiles/karabiner.json
ln -s ~/.config/karabiner/karabiner.json ~/.dotfiles/karabiner.json

echo "Running goku..."
goku

echo "Remaining things to do:"
# echo "[ ] configure firefox userchrome (https://www.userchrome.org/how-create-userchrome-css.html) \
# and symlink: ln -s ~/.dotfiles/userChrome.css ~/Library/Application Support/Firefox/Profiles/\`weird string\`.default-release/chrome/userChrome.css"
echo "[ ] Import rectangle settings"
echo "[ ] Install wavelink and import settings"
echo "[ ] ITerm2: Preferences -> General -> Preferences -> Load preferences from a custom folder or URL: ~/.dotfiles. \
Then, import color scheme (~/.dotfiles/material-ui-colors)"
echo "[ ] Set MacOS shortcuts (e.g. f4 to DND, f5 = show desktop, cmd + option + arrow = switch tab, cmd + e = archive)"
echo "[ ] install overcast, "
