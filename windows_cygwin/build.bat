choco install -y firefox googlechrome wget
wget -c https://cygwin.com/setup-x86_64.exe
REM cygwin installation
setup-x86_64.exe -R "C:\cygwin64" -s http://cygwin.netbet.org/ -q -g -P curl,zsh,git,vim,wget

