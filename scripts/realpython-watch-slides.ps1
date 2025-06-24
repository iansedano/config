Param($input_source)

$input_source = Convert-Path $input_source
$dest = "C:\dev\rp\rp-slides\slides.md"

Write-Host $input_source $dest

$parent = Split-Path $input_source
$leaf = Split-Path -Leaf $input_source

$sleep = 1

Write-Host "Current PID = $pid"
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "$parent"
$watcher.Filter = "*$leaf"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

# Action after event.
$action = {
    $time = Get-Date -Format 'HH:mm'
    Write-Host "Change detected $time"
    Copy-Item -Force -Path $args[1].FullPath -Destination $event.MessageData
    make -C "C:\dev\rp\rp-slides\" html
}

$job = Register-ObjectEvent $watcher "Changed" -Action $action -MessageData $dest

Write-Host $job.Id

# Main loop.
while ($true) { Start-Sleep $sleep }