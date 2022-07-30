import zipfile
import os
import json

with open("./mods/FactorioAccess/info.json") as fp:
    info = json.load(fp)
release = info["version"].replace(".","_")

filename = f"FactorioAccess_{release}.zip"

def add_to_zip(zipfp,path,prefix=""):
    #print('attempting to add', path)
    if os.path.isfile(path):
        zipfp.write(path,os.path.join(prefix,path))
    elif os.path.isdir(path):
        for sub_path in os.listdir(path):
            add_to_zip(zipfp,os.path.join(path,sub_path),prefix)

with zipfile.ZipFile(filename, mode='w') as zipfp:
    add_to_zip(zipfp,'mods')
    add_to_zip(zipfp,'config/config.ini')
    add_to_zip(zipfp,'Map Settings')
    add_to_zip(zipfp,'Changes.md')
    add_to_zip(zipfp,'Factorio.jkm')
    add_to_zip(zipfp,'launcher.exe')
    add_to_zip(zipfp,'LICENSE')
    add_to_zip(zipfp,'README.md')    
    add_to_zip(zipfp,'nvdaControllerClient64.dll')    
    add_to_zip(zipfp,'SAAPI64.dll')    

input("Release Genreated as "+filename)
