# Version 0.4.0

Updated in September of 2023.

## New Features
- General vehicle support
  * Entering and exiting a vehicle will notify you about the vehicle name.
  * Press K inside a vehicle to learn the heading and coordinates.
  * Pressing L while inside a vehicle will provide additional information about it. For cars, the fuel stocks are stated. For trains, basic info is given while the train menu has detailed info.
  * You can refuel a vehicle by dropping a stack in hand into it via CONTROL + LEFT BRACKET.

- Phases 0 and 1 and 2 of Trains Implementation. In general, we made it accessible to build rail lines, analyze rail segments, build train stations, build and examine trains, and drive trains manually or sub-automatically.
  * Added info support for rails. There is now distinction between end rails, station rails, etc. and the directions of rails are given.
  * Added support for building and renaming train stops.
  * Added train station rail information tool. When you look at a rail behind a train stop, you get information of which section of which rail vehicle would be positioned there when a train stops at the station.
  * Rail appender tool: Adds a straight rail to extend any straight end rail near the cursor.
  * Rail structure building menu: Allows building correctly oriented railway structures based on a selected end rail as the anchor point. Also can add signals to mid rails.
  * Functions added to build 45 degree turns and 90 degree turns as structures at end rails.
  * Added support for building and naming trains.
  * Allowed reading the fuel amount in a locomotive: check its status via RIGHT BRACKET.
  * The contents of cargo wagons and fluid wagons can be checked via RIGHT BRACKET.
  * Information about a train can be read from its menu including name, length, vehicle counts, cargo item counts, etc.
  * Rail analyzer tool: Press J inside a train to learn the nearest structure ahead on the rails and the distance to it. Press SHIFT + J to check the opposite direction.
  * Rail analyzer tool works on foot as well.
  * Subautomatic travel added: You can select an option from the train menu to make a train go by itself to the other station on a rail line with 2 stations.
  * Subautomatic trains announce to any passengers their next station and arriving station.
  * Rail chain signal placement designed to be same as in Vanilla. You need to craft any signals you place and they are refunded when mined.
  * Other additions all across the code to support trains.
  * Note 1: Parallel rail lines should be at least 4 tiles apart. This is partially enforced for the rail appender tool.
  * Note 2: Partially and fully automated train support are goals for later updates. See Chapter 16 of the wiki for more info.

- Rocket silo support added: Silos can now report rocket part counts and launch rockets (press SPACE on it when ready).

- Group mining added: If you press SHIFT + X on a tree or a rail, it will mine all of them immediately around you instead of only one.

- Mine lock added: Press CONTROL + X to hold the cut-and-paste tool. Every building the cursor touches while holding this tool will be mined instantly if possible. To disable to tool, empty your hand with SHIFT + Q.

- Added support for placing stone bricks and concrete varients as tiles, for making pathways or decoration.

- Added support for placing landfill over water. Note: This is not reversible.

- Added support for throwing capsule items, including cliff explosives, defender drones, and grenades. Note: Grenades will damage everything including you while cliff explosives affect only cliffs.

- Added support for wearing or swapping armor. Press SHIFT + LEFT BRACKET to equip an armor in your hand, but only when the inventory screen by itself is open. 

## Changes
- Changed the keybind for disconnecting rail vehicles from "V" to "SHIFT + G".
- Teleporting is disabled while riding a vehicle.
- Teleporting function can now also be called silently.
- Build lock smart placement for electric poles now applies to medium electric poles. They are placed to allow maxiumum continuous area coverage rather than maximum wire reach.
- Extra entries added to the ent info function for train related entities.
- Renamed all rails and trains directions to use defines instead of hardcoded integers
- Minor changes
  * Entity ghosts are now better identified.
  * Beacon contents are now read.
  * Containers now report top 2 items at first look, instead of 1. 
  * For entities containing fluids, any extra fluids are also reported.
  * Added information reporting for entities facing diagonal directions.
  * Added new sound effects for reaching the borders of inventories.
  * Added function to mine all trees and rocks in a given circular area. Useful for when placing structures.

## Bugfixes
- Fixed a bug where the inventory is opened directly when a Factorio Access menu is closed.
- Fixed a bug where entities that have not started using their fuel are reported as out of fuel.
- Fixed various crashes related to reading invalid items.
- Corrected the information error where items cannot be transferred to another building. It is not necessarily because it is full.


# Version 0.3.1

Updated 10/26/2022

## New Features

-Build lock. When enabled, the game will continuously try to build behind the player as they walk, or under the cursor in cursor mode. Useful for tasks like building long transport belts. Press CONTROL + B to enable or disable. It also automatically gets disabled when you switch into or out of cursor mode or empty your hand and take a step.

-Build lock has a special case for small electric poles where it places an electric pole only if it is within 6.5 to 7.5 tiles of the nearest small electric pole, allowing you to build lines of fully spaced out small electric poles while just walking. Note that not every tile between the fully spaced poles is powered.

## Changes

-Scanner Resource Aggregation: On the scan list, patches of resources will now be read as a group.  This includes all resource types including water, trees, and ores.

-Getting item or entity information with the L key now works for entities on the surface and inside chests and most building menus.

-Getting slot coordinates with the K key now works inside chests and most/all building menus.

-In cursor mode, pressing J will announce that the cursor is returned to the player in addition to doing it.

-Transport belt parts such as corners, junctions, and ends will now be specified when read by the cursor.

## Bug fixes

-Fixed a crash when setting filter inserter filters due to being able to select unsupported fluid recipes.

# Version 0.3.0

Updated 9/30/2022

## New Features

-New scanner categorization format.  Scanned entities will now be categorized by what they produce.  You can now tell the difference between a mining drill producing iron, and one producing copper, all from the scan list.

-New Scanner Controls:  Ppress SHIFT+PAGEUP and SHIFT+PAGEDOWN to select a particular building from the scan list.  For example, if you have 3 mining drills, it is now possible to track the one that is 3rd farthest from your position.

-New info: Fluid input and output tiles of buildings will now identify which fluid they should contain. 

-Building status info. Press RIGHT BRACKET with your hand empty when facing a building to read out its status, such as having its output full or missing ingredients. Great for diagnosing problems.

-Chest inventory limiting (bar). Useful for controlling automatically filled chests. When the chest inventory is open, press PAGE UP or PAGE DOWN to increase or decrease the limit by 1. Hold shift while pressing to increase or decrease by 5. Hold CONTROL while pressing to increase or decrease by the maximum amount.

-New inventory transfer shortcut (same as Vanilla Factorio) between building and player inventories. When you have a building inventory open, pressing CONTROL + LEFT BRACKET for a selected item in an inventory will cause an attempt to transfer the entire supply of this item to the other inventory. Non-transferred items will remain in their original inventory. Similarly, pressing CONTROL + RIGHT BRACKET will try to transfer half of the entire supply of the selected item.

-New inventory smart insert shortcut (same as Vanilla Factorio) between building and player inventories. When you have a building inventory open and select an empty slot, pressing CONTROL + LEFT BRACKET will cause an attempt to transfer the full contents of the selected inventory into the other inventory. This is useful for easily filling up labs and assembling machines with everything applicable from your own inventory instead of searching for items individually. Non-transferred items will remain in their original inventory. Similarly, pressing CONTROL + RIGHT BRACKET on an empty slot will try to transfer half of the entire supply of every item.

-New entity info upon encounter: Chests will announce their main contents. Pipes to ground, pumps, and storage tanks will announce the fluids they contain. Accumulators announce their charge percentage and amount. Solar panels announce their current production level based on the time of day. Electric poles announce the current power usage and then the current power generation capacity.

-New info: Transport belt analyzer now announces the position of each lane on the belt segment in front of you. For example, iron plates could be on the south lane of a belt segment facing west. This info is helpful for building sideloading junctions.

-New info: The reserved empty slots for ingredients and products inside assembling machines and chemical plants now announce what is expected to go in them.

## Changes

-Rocks are now categorized as resources because they can contain stone and coal.

-Entity information will no longer state the type of an entity, which usually was a repeat of the entity’s name.

## Bug fixes

-When you open a menu or an inventory, the item in the first slot was not being read. This should be fixed now for all menus.

-Transport belt analyzer now correctly reads contents of upstream belts

## Other

-Thanks to everyone who filled out the player survey!



# Version 0.2.0

Updated 07/27/22

New Features

-A new Freeplay map designed by @Sir Fendi, designed to introduce new players to Factorio Access.  Select Compass Valley from the list of difficulties to try it out.

-A new Fast Travel system.  Press V to open the fast travel menu, and save your cursor's location for later.  You are free to name, rename, delete, and create new points whenever you like.

-A new way to navigate your factory: BStride.  Travel from building to building as if they were laid out in a nice even grid.  Press CONTROL + S to open the BStride menu, then navigate with WASD.  Pick a direction, navigate the resulting list of options, and confirm a direction with your initial direction key.  For instance, if I wanted to go to the second building north of me, I'd press W to open the northern buildings list, D to select the second building from the list, then W again to confirm.  Press Left Bracket to teleport to your target building.

-Throughput summaries are now provided when looking at a building.  Simply walk up to a belt or pipe, and the mod will tell you what's on/in it.

-Trying to teleport to a building will no longer give an error.  Now you will teleport to the nearest free position, and the mod will tell you where you are in relation to your target.

-Pressing CONTROL + HOME will now teleport the player to the closest available position near the target, or if in cursor mode the old behavior will still occur.

-Mining a building now has audible feedback

-Copy building settings with SHIFT + RIGHT BRACKET, and paste the settings on another building with SHIFT + LEFT BRACKET.

-Visual cursor now follows the virtual cursor

-Game no longer requires callibration 

-Spaceship containers now include audible feedback when opening and closing.

-Default scan range is now 250 tiles in either direction of the player.

-Added building nudging. Nudge building by one tile by pressing CONTROL + SHIFT + DIRECTION, where the direction is one of W A S D.

And Many Many bug fixes thanks to @MyNameIsTrez

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
