Invoke-WebRequest 'https://dl.dropbox.com/s/mm1gyg1uha3vwae/ShareX-12.3.1-backup.sxb' -outFile 'c:\layout\sharexconfig.zip'

$caminho = [environment]::getfolderpath("mydocuments") +'\' + 'Sharex'
$comando = '& "C:\Program Files\7-Zip\7z.exe" e c:\layout\sharexconfig.zip -o'+$caminho+' -y'
Stop-Process -Name sharex | out-null
Invoke-Expression $comando | out-null
Start-Process -FilePath "C:\Program Files\ShareX\sharex.exe"


function CriarRegistro {
    Param ([string]$a)

    if (-Not(Test-Path $a)) {
        New-Item -Path $a -Force | out-null
    }
}


Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization' -Name NoLockScreen -Type DWord -Value 1
CriarRegistro('HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization')


Invoke-WebRequest 'https://dl.dropbox.com/s/ke5empa6ecx8hv9/NetTime.exe' -outFile 'c:\layout\NetTime.exe'
Invoke-WebRequest 'https://dl.dropbox.com/s/8nhtbtitju3k52o/NetTimeService.exe' -outFile 'c:\layout\NetTimeService.exe'
Invoke-WebRequest 'https://pastebin.com/raw/PTt4Zi2G' -outFile 'c:\layout\atualizarhorario.bat'
Start-Process 'c:\layout\atualizarhorario.bat'

CriarRegistro('HKLM:\SOFTWARE\Subjective Software\NetTime')
CriarRegistro('HKLM:\Software\WOW6432Node\Subjective Software\NetTime')


powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0

powercfg -change -monitor-timeout-ac 10
powercfg -change -monitor-timeout-dc 10

powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0

Set-ItemProperty -Path 'HKLM:\Software\WOW6432Node\Subjective Software\NetTime' -Name 'Hostname' -Type String -Value 'a.ntp.br'
Set-ItemProperty -Path 'HKLM:\Software\WOW6432Node\Subjective Software\NetTime' -Name 'Port' -Type DWord -Value '123'
Set-ItemProperty -Path 'HKLM:\Software\WOW6432Node\Subjective Software\NetTime' -Name 'Protocol' -Type DWord -Value '0'
Set-ItemProperty -Path 'HKLM:\Software\WOW6432Node\Subjective Software\NetTime' -Name 'LogLevel' -Type DWord -Value '3'

Start-Process 'c:\layout\atualizarhorario.bat'

$User= $env:UserName
$Trigger= New-ScheduledTaskTrigger -AtLogon
$Action= New-ScheduledTaskAction -Execute 'c:\layout\atualizarhorario.bat' -WorkingDirectory 'c:\layout\'
Register-ScheduledTask -TaskName 'Atualizar Horario' -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force