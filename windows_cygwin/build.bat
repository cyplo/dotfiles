@echo on
choco install -y --allowEmptyChecksum firefox googlechrome wget notepadplusplus sublimetext3 mono monodevelop gtksharp visualstudiocode microsoft-build-tools visualstudio2015community p4merge dotnet4.5 ruby nodejs stylecop

wget -c https://cygwin.com/setup-x86_64.exe
setup-x86_64.exe -R "C:\cygwin64" -s http://cygwin.netbet.org/ -q -g -P curl,zsh,git,vim,wget,xz,tar,gawk,bzip2,subversion,zlib,fontconfig,clang,cmake,lua,perl,the_silver_searcher

set script_path=%~dp0
set repo_path=%script_path%\..\
set bash=c:\cygwin64\bin\bash.exe --login -c

for /f "delims=" %%A in ('%bash% "cd `cygpath $HOMEPATH`/dev/dotfiles && git rev-parse --abbrev-ref HEAD"') do set "branch=%%A" 
%bash% 'echo "branch is $branch"'
%bash% "cp -vr `cygpath $HOMEPATH`/.ssh $HOME/"
%bash% "export OUTER_CLONE=`cygpath $repo_path` && $script_path/build_insider.sh"
