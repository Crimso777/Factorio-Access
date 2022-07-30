#!/usr/bin/env python3
import pyautogui as gui
import time
import math
import os
import sys
import subprocess
import threading
import queue

import accessible_output2.outputs.auto
ao_output = accessible_output2.outputs.auto.Auto()

gui.FAILSAFE = False


FACTORIO_INSTALL_PATH = "./"
FACTORIO_BIN_PATH = FACTORIO_INSTALL_PATH+'bin/x64/factorio.exe'

if len(sys.argv) > 1 and os.path.exists(sys.argv[1]):
    os.chdir(os.path.dirname(sys.argv[0]))
    FACTORIO_BIN_PATH=sys.argv[1]


ao_output.output("Hello Factorio!", False)



def get_elapsed_time(t1):
    t2 = time.time()
    days = (t2-t1)/60/60/24
    if days >= 1:
        return str(math.floor(days)) + " days"
    hours = (t2-t1)/60/60
    if hours >= 1:
        return str(math.floor(hours)) + " hours"
    minutes = (t2-t1)/60
    if minutes >= 1:
        return str(math.floor(minutes)) + " minutes"
    return str(math.ceil(t2-t1)) + " seconds"


def getAffirmation():
    while True:
        i = input()
        if i == 'yes' or i == 'Yes' or i == 'YES' or i == 'y' or i == 'Y':
            return True
        elif i == 'no' or i == 'No' or i == 'n' or i == 'N' or i == 'NO':
            return False
        else:
            print("Invalid input, please type either Yes or No")


def getBoolean():
    while True:
        i = input()
        if i == 'true' or i == 'True' or i == 't' or i == 'T' or i == 'TRUE':
            return 'true'
        elif i == 'false' or i == 'False' or i == 'f' or i == 'F' or i == 'FALSE':
            return 'false'
        else:
            print("Invalid input, please type either true or false")


def getNum():
    while True:
        i = input()
        try:
            result = float(i)
            return str(result)
        except:
            print("Invalid input, please enter a number.\n")

def select_option(options,prompt='Select an option:',one_indexed=True):
    while True:
        print(prompt)
        for i, val in enumerate(options):
            print(i + one_indexed, ": ", val)    
        i=input()
        if not i.isdigit():
            print("Invalid input, please enter a number.")
            continue
        i=int(i)-one_indexed
        if i > len(options):
            print("Option too high, please enter a smaller number.")
            continue
        if i<0:
            print("Options start at 1. Please enter a larger number.")
            continue
        return i

def time_sort(file):
    return os.path.getmtime("saves/"+file)

def get_sorted_saves():
    try:
        l = os.listdir("saves")
        l.sort(reverse=True, key=time_sort)
        return l
    except:
        return []


def do_menu(branch, name, zero_item=("Back",0)):
    if callable(branch):
        return branch()
    keys=list(branch)
    if zero_item:
        keys = [zero_item[0]] + keys
        branch = branch.copy()
        branch[zero_item[0]]=zero_item[1]
    while True:
        opt = select_option(keys, prompt=f"{name}:", one_indexed= not zero_item)
        if zero_item and zero_item[1] == opt:
            return opt
        key = keys[opt]
        do_menu(branch[key],key)


def connect_to_address_menu():
    raise Exception("TODO")



def customMapSettings():
    print("Please enter a name for your new settings file:\n")
    i = input()
    result = i
    path = "Map Settings/Custom Settings/" + i
    if not os.path.exists(path):
        os.makedirs(path)
    with open(os.path.join(path, i+"MapGenSettings.json"), 'w') as fp:
        fp.write(
            """{\n  "_terrain_segmentation_comment": "The inverse of 'water scale' in the map generator GUI.",\n""")
        print("Enter a value for terrain segmentation.  \nIt represents the size of biomes, where 1.0 is default, 2.0 is twice as large .5 is half as large, et cetera.")
        i = getNum()
        fp.write('  "terrain_segmentation": ' + i + ',\n\n')
        fp.write("""  "_water_comment":
  [
    "The equivalent to 'water coverage' in the map generator GUI. Higher coverage means more water in larger oceans.",
    "Water level = 10 * log2(this value)"
  ],
""")
        print("Enter the value for water level.\nHigher values lead to larger and more frequentt oceans.\nThe default value is 1.0")
        i = getNum()
        fp.write('  "water": ' + i + ',\n\n')
        print(
            "Enter the maximum width of the map in tiles,\n0 is both infinite and default.")
        i = getNum()
        fp.write('  "width": ' + i + ',\n')
        print(
            "Enter the maximum height of the map in tiles,\n0 is both infinite and default.")
        i = getNum()
        fp.write('  "height": ' + i + ',\n\n')
        fp.write("""  "_starting_area_comment": "Multiplier for 'biter free zone radius'",
""")
        print("Enter a multiplier for the size of your starting zone.\nAgain, 2 would be 200%, 1 is 100% and default, and .5 is 50%")
        i = getNum()
        fp.write('  "starting_area": ' + i + ',\n')
        print("Enter either true or false, to indicate whether enemies are docile until attacked.  Default is false\n")
        i = getBoolean()
        fp.write('  "peaceful_mode": ' + i + ',\n\n')
        fp.write("""  "autoplace_controls":
  {
""")
        print("Enter the frequency of coal.  The default value is 1.0, and this value determines how often coal is encountered on the map.")
        i = getNum()
        print("Enter the size of coal.  The default value is 1.0, and this value determines how large a deposit of coal is when found on the map.")
        i1 = getNum()
        print("Enter the richness of coal.  The default value is 1.0, and this value determines how much coal is on a single tile when found on the map.")
        i2 = getNum()
        fp.write('    "coal": {"frequency": ' + i +
                 ', "size": ' + i1 + ', "richness": ' + i2 + '},\n')

        print("Enter the frequency of stone.The default value is 1.0, and this value determines how often stone is encountered on the map.")
        i = getNum()
        print("Enter the size of stone.  The default value is 1.0, and this value determines how large a deposit of stone is when found on the map.")
        i1 = getNum()
        print("Enter the richness of stone.  The default value is 1.0, and this value determines how much stone is on a single tile when found on the map.")
        i2 = getNum()
        fp.write('    "stone": {"frequency": ' + i +
                 ', "size": ' + i1 + ', "richness": ' + i2 + '},\n')

        print("Enter the frequency of copper.  The default value is 1.0, and this value determines how often copper is encountered on the map.")
        i = getNum()
        print("Enter the size of copper.  The default value is 1.0, and this value determines how large a deposit of copper is when found on the map.")
        i1 = getNum()
        print("Enter the richness of copper.  The default value is 1.0, and this value determines how much copper is on a single tile when found on the map.")
        i2 = getNum()
        fp.write('    "copper-ore": {"frequency": ' + i +
                 ', "size": ' + i1 + ', "richness": ' + i2 + '},\n')

        print("Enter the frequency of iron.  The default value is 1.0, and this value determines how often iron is encountered on the map.")
        i = getNum()
        print("Enter the size of iron.  The default value is 1.0, and this value determines how large a deposit of iron is when found on the map.")
        i1 = getNum()
        print("Enter the richness of iron.  The default value is 1.0, and this value determines how much iron is on a single tile when found on the map.")
        i2 = getNum()
        fp.write('    "iron-ore": {"frequency": ' + i +
                 ', "size": ' + i1 + ', "richness": ' + i2 + '},\n')

        print("Enter the frequency of uranium.  The default value is 1.0, and this value determines how often uranium is encountered on the map.")
        i = getNum()
        print("Enter the size of uranium.  The default value is 1.0, and this value determines how large a deposit of uranium is when found on the map.")
        i1 = getNum()
        print("Enter the richness of uranium.  The default value is 1.0, and this value determines how much uranium is on a single tile when found on the map.")
        i2 = getNum()
        fp.write('    "uranium-ore": {"frequency": ' + i +
                 ', "size": ' + i1 + ', "richness": ' + i2 + '},\n')

        print("Enter the frequency of oil.  The default value is 1.0, and this value determines how often oil is encountered on the map.")
        i = getNum()
        print("Enter the size of oil.  The default value is 1.0, and this value determines how large a deposit of oil is when found on the map.")
        i1 = getNum()
        print("Enter the richness of oil.  The default value is 1.0, and this value determines how much oil is on a single tile when found on the map.")
        i2 = getNum()
        fp.write('    "crude-oil": {"frequency": ' + i +
                 ', "size": ' + i1 + ', "richness": ' + i2 + '},\n')

        print("Enter the frequency of forests.  The default value is 1.0, and this value determines how often forests are encountered on the map.")
        i = getNum()
        print("Enter the size of forests.  The default value is 1.0, and this value determines how large a forest is when found on the map.")
        i1 = getNum()
        print("Enter the richness of forests.  The default value is 1.0, and this value determines how healthy forests are when found on the map.")
        i2 = getNum()
        fp.write('    "trees": {"frequency": ' + i +
                 ', "size": ' + i1 + ', "richness": ' + i2 + '},\n')

        print("Enter the frequency of enemy bases.  The default value is 1.0, and this value determines how often bases are encountered on the map.")
        i = getNum()
        print("Enter the size of enemy bases.  The default value is 1.0, and this value determines how large an enemy base is when found on the map.")
        i1 = getNum()
        print("Enter the density of enemy bases.  The default value is 1.0, and this value determines how many enemy buildings are in a single base when found on the map.")
        i2 = getNum()
        fp.write('    "enemy-base": {"frequency": ' + i +
                 ', "size": ' + i1 + ', "richness": ' + i2 + '}\n')

        fp.write("""  },

  "cliff_settings":
  {
    "_name_comment": "Name of the cliff prototype",
    "name": "cliff",

    "_cliff_elevation_0_comment": "Elevation of first row of cliffs",
""")

        print("Enter the elevation of the first row of any cliff.  As far as I can tell, this only has a visual effect, but the default is 10 if you want to play around with it.")
        i = getNum()
        fp.write('    "cliff_elevation_0": ' + i + ',\n\n')
        fp.write("""    "_cliff_elevation_interval_comment":
    [
      "Elevation difference between successive rows of cliffs.",
      "This is inversely proportional to 'frequency' in the map generation GUI. Specifically, when set from the GUI the value is 40 / frequency."
    ],
""")
        print("Enter the average distance between cliffs.  The default value is 40, so if you want twice as many cliffs enter 20 or half as many cliffs enter 80.")
        i = getNum()
        fp.write('    "cliff_elevation_interval": '+i+',\n')
        print("Enter cliff density.  The default value is 1, and it determines how porous cliffs are.  a value of 10 will cause there to be no breaks in the cliffs, while a value of 0 will not spawn any cliffs at all IE completely porous.")
        i = getNum()
        fp.write('    "richness": ' + i + '\n')
        fp.write("""  },

  "_property_expression_names_comment":
  [
    "Overrides for property value generators (map type)",
    "Leave 'elevation' blank to get 'normal' terrain.",
    "Use 'elevation': '0_16-elevation' to reproduce terrain from 0.16.",
    "Use 'elevation': '0_17-island' to get an island.",
    "Moisture and terrain type are also controlled via this.",
    "'control-setting:moisture:frequency:multiplier' is the inverse of the 'moisture scale' in the map generator GUI.",
    "'control-setting:moisture:bias' is the 'moisture bias' in the map generator GUI.",
    "'control-setting:aux:frequency:multiplier' is the inverse of the 'terrain type scale' in the map generator GUI.",
    "'control-setting:aux:bias' is the 'terrain type bias' in the map generator GUI."
  ],
  "property_expression_names":
  {
""")
        print("Do you want to select an island map?  This will mean that beyond a certain distance from your starting zone, the map is an endless ocean.\nPlease enter either yes or no.  No is the default.")
        if (getAffirmation()):
            fp.write('    "elevation": "0_17-island",\n')
        print("Enter the value for moisture frequency.")
        i = getNum()
        fp.write(
            '    "control-setting:moisture:frequency:multiplier": "' + i + '",\n')
        print("Enter the value for moisture bias")
        i = getNum()
        fp.write('    "control-setting:moisture:bias": "' + i + '",\n')
        print("Enter value for terrain generation type.")
        i = getNum()
        fp.write('    "control-setting:aux:frequency:multiplier": "'+i+'",\n')
        print("Enter value for terrain bias.")
        i = getNum()
        fp.write('    "control-setting:aux:bias": "'+i+'"\n')
        fp.write("""  },

  "starting_points":
  [
""")
        print("Enter the x coordinate position that you would like to start the game at.")
        i = getNum()
        print("Enter the y coordinate position you would like to start the game at.")
        i1 = getNum()
        fp.write('    { "x": '+i+', "y": '+i1+'}\n')
        fp.write("""  ],

  "_seed_comment": "Use null for a random seed, number for a specific seed.",
""")
        print("Would you like to provide a seed for the random number generator?Please enter yes or no.")
        if getAffirmation():
            print("Enter the value of your seed, results must be positive integers.")
            i = getNum()
        else:
            i = 'null'
        fp.write('  "seed": ' + i + '\n')
        fp.write("}\n")
#      pass
    try:
        proc = subprocess.run([FACTORIO_BIN_PATH, "--map-gen-settings", os.path.join(path, result+"MapGenSettings.json"), "--map-settings",
                              "Map Settings/PeacefulSettings.json", "--create", "Maps/"+result], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except:
        print("Error saving map, make sure the name is a valid filename for windows.")
    return result


def customMapList():
    command = -1
    while command == -1:
        print("Select custom settings:\n")
        print("0 : Create new settings")
        try:
            l = os.listdir("Map Settings/Custom Settings")
        except:
            l = []
        for i in range(len(l)):
            print(i+1, ": ", l[i][:])
        i = input()

        try:
            int(i)
        except:
            print("Invalid Command\n")
            continue
        if int(i) == 0:
            return customMapSettings()
        for k in range(len(l)):
            if int(i) == k+1:
                print("loading", l[k][:])
                proc = subprocess.run([FACTORIO_BIN_PATH, "--map-gen-settings", "Map Settings/Custom Settings/" + l[k] + "/mapGenSettings.json", "--map-settings",
                                      "Map Settings/Custom Settings/" + l[k] + "/mapSettings.json", "--create", "Maps/"+i1], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                command = k+1

def process_game_stdout(stdout):
    for line in iter(stdout.readline, b''):
        print(line)
        line = line.decode('utf-8').rstrip('\r\n')
        if len(line) > 5 and line[:3] == 'out':
            ao_output.output(line[4:], True)
        elif len(line) > 10 and line[:9] == 'setCursor':
            coordstring = line[10:].split(",")
            print(coordstring)
            coords = [int(coordstring[0]), int(coordstring[1])]
            print(coords)
            gui.moveTo(coords[0], coords[1], _pause=False)
        elif len(line) > 16 and line[-15:] == "Saving finished":
          ao_output.output("Saving Complete", True)
        elif len(line) >= 10 and line[:10] == "time start":
          debug_time = time.time
        elif len(line) >= 9 and line[:9] == "time start":
          print(time.time - debug_time)
        elif len(line) > 8 and line[-7:] == "Goodbye":
            break

def save_game_rename():
    l = get_sorted_saves()

    if len(l) == 0:
        print("Make sure to save your game next time!")
    else:
        print("Would you like to name your last save?  You saved " +
              get_elapsed_time(os.path.getmtime("saves/"+l[0])) + " ago")
        if getAffirmation():
            print("Enter a name for your save file:")
            newName = input()
            check = False
            while check == False:
                try:
                    testFile = open(newName + ".test", "w")
                    testFile.close()
                    os.remove(newName + ".test")
                    check = True
                except:
                    print("Invalid file name, please try again.")
                    newName = input()

            dst = "saves/" + newName + ".zip"
            src = "saves/" + l[0]
            try:
                os.rename(src, dst)
            except:
                os.remove(dst)
                os.rename(src, dst)

def connect_to_address_menu():
    address = input("Enter the address to connect to:\n")
    connect_to_address(address)
def connect_to_address(address):
    launch_with_params(["--mp-connect",address])

def launch(path):
    launch_with_params(["--load-game", path])
    save_game_rename()
def launch_with_params(params):
    params = [
        FACTORIO_BIN_PATH, 
        "--config", "config/config.ini",
        "--mod-directory", "mods",
        "--fullscreen", "TRUE"] + params
    try:
        print("Launching")
        proc = subprocess.Popen(params , stdout=subprocess.PIPE)
        threading.Thread(target=process_game_stdout, args=(proc.stdout,), daemon=True).start()
        proc.wait()
    except Exception as e:
        print("error running game")
        raise e
    


def newGame():
    opts = ["Back","Create new map"] + [game[:-4] for game in os.listdir("Maps")]
    opt = select_option(opts,"Select a map:",False)
    if opt == 0:
        return
    if opt == 1:
        return chooseDifficulty()
    load_map=opts[opt]
    print("loading", load_map[:-4])
    return launch("Maps/"+load_map)


def chooseDifficulty():
    command = 0
    types={
        "Compass Valley":"CompassValleySettings.json",
        "Peaceful":"PeacefulSettings.json",
        "Easy":"PeacefulSettings.json",
        "Normal":"PeacefulSettings.json",
        "Hard":"PeacefulSettings.json",
        "Custom":False,
    }
    opts = ["Back"] + list(types)
    opt = select_option(opts,"Select type of map:",False)
    if opt == 0:
        return 0
    key = opts[opt]
    if types[key]:
        while True:
            name = input("Please enter a name for your new map:\n")
            try:
                proc = subprocess.run([FACTORIO_BIN_PATH, "--map-gen-settings", f"Map Settings/gen/{key}Map.json", "--map-settings",
                              "Map Settings/"+types[key], "--create", "Maps/"+name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            except:
                print("Error saving map, make sure the name is a valid filename for windows.")
                continue
            break
    else:
        name = customMapList()
        print("Creating Custom game...")
    return launch("Maps/"+name+".zip")
    


def loadGame():
    l = get_sorted_saves()
    opts = ["Back"] + [save[:-4] + " " + get_elapsed_time(os.path.getmtime("saves/" + save)) + " ago" for save in l]
    opt = select_option(opts,"Select a map:",False)
    if opt == 0:
        return 0
    return launch(l[opt-1])
    
def time_to_exit():
    ao_output.output("Goodbye Factorio", False)
    exit(0)
    
    
menu = {
    "Single Player":{
        "New Game" : newGame,
        "Load Game" : loadGame,
        },
    "Multiplayer":{
        "Connect to Address": connect_to_address_menu,
        },
    "Quit": time_to_exit
    }

do_menu(menu,"Main Menu",False)