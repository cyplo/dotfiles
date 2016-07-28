REM install Chocolatey
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

REM install base tools
choco install firefox
choco install googlechrome

REM install cygwin and all things inside
choco install cygwin cyg-get
