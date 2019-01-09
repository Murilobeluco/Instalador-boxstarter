# Script para instalação do Chocolatey/Boxstarter
# Para gerar o instalador:
# pip install pyinstaller
# pyinstaller --icon=box.ico -F instalador.py
# Link para o executavel final: bit.ly/instalador1

import winreg, os, time
from colorama import init, deinit, Fore, Back, Style

def executarComando(comando):
	import subprocess
	
	print("Executando o comando: '{}'".format(comando), flush=True)
	subprocess.call(comando, shell=True)

def abrirLink(url=''):
	import urllib.request

	comando = urllib.request.urlopen(url)
	
	return comando

def reiniciarExplorer():
	executarComando('taskkill /f /IM explorer.exe')
	time.sleep(20)
	executarComando('start explorer.exe')	

def tratarComando(comando):
	return comando.decode('utf-8').replace('\n', ' ').replace('\r', '')

def mudarValorRegistro(keyval, escopo, nomeChave, tipo, valor):
	try:
		key = winreg.OpenKey(escopo, keyval, 0, winreg.KEY_ALL_ACCESS)	
	except Exception:
		key = winreg.CreateKey(escopo, keyval)

	winreg.SetValueEx(key, nomeChave, 0, tipo, valor)

	winreg.CloseKey(key)

def configurarBarra():
	mudarValorRegistro(r'SOFTWARE\Microsoft\Windows\CurrentVersion\Search', winreg.HKEY_CURRENT_USER, 'SearchboxTaskbarMode', winreg.REG_DWORD, 0) 
	mudarValorRegistro(r'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People', winreg.HKEY_CURRENT_USER, 'PeopleBand', winreg.REG_DWORD, 0) 
	mudarValorRegistro(r'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced', winreg.HKEY_CURRENT_USER, 'ShowTaskViewButton', winreg.REG_DWORD, 0)
	mudarValorRegistro(r'SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager', winreg.HKEY_CURRENT_USER, 'SystemPaneSuggestionsEnabled', winreg.REG_DWORD, 0)
	mudarValorRegistro(r'SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager', winreg.HKEY_CURRENT_USER, 'SubscribedContent-338388Enabled', winreg.REG_DWORD, 0)
	mudarValorRegistro(r'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced', winreg.HKEY_CURRENT_USER, 'LaunchTo', winreg.REG_DWORD, 1)
	mudarValorRegistro(r'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced', winreg.HKEY_CURRENT_USER, 'Start_TrackProgs', winreg.REG_DWORD, 0)
	mudarValorRegistro(r'Software\Policies\Microsoft\Windows\Explorer', winreg.HKEY_LOCAL_MACHINE, 'HideRecentlyAddedApps', winreg.REG_DWORD, 1)
	mudarValorRegistro(r'Software\Policies\Microsoft\Windows\OneDrive', winreg.HKEY_LOCAL_MACHINE, 'DisableFileSyncNGSC', winreg.REG_DWORD, 1)
	mudarValorRegistro(r'Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel', winreg.HKEY_CURRENT_USER, '{20D04FE0-3AEA-1069-A2D8-08002B30309D}', winreg.REG_DWORD, 0)
	mudarValorRegistro(r'Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu', winreg.HKEY_CURRENT_USER, '{20D04FE0-3AEA-1069-A2D8-08002B30309D}', winreg.REG_DWORD, 0)
	mudarValorRegistro(r'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced', winreg.HKEY_CURRENT_USER, 'TaskbarSmallIcons', winreg.REG_DWORD, 0)
	mudarValorRegistro(r'SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop', winreg.HKEY_CURRENT_USER, 'IconSize', winreg.REG_DWORD, 32)
	mudarValorRegistro(r'SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop', winreg.HKEY_CURRENT_USER, 'Mode', winreg.REG_DWORD, 1)
	mudarValorRegistro(r'SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop', winreg.HKEY_CURRENT_USER, 'LogicalViewMode', winreg.REG_DWORD, 3)
	mudarValorRegistro(r'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced', winreg.HKEY_CURRENT_USER, 'Start_TrackDocs', winreg.REG_DWORD, 0)
	mudarValorRegistro(r'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer', winreg.HKEY_CURRENT_USER, 'NoRecentDocsHistory', winreg.REG_DWORD, 1)	

	executarComando(r'del "C:\Users\Public\Desktop\Boxstarter Shell.lnk"')
	executarComando(r'del "C:\Users\Public\Desktop\Microsoft Edge.lnk"')
	executarComando(r'del "%USERPROFILE%\Desktop\Microsoft Edge.lnk"')
	
	reiniciarExplorer()

def criarTempFile(sufixo, url, caminho=None, oculto=False):
	import tempfile

	if caminho is not None:
		if not os.path.exists(caminho):
			os.mkdir(caminho)
			if (oculto):
				os.popen('attrib +h '+ str(caminho))	

	tempFile, tempPath = tempfile.mkstemp(suffix=sufixo, dir=caminho, text=True)

	comando = abrirLink(url)

	with open(tempPath, mode='w', encoding="utf-8") as f:
		for linhas in comando:
			f.write(str(linhas.decode("utf-8")))
	
	os.close(tempFile)

	return tempPath

def limparIconesMenuIniciar():
	caminho = criarTempFile('.xml', 'https://pastebin.com/raw/Rag0n8dQ', r'c:\layout', True)
	
	mudarValorRegistro(r'Software\Policies\Microsoft\Windows\Explorer', winreg.HKEY_LOCAL_MACHINE, 'LockedStartLayout', winreg.REG_DWORD, 1)
	mudarValorRegistro(r'Software\Policies\Microsoft\Windows\Explorer', winreg.HKEY_LOCAL_MACHINE, 'StartLayoutFile', winreg.REG_EXPAND_SZ, str(caminho))
	executarComando('gpupdate /force')
	reiniciarExplorer()
	time.sleep(30)
	mudarValorRegistro(r'Software\Policies\Microsoft\Windows\Explorer', winreg.HKEY_LOCAL_MACHINE, 'LockedStartLayout', winreg.REG_DWORD, 0)
	mudarValorRegistro(r'Software\Policies\Microsoft\Windows\Explorer', winreg.HKEY_LOCAL_MACHINE, 'StartLayoutFile', winreg.REG_EXPAND_SZ, r'')
	reiniciarExplorer()

def executarArquivo():
	caminho = criarTempFile('.ps1', 'https://pastebin.com/raw/xdjMmWi1')

	executarComando('@powershell -NoProfile -ExecutionPolicy bypass -File ' + str(caminho))

	os.remove(caminho)

def removerOneDrive():
	executarComando('taskkill /f /im OneDrive.exe')	
	executarComando(r'%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall')
	executarComando(r"rd %UserProfile%\OneDrive /Q /S")
	executarComando(r"rd C:\OneDriveTemp /Q /S")
	executarComando(r"REG Delete HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6} /f")
	executarComando(r"REG Delete HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6} /f")

def instalar():
	executarComando('@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString(' + "'https://boxstarter.org/bootstrapper.ps1'" + ')); get-boxstarter -Force " ')
	time.sleep(10)
	executarComando('@powershell -NoProfile -ExecutionPolicy bypass -command "Import-Module ''C:/ProgramData/Boxstarter/Boxstarter.Chocolatey/Boxstarter.Chocolatey.psd1''; Invoke-ChocolateyBoxstarter; Install-BoxstarterPackage -PackageName https://pastebin.com/raw/Eqp09mjj -DisableReboots"')

	print(Fore.GREEN + '***configurando barra de tarefas***')
	executarArquivo()
	time.sleep(10)
	configurarBarra()
	time.sleep(10)
	print(Fore.GREEN + '***Removendo OneDrive***')
	removerOneDrive()
	time.sleep(10)
	print(Fore.GREEN + '***Removendo icones do menu iniciar***')
	limparIconesMenuIniciar()
	time.sleep(10)
	
if __name__ == "__main__":
	init()
	instalar()
	deinit()