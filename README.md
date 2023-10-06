# Welcome to Factorio Access BETA!

This is the BETA VERSION for an accessibility mod for the popular game Factorio.  The goal of this mod is to make the game completely accessible to the blind and visually impaired. This beta version includes the latest additions to the main mod and updated documentation files to match. Meanwhile the Mod Wiki remains on the main version's page. As a beta, this version may have a few more bugs and changes.

This "read me" file covers the basics of the mod, which include the installation guide, the mod controls, the FAQ and links to other information sources.

# Installing Factorio

The game can be purchased from Factorio.com or from Steam.

After purchase, you can create an account or log in at Factorio.com. 

If you have a steam key, you can have it connected with your account, or you can log in with Steam directly.

From Factorio.com, either from the main page or the downloads page, you can download the latest stable release.

# Installing Factorio Access

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
   
   

# Factorio Access Controls

## General

Time of day and current research: T

Save game: F1

Recalibrate: CONTROL + END

Pause or unpause the game with the visual pause menu: ESC
  
Pause or unpause the game with no menu: SHIFT + SPACE

## Movement

Movement: W A S D

Note: When you change direction, for the first key press, your character turns but does not take a step in that direction.

Change movement mode: CONTROL + W

Note the 3 movement types are as follows:

   1- Telestep: Press a direction to turn in that direction, then continue pressing in that direction to move.

   2- Step-By-Walk:  Temporarily removed. This mode is similar to Telestep, however the player character will physically take steps in the direction chosen.  The biggest difference is footsteps.

   3- Smooth-Walking: In this mode the character will move similarly to in a sighted game. The player will be notified if they run into something, but otherwise will not be notified of entities they are passing. Very fast, and great for getting around!

## Interactions

Get entity description: L, for most entities such as buildings

Read building status: RIGHT BRACKET, for applicable buildings when your hand is empty

Open building's menu: LEFT BRACKET

Mine or pick up: X

Mine or pick up a group: SHIFT + X. Applies only to some groups such as trees or rails.

Grab in hand instant mining tool: CONTROL + X. Also known as the cut and paste tool, this will instantly mine almost anything touched by the cursor. Does not work for ores.
  
Put away instant mining tool: SHIFT + Q

Open player inventory: E

Rotate: R. 

Rotation Note 1: If you have something in your hand, you will rotate that.  Otherwise you will rotate the building your cursor is over.

Rotation Note 2: The first time you press the rotate key, it will simply say the direction a building is facing. Subsequent presses will actually rotate the building.

Picker tool: For a detected entity, SHIFT + Q. This brings to hand more of the selected entity's item form, if you have it in your inventory.

Nudge building by one tile: CONTROL + SHIFT + DIRECTION, where the direction is one of W A S D.

Pick up nearby items on the ground or on top of nearby belts: Hold F 

Copy building settings: With empty hand, SHIFT + RIGHT BRACKET on the building

Paste building settings: With empty hand, SHIFT + LEFT BRACKET on the building

Quickly collect the entire output of a building: With empty hand, CONTROL + LEFT BRACKET on the building

Quickly collect half of the entire output of a building: With empty hand, CONTROL + RIGHT BRACKET on the building

## Cursor

Speak cursor coordinates: K. If the cursor is over an entity, its relative location ıupon the entity is read out, such as the Southwest corner.

Enable or disable cursor mode: I

Move cursor freely in cursor mode: W A S D
Jump cursor to character: J

Teleport player to cursor: SHIFT + T

Increase cursor size to examine a larger area: CONTROL + I

Decrease cursor size to examine a smaller area: CONTROL + SHIFT + I

Note: You must be in cursor mode for the size of the cursor to make any difference.

## Inventory

Open player inventory: E

Navigate inventory slots: W A S D

Get slot coordinates: K

Get selected item info: L

Pick up selected item to hand: LEFT BRACKET

Add selected item to quickbar: CONTROL + NUMBER KEY, for keys 1 to 9 and 0.

Switch to other menus: TAB

Close menus: E

## Item in Hand

Read item in hand: Q

Get info on item in hand: L

Empty the hand to your inventory: SHIFT + Q

Picker tool: With an empty hand, SHIFT + Q. Grabs from the inventory to the hand, more of the item related to the entity in front of you.

Pick from quickbar: NUMBER KEY

Assign hand item to a quickbar number: CONTROL + NUMBER KEY

Place building: LEFT BRACKET, for items that support it

Toggle build lock for continuous building: CONTROL + B. It is also turned off while switching cursor modes or emptying the hand.

Rotate: R. 

Rotation Note 1: If you have something in your hand, you will rotate that.  Otherwise you will rotate the building your cursor is over.

Rotation Note 2: The first time you press the rotate key, it will simply say the direction a building is facing. Subsequent presses will actually rotate the building.

Drop 1 unit: Z. Drops the item onto the ground or onto a belt or inside an applicable building.

Insert 1 stack of the item in hand where applicable: CONTROL + LEFT BRACKET. Works for chests or for smartly feeding machines and vehicles.

Insert half a stack of the item in hand where applicable: CONTROL + RIGHT BRACKET. Works for chests or for smartly feeding machines and vehicles.

## Floor Pavings and Thrown Items

Pave the floor with bricks or concrete: With the paving item in hand, LEFT BRACKET. This affects a 3 by 3 area with your character in the center.
  
Pick up floor paving: With any bricks or concrete in hand: X. This will pick up a 2 by 2 area centered on the cursor.
  
Place landfill over water: With landfill in hand, LEFT BRACKET. This affects any water in a 3 by 3 area with your character in the center. Note: This is not reversible!
  
Throw a capsule item at the cursor within range: With the item in hand, LEFT BRACKET. Warning: Throwing grenades will hurt you unless the cursor is moved far enough away.

## Guns and Armor Equipment

Swap gun in hand: TAB
  
Fire at the cursor: C. Warning: Friendly fire is allowed.
  
Fire at enemies with aiming assistance: SPACEBAR. This only when an enemy is within range, and only for pistols / submachine guns / rocket launchers with regular rockets.

Warning: There is not yet any audio guidance added about enemy presence.  

The rest of the controls in this section require you to have the inventory screen opened (but no buildings).

Equip a gun or ammo stack: LEFT BRACKET to take it in hand and SHIFT + LEFT BRACKET to equip it.
  
Read currently equipped guns (up to 3) and ammo: R
  
Reload all ammo slots from the inventory: SHIFT + R
  
Return all guns and ammo to inventory: CONTROL + SHIFT + R
  
Equip an armor suit or armor equipment module: LEFT BRACKET to take it in hand and SHIFT + LEFT BRACKET to equip it.
  
Read armor type and equipment stats: G
  
Read armor equipment list: SHIFT + G
  
Return all equipment and armor to inventory: CONTROL + SHIFT + G

## Scanner Tool

Scan for nearby entities: END

Repeat scanned entry: HOME

Navigate scanned entity list: PAGE UP and PAGE DOWN

Switch between different instances of the same entity: SHIFT + PAGE UP and SHIFT + PAGE DOWN

Change scanned category: CONTROL + PAGE UP and CONTROL + PAGE DOWN

Change Sorting mode for scanned list: N and SHIFT + N 

Move cursor to scanned target in cursor mode: CONTROL + HOME

Teleport to the scanned target outside of cursor mode: CONTROL + HOME

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

## While in a menu

Change tabs within a menu: TAB and SHIFT + TAB

Navigate inventory slots: W A S D

Coordinates of current inventory slot: K

Selected item information: L

Grab item in hand: LEFT BRACKET

Smart Insert/Smart Withdrawal: SHIFT + LEFT BRACKET

Note: This will insert an item stack, or withdraw an item stack from a building. It is smart because it will decide the proper inventory to send the item to.  For instance, smart inserting coal into a furnace will attempt to put it in the fuel category, as opposed to the input category.

Multi stack smart transfer: CONTROL + LEFT BRACKET

Note: When you have a building inventory open, pressing CONTROL + LEFT BRACKET for a selected item in an inventory will cause an attempt to transfer the entire supply of this item to the other inventory. Non-transferred items will remain in their original inventory. Similarly, pressing CONTROL + RIGHT BRACKET will try to transfer half of the entire supply of the selected item.

Note 2: When you have a building inventory open and select an empty slot, pressing CONTROL + LEFT BRACKET will cause an attempt to transfer the full contents of the selected inventory into the other inventory. This is useful for easily filling up labs and assembling machines with everything applicable from your own inventory instead of searching for items individually. Non-transferred items will remain in their original inventory. Similarly, pressing CONTROL + RIGHT BRACKET on an empty slot will try to transfer half of the entire supply of every item.

Modify chest inventory slot limits: PAGE UP or PAGE DOWN. 

Note: You can hold SHIFT to modify limits by increments of 5 instead of 1 and you can hold CONTROL to set the limit to maximum or zero.

## Crafting Menu

Navigate recipe groups: W S

Navigate recipes within a group: A D

Check crafting components required: K

Read recipe product description: L

Craft 1 item: LEFT BRACKET

Craft 5 items: RIGHT BRACKET

Craft as many items as possible:  SHIFT + LEFT BRACKET

## Crafting Queue Menu

Navigate queue: W A S D

Unqueue 1 item: LEFT BRACKET

Unqueue 5 items: RIGHT BRACKET

Unqueue all items: SHIFT + LEFT BRACKET

## In item selector submenu (alternative)

Select category: LEFT BRACKET or S

Jump to previous category level: W

Select category from currently selected tier: A and D

## Splitter Interactions

Set input priority side: SHIFT + LEFT ARROW, or SHIFT + RIGHT ARROW. Press the same side again to reset to equal priority.
  
Set output priority side: CONTROL + LEFT ARROW, or CONTROL + RIGHT ARROW. Press the same side again to reset to equal priority.
  
Set an item filter: With the item in hand, CONTROL + LEFT BRACKET
  
Set item filter output side: CONTROL + LEFT ARROW, or CONTROL + RIGHT ARROW
  
Set an item filter: With the item in hand, CONTROL + LEFT BRACKET
  
Clear the item filter: With an empty hand, CONTROL + LEFT BRACKET
  
Copy and paste splitter settings: SHIFT + RIGHT BRACKET and then SHIFT + LEFT BRACKET

## Rail Building and Analyzing

Rail unrestricted placement: Press CONTROL + LEFT BRACKET with rails in hand to place down a single straight rail.

Rail appending: Press LEFT BRACKET with rails in hand to automatically extend the nearest end rail by one unit. Also accepts RIGHT BRACKET.

Rail structure building menu: Press SHIFT + LEFT BRACKET on any rail, but end rails have the most options. Structures include turns, train stops, etc.

Rail analyzer UP: Press J with empty hand on any rail to check which rail structure is UP along the selected rail. Note: This cannot detect trains!

Rail analyzer DOWN: Press SHIFT + J with empty hand on any rail to check which rail structure is DOWN along the selected rail. Note: This cannot detect trains!

Station rail analyzer: Select a rail behind a train stop to hear corresponding the station space. Note: Every rail vehicle is 6 tiles long and there is one tile of extra space between each vehicle on a train.

Note 1: When building parallel rail segments, it is recommended to have at least 4 tiles of space between them in order to leave space for infrastructure such as rail signals, connecting rails, or crossing buildings.

Note 2: In case of bugs, be sure to save regularly. There is a known bug related to extending rails after building a train stop on an end rail.

Shortcut for building rail right turn 45 degrees: CONTROL + RIGHT ARROW on an end rail.

Shortcut for building rail left turn 45 degrees: CONTROL + LEFT ARROW on an end rail.

## Train Building and Examining

Place rail vehicles: LEFT BRACKET on an empty rail with the vehicle in hand and facing a rail. Locomotives snap into place at train stops. Nearby vehicles connect automatically to each other upon placing.

Manually connect rail vehicles: G near vehicles

Manually disconnect rail vehicles: SHIFT + G near vehicles

Flip direction of a rail vehicle: SHIFT + R on the vehicle, but it must be fully disconnected first.

Open train menu: LEFT BRACKET on the train's locomotives

Train vehicle quick info: L

Examine locomotive fuel tank contents: RIGHT BRACKET. 

Examine cargo wagon or fluid wagon contents: RIGHT BRACKET. Note that items can for now be added or removed only via cursor shortcuts or inserters.

Add fuel to a locomotive: With fuel items in hand, CONTROL + LEFT BRACKET on the locomotive


## Driving Ground Vehicles or Locomotives

Read fuel inventory: RIGHT BRACKET
  
Insert fuel: With the fuel stack in hand: CONTROL + LEFT BRACKET to insert all, or CONTROL + RIGHT BRACKET to insert half.
  
Insert ammo for any vehicle weapons: With the appropriate ammo stack in hand: CONTROL + LEFT BRACKET to insert all, or CONTROL + RIGHT BRACKET to insert half.
  
Enter or exit: ENTER

The following controls are for when driving:

Accelerate forward (or break): Hold W
  
Accelerate backward (or break): Hold S
  
Steer left or right: A or D. Not needed to make trains go around turns.
  
Get heading and speed and coordinates: K
  
Get some vehicle info: L
  
Fire selected vehicle weapon: SPACEBAR
  
For trains, analyze the first rail structure ahead: J
  
For trains, analyze the first rail structure behind: SHIFT + J

For trains, read precise distance to a nearby train stop for manual alignment: J
  
For trains, open the train menu: LEFT BRACKET. Navigate with ARROW KEYS.

## Using the Screen Reader

The screen reader, such as for NVDA, can be used but it is generally not that helpful during gameplay because in-game menus heavily use visual icons and graphs instead of text. We are designing the mod to require the screen reader as little as possible. However, the screen reader is necessary in the following situtaions: When the game crashes, when your character dies, when you win a game, and optionally when you pause the game.

# FAQ:

Q:  How much of the game is accessible right now?
A:  All basic interactions with buildings and items are supported. As of Version 0.4, you can complete the main objectives of the game but not every main feature is fully supported. There is currently partial support for combat and trains, and no support for multiplayer and flying robots and circuit networks. We are gradually working on it and some features are a few bugfixes away. Some unique features have been added to increase accessibility. More about this can be found on the wiki.

Q:  What is the development timeline?
A:  Development is slow overall due to the time constraints of our volunteers but we aim to have at least partial support for all main features before the middle of 2024.

Q:  Do I have to pay to use the mod?
A:  The mod is and always will be free. The game itself costs $35 on [Factorio.com](www.factorio.com) and prices can vary per country on Steam.

Q:  Does this mod work with the steam version?
A:  Not yet, however if you buy the game on Steam or another seller, you can use your product key to redeem the standalone version on factorio.com

Q:  Does this mod work with the demo?
A:  No, in fact no mods work with the demo.

Q:  Where can I find information about the game?
A:  There is in-game help via item descriptions, while this page, our own wiki, and the official wiki can provide information and guidance.

Q:  Can this mod run the game's tutorials?
A:  No, but there is in-game help via item descriptions, while this page, our own wiki, and the official wiki can provide info and guidance.

Q:  My game crashed, what gives?
A:  This mod is currently still in early access.  Bugs are normal and expected.  Please post about it in the issues channel of Discord. Autosave should generally restore your progress.

Q:  Who is working on the mod?
A:  We are a small group of volunteers who are not officially affiliated with the developers of Factorio.

Q:  Can I contribute to this project?
A:  Generally, playtesting and feedback from players is always welcome. You can also make suggestions for or assist in writing our wiki pages. Coding assitance from experienced modders would be appreciated. You can talk to us on Discord to discuss details.


# Wiki

For information about the game, such as the resources, machines, and systems, please check out our own [Factorio Access Wiki](https://github.com/Crimso777/Factorio-Access/wiki).

Factorio also has an [official wiki](https://wiki.factorio.com/).



# Help and Support

If your question wasn't answered here, please check out our [Discord server](https://discord.gg/CC4QA6KtzP), and ask your question there.

If you want to help others or discuss the development of the mod or the wiki, feel free to again join us at the [Discord server](https://discord.gg/CC4QA6KtzP).



# Changes

An updated changelog can be found [here](https://github.com/Crimso777/Factorio-Access/blob/main/CHANGES.md).



# Donations

While this mod is completely free for all, our main developer is a full time student working on this mod in their free time, thus any and all support is greatly appreciated.

If you are so inclined, you can donate at my [Patreon](https://www.patreon.com/Crimso777).
