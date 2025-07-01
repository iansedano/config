Write-Output "Stopping running jobs"
stop-job -State Running
Write-Output "Removing jobs"
remove-job -State NotStarted
remove-job -State Stopped
Write-Output "Done!"