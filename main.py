#!/usr/bin/env python3
import pyautogui as gui
#import cytolk.tolk as tolk
import time
import math
import os
import sys
import subprocess
import threading
import queue

import accessible_output2.outputs.auto
tolk = accessible_output2.outputs.auto.Auto()

gui.FAILSAFE = False

def show_exception_and_exit(exc_type, exc_value, tb):
    import traceback
    traceback.print_exception(exc_type, exc_value, tb)
    raw_input("Press key to exit.")
    sys.exit(-1)

sys.excepthook = show_exception_and_exit

FACTORIO_INSTALL_PATH = "./"
FACTORIO_BIN_PATH = FACTORIO_INSTALL_PATH+'bin/x64/factorio.exe'

if len(sys.argv) > 1 and os.path.exists(sys.argv[1]):
    os.chdir(os.path.dirname(sys.argv[0]))
    FACTORIO_BIN_PATH=sys.argv[1]


#tolk.load()

tolk.output("Hello Factorio!", False)


def enqueue_output(out, queue):
    for line in iter(out.readline, b''):
        queue.put(line)
    out.close()


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


def launch(path):
    try:
        #      return 0
        print("Launching")
        return subprocess.Popen([FACTORIO_BIN_PATH, "--load-game", path, "--fullscreen", "TRUE", "--config", "config/config.ini", "--mod-directory", "mods"], stdout=subprocess.PIPE)
    except:
        print("error launching game")


def newGame():
    command = -1
    while command == -1:
        print("Select a map:\n")
        print("0 : Create new map")
        try:
            l = os.listdir("Maps")
        except:
            l = []
        for i in range(len(l)):
            print(i+1, ": ", l[i][:-4])
        i = input()

        try:
            int(i)
        except:
            print("Invalid Command\n")
            continue
        if int(i) == 0:
            return chooseDifficulty()
            command = 0
        for k in range(len(l)):
            if int(i) == k+1:
                print("loading", l[k][:-4])
                return launch("Maps/"+l[k])
                command = k+1


def chooseDifficulty():
    command = 0
    while command == 0:
        print("Select type of map:\n1: Peaceful\n2: Easy\n3: Normal\n4: Hard\n5: Custom\n")
        i = input()

        try:
            int(i)
        except:
            print("Invalid Command\n")
            continue
        if int(i) == 1:
            print("Please enter a name for your new map:\n")
            i1 = input()
            try:
                proc = subprocess.run([FACTORIO_BIN_PATH, "--map-gen-settings", "Map Settings/gen/PeacefulMap.json", "--map-settings",
                                      "Map Settings/PeacefulSettings.json", "--create", "Maps/"+i1], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            except:
                print(
                    "Error saving map, make sure the name is a valid filename for windows.")
                continue
            command = 1
        elif int(i) == 2:
            print("Please enter a name for your new map:\n")
            i1 = input()
            try:
                proc = subprocess.run([FACTORIO_BIN_PATH, "--map-gen-settings", "Map Settings/gen/EasyMap.json", "--map-settings",
                                      "Map Settings/PeacefulSettings.json", "--create", "Maps/"+i1], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            except:
                print(
                    "Error saving map, make sure the name is a valid filename for windows.")
                continue
            command = 2
        elif int(i) == 3:
            print("Please enter a name for your new map:\n")
            i1 = input()
            try:
                proc = subprocess.run([FACTORIO_BIN_PATH, "--map-gen-settings", "Map Settings/gen/NormalMap.json", "--map-settings",
                                      "Map Settings/PeacefulSettings.json", "--create", "Maps/"+i1], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            except:
                print(
                    "Error saving map, make sure the name is a valid filename for windows.")
                continue

            command = 3
        elif int(i) == 4:
            print("Please enter a name for your new map:\n")
            i1 = input()
            try:
                proc = subprocess.run([FACTORIO_BIN_PATH, "--map-gen-settings", "Map Settings/gen/HardMap.json", "--map-settings",
                                      "Map Settings/PeacefulSettings.json", "--create", "Maps/"+i1], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            except:
                print(
                    "Error saving map, make sure the name is a valid filename for windows.")
                continue
            command = 4
        elif int(i) == 5:
            i1 = customMapList()
            command = 5

            print("Creating Custom game...")
    return launch("Maps/"+i1+".zip")
#   return command


def loadGame():
    command = -1
    while command == -1:
        print("Select a map:\n")
        print("0 : Back")
        try:
            l = os.listdir("saves")

            def time_sort(file):
                return os.path.getmtime("saves/"+file)
            l.sort(reverse=True, key=time_sort)

        except:
            l = []

        for i in range(len(l)):
            print(i+1, ": ", l[i][:-4] + " " +
                  get_elapsed_time(os.path.getmtime("saves/" + l[i])) + " ago")
        i = input()

        try:
            int(i)
        except:
            print("Invalid Command\n")
            continue
        if int(i) == 0:
            return 0
        for k in range(len(l)):
            if int(i) == k+1:
                return launch(l[k])

                command = k+1


command = 0
while command == 0:
    print("Enter 1 to start a new game, or 2 to load an existing one.\n")
    i = input()

    try:
        int(i)
    except:
        print("Invalid Command\n")
        continue
    if int(i) == 1:
        command = 1
        proc = newGame()
    elif int(i) == 2:
        proc = loadGame()
        if proc != 0:
          command = 2

    else:
        print("Invalid Command\n")
game_res = {"x": 0, "y": 0}
#time.sleep(20)
exit = False
debug_time = 0

# autoit.win_activate("FactorioAccess")

q = queue.Queue()
t = threading.Thread(target=enqueue_output, args=(proc.stdout, q))
t.daemon = True  # thread dies with the program
t.start()


while not exit:
    # read line without blocking
    try:
        line = q.get_nowait()  # or q.get(timeout=.1)
        print(line)
        line = line.decode('utf-8').rstrip('\r\n')
    except queue.Empty:
        #      print('no output yet')
        pass
    else:
        if len(line) > 5 and line[:3] == 'out':
            tolk.output(line[4:], True)
        elif len(line) > 5 and line[:4] == 'resx':
            game_res["x"] = int(line[5:])
        elif len(line) > 5 and line[:4] == 'resy':
            game_res["y"] = int(line[5:])
        elif len(line) > 10 and line[:9] == 'setCursor':
            coordstring = line[10:].split(",")
            print(coordstring)
            coords = [int(coordstring[0]), int(coordstring[1])]
            print(coords)
            gui.moveTo(coords[0], coords[1], _pause=False)
        elif len(line) > 16 and line[-15:] == "Saving finished":
          tolk.output("Saving Complete", True)
        elif len(line) >= 10 and line[:10] == "time start":
          debug_time = time.time
        elif len(line) >= 9 and line[:9] == "time start":
          print(time.time - debug_time)
        elif len(line) > 8 and line[-9:-2] == "Goodbye":
            exit = True
try:
    l = os.listdir("saves")

    def time_sort(file):
        return os.path.getmtime("saves/"+file)
    l.sort(reverse=True, key=time_sort)

except:
    l = []

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

tolk.output("Goodbye Factorio", False)
tolk.unload()
