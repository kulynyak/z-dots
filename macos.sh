#!/usr/bin/env bash

# Add Homebrew to PATH if not already added
sudo sh -c 'grep -qxF "export PATH=\"/opt/homebrew/bin:/opt/homebrew/sbin:\$PATH\"" /etc/profile || echo "export PATH=\"/opt/homebrew/bin:/opt/homebrew/sbin:\$PATH\"" >> /etc/profile'
source /etc/profile
# Install Homebrew (if not installed)
if test ! "$(which brew)"; then
  echo "Installing Homebrew for you."
  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && echo "Homebrew installed"
  fi
fi

source /etc/profile

inst_items=('git' 'karabiner' 'tmux' 'zsh' 'wezterm' 'kitty' 'bash' 'bin')
u_dots=$PWD
for i in "${inst_items[@]}"; do
  echo "installing $i ..."
  cd "$i"
  ./install.sh
  echo "$i installed"
  cd "$u_dots"
done

echo "installing hammerspoon ..."
hammerspoon=$HOME/.hammerspoon
if [ ! -d "$hammerspoon" ]; then
  git clone git@github.com:kulynyak/hammerspoon.git "$hammerspoon"
  ln -s "$hammerspoon" "$u_dots/hammerspoon"
fi
cd hammerspoon
./install.sh
echo "hammerspoon installed"
cd "$u_dots"


echo "installing Brewfile ..."
brew bundle --file="$u_dots/brew/Brewfile"
echo "Brewfile installed"
