oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/zash.omp.json" | Invoke-Expression

$HistorySavePath = $HISTFILE = Get-PSReadLineOption |
    Select-Object -ExpandProperty HistorySavePath

Set-PSReadLineOption -BellStyle None -HistoryNoDuplicates

zoxide init --cmd cd powershell | Out-String | Invoke-Expression
