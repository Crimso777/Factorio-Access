# Welcome to Factorio Access!

This is an accessibility mod for the popular game Factorio.  The goal of this mod is to make the game completely accessible to the blind and visually impaired.

This "read me" file covers the basics of the mod, which include the installation guide, the mod controls, the FAQ and links to other information sources.


# Installing Factorio and Factorio Access

To install the full version, follow the instructions below for the .zip file install.

To update to the most recent patch, follow the instructions below for the patch install.

Note:  If you have done a full installation using the .zip instructions, there is no need to follow the patch install directions until a new patch comes out.  

## Mod .zip file install

1. Download "Factorio Access.zip"
2. Open the .zip file and copy its contents
3. Navigate to the folder you have Factorio installed.  It should already contain a /bin folder, a /data folder, etc.  
4. Paste the files into your factorio folder
5. That's it!  You are now ready to run launcher.exe in administrator mode
6. If you are a jaws user, you may want to copy Factorio.jkm from the .zip into your JAWS settings folder, found in your user's AppData folder. An example file path is `C:\Users\Crimso\AppData\Roaming\Freedom Scientific\JAWS\2022\Settings\enu\`



## Mod patch install

1. Download control.lua, data.lua, and config.ini 
2. Navigate to your Factorio folder
3. Go to mods/FactorioAccess_0.0.1
4. Paste both control.lua and data.lua in this folder
5. Navigate back to your Factorio folder
6. Go to the config folder
7. Paste config.ini into this folder
8. All done! You can now run launcher.exe in administrator mode to play the game with the new patch


# Mod controls

## Movement

Movement: W A S D

Note: When you change direction, your character doesn't immediately move a tile in that direction.  Think of it like turning your head before taking a step.

Change movement mode: CONTROL + W

Note the 3 movement types are as follows:

   1- Telestep: Press a direction to turn in that direction, then continue pressing in that direction to move.

   2- Step-By-Walk:  This mode is similar to Telestep, however the player character will physically take steps in the direction chosen.  The biggest difference is footsteps.

   3- Smooth-Walking: In this mode the character will move similarly to in a sighted game. The player will be notified if they run into something, but otherwise will not be notified of entities they are passing. Very fast, and great for getting around!

## Interactions

Mine: X

Open inventory: E

Rotate: R

Note: If you have something in your hand, you will rotate that.  Otherwise you will rotate the building your cursor is over.

Additional Note: The first time you press the rotate key, it will simply say the direction a building is facing. Subsequent presses will actually rotate the building.

Place building: OPEN SQUARE BRACKET

Open building's menu: OPEN SQUARE BRACKET

Nudge building by one tile: CONTROL + SHIFT + DIRECTION, where the direction is one of W A S D.


## Cursor

Speak cursor coordinates: K

Cursor mode: I

Increase cursor size: CONTROL + I

Decrease cursor size: CONTROL + SHIFT + I

Note: You must be in cursor mode for the size of the cursor to make any difference.

Jump cursor to character: J

Teleport player to cursor: SHIFT + T


## Scanning

Scan for nearby entities: END

Navigate scanned entity list: PAGE UP and PAGE DOWN

Change scanned category: CONTROL + PAGE UP and CONTROL + PAGE DOWN

Change Sorting mode for scanned list: SHIFT + PAGE UP and SHIFT + PAGE DOWN

Repeat scanned entry: HOME

Move cursor to scanned target: CONTROL + HOME

note: If you are not in cursor mode, this will simply teleport the player to the nearest position to the target.

## Fast Travel

Open Fast Travel Menu: V

Select a fast travel point:  W and S

Select an option: A and D

Confirm an option: LEFT BRACKET

Note:  Options include Teleporting to a saved point, renaming a saved point, deleting a saved point, and creating a new point.

## BStride

Travel freely from building to building as if they were laid out in a grid pattern.

Open the BStride menu with CONTROL + S, and explore your factory with the following controls:

First, select a direction using WASD

Next navigate the list of adjacent buildings with the two perpendicular directions.  For instance, if you are going North, then use the A and D keys to select a building from the list.

Last, confirm your selection by pressing the direction you started with.  For instance, if I wanted to go to the 2nd item in the northern list I would hit W to go north, D to select option 2, and W again to confirm.

Once you find your target, press LEFT BRACKET to teleport your character to the building.

## Warnings

Warnings Menu: P

Navigate woarnings menu:    WASD to navigate a single range

Switch Range: TAB

Teleport cursor to Building with warning: LEFT BRACKET

Close Warnings menu: E


## Others

Time of day and current research: T

Save game: F1

Set quickbar #: CONTROL + Any number

Quickbar: Any number

Recalibrate: CONTROL + END

Note: If you zoom in and out frequently, you should also recalibrate in order for certain actions like mining and opening buildings to work.


## While in a menu

Note: Many functions are implemented only in the inventory screen, such as shift tab and item information.  Soon these features will be in building menus, but for now it is expected behavior.

Change tabs within a menu: TAB and SHIFT + TAB

Select Item: OPEN SQUARE BRACKET

Item information: L

Coordinates of current inventory slot: K

Smart Insert/Smart Withdrawal: SHIFT + OPEN SQUARE BRACKET

Note: This will insert an item stack, or withdraw an item stack from a building. It is smart because it will decide the proper inventory to send the item to.  For instance, smart inserting coal into a furnace will attempt to put it in the fuel category, as opposed to the input category.


### Crafting

Crafting components required: K

Craft 1 item: OPEN SQUARE BRACKET

Craft 5 items: CLOSE SQUARE BRACKET

Craft as many items as possible:  SHIFT + OPEN SQUARE BRACKET

Unqueue 1 item: OPEN SQUARE BRACKET

Unqueue 5 items: CLOSE SQUARE BRACKET

Unqueue all items: SHIFT + OPEN SQUARE BRACKET



## In item selector

Select category: OPEN SQUARE BRACKET or S

Jump to previous category level: W

Select category from currently selected tier: A and D



# FAQ:

Q: Does this mod work with the steam version?

A:  Not yet, however if you buy the game on steam you can use your product key to redeem the standalone version on factorio.com



Q: Does this mod work with the demo?

A:  No, in fact no mods work with the demo.



Q:  Can this mod run the tutorial?

A:  Not yet.  There are plans to create a custom tutorial, and to make the built in tutorial accessible, but these things are still at least a week away.



Q:  My game crashed, what gives?

A:  This mod is currently still in early access.  Bugs are normal and expectted.  Please post about it in the issues channel of Discord.



Q:  Do I have to pay to use the mod?

A:  The mod is and always will be free.  The game itself costs $30 on [Factorio.com](www.factorio.com)


# Help and Support

If your question wasn't answered here, please check out our [Discord server](https://discord.gg/CC4QA6KtzP), and ask your question there.

For information about the game, such as the resources, machines, and systems, please check out the [Factorio Access Wiki](https://github.com/Crimso777/Factorio-Access/wiki).

If you want to help others or discuss the development of the mod or the wiki, feel free to again join us at the [Discord server](https://discord.gg/CC4QA6KtzP).


# Changes

An updated changelog can be found [here](https://github.com/Crimso777/Factorio-Access/blob/main/CHANGES.md)



# Donations

While this mod is completely free for all, I am a full time student working on this mod in my free time, thus any and all support is greatly appreciated.

If you are so inclined, you can donate at my [Patreon](https://www.patreon.com/Crimso777)


