# elevated PowerShell

$REPOSITORY_NAME = "config"
$CONFIG_FOLDER_NAME = "configs/windows"

$repo_root = (get-item $PSScriptRoot).parent
if (($repo_root -split '\\')[-1] -ne $REPOSITORY_NAME) {
  write-host "Repo not correctly initialized"
  exit
}

$config_root = "$repo_root\$CONFIG_FOLDER_NAME"

$CONFIGS = @(
  @("powershell-profile.ps1", $PROFILE),
  @("gitconfigwin", "$HOME\.gitconfig"),
  @("windows-terminal.json",
    "$ENV:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"),
  @("sizer.xml",
    "$ENV:APPDATA\Sizer4\sizer.xml"),
  @("Preferences.sublime-settings",
    "$ENV:APPDATA\Sublime Text\Packages\User\Preferences.sublime-settings")
)

foreach ($pair in $CONFIGS) {
  $target = "$config_root\$($pair[0])"
  $symlink_path = $pair[1]
  
  Write-Host "Creating symlink for $target in $symlink_path"
  New-Item -ItemType SymbolicLink -Path $symlink_path -Target $target -Force
}
