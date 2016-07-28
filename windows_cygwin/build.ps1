# install Chocolatey
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

# install base tools
choco install firefox
choco install googlechrome

# install cygwin and all things inside
choco install cygwin cyg-get
