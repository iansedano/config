# Windows Setup Instructions

Do Windows Updates

```powershell
# to save content of a page to a file
iwr -useb "https://raw.githubusercontent.com/iansedano/config/master/setup/win-10-setup/setup-script-non-admin.ps1" | Add-Content test.txt
# to run content of an online script
iwr -useb "https://raw.githubusercontent.com/iansedano/config/master/setup/win-10-setup/setup-script-non-admin.ps1" | iex
```

## Explorer Settings

Explorer > This PC > File > Change Folder and Search Options > View

- Display full path in the title bar
- Show hidden files, folders and drives
- Hide extensions for known file types

```powershell
gh auth login
cd C:/
mkdir dev
cd dev
mkdir iansedano
cd iansedano
gh repo clone config
gh repo clone wtf
gh repo clone git-journal
$PROFILE
$RegistryPath = "HKCU:\Control Panel\Desktop"
$Name = "ActiveWndTrkTimeout"
$Val = "1000"
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Val -PropertyType DWORD -Force
```

- From config run setup-script.ps1 and then setup-script-2.ps1, then symlink setup.

## MySQL

```
Start-process mysqld -windowstyle hidden
get-process "mysql*"
Get-Process -Name "mysql*" | ForEach-Object { Stop-Process $_.Id }
```

or

```
net start mysql
```

```powershell
mysql.exe -u root -p
```

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT;
```

## Neovim

```pwsh
sudo new-item -ItemType SymbolicLink `
-Path "C:\Users\ianse\AppData\Local\nvim\init.vim" `
-Target "C:\dev\CodeSnips-Notes\configs\nvim-init.vim"
```

## Syncthing

Set it up!
