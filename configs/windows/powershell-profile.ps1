$ProfileTarget = get-item $PROFILE | Select-Object -ExpandProperty target
$ConfigFolder = (get-item $ProfileTarget).Directory
$ConfigRepo = $ConfigFolder.Parent.Parent

$DropboxPath = Get-Content "$ENV:LOCALAPPDATA\Dropbox\info.json" -ErrorAction Stop |
    ConvertFrom-Json |
    ForEach-Object 'personal' |
    ForEach-Object 'path'

$Notebook = "$DropboxPath\notebook"
$SnipLog = "$Notebook\snippet-log.md"
$Dev = "C:\dev"
$DropDev = "$DropboxPath\dev"

& $Env:USERPROFILE\env.ps1

$env:PATH = (Resolve-Path "$ConfigRepo/scripts").Path + ";" + $env:PATH

oh-my-posh init pwsh --config "$($ConfigFolder.FullName)/posh.omp.json" | Invoke-Expression

Import-Module PSFzf
Import-Module posh-git
Import-Module ps-autoenv

Invoke-Expression (&scoop-search --hook)

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Add `jabba use openjdk@17.0.2` for example in file referenced here
if (Test-Path "$Env:USERPROFILE\.jabba\jabba.ps1") { . "$Env:USERPROFILE\.jabba\jabba.ps1" }

function iidea(){start-process idea -argumentlist "." -windowstyle hidden}
function lsc(){Get-ChildItem | Format-Wide -Autosize -Property Name}
function dropdev(){Set-Location "$DropDev"}
function dev(){Set-Location "$Dev"}
function notebook(){Set-Location "$Notebook"}
function codesnip(){Set-Location $CodeSnipRepo}

function git-recurse ($command)
{
	Get-ChildItem -Recurse -Directory -Hidden -Filter .git `
	| ForEach-Object `
	{ Write-Host "`n`n ++++ $(Split-Path $_.FullName -Parent) ++++ `n" -ForegroundColor Green ; `
	& git --git-dir="$($_.FullName)" `
	--work-tree="$(Split-Path $_.FullName -Parent)" `
	$command}
}

function grep {
  $input | out-string -stream | select-string $args
}

# Blinking Cursor

$RECORDING = $true

function video(){
  if ( $global:RECORDING ){
    Set-PSReadLineOption -PredictionSource None
    echo "`e[6 q"
    $global:RECORDING = $false
  } else {
    echo "`e[5 q"
    Set-PSReadLineOption -PredictionSource History
    $global:RECORDING = $true
  }
}

function refresh {
  Write-Output "Refreshing..."
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
}

& "$ConfigFolder/pwsh-tree.ps1"

Import-Module "$ConfigFolder/pwsh-transcript.psm1"
function transcript(){
  Start-DropboxTranscript("$DropboxPath\backups\pwsh-logs")
}
