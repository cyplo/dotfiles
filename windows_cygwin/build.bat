choco install -y firefox googlechrome wget
wget -c https://cygwin.com/setup-x86_64.exe
REM cygwin installation
setup-x86_64.exe -R "C:\cygwin64" -s http://cygwin.netbet.org/ -q -g -P curl,zsh,git,vim,wget,xz,tar,gawk,bzip2,subversion
c:\cygwin64\bin\bash.exe --login -c "mkdir -pv $HOME/dev/"
c:\cygwin64\bin\bash.exe --login -c "ln -vfs `cygpath $HOMEPATH`/dev/dotfiles $HOME/dev"
c:\cygwin64\bin\bash.exe --login -c "DIR=$HOME/dev/dotfiles $DIR/common/configure_fresh_system"

