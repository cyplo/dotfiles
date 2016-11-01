@echo on
choco install -y --allowEmptyChecksum firefox googlechrome wget notepadplusplus sublimetext3 mono monodevelop gtksharp visualstudiocode p4merge dotnet4.5 ruby nodejs.install stylecop conemu dejavufonts ag
call refreshenv

wget -c https://cygwin.com/setup-x86_64.exe
setup-x86_64.exe -R "C:\cygwin64" -s http://mirror.switch.ch/ftp/mirror/cygwin/ -q -g -P curl,zsh,git,vim,wget,xz,tar,gawk,bzip2,subversion,zlib,fontconfig,clang,cmake,lua,perl,the_silver_searcher,gnupg,patch,zlib-devel,openssl-devel,libyaml-devel,libyaml0_2,sqlite3,make,libtool,autoconf,automake,bison,m4,mingw64-i686-gcc-core,mingw64-x86_64-gcc-core,patch,cygwin32-readline,libcrypt-devel,libcrypt0

set script_path=%~dp0
set repo_path=%script_path%\..\
set bash=c:\cygwin64\bin\bash.exe --login -c

for /f "delims=" %%A in ('%bash% "cd `cygpath $HOMEPATH`/dev/dotfiles && git rev-parse --abbrev-ref HEAD"') do set "branch=%%A" 
%bash% 'echo "branch is $branch"'
%bash% "cp -vr `cygpath $HOMEPATH`/.ssh $HOME/"
%bash% "export OUTER_CLONE=`cygpath $repo_path` && $script_path/build_insider.sh"
