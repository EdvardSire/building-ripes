#!/bin/bash

# install homebrew
if ! [[ -x $(which brew) ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# make sure that brew is on path
export PATH=/opt/homebrew/bin/:$PATH

# cd to home dir
cd

# install in the home dir
git clone https://github.com/EECS-NTNU/ripes-ntnu

# cd into dir and grab submodules
cd ripes-ntnu
git submodule update --init --recursive

# install relevant pacakges
# should really be like this: brew install autoconf automake libtool xz  pkg-config libgit2 libjpg libpng libmtp svg2png
# but didn't work on testing machine for some reason >:(
brew install qt
brew install autoconf 
brew install automake 
brew install libtool 
brew install xz
brew install pkg-config 
brew install libgit2 
brew install libjpg 
brew install libpng 
brew install libmtp 
brew install svg2png

# Setup python
brew install python@3.11
python3.11 -m pip install setuptools wheel py7zr>=0.20.2
python3.11 -m pip install aqtinstall==3.1.*

# Install relevant QT headers
python3.11 -m aqt install-qt mac desktop 6.5.0 clang_64 --outputdir ~/ripes-ntnu/Qt --modules qtcharts


# Exports for build 
cmake .
export QT_ROOT=$(pwd)/Qt/5.13.0/clang_64
export QT_QPA_PLATFORM_PLUGIN_PATH=$QT_ROOT/plugins
export PATH=$QT_ROOT/bin:$PATH
export CMAKE_PREFIX_PATH=$QT_ROOT/lib/cmake
DIR=$(pwd)

# Choose binary
choice=""
echo READY TO BUILD BINARY
echo PRESS 1 FOR ARM m1/m2 apple silicon
echo PRESS 2 FOR X86_64 intel
echo ANYTHING ELSE TO ABORT
read choice

# # Rebuild command table
# hash -r

if [[ $choice =~ ^[1]$ ]]; then
  cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES="arm64" .
  make
fi

if [[ $choice =~ ^[2]$ ]]; then
  cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES="x86_64" .
  make
fi

