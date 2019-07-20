# Script para instalação do Chocolatey/Boxstarter
# Para gerar o instalador:
# pip install pyinstaller
# pyinstaller --icon=box.ico -F instalador.py
# Link para o executavel final: bit.ly/instalador1

import winreg, os, time
from colorama import init, deinit, Fore

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

def deletarIcones():
	executarComando(r'del "C:\Users\Public\Desktop\Boxstarter Shell.lnk"')
	executarComando(r'del "C:\Users\Public\Desktop\Microsoft Edge.lnk"')
	executarComando(r'del "%USERPROFILE%\Desktop\Microsoft Edge.lnk"')

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

def removerApps():
	caminho = criarTempFile('.ps1', 'https://pastebin.com/raw/xdjMmWi1', r'c:\layout', True)

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
	executarComando('@powershell -NoProfile -ExecutionPolicy bypass -command "Import-Module ''C:/ProgramData/Boxstarter/Boxstarter.Chocolatey/Boxstarter.Chocolatey.psd1''; Invoke-ChocolateyBoxstarter -NoPassword -DisableRestart; Install-BoxstarterPackage -PackageName https://pastebin.com/raw/Eqp09mjj -DisableReboots"')

	print(Fore.GREEN + '***configurando barra de tarefas***')
	removerApps()
	time.sleep(10)
	deletarIcones()
	time.sleep(10)
	print(Fore.GREEN + '***Removendo OneDrive***')
	removerOneDrive()
	time.sleep(10)
	
if __name__ == "__main__":
	init()
	instalar()
	deinit()