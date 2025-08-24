$StartTime = Get-Date

scoop install svg-explorer-extension-np

Write-Output "Downloading and installing Chocolatey"
Invoke-WebRequest -useb community.chocolatey.org/install.ps1 | Invoke-Expression
choco feature enable -n allowGlobalConfirmation

Write-Output "Installing Chocolatey Packages"
choco install veracrypt
choco install sizer
choco install pdfxchangeeditor --version 7.0.328.2 --package-parameters="/NoDesktopShortcuts /NoViewInBrowsers"
choco pin add -n pdfxchangeeditor

# Delete new desktop shortcuts
$Desktops = "$env:PUBLIC\Desktop", "$env:USERPROFILE\Desktop"
  $Desktops |
  Get-ChildItem -Filter "*.lnk" -ErrorAction SilentlyContinue |
  Where-Object { $_.LastWriteTime -gt $StartTime } |
  Remove-Item

# refreshenv (choc replacement because it won't work on same session as install)
# Source: https://stackoverflow.com/a/22670892/10445017
foreach ($level in "Machine", "User") {
    [Environment]::GetEnvironmentVariables($level).GetEnumerator() |
    ForEach-Object {
        if ($_.Name -match 'Path$') {
            $combined_path = (Get-Content "Env:$($_.Name)") + ";$($_.Value)"
            $_.Value = (
              ($combined_path -split ';' | Select-Object -unique) -join ';'
            )
        }
        $_
    } | Set-Content -Path { "Env:$($_.Name)" }
}

