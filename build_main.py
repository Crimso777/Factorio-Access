import os
import sys

venv = 'venv'

venv_python = './' + venv

if sys.platform == 'win32':
	venv_python += '/Scripts/python3.exe'
else:
	venv_python += '/bin/python3'

if not os.path.isdir('./'+venv):
	os.system(sys.executable+' -m venv '+venv)
	os.system(venv_python+' -m pip install -r requirements.txt pyinstaller')

if os.path.isfile('main.spec'):
	os.system(venv_python+' -m PyInstaller main.spec')
else:
	os.system(venv_python+' -m PyInstaller --onefile --hidden-import=espeak --hidden-import=python_espeak-0.5.egg-info --hidden-import=speechd_config --hidden-import=speechd main.py')
