
for name, proto in pairs(data.raw.item) do
   if not proto.localised_description and proto.place_result then
      local pr = proto.place_result
      if pr.name then
         pr = pr.name
      end
      proto.localised_description = { "entity-description." .. pr }
   end
end

for name, proto in pairs(data.raw.container) do
   proto.open_sound  = proto.open_sound  or { filename = "__base__/sound/metallic-chest-open.ogg" , volume = 0.43 }
   proto.close_sound = proto.close_sound or { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.43 }
end

data.raw.character.character.has_belt_immunity = true