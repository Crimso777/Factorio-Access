import os
import sys
import re
import __main__


if getattr(sys, 'frozen', False):
    MY_BIN = sys.executable
else:
    MY_BIN = __main__.__file__

MY_CONFIG_DIR = os.path.dirname(MY_BIN)
    

MAC="Darwin"
WIN="win32"
LIN="linux"

WRITE_DATA_MAP={
    MAC:'~/Library/Application Support/factorio',
    WIN:'%appdata%\Factorio',
    LIN:'~/.factorio'
}

BIN=''
if len(sys.argv) > 1 and os.path.isfile(sys.argv[1]):
    BIN=sys.argv[1]
else:
    exe_map = {
        WIN:[
            "./bin/x64/factorio.exe",
            r"C:\Program Files\Factorio\bin\x64\factorio.exe",
            r'C:\Program Files (x86)\Steam\steamapps\common\Factorio\bin\x64\factorio.exe'
            ],
        MAC:[
            "/Applications/factorio.app/Contents/MacOS/factorio",
            '~/Library/Application Support/Steam/steamapps/common/Factorio/factorio.app/Contents/MacOS/factorio'
            ],
        LIN:[
            "./bin/x64/factorio",
            r'~/.steam/root/steam/steamapps/common/Factorio/bin/x64/factorio'
            ]
        }
    for path in exe_map[sys.platform]:
        if os.path.isfile(path):
            BIN = os.path.abspath(path)
            break
    if BIN.find('steam') >= 0:
        print("Looks like you have a steam installed version of factorio. Please launch through steam after updating it's command line parameters to the following:")
        print('"' + os.path.abspath(MY_BIN) + '" %command%')
        exit(1)
if not BIN:
    print("Could not find factorio would you like to install?")
    exit(1)

factorio_replacements={
    '__PATH__system-write-data__':os.path.expandvars(WRITE_DATA_MAP[sys.platform]),
    '__PATH__executable__': os.path.dirname(BIN)
    }

def proccess(path):
    for k,v in factorio_replacements.items():
        path = path.replace(k,v)
    path = os.path.abspath(path)
    return path

config_path='config/config.ini'

configs=[]
if len(sys.argv) > 2 and os.path.isfile(sys.argv[2]):
    configs.append(sys.argv[2])
    
configs.append("./"+config_path)

#try to append another config path from config-path.cfg
try:
    fp=open(proccess('__PATH__executable__/../../config-path.cfg'))
except FileNotFoundError:
    pass
else:
    with fp:
        for line in fp:
            match = re.fullmatch(r'config-path=([^\r\n]*)',line)
            if match:
                configs.append(proccess(match.group(1)))
                break
#last ditch config path
configs.append(proccess(os.path.join('__PATH__system-write-data__',config_path)))

CONFIG=''
WRITE_DIR=''
for path in configs:
    try:
        fp=open(path)
    except FileNotFoundError:
        pass
    else:
        CONFIG=path
        with fp:
            for line in fp:
                match = re.match(r'write-data=([^\r\n]*)',line)
                if match:
                    WRITE_DIR = proccess(match.group(1))
                    break
        break

if not CONFIG:
    print("Unable to find factorio config")
    exit(1)
if not WRITE_DIR:
    print("Unable to find factorio write directory")
    exit(1)
    
MODS=os.path.join(WRITE_DIR,'mods')
SAVES=os.path.join(WRITE_DIR,'saves')
