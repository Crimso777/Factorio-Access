
--Key information about rail units. 
function rail_ent_info(pindex, ent, description)  
   local result = ""
   local is_end_rail = false
   local is_horz_or_vert = false
   
   --Check if end rail: The rail is at the end of its segment and is also not connected to another rail
   is_end_rail, end_rail_dir, build_comment = check_end_rail(ent,pindex)
   if is_end_rail then
      --Further check if it is a single rail
      if build_comment == "single rail" then
         result = result .. "Single "
      end
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
         result = result ..  "0 with ends facing south and falling diagonal "
      elseif ent.direction == 1 then
         result = result ..  "1 with ends facing south and rising diagonal "
      elseif ent.direction == 2 then
         result = result ..  "2 with ends facing west  and rising diagonal "
      elseif ent.direction == 3 then
         result = result ..  "3 with ends facing west  and falling diagonal "
      elseif ent.direction == 4 then
         result = result ..  "4 with ends facing north and falling diagonal "
      elseif ent.direction == 5 then
         result = result ..  "5 with ends facing north and rising diagonal "
      elseif ent.direction == 6 then
         result = result ..  "6 with ends facing east  and rising diagonal "
      elseif ent.direction == 7 then
         result = result ..  "7 with ends facing east  and falling diagonal "
      end
   end
   
   --Check if at junction: The rail has at least 3 connections
   local connection_count = count_rail_connections(ent)
   if connection_count > 2 then
      result = result .. ", junction, "
   end
   
   --Check if it has rail signals
   local chain_s_count = 0
   local rail_s_count = 0
   local signals = ent.surface.find_entities_filtered{position = ent.position, radius = 2, name = "rail-chain-signal"}
   for i,s in ipairs(signals) do
      chain_s_count = chain_s_count + 1
   end
   
   signals = ent.surface.find_entities_filtered{position = ent.position, radius = 2, name = "rail-signal"}
   for i,s in ipairs(signals) do
      rail_s_count = rail_s_count + 1
   end
   
   if chain_s_count + rail_s_count == 0 then
      --(nothing)
   elseif chain_s_count + rail_s_count == 1 then
      result = result .. " with one signal, "
   elseif chain_s_count + rail_s_count == 2 then
      result = result .. " with a pair of signals, "
   elseif chain_s_count + rail_s_count > 2 then
      result = result .. " with many signals, "
   end
   
   --Check if there is a train stop nearby, to announce station spaces
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
      
      --Check if this rail is in the correct direction of the train stop
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
   
   if is_intersection_rail(ent, pindex) then
      result = result .. ", intersection "
   end
   
   return result
end


--Determines how many connections a rail has
function count_rail_connections(ent)
   local front_left_rail,r_dir_back,c_dir_back = ent.get_connected_rail{ rail_direction = defines.rail_direction.front,rail_connection_direction = defines.rail_connection_direction.left}
   local front_right_rail,r_dir_back,c_dir_back = ent.get_connected_rail{rail_direction = defines.rail_direction.front,rail_connection_direction = defines.rail_connection_direction.right}
   local back_left_rail,r_dir_back,c_dir_back = ent.get_connected_rail{ rail_direction = defines.rail_direction.back,rail_connection_direction = defines.rail_connection_direction.left}
   local back_right_rail,r_dir_back,c_dir_back = ent.get_connected_rail{rail_direction = defines.rail_direction.back,rail_connection_direction = defines.rail_connection_direction.right}
   local next_rail,r_dir_back,c_dir_back = ent.get_connected_rail{rail_direction = defines.rail_direction.front,  rail_connection_direction = defines.rail_connection_direction.straight}
   local prev_rail,r_dir_back,c_dir_back = ent.get_connected_rail{rail_direction = defines.rail_direction.back,   rail_connection_direction = defines.rail_connection_direction.straight}
   
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
   if not check_rail.valid then
      is_end_rail = false
      comment = "Invalid."
      return is_end_rail, -1, comment
   end
   if not (check_rail.name == "straight-rail" or check_rail.name == "curved-rail") then
      is_end_rail = false
      comment = "Not a rail."
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
      if connection_count == 0 then
         comment = "single rail"
      end
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
         local next_rail,r_dir_back,c_dir_back = check_rail.get_connected_rail{rail_direction = defines.rail_direction.front,  
               rail_connection_direction = defines.rail_connection_direction.straight}
         local prev_rail,r_dir_back,c_dir_back = check_rail.get_connected_rail{rail_direction = defines.rail_direction.back,   
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


--Report more info about a vehicle. For trains, this would include the name, ID, and train state.
function vehicle_info(pindex)
   local result = ""
   if not game.get_player(pindex).driving then
      return "Not in a vehicle."
   end
   
   local vehicle = game.get_player(pindex).vehicle   
   local train = game.get_player(pindex).vehicle.train
   if train == nil then
      --This is a type of car or tank.
      result = "Driving " .. vehicle.name .. ", " .. fuel_inventory_info(vehicle)
      --laterdo: can add more info here? For example health or ammo or trunk contents
      return result
   else
      --This is a type of locomotive or wagon.
      
      --Add the train name
      result = "On board " .. vehicle.name .. " of train " .. get_train_name(train) .. ", "
      
      --Add the train state
      result = result .. get_train_state_info(train) .. ", "
      
      --Declare destination if any. Note: Not tested yet. laterdo
      --if train.has_path and train.path_end_stop ~= nil then 
      --   result = result .. " heading to train stop " .. train.path_end_stop.backer_name .. ", "
      --   result = result .. " traveled a distance of " .. train.path.travelled_distance .. " out of " train.path.total_distance " distance, "
      --end
      
      --Note that more info and options are found in the train menu
      if vehicle.name == "locomotive" then
         result = result .. " Press LEFT BRACKET to open the train menu. "
      end
      return result
   end
end

--Look up and translate the train state. -laterdo better explanations
function get_train_state_info(train)
   local train_state_id = train.state
   local train_state_text = ""
   local state_lookup = into_lookup(defines.train_state)
   if train_state_id ~= nil then
      train_state_text = state_lookup[train_state_id]
   else
      train_state_text = "None"
   end
   return train_state_text
end

--Look up and translate the signal state. -test**
function get_signal_state_info(signal)
   local state_id = 0
   local state_lookup = nil
   local state_name = ""
   local result = ""
   if signal.name == "rail-signal" then
      state_id = signal.signal_state
	  state_lookup = into_lookup(defines.signal_state)
	  state_name = state_lookup[state_id]
	  result = state_name
   elseif signal.name == "rail-chain-signal" then 
      state_id = signal.chain_signal_state
	  state_lookup = into_lookup(defines.chain_signal_state)
	  state_name = state_lookup[state_id]
	  result = state_name
	  if state_name == "none_open" then result = "closed" end
   end
   return result
end

--Gets a train's name. The idea is that every locomotive on a train has the same backer name and this is the train's name. If there are multiple names, a warning returned.
function get_train_name(train)
   local locos = train.locomotives
   local train_name = ""
   local multiple_names = false
   
   if locos == nil then
      return "without locomotives"
   end
   
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
      local oldest_name = resolve_train_name(train)
      set_train_name(train,oldest_name)
      return oldest_name
   else
      return train_name
   end
end


--Sets a train's name. The idea is that every locomotive on a train has the same backer name and this is the train's name.
function set_train_name(train,new_name)
   local locos = train.locomotives
   if locos == nil then
      return false
   end
   for i,loco in ipairs(locos["front_movers"]) do
      loco.backer_name = new_name
   end
   for i,loco in ipairs(locos["back_movers"]) do
      loco.backer_name = new_name
   end
   return true
end

--Finds the oldest locomotive and applies its name across the train. Any new loco will be newwer and so the older names will be kept.
function resolve_train_name(train)
   local locos = train.locomotives
   local oldest_loco = nil
   
   if locos == nil then
      return "without locomotives"
   end
   
   for i,loco in ipairs(locos["front_movers"]) do
      if oldest_loco == nil then
         oldest_loco = loco
      elseif oldest_loco.unit_number > loco.unit_number then
         oldest_loco = loco
      end
   end
   for i,loco in ipairs(locos["back_movers"]) do
      if oldest_loco == nil then
         oldest_loco = loco
      elseif oldest_loco.unit_number > loco.unit_number then
         oldest_loco = loco
      end
   end
   
   if oldest_loco ~= nil then
      return oldest_loco.backer_name
   else
      return "error resolving train name"
   end
end


--Returns the rail at the end of an input rail's segment. If the input rail is already one end of the segment then it returns the other end. NOT TESTED
function get_rail_segment_other_end(rail)
   local end_rail_1, end_dir_1 = rail.get_rail_segment_end(defines.rail_direction.front) --Cannot be nil
   local end_rail_2, end_dir_2 = rail.get_rail_segment_end(defines.rail_direction.back) --Cannot be nil
   
   if rail.unit_number == end_rail_1.unit_number and rail.unit_number ~= end_rail_2.unit_number then
      return end_rail_2
   elseif rail.unit_number ~= end_rail_1.unit_number and rail.unit_number == end_rail_2.unit_number then
      return end_rail_1
   else
      --The other end is either both options or neither, so return any.
      return end_rail_1
   end
end


--For a rail at the end of its segment, returns the neighboring rail segment's end rail. Respects dir in terms of left/right/straight if it is given, else returns the first found option. NOTE: Not tested individually but worked in combination with other functions.
function get_neighbor_rail_segment_end(rail, con_dir_in)
   local dir = con_dir_in or nil
   local requested_neighbor_rail_1 = nil
   local requested_neighbor_rail_2 = nil
   local neighbor_rail,r_dir_back,c_dir_back = nil, nil, nil
   
   if dir ~= nil then
      --Check requested neighbor
      requested_neighbor_rail_1, req_dir_1, req_con_dir_1 = rail.get_connected_rail{ rail_direction = defines.rail_direction.front,rail_connection_direction = dir}
      requested_neighbor_rail_2, req_dir_2, req_con_dir_2 = rail.get_connected_rail{ rail_direction = defines.rail_direction.back ,rail_connection_direction = dir}
      if requested_neighbor_rail_1 ~= nil and not rail.is_rail_in_same_rail_segment_as(requested_neighbor_rail_1) then
         return requested_neighbor_rail_1, req_dir_1, req_con_dir_1
      elseif requested_neighbor_rail_2 ~= nil and not rail.is_rail_in_same_rail_segment_as(requested_neighbor_rail_2) then
         return requested_neighbor_rail_2, req_dir_2, req_con_dir_2
      else
         return nil, nil, nil
      end
   else    
      --Try all 6 options until you get any
      neighbor_rail,r_dir_back,c_dir_back = rail.get_connected_rail{rail_direction = defines.rail_direction.front,  rail_connection_direction = defines.rail_connection_direction.straight}
      if neighbor_rail ~= nil and not neighbor_rail.is_rail_in_same_rail_segment_as(rail) then
         return neighbor_rail,r_dir_back,c_dir_back
      end
      
      neighbor_rail,r_dir_back,c_dir_back = rail.get_connected_rail{rail_direction = defines.rail_direction.back,   rail_connection_direction = defines.rail_connection_direction.straight}
      if neighbor_rail ~= nil and not neighbor_rail.is_rail_in_same_rail_segment_as(rail) then
         return neighbor_rail,r_dir_back,c_dir_back
      end
      
      neighbor_rail,r_dir_back,c_dir_back = rail.get_connected_rail{ rail_direction = defines.rail_direction.front,rail_connection_direction = defines.rail_connection_direction.left}
      if neighbor_rail ~= nil and not neighbor_rail.is_rail_in_same_rail_segment_as(rail) then
         return neighbor_rail,r_dir_back,c_dir_back
      end
      
      neighbor_rail,r_dir_back,c_dir_back = rail.get_connected_rail{rail_direction = defines.rail_direction.front,rail_connection_direction = defines.rail_connection_direction.right}
      if neighbor_rail ~= nil and not neighbor_rail.is_rail_in_same_rail_segment_as(rail) then
         return neighbor_rail,r_dir_back,c_dir_back
      end
      
      neighbor_rail,r_dir_back,c_dir_back = rail.get_connected_rail{ rail_direction = defines.rail_direction.back,rail_connection_direction = defines.rail_connection_direction.left}
      if neighbor_rail ~= nil and not neighbor_rail.is_rail_in_same_rail_segment_as(rail) then
         return neighbor_rail,r_dir_back,c_dir_back
      end
      
      neighbor_rail,r_dir_back,c_dir_back = rail.get_connected_rail{rail_direction = defines.rail_direction.back,rail_connection_direction = defines.rail_connection_direction.right}
      if neighbor_rail ~= nil and not neighbor_rail.is_rail_in_same_rail_segment_as(rail) then
         return neighbor_rail,r_dir_back,c_dir_back
      end
      
      return nil, nil, nil
   end
end


--Reads all rail segment entities around a rail.
--Result 1: A rail or chain signal creates a new segment and is at the end of one of the two segments.
--Result 2: A train creates a new segment and is at the end of one of the two segments. It can be reported twice for FW1 and BACK2 or for FW2 and BACK1.
function read_all_rail_segment_entities(pindex, rail)
   local message = ""
   local ent_f1 = rail.get_rail_segment_entity(defines.rail_direction.front, true)
   local ent_f2 = rail.get_rail_segment_entity(defines.rail_direction.front, false)
   local ent_b1 = rail.get_rail_segment_entity(defines.rail_direction.back, true)  
   local ent_b2 = rail.get_rail_segment_entity(defines.rail_direction.back, false) 
   
   if ent_f1 == nil then
      message = message .. "forward 1 is nil, "
   elseif ent_f1.name == "train-stop" then
      message = message .. "forward 1 is train stop "               .. ent_f1.backer_name .. ", "
   elseif ent_f1.name == "rail-signal" then 
      message = message .. "forward 1 is rails signal with signal " .. get_signal_state_info(ent_f1) .. ", "
   elseif ent_f1.name == "rail-chain-signal" then 
      message = message .. "forward 1 is chain signal with signal " .. get_signal_state_info(ent_f1) .. ", "
   else
      message = message .. "forward 1 is else, "                    .. ent_f1.name .. ", "
   end
   
   if ent_f2 == nil then
      message = message .. "forward 2 is nil, "
   elseif ent_f2.name == "train-stop" then
      message = message .. "forward 2 is train stop "               .. ent_f2.backer_name .. ", "
   elseif ent_f2.name == "rail-signal" then 
      message = message .. "forward 2 is rails signal with signal " .. get_signal_state_info(ent_f2) .. ", "
   elseif ent_f2.name == "rail-chain-signal" then 
      message = message .. "forward 2 is chain signal with signal " .. get_signal_state_info(ent_f2) .. ", "
   else
      message = message .. "forward 2 is else, "                    .. ent_f2.name .. ", "
   end
   
   if ent_b1 == nil then
      message = message .. "back 1 is nil, "
   elseif ent_b1.name == "train-stop" then
      message = message .. "back 1 is train stop "               .. ent_b1.backer_name .. ", "
   elseif ent_b1.name == "rail-signal" then 
      message = message .. "back 1 is rails signal with signal " .. get_signal_state_info(ent_b1) .. ", "
   elseif ent_b1.name == "rail-chain-signal" then 
      message = message .. "back 1 is chain signal with signal " .. get_signal_state_info(ent_b1) .. ", "
   else
      message = message .. "back 1 is else, "                    .. ent_b1.name .. ", "
   end
   
   if ent_b2 == nil then
      message = message .. "back 2 is nil, "
   elseif ent_b2.name == "train-stop" then
      message = message .. "back 2 is train stop "               .. ent_b2.backer_name .. ", "
   elseif ent_b2.name == "rail-signal" then 
      message = message .. "back 2 is rails signal with signal " .. get_signal_state_info(ent_b2) .. ", "
   elseif ent_b2.name == "rail-chain-signal" then 
      message = message .. "back 2 is chain signal with signal " .. get_signal_state_info(ent_b2) .. ", "
   else
      message = message .. "back 2 is else, "                    .. ent_b2.name .. ", "
   end
   
   printout(message,pindex)
   return
end


--Gets opposite rail direction
function get_opposite_rail_direction(dir)
   if dir == defines.rail_direction.front then
      return defines.rail_direction.back
   else
      return defines.rail_direction.front
   end
end

--For testing: Report where object A is with respect to object B
function where_is_a_for_b(a,b)
   local to_the_north = false
   local to_the_east  = false
   local to_the_south = false
   local to_the_west  = false
   local message = "It is to the "
   
   if a.position.y - b.position.y > 0.9 then
      to_the_south = true
      message = message .. "south"
   elseif a.position.y - b.position.y < -0.9 then
      to_the_north = true
      message = message .. "north"
   end
   if a.position.x - b.position.x > 0.9 then
      to_the_east = true
      message = message .. "east"
   elseif a.position.x - b.position.x < -0.9 then
      to_the_west = true
      message = message .. "west"
   end
   
   if not to_the_east and not to_the_north and not to_the_south and not to_the_west then
      message = "The entity is nearby "
   end
   message = message .. ", " .. math.floor(math.abs(util.distance(a.position,b.position))) .. " tiles away."
   return message
end


--Checks if the train is all in one segment, which means the front and back rails are in the same segment.
function train_is_all_in_one_segment(train)
	return train.front_rail.is_rail_in_same_rail_segment_as(train.back_rail)
end


--[[Returns the leading rail and the direction on it that is "ahead" and the leading stock. This is the direction that the currently boarded locomotive or wagon is facing.
--Checks whether the current locomotive is one of the front or back locomotives and gives leading rail and leading stock accordingly.
--If this is not a locomotive, takes the front as the leading side.
--Checks distances with respect to the front/back stocks of the train
--Does not require any specific position or rotation for any of the stock!
--For the leading rail, the connected rail that is farthest from the leading stock is in the "ahead" direction. 
--]]
function get_leading_rail_and_dir_of_train_by_boarded_vehicle(pindex, train)
   local leading_rail = nil
   local trailing_rail = nil
   local leading_stock = nil
   local ahead_rail_dir = nil

   local vehicle = game.get_player(pindex).vehicle
   local front_rail = train.front_rail
   local back_rail  = train.back_rail
   local locos = train.locomotives
   local vehicle_is_a_front_loco = nil
   
   --Find the leading rail. If any "front" locomotive velocity is positive, the front stock is the one going ahead and its rail is the leading rail. 
   if vehicle.name == "locomotive" then
      --Leading direction is the one this loconotive faces
      for i,loco in ipairs(locos["front_movers"]) do
         if vehicle.unit_number == loco.unit_number then
            vehicle_is_a_front_loco = true
         end
      end
      if vehicle_is_a_front_loco == true then
         leading_rail = front_rail
		 trailing_rail = back_rail
         leading_stock = train.front_stock 
      else
         for i,loco in ipairs(locos["back_movers"]) do
            if vehicle.unit_number == loco.unit_number then
               vehicle_is_a_front_loco = false
            end
         end
         if vehicle_is_a_front_loco == false then
            leading_rail = back_rail
			trailing_rail = front_rail
            leading_stock = train.back_stock
         else
            --Unexpected place
            return nil, -1, nil
         end
      end
   else
      --Just assume the front stock is leading
      leading_rail = front_rail
	  trailing_rail = back_rail
      leading_stock = train.front_stock
   end
   
   --Error check
   if leading_rail == nil then
      return nil, -2, nil
   end
   
   --Find the ahead direction. For the leading rail, the connected rail that is farthest from the leading stock is in the "ahead" direction. 
   --Repurpose the variables named front_rail and back_rail
   front_rail = leading_rail.get_connected_rail{ rail_direction = defines.rail_direction.front, rail_connection_direction = defines.rail_connection_direction.straight}
   if front_rail == nil then
      front_rail = leading_rail.get_connected_rail{ rail_direction = defines.rail_direction.front, rail_connection_direction = defines.rail_connection_direction.left}
   end
   if front_rail == nil then
      front_rail = leading_rail.get_connected_rail{ rail_direction = defines.rail_direction.front, rail_connection_direction = defines.rail_connection_direction.right}
   end
   if front_rail == nil then
      --The leading rail is an end rail at the front direction
      return leading_rail, defines.rail_direction.front, leading_stock
   end
   
   back_rail = leading_rail.get_connected_rail{ rail_direction = defines.rail_direction.back, rail_connection_direction = defines.rail_connection_direction.straight}
   if back_rail == nil then
      back_rail = leading_rail.get_connected_rail{ rail_direction = defines.rail_direction.back, rail_connection_direction = defines.rail_connection_direction.left}
   end
   if back_rail == nil then
      back_rail = leading_rail.get_connected_rail{ rail_direction = defines.rail_direction.back, rail_connection_direction = defines.rail_connection_direction.right}
   end
   if back_rail == nil then
      --The leading rail is an end rail at the back direction
      return leading_rail, defines.rail_direction.back, leading_stock
   end
   
   local front_dist = math.abs(util.distance(leading_stock.position, front_rail.position)) 
   local back_dist = math.abs(util.distance(leading_stock.position, back_rail.position)) 
   --The connected rail that is farther from the leading stock is in the ahead direction.
   if front_dist > back_dist then
      return leading_rail, defines.rail_direction.front, leading_stock
   else
      return leading_rail, defines.rail_direction.back, leading_stock
   end
end
--[[ALT:To find the leading rail, checks the velocity sign of any "front-facing" locomotive. 
   --f any "front" locomotive velocity is positive, the front stock is the one going ahead and its rail is the leading rail. 
   --if front_facing_loco.speed >= 0 then
   --   leading_rail = front_rail
   --   leading_stock = train.front_stock 
   --else
   --   leading_rail = back_rail
   --   leading_stock = train.back_stock
   --end
--]]


--Return what is ahead at the end of this rail's segment in this given direction.
--Return the entity, a label, an extra value sometimes, and whether the entity faces the forward direction
function identify_rail_segment_end_object(rail, dir_ahead, accept_only_forward, prefer_back)
   local result_entity = nil
   local result_entity_label = ""
   local result_extra = nil
   local result_is_forward = nil
   
   --Correction: Flip the correct direction ahead for mismatching diagonal rails
   if rail.name == "straight-rail" and (rail.direction == 5 or rail.direction == 7) 
      or rail.name == "curved-rail" and (rail.direction == 0 or rail.direction == 1 or rail.direction == 2 or rail.direction == 3) then
      dir_ahead = get_opposite_rail_direction(dir_ahead)
   end
   
   local segment_last_rail = rail.get_rail_segment_end(dir_ahead)
   local entity_ahead = nil
   local entity_ahead_forward = rail.get_rail_segment_entity(dir_ahead,false)
   local entity_ahead_reverse = rail.get_rail_segment_entity(dir_ahead,true)
   
   local segment_last_is_end_rail, end_rail_dir, comment = check_end_rail(segment_last_rail, pindex)
   local segment_last_neighbor_count = count_rail_connections(segment_last_rail)
   
   if entity_ahead_forward ~= nil then
      entity_ahead = entity_ahead_forward
      result_is_forward = true
   elseif entity_ahead_reverse ~= nil and accept_only_forward == false then
      entity_ahead = entity_ahead_reverse
      result_is_forward = false
   end
   
   if prefer_back == true and entity_ahead_reverse ~= nil and accept_only_forward == false then 
      entity_ahead = entity_ahead_reverse
      result_is_forward = false
   end
   
   --When no entity ahead, check if the segment end is an end rail or fork rail?
   if entity_ahead == nil then
      if segment_last_is_end_rail then
         --End rail
         result_entity = segment_last_rail
         result_entity_label = "end rail"
         result_extra = end_rail_dir
         return result_entity, result_entity_label, result_extra, result_is_forward
      elseif segment_last_neighbor_count > 2 then
         --Junction rail
         result_entity = segment_last_rail
         result_entity_label = "fork split"
         result_extra = rail --A rail from the segment "entering" the junction
         return result_entity, result_entity_label, result_extra, result_is_forward
      else
         --The neighbor of the segment end rail is either a fork or an end rail or has an entity instead
		 neighbor_rail, neighbor_r_dir, neighbor_c_dir = get_neighbor_rail_segment_end(segment_last_rail, nil)
		 if neighbor_rail == nil then
		    --This must be a closed loop?
			result_entity = nil
            result_entity_label = "loop" 
            result_extra = nil
			return result_entity, result_entity_label, result_extra, result_is_forward
		 elseif count_rail_connections(neighbor_rail) > 2 then
		    --The neighbor is a forking rail
			result_entity = neighbor_rail
            result_entity_label = "fork merge" 
            result_extra = nil
			return result_entity, result_entity_label, result_extra, result_is_forward
		 elseif count_rail_connections(neighbor_rail) == 1 then
		    --The neighbor is an end rail
			local neighbor_is_end_rail, end_rail_dir, comment = check_end_rail(neighbor_rail, pindex)
			result_entity = neighbor_rail
            result_entity_label = "neighbor end" 
            result_extra = end_rail_dir
			return result_entity, result_entity_label, result_extra, result_is_forward
		 else
		    --The neighbor rail should have an entity?
            result_entity = segment_last_rail
            result_entity_label = "other rail" 
            result_extra = nil
            return result_entity, result_entity_label, result_extra, result_is_forward
		 end
      end
   --When entity ahead, check its type
   else
      if entity_ahead.name == "rail-signal" then
         result_entity = entity_ahead
         result_entity_label = "rail signal"
         result_extra = get_signal_state_info(entity_ahead)
         return result_entity, result_entity_label, result_extra, result_is_forward
      elseif entity_ahead.name == "rail-chain-signal" then
         result_entity = entity_ahead
         result_entity_label = "chain signal"
         result_extra = get_signal_state_info(entity_ahead)
         return result_entity, result_entity_label, result_extra, result_is_forward
      elseif entity_ahead.name == "train-stop" then
         result_entity = entity_ahead
         result_entity_label = "train stop"
         result_extra = entity_ahead.backer_name
         return result_entity, result_entity_label, result_extra, result_is_forward
      else
         --This is NOT expected.
         result_entity = entity_ahead
         result_entity_label = "other entity"
         result_extra = "Unidentified " .. entity_ahead.name
         return result_entity, result_entity_label, result_extra, result_is_forward
      end
   end
end


--Reads out the nearest railway object ahead with relevant details. Skips to the next segment if needed. 
--The output could be an end rail, junction rail, rail signal, chain signal, or train stop. 
function get_next_rail_entity_ahead(origin_rail, dir_ahead, only_this_segment)
   local next_entity, next_entity_label, result_extra, next_is_forward = identify_rail_segment_end_object(origin_rail, dir_ahead, false, false)
   local iteration_count = 1
   local segment_end_ahead, dir_se = origin_rail.get_rail_segment_end(dir_ahead)
   local prev_rail = segment_end_ahead
   local current_rail = origin_rail
   local neighbor_r_dir = dir_ahead
   local neighbor_c_dir = nil
   
   --First correction for the train stop exception
   if next_entity_label == "train stop" and next_is_forward == false then
      next_entity, next_entity_label, result_extra, next_is_forward = identify_rail_segment_end_object(current_rail, neighbor_r_dir, true, false)
   end
   
   --Skip all "other rail" cases
   while not only_this_segment and next_entity_label == "other rail" and iteration_count < 100 do 
      if iteration_count % 2 == 1 then
         --Switch to neighboring segment
         current_rail, neighbor_r_dir, neighbor_c_dir = get_neighbor_rail_segment_end(prev_rail, nil)
         prev_rail = current_rail
         next_entity, next_entity_label, result_extra, next_is_forward = identify_rail_segment_end_object(current_rail, neighbor_r_dir, false, true)
         --Correction for the train stop exception
         if next_entity_label == "train stop" and next_is_forward == false then
            next_entity, next_entity_label, result_extra, next_is_forward = identify_rail_segment_end_object(current_rail, neighbor_r_dir, true, true)
         end
         --Correction for flipped direction
         if next_is_forward ~= nil then
            next_is_forward = not next_is_forward
         end
         iteration_count = iteration_count + 1
      else
         --Check other end of the segment. NOTE: Never got more than 2 iterations in tests so far...
         neighbor_r_dir = get_opposite_rail_direction(neighbor_r_dir)
         next_entity, next_entity_label, result_extra, next_is_forward = identify_rail_segment_end_object(current_rail, neighbor_r_dir, false, false)
         --Correction for the train stop exception
         if next_entity_label == "train stop" and next_is_forward == false then
            next_entity, next_entity_label, result_extra, next_is_forward = identify_rail_segment_end_object(current_rail, neighbor_r_dir, true, false)
         end
         iteration_count = iteration_count + 1
      end
   end
      
   return next_entity, next_entity_label, result_extra, next_is_forward, iteration_count
end


--Takes all the output from the get_next_rail_entity_ahead and adds extra info before reading them out. Does NOT detect trains.
function train_read_next_rail_entity_ahead(pindex, invert)
   local message = "Ahead, "
   local train = game.get_player(pindex).vehicle.train
   local leading_rail, dir_ahead, leading_stock = get_leading_rail_and_dir_of_train_by_boarded_vehicle(pindex,train)
   if invert then
      dir_ahead = get_opposite_rail_direction(dir_ahead)
	  message = "Behind, "
   end
   --Correction for trains: Flip the correct direction ahead for mismatching diagonal rails
   if leading_rail.name == "straight-rail" and (leading_rail.direction == 5 or leading_rail.direction == 7) then
      dir_ahead = get_opposite_rail_direction(dir_ahead)
   end
   --Correction for trains: Curved rails report different directions based on where the train sits and so are unreliable.
   if leading_rail.name == "curved-rail" then
      printout("Curved rail analysis error, check from another rail.",pindex)
	  return
   end
   local next_entity, next_entity_label, result_extra, next_is_forward, iteration_count = get_next_rail_entity_ahead(leading_rail, dir_ahead, false)
   if next_entity == nil then
      printout("Analysis error, this rail might be looping.",pindex)
      return
   end
   local distance = math.floor(util.distance(leading_stock.position, next_entity.position))
      
   --Test message
   --message = message .. iteration_count .. " iterations, "
   
   --Maybe check for trains here, but there is no point because the checks use signal blocks...
   --local trains_in_origin_block = origin_rail.trains_in_block
   --local trains_in_current_block = current_rail.trains_in_block
   
   --Report opposite direction entities.
   if next_is_forward == false and (next_entity_label == "train stop" or next_entity_label == "rail signal" or next_entity_label == "chain signal") then
      message = message .. " Opposite direction's "
   end
   
   --Add more info depending on entity label
   if next_entity_label == "end rail" then
      message = message .. next_entity_label
      
   elseif next_entity_label == "fork split" then
      local entering_segment_rail = result_extra  
      message = message .. "rail fork splitting "
      --laterdo here, list available fork directions
   
   elseif next_entity_label == "fork merge" then
      local entering_segment_rail = result_extra  
      message = message .. "rail fork merging "
	  
   elseif next_entity_label == "neighbor end" then
      local entering_segment_rail = result_extra  
      message = message .. "end rail "
      
   elseif next_entity_label == "rail signal" then
      message = message .. "rail signal with state " .. get_signal_state_info(next_entity) .. " "
      
   elseif next_entity_label == "chain signal" then
      message = message .. "chain signal with state " .. get_signal_state_info(next_entity) .. " "
      
   elseif next_entity_label == "train stop" then
      local stop_name = next_entity.backer_name
      --Add more specific distance info
      if math.abs(distance) > 25 or next_is_forward == false then
         message = message .. "Train stop " .. stop_name .. ", in " .. distance .. " meters. "
      else
         distance = util.distance(leading_stock.position, next_entity.position) - 3.6
         if math.abs(distance) <= 0.2 then
            message = " Aligned with train stop " .. stop_name
         elseif distance > 0.2 then
            message = math.floor(distance * 10) / 10 .. " meters away from train stop " .. stop_name .. ", for the frontmost vehicle. " 
         elseif distance < 0.2 then
            message = math.floor((-distance) * 10) / 10 .. " meters past train stop " .. stop_name .. ", for the frontmost vehicle. " 
         end
      end
   
   elseif next_entity_label == "other rail" then
      message = message .. "unspecified entity"
      
   elseif next_entity_label == "other entity" then
      message = message .. next_entity.name
   end
   
   --Add general distance info
   if next_entity_label ~= "train stop" then
      message = message .. " in " .. distance .. " meters. "
      if next_entity_label == "end rail" then
         message = message .. " facing " .. direction_lookup(result_extra)
      end
   end
   --If a train stop is close behind, read that instead
   if leading_stock.name == "locomotive" and next_entity_label ~= "train stop" then
      local heading = get_heading(leading_stock)
      local pos = leading_stock.position
      local scan_area = nil
      local passed_stop = nil
      local first_reset = false
      --Scan behind the leading stock for 15m for passed train stops
      if heading == "North" then --scan the south
         scan_area = {{pos.x-4,pos.y-4},{pos.x+4,pos.y+15}}
      elseif heading == "South" then
         scan_area = {{pos.x-4,pos.y-15},{pos.x+4,pos.y+4}}
      elseif heading == "East" then --scan the west
         scan_area = {{pos.x-15,pos.y-4},{pos.x+4,pos.y+4}}
      elseif heading == "West" then
         scan_area = {{pos.x-4,pos.y-4},{pos.x+15,pos.y+4}}
      else
         --message = " Rail object scan error " .. heading .. " "
         scan_area = {{pos.x+4,pos.y+4},{pos.x+4,pos.y+4}}
      end
      local ents = game.get_player(pindex).surface.find_entities_filtered{area = scan_area, name = "train-stop"}
      for i,passed_stop in ipairs(ents) do
         distance = util.distance(leading_stock.position, passed_stop.position) - 0 
         --message = message .. " found stop " 
         if distance < 12.5 and direction_lookup(passed_stop.direction) == get_heading(leading_stock) then
            if not first_reset then
               message = ""
               first_reset = true
            end
            message = message .. math.floor(distance+0.5) .. " meters past train stop " .. passed_stop.backer_name .. ", "
         end
      end
      if first_reset then
         message = message .. " for the front vehicle. "
      end
   end
   printout(message,pindex)
   --Draw circles for visual debugging
   rendering.draw_circle{color = {0, 1, 0},radius = 1,width = 10,target = next_entity,surface = next_entity.surface,time_to_live = 100}
end


function rail_read_next_rail_entity_ahead(pindex, rail, is_forward)
   local message = "Up this rail, "
   local origin_rail = rail
   local dir_ahead = defines.rail_direction.front
   if not is_forward then
      dir_ahead = defines.rail_direction.back
	  message = "Down this rail, "
   end
   local next_entity, next_entity_label, result_extra, next_is_forward, iteration_count = get_next_rail_entity_ahead(origin_rail, dir_ahead, false)
   if next_entity == nil then
      printout("Analysis error. This rail might be looping.",pindex)
      return
   end
   local distance = math.floor(util.distance(origin_rail.position, next_entity.position))
      
   --Test message
   --message = message .. iteration_count .. " iterations, "
   
   --Maybe check for trains here, but there is no point because the checks use signal blocks...
   --local trains_in_origin_block = origin_rail.trains_in_block
   --local trains_in_current_block = current_rail.trains_in_block
   
   --Report opposite direction entities.
   if next_is_forward == false and (next_entity_label == "train stop" or next_entity_label == "rail signal" or next_entity_label == "chain signal") then
      message = message .. " Opposite direction's "
   end
   
   --Add more info depending on entity label
   if next_entity_label == "end rail" then
      message = message .. next_entity_label
      
   elseif next_entity_label == "fork split" then
      local entering_segment_rail = result_extra  
      message = message .. "rail fork splitting "
      --laterdo here, give rail fork directions
   
   elseif next_entity_label == "fork merge" then
      local entering_segment_rail = result_extra  
      message = message .. "rail fork merging "
	  
   elseif next_entity_label == "neighbor end" then
      local entering_segment_rail = result_extra  
      message = message .. "end rail "
	  
   elseif next_entity_label == "rail signal" then
      message = message .. "rail signal with state " .. get_signal_state_info(next_entity) .. " "
      
   elseif next_entity_label == "chain signal" then
      message = message .. "chain signal with state " .. get_signal_state_info(next_entity) .. " "
      
   elseif next_entity_label == "train stop" then
      local stop_name = next_entity.backer_name
      --Add more specific distance info
      if math.abs(distance) > 25 or next_is_forward == false then
         message = message .. "Train stop " .. stop_name .. ", in " .. distance .. " meters, "
      else
         distance = util.distance(origin_rail.position, next_entity.position) - 2.5
         if math.abs(distance) <= 0.2 then
            message = " Aligned with train stop " .. stop_name
         elseif distance > 0.2 then
            message = math.floor(distance * 10) / 10 .. " meters away from train stop " .. stop_name .. ". " 
         elseif distance < 0.2 then
            message = math.floor((-distance) * 10) / 10 .. " meters past train stop " .. stop_name .. ". " 
         end
      end
   
   elseif next_entity_label == "other rail" then
      message = message .. "unspecified entity"
      
   elseif next_entity_label == "other entity" then
      message = message .. next_entity.name
   end
   
   --Add general distance info
   if next_entity_label ~= "train stop" then
      message = message .. " in " .. distance .. " meters, "
      if next_entity_label == "end rail" then
         message = message .. " facing " .. direction_lookup(result_extra)
      end
   end
   printout(message,pindex)
   --Draw circles for visual debugging
   rendering.draw_circle{color = {0, 1, 0},radius = 1,width = 10,target = next_entity,surface = next_entity.surface,time_to_live = 100}
end


 
--laterdo here: Rail analyzer menu where you will use arrow keys to go forward/back and left/right along a rail.
function rail_analyzer_menu(pindex, origin_rail,is_called_from_train)
   return
end


--Builds a 45 degree rail turn to the right from a horizontal or vertical end rail that is the anchor rail. 
function build_rail_turn_right_45_degrees(anchor_rail, pindex)
   local build_comment = ""
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local stack2 = nil
   local pos = nil
   local dir = -1
   local build_area = nil
   local can_place_all = true
   local is_end_rail
   local anchor_dir = anchor_rail.direction
   
   --1. Firstly, check if the player has enough rails to place this (3 units) 
   if not (stack.valid and stack.valid_for_read and stack.name == "rail" and stack.count >= 3) then
      --Check if the inventory has enough
      if players[pindex].inventory.lua_inventory.get_item_count("rail") < 3 then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         printout("You need at least 3 rails in your inventory to build this turn.", pindex)
         return
      else
         --Take from the inventory.
         stack2 = players[pindex].inventory.lua_inventory.find_item_stack("rail")
         game.get_player(pindex).cursor_stack.swap_stack(stack2)
         stack = game.get_player(pindex).cursor_stack
         players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
      end
   end
   
   --2. Secondly, verify the end rail and find its direction
   is_end_rail, dir, build_comment = check_end_rail(anchor_rail,pindex)
   if not is_end_rail then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(build_comment, pindex)
      game.get_player(pindex).clear_cursor()
      return
   end
   pos = anchor_rail.position
   
   --3. Clear trees and rocks in the build area, can be tuned later...
   -- if dir == 0 or dir == 1 then
      -- build_area = {{pos.x-9, pos.y+9},{pos.x+16,pos.y-16}}
   -- elseif dir == 2 or dir == 3 then
      -- build_area = {{pos.x-9, pos.y-9},{pos.x+16,pos.y+16}}
   -- elseif dir == 4 or dir == 5 then
      -- build_area = {{pos.x+9, pos.y-9},{pos.x-16,pos.y+16}}
   -- elseif dir == 6 or dir == 7 then
      -- build_area = {{pos.x+9, pos.y+9},{pos.x-16,pos.y-16}}
   -- end 
   temp1, build_comment = mine_trees_and_rocks_in_circle(pos,12, pindex)
   
   --4. Check if every object can be placed
   if dir == 0 then 
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+2, pos.y-4}, direction = 1, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+4, pos.y-8}, direction = 7, force = game.forces.player}
   elseif dir == 2 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+6, pos.y+2}, direction = 3, force = game.forces.player} 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+8, pos.y+4}, direction = 1, force = game.forces.player}
   elseif dir == 4 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+0, pos.y+6}, direction = 5, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-4, pos.y+8}, direction = 3, force = game.forces.player}
   elseif dir == 6 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-4, pos.y+0}, direction = 7, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-8, pos.y-4}, direction = 5, force = game.forces.player}
   elseif dir == 1 then
      if anchor_dir == 7 then
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+4, pos.y-2}, direction = 6, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+8, pos.y-4}, direction = 2, force = game.forces.player}
      elseif anchor_dir == 3 then
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+2, pos.y-0}, direction = 7, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+6, pos.y-2}, direction = 6, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+10, pos.y-4}, direction = 2, force = game.forces.player}
      end
   elseif dir == 5 then
      if anchor_dir == 3 then--2
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-2, pos.y+4}, direction = 2, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-8, pos.y+4}, direction = 2, force = game.forces.player}
      elseif anchor_dir == 7 then--3
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-2, pos.y+0}, direction = 3, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-4, pos.y+4}, direction = 2, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-10, pos.y+4}, direction = 2, force = game.forces.player}
      end
   elseif dir == 3 then
      if anchor_dir == 1 then--2
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+4, pos.y+4}, direction = 0, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+4, pos.y+8}, direction = 0, force = game.forces.player}
      elseif anchor_dir == 5 then--3
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-0, pos.y+2}, direction = 1, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+4, pos.y+6}, direction = 0, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+4, pos.y+10}, direction = 0, force = game.forces.player}
      end
   elseif dir == 7 then
      if anchor_dir == 5 then--2
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-2, pos.y-2}, direction = 4, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-4, pos.y-8}, direction = 0, force = game.forces.player}
      elseif anchor_dir == 1 then--3
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-0, pos.y-2}, direction = 5, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-2, pos.y-4}, direction = 4, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-4, pos.y-10}, direction = 0, force = game.forces.player}
      end
   end
  
   if not can_place_all then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("Building area occupied.", pindex)
      game.get_player(pindex).clear_cursor()
      return
   end
   
   --5. Build the rail entities to create the turn
   if dir == 0 then 
      surf.create_entity{name = "curved-rail", position = {pos.x+2, pos.y-4}, direction = 1, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+4, pos.y-8}, direction = 7, force = game.forces.player}
   elseif dir == 2 then
      surf.create_entity{name = "curved-rail", position = {pos.x+6, pos.y+2}, direction = 3, force = game.forces.player} 
      surf.create_entity{name = "straight-rail", position = {pos.x+8, pos.y+4}, direction = 1, force = game.forces.player}
   elseif dir == 4 then
      surf.create_entity{name = "curved-rail", position = {pos.x+0, pos.y+6}, direction = 5, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-4, pos.y+8}, direction = 3, force = game.forces.player}
   elseif dir == 6 then
      surf.create_entity{name = "curved-rail", position = {pos.x-4, pos.y+0}, direction = 7, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-8, pos.y-4}, direction = 5, force = game.forces.player}
   elseif dir == 1 then
      if anchor_dir == 7 then
         surf.create_entity{name = "curved-rail", position = {pos.x+4, pos.y-2}, direction = 6, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x+8, pos.y-4}, direction = 2, force = game.forces.player}
      elseif anchor_dir == 3 then
         surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y-0}, direction = 7, force = game.forces.player}
         surf.create_entity{name = "curved-rail", position = {pos.x+6, pos.y-2}, direction = 6, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x+10, pos.y-4}, direction = 2, force = game.forces.player}
      end
   elseif dir == 5 then
      if anchor_dir == 3 then--2
         surf.create_entity{name = "curved-rail", position = {pos.x-2, pos.y+4}, direction = 2, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x-8, pos.y+4}, direction = 2, force = game.forces.player}
      elseif anchor_dir == 7 then--3
         surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y+0}, direction = 3, force = game.forces.player}
         surf.create_entity{name = "curved-rail", position = {pos.x-4, pos.y+4}, direction = 2, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x-10, pos.y+4}, direction = 2, force = game.forces.player}
      end
   elseif dir == 3 then
      if anchor_dir == 1 then--2
         surf.create_entity{name = "curved-rail", position = {pos.x+4, pos.y+4}, direction = 0, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x+4, pos.y+8}, direction = 0, force = game.forces.player}
      elseif anchor_dir == 5 then--3
         surf.create_entity{name = "straight-rail", position = {pos.x-0, pos.y+2}, direction = 1, force = game.forces.player}
         surf.create_entity{name = "curved-rail", position = {pos.x+4, pos.y+6}, direction = 0, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x+4, pos.y+10}, direction = 0, force = game.forces.player}
      end
   elseif dir == 7 then
      if anchor_dir == 5 then--2
         surf.create_entity{name = "curved-rail", position = {pos.x-2, pos.y-2}, direction = 4, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x-4, pos.y-8}, direction = 0, force = game.forces.player}
      elseif anchor_dir == 1 then--3
         surf.create_entity{name = "straight-rail", position = {pos.x-0, pos.y-2}, direction = 5, force = game.forces.player}
         surf.create_entity{name = "curved-rail", position = {pos.x-2, pos.y-4}, direction = 4, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x-4, pos.y-10}, direction = 0, force = game.forces.player}
      end
   end
   
   
   --6 Remove rail units from the player's hand
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 2
   if (dir == 1 and anchor_dir == 3) or (dir == 5 and anchor_dir == 7) or (dir == 3 and anchor_dir == 5) or (dir == 7 and anchor_dir == 1) then
      game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 1
   end
   game.get_player(pindex).clear_cursor()
   
   --7. Sounds and results
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}
   game.get_player(pindex).play_sound{path = "entity-build/curved-rail"}
   printout("Rail turn built 45 degrees right, " .. build_comment, pindex)
   return
   
end


--Builds a 90 degree rail turn to the right from a horizontal or vertical end rail that is the anchor rail. 
function build_rail_turn_right_90_degrees(anchor_rail, pindex)
   local build_comment = ""
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local stack2 = nil
   local pos = nil
   local dir = -1
   local build_area = nil
   local can_place_all = true
   local is_end_rail
   
   --1. Firstly, check if the player has enough rails to place this (10 units) 
   if not (stack.valid and stack.valid_for_read and stack.name == "rail" and stack.count >= 10) then
      --Check if the inventory has enough
      if players[pindex].inventory.lua_inventory.get_item_count("rail") < 10 then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         printout("You need at least 10 rails in your inventory to build this turn.", pindex)
         return
      else
         --Take from the inventory.
         stack2 = players[pindex].inventory.lua_inventory.find_item_stack("rail")
         game.get_player(pindex).cursor_stack.swap_stack(stack2)
         stack = game.get_player(pindex).cursor_stack
         players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
      end
   end
   
   --2. Secondly, verify the end rail and find its direction
   is_end_rail, dir, build_comment = check_end_rail(anchor_rail,pindex)
   if not is_end_rail then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(build_comment, pindex)
      game.get_player(pindex).clear_cursor()
      return
   end
   pos = anchor_rail.position
   if dir == 1 or dir == 3 or dir == 5 or dir == 7 then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("This structure is for horizontal or vertical end rails only.", pindex)
      game.get_player(pindex).clear_cursor()
      return
   end
   
   --3. Clear trees and rocks in the build area
   -- if dir == 0 then
      -- build_area = {{pos.x-2, pos.y+2},{pos.x+16,pos.y-16}}
   -- elseif dir == 2 then
      -- build_area = {{pos.x-2, pos.y-2},{pos.x+16,pos.y+16}}
   -- elseif dir == 4 then
      -- build_area = {{pos.x+2, pos.y-2},{pos.x-16,pos.y+16}}
   -- elseif dir == 6 then
      -- build_area = {{pos.x+2, pos.y+2},{pos.x-16,pos.y-16}}
   -- end 
   temp1, build_comment = mine_trees_and_rocks_in_circle(pos,18, pindex)
   
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
      game.get_player(pindex).clear_cursor()
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
   game.get_player(pindex).clear_cursor()
   
   --7. Sounds and results
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}
   game.get_player(pindex).play_sound{path = "entity-build/curved-rail"}
   printout("Rail turn built 90 degrees right, " .. build_comment, pindex)
   return
   
end


--Builds a 45 degree rail turn to the left from a horizontal or vertical end rail that is the anchor rail. 
function build_rail_turn_left_45_degrees(anchor_rail, pindex)
   local build_comment = ""
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local stack2 = nil
   local pos = nil
   local dir = -1
   local build_area = nil
   local can_place_all = true
   local is_end_rail
   local anchor_dir = anchor_rail.direction
   
   --1. Firstly, check if the player has enough rails to place this (3 units) 
   if not (stack.valid and stack.valid_for_read and stack.name == "rail" and stack.count >= 3) then
      --Check if the inventory has enough
      if players[pindex].inventory.lua_inventory.get_item_count("rail") < 3 then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         printout("You need at least 3 rails in your inventory to build this turn.", pindex)
         return
      else
         --Take from the inventory.
         stack2 = players[pindex].inventory.lua_inventory.find_item_stack("rail")
         game.get_player(pindex).cursor_stack.swap_stack(stack2)
         stack = game.get_player(pindex).cursor_stack
         players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
      end
   end
   
   --2. Secondly, verify the end rail and find its direction
   is_end_rail, dir, build_comment = check_end_rail(anchor_rail,pindex)
   if not is_end_rail then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(build_comment, pindex)
      game.get_player(pindex).clear_cursor()
      return
   end
   pos = anchor_rail.position
   
   --3. Clear trees and rocks in the build area, can be tuned later...
   -- if dir == 0 or dir == 1 then
      -- build_area = {{pos.x+9, pos.y+9},{pos.x-16,pos.y-16}}
   -- elseif dir == 2 or dir == 3 then
      -- build_area = {{pos.x-9, pos.y+9},{pos.x+16,pos.y-16}}
   -- elseif dir == 4 or dir == 5 then
      -- build_area = {{pos.x-9, pos.y-9},{pos.x+16,pos.y+16}}
   -- elseif dir == 6 or dir == 7 then
      -- build_area = {{pos.x+9, pos.y-9},{pos.x-16,pos.y+16}}
   -- end 
   temp1, build_comment = mine_trees_and_rocks_in_circle(pos,12, pindex)
   
   --4. Check if every object can be placed
   if dir == 0 then 
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+0, pos.y-4}, direction = 0, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-4, pos.y-8}, direction = 1, force = game.forces.player}
   elseif dir == 2 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+6, pos.y+0}, direction = 2, force = game.forces.player} 
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+8, pos.y-4}, direction = 3, force = game.forces.player}
   elseif dir == 4 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+2, pos.y+6}, direction = 4, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+4, pos.y+8}, direction = 5, force = game.forces.player}
   elseif dir == 6 then
      can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-4, pos.y+2}, direction = 6, force = game.forces.player}
      can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-8, pos.y+4}, direction = 7, force = game.forces.player}
   elseif dir == 1 then
      if anchor_dir == 3 then--2
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+4, pos.y-2}, direction = 5, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+4, pos.y-8}, direction = 0, force = game.forces.player}
      elseif anchor_dir == 7 then--3
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+0, pos.y-2}, direction = 3, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+4, pos.y-4}, direction = 5, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+4, pos.y-10}, direction = 0, force = game.forces.player}
      end
   elseif dir == 5 then
      if anchor_dir == 7 then--2
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-2, pos.y+4}, direction = 1, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-4, pos.y+8}, direction = 0, force = game.forces.player}
      elseif anchor_dir == 3 then--3
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-0, pos.y+2}, direction = 7, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-2, pos.y+6}, direction = 1, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-4, pos.y+10}, direction = 0, force = game.forces.player}
      end
   elseif dir == 3 then
      if anchor_dir == 5 then--2
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+4, pos.y+4}, direction = 7, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+8, pos.y+4}, direction = 2, force = game.forces.player}
      elseif anchor_dir == 1 then--3
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+2, pos.y+0}, direction = 5, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x+6, pos.y+4}, direction = 7, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x+10, pos.y+4}, direction = 2, force = game.forces.player}
      end
   elseif dir == 7 then
      if anchor_dir == 1 then--2
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-2, pos.y-2}, direction = 3, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-8, pos.y-4}, direction = 2, force = game.forces.player}
      elseif anchor_dir == 5 then--3
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-2, pos.y-0}, direction = 1, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "curved-rail", position = {pos.x-4, pos.y-2}, direction = 3, force = game.forces.player}
         can_place_all = can_place_all and surf.can_place_entity{name = "straight-rail", position = {pos.x-10, pos.y-4}, direction = 2, force = game.forces.player}
      end
   end
  
   if not can_place_all then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("Building area occupied.", pindex)
      game.get_player(pindex).clear_cursor()
      return
   end
   
   --5. Build the rail entities to create the turn
   if dir == 0 then 
      surf.create_entity{name = "curved-rail", position = {pos.x+0, pos.y-4}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-4, pos.y-8}, direction = 1, force = game.forces.player}
   elseif dir == 2 then
      surf.create_entity{name = "curved-rail", position = {pos.x+6, pos.y+0}, direction = 2, force = game.forces.player} 
      surf.create_entity{name = "straight-rail", position = {pos.x+8, pos.y-4}, direction = 3, force = game.forces.player}
   elseif dir == 4 then
      surf.create_entity{name = "curved-rail", position = {pos.x+2, pos.y+6}, direction = 4, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+4, pos.y+8}, direction = 5, force = game.forces.player}
   elseif dir == 6 then
      surf.create_entity{name = "curved-rail", position = {pos.x-4, pos.y+2}, direction = 6, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-8, pos.y+4}, direction = 7, force = game.forces.player}
   elseif dir == 1 then
      if anchor_dir == 3 then--2
         surf.create_entity{name = "curved-rail", position = {pos.x+4, pos.y-2}, direction = 5, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x+4, pos.y-8}, direction = 0, force = game.forces.player}
      elseif anchor_dir == 7 then--3
         surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y-2}, direction = 3, force = game.forces.player}
         surf.create_entity{name = "curved-rail", position = {pos.x+4, pos.y-4}, direction = 5, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x+4, pos.y-10}, direction = 0, force = game.forces.player}
      end
   elseif dir == 5 then
      if anchor_dir == 7 then--2
         surf.create_entity{name = "curved-rail", position = {pos.x-2, pos.y+4}, direction = 1, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x-4, pos.y+8}, direction = 0, force = game.forces.player}
      elseif anchor_dir == 3 then--3
         surf.create_entity{name = "straight-rail", position = {pos.x-0, pos.y+2}, direction = 7, force = game.forces.player}
         surf.create_entity{name = "curved-rail", position = {pos.x-2, pos.y+6}, direction = 1, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x-4, pos.y+10}, direction = 0, force = game.forces.player}
      end
   elseif dir == 3 then
      if anchor_dir == 5 then--2
         surf.create_entity{name = "curved-rail", position = {pos.x+4, pos.y+4}, direction = 7, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x+8, pos.y+4}, direction = 2, force = game.forces.player}
      elseif anchor_dir == 1 then--3
         surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y+0}, direction = 5, force = game.forces.player}
         surf.create_entity{name = "curved-rail", position = {pos.x+6, pos.y+4}, direction = 7, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x+10, pos.y+4}, direction = 2, force = game.forces.player}
      end
   elseif dir == 7 then
      if anchor_dir == 1 then--2
         surf.create_entity{name = "curved-rail", position = {pos.x-2, pos.y-2}, direction = 3, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x-8, pos.y-4}, direction = 2, force = game.forces.player}
      elseif anchor_dir == 5 then--3
         surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y-0}, direction = 1, force = game.forces.player}
         surf.create_entity{name = "curved-rail", position = {pos.x-4, pos.y-2}, direction = 3, force = game.forces.player}
         surf.create_entity{name = "straight-rail", position = {pos.x-10, pos.y-4}, direction = 2, force = game.forces.player}
      end
   end
   
   
   --6 Remove rail units from the player's hand
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 2
   if (dir == 1 and anchor_dir == 7) or (dir == 5 and anchor_dir == 3) or (dir == 3 and anchor_dir == 1) or (dir == 7 and anchor_dir == 5) then
      game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 1
   end
   game.get_player(pindex).clear_cursor()
   
   --7. Sounds and results
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}
   game.get_player(pindex).play_sound{path = "entity-build/curved-rail"}
   printout("Rail turn built 45 degrees left, " .. build_comment, pindex)
   return
   
end


--Builds a 90 degree rail turn to the left from a horizontal or vertical end rail that is the anchor rail. 
function build_rail_turn_left_90_degrees(anchor_rail, pindex)
   local build_comment = ""
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local stack2 = nil
   local pos = nil
   local dir = -1
   local build_area = nil
   local can_place_all = true
   local is_end_rail
   
   --1. Firstly, check if the player has enough rails to place this (10 units)
   if not (stack.valid and stack.valid_for_read and stack.name == "rail" and stack.count > 10) then
      --Check if the inventory has enough
      if players[pindex].inventory.lua_inventory.get_item_count("rail") < 10 then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         printout("You need at least 10 rails in your inventory to build this turn.", pindex)
         return
      else
         --Take from the inventory.
         stack2 = players[pindex].inventory.lua_inventory.find_item_stack("rail")
         game.get_player(pindex).cursor_stack.swap_stack(stack2)
         stack = game.get_player(pindex).cursor_stack
         players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
      end
   end
   
   --2. Secondly, verify the end rail and find its direction
   is_end_rail, dir, build_comment = check_end_rail(anchor_rail,pindex)
   if not is_end_rail then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(build_comment, pindex)
      game.get_player(pindex).clear_cursor()
      return
   end
   pos = anchor_rail.position
   if dir == 1 or dir == 3 or dir == 5 or dir == 7 then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("This structure is for horizontal or vertical end rails only.", pindex)
      game.get_player(pindex).clear_cursor()
      return
   end
   
   --3. Clear trees and rocks in the build area
   -- if dir == 0 then
      -- build_area = {{pos.x+2, pos.y+2},{pos.x-16,pos.y-16}}
   -- elseif dir == 2 then
      -- build_area = {{pos.x+2, pos.y+2},{pos.x+16,pos.y-16}}
   -- elseif dir == 4 then
      -- build_area = {{pos.x+2, pos.y+2},{pos.x+16,pos.y+16}}
   -- elseif dir == 6 then
      -- build_area = {{pos.x+2, pos.y+2},{pos.x-16,pos.y+16}}
   -- end 
   temp1, build_comment = mine_trees_and_rocks_in_circle(pos,18, pindex)
   
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
      game.get_player(pindex).clear_cursor()
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
   game.get_player(pindex).clear_cursor()
   
   --7. Sounds and results
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}
   game.get_player(pindex).play_sound{path = "entity-build/curved-rail"}
   printout("Rail turn built 90 degrees left, " .. build_comment, pindex)
   return
end


--Builds a minimal straight rail intersection on a horizontal or vertical end rail. Note: We should build other intersections with blueprint imports.
function build_small_plus_intersection(anchor_rail, pindex)
   local build_comment = ""
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local stack2 = nil
   local pos = nil
   local dir = -1
   local build_area = nil
   local can_place_all = true
   local is_end_rail
   
   --1. Firstly, check if the player has enough rails to place this (5 units)
   if not (stack.valid and stack.valid_for_read and stack.name == "rail" and stack.count > 5) then
      --Check if the inventory has enough
      if players[pindex].inventory.lua_inventory.get_item_count("rail") < 5 then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         printout("You need at least 5 rails in your inventory to build this turn.", pindex)
         return
      else
         --Take from the inventory.
         stack2 = players[pindex].inventory.lua_inventory.find_item_stack("rail")
         game.get_player(pindex).cursor_stack.swap_stack(stack2)
         stack = game.get_player(pindex).cursor_stack
         players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
      end
   end
   
   --2. Secondly, verify the end rail and find its direction
   is_end_rail, dir, build_comment = check_end_rail(anchor_rail,pindex)
   if not is_end_rail then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(build_comment, pindex)
      game.get_player(pindex).clear_cursor()
      return
   end
   pos = anchor_rail.position
   if dir == 1 or dir == 3 or dir == 5 or dir == 7 then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("This structure is for horizontal or vertical end rails only.", pindex)
      game.get_player(pindex).clear_cursor()
      return
   end
   
   --3. Clear trees and rocks in the build area
   temp1, build_comment = mine_trees_and_rocks_in_circle(pos,10, pindex)
   
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
      game.get_player(pindex).clear_cursor()
      return
   end
   
   --5. Build the five rail entities to create the structure. Also add signals for free
   if dir == 0 then 
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y-2}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y-4}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y-2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y-2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y-2}, direction = 2, force = game.forces.player}
      
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x-2, pos.y-0}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x+1, pos.y-5}, direction = 4, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x-3, pos.y-4}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x+2, pos.y-1}, direction = 6, force = game.forces.player}
      
      surf.create_entity{name = "rail-chain-signal", position = {pos.x+1, pos.y-0}, direction = 4, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-2, pos.y-5}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-3, pos.y-1}, direction = 6, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x+2, pos.y-4}, direction = 2, force = game.forces.player}
      
   elseif dir == 2 then
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y+0}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+4, pos.y+0}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y-2}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y+0}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y+2}, direction = 0, force = game.forces.player}
      
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x-1, pos.y-2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x+4, pos.y+1}, direction = 6, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x+3, pos.y-3}, direction = 4, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x-0, pos.y+2}, direction = 0, force = game.forces.player}
      
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-1, pos.y+1}, direction = 6, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x+4, pos.y-2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-0, pos.y-3}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x+3, pos.y+2}, direction = 4, force = game.forces.player}
      
      
      
   elseif dir == 4 then
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y+2}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y+4}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+0, pos.y+2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y+2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x+2, pos.y+2}, direction = 2, force = game.forces.player}
      
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x+1, pos.y-1}, direction = 4, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x-2, pos.y+4}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x-3, pos.y+0}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x+2, pos.y+3}, direction = 6, force = game.forces.player}
      
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-2, pos.y-1}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x+1, pos.y+4}, direction = 4, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-3, pos.y+3}, direction = 6, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x+2, pos.y+0}, direction = 2, force = game.forces.player}
      
   elseif dir == 6 then
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y+0}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-4, pos.y+0}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y-2}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y+0}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "straight-rail", position = {pos.x-2, pos.y+2}, direction = 0, force = game.forces.player}
      
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x-0, pos.y+1}, direction = 6, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x-5, pos.y-2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x-4, pos.y+2}, direction = 0, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal"  , position = {pos.x-1, pos.y-3}, direction = 4, force = game.forces.player}
      
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-0, pos.y-2}, direction = 2, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-5, pos.y+1}, direction = 6, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-1, pos.y+2}, direction = 4, force = game.forces.player}
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-4, pos.y-3}, direction = 0, force = game.forces.player}
      
   end
   
   --6 Remove 5 rail units from the player's hand
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 5
   game.get_player(pindex).clear_cursor()
   
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
   local end_dir_1 = nil
   local end_dir_2 = nil
   local rail_api_dir = nil
   local is_end_rail = nil
   local end_rail_dir = nil
   local comment = ""
   
   --0 Check if there is at least 1 rail in hand, else return
   if not (stack.valid and stack.valid_for_read and stack.name == "rail" and stack.count > 0) then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("You need at least 1 rail in hand.", pindex)
      return
   end
   
   --1 Check the cursor entity. If it is an end rail, use this instead of scanning to extend the rail you want.
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
         ents = surf.find_entities_filtered{position = pos, radius = 3, name = "curved-rail"}
         if #ents == 0 then
            game.get_player(pindex).play_sound{path = "utility/cannot_build"}
            if players[pindex].build_lock == false then
               printout("No rails found nearby.",pindex)
               return
            end
         end
      end

      --3 For the first rail found, check if it is at the end of its segment and if the rail is not within X tiles of pos, try the other end
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
         --printout(comment, pindex)
         printout("No end rails found nearby", pindex)
         return
      end
   end
   
   --5 Confirmed as an end rail. Get its position and find the correct position and direction for the appended rail.
   end_rail_pos = end_found.position
   end_rail_dir = end_found.direction
   append_rail_dir = -1
   append_rail_pos = nil
   rail_api_dir = end_found.direction
   
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
      --Make sure to use the reported end direction for curved rails
      is_end_rail, end_rail_dir, comment = check_end_rail(ent,pindex)
      if end_rail_dir == 0 then
         if rail_api_dir == 4 then
            append_rail_pos = {end_rail_pos.x-2, end_rail_pos.y-6}
            append_rail_dir = 0
         elseif rail_api_dir == 5 then
            append_rail_pos = {end_rail_pos.x-0, end_rail_pos.y-6}
            append_rail_dir = 0
         end
      elseif end_rail_dir == 1 then
         if rail_api_dir == 1 then
            append_rail_pos = {end_rail_pos.x+2, end_rail_pos.y-4}
            append_rail_dir = 7
         elseif rail_api_dir == 2 then
            append_rail_pos = {end_rail_pos.x+2, end_rail_pos.y-4}
            append_rail_dir = 3
         end
      elseif end_rail_dir == 2 then
         if rail_api_dir == 6 then
            append_rail_pos = {end_rail_pos.x+4, end_rail_pos.y-2}
            append_rail_dir = 2
         elseif rail_api_dir == 7 then
            append_rail_pos = {end_rail_pos.x+4, end_rail_pos.y-0}
            append_rail_dir = 2
         end         
      elseif end_rail_dir == 3 then
         if rail_api_dir == 3 then
            append_rail_pos = {end_rail_pos.x+2, end_rail_pos.y+2}
            append_rail_dir = 1
         elseif rail_api_dir == 4 then
            append_rail_pos = {end_rail_pos.x+2, end_rail_pos.y+2}
            append_rail_dir = 5
         end
      elseif end_rail_dir == 4 then
         if rail_api_dir == 0 then
            append_rail_pos = {end_rail_pos.x-0, end_rail_pos.y+4}
            append_rail_dir = 0
         elseif rail_api_dir == 1 then
            append_rail_pos = {end_rail_pos.x-2, end_rail_pos.y+4}
            append_rail_dir = 0
         end
      elseif end_rail_dir == 5 then
         if rail_api_dir == 5 then
            append_rail_pos = {end_rail_pos.x-4, end_rail_pos.y+2}
            append_rail_dir = 3
         elseif rail_api_dir == 6 then
            append_rail_pos = {end_rail_pos.x-4, end_rail_pos.y+2}
            append_rail_dir = 7
         end
      elseif end_rail_dir == 6 then
         if rail_api_dir == 2 then
            append_rail_pos = {end_rail_pos.x-6, end_rail_pos.y-0}
            append_rail_dir = 2
         elseif rail_api_dir == 3 then
            append_rail_pos = {end_rail_pos.x-6, end_rail_pos.y-2}
            append_rail_dir = 2
         end 
      elseif end_rail_dir == 7 then
         if rail_api_dir == 0 then
            append_rail_pos = {end_rail_pos.x-4, end_rail_pos.y-4}
            append_rail_dir = 1
         elseif rail_api_dir == 7 then
            append_rail_pos = {end_rail_pos.x-4, end_rail_pos.y-4}
            append_rail_dir = 5
         end 
      end
   end

   --6. Clear trees and rocks nearby and check if the selected 2x2 space is free for building, else return
   if append_rail_pos == nil then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout(end_rail_dir .. " and " .. rail_api_dir .. ", rail appending direction error.",pindex)
      return
   end
   temp1, build_comment = mine_trees_and_rocks_in_circle(append_rail_pos,3, pindex)
   if not surf.can_place_entity{name = "straight-rail", position = append_rail_pos, direction = append_rail_dir} then 
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("Cannot place here to extend the rail.",pindex)
      return
   end
   
   --7. Create the appended rail and subtract 1 rail from the hand.
   --game.get_player(pindex).build_from_cursor{position = append_rail_pos, direction = append_rail_dir}--acts unsolvably weird when building diagonals of rotation 5 and 7
   created_rail = surf.create_entity{name = "straight-rail", position = append_rail_pos, direction = append_rail_dir, force = game.forces.player}
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 1
   game.get_player(pindex).play_sound{path = "entity-build/straight-rail"}
   
   if not (created_rail ~= nil and created_rail.valid) then
      game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("Rail invalid error.",pindex)
      return
   end
   
   --8. Check if the appended rail is with 4 tiles of a parallel rail. If so, delete it.
   if created_rail.valid and has_parallel_neighbor(created_rail,pindex) then
      game.get_player(pindex).mine_entity(created_rail,true)
	  game.get_player(pindex).play_sound{path = "utility/cannot_build"}
      printout("Cannot place, parallel rail segments should be at least 4 tiles apart.",pindex)
   end
   
   --9. Check if the appended rail has created an intersection. If so, notify the player.
   if created_rail.valid and is_intersection_rail(created_rail,pindex) then
      printout("Intersection created.",pindex)
   end
      
end

--laterdo maybe revise build-item-in-hand for single placed rails so that you can have more control on it. Create a new place single rail function
--function place_single_rail(pindex)
--end

--Counts rails within range of a selected rail.
function count_rails_within_range(rail, range, pindex)
   --1. Scan around the rail for other rails
   local counter = 0
   local pos = rail.position
   local scan_area = {{pos.x-range,pos.y-range},{pos.x+range,pos.y+range}}
   local ents = game.get_player(pindex).surface.find_entities_filtered{area = scan_area, name = "straight-rail"}
   for i,other_rail in ipairs(ents) do
      --2. Increase counter for each straight rail
	  counter = counter + 1
   end
   ents = game.get_player(pindex).surface.find_entities_filtered{area = scan_area, name = "curved-rail"}
   for i,other_rail in ipairs(ents) do
      --3. Increase counter for each curved rail
	  counter = counter + 1
   end
   --Draw the range for visual debugging
   rendering.draw_circle{color = {0, 1, 0}, radius = range, width = range, target = rail, surface = rail.surface,time_to_live = 100}
   return counter
end

--Checks if the rail is parallel to another neighboring segment.
function has_parallel_neighbor(rail, pindex)
   --1. Scan around the rail for other rails
   local pos = rail.position
   local dir = rail.direction
   local range = 4
   if dir % 2 == 1 then
      range = 3
   end
   local scan_area = {{pos.x-range,pos.y-range},{pos.x+range,pos.y+range}} 
   local ents = game.get_player(pindex).surface.find_entities_filtered{area = scan_area, name = "straight-rail"}
   for i,other_rail in ipairs(ents) do
	 --2. For each rail, does it have the same rotation but a different segment? If yes return true.
	 local pos2 = other_rail.position
	  if rail.direction == other_rail.direction and not rail.is_rail_in_same_rail_segment_as(other_rail) then
	     --3. Also ignore cases where the rails are directly facing each other so that they can be connected
	     if (pos.x ~= pos2.x) and (pos.y ~= pos2.y) and (math.abs(pos.x - pos2.x) - math.abs(pos.y - pos2.y)) > 1 then
	        --4. Parallel neighbor found
		    rendering.draw_circle{color = {1, 0, 0},radius = range,width = range,target = pos,surface = rail.surface,time_to_live = 100}
	 	    return true
		 end
	  end
   end
   --4. No parallel neighbor found
   return false
end

--Checks if the rail is amid an intersection.
function is_intersection_rail(rail, pindex)
   --1. Scan around the rail for other rails
   local pos = rail.position
   local dir = rail.direction
   local scan_area = {{pos.x-1,pos.y-1},{pos.x+1,pos.y+1}} 
   local ents = game.get_player(pindex).surface.find_entities_filtered{area = scan_area, name = "straight-rail"}
   for i,other_rail in ipairs(ents) do
      --2. For each rail, does it have a different rotation and a different segment? If yes return true.
	  local dir_2 = other_rail.direction
	  dir = dir % 4
	  dir_2 = dir_2 % 4
	  if dir ~= dir_2 and not rail.is_rail_in_same_rail_segment_as(other_rail) then
	     rendering.draw_circle{color = {0, 0, 1},radius = 1.5,width = 1.5,target = pos,surface = rail.surface,time_to_live = 100}
         return true
	  end
   end
   return false
end

--Places a chain signal pair around a rail depending on its direction. May fail if the spots are full.
function place_chain_signal_pair(rail,pindex)
   local stack = game.get_player(pindex).cursor_stack
   local stack2 = nil
   local build_comment = "no comment"
   local successful = true
   local dir = rail.direction
   local pos = rail.position
   local surf = rail.surface
   local can_place_all = true
   
   --1. Check if signals can be placed, based on direction
   if dir == 0 or dir == 4 then
      can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x+1, pos.y}, direction = 4, force = game.forces.player}
	  can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x-2, pos.y}, direction = 0, force = game.forces.player}
   elseif dir == 2 or dir == 6 then
      can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x, pos.y-2}, direction = 2, force = game.forces.player}
	  can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x, pos.y+1}, direction = 6, force = game.forces.player}
   elseif dir == 1 then
      can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x-1, pos.y-0}, direction = 7, force = game.forces.player}
	  can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x+1, pos.y-2}, direction = 3, force = game.forces.player}
   elseif dir == 5 then
      can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x-2, pos.y+1}, direction = 7, force = game.forces.player}
	  can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x+0, pos.y-1}, direction = 3, force = game.forces.player}
   elseif dir == 3 then
      can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x-1, pos.y-1}, direction = 1, force = game.forces.player}
	  can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x+1, pos.y+1}, direction = 5, force = game.forces.player}
   elseif dir == 7 then
      can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x-2, pos.y-2}, direction = 1, force = game.forces.player}
	  can_place_all = can_place_all and surf.can_place_entity{name = "rail-chain-signal", position = {pos.x+0, pos.y+0}, direction = 5, force = game.forces.player}
   else
      successful = false
	  game.get_player(pindex).play_sound{path = "utility/cannot_build"}
	  build_comment = "direction error"
	  return successful, build_comment
   end
   
   if not can_place_all then
      successful = false
	  game.get_player(pindex).play_sound{path = "utility/cannot_build"}
	  build_comment = "cannot place"
	  return successful, build_comment
   end
   
   --2. Check if there are already chain signals or rail signals nearby. If yes, stop.
   local signals_found = 0
   local signals = surf.find_entities_filtered{position = pos, radius = 3, name="rail-chain-signal"}
   for i,signal in ipairs(signals) do
      signals_found = signals_found + 1
   end
   local signals = surf.find_entities_filtered{position = pos, radius = 3, name="rail-signal"}
   for i,signal in ipairs(signals) do
      signals_found = signals_found + 1
   end
   if signals_found > 0 then
      successful = false
	  game.get_player(pindex).play_sound{path = "utility/cannot_build"}
	  build_comment = "Too close to existing signals."
	  return successful, build_comment
   end
   
   --3. Check whether the player has enough rail chain signals.
   if not (stack.valid and stack.valid_for_read and stack.name == "rail-chain-signal" and stack.count >= 2) then
      --Check if the inventory has one instead
      if players[pindex].inventory.lua_inventory.get_item_count("rail-chain-signal") < 2 then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         build_comment = "You need to have at least 2 rail chain signals on you."
		 successful = false
		 game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         return successful, build_comment
      else
         --Take from the inventory.
         stack2 = players[pindex].inventory.lua_inventory.find_item_stack("rail-chain-signal")
         game.get_player(pindex).cursor_stack.swap_stack(stack2)
         stack = game.get_player(pindex).cursor_stack
         players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
      end
   end
   
   --4. Place the signals.
   if dir == 0 or dir == 4 then
      surf.create_entity{name = "rail-chain-signal", position = {pos.x+1, pos.y}, direction = 4, force = game.forces.player}
	  surf.create_entity{name = "rail-chain-signal", position = {pos.x-2, pos.y}, direction = 0, force = game.forces.player}
   elseif dir == 2 or dir == 6 then
      surf.create_entity{name = "rail-chain-signal", position = {pos.x, pos.y-2}, direction = 2, force = game.forces.player}
	  surf.create_entity{name = "rail-chain-signal", position = {pos.x, pos.y+1}, direction = 6, force = game.forces.player}
   elseif dir == 1 then
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-1, pos.y-0}, direction = 7, force = game.forces.player}
	  surf.create_entity{name = "rail-chain-signal", position = {pos.x+1, pos.y-2}, direction = 3, force = game.forces.player}
   elseif dir == 5 then
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-2, pos.y+1}, direction = 7, force = game.forces.player}
	  surf.create_entity{name = "rail-chain-signal", position = {pos.x+0, pos.y-1}, direction = 3, force = game.forces.player} 
   elseif dir == 3 then
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-1, pos.y-1}, direction = 1, force = game.forces.player}
	  surf.create_entity{name = "rail-chain-signal", position = {pos.x+1, pos.y+1}, direction = 5, force = game.forces.player}
   elseif dir == 7 then
      surf.create_entity{name = "rail-chain-signal", position = {pos.x-2, pos.y-2}, direction = 1, force = game.forces.player}
	  surf.create_entity{name = "rail-chain-signal", position = {pos.x+0, pos.y+0}, direction = 5, force = game.forces.player}
   else
      successful = false
	  game.get_player(pindex).play_sound{path = "utility/cannot_build"}
	  build_comment = "direction error"
	  return successful, build_comment
   end
   
   --Reduce the signal count and restore the cursor and wrap up
   game.get_player(pindex).cursor_stack.count = game.get_player(pindex).cursor_stack.count - 2
   game.get_player(pindex).clear_cursor()
   
   game.get_player(pindex).play_sound{path = "entity-build/rail-chain-signal"}
   game.get_player(pindex).play_sound{path = "entity-build/rail-chain-signal"}
   return successful, build_comment
end

--Deletes rail signals around a rail.
function destroy_signals(rail)
   local chains = rail.surface.find_entities_filtered{position = rail.position, radius = 2, name = "rail-chain-signal"}
   for i,chain in ipairs(chains) do
      chain.destroy()
   end
   local signals = rail.surface.find_entities_filtered{position = rail.position, radius = 2, name = "rail-signal"}
   for i,signal in ipairs(signals) do
      signal.destroy()
   end
end

--Mines for the player the rail signals around a rail.
function mine_signals(rail,pindex)
   local chains = rail.surface.find_entities_filtered{position = rail.position, radius = 2, name = "rail-chain-signal"}
   for i,chain in ipairs(chains) do
      game.get_player(pindex).mine_entity(chain,true)
   end
   local signals = rail.surface.find_entities_filtered{position = rail.position, radius = 2, name = "rail-signal"}
   for i,signal in ipairs(signals) do
      game.get_player(pindex).mine_entity(signal,true)
   end
end


--Places a train stop facing the direction of the end rail.
function build_train_stop(anchor_rail, pindex)
   local build_comment = ""
   local surf = game.get_player(pindex).surface
   local stack = game.get_player(pindex).cursor_stack
   local stack2 = nil
   local pos = nil
   local dir = -1
   local build_area = nil
   local can_place_all = true
   local is_end_rail
   
   --1. Firstly, check if the player has a train stop in hand
   if not (stack.valid and stack.valid_for_read and stack.name == "train-stop" and stack.count > 0) then
      --Check if the inventory has enough
      if players[pindex].inventory.lua_inventory.get_item_count("train-stop") < 1 then
         game.get_player(pindex).play_sound{path = "utility/cannot_build"}
         printout("You need at least 1 train stop in your inventory to build this turn.", pindex)
         return
      else
         --Take from the inventory.
         stack2 = players[pindex].inventory.lua_inventory.find_item_stack("train-stop")
         game.get_player(pindex).cursor_stack.swap_stack(stack2)
         stack = game.get_player(pindex).cursor_stack
         players[pindex].inventory.max = #players[pindex].inventory.lua_inventory
      end
   end
   
   --2. Secondly, find the direction based on end rail or player direction
   is_end_rail, end_rail_dir, build_comment = check_end_rail(anchor_rail,pindex)
   if is_end_rail then
      dir = end_rail_dir
   else
      --Choose the dir based on player direction 
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
      game.get_player(pindex).clear_cursor()
      return
   end
   
   --3. Clear trees and rocks in the build area
   temp1, build_comment = mine_trees_and_rocks_in_circle(pos,3, pindex)
   
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
      game.get_player(pindex).clear_cursor()
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
   game.get_player(pindex).clear_cursor()
   
   --7. Sounds and results
   game.get_player(pindex).play_sound{path = "entity-build/train-stop"}
   printout("Train stop built facing" .. direction_lookup(dir) .. ", " .. build_comment, pindex)
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

--Directions lookup table
function direction_lookup(dir)
   local reading = "unknown"
   if dir < 0 then
      return "direction error 1"
   end
   
   if dir == 0 then
      reading = "North"
   elseif dir == 1 then
      reading = "Northeast"
   elseif dir == 2 then
      reading = "East"
   elseif dir == 3 then
      reading = "Southeast"
   elseif dir == 4 then
      reading = "South"
   elseif dir == 5 then
      reading = "Southwest"
   elseif dir == 6 then
      reading = "West"
   elseif dir == 7 then
      reading = "Northwest"
   else
      reading = "direction error 2"
   end      
   return reading
end


function rail_builder_open(pindex, rail)
   --Set the player menu tracker to this menu
   players[pindex].menu = "rail_builder"
   players[pindex].in_menu = true
   
   --Set the menu line counter to 0
   players[pindex].rail_builder.index = 0
   
   --Determine rail type
   local is_end_rail, end_dir, comment = check_end_rail(rail,pindex)
   local dir = rail.direction
   if is_end_rail then
      if dir == 0 or dir == 2 or dir == 4 or dir == 6 then 
         --Straight end rails
         players[pindex].rail_builder.rail_type = 1
         players[pindex].rail_builder.index_max = 6
      else 
         --Diagonal end rails
         players[pindex].rail_builder.rail_type = 2
         players[pindex].rail_builder.index_max = 2
      end
   else
      if dir == 0 or dir == 2 or dir == 4 or dir == 6 then 
         --Straight mid rails
         players[pindex].rail_builder.rail_type = 3
         players[pindex].rail_builder.index_max = 2
      else
         --Diagonal mid rails
         players[pindex].rail_builder.rail_type = 4
         players[pindex].rail_builder.index_max = 2
      end
   end
   
   --Play sound
   game.get_player(pindex).play_sound{path = "Open-Inventory-Sound"}
   
   --Load menu 
   players[pindex].rail_builder.rail = rail
   rail_builder(pindex, false)
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
      game.get_player(pindex).play_sound{path = "Mine-Building"}
   else
      --Play sound
      game.get_player(pindex).play_sound{path = "Inventory-Move"}
   end
   
   --Load menu 
   rail_builder(pindex, false)
end


function rail_builder_down(pindex)
   --Increment the index
   players[pindex].rail_builder.index = players[pindex].rail_builder.index + 1

   --Check the index against the limit
   if players[pindex].rail_builder.index > players[pindex].rail_builder.index_max then
      players[pindex].rail_builder.index = players[pindex].rail_builder.index_max
      game.get_player(pindex).play_sound{path = "Mine-Building"}
   else
      --Play sound
      game.get_player(pindex).play_sound{path = "Inventory-Move"}
   end
   
   --Load menu 
   rail_builder(pindex, false)
end


--Builder menu to build rail structures
function rail_builder(pindex, clicked_in)
   local clicked = clicked_in
   local comment = ""
   local menu_line = players[pindex].rail_builder.index
   local rail_type = players[pindex].rail_builder.rail_type
   local rail = players[pindex].rail_builder.rail
   
   if rail == nil then
      comment = " Rail nil error "
      printout(comment,pindex)
      rail_builder_close(pindex, false)
      return
   end
   
   if menu_line == 0 then
	  comment = comment .. "Select a structure to build by going up or down this menu, attempt to build it via LEFT BRACKET, "
      printout(comment,pindex)
      return
   end
   
   if rail_type == 1 then
      --Straight end rails
      if menu_line == 1 then
         if not clicked then
            comment = comment .. "Left turn 45 degrees"
            printout(comment,pindex)
         else
            --Build it here
            build_rail_turn_left_45_degrees(rail, pindex)
         end
      elseif menu_line == 2 then
         if not clicked then
            comment = comment .. "Right turn 45 degrees"
            printout(comment,pindex)
         else
            --Build it here
            build_rail_turn_right_45_degrees(rail, pindex)
         end
      elseif menu_line == 3 then
         if not clicked then
            comment = comment .. "Left turn 90 degrees"
            printout(comment,pindex)
         else
            --Build it here
            build_rail_turn_left_90_degrees(rail, pindex)
         end
      elseif menu_line == 4 then
         if not clicked then
            comment = comment .. "Right turn 90 degrees"
            printout(comment,pindex)
         else
            --Build it here
            build_rail_turn_right_90_degrees(rail, pindex)
         end
      elseif menu_line == 5 then
         if not clicked then
            comment = comment .. "Train stop facing end rail direction"
            printout(comment,pindex)
         else
            --Build it here
            build_train_stop(rail, pindex)
         end
      --elseif menu_line == 6 then
      --   if not clicked then
      --      comment = comment .. "Plus intersection"
      --      printout(comment,pindex)
      --   else
      --      --Build it here
      --      build_small_plus_intersection(rail, pindex)
      --   end
      end
   elseif rail_type == 2 then
      --Diagonal end rails
      if menu_line == 1 then
         if not clicked then
            comment = comment .. "Left turn 45 degrees"
            printout(comment,pindex)
         else
            --Build it here
            build_rail_turn_left_45_degrees(rail, pindex)
         end
      elseif menu_line == 2 then
         if not clicked then
            comment = comment .. "Right turn 45 degrees"
            printout(comment,pindex)
         else
            --Build it here
            build_rail_turn_right_45_degrees(rail, pindex)
         end
      end
   elseif rail_type == 3 then
      --Straight mid rails
	  if menu_line == 1 then
         if not clicked then
            comment = comment .. "Pair of chain rail signals."
            printout(comment,pindex)
         else
            local success, build_comment = place_chain_signal_pair(rail,pindex)
			if success then
			   comment = "Signals placed."
			else
			   comment = comment .. build_comment
			end
            printout(comment,pindex)
         end
	  elseif menu_line == 2 then
         if not clicked then
            comment = comment .. "Clear rail signals"
            printout(comment,pindex)
         else
            mine_signals(rail,pindex)
            printout("Signals cleared.",pindex)
         end
      end
      --After implementing junctions we will allow building mid rail train stops. This is commented out for now.
      --if menu_line == 3 then 
      --   if not clicked then
      --      comment = comment .. "Train stop facing the player direction"
      --      printout(comment,pindex)
      --   else
      --      --Build it here
      --      build_train_stop(rail, pindex)
      --   end
      --end
   elseif rail_type == 4 then
      --Diagonal mid rails
      if menu_line == 1 then
         if not clicked then
            comment = comment .. "Pair of chain rail signals." 
            printout(comment,pindex)
         else
            local success, build_comment = place_chain_signal_pair(rail,pindex)
			if success then
			   comment = "Signals placed."
			else
			   comment = comment .. build_comment
			end
            printout(comment,pindex)
         end
	  elseif menu_line == 2 then
         if not clicked then
            comment = comment .. "Clear rail signals"
            printout(comment,pindex)
         else
            mine_signals(rail,pindex)
            printout("Signals cleared.",pindex)
         end
      end
   end
   return
end

--This menu opens when the player presses LEFT BRACKET on a locomotive that they are either riding or looking at with the cursor.
function train_menu(menu_index, pindex, clicked, other_input)
   local index = menu_index
   local other = other_input or -1
   local locomotive = nil
   if game.get_player(pindex).vehicle ~= nil and game.get_player(pindex).vehicle.name == "locomotive" then
      locomotive = game.get_player(pindex).vehicle
      players[pindex].train_menu.locomotive = locomotive
   elseif players[pindex].tile.ents[1]  ~= nil and players[pindex].tile.ents[1].name == "locomotive" then
      locomotive = players[pindex].tile.ents[1]
      players[pindex].train_menu.locomotive = locomotive
   else
      players[pindex].train_menu.locomotive = nil
      printout("Train menu requires a locomotive", pindex)
      return
   end
   local train = locomotive.train
   
   if index == 0 then
      --Give basic info about this train, such as its name and ID. Instructions.
      printout("Train ".. get_train_name(train) .. ", with ID " .. train.id 
      .. ", Press UP ARROW and DOWN ARROW to navigate options, press LEFT BRACKET to select an option or press E to exit this menu.", pindex)
   elseif index == 1 then
      printout("Train state " .. get_train_state_info(train) .. " ", pindex)
   elseif index == 2 then
      if not clicked then
         printout("Rename this train, press LEFT BRACKET.", pindex)
      else
         if train.locomotives == nil then
            printout("The train must have locomotives for it to be named.", pindex)
            return
         end
         printout("Enter a new name for this train, then press ENTER to confirm.", pindex)
         players[pindex].train_menu.renaming = true
         local frame = game.get_player(pindex).gui.screen.add{type = "frame", name = "train-rename"}
         frame.bring_to_front()
         frame.force_auto_center()
         frame.focus()
         game.get_player(pindex).opened = frame
         local input = frame.add{type="textfield", name = "input"}
         input.focus()
      end
   elseif index == 3 then
      local locos = train.locomotives
      printout("Vehicle counts, " .. #locos["front_movers"] .. " locomotives facing front, " 
      .. #locos["back_movers"] .. " locomotives facing back, " .. #train.cargo_wagons .. " cargo wagons, "
      .. #train.fluid_wagons .. " fluid wagons, ", pindex) 
   elseif index == 4 then 
	  --Train contents
      printout("Cargo " .. train_top_contents_info(train) .. " ", pindex)
   elseif index == 5 then 
	  --Click here to travel to the next train stop
	  if not clicked then
         printout("Auto travel to a new train stop, press LEFT BRACKET.", pindex)
      else
	     sub_automatic_travel_to_other_stop(train,pindex)
      end
   end
   --[[ Train menu options summary
   0. name, id, menu instructions
   1. Train state , destination
   2. click to rename
   3. vehicles
   4. Cargo
   5. click to set schedule
   ]]
end


function train_menu_open(pindex)
   --Set the player menu tracker to this menu
   players[pindex].menu = "train_menu"
   players[pindex].in_menu = true
   
   --Set the menu line counter to 0
   players[pindex].train_menu.index = 0
   
   --Play sound
   game.get_player(pindex).play_sound{path = "Open-Inventory-Sound"}
   
   --Load menu 
   train_menu(players[pindex].train_menu.index, pindex, false)
end


function train_menu_close(pindex, mute_in)
   local mute = mute_in
   --Set the player menu tracker to none
   players[pindex].menu = "none"
   players[pindex].in_menu = false

   --Set the menu line counter to 0
   players[pindex].train_menu.index = 0
   
   --play sound
   if not mute then
      game.get_player(pindex).play_sound{path="Close-Inventory-Sound"}
   end
   
   --Destroy GUI
   if game.get_player(pindex).gui.screen["train-rename"] ~= nil then
      game.get_player(pindex).gui.screen["train-rename"].destroy()
   end
end


function train_menu_up(pindex)
   players[pindex].train_menu.index = players[pindex].train_menu.index - 1
   if players[pindex].train_menu.index < 0 then
      players[pindex].train_menu.index = 0
      game.get_player(pindex).play_sound{path = "Mine-Building"}
   else
      --Play sound
      game.get_player(pindex).play_sound{path = "Inventory-Move"}
   end
   --Load menu
   train_menu(players[pindex].train_menu.index, pindex, false)
end


function train_menu_down(pindex)
   players[pindex].train_menu.index = players[pindex].train_menu.index + 1
   if players[pindex].train_menu.index > 5 then
      players[pindex].train_menu.index = 5
      game.get_player(pindex).play_sound{path = "Mine-Building"}
   else
      --Play sound
      game.get_player(pindex).play_sound{path = "Inventory-Move"}
   end
   --Load menu
   train_menu(players[pindex].train_menu.index, pindex, false)
end


--This menu opens when the cursor presses LEFT BRACKET on a train stop.
function train_stop_menu(menu_index, pindex, clicked, other_input)
   local index = menu_index
   local other = other_input or -1
   local train_stop = nil
   if players[pindex].tile.ents[1]  ~= nil and players[pindex].tile.ents[1].name == "train-stop" then 
      train_stop = players[pindex].tile.ents[1]
      players[pindex].train_stop_menu.stop = train_stop
   else
      printout("Train stop menu error", pindex)
      players[pindex].train_stop_menu.stop = nil
      return
   end
   
   if index == 0 then
      printout("Train stop " .. train_stop.backer_name .. ", Press W and S to navigate options, press LEFT BRACKET to select an option or press E to exit this menu.", pindex)
   elseif index == 1 then
      if not clicked then
         printout("Rename this stop.", pindex)
      else
         printout("Enter a new name for this train stop, then press ENTER to confirm.", pindex)
         players[pindex].train_stop_menu.renaming = true
         local frame = game.get_player(pindex).gui.screen.add{type = "frame", name = "train-stop-rename"}
         frame.bring_to_front()
         frame.force_auto_center()
         frame.focus()
         game.get_player(pindex).opened = frame
         local input = frame.add{type="textfield", name = "input"}
         input.focus()
      end
   elseif index == 2 then
      printout("Note, you are recommended to set up a fast travel point near this stop.",pindex)--laterdo: add clickable option to add/remove this stop to the list.
   end
end


function train_stop_menu_open(pindex)
   --Set the player menu tracker to this menu
   players[pindex].menu = "train_stop_menu"
   players[pindex].in_menu = true
   
   --Set the menu line counter to 0
   players[pindex].train_stop_menu.index = 0
   
   --Play sound
   game.get_player(pindex).play_sound{path = "Open-Inventory-Sound"}  
   
   --Load menu 
   train_stop_menu(players[pindex].train_stop_menu.index, pindex, false)
end


function train_stop_menu_close(pindex, mute_in)
   local mute = mute_in
   --Set the player menu tracker to none
   players[pindex].menu = "none"
   players[pindex].in_menu = false

   --Set the menu line counter to 0
   players[pindex].train_stop_menu.index = 0
   
   --Destroy GUI
   if game.get_player(pindex).gui.screen["train-stop-rename"] ~= nil then
      game.get_player(pindex).gui.screen["train-stop-rename"].destroy()
   end
   
   --play sound
   if not mute then
      game.get_player(pindex).play_sound{path="Close-Inventory-Sound"}
   end
end


function train_stop_menu_up(pindex)
   players[pindex].train_stop_menu.index = players[pindex].train_stop_menu.index - 1
   if players[pindex].train_stop_menu.index < 0 then
      players[pindex].train_stop_menu.index = 0
      game.get_player(pindex).play_sound{path = "Mine-Building"}
   else
      --Play sound
      game.get_player(pindex).play_sound{path = "Inventory-Move"}
   end
   --Load menu 
   train_stop_menu(players[pindex].train_stop_menu.index, pindex, false)
end


function train_stop_menu_down(pindex)
   players[pindex].train_stop_menu.index = players[pindex].train_stop_menu.index + 1
   if players[pindex].train_stop_menu.index > 2 then
      players[pindex].train_stop_menu.index = 2
      game.get_player(pindex).play_sound{path = "Mine-Building"}
   else
      --Play sound
      game.get_player(pindex).play_sound{path = "Inventory-Move"}
   end
   --Load menu 
   train_stop_menu(players[pindex].train_stop_menu.index, pindex, false)
end

--Returns most common items in a cargo wagon. laterdo a full inventory screen maybe.
function cargo_wagon_top_contents_info(wagon)
   local result = ""
   local itemset = wagon.get_inventory(defines.inventory.cargo_wagon).get_contents()
   local itemtable = {}
   for name, count in pairs(itemset) do
      table.insert(itemtable, {name = name, count = count})
   end
   table.sort(itemtable, function(k1, k2)
      return k1.count > k2.count
   end)
   if #itemtable == 0 then
      result = result .. " Contains no items. "
   else
      result = result .. " Contains " .. itemtable[1].name .. " times " .. itemtable[1].count .. ", "
      if #itemtable > 1 then
         result = result .. " and " .. itemtable[2].name .. " times " .. itemtable[2].count .. ", "
      end
      if #itemtable > 2 then
         result = result .. " and " .. itemtable[3].name .. " times " .. itemtable[3].count .. ", "
      end
      if #itemtable > 3 then
         result = result .. " and " .. itemtable[4].name .. " times " .. itemtable[4].count .. ", "
      end
      if #itemtable > 4 then
         result = result .. " and " .. itemtable[5].name .. " times " .. itemtable[5].count .. ", "
      end
      if #itemtable > 5 then
         result = result .. " and other items "
      end
   end
   result = result .. ", Use inserters or cursor shortcuts to fill and empty this wagon. "
   return result
end

--Returns most common items in a fluid wagon or train.
function fluid_contents_info(wagon)
   local result = ""
   local itemset = wagon.get_fluid_contents()
   local itemtable = {}
   for name, amount in pairs(itemset) do
      table.insert(itemtable, {name = name, amount = amount})
   end
   table.sort(itemtable, function(k1, k2)
      return k1.amount > k2.amount
   end)
   if #itemtable == 0 then
      result = result .. " Contains no fluids. "
   else
      result = result .. " Contains " .. itemtable[1].name .. " times " .. string.format(" %.0f ", itemtable[1].amount) .. ", "
	  if #itemtable > 1 then
         result = result .. " and " .. itemtable[2].name .. " times " .. string.format(" %.0f ", itemtable[2].amount) .. ", "
      end
	  if #itemtable > 2 then
         result = result .. " and " .. itemtable[3].name .. " times " .. string.format(" %.0f ", itemtable[3].amount) .. ", "
      end
      if #itemtable > 3 then
         result = result .. " and other fluids "
      end
   end
   if wagon.object_name ~= "LuaTrain" and wagon.name == "fluid-wagon" then
      result = result .. ", Use pumps to fill and empty this wagon. "
   end
   return result
end


--Returns most common items and fluids in a train (sum of all wagons)
function train_top_contents_info(train)
   local result = ""
   local itemset = train.get_contents()
   local itemtable = {}
   for name, count in pairs(itemset) do
      table.insert(itemtable, {name = name, count = count})
   end
   table.sort(itemtable, function(k1, k2)
      return k1.count > k2.count
   end)
   if #itemtable == 0 then
      result = result .. " Contains no items, "
   else
      result = result .. " Contains " .. itemtable[1].name .. " times " .. itemtable[1].count .. ", "
      if #itemtable > 1 then
         result = result .. " and " .. itemtable[2].name .. " times " .. itemtable[2].count .. ", "
      end
      if #itemtable > 2 then
         result = result .. " and " .. itemtable[3].name .. " times " .. itemtable[3].count .. ", "
      end
      if #itemtable > 3 then
         result = result .. " and other items, "
      end
   end
   result = result .. fluid_contents_info(train)
   return result
end


--Return fuel content in a fuel inventory
function fuel_inventory_info(ent)
   local result = "Contains no fuel."
   local itemset = ent.get_fuel_inventory().get_contents()
   local itemtable = {}
   for name, count in pairs(itemset) do
      table.insert(itemtable, {name = name, count = count})
   end
   table.sort(itemtable, function(k1, k2)
      return k1.count > k2.count
   end)
   if #itemtable > 0 then
      result = "Contains as fuel, " .. itemtable[1].name .. " times " .. itemtable[1].count .. " "
      if #itemtable > 1 then
         result = result .. " and " .. itemtable[2].name .. " times " .. itemtable[2].count .. " "
      end
      if #itemtable > 2 then
         result = result .. " and " .. itemtable[3].name .. " times " .. itemtable[3].count .. " "
      end
   end
   return result
end


--Set a temporary train stop...
function set_temporary_train_stop(train,pindex)
   local p = game.get_player(pindex)
   local surf = p.surface
   local train_stops = surf.get_train_stops()
   for i,stop in ipairs(train_stops) do
      --Add the stop to the schedule's top
	  local wait_condition_1 = {type = "passenger_not_present", compare_type = "and"}
	  local new_record = {wait_conditions = {wait_condition_1}, station = stop.backer_name, temporary = true}
	  
	  local schedule = train.schedule
	  if schedule == nil then--**
	     schedule = {current = 1, records = {new_record}}
		 game.get_player(pindex).print("made new schedule")
	  else
		 local records = schedule.records
		 table.insert(records, new_record)--**try
		 game.get_player(pindex).print("added to schedule")
	  end
	  train.schedule = schedule
	  
	  --Make the train aim for the stop, but change stop if there is no path
	  train.go_to_station(1)
	  train.recalculate_path()
	  if true then return end--**
	  
	  if not train.has_path or train.path.size < 3 then --path size < 3 means the train is already at the station
	     game.get_player(pindex).print("nope")--**
		 --Clear the schedule record
		 local schedule_len = 0
		 if schedule ~= nil then
			 for i,row in ipairs(schedule) do
				schedule_len = schedule_len + 1
			 end
			 if schedule_len == 1 then --Removing the only line if any
				--train.schedule = nil
				game.get_player(pindex).print("schedule length now 0")
			 else --Removing one line
				--train.schedule = table.remove(train.schedule, 1)--**
				game.get_player(pindex).print("schedule length now " .. (schedule_len - 0))
			 end
		 else
		    game.get_player(pindex).print("schedule was nil")
		 end
	  else
	     --Valid station and path selected.
	     rendering.draw_circle{color = {0, 1, 0},radius = 7,width = 7,target = p.position,surface = p.surface,time_to_live = 100}
		 game.get_player(pindex).print("path size " .. train.path.size)
	     return
	     
	  end
   end
end



--Subautomatic travel to a reachable train stop that is at least 3 rails away
function sub_automatic_travel_to_other_stop(train,pindex)
   local p = game.get_player(pindex)
   local surf = p.surface
   local train_stops = surf.get_train_stops()
   for i,stop in ipairs(train_stops) do
      --Set a stop
	  local wait_condition_1 = {type = "passenger_present", compare_type = "and"}
	  local new_record = {wait_conditions = {wait_condition_1}, station = stop.backer_name, temporary = true}
	  train.schedule = {current = 1, records = {new_record}}
	  
	  --Make the train aim for the stop
	  train.go_to_station(1)	  
	  if not train.has_path or train.path.size < 3 then
	     --Invalid path or path to an station nearby
	     train.schedule = nil
		 train.manual_mode = true
	  else
	     --Valid station and path selected.
	     return
	  end
   end
end