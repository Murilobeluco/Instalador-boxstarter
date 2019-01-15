choco feature enable -n allowEmptyChecksums
Update-ExecutionPolicy Unrestricted
Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowHiddenFilesFoldersDrives -DisableShowFrequentFoldersInQuickAccess -enableShowRibbon 
Set-TaskbarOptions -Size Small -Combine Never
Disable-UAC
Disable-BingSearch

Write-BoxstarterMessage "Desativando modo de hibernacao"
powercfg -h off

Write-BoxstarterMessage "Mudando configuracao de energia: timeout do HD nunca"
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0

Write-BoxstarterMessage "Mudando configuracao de energia: Desligar monitor apos 20 minutos"
powercfg -change -monitor-timeout-ac 20
powercfg -change -monitor-timeout-dc 20

Write-BoxstarterMessage "Mudando configuracao de energia: Standby do computador para nunca"
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0

Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Value 2

choco install Firefox googlechrome freedownloadmanager 7zip.install spotify battle.net discord.install qbittorrent jre8 javaruntime steam notepadplusplus sharex -y --ignore-checksums

Write-BoxstarterMessage "Configurando horario do windows"

New-Item -ItemType directory -Path "C:\layout\"

Get-Item "c:\layout" -Force | foreach { $_.Attributes = $_.Attributes -bor "Hidden" }

wget "https://www.horstmuc.de/win64/timesync64.zip" -outFile "c:\layout\timesync64.zip"

& 7z.exe e c:\layout\timesync64.zip -oc:\layout\ *.exe -r -y

Start-Sleep -Seconds 10

Write-BoxstarterMessage "atualizando horario"
c:\layout\timesync.exe /auto 999

Start-Sleep -Seconds 20

Stop-Process -Name timesync
Remove-Item C:\layout\timesync64.zip

Write-BoxStarterMessage "Criando tarefa do horario"
$User= "SYSTEM"
$Trigger= New-ScheduledTaskTrigger -AtLogon
$Action= New-ScheduledTaskAction -Execute "C:\layout\timesync.exe" -Argument "/auto" -WorkingDirectory "c:\layout\"
Register-ScheduledTask -TaskName "Atualizar Horario" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force

#Alterando Registros
