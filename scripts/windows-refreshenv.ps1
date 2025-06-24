# foreach ($level in "Machine", "User") {
#     [Environment]::GetEnvironmentVariables($level).GetEnumerator() | ForEach-Object {
#         Write-Output($_.name)
#         if ($_.Name -match 'Path$') {
#             $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select-Object -unique) -join ';'
#         }
#         $_
#     } | Set-Content -Path { "Env:$($_.Name)" }
# }


foreach ($level in "Machine", "User") {
    [Environment]::GetEnvironmentVariables($level).GetEnumerator() | ForEach-Object {
        if ($_.Name -match 'Path$') { 
            $_.Value = (
                $((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' |
                Select-Object -unique
            ) -join ';'
        }
        $_
    }
    | Set-Content -Path { "Env:$($_.Name)" }
}