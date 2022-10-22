

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
      result = result .. " straight "
      if end_rail_dir == 0 then
         result = result .. " facing North "
      elseif end_rail_dir == 1 then
         result = result .. " facing Northeast "
      elseif end_rail_dir == 2 then
         result = result .. " facing East "
      elseif end_rail_dir == 3 then
         result = result .. " facing Southeast "
      elseif end_rail_dir == 4 then
         result = result .. " facing South "
      elseif end_rail_dir == 5 then
         result = result .. " facing Southwest "
      elseif end_rail_dir == 6 then
         result = result .. " facing West "
      elseif end_rail_dir == 7 then
         result = result .. " facing Northwest "
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
   
   elseif ent.name == "curved-rail" and is_end_rail == true then
      result = result .. " curved "
      if end_rail_dir == 0 then
         result = result .. " facing North "
      elseif end_rail_dir == 1 then
         result = result .. " facing Northeast "
      elseif end_rail_dir == 2 then
         result = result .. " facing East "
      elseif end_rail_dir == 3 then
         result = result .. " facing Southeast "
      elseif end_rail_dir == 4 then
         result = result .. " facing South "
      elseif end_rail_dir == 5 then
         result = result .. " facing Southwest "
      elseif end_rail_dir == 6 then
         result = result .. " facing West "
      elseif end_rail_dir == 7 then
         result = result .. " facing Northwest "
      end
   
   elseif ent.name == "curved-rail" and is_end_rail == false then
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
         result = result ..  "7 west and falling ends"
      end
   end
   
   --Check if at junction: The rail has at least 3 connections
   local connection_count = count_rail_connections(ent)
   if connection_count > 2 then
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


--Determines how many connections a rail has
function count_rail_connections(ent)
   local front_left_rail,temp1,temp2 = ent.get_connected_rail{ rail_direction = defines.rail_direction.front,rail_connection_direction = defines.rail_connection_direction.left}
   local front_right_rail,temp1,temp2 = ent.get_connected_rail{rail_direction = defines.rail_direction.front,rail_connection_direction = defines.rail_connection_direction.right}
   local back_left_rail,temp1,temp2 = ent.get_connected_rail{ rail_direction = defines.rail_direction.back,rail_connection_direction = defines.rail_connection_direction.left}
   local back_right_rail,temp1,temp2 = ent.get_connected_rail{rail_direction = defines.rail_direction.back,rail_connection_direction = defines.rail_connection_direction.right}
   local next_rail,temp1,temp2 = ent.get_connected_rail{rail_direction = defines.rail_direction.front,  rail_connection_direction = defines.rail_connection_direction.straight}
   local prev_rail,temp1,temp2 = ent.get_connected_rail{rail_direction = defines.rail_direction.back,   rail_connection_direction = defines.rail_connection_direction.straight}
   
   local connection_count = 0
   if next_rail ~= nil then
      connection_count = connection_count + 1
   end
   if prev_rail ~= nil then
      connection_count = connection_count + 1
   end
   if front_left_rail ~= nil then
      connection_count = connection_count + 1
   end
   if front_right_rail ~= nil then
      connection_count = connection_count + 1
   end
   if back_left_rail ~= nil then
      connection_count = connection_count + 1
   end
   if back_right_rail ~= nil then
      connection_count = connection_count + 1
   end
   return connection_count
end


--Determines if an entity is an end rail. Returns boolean is_end_rail, integer end rail direction, and string comment for errors.
function check_end_rail(check_rail, pindex)
   local is_end_rail = false
   local dir = -1
   local comment = "Check function error."
   
   --Check if the entity is a rail
   if check_rail == nil then
      is_end_rail = false
      comment = "Nil."
      return is_end_rail, -1, comment
   end
   
   --Check if end rail: The rail is at the end of its segment and has only 1 connection.
   end_rail_1, end_dir_1 = check_rail.get_rail_segment_end(defines.rail_direction.front)
   end_rail_2, end_dir_2 = check_rail.get_rail_segment_end(defines.rail_direction.back)
   local connection_count = count_rail_connections(check_rail)
   if (check_rail.unit_number == end_rail_1.unit_number or check_rail.unit_number == end_rail_2.unit_number) and connection_count < 2 then
      --End rail confirmed, get direction
      is_end_rail = true
      comment = "End rail confirmed."
      if check_rail.name == "straight-rail" then
         local next_rail_straight,temp1,temp2 = check_rail.get_connected_rail{rail_direction = defines.rail_direction.front, 
               rail_connection_direction = defines.rail_connection_direction.straight}
         local next_rail_left,temp1,temp2 = check_rail.get_connected_rail{rail_direction = defines.rail_direction.front,
               rail_connection_direction = defines.rail_connection_direction.left}
         local next_rail_right,temp1,temp2 = check_rail.get_connected_rail{rail_direction = defines.rail_direction.front,
               rail_connection_direction = defines.rail_connection_direction.right}
         local next_rail = nil
         if next_rail_straight ~= nil then
            next_rail = next_rail_straight
         elseif next_rail_left ~= nil then
            next_rail = next_rail_left
         elseif next_rail_right ~= nil then
            next_rail = next_rail_right
         end
         local prev_rail_straight,temp1,temp2 = check_rail.get_connected_rail{rail_direction = defines.rail_direction.back,   
               rail_connection_direction = defines.rail_connection_direction.straight}
         local prev_rail_left,temp1,temp2 = check_rail.get_connected_rail{rail_direction = defines.rail_direction.back,   
               rail_connection_direction = defines.rail_connection_direction.left}
         local prev_rail_right,temp1,temp2 = check_rail.get_connected_rail{rail_direction = defines.rail_direction.back,   
               rail_connection_direction = defines.rail_connection_direction.right}
         local prev_rail = nil
         if prev_rail_straight ~= nil then
            prev_rail = prev_rail_straight
         elseif prev_rail_left ~= nil then
            prev_rail = prev_rail_left
         elseif prev_rail_right ~= nil then
            prev_rail = prev_rail_right
         end
         if check_rail.direction == 0 and next_rail == nil then
            dir = 0
         elseif check_rail.direction == 0 and prev_rail == nil then
            dir = 4
         elseif check_rail.direction == 1 and next_rail == nil then
            dir = 7
         elseif check_rail.direction == 1 and prev_rail == nil then
            dir = 3
         elseif check_rail.direction == 2 and next_rail == nil then
            dir = 2
         elseif check_rail.direction == 2 and prev_rail == nil then
            dir = 6
         elseif check_rail.direction == 3 and next_rail == nil then
            dir = 1
         elseif check_rail.direction == 3 and prev_rail == nil then
            dir = 5
         elseif check_rail.direction == 4 and next_rail == nil then
            dir = 4
         elseif check_rail.direction == 4 and prev_rail == nil then
            dir = 0
         elseif check_rail.direction == 5 and next_rail == nil then
            dir = 3
         elseif check_rail.direction == 5 and prev_rail == nil then
            dir = 7
         elseif check_rail.direction == 6 and next_rail == nil then
            dir = 6
         elseif check_rail.direction == 6 and prev_rail == nil then
            dir = 2
         elseif check_rail.direction == 7 and next_rail == nil then
            dir = 5
         elseif check_rail.direction == 7 and prev_rail == nil then
            dir = 1
         else
            --This line should not be reachable
            is_end_rail = false
            comment = "Rail direction error."
            return is_end_rail, -3, comment
         end
      elseif check_rail.name == "curved-rail" then 
         local next_rail,temp1,temp2 = check_rail.get_connected_rail{rail_direction = defines.rail_direction.front,  
               rail_connection_direction = defines.rail_connection_direction.straight}
         local prev_rail,temp1,temp2 = check_rail.get_connected_rail{rail_direction = defines.rail_direction.back,   
               rail_connection_direction = defines.rail_connection_direction.straight}
         if check_rail.direction == 0 and next_rail == nil then
            dir = 4
         elseif check_rail.direction == 0 and prev_rail == nil then
            dir = 7
         elseif check_rail.direction == 1 and next_rail == nil then
            dir = 4
         elseif check_rail.direction == 1 and prev_rail == nil then
            dir = 1
         elseif check_rail.direction == 2 and next_rail == nil then
            dir = 6
         elseif check_rail.direction == 2 and prev_rail == nil then
            dir = 1
         elseif check_rail.direction == 3 and next_rail == nil then
            dir = 6
         elseif check_rail.direction == 3 and prev_rail == nil then
            dir = 3
         elseif check_rail.direction == 4 and next_rail == nil then
            dir = 0
         elseif check_rail.direction == 4 and prev_rail == nil then
            dir = 3
         elseif check_rail.direction == 5 and next_rail == nil then
            dir = 0
         elseif check_rail.direction == 5 and prev_rail == nil then
            dir = 5
         elseif check_rail.direction == 6 and next_rail == nil then
            dir = 2
         elseif check_rail.direction == 6 and prev_rail == nil then
            dir = 5
         elseif check_rail.direction == 7 and next_rail == nil then
            dir = 2
         elseif check_rail.direction == 7 and prev_rail == nil then
            dir = 7
         else
            --This line should not be reachable
            is_end_rail = false
            comment = "Rail direction error."
            return is_end_rail, -3, comment
         end
      end
   else
      --Not the end rail
      is_end_rail = false
      comment = "This rail is not the end rail."
      return is_end_rail, -4, comment
   end
   
   return is_end_rail, dir, comment
end


--Report more info about a vehicle. For trains, this would include the name, ID, and destination.
function vehicle_info(pindex)
   local result = ""
   if not game.get_player(pindex).driving then
      return "Not in a vehicle."
   end
   
   local vehicle = game.get_player(pindex).vehicle   
   local train = game.get_player(pindex).vehicle.train
   if train == nil then
      --This is a type of car or tank.
      result = vehicle.name .. " " 
      --can add more info here? For example health status and fuel status
      return result
   else
      --This is a type of locomotive or wagon.
      --Check the state of the train
      local train_state_id = train.state
      local train_state_text = ""
      local state_lookup = into_lookup(defines.train_state)
      if train_state_id ~= nil then
         train_state_text = state_lookup[train_state_id]
      else
         train_state_text = "No state"
      end
      
      --Add the train name
      result = " Train " .. get_train_name(train) .. " with ID " .. train.id .. ", "
      
      --Add the train state
      result = result .. train_state_text .. ", "
      
      --Declare destination if any. Note: Not tested yet.
      if train.has_path and train.path_end_stop ~= nil then 
         result = result .. " heading to train stop " .. train.path_end_stop.backer_name .. ", "
         result = result .. " traveled " .. train.path.travelled_distance .. " of " train.path.total_distance " distance. "
      end
      return result
   end
end


--Gets a train's name. The idea is that every locomotive on a train has the same backer name and this is the train's name. If there are multiple names, a warning returned.
function get_train_name(train)
   locos = train.locomotives
   local train_name = ""
   local multiple_names = false
   
   for i,loco in ipairs(locos["front_movers"]) do
      if train_name ~= "" and train_name ~= loco.backer_name then
         multiple_names = true
      end
      train_name = loco.backer_name
   end
   for i,loco in ipairs(locos["back_movers"]) do
      if train_name ~= "" and train_name ~= loco.backer_name then
         multiple_names = true
      end
      train_name = loco.backer_name
   end
   
   if train_name == "" then
      return "without a name"
   elseif multiple_names then
      return train_name .. ", and other names, "
   else
      return train_name
   end
end


--Sets a train's name. The idea is that every locomotive on a train has the same backer name and this is the train's name.
function set_train_name(train,new_name)
   locos = train.locomotives
   for i,loco in ipairs(locos["front_movers"]) do
      loco.backer_name = new_name
   end
   for i,loco in ipairs(locos["back_movers"]) do
      loco.backer_name = new_name
   end
end


--Sets a trainstop name
function set_trainstop_name(ent, new_name)
   ent.backer_name = new_name
end


--For a train, reports the name and distance of the nearest rail structure such as train stop. Reporting junctions will require having the structure log.
function read_structure_ahead(vehicle, back_instead)
   local back_instead = back_instead or false
   local train = vehicle.train
   local result = ""
   local front_rail = train.front_rail
   local front_last_rail = front_rail.get_rail_segment_end(train.rail_direction_from_front_rail)
   local entity_ahead = front_rail.get_rail_segment_entity(train.rail_direction_from_front_rail, false)
   local other_entity_1 = front_rail.get_rail_segment_entity(train.rail_direction_from_front_rail, true)
   local other_entity_2 = front_rail.get_rail_segment_entity(train.rail_direction_from_back_rail, false)
   local other_entity_3 = front_rail.get_rail_segment_entity(train.rail_direction_from_back_rail, true)
   local check_further = false
   local distance = -1
   
   if train == nil then
      printout("This check works only for trains.",pindex)
      return
   end
   
   if back_instead then--todo find correct other entity for the reverse direction, maybe using the back rail
      front_rail = train.front_rail
      front_last_rail   = front_rail.get_rail_segment_end(train.rail_direction_from_back_rail)
      entity_ahead      = entity_ahead
      other_enity_ahead = entity_ahead
      result = result .. "In reverse "
      return---***temp
   end
     
   --Check the distance ahead
   distance = util.distance(front_rail.position, front_last_rail.position)
   
   --Identify what is ahead
   if entity_ahead == nil then
      local is_end_rail, dir, comment = check_end_rail(front_last_rail, pindex)
      local connection_count = count_rail_connections(front_last_rail)
      if is_end_rail then
         result = result .. "End rail "
      elseif connection_count > 2 then
         result = result .. "Junction "
         check_further = true
      else
         check_further = true
         if other_entity_1 ~= nil then
            result = result .. " other 1, " .. other_entity_1.name .. " "--opposite direction rail signal
         elseif other_entity_2 ~= nil then
            result = result .. " other 2, " .. other_entity_1.name .. " "
         elseif other_entity_3 ~= nil then
            result = result .. " other 3, " .. other_entity_1.name .. " "--likely to be same entity as other 1
         else
            result = result .. " Unknown structure " --todo iterate to next rail or something to find it.
         end
      end   
   elseif entity_ahead.name == "train-stop" then
      distance = distance - 2
      if distance > 25 then
         result = "Train stop " .. entity_ahead.backer_name .. " ahead in " .. distance .. " meters. "
         if back_instead then
            result = "Train stop " .. entity_ahead.backer_name .. " behind in " .. distance .. " meters. "
         end
      else
         distance = util.distance(vehicle.position, entity_ahead.position) - 3.6
         if math.abs(distance) <= 0.2 then
            result = " Aligned with train stop " .. entity_ahead.backer_name
         elseif distance > 0.2 then
            result = math.floor(distance * 10) / 10 .. " meters away from train stop " .. entity_ahead.backer_name .. ", for this vehicle. " --maybe always read front locomotive?
         elseif distance < 0.2 then
            result = math.floor((-distance) * 10) / 10 .. " meters past train stop " .. entity_ahead.backer_name .. ", for this vehicle. " --maybe always read front locomotive?
         end
      end
   elseif entity_ahead.name == "rail-signal" then
      result = result .. "Rail signal, state " .. entity_ahead.signal_state .. " "
      check_further = true
   elseif entity_ahead.name == "rail-chain-signal" then
      result = result .. "Chain signal, state " .. entity_ahead.chain_signal_state .. " "
      check_further = true
   else
      result = result .. "Unknown structure "
   end
   
   --Todo here later: check the structure log to identify if there is a known junction
   if check_further then
      result = result
   end
   
   --Give a distance until the end rail. Note: The current distance is direct and ignores the rail length, which may cause errors for curved paths.
   if entity_ahead == nil or entity_ahead.name ~= "train-stop" then
      result = result .. " ahead in " .. math.floor(distance) .. " meters, "
      
      --Feature to notify passed train stops.
      if vehicle.name == "locomotive" then
         local heading = get_heading(vehicle)
         local pos = vehicle.position
         local scan_area = nil
         local passed_stop = nil
         --Scan behind the locomotive for 25 meters for straight rails todo test**
         if heading == "North" then
            scan_area = {{pos.x-3,pos.y-3},{pos.x+3,pos.y+25}}
         elseif heading == "South" then
            scan_area = {{pos.x-3,pos.y+3},{pos.x+3,pos.y-25}}
         elseif heading == "East" then
            scan_area = {{pos.x-25,pos.y-3},{pos.x+3,pos.y+3}}
         elseif heading == "West" then
            scan_area = {{pos.x+25,pos.y-3},{pos.x-3,pos.y+3}}
         else
            scan_area = {{pos.x+0,pos.y+0},{pos.x+1,pos.y+1}}
         end
         local ents = game.get_player(pindex).surface.find_entities_filtered{area = scan_area, name = "train-stop"}
         if #ents > 0 then
            passed_stop = ents[1]
            distance = util.distance(vehicle.position, passed_stop.position)
            if distance > 12.5 then
               result = result .. " train stop " .. passed_stop.backer_name .. " behind in " .. math.floor(distance) .. " meters. "
            else
               result = math.floor(distance) .. " meters past train stop " .. passed_stop.backer_name .. ", for this vehicle. " --maybe always read front locomotive?
            end
         end
      end
   end
   printout(result,pindex)
   return
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
   
   --1. Firstly, check if the player has enough rails to place this (10 units) **todo extend all 4 of these to check inventory if the hand is not right
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
   printout("Rail turn built, " .. build_comment, pindex)
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
   printout("Rail turn built, " .. build_comment, pindex)
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
   printout("Intersection built." .. build_comment, pindex)
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
         if players[pindex].build_lock == false then
            printout("No rails found nearby.",pindex)
         end
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
         if players[pindex].build_lock == false then
            printout("No end rails found nearby", pindex)
         end
         return
      end
      
      --4 Check if the found segment end is an end rail
      is_end_rail, end_rail_dir, comment = check_end_rail(end_found,pindex)
      if not is_end_rail then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         printout(comment, pindex)
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
      printout("Cannot place here to extend the rail.",pindex)
      return
   end
   
   --7. Finally, create the appended rail and subtract 1 rail from the hand.
   --game.get_player(pindex).build_from_cursor{position = append_rail_pos, direction = append_rail_dir}--acts unsolvably weird when building diagonals of rotation 5 and 7
   surf.create_entity{name = "straight-rail", position = append_rail_pos, direction = append_rail_dir, force = game.forces.player}
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 1
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}

end


--Places a train stop facing the direction of the end rail.
function build_train_stop(anchor_rail, pindex)
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
   
   --2. Secondly, find the direction based on end rail or player direction
   is_end_rail, end_rail_dir, build_comment = check_end_rail(anchor_rail,pindex)
   if is_end_rail then
      dir = end_rail_dir
   elseif end_rail_dir < 0 then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(build_comment, pindex)
      return
   else
      --Choose the dir based on player direction **todo verify
      if anchor_rail.direction == 0 or anchor_rail.direction == 4 then
         if players[pindex].player_direction == 0 or players[pindex].player_direction == 2 then
            dir = 0
         elseif players[pindex].player_direction == 4 or players[pindex].player_direction == 6 then
            dir = 4
         end
      elseif anchor_rail.direction == 2 or anchor_rail.direction == 6 then
         if players[pindex].player_direction == 0 or players[pindex].player_direction == 2 then
            dir = 2
         elseif players[pindex].player_direction == 4 or players[pindex].player_direction == 6 then
            dir = 6
         end
      end
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
   printout("Train stop built." .. build_comment, pindex)
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


function rail_builder_open(pindex, rail)
   --Set the player menu tracker to this menu
   players[pindex].menu = "rail_builder"
   players[pindex].in_menu = true
   
   --Set the menu line counter to 0
   players[pindex].rail_builder.index = 0
   
   --Play sound
   game.get_player(pindex).play_sound{path = "Open-Inventory-Sound"}
   
   --Load menu 
   players[pindex].rail_builder.rail = rail
   rail_builder(pindex, players[pindex].rail_builder.index, true)
end


function rail_builder_close(pindex, mute_in)
   local mute = mute_in or false
   --Set the player menu tracker to none
   players[pindex].menu = "none"
   players[pindex].in_menu = false

   --Set the menu line counter to 0
   players[pindex].rail_builder.index = 0
   
   --play sound
   if not mute then
      game.get_player(pindex).play_sound{path="Close-Inventory-Sound"}
   end
end


function rail_builder_up(pindex)
   --Decrement the index
   players[pindex].rail_builder.index = players[pindex].rail_builder.index - 1

   --Check the index against the limit
   if players[pindex].rail_builder.index < 0 then
      players[pindex].rail_builder.index = 0
   else
      --Play sound
      game.get_player(pindex).play_sound{path = "Inventory-Move"}
   end
   
   --Load menu 
   rail_builder(pindex, players[pindex].rail_builder.index, true)
end


function rail_builder_down(pindex)
   --Increment the index
   players[pindex].rail_builder.index = players[pindex].rail_builder.index + 1

   --Check the index against the limit
   if players[pindex].rail_builder.index > 6 then
      players[pindex].rail_builder.index = 6
   else
      --Play sound
      game.get_player(pindex).play_sound{path = "Inventory-Move"}
   end
   
   --Load menu 
   rail_builder(pindex, players[pindex].rail_builder.index, true)
end


--Build menu to build rail structures **todo test
function rail_builder(pindex, menu_line_in, reading_in)
   local comment = ""
   local menu_line = menu_line_in
   local reading = reading_in
   local rail = players[pindex].rail_builder.rail
   local is_end_rail, end_rail_dir, e_comment = check_end_rail(rail, pindex)
   
   if end_rail_dir < 0 then
      comment = " Rail error " .. end_rail_dir
      printout(comment,pindex)
      return
   end
   
   if menu_line == 0 then
      comment = comment .. "Select a structure to build by going up or down this menu. Attempt to build it via LEFT BRACKET. "
      if not is_end_rail then
         comment = comment .. "Note that end rails have more options available. "
      end
      printout(comment,pindex)
      return
   end
   if not is_end_rail then
      --End rails have more options than mid rails. For mid rails we skip these options
      menu_line = menu_line + 4
   end
   
   if menu_line == 1 then
      if reading then
         comment = comment .. "Left turn 90 degrees"
         printout(comment,pindex)
      else
         --Build it here
         build_rail_turn_left_90_degrees(rail, pindex)
      end
   elseif menu_line == 2 then
      if reading then
         comment = comment .. "Left turn 45 degrees"
         printout(comment,pindex)
      else
         --Build it here
         printout("This feature is not yet supported.",pindex)
      end
   elseif menu_line == 3 then
      if reading then
         comment = comment .. "Right turn 90 degrees"
         printout(comment,pindex)
      else
         --Build it here
         build_rail_turn_right_90_degrees(rail, pindex)
      end
   elseif menu_line == 4 then
      if reading then
         comment = comment .. "Right turn 45 degrees"
         printout(comment,pindex)
      else
         --Build it here
         printout("This feature is not yet supported.",pindex)
      end
   elseif menu_line == 5 then
      if reading then
         comment = comment .. "Train stop"
         printout(comment,pindex)
      else
         --Build it here
         build_train_stop(rail, pindex)
      end
   elseif menu_line == 6 then
      if reading then
         comment = comment .. "Plus intersection"
         printout(comment,pindex)
      else
         --Build it here
         build_small_plus_intersection(rail, pindex)
      end
   end
   return
end
