
for name, proto in pairs(data.raw.item) do
   if not proto.localised_description and proto.place_result then
      local pr = proto.place_result
      if pr.name then
         pr = pr.name
      end
      proto.localised_description = { "entity-description." .. pr }
   end
end

data.raw.character.character.has_belt_immunity = true