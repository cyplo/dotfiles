@echo on
choco install -y --allowEmptyChecksum firefox googlechrome wget notepadplusplus sublimetext3 mono monodevelop gtksharp visualstudiocode p4merge dotnet4.5 nodejs.install conemu dejavufonts ag golang wireshark procexp procmon drmemory.install WinPcap keepass.install nextcloud-client f.lux
choco upgrade -y all
call refreshenv

wget -c https://cygwin.com/setup-x86_64.exe
setup-x86_64.exe -R "C:\cygwin64" -s http://mirror.switch.ch/ftp/mirror/cygwin/ -q -g -P curl,zsh,git,vim,wget,xz,tar,gawk,bzip2,subversion,zlib,fontconfig,clang,cmake,clang,gcc,gcc-g++,lua,perl,the_silver_searcher,gnupg,patch,zlib-devel,openssl-devel,libyaml-devel,libyaml0_2,sqlite3,make,libtool,autoconf,automake,bison,m4,mingw64-i686-gcc-core,mingw64-x86_64-gcc-core,patch,cygwin32-readline,libcrypt-devel,libcrypt0,ncurses,libncurses-devel,python-devel,libxslt,libxslt-devel,libjpeg-devel

set script_path=%~dp0
set repo_path=%script_path%\..\
pushd %repo_path%
set repo_path=%CD%
popd

set bash=c:\cygwin64\bin\bash.exe --login -c

for /f "delims=" %%A in ('%bash% "cd `cygpath $HOMEPATH`/dev/dotfiles && git rev-parse --abbrev-ref HEAD"') do set "branch=%%A" 
%bash% 'echo "branch is $branch"'
%bash% "cp -vr `cygpath $HOMEPATH`/.ssh $HOME/"
%bash% "export OUTER_CLONE=`cygpath $repo_path` && $script_path/build_insider.sh"

echo Configuring Windows-specific settings
echo %repo_path% is repo path

if not exist "%appdata%\Roaming\" mkdir "%appdata%\Roaming\"
IF EXIST "%appdata%\Roaming\ConEmu.xml" del /F "%appdata%\Roaming\ConEmu.xml"
mklink /h "%appdata%\Roaming\ConEmu.xml" "%repo_path%\conemu.xml"

IF EXIST "%HOMEPATH%\.gitconfig" del /F "%HOMEPATH%\.gitconfig"
mklink /h "%HOMEPATH%\.gitconfig" "%repo_path%\.gitconfig.windows
