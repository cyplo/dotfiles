choco install -y firefox googlechrome wget
refreshenv
wget https://cygwin.com/setup-x86_64.exe
REM cygwin installation
setup-x86_64 -R c:\cywin\ -Pg curl,zsh,git,vim,wget

