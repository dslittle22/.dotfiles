It's my dotfiles!

to create symlink:
`ln -s ~/.dotfiles/<filename> ~/<filename>`
For example, I have these symlinks:
`ln -s ~/.dotfiles/.vimrc ~/.vimrc`
`ln -s ~/.dotfiles/.gitconfig ~/.gitconfig`
`ln -s ~/.dotfiles/karabiner.edn ~/.config/karabiner.edn`
`ln -s ~/.dotfiles/userChrome.css ~/Library/Application Support/Firefox/Profiles/afjndxke.default-release/chrome/userChrome.css`

karabiner.json goes directly in ~/.config/karabiner . No symlink. This is so that function keys work right.

Vim plugins installation:
to install a plugin, do:
`mkdir -p ~/.vim/pack/plugins/start`
`cd ''`
`git clone <github plugin url>`

more info: https://medium.com/@paulodiovani/installing-vim-8-plugins-with-the-native-pack-system-39b71c351fea

Currently, you just have tpope/commentary and tpope/surround installed.
