Bootstrap from cmd.exe running as Administrator:

    @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/cyplo/dotfiles/master/windows/bootstrap.ps1'))"

launch a normal user's cmd.exe and:

    refreshenv
    ssh-keygen -b 8192
    type .ssh\id_rsa.pub
    # add this key to github
    mkdir dev
    cd dev
    git clone git@github.com:cyplo/dotfiles.git

launch new cmd.exe as Administrator and:
    
    cd %HOMEPATH%\dev\dotfiles
    windows\build.bat

