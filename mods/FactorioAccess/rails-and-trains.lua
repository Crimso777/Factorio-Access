

--Key information about rail units. 
function rail_ent_info(pindex, ent, description)  
   local result = ""
   local is_end_rail = false
   local is_horz_or_vert = false
   
   --Check if end rail: The rail is at the end of its segment and is also not connected to another rail
   is_end_rail, end_rail_dir, build_comment = check_end_rail(ent,pindex)
   if is_end_rail then
      result = result .. "End rail "
   else
      result = result .. "Rail "
   end
      
   --Explain the rail facing direction
   if ent.name == "straight-rail" and is_end_rail then
      if end_rail_dir == 0 then
         result = result .. " facing North "
         is_horz_or_vert = true
      elseif end_rail_dir == 4 then
         result = result .. " facing South "
         is_horz_or_vert = true
      elseif end_rail_dir == 2 then
         result = result .. " facing East "
         is_horz_or_vert = true
      elseif end_rail_dir == 6 then
         result = result .. " facing West "
         is_horz_or_vert = true
         
      elseif end_rail_dir == 1 then
         result = result .. " on falling diagonal left "
      elseif end_rail_dir == 5 then
         result = result .. " on falling diagonal right "
      elseif end_rail_dir == 3 then
         result = result .. " on rising diagonal left "
      elseif end_rail_dir == 7 then
         result = result .. " on rising diagonal right "
      end
      
   elseif ent.name == "straight-rail" and is_end_rail == false then
      if ent.direction == 0 or ent.direction == 4 then --always reports 0 it seems
         result = result .. " vertical "
         is_horz_or_vert = true
      elseif ent.direction == 2 or ent.direction == 6 then --always reports 2 it seems
         result = result .. " horizontal "
         is_horz_or_vert = true
         
      elseif ent.direction == 1 then
         result = result .. " on falling diagonal left "
      elseif ent.direction == 5 then
         result = result .. " on falling diagonal right "
      elseif ent.direction == 3 then
         result = result .. " on rising diagonal left "
      elseif ent.direction == 7 then
         result = result .. " on rising diagonal right "
      end
      
   elseif ent.name == "curved-rail" then
      result = result .. " curved in direction "
      if ent.direction == 0 then 
         result = result ..  "0 with north and falling ends"
      elseif ent.direction == 1 then
         result = result ..  "1 with north and rising ends"
      elseif ent.direction == 2 then
         result = result ..  "2 with east  and rising ends"
      elseif ent.direction == 3 then
         result = result ..  "3 with east  and falling ends"
      elseif ent.direction == 4 then
         result = result ..  "4 with south and falling ends"
      elseif ent.direction == 5 then
         result = result ..  "5 with south and rising ends"
      elseif ent.direction == 6 then
         result = result ..  "6 with west  and rising ends"
      elseif ent.direction == 7 then
         result = result ..  "7, west and falling ends"
      end
   end
   
   --Check if at junction
   left_rail,temp1,temp2 = ent.get_connected_rail{rail_direction = defines.rail_direction.front, rail_connection_direction = defines.rail_connection_direction.left}
   right_rail,temp1,temp2 = ent.get_connected_rail{rail_direction = defines.rail_direction.back,  rail_connection_direction = defines.rail_connection_direction.right}
   if left_rail ~= nil or right_rail ~= nil then
      result = result .. " junction, "
   end
   
   --Check if there is a train stop nearby
   if is_horz_or_vert then
      local stop = nil
      local segment_ent_1 = ent.get_rail_segment_entity(defines.rail_direction.front, false)
      local segment_ent_2 = ent.get_rail_segment_entity(defines.rail_direction.back, false)
      if segment_ent_1 ~= nil and segment_ent_1.name == "train-stop" and util.distance(ent.position, segment_ent_1.position) < 45 then
         stop = segment_ent_1
      elseif segment_ent_2 ~= nil and segment_ent_2.name == "train-stop" and util.distance(ent.position, segment_ent_2.position) < 45 then
         stop = segment_ent_2
      end
      if stop == nil then
         return result
      end
      
      --Check if this rail is in the direction of the trains stop
      local rail_dir_1 = segment_ent_1 == stop
      local rail_dir_2 = segment_ent_2 == stop
      local stop_dir = stop.connected_rail_direction
      local pairing_correct = false
      
      if rail_dir_1 and stop_dir == defines.rail_direction.front then
         --result = result .. ", pairing 1, "
         pairing_correct = true
      elseif rail_dir_1 and stop_dir == defines.rail_direction.back then
         --result = result .. ", pairing 2, "
         pairing_correct = false
      elseif rail_dir_2 and stop_dir == defines.rail_direction.front then
         --result = result .. ", pairing 3, "
         pairing_correct = false
      elseif rail_dir_2 and stop_dir == defines.rail_direction.back then
         --result = result .. ", pairing 4, "
         pairing_correct = true
      else
         result = result .. ", pairing error, "
         pairing_correct = false
      end
      
      if not pairing_correct then
         return result
      end
      
      --Count distance and determine railcar slot
      local dist = util.distance(ent.position, stop.position)
      --result = result .. " stop distance " .. dist
      if dist < 2 then
         result = result .. " station locomotive space front"
      elseif dist < 3 then
         result = result .. " station locomotive space middle"
      elseif dist < 5 then
         result = result .. " station locomotive space middle"
      elseif dist < 7 then
         result = result .. " station locomotive end and gap 1"
      elseif dist < 9 then
         result = result .. " station space 1 front"
      elseif dist < 11 then
         result = result .. " station space 1 middle"
      elseif dist < 13 then
         result = result .. " station space 1 end"
      elseif dist < 15 then
         result = result .. " station gap 2 and station space 2 front"
      elseif dist < 17 then
         result = result .. " station space 2 middle"
      elseif dist < 19 then
         result = result .. " station space 2 middle"
      elseif dist < 21 then
         result = result .. " station space 2 end and gap 3"
      elseif dist < 23 then
         result = result .. " station space 3 front"
      elseif dist < 25 then
         result = result .. " station space 3 middle"
      elseif dist < 27 then
         result = result .. " station space 3 end"
      elseif dist < 29 then
         result = result .. " station gap 4 and station space 4 front"
      elseif dist < 31 then
         result = result .. " station space 4 middle"
      elseif dist < 33 then
         result = result .. " station space 4 middle"
      elseif dist < 35 then
         result = result .. " station space 4 end and gap 5"
      elseif dist < 37 then
         result = result .. " station space 5 front"
      elseif dist < 39 then
         result = result .. " station space 5 middle"
      elseif dist < 41 then
         result = result .. " station space 5 end"
      elseif dist < 43 then
         result = result .. " station gap 6 and station space 6 front"
      elseif dist < 45 then
         result = result .. " station space 6 middle"
      end
   end
   
   return result
end


--Determines if an entity is an end rail. Returns boolean is_end_rail, integer end rail direction, and string comment for errors.
function check_end_rail(check_rail, pindex)
   local is_end_rail = false
   local dir = -1
   local comment = "Check function error."
   
   --Check if the entity is a rail
   if check_rail == nil then
      is_end_rail = false
      comment = "Nil, a straight end rail is required."
      return is_end_rail, -1, comment
   elseif not (check_rail.name == "straight-rail") then
      is_end_rail = false
      comment = "Not a straight rail, a straight end rail is required."
      return is_end_rail, -1, comment
   end
   
   --Check if end rail: The rail is at the end of its segment and is also not connected to another rail in the forward or backward direction
   end_rail_1, end_dir_1 = check_rail.get_rail_segment_end(defines.rail_direction.front)
   end_rail_2, end_dir_2 = check_rail.get_rail_segment_end(defines.rail_direction.back)
   next_rail,temp1,temp2 = check_rail.get_connected_rail{rail_direction = defines.rail_direction.front, rail_connection_direction = defines.rail_connection_direction.straight}
   prev_rail,temp1,temp2 = check_rail.get_connected_rail{rail_direction = defines.rail_direction.back,  rail_connection_direction = defines.rail_connection_direction.straight}
   if (check_rail.unit_number == end_rail_1.unit_number or check_rail.unit_number == end_rail_2.unit_number) and (next_rail == nil or prev_rail == nil) then
      --End rail confirmed, get direction
      is_end_rail = true
      comment = "End rail confirmed."
      if check_rail.direction == 0 and check_rail.unit_number == end_rail_1.unit_number then
         dir = 0
      elseif check_rail.direction == 0 and check_rail.unit_number == end_rail_2.unit_number then
         dir = 4
      elseif check_rail.direction == 2 and check_rail.unit_number == end_rail_1.unit_number then
         dir = 2
      elseif check_rail.direction == 2 and check_rail.unit_number == end_rail_2.unit_number then
         dir = 6
      elseif check_rail.direction == 1 or check_rail.direction == 3 or check_rail.direction == 5 or check_rail.direction == 7 then
         dir = check_rail.direction
      else
         is_end_rail = false
         comment = "Rail direction error."
         return is_end_rail, -3, comment
      end
   else
      --Not the end rail
      is_end_rail = false
      comment = "This rail is not the end rail."
      return is_end_rail, -4, comment
   end
   
   return is_end_rail, dir, comment
end


--Builds a 90 degree rail turn to the right as a 14x12 object. Enter the start tile position and the direction to face when starting to turn right. 0 for North, 2 for East, etc.  Must be standing on the end of a straight rail with rails in hand.
function build_rail_turn_right_90_degrees(anchor_rail, pindex)
   local build_comment = ""
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local pos = nil
   local dir = -1
   local build_area = nil
   local can_place_all = true
   local is_end_rail
   
   --1. Firstly, check if the player has enough rails to place this (10 units)
   if not (stack.valid and stack.valid_for_read and stack.name == "rail" and stack.count > 10) then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("You need at least 10 rails in hand to build this turn.", pindex)
      return
   end
   
   --2. Secondly, verify the end rail and find its direction
   is_end_rail, dir, build_comment = check_end_rail(anchor_rail,pindex)
   if not is_end_rail then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(build_comment, pindex)
      return
   end
   pos = anchor_rail.position
   if dir == 1 or dir == 3 or dir == 5 or dir == 7 then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("This structure is for horizontal or vertical end rails only.", pindex)
      return
   end
   
   --3. Clear trees and rocks in the build area
   if dir == 0 then
      build_area = {{pos.x, pos.y},{pos.x+14,pos.y-12}}
   elseif dir == 2 then
      build_area = {{pos.x, pos.y},{pos.x+12,pos.y+14}}
   elseif dir == 4 then
      build_area = {{pos.x, pos.y},{pos.x-14,pos.y+12}}
   elseif dir == 6 then
      build_area = {{pos.x, pos.y},{pos.x-12,pos.y-14}}
   end 
   temp1, build_comment = mine_trees_and_rocks_in_area(build_area, pindex)
   
   --4. Check if every object can be placed
   if dir == 0 then 
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+2, pos.y-4}, direction = 1, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+4, pos.y-8}, direction = 7, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+8, pos.y-10}, direction = 6, force = game.forces.player} 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+12, pos.y-12}, direction = 2, force = game.forces.player}
   elseif dir == 2 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+6, pos.y+2}, direction = 3, force = game.forces.player} 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+8, pos.y+4}, direction = 1, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+12, pos.y+8}, direction = 0, force = game.forces.player} 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+12, pos.y+12}, direction = 4, force = game.forces.player}
   elseif dir == 4 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+0, pos.y+6}, direction = 5, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-4, pos.y+8}, direction = 3, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-6, pos.y+12}, direction = 2, force = game.forces.player} 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-12, pos.y+12}, direction = 6, force = game.forces.player}
   elseif dir == 6 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-4, pos.y+0}, direction = 7, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-8, pos.y-4}, direction = 5, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-10, pos.y-6}, direction = 4, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-12, pos.y-12}, direction = 0, force = game.forces.player}
   end
  
   if not can_place_all then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("Building area occupied.", pindex)
      return
   end
   
   --5. Build the five rail entities to create the turn
   if dir == 0 then 
      surf.create_entity{name = "curved-rail", position = {pos.x+2, pos.y-4}, direction = 1, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+4, pos.y-8}, direction = 7, force = game.forces.player}
      surf.create_entity{name = "curved-rail", position = {pos.x+8, pos.y-10}, direction = 6, force = game.forces.player} 
      surf.create_entity{name = "straight-rail", position = {pos.x+12, pos.y-12}, direction = 2, force = game.forces.player}
   elseif dir == 2 then
      surf.create_entity{name = "curved-rail", position = {pos.x+6, pos.y+2}, direction = 3, force = game.forces.player} 
      surf.create_entity{name = "straight-rail", position = {pos.x+8, pos.y+4}, direction = 1, force = game.forces.player}
      surf.create_entity{name = "curved-rail", position = {pos.x+12, pos.y+8}, direction = 0, force = game.forces.player} 
      surf.create_entity{name = "straight-rail", position = {pos.x+12, pos.y+12}, direction = 4, force = game.forces.player}
   elseif dir == 4 then
      surf.create_entity{name = "curved-rail", position = {pos.x+0, pos.y+6}, direction = 5, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-4, pos.y+8}, direction = 3, force = game.forces.player}
      surf.create_entity{name = "curved-rail", position = {pos.x-6, pos.y+12}, direction = 2, force = game.forces.player} 
      surf.create_entity{name = "straight-rail", position = {pos.x-12, pos.y+12}, direction = 6, force = game.forces.player}
   elseif dir == 6 then
      surf.create_entity{name = "curved-rail", position = {pos.x-4, pos.y+0}, direction = 7, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-8, pos.y-4}, direction = 5, force = game.forces.player}
      surf.create_entity{name = "curved-rail", position = {pos.x-10, pos.y-6}, direction = 4, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-12, pos.y-12}, direction = 0, force = game.forces.player}
   end
   
   --6 Remove 10 rail units from the player's hand
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 10
   
   --7. Sounds and results
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}
   game.get_player(pindex).play_sound{path = "entity-build/curved-rail"}
   printout("Built a right rail turn of 90 degrees, " .. build_comment, pindex)
   return
   
end


--Builds a 90 degree rail turn to the left from a horizontal or vertical end rail that is the anchor rail. The player needs to have at least 10 rails in hand.
function build_rail_turn_left_90_degrees(anchor_rail, pindex)
   local build_comment = ""
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local pos = nil
   local dir = -1
   local build_area = nil
   local can_place_all = true
   local is_end_rail
   
   --1. Firstly, check if the player has enough rails to place this (10 units)
   if not (stack.valid and stack.valid_for_read and stack.name == "rail" and stack.count > 10) then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("You need at least 10 rails in hand to build this turn.", pindex)
      return
   end
   
   --2. Secondly, verify the end rail and find its direction
   is_end_rail, dir, build_comment = check_end_rail(anchor_rail,pindex)
   if not is_end_rail then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(build_comment, pindex)
      return
   end
   pos = anchor_rail.position
   if dir == 1 or dir == 3 or dir == 5 or dir == 7 then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("This structure is for horizontal or vertical end rails only.", pindex)
      return
   end
   
   --3. Clear trees and rocks in the build area
   if dir == 0 then
      build_area = {{pos.x, pos.y},{pos.x-14,pos.y-12}}
   elseif dir == 2 then
      build_area = {{pos.x, pos.y},{pos.x+12,pos.y-14}}
   elseif dir == 4 then
      build_area = {{pos.x, pos.y},{pos.x+14,pos.y+12}}
   elseif dir == 6 then
      build_area = {{pos.x, pos.y},{pos.x-12,pos.y+14}}
   end 
   temp1, build_comment = mine_trees_and_rocks_in_area(build_area, pindex)
   
   --4. Check if every object can be placed
   if dir == 0 then 
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+0, pos.y-4}, direction = 0, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-4, pos.y-8}, direction = 1, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-6, pos.y-10}, direction = 3, force = game.forces.player} 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-12, pos.y-12}, direction = 2, force = game.forces.player}
   elseif dir == 2 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+6, pos.y+0}, direction = 2, force = game.forces.player} 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+8, pos.y-4}, direction = 3, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+12, pos.y-6}, direction = 5, force = game.forces.player} 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+12, pos.y-12}, direction = 4, force = game.forces.player}
   elseif dir == 4 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+2, pos.y+6}, direction = 4, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+4, pos.y+8}, direction = 5, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+8, pos.y+12}, direction = 7, force = game.forces.player} 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+12, pos.y+12}, direction = 6, force = game.forces.player}
   elseif dir == 6 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-4, pos.y+2}, direction = 6, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-8, pos.y+4}, direction = 7, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-10, pos.y+8}, direction = 1, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-12, pos.y+12}, direction = 0, force = game.forces.player}
   end
  
   if not can_place_all then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("Building area occupied.", pindex)
      return
   end
   
   --5. Build the five rail entities to create the turn
   if dir == 0 then 
      surf.create_entity{name = "curved-rail", position = {pos.x+0, pos.y-4}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-4, pos.y-8}, direction = 1, force = game.forces.player}
      surf.create_entity{name = "curved-rail", position = {pos.x-6, pos.y-10}, direction = 3, force = game.forces.player} 
      surf.create_entity{name = "straight-rail", position = {pos.x-12, pos.y-12}, direction = 2, force = game.forces.player}
   elseif dir == 2 then
      surf.create_entity{name = "curved-rail", position = {pos.x+6, pos.y+0}, direction = 2, force = game.forces.player} 
      surf.create_entity{name = "straight-rail", position = {pos.x+8, pos.y-4}, direction = 3, force = game.forces.player}
      surf.create_entity{name = "curved-rail", position = {pos.x+12, pos.y-6}, direction = 5, force = game.forces.player} 
      surf.create_entity{name = "straight-rail", position = {pos.x+12, pos.y-12}, direction = 4, force = game.forces.player}
   elseif dir == 4 then
      surf.create_entity{name = "curved-rail", position = {pos.x+2, pos.y+6}, direction = 4, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+4, pos.y+8}, direction = 5, force = game.forces.player}
      surf.create_entity{name = "curved-rail", position = {pos.x+8, pos.y+12}, direction = 7, force = game.forces.player} 
      surf.create_entity{name = "straight-rail", position = {pos.x+12, pos.y+12}, direction = 6, force = game.forces.player}
   elseif dir == 6 then
      surf.create_entity{name = "curved-rail", position = {pos.x-4, pos.y+2}, direction = 6, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-8, pos.y+4}, direction = 7, force = game.forces.player}
      surf.create_entity{name = "curved-rail", position = {pos.x-10, pos.y+8}, direction = 1, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-12, pos.y+12}, direction = 0, force = game.forces.player}
   end
   
   --6 Remove 10 rail units from the player's hand
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 10
   
   --7. Sounds and results
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}
   game.get_player(pindex).play_sound{path = "entity-build/curved-rail"}
   printout("Built a left rail turn of 90 degrees" .. build_comment, pindex)
   return
end


--Builds a minimal straight rail intersection on a horizontal or vertical end rail. Note: We should build other intersections with blueprint imports.
function build_small_plus_intersection(anchor_rail, pindex)
   local build_comment = ""
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local pos = nil
   local dir = -1
   local build_area = nil
   local can_place_all = true
   local is_end_rail
   
   --1. Firstly, check if the player has enough rails to place this (5 units)
   if not (stack.valid and stack.valid_for_read and stack.name == "rail" and stack.count > 5) then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("You need at least 5 rails in hand to build this structure.", pindex)
      return
   end
   
   --2. Secondly, verify the end rail and find its direction
   is_end_rail, dir, build_comment = check_end_rail(anchor_rail,pindex)
   if not is_end_rail then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(build_comment, pindex)
      return
   end
   pos = anchor_rail.position
   if dir == 1 or dir == 3 or dir == 5 or dir == 7 then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("This structure is for horizontal or vertical end rails only.", pindex)
      return
   end
   
   --3. Clear trees and rocks in the build area
   temp1, build_comment = mine_trees_and_rocks_in_area({{pos.x-7,pos.y-7},{pos.x+7,pos.y+7}}, pindex)
   
   --4. Check if every object can be placed
   if dir == 0 then 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+0, pos.y-2}, direction = 0, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+0, pos.y-4}, direction = 0, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+0, pos.y-2}, direction = 2, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-2, pos.y-2}, direction = 2, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+2, pos.y-2}, direction = 2, force = game.forces.player}
      
   elseif dir == 2 then
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+2, pos.y+0}, direction = 2, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+4, pos.y+0}, direction = 2, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+2, pos.y-2}, direction = 0, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+2, pos.y+0}, direction = 0, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+2, pos.y+2}, direction = 0, force = game.forces.player}
      
   elseif dir == 4 then
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+0, pos.y+2}, direction = 0, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+0, pos.y+4}, direction = 0, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+0, pos.y+2}, direction = 2, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-2, pos.y+2}, direction = 2, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+2, pos.y+2}, direction = 2, force = game.forces.player}
      
   elseif dir == 6 then
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-2, pos.y+0}, direction = 2, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-4, pos.y+0}, direction = 2, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-2, pos.y-2}, direction = 0, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-2, pos.y+0}, direction = 0, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-2, pos.y+2}, direction = 0, force = game.forces.player}
      
   end
  
   if not can_place_all then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("Building area occupied.", pindex)
      return
   end
   
   --5. Build the five rail entities to create the structure
   if dir == 0 then 
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y-2}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y-4}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y-2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y-2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y-2}, direction = 2, force = game.forces.player}
      
   elseif dir == 2 then
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y+0}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+4, pos.y+0}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y-2}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y+0}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y+2}, direction = 0, force = game.forces.player}
      
   elseif dir == 4 then
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y+2}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y+4}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y+2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y+2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y+2}, direction = 2, force = game.forces.player}
      
   elseif dir == 6 then
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y+0}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-4, pos.y+0}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y-2}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y+0}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y+2}, direction = 0, force = game.forces.player}
      
   end
   
   --6 Remove 5 rail units from the player's hand
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 5
   
   --7. Sounds and results
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}
   printout("Built a straight intersection." .. build_comment, pindex)
   return
end


--Appends a new straight or diagonal rail to a rail end found near the input position. The cursor needs to be holding rails.
function append_rail(pos, pindex)
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local is_end_rail = false
   local end_found = nil
   local end_dir = nil
   
   --0 Check if there is at least 1 rail in hand, else return
   if not (stack.valid and stack.valid_for_read and stack.name == "rail" and stack.count > 10) then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("You need at least 1 rail in hand.", pindex)
      return
   end
   
   --1 Check the cursor entity. If it is end rail, use this instead of scanning to extend the rail you want.
   local ent = players[pindex].tile.ents[1]
   is_end_rail, end_rail_dir, comment = check_end_rail(ent,pindex)
   if is_end_rail then
      end_found = ent
      end_rail_1, end_dir_1 = ent.get_rail_segment_end(defines.rail_direction.front)
      end_rail_2, end_dir_2 = ent.get_rail_segment_end(defines.rail_direction.back)
      if ent.unit_number == end_rail_1.unit_number then
         end_dir = end_dir_1
      elseif ent.unit_number == end_rail_2.unit_number then
         end_dir = end_dir_2
      end
   else
      --2 Scan the area around within a X tile radius of pos
      local ents = surf.find_entities_filtered{position = pos, radius = 3, name = "straight-rail"}
      if #ents == 0 then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         printout("No rails found nearby.",pindex)
      end

      --3 For the first straight rail found, check if it is at the end of its segment and if the rail is not within X tiles of pos, try the other end
      for i,rail in ipairs(ents) do
         end_rail_1, end_dir_1 = rail.get_rail_segment_end(defines.rail_direction.front)
         end_rail_2, end_dir_2 = rail.get_rail_segment_end(defines.rail_direction.back)
         if util.distance(pos, end_rail_1.position) < 3 then--is within range
            end_found = end_rail_1
            end_dir = end_dir_1
         elseif util.distance(pos, end_rail_2.position) < 3 then--is within range
            end_found = end_rail_2
            end_dir = end_dir_2
         end
      end   
      if end_found == nil then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         printout("No end rails found nearby", pindex)
         return
      end
      
      --4 Check if the found segment end is an end rail
      is_end_rail, end_rail_dir, comment = check_end_rail(end_found,pindex)
      if not is_end_rail then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         printout(build_comment, pindex)
         return
      end
   end
   
   --5 Confirmed as an end rail. Get its position and find the correct position and direction for the appended rail.
   end_rail_pos = end_found.position
   end_rail_dir = end_found.direction
   append_rail_dir = -1
   append_rail_pos = end_rail_pos
   
   --printout(" Rail end found at " .. end_found.position.x .. " , " .. end_found.position.y .. " , facing " .. end_found.direction, pindex)--Checks

   if end_found.name == "straight-rail" then
      if end_rail_dir == 0 or end_rail_dir == 4 then 
         append_rail_dir = 0
         if end_dir == defines.rail_direction.front then
            append_rail_pos = {end_rail_pos.x+0, end_rail_pos.y-2}
         else
            append_rail_pos = {end_rail_pos.x+0, end_rail_pos.y+2}
         end
         
      elseif end_rail_dir == 2 or end_rail_dir == 6 then
         append_rail_dir = 2
         if end_dir == defines.rail_direction.front then
            append_rail_pos = {end_rail_pos.x+2, end_rail_pos.y+0}
         else
            append_rail_pos = {end_rail_pos.x-2, end_rail_pos.y-0}
         end
         
      elseif end_rail_dir == 1 then
         append_rail_dir = 5
         if end_dir == defines.rail_direction.front then
            append_rail_pos = {end_rail_pos.x+0, end_rail_pos.y-2}
         else
            append_rail_pos = {end_rail_pos.x+2, end_rail_pos.y+0}
         end
      elseif end_rail_dir == 5 then
         append_rail_dir = 1
         if end_dir == defines.rail_direction.front then
            append_rail_pos = {end_rail_pos.x+0, end_rail_pos.y+2}
         else
            append_rail_pos = {end_rail_pos.x-2, end_rail_pos.y+0}
         end
         
      elseif end_rail_dir == 3 then
         append_rail_dir = 7
         if end_dir == defines.rail_direction.front then
            append_rail_pos = {end_rail_pos.x+2, end_rail_pos.y+0}
         else
            append_rail_pos = {end_rail_pos.x+0, end_rail_pos.y+2}
         end
      elseif end_rail_dir == 7 then
         append_rail_dir = 3
         if end_dir == defines.rail_direction.front then
            append_rail_pos = {end_rail_pos.x-2, end_rail_pos.y+0}
         else
            append_rail_pos = {end_rail_pos.x+0, end_rail_pos.y-2}
         end
      end
      
   elseif end_found.name == "curved-rail" then
         printout("Cannot append to curved end rails.",pindex)
         return
   end

   --6. Check if the selected 2x2 space is free for building, else return
   if not surf.can_place_entity{name = "straight-rail", position = append_rail_pos, direction = append_rail_dir} then 
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("Cannot extend the end rail.",pindex)
      return
   end
   
   --7. Finally, create the appended rail and subtract 1 rail from the hand.
   --game.get_player(pindex).build_from_cursor{position = append_rail_pos, direction = append_rail_dir}--acts unsolvably weird when building diagonals of rotation 5 and 7
   surf.create_entity{name = "straight-rail", position = append_rail_pos, direction = append_rail_dir, force = game.forces.player}
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 1
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}

end


--Places a train stop facing the direction of the end rail.
function build_end_train_stop(anchor_rail, pindex)
   local build_comment = ""
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local pos = nil
   local dir = -1
   local build_area = nil
   local can_place_all = true
   local is_end_rail
   
   --1. Firstly, check if the player has a train stop in hand
   if not (stack.valid and stack.valid_for_read and stack.name == "train-stop" and stack.count > 0) then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("You need at least 1 train stop in hand to build this structure.", pindex)
      return
   end
   
   --2. Secondly, verify the end rail and find its direction
   is_end_rail, dir, build_comment = check_end_rail(anchor_rail,pindex)
   if not is_end_rail then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(build_comment, pindex)
      return
   end
   pos = anchor_rail.position
   if dir == 1 or dir == 3 or dir == 5 or dir == 7 then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("This structure is for horizontal or vertical end rails only.", pindex)
      return
   end
   
   --3. Clear trees and rocks in the build area
   temp1, build_comment = mine_trees_and_rocks_in_area({{pos.x-5,pos.y-5},{pos.x+5,pos.y+5}}, pindex)
   
   --4. Check if every object can be placed
   if dir == 0 then 
      can_place_all = can_place_all and surf.can_place_entity{name = "train-stop", position = {pos.x+2, pos.y+0}, direction = 0, force = game.forces.player}
      
   elseif dir == 2 then
      can_place_all = can_place_all and surf.can_place_entity{name = "train-stop", position = {pos.x+0, pos.y+2}, direction = 2, force = game.forces.player}
      
   elseif dir == 4 then
      can_place_all = can_place_all and surf.can_place_entity{name = "train-stop", position = {pos.x-2, pos.y+0}, direction = 4, force = game.forces.player}
      
   elseif dir == 6 then
      can_place_all = can_place_all and surf.can_place_entity{name = "train-stop", position = {pos.x-0, pos.y-2}, direction = 6, force = game.forces.player}
      
   end
  
   if not can_place_all then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("Building area occupied, possibly by the player. Cursor mode recommended.", pindex)
      return
   end
   
   --5. Build the five rail entities to create the structure 
   if dir == 0 then 
      surf.create_entity{name = "train-stop", position = {pos.x+2, pos.y+0}, direction = 0, force = game.forces.player}
      
   elseif dir == 2 then
      surf.create_entity{name = "train-stop", position = {pos.x+0, pos.y+2}, direction = 2, force = game.forces.player}
      
   elseif dir == 4 then
      surf.create_entity{name = "train-stop", position = {pos.x-2, pos.y+0}, direction = 4, force = game.forces.player}
      
   elseif dir == 6 then
      surf.create_entity{name = "train-stop", position = {pos.x-0, pos.y-2}, direction = 6, force = game.forces.player}
      
   end
   
   --6 Remove 5 rail units from the player's hand
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 1
   
   --7. Sounds and results
   game.get_player(pindex).play_sound{path = "entity-build/train-stop"}
   printout("Built a train stop." .. build_comment, pindex)
   return
end

--Converts the entity orientation value to a heading
function get_heading(ent)
   local heading = "unknown"
   if ent == nil then
      return "nill error"
   end
   local ori = ent.orientation
   if ori < 0.0625 then
      heading = "North"
   elseif ori < 0.1875 then
      heading = "Northeast"
   elseif ori < 0.3125 then
      heading = "East"
   elseif ori < 0.4375 then
      heading = "Southeast"
   elseif ori < 0.5625 then
      heading = "South"
   elseif ori < 0.6875 then
      heading = "Southwest"
   elseif ori < 0.8125 then
      heading = "West"
   elseif ori < 0.9375 then
      heading = "Northwest"
   else
      heading = "North"
   end      
   return heading
end

