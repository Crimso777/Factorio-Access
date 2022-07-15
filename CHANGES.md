# Version 0.1.2

Updated 07/15/22

Bug Fixes:

-Pumps should now say the correct output direction, even when they are facing north.

-Fixed a crash involving pumps and left clicking before navigating the pump menu

-Fixed bugs regarding filter inserters and their unique menu structure

-Fixed game crashing if butttons were pressed before callibration

Features:

-Game will now announce to player when tab is necessary to start the game

-Updated descriptions for certain entities

-Objects that cannot be rotated will now appropriately say so

-Added item information in crafting menu.  Press L to get a description of a recipe's product


# Version 0.1.1

Updated 07/09/22

Bug Fixes:

-Fixed errors when mining things such as trees.  Thanks @Eph

# Version 0.1.0

Updated 07/07/2022

New Features:

-Added transport line analyzer:  LEFT BRACKET while facing a belt to open the new and improved transport belt menu.  Use tab to toggle between the contents of the single tile you are looking at, the entire transport line's contents, and analysis of belts upstream and downstream from the examined belt.

-Added Warnings menu:  Press P to see the new warnings menu.  Warnings are little icons that appear over buildings graphically and indicate something is wrong with the building.  Examples include not connected, no power, and no fuel.  LEFT BRACKET while over a warning to jump to the building in question.

-Added localised descriptions for all items and entities in the game.  Press L while over an item in inventory to get detailed information about the item.  Special shoutout to @Sir Fendi and @MyNameIsTres for making this possible.  

-Selecting items will now notify the player what is currently in the hand.  Thanks to @Eph for making this happen

-Added various mouse controls while on the main map.  Examples include CONTROL + LEFT BRACKET and CONTROL + RIGHT BRACKET for fast transfer and fast split respectively.  This means to put the entire stack you are holding in a building, press CONTROL and LEFT BRACKET while focused on a building.  To put half, press CONTROL + RIGHT BRACKET.  Thanks again to @Eph for his work in this regard

-Jumping cursor to scan items no longer requires entering cursor mode.  This should make it easier to get where you need to go.

-Read-Tile now gives additional information including the recipe that a production building is using, whether it is connected to power or out of fuel.

-Q now speaks the item held in hand.  SHIFT + Q now performs actions that Q previously executed.

Various Bug Fixes.


# Version 0.0.5

Updated 06/23/22
New Features:

-Manual Recalibration: Press CONTROL + END to recallibrate.  Very useful if you frequently zoom in

-Sort by number of entities found in a scan: Press SHIFT + PAGEUP and SHIFT + PAGEDOWN to alternate between scanning modes

-Modular Cursor:  Change the size of your cursor with CONTROL + I and CONTROL + SHIFT + I

   note:  The cursor is only modular in cursor mode, so you will need to press I first in order to enter cursor mode.

-Scan Summary: The modular cursor will give a list of important information for the area scanned, in addition to adding the normal elements to your scan list.  For now end only triggers the normal re-scan around the player's location.

-Building filters are now accessible

-New Item selector:  Only implemented for filter building slots currently, if popular could make navigating recipes and technologies easier too.

-Examining a resource tile will now speak the amount of resources left to be mined.

-Added more descriptive feedback regarding entities that cannot be rotated

Various bugfixes:

   -Fixed bug where teleporting wouldn't properly update the cursor and player locations

   -Fixed bug where electric poles wouldn't speak connected/not connected while over a resource

   -Fixed bug where offshore pumps wouldn't read output correctly

   -fixed bug(hopefully) where a scanned item would disappear from the scan list requiring a re-scan

   -fixed bug where opening inventory during callibration would bypass callibration

# Version 0.0.4

Updated 6/16/22

-Variety of bug fixes:

   -Game will no longer crash when changing category before the initial scan

   -Electric poles now correctly say connected based on cursor location, not player location

   -Belts that become invalid should no longer crash the game

   -Oddly shaped buildings should now read all input/output regardless of orientation

-Brand new movement modes brought by @Eph on Discord.  Toggle between them with Control+W

   -Telestep: The good old movement you all know and try to love

   -Step-By-Walk: Should be the same as telestep but with footstep sound effects.  

   -Smooth-Walking: Effectively turns off the read tile system unless you walk into something you cannot pass through.  Great for navigating forests, squeezing between furnaces, and getting places quickly.  No more angry tapping.

Note: The new movement system may have some undiscovered bugs, so please be patient and report in the Issues channel on Discord.

-Significant improvements to scanning and initialization performance.

-A fresh new .jkm file for Jaws users.  This should also speed up performance.  Consult the readme for instructions on how to install this file.


# Version 0.0.3

Updated 6/15/22

-Added accessible menu for placing offshore pumps

-Added f to the list of keybinds in the readme


# Version 0.0.2

Updated 6/15/22

-Started a changelog, version numbers will be reflected here but not in the mods folder just to keep things simple

-Added tile based descriptions of a buildings input/output.  To see this information, use cursor mode and move around the perimeter of the building.  

   For instance: moving the cursor over the top left corner of a burner mining drill will speak "output 1 north" indicating that things come out of the building, and this occurs 1 tile north of the cursor.

-Added descriptions for direction a building is facing

--Added power output description when cursor is over a generator type building

   note: solar panels are programmed differently, so will require more work for power output information.

-Added total network power production to description when cursor is on electric poles

-Added several new categories for scanning

-Empty categories will now be ignored, and the player will not have to move through them.

-Added a Jump to Scanned feature, whereby the player can jump their cursor to the location of something in the scan list.

   This is done with control+home and can only be done while in cursor mode

-Underground belts and pipes are now somewhat accessible.  Once placed they will indicate the location of their connected partner. 

   Note, these objects do not yet speak "connected" or "not connected" while placing them, but that too will be added this week.

-Modified building logic to be more reliable.

-Building from cursor now supported.  Player must be in range of the target location, and the target location must be unoccupied

-Removed unnecessary empty inventories from buildings

-Callibration once again has a failsafe.  If your callibration failed, you will be prompted to callibrate again.

-Player will now be notified at the end of every autosave, and at the beginning of any autosave triggered by pressing F1

   Note: Notifying at the start of game triggered autosaves is a work in progress, and should be done by end of week.

-Fixed crash triggered by selecting "back" option in launcher save file list
