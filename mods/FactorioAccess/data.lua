--data:
data.raw.character.character.has_belt_immunity = true
local resource_map_node = table.deepcopy(data.raw["container"]) 
resource_map_node.name = "map-node"
resource_map_node.type = "simple-entity-with-force"
--resource_map_node.inventory_size = 0

resource_map_node["collision_box"] = {{-0, -0}, {0, 0}}
resource_map_node["collision_mask"] = {}
resource_map_node["selection_box"] = nil
resource_map_node["order"] = "z"
resource_map_node["max_health"] = 2147483648
resource_map_node["picture"] = {
	filename = "__FactorioAccess__/Graphics/invisible.png",
	width = 1,
	height = 1,
	direction_count = 1
}




data:extend({
 resource_map_node,
{
   type = "sound",
   name = "Face-Dir",
   filename = "__FactorioAccess__/Audio/1face_dir.ogg",
   volume = 1,
   preload = true
},
{
   type = "sound",
   name = "Inventory-Move",
   filename = "__FactorioAccess__/Audio/inventory-move.ogg",
   volume = 1,
   preload = true
},

{
   type = "sound",
   name = "Mine-Building",
   filename = "__FactorioAccess__/Audio/mine_02.ogg",
   volume = 1,
   preload = true
},

{
   type = "sound",
   name = "Open-Inventory-Sound",
   filename = "__core__/sound/gui-green-button.ogg",
   volume = 1,
   preload = true
},

{
   type = "sound",
   name = "Close-Inventory-Sound",
   filename = "__core__/sound/gui-green-confirm.ogg",
   volume = 1,
   preload = true
},

{
   type = "sound",
   name = "Change-Menu-Tab-Sound",
   filename = "__core__/sound/gui-switch.ogg",
   volume = 1,
   preload = true
},

{
   type = "sound",
   name = "Rotate-Hand-Sound",
   filename = "__core__/sound/gui-back.ogg",
   volume = 1,
   preload = true
},

  {
    type = "custom-input",
    name = "cursor-up",
    key_sequence = "W",
    linked_game_control = "move-up",
    consuming = "none"
},
{
    type = "custom-input",
    name = "cursor-down",
    key_sequence = "S",
    linked_game_control = "move-down",
    consuming = "none"
},
{
    type = "custom-input",
    name = "cursor-left",
    key_sequence = "A",
    linked_game_control = "move-left",
    consuming = "none"
},
{
    type = "custom-input",
    name = "cursor-right",
    key_sequence = "D",
    linked_game_control = "move-right",
    consuming = "none"
},
  {
    type = "custom-input",
    name = "nudge-up",
    key_sequence = "CONTROL + SHIFT + W",
    consuming = "none"
},
{
    type = "custom-input",
    name = "nudge-down",
    key_sequence = "CONTROL + SHIFT + S",
    consuming = "none"
},
{
    type = "custom-input",
    name = "nudge-left",
    key_sequence = "CONTROL + SHIFT + A",
    consuming = "none"
},
{
    type = "custom-input",
    name = "nudge-right",
    key_sequence = "CONTROL + SHIFT + D",
    consuming = "none"
},

{
    type = "custom-input",
    name = "read-coords",
    key_sequence = "K",
    consuming = "none"
},
{
    type = "custom-input",
    name = "jump-to-player",
    key_sequence = "J",
    consuming = "none"
},
{
    type = "custom-input",
    name = "shift-j",
    key_sequence = "SHIFT + J",
    consuming = "none"
},
{
    type = "custom-input",
    name = "teleport-to-cursor",
    key_sequence = "SHIFT + T",
    consuming = "none"
},
{
    type = "custom-input",
    name = "toggle-cursor",
    key_sequence = "I",
    consuming = "none"
},

{
    type = "custom-input",
    name = "cursor-size-increment",
    key_sequence = "CONTROL + I",
    consuming = "none"
},

{
    type = "custom-input",
    name = "cursor-size-decrement",
    key_sequence = "CONTROL + SHIFT + I",
    consuming = "none"
},

{
    type = "custom-input",
    name = "scan-up",
    key_sequence = "PAGEUP",
    alternative_key_sequence = "UP",
    consuming = "none"
},

{
    type = "custom-input",
    name = "scan-down",
    key_sequence = "PAGEDOWN",
    alternative_key_sequence = "DOWN",
    consuming = "none"
},

{
    type = "custom-input",
    name = "scan-middle",
    key_sequence = "HOME",
    alternative_key_sequence = "RSHIFT",
    consuming = "none"
},
{
    type = "custom-input",
    name = "jump-to-scan",
    key_sequence = "CONTROL + HOME",
    alternative_key_sequence = "CONTROL + RSHIFT",
    consuming = "none"
},

{
    type = "custom-input",
    name = "repeat-last-spoken",
    key_sequence = "CONTROL + TAB",
    consuming = "none"
}
,
{
    type = "custom-input",
    name = "tile-cycle",
    key_sequence = "F",
    consuming = "none"
},

{
    type = "custom-input",
    name = "rescan",
    key_sequence = "END",
    alternative_key_sequence = "RCTRL",
    consuming = "none"
},

{
    type = "custom-input",
    name = "recalibrate",
    key_sequence = "CONTROL + END",
    alternative_key_sequence = "CONTROL + RCTRL",
    consuming = "none"
},

{
    type = "custom-input",
    name = "scan-category-up",
    key_sequence = "CONTROL + PAGEUP",
    alternative_key_sequence = "CONTROL + UP",
    consuming = "none"
},

{
    type = "custom-input",
    name = "scan-category-down",
    key_sequence = "CONTROL + PAGEDOWN",
    alternative_key_sequence = "CONTROL + DOWN",
    consuming = "none"
},

{
    type = "custom-input",
    name = "scan-mode-up",
    key_sequence = "SHIFT + N",
    consuming = "none"
},


{
    type = "custom-input",
    name = "scan-mode-down",
    key_sequence = "N",
    consuming = "none"
},

{
    type = "custom-input",
    name = "scan-selection-up",
    key_sequence = "SHIFT + PAGEUP",
    alternative_key_sequence = "SHIFT + UP",
    consuming = "none"
},

{
    type = "custom-input",
    name = "scan-selection-down",
    key_sequence = "SHIFT + PAGEDOWN",
    alternative_key_sequence = "SHIFT + DOWN",
    consuming = "none"
},

{
    type = "custom-input",
    name = "quickbar-1",
    key_sequence = "1",
    consuming = "none"
},

{
    type = "custom-input",
    name = "quickbar-2",
    key_sequence = "2",
    consuming = "none"
},

{
    type = "custom-input",
    name = "quickbar-3",
    key_sequence = "3",
    consuming = "none"
},

{
    type = "custom-input",
    name = "quickbar-4",
    key_sequence = "4",
    consuming = "none"
},

{
    type = "custom-input",
    name = "quickbar-5",
    key_sequence = "5",
    consuming = "none"
},

{
    type = "custom-input",
    name = "quickbar-6",
    key_sequence = "6",
    consuming = "none"
},

{
    type = "custom-input",
    name = "quickbar-7",
    key_sequence = "7",
    consuming = "none"
},

{
    type = "custom-input",
    name = "quickbar-8",
    key_sequence = "8",
    consuming = "none"
},

{
    type = "custom-input",
    name = "quickbar-9",
    key_sequence = "9",
    consuming = "none"
},

{
    type = "custom-input",
    name = "quickbar-10",
    key_sequence = "0",
    consuming = "none"
},

{
    type = "custom-input",
    name = "set-quickbar-1",
    key_sequence = "CONTROL + 1",
    consuming = "none"
},

{
    type = "custom-input",
    name = "set-quickbar-2",
    key_sequence = "CONTROL + 2",
    consuming = "none"
},

{
    type = "custom-input",
    name = "set-quickbar-3",
    key_sequence = "CONTROL + 3",
    consuming = "none"
},

{
    type = "custom-input",
    name = "set-quickbar-4",
    key_sequence = "CONTROL + 4",
    consuming = "none"
},

{
    type = "custom-input",
    name = "set-quickbar-5",
    key_sequence = "CONTROL + 5",
    consuming = "none"
},

{
    type = "custom-input",
    name = "set-quickbar-6",
    key_sequence = "CONTROL + 6",
    consuming = "none"
},

{
    type = "custom-input",
    name = "set-quickbar-7",
    key_sequence = "CONTROL + 7",
    consuming = "none"
},

{
    type = "custom-input",
    name = "set-quickbar-8",
    key_sequence = "CONTROL + 8",
    consuming = "none"
},

{
    type = "custom-input",
    name = "set-quickbar-9",
    key_sequence = "CONTROL + 9",
    consuming = "none"
},

{
    type = "custom-input",
    name = "set-quickbar-10",
    key_sequence = "CONTROL + 0",
    consuming = "none"
},



{
    type = "custom-input",
    name = "open-inventory",
    key_sequence = "E",
    consuming = "none"
},

{
    type = "custom-input",
    name = "mine-access",
    key_sequence = "X",
    linked_game_control = "mine",
    consuming = "none"
},

{
    type = "custom-input",
    name = "switch-menu",
    key_sequence = "TAB",
    consuming = "none"
},


{
    type = "custom-input",
    name = "reverse-switch-menu",
    key_sequence = "SHIFT + TAB",
    consuming = "none"
},


{
    type = "custom-input",
    name = "left-click",
    key_sequence = "LEFTBRACKET",
    consuming = "none"
},


{
    type = "custom-input",
    name = "right-click",
    key_sequence = "RIGHTBRACKET",
    consuming = "none"
},

{
    type = "custom-input",
    name = "shift-click",
    key_sequence = "SHIFT + LEFTBRACKET",
    consuming = "none"
},

{
    type = "custom-input",
    name = "control-click",
    key_sequence = "CONTROL + LEFTBRACKET",
    consuming = "none"
},

{
    type = "custom-input",
    name = "control-right-click",
    key_sequence = "CONTROL + RIGHTBRACKET",
    consuming = "none"
},

{
    type = "custom-input",
    name = "item-info",
    key_sequence = "L",
    consuming = "none"
},

{
    type = "custom-input",
    name = "list-warnings",
    key_sequence = "P",
    consuming = "none"
},

{
    type = "custom-input",
    name = "rotate-building",
    key_sequence = "R",
    linked_game_control = "rotate",
    consuming = "game-only"
},

{
    type = "custom-input",
    name = "prompt",
    key_sequence = "SPACE",
    consuming = "none"
},

{
    type = "custom-input",
    name = "time",
    key_sequence = "T",
    consuming = "none"
},

{
    type = "custom-input",
    name = "save",
    key_sequence = "F1",
    consuming = "none"
},

{
    type = "custom-input",
    name = "toggle-build-lock",
    key_sequence = "CONTROL + B",
    consuming = "none"
},

{
    type = "custom-input",
    name = "toggle-walk",
    key_sequence = "CONTROL + W",
    consuming = "none"
},

{
    type = "custom-input",
    name = "read-hand",
    key_sequence = "Q",
    consuming = "none"
},

{
    type = "custom-input",
    name = "open-fast-travel",
    key_sequence = "V",
    consuming = "none"
},

{
    type = "custom-input",
    name = "fa-alt-zoom-in",
    key_sequence = "X",
    linked_game_control = "alt-zoom-in",
    consuming = "none"
},

{
    type = "custom-input",
    name = "fa-alt-zoom-out",
    key_sequence = "X",
    linked_game_control = "alt-zoom-out",
    consuming = "none"
},

{
    type = "custom-input",
    name = "fa-zoom-out",
    key_sequence = "X",
    linked_game_control = "zoom-out",
    consuming = "none"
},

{
    type = "custom-input",
    name = "fa-zoom-in",
    key_sequence = "X",
    linked_game_control = "zoom-in",
    consuming = "none"
},

{
    type = "custom-input",
    name = "fa-debug-reset-zoom-2x",
    key_sequence = "X",
    linked_game_control = "debug-reset-zoom-2x",
    consuming = "none"
},

{
    type = "custom-input",
    name = "fa-debug-reset-zoom",
    key_sequence = "X",
    linked_game_control = "debug-reset-zoom",
    consuming = "none"
},

{
    type = "custom-input",
    name = "open-structure-travel",
    key_sequence = "CONTROL + S",
    consuming = "none"
},

{
    type = "custom-input",
    name = "shift-g-key",
    key_sequence = "SHIFT + G",
    consuming = "none"
},

{
    type = "custom-input",
    name = "control-g-key",
    key_sequence = "CONTROL + G",
    consuming = "none"
},

{
    type = "custom-input",
    name = "control-left",
    key_sequence = "CONTROL + LEFT",
    consuming = "none"
},

{
    type = "custom-input",
    name = "control-right",
    key_sequence = "CONTROL + RIGHT",
    consuming = "none"
}

})