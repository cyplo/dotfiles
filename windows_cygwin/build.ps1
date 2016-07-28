# install Chocolatey
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

# install base tools
choco install -y firefox
choco install -y googlechrome

# install cygwin and all things inside
choco install -y cygwin cyg-get
