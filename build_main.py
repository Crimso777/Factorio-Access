import os
import sys
print("test")
venv = 'venv'

venv_python = os.path.join('.', venv)

if sys.platform == 'win32':
    venv_python += '\Scripts\python.exe'
else:
    venv_python += '/bin/python3'

print(venv_python)

linux_hidden_modules=['espeak','python_espeak-0.5.egg-info','speechd_config','speechd']
system_packages="/usr/lib/python3/dist-packages/"
hidden_imports=[]

if not os.path.isdir('./'+venv):
    print('"'+sys.executable+'" -m venv '+venv)
    os.system('"'+sys.executable+'" -m venv '+venv)
    print(venv_python)
    os.system(venv_python+' -m pip install -r requirements.txt pyinstaller')
    if sys.platform == 'linux':
        full_paths=' '.join([system_packages+mod for mod in linux_hidden_modules])
        copy_cmd="cp -r "+full_paths+' ./'+venv+'/lib/python3.8/site-packages/'
        print(copy_cmd)
        os.system(copy_cmd)
        hidden_imports+=linux_hidden_modules
        

if os.path.isfile('main.spec'):
    os.system(venv_python+' -m PyInstaller main.spec')
else:
    hi="".join([' --hidden-import='+imp for imp in hidden_imports])
    os.system(venv_python+' -m PyInstaller --onefile'+hi+' main.py')
