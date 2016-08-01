@echo on
choco install -y firefox googlechrome wget notepadplusplus sublimetext3

wget -c https://cygwin.com/setup-x86_64.exe
setup-x86_64.exe -R "C:\cygwin64" -s http://cygwin.netbet.org/ -q -g -P curl,zsh,git,vim,wget,xz,tar,gawk,bzip2,subversion,zlib,fontconfig,cmake,clang,gcc,gcc-g++

set bash=c:\cygwin64\bin\bash.exe --login -c
for /f "delims=" %%A in ('%bash% "cd `cygpath $HOMEPATH`/dev/dotfiles && git rev-parse --abbrev-ref HEAD"') do set "branch=%%A" 
%bash% 'echo "branch is $branch"'
%bash% "cp -vr `cygpath $HOMEPATH`/.ssh $HOME/"

%bash% "mkdir -pv $HOME/dev/"
%bash% "rm -fr $HOME/dev/dotfiles"
%bash% "git clone `cygpath $HOMEPATH`/dev/dotfiles $HOME/dev/dotfiles"
%bash% "cd $HOME/dev/dotfiles && git remote set-url origin git@github.com:cyplo/dotfiles.git"
%bash% "cd $HOME/dev/dotfiles && git checkout $branch"
%bash% "cd $HOME/dev/dotfiles && git pull"
%bash% "export DIR=$HOME/dev/dotfiles && NOSUDO=true DONT_CHANGE_SHELL=true NORUST=true $DIR/common/configure_fresh_system"

