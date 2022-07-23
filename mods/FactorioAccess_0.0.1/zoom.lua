

local MIN_ZOOM = 0.275
local MAX_ZOOM = 3.282

local ZOOM_PER_TICK = 1.104086977

local ln_zoom = math.log(ZOOM_PER_TICK)


function get_zoom_tick(pindex)
   return math.floor(math.log(global.players[pindex].zoom)/ln_zoom + 0.5)
end

function tick_to_zoom(zoom_tick)
   return ZOOM_PER_TICK ^ zoom_tick
end

function fix_zoom(pindex)
   game.players[pindex].zoom = global.players[pindex].zoom
end

function zoom_change(pindex,etick,change_by_tick)
   -- if global.players[pindex].last_zoom_event_tick == etick then
      -- print("maybe duplicate")
      -- return
   -- end
   -- global.players[pindex].last_zoom_event_tick = etick
   if game.players[pindex].render_mode == defines.render_mode.game then
      local tick = get_zoom_tick(pindex)
      tick = tick + change_by_tick
      local zoom = tick_to_zoom(tick)
      if zoom < MAX_ZOOM and zoom > MIN_ZOOM then
         global.players[pindex].zoom = zoom
         target(pindex)
      end
   end
end

function zoom_in(event)
   zoom_change(event.player_index, event.tick, 1)
end

function zoom_out(event)
   zoom_change(event.player_index, event.tick, -1)
end



script.on_event("fa-zoom-in" , zoom_in )
script.on_event("fa-zoom-out", zoom_out)
script.on_event(defines.events.on_cutscene_waypoint_reached,function(event)
   if game.players[event.player_index].render_mode == defines.render_mode.game then
      fix_zoom(event.player_index)
   end
end)
script.on_event("fa-debug-reset-zoom",function(event)
   global.players[event.player_index].zoom = 1
end)
script.on_event("fa-debug-reset-zoom-2x",function(event)
   global.players[event.player_index].zoom = 2
end)