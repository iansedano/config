# elevated PowerShell

$CONFIGS = @(
  @("powershell-profile.ps1", $PROFILE),
  @("gitconfigwin", "$HOME\.gitconfig"),
  @("windows-terminal.json",
    "$ENV:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"),
  @("sizer.xml",
    "$ENV:APPDATA\Sizer4\sizer.xml"),
  @("Preferences.sublime-settings",
    "$HOME\scoop\persist\sublime-text\Data\Packages\User\Preferences.sublime-settings")
)

foreach ($pair in $CONFIGS) {
  $target = "$($pair[0])"
  $symlink_path = $pair[1]
  
  Write-Host "Creating symlink for $target in $symlink_path"
  New-Item -ItemType SymbolicLink -Path $symlink_path -Target (Resolve-Path $target).Path -Force
}
