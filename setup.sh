# manual install
# https://github.com/patroza/alt-tab-macos

# install
brew install --cask nikitabobko/tap/aerospace

brew tap FelixKratz/formulae
brew install sketchybar

brew tap FelixKratz/formulae
brew install borders

brew install stow

brew install --cask font-ubuntu-mono-nerd-font
brew install --cask font-hack-nerd-font
brew install --cask font-sf-pro
brew install --cask font-sf-mono
brew install --cask font-sketchybar-app-font
brew install --cask font-inconsolata-nerd-font
brew install --cask font-caskaydia-cove-nerd-font
brew install --cask font-cascadia-code-nf
brew install --cask font-meslo-lg-nerd-font
brew install zoxide eza
brew install tmux sesh
brew install nushell
brew install fastfetch btop
brew tap ajrosen/tap && brew install icalPal
brew install --cask font-jetbrains-mono && brew install --cask font-jetbrains-mono-nerd-font

#brew install asimov
#brew install derailed/k9s/k9s
#brew install jesseduffield/lazydocker/lazydocker lazygit


# skychybar alt
brew install --cask ubersicht
git clone https://github.com/Jean-Tinland/simple-bar $HOME/Library/Application\ Support/Übersicht/widgets/simple-bar
git clone https://github.com/Jean-Tinland/simple-bar-server.git $HOME/pj/simple-bar-server
cd $HOME/pj/simple-bar-server
# Install local dependencies
npm install

npm i -g pm2
# Run the server
npm run start

# Register the server to be run at startup
# pm2 will ask you to run a command as sudo to register it ("sudo env PATH=...")
pm2 startup

sudo env PATH=$PATH:/Users/patrickroza/.nvm/versions/node/v22.20.0/bin /Users/patrickroza/.nvm/versions/node/v22.20.0/lib/node_modules/pm2/bin/pm2 startup launchd -u patrickroza --hp /Users/patrickroza

# Save the current pm2 configuration
pm2 save
