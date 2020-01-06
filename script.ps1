choco feature enable -n allowEmptyChecksums
Update-ExecutionPolicy Unrestricted
Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowHiddenFilesFoldersDrives -DisableShowFrequentFoldersInQuickAccess -enableShowRibbon
Set-TaskbarOptions -Combine Never
Disable-BingSearch
 
choco install Firefox googlechrome notepadplusplus.install shutup10 qbittorrent spotify discord.install fastcopy battle.net twitch authy-desktop megasync dropbox 7zip.install sharex  jre8 javaruntime freedownloadmanager steam razer-synapse-2 geforce-experience -y --ignore-checksums
 
Write-BoxstarterMessage 'Desativando modo de hibernacao'
powercfg -h off
 
Write-BoxstarterMessage 'Mudando configuracao de energia: timeout do HD nunca'
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
 
Write-BoxstarterMessage 'Mudando configuracao de energia: Desligar monitor apos 20 minutos'
powercfg -change -monitor-timeout-ac 10
powercfg -change -monitor-timeout-dc 10
 
Write-BoxstarterMessage 'Mudando configuracao de energia: Standby do computador para nunca'
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
 
Set-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name 'InitialKeyboardIndicators' -Value 2
 
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\7-Zip\", [EnvironmentVariableTarget]::Machine)
refreshenv
 
New-Item -ItemType directory -Path 'C:\layout\'
 
Get-Item 'c:\layout' -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor 'Hidden' }
 
 
Write-BoxstarterMessage 'Configurando ShareX'
Invoke-WebRequest 'https://dl.dropbox.com/s/8ns8lh850n5ppuh/ShareX-13.0.1-backup.sxb' -outFile 'c:\layout\sharexconfig.zip'
                           
$caminho = [environment]::getfolderpath("mydocuments") +'\' + 'Sharex'
$comando = '& 7z.exe e c:\layout\sharexconfig.zip -o'+$caminho+' -y'
Stop-Process -Name sharex | out-null
Invoke-Expression $comando | out-null

 
function CriarRegistro {
    Param ([string]$a)
     
    if (-Not(Test-Path $a)) {
        New-Item -Path $a -Force | out-null
    }    
}
 
function CarregarExplorer {
    Write-BoxStarterMessage 'Parando o processo Explorer.exe'
    Stop-Process -Name Explorer | out-null
    gpupdate /force
    Start-Sleep 10
}
 
Write-BoxStarterMessage 'Alterando configuracoes do registro'
CriarRegistro('HKLM:\Software\Policies\Microsoft\Windows\Explorer')
CriarRegistro('HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization')
CriarRegistro('HKLM:\Software\Policies\Microsoft\Windows\OneDrive')
CriarRegistro('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize')
CriarRegistro('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu')
CriarRegistro('HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer')
CriarRegistro('HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People')
CriarRegistro('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel')
 
#configurando menu iniciar
Write-BoxStarterMessage 'Configurando menu iniciar'
Invoke-WebRequest 'https://pastebin.com/raw/Rag0n8dQ' -outFile 'c:\layout\layout.xml'
Set-ItemProperty -Path 'HKLM:Software\Policies\Microsoft\Windows\Explorer' -Name 'LockedStartLayout' -Type DWord -Value 1
Set-ItemProperty -Path 'HKLM:Software\Policies\Microsoft\Windows\Explorer' -Name 'StartLayoutFile' -Type ExpandString -Value 'c:\layout\layout.xml'
CarregarExplorer
Set-ItemProperty -Path 'HKLM:Software\Policies\Microsoft\Windows\Explorer' -Name 'LockedStartLayout' -Type DWord -Value 0
Set-ItemProperty -Path 'HKLM:Software\Policies\Microsoft\Windows\Explorer' -Name 'StartLayoutFile' -Type ExpandString -Value ''
CarregarExplorer
 
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization' -Name NoLockScreen -Type DWord -Value 1
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name 'HideRecentlyAddedApps' -Type DWord -Value 1
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\OneDrive' -Name 'DisableFileSyncNGSC' -Type DWord -Value 1
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize' -Name 'StartupDelayInMSec' -Type QWord -Value 0
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name 'PeopleBand' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SystemPaneSuggestionsEnabled' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338388Enabled' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Type DWord -Value 1
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarSmallIcons' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop' -Name 'IconSize' -Type DWord -Value 30
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop' -Name 'Mode' -Type DWord -Value 1
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop' -Name 'LogicalViewMode' -Type DWord -Value 3
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackDocs' -Type DWord -Value 0
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoRecentDocsHistory' -Type DWord -Value 1
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarGlomLevel' -Type Dword -Value 2
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'DisableAntiSpyware' -Type Dword -Value 1
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Free Download Manager'
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Spotify'
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Discord'
 
Write-BoxStarterMessage 'apaga pacote temporario'
$caminho = $env:ProgramData + '\chocolatey\lib\'
Remove-Item –path $caminho -include *tmp* –recurse

Write-BoxStarterMessage 'Configurando Shutup10'
Invoke-WebRequest 'https://pastebin.com/raw/RUUZndqj' -outFile 'c:\layout\ooshutup10.cfg'
oosu10.exe c:\layout\ooshutup10.cfg /quiet

Write-BoxstarterMessage 'Configurando horario do windows'
Invoke-WebRequest 'https://dl.dropbox.com/s/ke5empa6ecx8hv9/NetTime.exe' -outFile 'c:\layout\NetTime.exe'
Invoke-WebRequest 'https://dl.dropbox.com/s/8nhtbtitju3k52o/NetTimeService.exe' -outFile 'c:\layout\NetTimeService.exe'
Invoke-WebRequest 'https://pastebin.com/raw/PTt4Zi2G' -outFile 'c:\layout\atualizarhorario.bat'

CriarRegistro('HKLM:\SOFTWARE\Subjective Software\NetTime')

Set-ItemProperty -Path 'HKLM:\Software\Subjective Software\NetTime' -Name 'Hostname' -Type String -Value 'a.ntp.br'
Set-ItemProperty -Path 'HKLM:\Software\Subjective Software\NetTime' -Name 'Port' -Type DWord -Value '123'
Set-ItemProperty -Path 'HKLM:\Software\Subjective Software\NetTime' -Name 'Protocol' -Type DWord -Value '0'

c:\layout\NetTime.exe /updateonce

Write-BoxStarterMessage 'Criando tarefa do horario'
$User= $env:UserName
$Trigger= New-ScheduledTaskTrigger -AtLogon
$Action= New-ScheduledTaskAction -Execute 'c:\layout\atualizarhorario.bat' -WorkingDirectory 'c:\layout\'
Register-ScheduledTask -TaskName 'Atualizar Horario' -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force