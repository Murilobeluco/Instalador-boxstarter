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

Get-Item "c:\layout" -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }

Invoke-WebRequest "https://www.horstmuc.de/win64/timesync64.zip" -outFile "c:\layout\timesync64.zip"

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


########################
#Função powershell#
function CriarRegistro {
    Param ([string]$a)
     
    if (-Not(Test-Path $a)) {
        New-Item -Path $a -Force
    }     
}


#Alterando Registros
Write-BoxStarterMessage "Alterando configuracoes do registro"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
CriarRegistro("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize")
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Name "StartupDelayInMSec" -Type QWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Type DWord -Value 0
CriarRegistro("HKLM:\Software\Policies\Microsoft\Windows\Explorer")
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Explorer" -Name "HideRecentlyAddedApps" -Type DWord -Value 1
CriarRegistro("HKLM:\Software\Policies\Microsoft\Windows\OneDrive")
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
CriarRegistro("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0

Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" -Name "IconSize" -Type DWord -Value 32
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" -Name "Mode" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" -Name "LogicalViewMode" -Type DWord -Value 3

