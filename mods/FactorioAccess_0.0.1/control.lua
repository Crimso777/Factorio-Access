players = {}
groups = {}
local util = require('util')

function prune_item_groups(array)
   if #groups == 0 then
      local dict = game.item_prototypes
      local a = get_iterable_array(dict)
      for i, v in ipairs(a) do
         local check1 = true
         local check2 = true

         for i1, v1 in ipairs(groups) do
            if v1.name == v.group.name then
               check1 = false
            end
            if v1.name == v.subgroup.name then
               check2 = false
            end
         end
         if check1 then
            table.insert(groups, v.group)
         end
         if check2 then
            table.insert(groups, v.subgroup)
         end
      end         
   end
   local i = 1
   while i < #array and array ~= nil and array[i] ~= nil do
      local check = true
      for i1, v in ipairs(groups) do
         if v ~= nil and array[i].name == v.name then
            i = i + 1
            check = false
            break
         end
      end
      if check then
         table.remove(array, i)
      end
   end
end
         

                  function read_item_selector_slot(pindex)
   printout(players[pindex].item_cache[players[pindex].item_selector.index].name, pindex)
end

function get_iterable_array(dict)
   result = {}
   for i, v in pairs(dict) do
      table.insert(result, v)
   end
   return result
end

function read_scan_summary (pindex)      
   local result = ""
   local left_top = {x = math.floor((players[pindex].cursor_pos.x - 1 - players[pindex].cursor_size) / 32), y = math.floor((players[pindex].cursor_pos.y - 1 - players[pindex].cursor_size)/32)}
   local right_bottom = {x = math.floor((players[pindex].cursor_pos.x + 1 + players[pindex].cursor_size)/32), y = math.floor((players[pindex].cursor_pos.y + 1 + players[pindex].cursor_size)/32)}
   local count = 0
   local total = 0
   for i = left_top.x, right_bottom.x do
      for i1 = left_top.y, right_bottom.y do
         if game.get_player(pindex).surface.is_chunk_generated({i, i1}) then
            count = count + 1
         end
         total = total + 1
      end
   end
   if total > 0 and count/total == 0 then
      printout("This area is completely unexplored.  Move closer or set up radar to reveal this area of the map.", pindex)
      return
   elseif count ~= total then
      result = result .. "Explored " .. math.floor((count/total) * 100) .. "% "
   end
   if #players[pindex].nearby.ents > 0 then
         local percentages = {}
         for i, ent in ipairs(players[pindex].nearby.ents) do
            local area = 1
            if ent.name ~= "water" then
               local box = players[pindex].nearby.ents[i].ents[1].prototype.selection_box
               local width = math.ceil(box.right_bottom.x * 2)
               local height = math.ceil(2* box.right_bottom.y)
               area = width * height
            end
            table.insert(percentages, {name = ent.name, percent = math.floor((area * players[pindex].nearby.ents[i].count / ((1+players[pindex].cursor_size * 2) ^2) * 100) + .5)})
         end
         table.sort(percentages, function(k1, k2)
            return k1.percent > k2.percent
         end)

         result = result .. "Area contains "
         local i = 1
         while i <= # percentages and i <= 5 do
            result = result .. percentages[i].name .. " " .. percentages[i].percent .. "%, "
               i = i + 1
         end
      
   else
      result = result .. "Empty Area  "
   end
   printout(string.sub(result, 1, -3), pindex)
end
   

function scan_sort(pindex)
   for i, name in ipairs(players[pindex].nearby.ents   ) do
      local i1 = 1
      while i1 <= #name.ents do
         if name.ents[i1].valid == false then
            table.remove(name.ents, i1)
         else
            i1 = i1 + 1
         end
      end
      if #name.ents == 0 then
         table.remove(players[pindex].nearby.ents, i)
      end
   end

   if players[pindex].nearby.count == false then
      table.sort(players[pindex].nearby.ents, function(k1, k2) 
         local pos = game.get_player(pindex).position
         local ent1 = nil
         local ent2 = nil
         if k1.name == "water" then
            table.sort( k1.ents , function(k3, k4) 
               return distance(pos, k3.position) < distance(pos, k4.position)
            end)
            ent1 = k1.ents[1]
         else
            ent1 = game.get_player(pindex).surface.get_closest(pos, k1.ents)
         end
         if k2.name == "water" then
            table.sort( k2.ents , function(k3, k4) 
               return distance(pos, k3.position) < distance(pos, k4.position)
            end)
            ent2 = k2.ents[1]
         else
         ent2 = game.get_player(pindex).surface.get_closest(pos, k2.ents)
         end
         return distance(pos, ent1.position) < distance(pos, ent2.position)
      end)
            
   else
      table.sort(players[pindex].nearby.ents, function(k1, k2)
         return k1.count > k2.count
      end)
   end
   populate_categories(pindex)

end
   


function center_of_tile(pos)
   return {x = math.floor(pos.x)+0.5, y = math.floor(pos.y)+ .5}
end

function get_power_string(power)
   result = ""
   if power > 1000000000000 then
      power = power/1000000000000
      result = result .. string.format(" %.3f Terawatts", power) 
   elseif power > 1000000000 then
      power = power / 1000000000
      result = result .. string.format(" %.3f Gigawatts", power) 
   elseif power > 1000000 then
      power = power / 1000000
      result = result .. string.format(" %.3f Megawatts", power) 
   elseif power > 1000 then
      power = power / 1000
      result = result .. string.format(" %.3f Kilowatts", power) 
   else
      result = result .. string.format(" %.3f Watts", power) 
   end
   return result
end
function get_adjacent_source(box, pos, dir)
   local result = {position = pos, direction = ""}
   ebox = table.deepcopy(box)
   if dir == 1 or dir == 3 then
      ebox.left_top.x = box.left_top.y
      ebox.left_top.y = box.left_top.x
      ebox.right_bottom.x = box.right_bottom.y
      ebox.right_bottom.y = box.right_bottom.x
   end
   ebox.left_top.x = math.ceil(ebox.left_top.x * 2)/2
   ebox.left_top.y = math.ceil(ebox.left_top.y * 2)/2
   ebox.right_bottom.x = math.floor(ebox.right_bottom.x * 2)/2
   ebox.right_bottom.y = math.floor(ebox.right_bottom.y * 2)/2


   if pos.x < ebox.left_top.x then
      result.position.x = result.position.x + 1
      result.direction = "West"
         elseif pos.x > ebox.right_bottom.x then
      result.position.x = result.position.x - 1
      result.direction = "East"
   elseif pos.y < ebox.left_top.y then
      result.position.y = result.position.y + 1
      result.direction = "North"
   elseif pos.y > ebox.right_bottom.y then
      result.position.y = result.position.y - 1
      result.direction = "South"
   end
   return result
end
function read_technology_slot(pindex)
   local techs = {}
   if players[pindex].technology.category == 1 then
      techs = players[pindex].technology.lua_researchable
   elseif players[pindex].technology.category == 2 then
      techs = players[pindex].technology.lua_locked
   elseif players[pindex].technology.category == 3 then
      techs = players[pindex].technology.lua_unlocked
   end
   
   if next(techs) ~= nil and players[pindex].technology.index > 0 and players[pindex].technology.index <= #techs then
      local tech = techs[players[pindex].technology.index]
      if tech.valid then
         printout(tech.name, pindex)
      else
         printout("Error loading technology", pindex)
      end
   else
      printout("No technologies in this category yet", pindex)
   end
end
function populate_categories(pindex)
   players[pindex].nearby.resources = {}
   players[pindex].nearby.containers = {}
   players[pindex].nearby.buildings = {}
   players[pindex].nearby.other = {}

   for i, ent in ipairs(players[pindex].nearby.ents) do
      while #ent.ents > 0 and ent.ents[1].valid == false do
         table.remove(ent.ents, 1)
      end
      if #ent.ents == 0 then
         print("Empty ent")
      elseif ent.name == "water" then
         table.insert(players[pindex].nearby.resources, ent)      
      elseif ent.ents[1].type == "resource" or ent.ents[1].type == "tree" then
         table.insert(players[pindex].nearby.resources, ent)
      elseif ent.ents[1].type == "container" then
         table.insert(players[pindex].nearby.containers, ent)
      elseif ent.ents[1].type == "simple-entity" or ent.ents[1].type == "simple-entity-with-owner" then
         table.insert(players[pindex].nearby.other, ent)
      elseif ent.ents[1].prototype.is_building then
         table.insert(players[pindex].nearby.buildings, ent)
      end
   end
end

function read_belt_slot(pindex)
   local stack = nil
   if players[pindex].belt.sector == 1 then
      stack = players[pindex].belt.line1[players[pindex].belt.index]
   elseif players[pindex].belt.sector == 2 then
      stack = players[pindex].belt.line2[players[pindex].belt.index]
   else
      return
   end
   if stack.valid_for_read and stack.valid then
      printout(stack.name .. " x " .. stack.count, pindex)
   else
      printout("Empty slot", pindex)
   end
end
function reset_rotation(pindex)
   players[pindex].building_direction = -1
end

function read_building_recipe(pindex)
   if players[pindex].building.recipe_selection then
      recipe = players[pindex].building.recipe_list[players[pindex].building.category][players[pindex].building.index]
      if recipe.valid == true then
         printout(recipe.name .. " " .. recipe.category .. " " .. recipe.group.name .. " " .. recipe.subgroup.name, pindex)
      else
         printout("Blank",pindex)
      end
   else
      local recipe = players[pindex].building.recipe
      if recipe ~= nil then
         printout(recipe.name, pindex)
      else
         printout("Select a recipe", pindex)
      end
   end
end
   
   

function read_building_slot(pindex)
   if players[pindex].building.sectors[players[pindex].building.sector].name == "Filters" then 
      printout(players[pindex].building.sectors[players[pindex].building.sector].inventory[players[pindex].building.index], pindex)
   elseif players[pindex].building.sectors[players[pindex].building.sector].name == "Fluid" then 
      local box = players[pindex].building.sectors[players[pindex].building.sector].inventory
      local capacity = box.get_capacity(players[pindex].building.index)
      local type = box.get_prototype(players[pindex].building.index).production_type
      local fluid = box[players[pindex].building.index]
--      fluid = {name = "water", amount = 1}
      local name  = "Any"
      local amount = 0
      if fluid ~= nil then
         amount = fluid.amount
         name = fluid.name
      end

      printout(name .. " " .. type .. " " .. amount .. "/" .. capacity, pindex)
   else
      stack = players[pindex].building.sectors[players[pindex].building.sector].inventory[players[pindex].building.index]
      if stack.valid_for_read and stack.valid then
         printout(stack.name .. " x " .. stack.count, pindex)
      else
         printout("Empty slot", pindex)
      end
   end
end

function factorio_default_sort(k1, k2) 
   if k1.group.order ~= k2.group.order then
      return k1.group.order < k2.group.order
   elseif k1.subgroup.order ~= k2.subgroup.order then
      return k1.subgroup.order < k2.subgroup.order
   elseif k1.order ~= k2.order then
      return k1.order < k2.order
   else               
      return k1.name < k2.name
   end
end


function get_recipes(pindex, building)
   local category_filters={}
   for category_name, _ in pairs(building.prototype.crafting_categories) do
      table.insert(category_filters, {filter="category", category=category_name})
   end
   local all_machine_recipes = game.get_filtered_recipe_prototypes(category_filters)
   local unlocked_machine_recipes = {}
   local force_recipes = game.get_player(pindex).force.recipes
   for recipe_name, recipe in pairs(all_machine_recipes) do
      if force_recipes[recipe_name] ~= nil and force_recipes[recipe_name].enabled then
         if unlocked_machine_recipes[recipe.group.name] == nil then
            unlocked_machine_recipes[recipe.group.name]={}
         end
         table.insert(unlocked_machine_recipes[recipe.group.name],force_recipes[recipe.name])
      end
   end
   local result={}
   for group, recipes in pairs(unlocked_machine_recipes) do
      table.insert(result,recipes)
   end
   return result
end
function get_tile_dimensions(item)
   if item.place_result ~= nil then
      local dimensions = item.place_result.selection_box
      x = math.ceil(dimensions.right_bottom.x - dimensions.left_top.x)
      y = math.ceil(dimensions.right_bottom.y - dimensions.left_top.y)
      return x .. ", " .. y
   end
   return ""
end

function read_crafting_queue(pindex)
   if players[pindex].crafting_queue.max ~= 0 then
      item = players[pindex].crafting_queue.lua_queue[players[pindex].crafting_queue.index]
      printout(item.recipe .. " x " .. item.count, pindex)
   else
      printout("Blank", pindex)
   end
end
   
function load_crafting_queue(pindex)
   if players[pindex].crafting_queue.lua_queue ~= nil then
      players[pindex].crafting_queue.lua_queue = game.get_player(pindex).crafting_queue
      if players[pindex].crafting_queue.lua_queue ~= nil then
         delta = players[pindex].crafting_queue.max - #players[pindex].crafting_queue.lua_queue
         players[pindex].crafting_queue.index = math.max(1, players[pindex].crafting_queue.index - delta)
         players[pindex].crafting_queue.max = #players[pindex].crafting_queue.lua_queue
      else
      players[pindex].crafting_queue.index = 1
      players[pindex].crafting_queue.max = 0
      end
   else
      players[pindex].crafting_queue.lua_queue = game.get_player(pindex).crafting_queue
   players[pindex].crafting_queue.index = 1
      if players[pindex].crafting_queue.lua_queue ~= nil then
      players[pindex].crafting_queue.max = # players[pindex].crafting_queue.lua_queue
      else
         players[pindex].crafting_queue.max = 0
      end
   end
end

function read_crafting_slot(pindex)
   recipe = players[pindex].crafting.lua_recipes[players[pindex].crafting.category][players[pindex].crafting.index]
   if recipe.valid == true then
      if recipe.category == "smelting" then
         printout(recipe.name .. " can only be crafted by a furnace.", pindex)
      else
         printout(recipe.name .. " " .. recipe.category .. " " .. recipe.group.name .. " " .. game.get_player(pindex).get_craftable_count(recipe.name), pindex)
      end
      else
      printout("Blank",pindex)
   end
end



function read_inventory_slot(pindex)
   local stack = players[pindex].inventory.lua_inventory[players[pindex].inventory.index]
   if stack.valid_for_read and stack.valid == true then
      printout(stack.name .. " x " .. stack.count .. " " .. stack.prototype.subgroup.name , pindex)
      else
      printout("Empty Slot",pindex)
   end
end


function set_quick_bar(index, pindex)
   local page = game.get_player(pindex).get_active_quick_bar_page(1)-1
   local stack = players[pindex].inventory.lua_inventory[players[pindex].inventory.index]
   if stack.valid_for_read and stack.valid == true then
      game.get_player(pindex).set_quick_bar_slot(index + 10*page, stack) 
      printout("Assigned " .. index, pindex)

   else
      game.get_player(pindex).set_quick_bar_slot(index + 10*page, nil) 
      printout("Unassigned " .. index, pindex)
   end
end

function read_hand(pindex)
   local cursor_stack=game.get_player(pindex).cursor_stack
   if cursor_stack and cursor_stack.valid and cursor_stack.valid_for_read then
      local out={"access.cursor-description"}
      table.insert(out,cursor_stack.prototype.localised_name)
      local build_entity = cursor_stack.prototype.place_result
      if build_entity and build_entity.supports_direction then
         table.insert(out,1)
         table.insert(out,{"access.facing-direction",players[pindex].building_direction*2})
      else
         table.insert(out,0)
         table.insert(out,"")
      end
      table.insert(out,cursor_stack.count)
      local extra = game.get_player(pindex).character.get_main_inventory().get_item_count(cursor_stack.name)
      if extra > 0 then
         table.insert(out,cursor_stack.count+extra)
      else
         table.insert(out,0)
      end
      printout(out, pindex)
   else
      printout({"access.empty_cursor"}, pindex)
   end
end

function read_quick_bar(index,pindex)
   page = game.get_player(pindex).get_active_quick_bar_page(1)-1
   local item = game.get_player(pindex).get_quick_bar_slot(index+ 10*page)
   if item ~= nil then
      local count = game.get_player(pindex).character.get_main_inventory().get_item_count(item.name)
      local stack = game.get_player(pindex).cursor_stack
      if stack.valid_for_read then
         count = count + stack.count
         printout("unselected " .. item.name .. " x " .. count, pindex)
      else
         printout("selected " .. item.name .. " x " .. count, pindex)
      end

   else
      printout("Empty Slot",pindex)
   end

end

function target(pindex)
      move_cursor_map(players[pindex].cursor_pos,pindex)
end
function move_cursor_map(position,pindex)
   player = game.get_player(pindex)
   move_cursor((position.x-player.position.x)*players[pindex].scale.x + (players[pindex].resolution.width/2), (position.y - player.position.y) * players[pindex].scale.y + (players[pindex].resolution.height/2), pindex)
end
function move_cursor(x,y, pindex)
   if x >= 0 and y >=0 and x < players[pindex].resolution.width and y < players[pindex].resolution.height then
      print ("setCursor " .. math.ceil(x) .. "," .. math.ceil(y))
   end
end

function scale_stop(position, pindex)
   player = game.get_player(pindex)
   move_cursor(players[pindex].resolution.width/2, players[pindex].resolution.height/2, pindex)
   x1 = player.position.x
   y1 = player.position.y
   x2 = position.x
   y2 = position.y
   dx = math.abs(x2-x1)
   dy = math.abs(y2-y1)
   pptx = players[pindex].resolution.width/dx/2
   ppty = players[pindex].resolution.height/dy/2
   players[pindex].scale.x = math.floor(pptx + .5)
   players[pindex].scale.y = math.floor(ppty + .5)

   local success = true
   if pptx > 50 or ppty > 50 then
      success = false
   end
   printout("Callibration complete", pindex)
   game.speed = 1
   players[pindex].in_menu = false
   players[pindex].menu = "none"
   local check = true
   for i = 1, #players,1 do
      if players[i].menu == "prompt" then
         check = false
      end
   end
   if check then
      script.on_event("prompt", nil)
   end
   if not(success) then
      scale_start(pindex)
   end
end

function scale_start(pindex)
   local player = game.get_player(pindex)
   players[pindex].resolution = player.display_resolution
   print ("resx="..players[pindex].resolution.width)
   print ("resy="..players[pindex].resolution.height)
      
   move_cursor(0,0,pindex)
   if #players < 2 then
--      game.speed = .1
      end
   printout("Calibration Started.  Press space to continue", pindex)
   players[pindex].in_menu = true
   players[pindex].menu = "prompt"
   script.on_event("prompt", function(event)
      if event.player_index == pindex then
         scale_stop(event.cursor_position,pindex)
      end
   end)
      
end



function tile_cycle(pindex)
   players[pindex].tile.index = players[pindex].tile.index + 1

   if players[pindex].tile.index > #players[pindex].tile.ents + 1 then
      players[pindex].tile.index = 1
      printout(players[pindex].tile.tile, pindex)
   else
      if players[pindex].tile.ents[players[pindex].tile.index - 1].valid then
         result = ""
         local ent = players[pindex].tile.ents[players[pindex].tile.index - 1]
         result = ent.name
         result = result .. " " .. ent.type .. " "
         if ent.type == "resource" then
            result = result .. " x " .. ent.amount
         end
         if ent.prototype.is_building and ent.prototype.supports_direction then
            result = result .. "Facing "
            if ent.direction == 0 then 
               result = result .. "North "
            elseif ent.direction == 4 then
               result = result .. "South "
            elseif ent.direction == 6 then
               result = result .. "West "
            elseif ent.direction == 2 then
               result = result .. "East "
            end
         end
         if ent.prototype.type == "generator" then
            local power1 = ent.energy_generated_last_tick * 60
            local power2 = ent.prototype.max_energy_production * 60
            if power2 ~= nil then
               result = result .. "Producing " .. get_power_string(power1) .. " / " .. get_power_string(power2) .. " "
            else
               result = result .. "Producing " .. get_power_string(power1) .. " "
            end
         end
         if ent.prototype.type == "underground-belt" and ent.neighbours ~= nil then
            result = result .. distance(ent.position, ent.neighbours.position) .. " " .. direction(ent.position, ent.neighbours.position)
         elseif (ent.prototype.type  == "pipe" or ent.prototype.type == "pipe-to-ground") and ent.neighbours ~= nil then
            for i, v in pairs(ent.neighbours) do
               for i1, v1 in pairs(v) do
                  result = result .. distance(ent.position, v1.position) .. " " .. direction(ent.position, v1.position)
               end
            end
         end
         printout(result, pindex)


      end
   end
end
      


function check_for_player(index)
   if players[index] == nil then
   initialize(game.get_player(index))
   end
end

function printout(str, pindex)
   players[pindex].last = str
   localised_print({"","out ",str})
end

function repeat_last_spoken (pindex)
   printout(players[pindex].last, pindex)
end

function scan_index(pindex)
   if (players[pindex].nearby.category == 1 and next(players[pindex].nearby.ents) == nil) or (players[pindex].nearby.category == 2 and next(players[pindex].nearby.resources) == nil) or (players[pindex].nearby.category == 3 and next(players[pindex].nearby.containers) == nil) or (players[pindex].nearby.category == 4 and next(players[pindex].nearby.buildings) == nil) or (players[pindex].nearby.category == 5 and next(players[pindex].nearby.other) == nil) then
      printout("No entities found.  Try refreshing with end key.", pindex)
   else
      local ents = {}
      if players[pindex].nearby.category == 1 then
         ents = players[pindex].nearby.ents
      elseif players[pindex].nearby.category == 2 then
         ents = players[pindex].nearby.resources
      elseif players[pindex].nearby.category == 3 then
         ents = players[pindex].nearby.containers
      elseif players[pindex].nearby.category == 4 then
         ents = players[pindex].nearby.buildings
      elseif players[pindex].nearby.category == 5 then
         ents = players[pindex].nearby.other
      end
      local ent = nil
      if ents[players[pindex].nearby.index].name == "water" then
         table.sort(ents[players[pindex].nearby.index].ents, function(k1, k2) 
            local pos = game.get_player(pindex).position
            return distance(pos, k1.position) < distance(pos, k2.position)
         end)
         ent = ents[players[pindex].nearby.index].ents[1]
         while ent.valid ~= true do
            table.remove(ents[players[pindex].nearby.index].ents, 1)
            ent = ents[players[pindex].nearby.index].ents[1]
         end
      else
         local i = 1
         while i <= #ents[players[pindex].nearby.index].ents do
            if ents[players[pindex].nearby.index].ents[i].valid then
               i = i + 1
            else
               table.remove(ents[players[pindex].nearby.index].ents, i)
            end
         end
         if #ents[players[pindex].nearby.index].ents == 0 then
            table.remove(ents,players[pindex].nearby.index)
            players[pindex].nearby.index = math.min(players[pindex].nearby.index, #ents)
            scan_index(pindex)
            return
         end
         ent = game.get_player(pindex).surface.get_closest(game.get_player(pindex).position, ents[players[pindex].nearby.index].ents)
      end
      if players[pindex].nearby.count == false then
         printout (ent.name .. " " .. math.floor(distance(game.get_player(pindex).position, ent.position)) .. " " .. direction(game.get_player(pindex).position, ent.position), pindex)
      else
         printout (ent.name .. " x " .. ents[players[pindex].nearby.index].count , pindex)
      end
   end
 end
   

function scan_down(pindex)
   if (players[pindex].nearby.category == 1 and players[pindex].nearby.index < #players[pindex].nearby.ents) or (players[pindex].nearby.category == 2 and players[pindex].nearby.index < #players[pindex].nearby.resources) or (players[pindex].nearby.category == 3 and players[pindex].nearby.index < #players[pindex].nearby.containers) or (players[pindex].nearby.category == 4 and players[pindex].nearby.index < #players[pindex].nearby.buildings)  or (players[pindex].nearby.category == 5 and players[pindex].nearby.index < #players[pindex].nearby.other) then
      players[pindex].nearby.index = players[pindex].nearby.index + 1
   end
--   if not(pcall(function()
      scan_index(pindex)
--   end)) then
--      if players[pindex].nearby.category == 1 then
--         table.remove(players[pindex].nearby.ents, players[pindex].nearby.index)
--      elseif players[pindex].nearby.category == 2 then
--         table.remove(players[pindex].nearby.resources, players[pindex].nearby.index)
--      elseif players[pindex].nearby.category == 3 then
--         table.remove(players[pindex].nearby.containers, players[pindex].nearby.index)
--      elseif players[pindex].nearby.category == 4 then
--         table.remove(players[pindex].nearby.buildings, players[pindex].nearby.index)
--      elseif players[pindex].nearby.category == 5 then
--         table.remove(players[pindex].nearby.other, players[pindex].nearby.index)
--      end
--      scan_up(pindex)
--      scan_down(pindex)
--   end
end

function scan_up(pindex)
   if players[pindex].nearby.index > 1 then
      players[pindex].nearby.index = players[pindex].nearby.index - 1
   end
   if not(pcall(function()
scan_index(pindex)
end)) then
      if players[pindex].nearby.category == 1 then
         table.remove(players[pindex].nearby.ents, players[pindex].nearby.index)
      elseif players[pindex].nearby.category == 2 then
         table.remove(players[pindex].nearby.resources, players[pindex].nearby.index)
      elseif players[pindex].nearby.category == 3 then
         table.remove(players[pindex].nearby.containers, players[pindex].nearby.index)
      elseif players[pindex].nearby.category == 4 then
         table.remove(players[pindex].nearby.buildings, players[pindex].nearby.index)
      elseif players[pindex].nearby.category == 5 then
         table.remove(players[pindex].nearby.other, players[pindex].nearby.index)
      end
      scan_down(pindex)
      scan_up(pindex)
   end
 end

function scan_middle(pindex)
   local ents = {}
   if players[pindex].nearby.category == 1 then
      ents = players[pindex].nearby.ents
   elseif players[pindex].nearby.category == 2 then
      ents = players[pindex].nearby.resources
   elseif players[pindex].nearby.category == 3 then
      ents = players[pindex].nearby.containers
   elseif players[pindex].nearby.category == 4 then
      ents = players[pindex].nearby.buildings
   elseif players[pindex].nearby.category == 5 then
      ents = players[pindex].nearby.other
   end

   if players[pindex].nearby.index < 1 then
      players[pindex].nearby.index = 1
   elseif players[pindex].nearby.index > #ents then
      players[pindex].nearby.index = #ents
   end

   if not(pcall(function()
      scan_index(pindex)
   end)) then
      table.remove(ents, players[pindex].nearby.index)
      scan_middle(pindex)
   end
 end



function rescan(pindex)
   players[pindex].nearby.index = 1
   first_player = game.get_player(pindex)
   players[pindex].nearby.ents = scan_area(math.floor(first_player.position.x)-100, math.floor(first_player.position.y)-100, 200, 200, pindex)
   populate_categories(pindex)
end

directions={
   [defines.direction.north]="North",
   [defines.direction.northeast]="Northeast",
   [defines.direction.east]="East",
   [defines.direction.southeast]="Southeast",
   [defines.direction.south]="South",
   [defines.direction.southwest]="Southwest",
   [defines.direction.west]="West",
   [defines.direction.northwest]="Northwest",
   [8] = ""
}

function direction (pos1, pos2)
   local x1 = pos1.x
   local x2 = pos2.x
   local dx = x2 - x1
   local y1 = pos1.y
   local y2 = pos2.y
   local dy = y2 - y1
   local dir = math.floor(10.5 + 4*math.atan2(dy,dx)/math.pi)%8
   if dx == 0 and dy == 0 then
      dir = 8
   end
   return directions[dir]
end
function distance ( pos1, pos2)
   local x1 = pos1.x
   local x2 = pos2.x
  local dx = math.abs(x2 - x1)
   local y1 = pos1.y
   local y2 = pos2.y
  local dy = math.abs(y2 - y1)
   if direction(pos1,pos2) == "North" then 
   end
  return math.abs(math.sqrt (dx * dx + dy * dy ))
end

function index_of_entity(array, value)
   if next(array) == nil then
      return nil
   end
    for i = 1, #array,1 do
        if array[i].name == value then
            return i
      end
   end
   return nil
end

function scan_area (x,y,w,h, pindex)
   local first_player = game.get_player(pindex)
   local surf = first_player.surface
   local ents = surf.find_entities_filtered{area = {{x, y},{x+w, y+h}}}
   local result = {}
   local waters = surf.find_tiles_filtered{area = {{x, y},{x+w, y+h}}, name = "water"}
   if next(waters) ~= nil then
      table.insert(result, {name = waters[1].name, count = #waters, ents=waters})
   end

   while next(result) ~= nil and #result[1].ents > 100 do
      table.remove(result[1].ents, math.random(#result[1].ents))
   end

   for i=1, #ents, 1 do
      index = index_of_entity(result, ents[i].name)
      if index == nil then
         table.insert(result, {name = ents[i].name, count = 1, ents = {ents[i]}})

      elseif #result[index] >= 100 then
         table.remove(result[index].ents, math.random(100))
         table.insert(result[index].ents, ents[i])
         result[index].count = result[index].count + 1

      else
         table.insert(result[index].ents, ents[i])
         result[index].count = result[index].count + 1

         
--         result[index] = ents[i]
      end
   end
   if players[pindex].nearby.count == false then
      table.sort(result, function(k1, k2) 
         local pos = game.get_player(pindex).position
         local ent1 = nil
         local ent2 = nil
         if k1.name == "water" then
            table.sort( k1.ents , function(k3, k4) 
               return distance(pos, k3.position) < distance(pos, k4.position)
            end)
            ent1 = k1.ents[1]
         else
            ent1 = surf.get_closest(pos, k1.ents)
         end
         if k2.name == "water" then
            table.sort( k2.ents , function(k3, k4) 
               return distance(pos, k3.position) < distance(pos, k4.position)
            end)
            ent2 = k2.ents[1]
         else
         ent2 = surf.get_closest(pos, k2.ents)
         end
         return distance(pos, ent1.position) < distance(pos, ent2.position)
      end)
   else
      table.sort(result, function(k1, k2)
         return k1.count > k2.count
      end)
   end

   return result
end

function toggle_cursor(pindex)
   if not(players[pindex].cursor) then
      printout("Cursor enabled.", pindex)
      players[pindex].cursor = true
   else
      printout("Cursor disabled", pindex)
      players[pindex].cursor = false
      players[pindex].cursor_pos = offset_position(players[pindex].position,players[pindex].player_direction,1)
      target(pindex)
   end
end

function teleport_to_cursor(pindex)
   first_player = game.get_player(pindex)
   can_port = first_player.surface.can_place_entity{name = "character", position = players[pindex].cursor_pos}
   if can_port then
      teleported = first_player.teleport(players[pindex].cursor_pos)
      if teleported then
         read_tile(pindex)
         players[pindex].position=table.deepcopy(players[pindex].cursor_pos)

      else
         printout("Teleport Failed", pindex)
      end
   else
      printout("Tile Occupied", pindex)
   end
end
function jump_to_player(pindex)
   local first_player = game.get_player(pindex)
   players[pindex].cursor_pos.x = math.floor(first_player.position.x)+.5
   players[pindex].cursor_pos.y = math.floor(first_player.position.y) + .5
   read_coords(pindex)
end

   

function read_tile(pindex)   
   local surf = game.get_player(pindex).surface
   local result = ""
   players[pindex].tile.ents = surf.find_entities_filtered{area = {{players[pindex].cursor_pos.x - .5, players[pindex].cursor_pos.y - .5}, {players[pindex].cursor_pos.x+ .29 , players[pindex].cursor_pos.y + .29}}} 
   if not(pcall(function()
      players[pindex].tile.tile =  surf.get_tile(players[pindex].cursor_pos.x, players[pindex].cursor_pos.y).name
   end)) then
      printout("Tile out of range", pindex)
      return
   end
   if next(players[pindex].tile.ents) == nil then
      result = players[pindex].tile.tile
   else
      local ent = players[pindex].tile.ents[1]
      result = ent.name
      result = result .. " " .. ent.type .. " "
      if ent.type == "resource" then
         result = result .. " x " .. ent.amount
      end
      if ent.prototype.is_building and ent.prototype.supports_direction then
         result = result .. "Facing "
         if ent.direction == 0 then 
            result = result .. "North "
         elseif ent.direction == 4 then
            result = result .. "South "
         elseif ent.direction == 6 then
            result = result .. "West "
         elseif ent.direction == 2 then
            result = result .. "East "
         end
      end
      if ent.prototype.type == "generator" then
         local power1 = ent.energy_generated_last_tick * 60
         local power2 = ent.prototype.max_energy_production * 60
         if power2 ~= nil then
            result = result .. "Producing " .. get_power_string(power1) .. " / " .. get_power_string(power2) .. " "
         else
            result = result .. "Producing " .. get_power_string(power1) .. " "
         end
      end
      if ent.prototype.type == "underground-belt" and ent.neighbours ~= nil then
         result = result .. distance(ent.position, ent.neighbours.position) .. " " .. direction(ent.position, ent.neighbours.position)
      elseif (ent.prototype.type  == "pipe" or ent.prototype.type == "pipe-to-ground") and ent.neighbours ~= nil then
         for i, v in pairs(ent.neighbours) do
            for i1, v1 in pairs(v) do
               result = result .. distance(ent.position, v1.position) .. " " .. direction(ent.position, v1.position)
            end
         end
      elseif next(ent.prototype.fluidbox_prototypes) ~= nil then
         local relative_position = {x = players[pindex].cursor_pos.x - ent.position.x, y = players[pindex].cursor_pos.y - ent.position.y}
         local direction = ent.direction/2
         for i, box in pairs(ent.prototype.fluidbox_prototypes) do
            for i1, pipe in pairs(box.pipe_connections) do
               local adjusted = get_adjacent_source(ent.prototype.selection_box, pipe.positions[direction + 1], direction)
               if adjusted.position.x == relative_position.x and adjusted.position.y == relative_position.y then
                  result = result .. pipe.type .. " 1 " .. adjusted.direction .. " "
               end
            end
         end
      end
      if ent.type == "electric-pole" then
         result = result .. #ent.neighbours.copper
         local power = 0
         for i, v in pairs(ent.electric_network_statistics.output_counts) do
            power = power + (ent.electric_network_statistics.get_flow_count{name = i, input = false, precision_index = defines.flow_precision_index.five_seconds})
      end
         power = power * 60
         if power > 1000000000000 then
            power = power/1000000000000
            result = result .. string.format(" %.3f Terawatts", power) 
         elseif power > 1000000000 then
            power = power / 1000000000
            result = result .. string.format(" %.3f Gigawatts", power) 
         elseif power > 1000000 then
            power = power / 1000000
            result = result .. string.format(" %.3f Megawatts", power) 
         elseif power > 1000 then
            power = power / 1000
            result = result .. string.format(" %.3f Kilowatts", power) 
         else
            result = result .. string.format(" %.3f Watts", power) 
      end




                     
      end
      if ent.prototype.electric_energy_source_prototype ~= nil and ent.is_connected_to_electric_network() == false then
         result = result .. "Not Connected"
      end
      if ent.drop_position ~= nil then
         local position = ent.drop_position
         local direction = ent.direction /2
         local increment = 1
         if ent.type == "inserter" then
            direction = (direction + 2) % 4
            if ent.name == "long-handed-inserter" then
               increment = 2
            end
         end
         if direction == 0 then
            position.y = position.y + increment
         elseif direction == 2 then
            position.y = position.y - increment
         elseif direction == 3 then
            position.x = position.x + increment
         elseif direction == 1 then
            position.x = position.x - increment
         end
--         result = result .. math.floor(position.x) .. " " .. math.floor(position.y) .. " " .. direction .. " "
         if math.floor(players[pindex].cursor_pos.x) == math.floor(position.x) and math.floor(players[pindex].cursor_pos.y) == math.floor(position.y) then
            result = result .. " Output " .. increment .. " "
            if direction == 0 then
               result = result .. "North "
            elseif direction == 2 then
               result = result .. "South "
            elseif direction == 3 then
               result = result .. "West " 
            elseif direction == 1 then
               result = result .. "East "
            end
         end
      end
--      players[pindex].tile.index = # players[pindex].tile.ents+1
      players[pindex].tile.index = 2
      players[pindex].tile.previous = ent
   end
   if next(players[pindex].tile.ents) == nil or players[pindex].tile.ents[1].type == "resource" then
      local stack = game.get_player(pindex).cursor_stack
      if stack.valid_for_read and stack.valid and stack.prototype.place_result ~= nil and stack.prototype.place_result.type == "electric-pole" then
         local ent = stack.prototype.place_result
         local position = table.deepcopy(players[pindex].cursor_pos)
         local dict = game.get_filtered_entity_prototypes{{filter = "type", type = "electric-pole"}}
         local poles = {}
         for i, v in pairs(dict) do
            table.insert(poles, v)
         end
         table.sort(poles, function(k1, k2) return k1.max_wire_distance < k2.max_wire_distance end)
         local check = false
         for i, pole in ipairs(poles) do
            names = {}
            for i1 = i, #poles, 1 do
               table.insert(names, poles[i1].name)
            end
            local T = {
               position = position,
               radius = pole.max_wire_distance,
               name = names
            }
            if #surf.find_entities_filtered(T) > 0 then
               check = true
               break
            end
         if stack.name == pole.name then
            break
         end
      end
         if check then
            result = result .. " " .. "connected"
         else
            result = result .. "Not Connected"
         end
      elseif stack.valid_for_read and stack.valid and stack.prototype.place_result ~= nil and  stack.prototype.place_result.electric_energy_source_prototype ~= nil then
         local ent = stack.prototype.place_result
         local position = table.deepcopy(players[pindex].cursor_pos)
         if players[pindex].cursor then
               position.x = position.x + math.ceil(2*ent.selection_box.right_bottom.x)/2 - .5
               position.y = position.y + math.ceil(2*ent.selection_box.right_bottom.y)/2 - .5
         elseif players[pindex].player_direction == defines.direction.north then
            if players[pindex].building_direction == 0 or players[pindex].building_direction == 2 then
               position.y = position.y + math.ceil(2* ent.selection_box.left_top.y)/2 + .5
            elseif players[pindex].building_direction == 1 or players[pindex].building_direction == 3 then
            position.y = position.y + math.ceil(2* ent.selection_box.left_top.x)/2 + .5
            end
         elseif players[pindex].player_direction == defines.direction.south then
            if players[pindex].building_direction == 0 or players[pindex].building_direction == 2 then
               position.y = position.y + math.ceil(2* ent.selection_box.right_bottom.y)/2 - .5
            elseif players[pindex].building_direction == 1 or players[pindex].building_direction == 3 then
               position.y = position.y + math.ceil(2* ent.selection_box.right_bottom.x)/2 - .5
            end
         elseif players[pindex].player_direction == defines.direction.west then
            if players[pindex].building_direction == 0 or players[pindex].building_direction == 2 then
               position.x = position.x + math.ceil(2* ent.selection_box.left_top.x)/2 + .5
            elseif players[pindex].building_direction == 1 or players[pindex].building_direction == 3 then
               position.x = position.x + math.ceil(2* ent.selection_box.left_top.y)/2 + .5
            end

         elseif players[pindex].player_direction == defines.direction.east then
            if players[pindex].building_direction == 0 or players[pindex].building_direction == 2 then
               position.x = position.x + math.ceil(2* ent.selection_box.right_bottom.x)/2 - .5
            elseif players[pindex].building_direction == 1 or players[pindex].building_direction == 3 then
               position.x = position.x + math.ceil(2* ent.selection_box.right_bottom.y)/2 - .5
            end
         end
         local dict = game.get_filtered_entity_prototypes{{filter = "type", type = "electric-pole"}}
         local poles = {}
         for i, v in pairs(dict) do
            table.insert(poles, v)
         end
         table.sort(poles, function(k1, k2) return k1.supply_area_distance < k2.supply_area_distance end)
         local check = false
         for i, pole in ipairs(poles) do
            local names = {}
            for i1 = i, #poles, 1 do
               table.insert(names, poles[i1].name)
            end
            local area = {
               left_top = {(position.x + math.ceil(ent.selection_box.left_top.x) - pole.supply_area_distance), (position.y + math.ceil(ent.selection_box.left_top.y) - pole.supply_area_distance)},
               right_bottom = {position.x + math.floor(ent.selection_box.right_bottom.x) + pole.supply_area_distance, position.y + math.floor(ent.selection_box.right_bottom.y) + pole.supply_area_distance},
               orientation = players[pindex].building_direction/4
           }
            local T = {
               area = area,
               name = names
            }
            if #surf.find_entities_filtered(T) > 0 then
               check = true
               break
            end
         end
         if check then
            result = result .. " " .. "connected"
         else
            result = result .. "Not Connected"
         end
      end
   end
   printout(result, pindex)
end


function read_coords(pindex)
   if not(players[pindex].in_menu) then
      printout(math.floor(players[pindex].cursor_pos.x) .. ", " .. math.floor(players[pindex].cursor_pos.y), pindex)
   elseif players[pindex].menu == "inventory" then
      local x = players[pindex].inventory.index %10
      local y = math.floor(players[pindex].inventory.index/10) + 1
      if x == 0 then
         x = x + 10
         y = y - 1
      end
      printout(x .. ", " .. y, pindex)
   elseif players[pindex].menu == "crafting" then
      printout("Ingredients:",pindex)
      recipe = players[pindex].crafting.lua_recipes[players[pindex].crafting.category][players[pindex].crafting.index]
      result = ""
      for i, v in pairs(recipe.ingredients) do
         result = result .. ", " .. v.name .. " x" .. v.amount
      end
      printout(string.sub(result, 3), pindex)
   elseif players[pindex].menu == "technology" then
      local techs = {}
      if players[pindex].technology.category == 1 then
         techs = players[pindex].technology.lua_researchable
      elseif players[pindex].technology.category == 2 then
         techs = players[pindex].technology.lua_locked
      elseif players[pindex].technology.category == 3 then
         techs = players[pindex].technology.lua_unlocked
      end
   
      if next(techs) ~= nil and players[pindex].technology.index > 0 and players[pindex].technology.index <= #techs then
         local result = "Requires "
         if #techs[players[pindex].technology.index].prerequisites < 1 then
            result = result .. " No prior research "
         end
         for i, preq in pairs(techs[players[pindex].technology.index].prerequisites) do 
            result = result .. preq.name .. " , "
         end
         result = result .. " and " .. techs[players[pindex].technology.index].research_unit_count .. " x "
         for i, ingredient in pairs(techs[players[pindex].technology.index].research_unit_ingredients ) do
            result = result .. ingredient.name .. " " .. " , "
         end
         
         printout(string.sub(result, 1, -3), pindex)
      end
   end
end

function initialize(player)
   index = player.index
   player.character_reach_distance_bonus = math.max(player.character_reach_distance_bonus, 1)
--   player.surface.daytime = .5
   players[index] = {
      player = player,
      in_menu = false,
      in_item_selector = false,
      on_target = false,
      menu = "none",
      cursor = false,
      cursor_pos = nil,
      cursor_size = 0 ,
      scale = {x,y},
      num_elements = 0,
      player_direction = player.walking_state.direction,
      position = {x= math.floor(player.position.x) + .5, y= math.floor(player.position.y)+.5},
      walk = 0,
      move_queue = {},
      building_direction = 0,
      direction_lag = true,
      previous_item = "",
      nearby = nil,
      tile = nil,
      inventory = nil,
      crafting = nil,
      crafting_queue = nil,
      technology = nil,
      building = nil,
      belt = nil,
      pump = nil,
      last = "",
      item_selection = false,
      item_cache = {},
      item_selector = {},
      resolution = nil
   }
   players[index].cursor_pos = offset_position(players[index].position,players[index].player_direction,1)
   players[index].nearby = {
      index = 0,
      count = false,
      category = 1,
      ents = {},
      resources = {},
      containers = {},
      buildings = {},
      other = {}
   }
   players[index].nearby.ents = {}

   players[index].tile = {
      ents = {},
      tile = "",
      index = 1,
      previous = nil
   }

   players[index].inventory = {
      lua_inventory = nil,
      max = 0,
      index = 1
   }

   players[index].crafting = {
      lua_recipes = nil,
      max = 0,
      index = 1,
      category = 1
   }

   players[index].crafting_queue = {
      index = 1,
      max = 0,
      lua_queue = nil
   }

   players[index].technology = {
      index = 1,
      category = 1,
      lua_researchable = {},
      lua_unlocked = {},
      lua_locked = {}
   }

   players[index].building = {
      index = 0,
      ent = nil,
      sectors = nil,
      sector = 0,
      recipe_selection = false,
      item_selection = false,
      category = 0,
      recipe = nil,
      recipe_list = nil
   }

   players[index].belt = {
      index = 1,
      sector = 1,
      ent = nil,
      line1 = nil,
      line2 = nil
   }

   players[index].pump = {
      index = 0,
      positions = {}
   }

   players[index].item_selector = {
      index = 0,
      group = 0,
      subgroup = 0
   }


   scale_start(index)
--   player.insert{name="pipe", count=100}
--   printout("Character loaded." .. #game.surfaces,  player.index)
--   player.insert{name="accumulator", count=10}
--   player.insert{name="beacon", count=10}
--   player.insert{name="boiler", count=10}
--   player.insert{name="centrifuge", count=10}
--   player.insert{name="chemical-plant", count=10}
--   player.insert{name="electric-mining-drill", count=10}
--   player.insert{name="heat-exchanger", count=10}
--   player.insert{name="nuclear-reactor", count=10}
--   player.insert{name="offshore-pump", count=10}
--   player.insert{name="oil-refinery", count=10}
--   player.insert{name="pumpjack", count=10}
--   player.insert{name="rocket-silo", count=1}
--   player.insert{name="steam-engine", count=10}
--   player.insert{name="wooden-chest", count=10}
--   player.insert{name="assembling-machine-1", count=10}
--   player.insert{name="gun-turret", count=10}
--   player.insert{name="transport-belt", count=100}
--   player.insert{name="coal", count=100}
--   player.insert{name="filter-inserter", count=10}
--   player.insert{name="fast-transport-belt", count=100}
--   player.insert{name="express-transport-belt", count=100}
--   player.insert{name="small-electric-pole", count=100}
--   player.insert{name="big-electric-pole", count=100}
--   player.insert{name="substation", count=100}
--   player.insert{name="solar-panel", count=100}
--   player.insert{name="pipe-to-ground", count=100}
--   player.insert{name="underground-belt", count=100}

--   player.force.research_all_technologies()

   script.on_event(defines.events.on_player_changed_position,function(event)
      local pindex = event.player_index
      check_for_player(pindex)
      if players[pindex].walk == 2 then
         local pos = game.get_player(pindex).position
         pos.x = math.floor(pos.x)+0.5
         pos.y = math.floor(pos.y)+0.5
         if game.get_player(pindex).walking_state.direction ~= players[pindex].direction then
            players[pindex].direction = game.get_player(pindex).walking_state.direction
            local new_pos = offset_position(pos,players[pindex].direction,1)
            players[pindex].cursor_pos = new_pos
            players[pindex].position = pos
--            target(pindex)
         else
         
            players[pindex].cursor_pos.x = players[pindex].cursor_pos.x + pos.x - players[pindex].position.x
            players[pindex].cursor_pos.y = players[pindex].cursor_pos.y + pos.y - players[pindex].position.y
            players[pindex].position = pos
         end
         -- print("checking:".. players[pindex].cursor_pos.x .. "," .. players[pindex].cursor_pos.y)
         if not game.get_player(pindex).surface.can_place_entity{name = "character", position = players[pindex].cursor_pos} then
            read_tile(pindex)
            target(pindex)
         end
      end
   end)


end


function menu_cursor_move(direction,pindex)
   if     direction == defines.direction.north then
      menu_cursor_up(pindex)
   elseif direction == defines.direction.south then
      menu_cursor_down(pindex)
   elseif direction == defines.direction.east  then
      menu_cursor_right(pindex)
   elseif direction == defines.direction.west  then
      menu_cursor_left(pindex)
   end
end 

function menu_cursor_up(pindex)
   if players[pindex].item_selection then
      if players[pindex].item_selector.group == 0 then
         printout("Blank", pindex)
      elseif players[pindex].item_selector.subgroup == 0 then
         players[pindex].item_cache = get_iterable_array(game.item_group_prototypes)
         prune_item_groups(players[pindex].item_cache)
         players[pindex].item_selector.index = players[pindex].item_selector.group
         players[pindex].item_selector.group = 0
         read_item_selector_slot(pindex)
      else
         local group = players[pindex].item_cache[players[pindex].item_selector.index].group
         players[pindex].item_cache = get_iterable_array(group.subgroups)
         prune_item_groups(players[pindex].item_cache)

         players[pindex].item_selector.index = players[pindex].item_selector.subgroup
         players[pindex].item_selector.subgroup = 0
         read_item_selector_slot(pindex)
               end         

   elseif players[pindex].menu == "inventory" then
      players[pindex].inventory.index = players[pindex].inventory.index -10
      if players[pindex].inventory.index < 1 then
         players[pindex].inventory.index = players[pindex].inventory.max + players[pindex].inventory.index
      

      end
      read_inventory_slot(pindex)

   elseif players[pindex].menu == "crafting" then
      players[pindex].crafting.index = 1
      players[pindex].crafting.category = players[pindex].crafting.category - 1

      if players[pindex].crafting.category < 1 then
         players[pindex].crafting.category = players[pindex].crafting.max
      end
      read_crafting_slot(pindex)
   elseif players[pindex].menu == "crafting_queue" then   
      load_crafting_queue(pindex)
      players[pindex].crafting_queue.index = 1
      read_crafting_queue(pindex)
   elseif players[pindex].menu == "building" then
      if players[pindex].building.sector <= #players[pindex].building.sectors then
         if players[pindex].building.sectors[players[pindex].building.sector].inventory == nil or #players[pindex].building.sectors[players[pindex].building.sector].inventory < 1 then
            printout("blank", pindex)
            return
         end
         if #players[pindex].building.sectors[players[pindex].building.sector].inventory > 10 then
            players[pindex].building.index = players[pindex].building.index - 8
            if players[pindex].building.index < 1 then
               players[pindex].building.index = players[pindex].building.index + #players[pindex].building.sectors[players[pindex].building.sector].inventory 
            end
         else
            players[pindex].building.index = 1
         end
         read_building_slot(pindex)
      elseif players[pindex].building.recipe_list == nil then
         players[pindex].inventory.index = players[pindex].inventory.index -10
         if players[pindex].inventory.index < 1 then
            players[pindex].inventory.index = players[pindex].inventory.max + players[pindex].inventory.index
         end
         read_inventory_slot(pindex)
      else
         if players[pindex].building.sector == #players[pindex].building.sectors + 1 then
            if players[pindex].building.recipe_selection then
               players[pindex].building.category = players[pindex].building.category - 1
               players[pindex].building.index = 1
               if players[pindex].building.category < 1 then
                  players[pindex].building.category = #players[pindex].building.recipe_list
               end
            end
            read_building_recipe(pindex)
         else
            players[pindex].inventory.index = players[pindex].inventory.index -10
            if players[pindex].inventory.index < 1 then
               players[pindex].inventory.index = players[pindex].inventory.max + players[pindex].inventory.index
            end
            read_inventory_slot(pindex)
            end
         end
   elseif players[pindex].menu == "technology" then
      if players[pindex].technology.category > 1 then
      players[pindex].technology.category = players[pindex].technology.category - 1
      end
      if players[pindex].technology.category == 1 then
         printout("Researchable ttechnologies", pindex)
      elseif players[pindex].technology.category == 2 then
         printout("Locked technologies", pindex)
      elseif players[pindex].technology.category == 3 then
         printout("Past Research", pindex)
      end
      
   elseif players[pindex].menu == "belt" then
      if players[pindex].belt.sector == 1 and players[pindex].belt.line1.valid and #players[pindex].belt.line1 > 0 then
         players[pindex].belt.index = 1
         read_belt_slot(pindex)
      elseif players[pindex].belt.sector == 2 and players[pindex].belt.line2.valid and #players[pindex].belt.line2 > 0 then
         players[pindex].belt.index = 1
         read_belt_slot(pindex)
      end
   elseif players[pindex].menu == "pump" then
      players[pindex].pump.index = math.max(1, players[pindex].pump.index - 1)      
      local dir = ""
      if players[pindex].pump.positions[players[pindex].pump.index].direction == 0 then
         dir = " North"
      elseif players[pindex].pump.positions[players[pindex].pump.index].direction == 4 then
         dir = " South"
      elseif players[pindex].pump.positions[players[pindex].pump.index].direction == 2 then
         dir = " East"
      elseif players[pindex].pump.positions[players[pindex].pump.index].direction == 6 then
         dir = " West"
      end

      printout("Option " .. players[pindex].pump.index .. ": " .. math.floor(distance(game.get_player(pindex).position, players[pindex].pump.positions[players[pindex].pump.index].position)) .. " meters " .. direction(game.get_player(pindex).position, players[pindex].pump.positions[players[pindex].pump.index].position) .. " Facing " .. dir, pindex)

   end
end

function menu_cursor_down(pindex)
   if players[pindex].item_selection then
      if players[pindex].item_selector.group == 0 then
         players[pindex].item_selector.group = players[pindex].item_selector.index
         players[pindex].item_cache = get_iterable_array(players[pindex].item_cache[players[pindex].item_selector.group].subgroups)
         prune_item_groups(players[pindex].item_cache)

         players[pindex].item_selector.index = 1
         read_item_selector_slot(pindex)
      elseif players[pindex].item_selector.subgroup == 0 then
         players[pindex].item_selector.subgroup = players[pindex].item_selector.index
         local prototypes = game.get_filtered_item_prototypes{{filter="subgroup",subgroup = players[pindex].item_cache[players[pindex].item_selector.index].name}}
         players[pindex].item_cache = get_iterable_array(prototypes)
         players[pindex].item_selector.index = 1
         read_item_selector_slot(pindex)
      else
         printout("Press left bracket to confirm your selection.", pindex)
               end         

   elseif players[pindex].menu == "inventory" then
      players[pindex].inventory.index = players[pindex].inventory.index +10
      if players[pindex].inventory.index > players[pindex].inventory.max then
         players[pindex].inventory.index = players[pindex].inventory.index - players[pindex].inventory.max
      end
      read_inventory_slot(pindex)

   elseif players[pindex].menu == "crafting" then
      players[pindex].crafting.index = 1
      players[pindex].crafting.category = players[pindex].crafting.category + 1

      if players[pindex].crafting.category > players[pindex].crafting.max then
         players[pindex].crafting.category = 1
      end
      read_crafting_slot(pindex)
   elseif players[pindex].menu == "crafting_queue" then   
      load_crafting_queue(pindex)
      players[pindex].crafting_queue.index = players[pindex].crafting_queue.max
      read_crafting_queue(pindex)
   elseif players[pindex].menu == "building" then
      if players[pindex].building.sector <= #players[pindex].building.sectors then
         if players[pindex].building.sectors[players[pindex].building.sector].inventory == nil or #players[pindex].building.sectors[players[pindex].building.sector].inventory < 1 then
            printout("blank", pindex)
            return
         end

         if #players[pindex].building.sectors[players[pindex].building.sector].inventory > 10 then
            players[pindex].building.index = players[pindex].building.index + 8
            if players[pindex].building.index > #players[pindex].building.sectors[players[pindex].building.sector].inventory then
               players[pindex].building.index = players[pindex].building.index %8
               if players[pindex].building.index < 1 then
                  players[pindex].building.index = 8
               end
            end
         else
            players[pindex].building.index = #players[pindex].building.sectors[players[pindex].building.sector].inventory
         end
         read_building_slot(pindex)
      elseif players[pindex].building.recipe_list == nil then
         players[pindex].inventory.index = players[pindex].inventory.index +10
         if players[pindex].inventory.index > players[pindex].inventory.max then
            players[pindex].inventory.index = players[pindex].inventory.index%10 
         end
         read_inventory_slot(pindex)
      else
         if players[pindex].building.sector == #players[pindex].building.sectors + 1 then
            if players[pindex].building.recipe_selection then
               players[pindex].building.index = 1
               players[pindex].building.category = players[pindex].building.category + 1
               if players[pindex].building.category > #players[pindex].building.recipe_list then
                  players[pindex].building.category = 1
               end
            end
            read_building_recipe(pindex)
         else
            players[pindex].inventory.index = players[pindex].inventory.index +10
            if players[pindex].inventory.index > players[pindex].inventory.max then
               players[pindex].inventory.index = players[pindex].inventory.index%10
            end
            read_inventory_slot(pindex)
            end
         end
   elseif players[pindex].menu == "technology" then
      if players[pindex].technology.category < 3 then
      players[pindex].technology.category = players[pindex].technology.category + 1
      end
      if players[pindex].technology.category == 1 then
         printout("Researchable ttechnologies", pindex)
      elseif players[pindex].technology.category == 2 then
         printout("Locked technologies", pindex)
      elseif players[pindex].technology.category == 3 then
         printout("Past Research", pindex)
      end

   elseif players[pindex].menu == "belt" then
      if players[pindex].belt.sector == 1 and players[pindex].belt.line1.valid and #players[pindex].belt.line1 > 0 then
         players[pindex].belt.index = #players[pindex].belt.line1
         read_belt_slot(pindex)
      elseif players[pindex].belt.sector == 2 and players[pindex].belt.line2.valid and #players[pindex].belt.line2 > 0 then
         players[pindex].belt.index = #players[pindex].belt.line2
         read_belt_slot(pindex)
      end
   elseif players[pindex].menu == "pump" then
      players[pindex].pump.index = math.min(#players[pindex].pump.positions, players[pindex].pump.index + 1)
      local dir = ""
      if players[pindex].pump.positions[players[pindex].pump.index].direction == 0 then
         dir = " North"
      elseif players[pindex].pump.positions[players[pindex].pump.index].direction == 4 then
         dir = " South"
      elseif players[pindex].pump.positions[players[pindex].pump.index].direction == 2 then
         dir = " East"
      elseif players[pindex].pump.positions[players[pindex].pump.index].direction == 6 then
         dir = " West"
      end

      printout("Option " .. players[pindex].pump.index .. ": " .. math.floor(distance(game.get_player(pindex).position, players[pindex].pump.positions[players[pindex].pump.index].position)) .. " meters " .. direction(game.get_player(pindex).position, players[pindex].pump.positions[players[pindex].pump.index].position) .. " Facing " .. dir, pindex)

   end
end

function menu_cursor_left(pindex)
   if players[pindex].item_selection then
         players[pindex].item_selector.index = math.max(1, players[pindex].item_selector.index - 1)
         read_item_selector_slot(pindex)

   elseif players[pindex].menu == "inventory" then
      players[pindex].inventory.index = players[pindex].inventory.index -1
      if players[pindex].inventory.index%10 == 0 then
         players[pindex].inventory.index = players[pindex].inventory.index + 10
      end
      read_inventory_slot(pindex)

   elseif players[pindex].menu == "crafting" then
      players[pindex].crafting.index = players[pindex].crafting.index -1
      if players[pindex].crafting.index < 1 then
         players[pindex].crafting.index = #players[pindex].crafting.lua_recipes[players[pindex].crafting.category]
      end
      read_crafting_slot(pindex)

   elseif players[pindex].menu == "crafting_queue" then
      load_crafting_queue(pindex)
      if players[pindex].crafting_queue.index < 2 then
         players[pindex].crafting_queue.index = players[pindex].crafting_queue.max
      else
         players[pindex].crafting_queue.index = players[pindex].crafting_queue.index - 1
      end
      read_crafting_queue(pindex)
   elseif players[pindex].menu == "building" then
      if players[pindex].building.sector <= #players[pindex].building.sectors then
         if players[pindex].building.sectors[players[pindex].building.sector].inventory == nil or #players[pindex].building.sectors[players[pindex].building.sector].inventory < 1 then
            printout("blank", pindex)
            return
         end

         if #players[pindex].building.sectors[players[pindex].building.sector].inventory > 10 then
            players[pindex].building.index = players[pindex].building.index - 1
            if players[pindex].building.index%8 == 0 then
               players[pindex].building.index = players[pindex].building.index + 8
            end
         else
            players[pindex].building.index = players[pindex].building.index - 1
            if players[pindex].building.index < 1 then
               players[pindex].building.index = #players[pindex].building.sectors[players[pindex].building.sector].inventory
            end
         end
         read_building_slot(pindex)
      elseif players[pindex].building.recipe_list == nil then
         players[pindex].inventory.index = players[pindex].inventory.index -1
         if players[pindex].inventory.index%10 < 1 then
            players[pindex].inventory.index = players[pindex].inventory.index + 10
         end
         read_inventory_slot(pindex)
      else
         if players[pindex].building.sector == #players[pindex].building.sectors + 1 then
            print("recipe should be taken")
            if players[pindex].building.recipe_selection then
               players[pindex].building.index = players[pindex].building.index - 1
               if players[pindex].building.index < 1 then
                  players[pindex].building.index = #players[pindex].building.recipe_list[players[pindex].building.category]
               end
            end
            read_building_recipe(pindex)
         else
            players[pindex].inventory.index = players[pindex].inventory.index -1
            if players[pindex].inventory.index%10 < 1 then
               players[pindex].inventory.index = players[pindex].inventory.index + 10
            end
            read_inventory_slot(pindex)
            end
         end

   elseif players[pindex].menu == "technology" then
      if players[pindex].technology.index > 1 then
         players[pindex].technology.index = players[pindex].technology.index - 1
      end
      read_technology_slot(pindex)
   elseif players[pindex].menu == "belt" then
      if players[pindex].belt.sector == 1 and players[pindex].belt.line1.valid and #players[pindex].belt.line1 > 0 then
         players[pindex].belt.index = players[pindex].belt.index - 1
         if players[pindex].belt.index < 1 or players[pindex].belt.index > #players[pindex].belt.line1 then 
            players[pindex].belt.index = # players[pindex].belt.line1
         end
         read_belt_slot(pindex)
      elseif players[pindex].belt.sector == 2 and players[pindex].belt.line2.valid and #players[pindex].belt.line2 > 0 then
         players[pindex].belt.index = players[pindex].belt.index - 1
         if players[pindex].belt.index < 1 or players[pindex].belt.index > #players[pindex].belt.line2 then
            players[pindex].belt.index = #players[pindex].belt.line2
         end
         read_belt_slot(pindex)
      end



   end
end

function menu_cursor_right(pindex)
   if players[pindex].item_selection then
         players[pindex].item_selector.index = math.min(#players[pindex].item_cache, players[pindex].item_selector.index + 1)
         read_item_selector_slot(pindex)

   elseif players[pindex].menu == "inventory" then
      players[pindex].inventory.index = players[pindex].inventory.index +1
      if players[pindex].inventory.index%10 == 1 then
         players[pindex].inventory.index = players[pindex].inventory.index - 10
      end
      read_inventory_slot(pindex)

   elseif players[pindex].menu == "crafting" then
      players[pindex].crafting.index = players[pindex].crafting.index +1
      if players[pindex].crafting.index > #players[pindex].crafting.lua_recipes[players[pindex].crafting.category] then
         players[pindex].crafting.index = 1
      end
      read_crafting_slot(pindex)

   elseif players[pindex].menu == "crafting_queue" then
      load_crafting_queue(pindex)
      if players[pindex].crafting_queue.index >= players[pindex].crafting_queue.max then
         players[pindex].crafting_queue.index = 1
      else
         players[pindex].crafting_queue.index = players[pindex].crafting_queue.index + 1
      end
      read_crafting_queue(pindex)
   elseif players[pindex].menu == "building" then
      if players[pindex].building.sector <= #players[pindex].building.sectors then
         if players[pindex].building.sectors[players[pindex].building.sector].inventory == nil or #players[pindex].building.sectors[players[pindex].building.sector].inventory < 1 then
            printout("blank", pindex)
            return
         end

         if #players[pindex].building.sectors[players[pindex].building.sector].inventory > 10 then
            players[pindex].building.index = players[pindex].building.index + 1
            if players[pindex].building.index%8 == 1 then
               players[pindex].building.index = players[pindex].building.index - 8
            end
         else
            players[pindex].building.index = players[pindex].building.index + 1
            if players[pindex].building.index > #players[pindex].building.sectors[players[pindex].building.sector].inventory then
               players[pindex].building.index = 1
            end
         end
         print(players[pindex].building.index)
         read_building_slot(pindex)
      elseif players[pindex].building.recipe_list == nil then
         players[pindex].inventory.index = players[pindex].inventory.index +1
         if players[pindex].inventory.index%10 == 1 then
            players[pindex].inventory.index = players[pindex].inventory.index - 10
         end
         read_inventory_slot(pindex)
      else
         if players[pindex].building.sector == #players[pindex].building.sectors + 1 then
            if players[pindex].building.recipe_selection then
               players[pindex].building.index = players[pindex].building.index + 1
               print(players[pindex].building.category .. " " .. #players[pindex].building.recipe_list)
               if players[pindex].building.index > #players[pindex].building.recipe_list[players[pindex].building.category] then
                  players[pindex].building.index  = 1
               end
            end
            read_building_recipe(pindex)
         else
            players[pindex].inventory.index = players[pindex].inventory.index +1
            if players[pindex].inventory.index%10 == 1 then
               players[pindex].inventory.index = players[pindex].inventory.index - 10
            end
            read_inventory_slot(pindex)
            end
         end
   elseif players[pindex].menu == "technology" then
      local techs = {}
      if players[pindex].technology.category == 1 then
         techs = players[pindex].technology.lua_researchable
      elseif players[pindex].technology.category == 2 then
         techs = players[pindex].technology.lua_locked
      elseif players[pindex].technology.category == 3 then
         techs = players[pindex].technology.lua_unlocked
      end
      if players[pindex].technology.index < #techs then
         players[pindex].technology.index = players[pindex].technology.index + 1
      end
      read_technology_slot(pindex)


   elseif players[pindex].menu == "belt" then
      if players[pindex].belt.sector == 1 and players[pindex].belt.line1.valid and #players[pindex].belt.line1 > 0 then
         players[pindex].belt.index = players[pindex].belt.index + 1
         if players[pindex].belt.index > #players[pindex].belt.line1 then 
            players[pindex].belt.index = 1
         end
         read_belt_slot(pindex)
      elseif players[pindex].belt.sector == 2 and players[pindex].belt.line2.valid and #players[pindex].belt.line2 > 0 then
         players[pindex].belt.index = players[pindex].belt.index + 1
         if players[pindex].belt.index > #players[pindex].belt.line2 then 
            players[pindex].belt.index = 1
         end
         read_belt_slot(pindex)
      end



   end
end



function move_characters(event)
   for pindex, player in pairs(players) do
      if player.walk ~= 2 or player.cursor or player.in_menu then
         local walk = false
         while #player.move_queue > 0 do
            local next_move = player.move_queue[1]
            player.player.walking_state = {walking = true, direction = next_move.direction}
            if next_move.direction == defines.direction.north then
               walk = player.player.position.y > next_move.dest.y
            elseif next_move.direction == defines.direction.south then
               walk = player.player.position.y < next_move.dest.y
            elseif next_move.direction == defines.direction.east then
               walk = player.player.position.x < next_move.dest.x
            elseif next_move.direction == defines.direction.west then
               walk = player.player.position.x > next_move.dest.x
            end
            
            if walk then
               break
            else
               table.remove(player.move_queue,1)
            end
         end
         if not walk then
            player.player.walking_state = {walking = false}
         end
      end
   end
end
script.on_event({defines.events.on_tick},move_characters)


function offset_position(oldpos,direction,distance)
   if direction == defines.direction.north then
      return { x = oldpos.x, y = oldpos.y - distance}
   elseif direction == defines.direction.south then
      return { x = oldpos.x, y = oldpos.y + distance}
   elseif direction == defines.direction.east then
      return { x = oldpos.x + distance, y = oldpos.y}
   elseif direction == defines.direction.west then
      return { x = oldpos.x - distance, y = oldpos.y}
   elseif direction == defines.direction.northwest then
      return { x = oldpos.x - distance, y = oldpos.y - distance}
   elseif direction == defines.direction.northeast then
      return { x = oldpos.x + distance, y = oldpos.y - distance}
   elseif direction == defines.direction.southwest then
      return { x = oldpos.x - distance, y = oldpos.y + distance}
   elseif direction == defines.direction.southeast then
      return { x = oldpos.x + distance, y = oldpos.y + distance}
   end
end


function move(direction,pindex)
   if players[pindex].walk == 2 then
      return
   end
   first_player = game.get_player(pindex)
   local pos = players[pindex].position
   local new_pos = offset_position(pos,direction,1)
   if players[pindex].player_direction == direction then
      can_port = first_player.surface.can_place_entity{name = "character", position = new_pos}
      if can_port then
         if players[pindex].walk == 1 then
            table.insert(players[pindex].move_queue,{direction=direction,dest=new_pos})
         else
            teleported = first_player.teleport(new_pos)
            if not teleported then
               printout("Teleport Failed", pindex)
            end
         end
         players[pindex].position = new_pos
         players[pindex].cursor_pos = offset_position(players[pindex].cursor_pos, direction,1)
         read_tile(pindex)
         target(pindex)
      else
         printout("Tile Occupied", pindex)
         target(pindex)
      end
   else
      if players[pindex].walk == 2 then
         table.insert(players[pindex].move_queue,{direction=direction,dest=pos})
      end
      players[pindex].player_direction = direction
      players[pindex].cursor_pos = new_pos
      read_tile(pindex)
      target(pindex)
   end
end


function move_key(direction,event)
   check_for_player(event.player_index)
   if players[event.player_index].in_menu and players[pindex].menu ~= "prompt" then
      menu_cursor_move(direction,event.player_index)
   elseif players[event.player_index].cursor then
      players[event.player_index].cursor_pos = offset_position(players[event.player_index].cursor_pos, direction,1 + players[pindex].cursor_size*2)
      if players[pindex].cursor_size == 0 then
         read_tile(pindex)
         target(event.player_index)
      else
         players[pindex].nearby.index = 1
         players[pindex].nearby.ents = scan_area(math.floor(players[pindex].cursor_pos.x)-players[pindex].cursor_size, math.floor(players[pindex].cursor_pos.y)-players[pindex].cursor_size, players[pindex].cursor_size * 2 + 1, players[pindex].cursor_size * 2 + 1, pindex)
         populate_categories(pindex)
         read_scan_summary(pindex)
      end
   else
      move(direction,event.player_index)
   end
end



script.on_event("cursor-up", function(event)
   move_key(defines.direction.north,event)
end)

script.on_event("cursor-down", function(event)
   move_key(defines.direction.south,event)
end)

script.on_event("cursor-left", function(event)
   move_key(defines.direction.west,event)
end)
script.on_event("cursor-right", function(event)
   move_key(defines.direction.east,event)
end)



script.on_event("read-coords", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   read_coords(pindex)
end
)
script.on_event("jump-to-player", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      if players[pindex].cursor then jump_to_player(pindex)
      end
   end
end
)
script.on_event("teleport-to-cursor", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
   teleport_to_cursor(pindex)
   end
end
)

script.on_event("toggle-cursor", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then

      toggle_cursor(pindex)
   end
end
)

script.on_event("cursor-size-increment", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      if players[pindex].cursor_size == 0 then
         players[pindex].cursor_size = 5
      elseif players[pindex].cursor_size == 5 then
         players[pindex].cursor_size = 50
      elseif players[pindex].cursor_size == 50 then
         players[pindex].cursor_size = 125
      end
      printout("Cursor size set to " .. players[pindex].cursor_size * 2 + 1, pindex)
   end
end)

script.on_event("cursor-size-decrement", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      if players[pindex].cursor_size == 5 then
         players[pindex].cursor_size = 0
      elseif players[pindex].cursor_size == 50 then
         players[pindex].cursor_size = 5
      elseif players[pindex].cursor_size == 125 then
         players[pindex].cursor_size = 50
      end
      printout("Cursor size set to " .. players[pindex].cursor_size * 2 + 1, pindex)
   end
end)

script.on_event("rescan", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      rescan(pindex)
   end
end
)
script.on_event("scan-up", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then

   scan_up(pindex)
   end
end
)

script.on_event("scan-down", function(event)
   pindex = event.player_index
      check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      scan_down(pindex)
   end
end
)

script.on_event("scan-middle", function(event)
   pindex = event.player_index
      check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      scan_middle(pindex)
   end
end
)

script.on_event("jump-to-scan", function(event)
   pindex = event.player_index
      check_for_player(pindex)
   if not (players[event.player_index].in_menu) and players[pindex].cursor then
      if (players[pindex].nearby.category == 1 and next(players[pindex].nearby.ents) == nil) or (players[pindex].nearby.category == 2 and next(players[pindex].nearby.resources) == nil) or (players[pindex].nearby.category == 3 and next(players[pindex].nearby.containers) == nil) or (players[pindex].nearby.category == 4 and next(players[pindex].nearby.buildings) == nil) or (players[pindex].nearby.category == 5 and next(players[pindex].nearby.other) == nil) then
         printout("No entities found.  Try refreshing with end key.", pindex)
      else
         local ents = {}
         if players[pindex].nearby.category == 1 then
            ents = players[pindex].nearby.ents
         elseif players[pindex].nearby.category == 2 then
            ents = players[pindex].nearby.resources
         elseif players[pindex].nearby.category == 3 then
            ents = players[pindex].nearby.containers
         elseif players[pindex].nearby.category == 4 then
            ents = players[pindex].nearby.buildings
         elseif players[pindex].nearby.category == 5 then
            ents = players[pindex].nearby.other
         end
         local ent = nil
         if ents[players[pindex].nearby.index].name == "water" then
            table.sort(ents[players[pindex].nearby.index].ents, function(k1, k2) 
               local pos = game.get_player(pindex).position
               return distance(pos, k1.position) < distance(pos, k2.position)
            end)
            ent = ents[players[pindex].nearby.index].ents[1]
            while ent.valid ~= true do
               table.remove(ents[players[pindex].nearby.index], 1)
               ent = ents[players[pindex].nearby.index][1]
            end
         else
            for i, dud in ipairs(ents[players[pindex].nearby.index].ents) do
               if not(dud.valid) then
                  table.remove(ents[players[pindex].nearby.index].ents, i)
               end
            end
            ent = game.get_player(pindex).surface.get_closest(game.get_player(pindex).position, ents[players[pindex].nearby.index].ents)
         end
      players[pindex].cursor_pos = center_of_tile(ent.position)
      printout("Cursor has jumped to " .. ent.name .. " at " .. math.floor(players[pindex].cursor_pos.x) .. " " .. math.floor(players[pindex].cursor_pos.y), pindex)
      end
   end
end
)

script.on_event("scan-category-up", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      local new_category = players[pindex].nearby.category - 1
      while new_category > 0 and ((new_category == 1 and next(players[pindex].nearby.ents) == nil) or (new_category == 2 and next(players[pindex].nearby.resources) == nil) or (new_category == 3 and next(players[pindex].nearby.containers) == nil) or (new_category == 4 and next(players[pindex].nearby.buildings) == nil) or (new_category == 5 and next(players[pindex].nearby.other) == nil)) do
         new_category = new_category - 1
      end
      if new_category > 0 then
      players[pindex].nearby.index = 1
         players[pindex].nearby.category = new_category
      end
      if players[pindex].nearby.category == 1 then
         printout("All", pindex)
      elseif players[pindex].nearby.category == 2 then
         printout("Resources", pindex)
      elseif players[pindex].nearby.category == 3 then
         printout("Containers", pindex)
      elseif players[pindex].nearby.category == 4 then
         printout("Buildings", pindex)
      elseif players[pindex].nearby.category == 5 then
         printout("Other", pindex)

      end
   end
end
)
script.on_event("scan-category-down", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      local new_category  = players[pindex].nearby.category + 1
      while new_category < 6 and ((new_category == 1 and next(players[pindex].nearby.ents) == nil) or (new_category == 2 and next(players[pindex].nearby.resources) == nil) or (new_category == 3 and next(players[pindex].nearby.containers) == nil) or (new_category == 4 and next(players[pindex].nearby.buildings) == nil) or (new_category == 5 and next(players[pindex].nearby.other) == nil)) do
         new_category = new_category + 1
      end
      if new_category <= 5 then
         players[pindex].nearby.category = new_category
      players[pindex].nearby.index = 1
      end
    
      if players[pindex].nearby.category == 1 then
         printout("All", pindex)
      elseif players[pindex].nearby.category == 2 then
         printout("Resources", pindex)
      elseif players[pindex].nearby.category == 3 then
         printout("Containers", pindex)
      elseif players[pindex].nearby.category == 4 then
         printout("Buildings", pindex)
      elseif players[pindex].nearby.category == 5 then
         printout("Other", pindex)

      end
   end
end
)

script.on_event("scan-mode-up", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      players[pindex].nearby.index = 1
      players[pindex].nearby.count = false
      printout("Sorting by distance", pindex)
      scan_sort(pindex)
   end
end)

script.on_event("scan-mode-down", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      players[pindex].nearby.index = 1
      players[pindex].nearby.count = true
      printout("Sorting by count", pindex)
      scan_sort(pindex)
   end
end)

script.on_event("repeat-last-spoken", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   repeat_last_spoken(pindex)
end   
)


script.on_event("tile-cycle", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      tile_cycle(pindex)
   end
end   
)

script.on_event("open-inventory", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then
      players[pindex].in_menu = true
      players[pindex].menu="inventory"
      players[pindex].inventory.lua_inventory = game.get_player(pindex).character.get_main_inventory()
      players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
      players[pindex].inventory.index = 1
      printout("Inventory", pindex)
--      read_inventory_slot(pindex)
      players[pindex].crafting.lua_recipes = get_recipes(pindex, game.get_player(pindex).character)
      players[pindex].crafting.max = #players[pindex].crafting.lua_recipes
      players[pindex].crafting.category = 1
      players[pindex].crafting.index = 1
      players[pindex].technology.category = 1
      players[pindex].technology.lua_researchable = {}
      players[pindex].technology.lua_unlocked = {}
      players[pindex].technology.lua_locked = {}
      for i, tech in pairs(game.get_player(pindex).force.technologies) do
         if tech.researched then
            table.insert(players[pindex].technology.lua_unlocked, tech)
         else
            local check = true
            for i1, preq in pairs(tech.prerequisites) do
               if not(preq.researched) then
                  check = false
               end
            end
            if check then
               table.insert(players[pindex].technology.lua_researchable, tech)
            else
               local check = false
               for i1, preq in pairs(tech.prerequisites) do
                  if preq.researched then
                     check = true
                  end
               end
               if check then
                  table.insert(players[pindex].technology.lua_locked, tech)
               end
            end
         end
      end
   elseif players[pindex].menu ~= "prompt" then
      printout("Menu closed.", pindex)
      players[pindex].in_menu = false
      players[pindex].menu = "none"
      players[pindex].item_selection = false
      players[pindex].item_cache = {}
      players[pindex].item_selector = {index = 0, group = 0, subgroup = 0}
   end
end   
)



script.on_event("quickbar-1", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[pindex].in_menu) then
      read_quick_bar(1,pindex)
   end
end   
)

script.on_event("quickbar-2", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[pindex].in_menu) then
      read_quick_bar(2,pindex)
   end
end   
)

script.on_event("quickbar-3", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[pindex].in_menu) then
      read_quick_bar(3,pindex)
   end
end   
)

script.on_event("quickbar-4", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[pindex].in_menu) then
      read_quick_bar(4,pindex)
   end
end   
)

script.on_event("quickbar-5", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[pindex].in_menu) then
      read_quick_bar(5,pindex)
   end
end   
)

script.on_event("quickbar-6", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[pindex].in_menu) then
      read_quick_bar(6,pindex)
   end
end   
)

script.on_event("quickbar-7", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[pindex].in_menu) then
      read_quick_bar(7,pindex)
   end
end   
)

script.on_event("quickbar-8", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[pindex].in_menu) then
      read_quick_bar(8,pindex)
   end
end   
)

script.on_event("quickbar-9", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[pindex].in_menu) then
      read_quick_bar(9,pindex)
   end
end   
)

script.on_event("quickbar-10", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[pindex].in_menu) then
      read_quick_bar(10,pindex)
   end
end   
)

script.on_event("set-quickbar-1", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if players[pindex].menu == "inventory" then
      set_quick_bar(1, pindex)
   end
end   
)

script.on_event("set-quickbar-2", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if players[pindex].menu == "inventory" then
      set_quick_bar(2, pindex)
   end
end   
)

script.on_event("set-quickbar-3", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if players[pindex].menu == "inventory" then
      set_quick_bar(3, pindex)
   end
end   
)

script.on_event("set-quickbar-4", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if players[pindex].menu == "inventory" then
      set_quick_bar(4, pindex)
   end
end   
)

script.on_event("set-quickbar-5", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if players[pindex].menu == "inventory" then
      set_quick_bar(5, pindex)
   end
end   
)

script.on_event("set-quickbar-6", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if players[pindex].menu == "inventory" then
      set_quick_bar(6, pindex)
   end
end   
)

script.on_event("set-quickbar-7", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if players[pindex].menu == "inventory" then
      set_quick_bar(7, pindex)
   end
end   
)

script.on_event("set-quickbar-8", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if players[pindex].menu == "inventory" then
      set_quick_bar(8, pindex)
   end
end   
)

script.on_event("set-quickbar-9", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if players[pindex].menu == "inventory" then
      set_quick_bar(9, pindex)
   end
end   
)

script.on_event("set-quickbar-10", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if players[pindex].menu == "inventory" then
      set_quick_bar(10, pindex)
   end
end   
)

script.on_event("switch-menu", function(event)
   pindex = event.player_index
      check_for_player(pindex)
   if players[pindex].in_menu then
      if players[pindex].menu == "building" then
         players[pindex].building.index = 1
         players[pindex].building.sector = players[pindex].building.sector + 1
         if players[pindex].building.sector <= #players[pindex].building.sectors then
            local inventory = players[pindex].building.sectors[players[pindex].building.sector].inventory
            local len = 0
            if inventory ~= nil then
               len = #inventory
            else
               print("Somehow is nil...", pindex)
            end
            printout(len .. " " ..players[pindex].building.sectors[players[pindex].building.sector].name , pindex)
--            if inventory == players[pindex].building.sectors[players[pindex].building.sector+1].inventory then
--               printout("Big Problem!", pindex)
  --          end
         elseif players[pindex].building.recipe_list == nil then
            if players[pindex].building.sector == (#players[pindex].building.sectors + 1) then
               printout("Player Inventory", pindex)
            else
               players[pindex].building.sector = 1
               local inventory = players[pindex].building.sectors[players[pindex].building.sector].inventory
               local len = 0
               if inventory ~= nil then
                 len = #inventory
               end

               printout(len .. " " ..players[pindex].building.sectors[players[pindex].building.sector].name, pindex)
            end
         else
            if players[pindex].building.sector == #players[pindex].building.sectors + 1 then
               printout("Recipe", pindex)
            elseif players[pindex].building.sector == #players[pindex].building.sectors + 2 then
               printout("Player Inventory", pindex)
            else
               players[pindex].building.sector = 1
               printout(players[pindex].building.sectors[players[pindex].building.sector].name, pindex)
            end
         end
      elseif players[pindex].menu == "inventory" then
         players[pindex].menu = "crafting"
         printout("Crafting", pindex)
      elseif players[pindex].menu == "crafting" then 
         players[pindex].menu = "crafting_queue"
         printout("Queue", pindex)
         load_crafting_queue(pindex)
      elseif players[pindex].menu == "crafting_queue" then
         players[pindex].menu = "technology"
         printout("Technology, Researchable Technologies", pindex)
      elseif players[pindex].menu == "technology" then
         players[pindex].menu = "inventory"
         printout("Inventory", pindex)
      elseif players[pindex].menu == "belt" then
         if players[pindex].belt.sector == 1 and players[pindex].belt.line2.valid then
            players[pindex].belt.sector = 2
            printout("Right side" .. #players[pindex].belt.line2, pindex)
         elseif players[pindex].belt.sector == 2 and players[pindex].belt.line1.valid then
            players[pindex].belt.sector = 1
            printout("Left side " .. #players[pindex].belt.line1, pindex)
         end
      end
   end
end)

script.on_event("reverse-switch-menu", function(event)
   pindex = event.player_index
      check_for_player(pindex)
   if players[pindex].in_menu then
      if players[pindex].menu == "building" then
         players[pindex].building.index = 1
         players[pindex].building.sector = players[pindex].building.sector - 1
         if players[pindex].building.sector < 1 then
            if players[pindex].building.recipe_list == nil then
               players[pindex].building.sector = #players[pindex].building.sectors + 1
            else
               players[pindex].building.sector = #players[pindex].building.sectors + 2
            end
            printout("Player's Inventory", pindex)
            
         elseif players[pindex].building.sector <= #players[pindex].building.sectors then
            local inventory = players[pindex].building.sectors[players[pindex].building.sector].inventory
            local len = 0
            if inventory ~= nil then
               len = #inventory
            else
               print("Somehow is nil...", pindex)
            end
            printout(len .. " " ..players[pindex].building.sectors[players[pindex].building.sector].name , pindex)
         elseif players[pindex].building.recipe_list == nil then
            if players[pindex].building.sector == (#players[pindex].building.sectors + 1) then
               printout("Player Inventory", pindex)
            end
         else
            if players[pindex].building.sector == #players[pindex].building.sectors + 1 then
               printout("Recipe", pindex)
            elseif players[pindex].building.sector == #players[pindex].building.sectors + 2 then
               printout("Player Inventory", pindex)
            end
         end


      elseif players[pindex].menu == "inventory" then
         players[pindex].menu = "technology"
         printout("Technology, Researchable Technologies", pindex)
      elseif players[pindex].menu == "crafting_queue" then
         players[pindex].menu = "crafting"
         printout("Crafting", pindex)
      elseif players[pindex].menu == "technology" then 
         players[pindex].menu = "crafting_queue"
         printout("Queue", pindex)
         load_crafting_queue(pindex)
      elseif players[pindex].menu == "crafting" then
         players[pindex].menu = "inventory"
--         read_inventory_slot(pindex)
         printout("Inventory", pindex)
      end
   end
end)



script.on_event("mine-access", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   if not (players[event.player_index].in_menu) then   
      target(pindex)
   end
end
)

script.on_event("left-click", function(event)
   pindex = event.player_index
      check_for_player(pindex)
   if players[pindex].in_menu then
      if players[pindex].menu == "inventory" then
         local stack = players[pindex].inventory.lua_inventory[players[pindex].inventory.index]
         game.get_player(pindex).cursor_stack.swap_stack(stack)
         players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
         read_inventory_slot(pindex)
      elseif players[pindex].menu == "crafting" then
         local T = {
            count = 1,
         recipe = players[pindex].crafting.lua_recipes[players[pindex].crafting.category][players[pindex].crafting.index],
            silent = false
         }
         game.get_player(pindex).begin_crafting(T)
         read_crafting_slot(pindex)
      elseif players[pindex].menu == "crafting_queue" then
         load_crafting_queue(pindex)
         if players[pindex].crafting_queue.max >= 1 then
            local T = {
            index = players[pindex].crafting_queue.index,
               count = 1
            }
            game.get_player(pindex).cancel_crafting(T)
            load_crafting_queue(pindex)
            read_crafting_queue(pindex)

         end
      elseif players[pindex].menu == "building" then
         if players[pindex].building.sector <= #players[pindex].building.sectors and #players[pindex].building.sectors[players[pindex].building.sector].inventory > 0  then
            if players[pindex].building.sectors[players[pindex].building.sector].name == "Fluid" then
               return
            elseif players[pindex].building.sectors[players[pindex].building.sector].name == "Filters" then
               if players[pindex].building.index == #players[pindex].building.sectors[players[pindex].building.sector].inventory then
                  if players[pindex].building.ent.inserter_filter_mode == "whitelist" then
                     players[pindex].building.ent.inserter_filter_mode = "blacklist"
                  else
                     players[pindex].building.ent.inserter_filter_mode = "whitelist"
                  end
                  players[pindex].building.sectors[players[pindex].building.sector].inventory[players[pindex].building.index] = players[pindex].building.ent.inserter_filter_mode 
                  read_building_slot(pindex)
               elseif players[pindex].building.item_selection then
                  if players[pindex].item_selector.group == 0 then
                     players[pindex].item_selector.group = players[pindex].item_selector.index
                     players[pindex].item_cache = get_iterable_array(players[pindex].item_cache[players[pindex].item_selector.index].subgroups)
                     players[pindex].item_selector.index = 1
                     read_item_selector_slot(pindex)
                  elseif players[pindex].item_selector.subgroup == 0 then
                     players[pindex].item_selector.subgroup = players[pindex].item_selector.index
                     local prototypes = game.get_filtered_item_prototypes{{filter="subgroup",subgroup = players[pindex].item_cache[players[pindex].item_selector.index].name}}
                     players[pindex].item_cache = get_iterable_array(prototypes)
                     players[pindex].item_selector.index = 1
                     read_item_selector_slot(pindex)
                  else
                     players[pindex].building.ent.set_filter(players[pindex].building.index, players[pindex].item_cache[players[pindex].item_selector.index].name)
                     players[pindex].building.sectors[players[pindex].building.sector].inventory[players[pindex].building.index] = players[pindex].building.ent.get_filter(players[pindex].building.index)
                     printout("Filter set.", pindex)
                     players[pindex].building.item_selection = false
                     players[pindex].item_selection = false


                  end
               else
                  players[pindex].item_selector.group = 0
                  players[pindex].item_selector.subgroup = 0
                  players[pindex].item_selector.index = 1
                     players[pindex].item_selection = true
                  players[pindex].building.item_selection = true
                  players[pindex].item_cache = get_iterable_array(game.item_group_prototypes)
                     prune_item_groups(players[pindex].item_cache)                  
                  read_item_selector_slot(pindex)

               end
               return
            end
            local stack = players[pindex].building.sectors[players[pindex].building.sector].inventory[players[pindex].building.index]
            game.get_player(pindex).cursor_stack.swap_stack(stack)
            read_building_slot(pindex)
         elseif players[pindex].building.recipe_list == nil then
            local stack = players[pindex].inventory.lua_inventory[players[pindex].inventory.index]
            game.get_player(pindex).cursor_stack.swap_stack(stack)
               players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
            read_inventory_slot(pindex)
         else
            if players[pindex].building.sector == #players[pindex].building.sectors + 1 then
               if players[pindex].building.recipe_selection then
                  if not(pcall(function()
                     players[pindex].building.recipe = players[pindex].building.recipe_list[players[pindex].building.category][players[pindex].building.index]
                     if players[pindex].building.ent.valid then
                        players[pindex].building.ent.set_recipe(players[pindex].building.recipe)
                     end
                     players[pindex].building.recipe_selection = false
                     players[pindex].building.index = 1
                     printout("Selected", pindex)
                  end)) then
                     printout("This is only a list of what can be crafted by this machine.  Please put items in input to start the crafting process.", pindex)
                  end
               elseif #players[pindex].building.recipe_list > 0 then
                  players[pindex].building.recipe_selection = true
                  players[pindex].building.category = 1
                  players[pindex].building.index = 1
                  printout("Select a recipe", pindex)
               else
                  printout("No recipes unlocked for this building yet.", pindex)
               end
            else
               local stack = players[pindex].inventory.lua_inventory[players[pindex].inventory.index]
               game.get_player(pindex).cursor_stack.swap_stack(stack)

                  players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
--               read_inventory_slot(pindex)
            end

         end
      elseif players[pindex].menu == "technology" then
         local techs = {}
         if players[pindex].technology.category == 1 then
            techs = players[pindex].technology.lua_researchable
         elseif players[pindex].technology.category == 2 then
            techs = players[pindex].technology.lua_locked
         elseif players[pindex].technology.category == 3 then
            techs = players[pindex].technology.lua_unlocked
         end
            
         if next(techs) ~= nil and players[pindex].technology.index > 0 and players[pindex].technology.index <= #techs then
            if game.get_player(pindex).force.add_research(techs[players[pindex].technology.index]) then
               printout("Research started.", pindex)
            else
               printout("Research locked, first complete the prerequisites.", pindex)
            end
         end
      elseif players[pindex].menu == "pump" then
         local entry = players[pindex].pump.positions[players[pindex].pump.index]
         game.get_player(pindex).build_from_cursor{position = entry.position, direction = entry.direction}
         players[pindex].in_menu = false
         players[pindex].menu = "none"
         printout("Pump placed.", pindex)
      end
   else
      local stack = game.get_player(pindex).cursor_stack
      if stack.valid_for_read and stack.valid and stack.prototype.place_result ~= nil and stack.name ~= "offshore-pump" then
         local ent = stack.prototype.place_result
         local position = {x,y}

         if not(players[pindex].cursor) then
            position = game.get_player(pindex).position
         if players[pindex].building_direction < 0 then
            players[pindex].building_direction = 0
         end
         if players[pindex].player_direction == defines.direction.north then
            if players[pindex].building_direction == 0 or players[pindex].building_direction == 2 then
               position.y = position.y + math.ceil(2* ent.selection_box.left_top.y)/2 - 1
            elseif players[pindex].building_direction == 1 or players[pindex].building_direction == 3 then
               position.y = position.y + math.ceil(2* ent.selection_box.left_top.x)/2 - 1
            end
         elseif players[pindex].player_direction == defines.direction.south then
            if players[pindex].building_direction == 0 or players[pindex].building_direction == 2 then
               position.y = position.y + math.ceil(2* ent.selection_box.right_bottom.y)/2 + .5
            elseif players[pindex].building_direction == 1 or players[pindex].building_direction == 3 then
               position.y = position.y + math.ceil(2* ent.selection_box.right_bottom.x)/2 + .5
            end
         elseif players[pindex].player_direction == defines.direction.west then
            if players[pindex].building_direction == 0 or players[pindex].building_direction == 2 then
               position.x = position.x + math.ceil(2* ent.selection_box.left_top.x)/2 - 1
            elseif players[pindex].building_direction == 1 or players[pindex].building_direction == 3 then
               position.x = position.x + math.ceil(2* ent.selection_box.left_top.y)/2 - 1
            end

         elseif players[pindex].player_direction == defines.direction.east then
            if players[pindex].building_direction == 0 or players[pindex].building_direction == 2 then
               position.x = position.x + math.ceil(2* ent.selection_box.right_bottom.x)/2 + .5
            elseif players[pindex].building_direction == 1 or players[pindex].building_direction == 3 then
               position.x = position.x + math.ceil(2* ent.selection_box.right_bottom.y)/2 + .5
            end
         end     
         else
            position = {x = math.floor(players[pindex].cursor_pos.x), y = math.floor(players[pindex].cursor_pos.y)}
            local box = ent.selection_box
               box.right_bottom = {x = (math.ceil(box.right_bottom.x * 2))/2, y = (math.ceil(box.right_bottom.y * 2))/2}
            if players[pindex].building_direction == 0 or players[pindex].building_direction == 2 then
               position.x = position.x + box.right_bottom.x
               position.y = position.y + box.right_bottom.y
            else
               position.x = position.x + box.right_bottom.y
               position.y = position.y + box.right_bottom.x
            end
         end
         local building = {
            position = position,
            direction = players[pindex].building_direction * 2,
            alt = false
         }
         building.position = game.get_player(pindex).surface.find_non_colliding_position(ent.name, position, .5, .05)
         if building.position ~= nil and game.get_player(pindex).can_build_from_cursor(building) then 
            game.get_player(pindex).build_from_cursor(building)  
            read_tile(pindex)
         else
            printout("Cannot place that there.", pindex)
            print(players[pindex].player_direction .. " " .. game.get_player(pindex).character.position.x .. " " .. game.get_player(pindex).character.position.y .. " " .. players[pindex].cursor_pos.x .. " " .. players[pindex].cursor_pos.y .. " " .. position.x .. " " .. position.y)
         end
      elseif stack.valid and stack.valid_for_read and stack.name == "offshore-pump" then
         local ent = stack.prototype.place_result
         players[pindex].pump.positions = {}
         local initial_position = game.get_player(pindex).position
         initial_position.x = math.floor(initial_position.x) 
         initial_position.y = math.floor(initial_position.y)
         for i1 = -10, 10 do
            for i2 = -10, 10 do
               for i3 = 0, 3 do
               local position = {x = initial_position.x + i1, y = initial_position.y + i2}
                  if game.get_player(pindex).can_build_from_cursor{name = "offshore-pump", position = position, direction = i3 * 2} then
                     table.insert(players[pindex].pump.positions, {position = position, direction = i3*2})
                  end
               end
            end
         end
         if #players[pindex].pump.positions == 0 then
            printout("No available positions.  Try moving closer to water.", pindex)
         else
            players[pindex].in_menu = true
            players[pindex].menu = "pump"
            printout("There are " .. #players[pindex].pump.positions .. " possibilities, scroll up and down, then select one to build, or press e to cancel.", pindex)
            table.sort(players[pindex].pump.positions, function(k1, k2) 
               return distance(initial_position, k1.position) < distance(initial_position, k2.position)
            end)

            players[pindex].pump.index = 0
         end
      elseif next(players[pindex].tile.ents) ~= nil and players[pindex].tile.index > 1 and players[pindex].tile.ents[1].valid then
         local ent = players[pindex].tile.ents[1]
         if ent.operable and ent.prototype.is_building then
            if ent.prototype.subgroup.name == "belt" then
               players[pindex].in_menu = true
               players[pindex].menu = "belt"
               players[pindex].belt.line1 = ent.get_transport_line(1)
               players[pindex].belt.line2 = ent.get_transport_line(2)
               players[pindex].belt.ent = ent
               players[pindex].belt.sector = 1
               players[pindex].belt.index = 1
               printout(#players[pindex].belt.line1 .. " " .. #players[pindex].belt.line2 .. " " .. players[pindex].belt.ent.get_max_transport_line_index(), pindex)

               return
            end
--            target(pindex)
            if ent.prototype.ingredient_count ~= nil then
               players[pindex].building.recipe = ent.get_recipe()
               players[pindex].building.recipe_list = get_recipes(pindex, ent)
               players[pindex].building.category = 1
            else
               players[pindex].building.recipe = nil
               players[pindex].building.recipe_list = nil
               players[pindex].building.category = 0
            end
            players[pindex].inventory.lua_inventory = game.get_player(pindex).get_main_inventory()
            players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
            players[pindex].building.sectors = {}
            players[pindex].building.sector = 1
            if ent.get_output_inventory() ~= nil then
               table.insert(players[pindex].building.sectors, {
                  name = "Output",
                  inventory = ent.get_output_inventory()})
            end
            if ent.get_fuel_inventory() ~= nil then
               table.insert(players[pindex].building.sectors, {
                  name = "Fuel",
                  inventory = ent.get_fuel_inventory()})
            end
            if ent.prototype.ingredient_count ~= nil then
               table.insert(players[pindex].building.sectors, {
                  name = "Input",
                  inventory = ent.get_inventory(defines.inventory.assembling_machine_input)})
            end
            if ent.get_module_inventory() ~= nil and #ent.get_module_inventory() > 0 then
               table.insert(players[pindex].building.sectors, {
                  name = "Modules",
                  inventory = ent.get_module_inventory()})
                        end
            if ent.get_burnt_result_inventory() ~= nil and #ent.get_burnt_result_inventory() > 0 then
               table.insert(players[pindex].building.sectors, {
                  name = "Burned",
                  inventory = ent.get_burnt_result_inventory()})
            end
            if ent.fluidbox ~= nil and #ent.fluidbox > 0 then
               table.insert(players[pindex].building.sectors, {
                  name = "Fluid",
                  inventory = ent.fluidbox})
            end

            if ent.filter_slot_count > 0 then
               table.insert(players[pindex].building.sectors, {
                  name = "Filters",
                  inventory = {}})
               for i = 1, ent.filter_slot_count do
                  local filter = ent.get_filter(i)
                  if filter == nil then
                     filter = "No filter selected."
                  end
                  table.insert(players[pindex].building.sectors[#players[pindex].building.sectors].inventory, filter)
               end
               table.insert(players[pindex].building.sectors[#players[pindex].building.sectors].inventory, ent.inserter_filter_mode)

            end

            for i1=#players[pindex].building.sectors, 2, -1 do
               for i2 = i1-1, 1, -1 do
                  if players[pindex].building.sectors[i1].inventory == players[pindex].building.sectors[i2].inventory then
                     table.remove(players[pindex].building.sectors, i2)
                     i2 = i2 + 1
                  end
               end
            end
            if #players[pindex].building.sectors > 0 then
               players[pindex].building.ent = ent
               players[pindex].in_menu = true
               players[pindex].menu = "building"
               players[pindex].inventory.index = 1
               players[pindex].building.index = 1

               local inventory = players[pindex].building.sectors[players[pindex].building.sector].inventory
               local len = 0
               if inventory ~= nil then
                 len = #inventory
               end
               printout(len .. " " ..players[pindex].building.sectors[players[pindex].building.sector].name , pindex)
            else
               printout("This building has no inventory", pindex)
            end

	        else
            printout("Not a building.", pindex)
         end
      end
   end
end
)
script.on_event("shift-click", function(event)
   pindex = event.player_index
      check_for_player(pindex)
   if players[pindex].in_menu then
      if players[pindex].menu == "crafting" then
         local recipe = players[pindex].crafting.lua_recipes[players[pindex].crafting.category][players[pindex].crafting.index]
         local T = {
            count = game.get_player(pindex).get_craftable_count(recipe),
         recipe = players[pindex].crafting.lua_recipes[players[pindex].crafting.category][players[pindex].crafting.index],
            silent = false
         }
         game.get_player(pindex).begin_crafting(T)
         read_crafting_slot(pindex)

      elseif players[pindex].menu == "crafting_queue" then
         load_crafting_queue(pindex)
         if players[pindex].crafting_queue.max >= 1 then
            local T = {
            index = players[pindex].crafting_queue.index,
               count = players[pindex].crafting_queue.lua_queue[players[pindex].crafting_queue.index].count
            }
            game.get_player(pindex).cancel_crafting(T)
            load_crafting_queue(pindex)
            read_crafting_queue(pindex)

         end
      elseif players[pindex].menu == "building" then
         if players[pindex].building.sector <= #players[pindex].building.sectors and #players[pindex].building.sectors[players[pindex].building.sector].inventory > 0 and players[pindex].building.sectors[players[pindex].building.sector].name ~= "Fluid" then
            local stack = players[pindex].building.sectors[players[pindex].building.sector].inventory[players[pindex].building.index]
            if stack.valid and stack.valid_for_read then
               if game.get_player(pindex).can_insert(stack) then
                  local result = stack.name
                  local inserted = game.get_player(pindex).insert(stack)
                  players[pindex].building.sectors[players[pindex].building.sector].inventory.remove{name = stack.name, count = inserted}
                  result = "Moved " .. inserted .. " " .. result .. " to player's inventory."
                  printout(result, pindex)
               else
                  printout("Inventory full.", pindex)
               end
            end
         else
            local offset = 1
            if players[pindex].building.recipe_list ~= nil then
               offset = offset + 1
            end
            if players[pindex].building.sector == #players[pindex].building.sectors + offset then
               local stack = players[pindex].inventory.lua_inventory[players[pindex].inventory.index]
               if stack.valid and stack.valid_for_read then
                  if players[pindex].building.ent.can_insert(stack) then
                     local result = stack.name
                     local inserted = players[pindex].building.ent.insert(stack)
                     players[pindex].inventory.lua_inventory.remove{name = stack.name, count = inserted}
                     result = "Moved " .. inserted .. " " .. result .. " to " .. players[pindex].building.ent.name
                     printout(result, pindex)
                  else
                     printout("Inventory full.", pindex)
                  end
               end
            end
         end


      end
   end
end
)

script.on_event("right-click", function(event)
   pindex = event.player_index
      check_for_player(pindex)
   if players[pindex].in_menu then
      if players[pindex].menu == "crafting" then
         local recipe = players[pindex].crafting.lua_recipes[players[pindex].crafting.category][players[pindex].crafting.index]
         local T = {
            count = 5,
         recipe = players[pindex].crafting.lua_recipes[players[pindex].crafting.category][players[pindex].crafting.index],
            silent = false
         }
         game.get_player(pindex).begin_crafting(T)
         read_crafting_slot(pindex)

      elseif players[pindex].menu == "crafting_queue" then
         load_crafting_queue(pindex)
         if players[pindex].crafting_queue.max >= 1 then
            local T = {
            index = players[pindex].crafting_queue.index,
               count = 5
            }
            game.get_player(pindex).cancel_crafting(T)
            load_crafting_queue(pindex)
            read_crafting_queue(pindex)
         end
      elseif players[pindex].menu == "building" then
         local stack = game.get_player(pindex).cursor_stack
         if stack.valid_for_read and stack.valid and stack.count > 0 then
            if players[pindex].building.sector <= #players[pindex].building.sectors then
               T = {
                  name = stack.name,
                  count = 1
               }                  
               local inserted = players[pindex].building.sectors[players[pindex].building.sector].inventory.insert(T)
               if inserted == 1 then
                  printout("Inserted 1 " .. stack.name, pindex)
                  stack.count = stack.count - 1
               else
                  printout("Cannot insert " .. stack.name .. " into " .. players[pindex].building.sectors[players[pindex].building.sector].name, pindex)
               end
            end
         end

      end
   end
end
)

script.on_event("rotate-building", function(event)
   pindex = event.player_index
      check_for_player(pindex)
   if not(players[pindex].in_menu) then
      local stack = game.get_player(pindex).cursor_stack
      if stack.valid_for_read and stack.valid and stack.prototype.place_result ~= nil then
         if stack.prototype.place_result.supports_direction then
            if not(players[pindex].building_direction_lag) then
               players[pindex].building_direction = players[pindex].building_direction + 1
               if players[pindex].building_direction > 3 then
                  players[pindex].building_direction = players[pindex].building_direction %4
               end
            end
            if players[pindex].building_direction == 0 then
               printout("North", pindex)
            elseif players[pindex].building_direction == 1 then
               printout("East", pindex)
            elseif players[pindex].building_direction == 2 then
               printout("South", pindex)
            elseif players[pindex].building_direction == 3 then
               printout("West", pindex)
            end
            players[pindex].building_direction_lag = false
         else
            printout(stack.name .. " cannot be rotated.", pindex)
         end
      elseif next(players[pindex].tile.ents) ~= nil and players[pindex].tile.index > 1 and players[pindex].tile.ents[players[pindex].tile.index-1].valid then
         local ent = players[pindex].tile.ents[players[pindex].tile.index-1]
         if ent.prototype.supports_direction then
            if not(players[pindex].building_direction_lag) then
               local T = {
                  reverse = false,
                  by_player = pindex
               }
                  if not(ent.rotate(T)) then
                     printout("Cannot rotate this object.", pindex)
                     return
                  end
            else
               players[pindex].building_direction_lag = false
            end
            if ent.direction == 0 then
               printout("North", pindex)
            elseif ent.direction == 2 then
               printout("East", pindex)
            elseif ent.direction == 4 then
               printout("South", pindex)
            elseif ent.direction == 6 then
               printout("West", pindex)
            else
               printout("Not a direction...", pindex)
            end
         else
            printout(ent.name .. " cannot be rotated.", pindex)
         end               
      else
         print("not a valid stack for rotating")
      end
   end
end
)


script.on_event("item-info", function(event)
   pindex = event.player_index
      check_for_player(pindex)
   if players[pindex].in_menu then
      if players[pindex].menu == "inventory" then
         local stack = players[pindex].inventory.lua_inventory[players[pindex].inventory.index]
         if stack.valid_for_read and stack.valid == true then
            dimensions = get_tile_dimensions(stack.prototype)
            script.on_event(defines.events.on_string_translated, function(event1)
               if event1.player_index == pindex then
                  printout(dimensions .. " " .. event1.result, pindex)
                  script.on_event(defines.events.on_string_translated, nil)
               end
            end)
            game.get_player(pindex).request_translation(stack.prototype.localised_description)
         else
            printout("Blank", pindex)
         end

      elseif players[pindex].menu == "technology" then
         local techs = {}
         if players[pindex].technology.category == 1 then
            techs = players[pindex].technology.lua_researchable
         elseif players[pindex].technology.category == 2 then
            techs = players[pindex].technology.lua_locked
         elseif players[pindex].technology.category == 3 then
            techs = players[pindex].technology.lua_unlocked
         end
   
         if next(techs) ~= nil and players[pindex].technology.index > 0 and players[pindex].technology.index <= #techs then
            local result = "Grants the following rewards:"
            local rewards = techs[players[pindex].technology.index].effects
            for i, reward in ipairs(rewards) do
               for i1, v in pairs(reward) do
                  result = result .. v .. " , "
               end
            end
            printout(string.sub(result, 1, -3), pindex)
         end
      end

   end
end
)

script.on_event("time", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   local surf = game.get_player(pindex).surface
   local hour = math.floor(24*surf.daytime)
   local minute = math.floor((24* surf.daytime - hour) * 60)
   local progress = math.floor(game.get_player(pindex).force.research_progress* 100)
   local tech = game.get_player(pindex).force.current_research
   if tech ~= nil then
      printout("The time is " .. hour .. ":" .. string.format("%02d", minute) .. " Researching " .. game.get_player(pindex).force.current_research.name .. " " .. progress .. "%", pindex)
   else
      printout("The time is " .. hour .. ":" .. string.format("%02d", minute), pindex)
   end
end)

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
   pindex = event.player_index
   check_for_player(pindex)
   local stack = game.get_player(pindex).cursor_stack
   local new_item = ""
   if stack.valid_for_read then 
      new_item = stack.name
   end
   if players[pindex].previous_item ~= new_item then
      players[pindex].previous_item = new_item
      players[pindex].building_direction_lag = true
      read_hand(pindex)
   end
end)



script.on_event(defines.events.on_cutscene_cancelled, function(event)
   check_for_player(event.player_index)
   rescan(event.player_index)
end)

script.on_event(defines.events.on_gui_closed, function(event)
   pindex = event.player_index
   check_for_player(pindex)   
--   rescan(pindex)
   if players[pindex].in_menu == true and players[pindex].menu ~= "prompt"then
      players[pindex].in_menu = false
      players[pindex].menu = "none"
   end
end
)

script.on_event("save", function(event)
   pindex = event.player_index
   check_for_player(pindex)
   game.auto_save("manual")
   printout("Saving Game, please do not quit yet.", pindex)

end)

walk_type_speech={
   "Telestep enabled",
   "Step by walk enabled",
   "Walking smoothly enabled"
}

script.on_event("toggle-walk",function(event)
   pindex = event.player_index
   check_for_player(pindex)
   players[pindex].walk = (players[pindex].walk + 1) % 3
   printout(walk_type_speech[players[pindex].walk +1], pindex)
end)

script.on_event("recalibrate",function(event)
   pindex = event.player_index
   scale_start(pindex)
end)

script.on_event("read-hand",function(event)
   pindex = event.player_index
   check_for_player(pindex)
   read_hand(pindex)
end)

