choco install -y firefox googlechrome wget notepadplusplus

wget -c https://cygwin.com/setup-x86_64.exe
setup-x86_64.exe -R "C:\cygwin64" -s http://cygwin.netbet.org/ -q -g -P curl,zsh,git,vim,wget,xz,tar,gawk,bzip2,subversion

c:\cygwin64\bin\bash.exe --login -c "cp -vr `cygpath $HOMEPATH`/.ssh $HOME/"
c:\cygwin64\bin\bash.exe --login -c "mkdir -pv $HOME/dev/"
c:\cygwin64\bin\bash.exe --login -c "git clone git@github.com:cyplo/dotfiles.git dev/dotfiles"

c:\cygwin64\bin\bash.exe --login -c "export DIR=$HOME/dev/dotfiles && bash $DIR/common/configure_fresh_system"

