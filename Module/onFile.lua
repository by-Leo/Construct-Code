activity.onFile = {}

activity.onFile.scenes = function(name, index)
  local group = activity.scenes[activity.programs.name]
  local data = ccodeToJson(activity.programs.name)

  if name == 'remove' then
    table.remove(data.scenes, index)
  elseif name == 'rename' then
    data.scenes[index].name = activity.scenes[activity.programs.name].block[index].text.text
  elseif name == 'move' or name == 'copy' then
    local t, newdata, copy, copyI = {}, {build = data.build, program = data.program, scenes = {}}, false, 1
    for i = 1, #data.scenes do t[data.scenes[i].name] = data.scenes[i] end
    for i = 1, #group.block do
      if name == 'copy' and group.block[i].text.text == group.block[index].copy then
        copy, copyI = true, i
        newdata.scenes[i] = {
          name = t[group.block[i].text.text].name,
          objects = table.copy(t[group.block[i].text.text].objects)
        }
        newdata.scenes[index] = {
          name = group.block[index].text.text,
          objects = table.copy(t[group.block[i].text.text].objects)
        }
      else
        if t[group.block[i].text.text] then
          newdata.scenes[i] = {
            name = t[group.block[i].text.text].name,
            objects = table.copy(t[group.block[i].text.text].objects)
          }
        elseif name == 'copy' and not copy then
          newdata.scenes[i] = {}
        end
      end
    end data = newdata
  end

  local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
  local file = io.open(path, 'w')
  if file then file:write(jsonToCCode(data)) io.close(file) end
end

activity.onFile.objects = function(name, index)
  local group = activity.objects[activity.scenes.name]
  local data = ccodeToJson(activity.programs.name)

  for j = 1, #data.scenes do
    if data.scenes[j].name == activity.scenes.scene then
      if name == 'remove' then
        table.remove(data.scenes[j].objects, index)
      elseif name == 'rename' then
        data.scenes[j].objects[index].name = activity.objects[activity.scenes.name].block[index].text.text
      elseif name == 'move' or name == 'copy' then
        local t, newdata, copy, copyI = {}, {build = data.build, program = data.program, scenes = table.copy(data.scenes)}, false, 1
        newdata.scenes[j] = {name = data.scenes[j].name, objects = {}}
        for i = 1, #data.scenes[j].objects do t[data.scenes[j].objects[i].name] = data.scenes[j].objects[i] end
        for i = 1, #group.block do
          if name == 'copy' and group.block[i].text.text == group.block[index].copy then
            copy, copyI = true, i
            newdata.scenes[j].objects[i] = {
              name = t[group.block[i].text.text].name,
              import = t[group.block[i].text.text].import,
              textures = table.copy(t[group.block[i].text.text].textures),
              events = table.copy(t[group.block[i].text.text].events)
            }
            newdata.scenes[j].objects[index] = {
              name = group.block[index].text.text,
              import = t[group.block[i].text.text].import,
              textures = table.copy(t[group.block[i].text.text].textures),
              events = table.copy(t[group.block[i].text.text].events)
            }
          else
            if t[group.block[i].text.text] then
              newdata.scenes[j].objects[i] = {
                name = t[group.block[i].text.text].name,
                import = t[group.block[i].text.text].import,
                textures = table.copy(t[group.block[i].text.text].textures),
                events = table.copy(t[group.block[i].text.text].events)
              }
            elseif name == 'copy' and not copy then
              newdata.scenes[j].objects[i] = {}
            end
          end
        end data = newdata
      end
      break
    end
  end


  local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
  local file = io.open(path, 'w')
  if file then file:write(jsonToCCode(data)) io.close(file) end
end

activity.onFile.textures = function(name, index)
  if name == 'move' or name == 'copy' or name == 'remove' or name == 'rename' then
    local data = ccodeToJson(activity.programs.name)
    local texture = activity.textures[activity.objects.texture].block[index].text.text

    for sI = 1, #data.scenes do
      if data.scenes[sI].name == activity.scenes.scene then
        for oI = 1, #data.scenes[sI].objects do
          if data.scenes[sI].objects[oI].name == activity.objects.object then
            data.scenes[sI].objects[oI].textures = {}
            for i = 1, #activity.textures[activity.objects.texture].block do
              if name == 'remove' and activity.textures[activity.objects.texture].block[i].text.text ~= texture then
                data.scenes[sI].objects[oI].textures[#data.scenes[sI].objects[oI].textures+1] = activity.textures[activity.objects.texture].block[i].text.text
              elseif name ~= 'remove' then
                data.scenes[sI].objects[oI].textures[#data.scenes[sI].objects[oI].textures+1] = activity.textures[activity.objects.texture].block[i].text.text
              end
            end
            break
          end
        end
        break
      end
    end

    local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
    local file = io.open(path, 'w')
    if file then file:write(jsonToCCode(data)) io.close(file) end
  end
end

activity.blocksFileUpdate = function()
  local group = activity.blocks[activity.objects.name]
  local data = ccodeToJson(activity.programs.name)

  for s = 1, #data.scenes do
    if data.scenes[s].name == activity.scenes.scene then
      for o = 1, #data.scenes[s].objects do
        if data.scenes[s].objects[o].name == activity.objects.object then
          data.scenes[s].objects[o].events = {}

          for i = 1, #group.block do
            if group.block[i].data.type == 'event' then
              data.scenes[s].objects[o].events[#data.scenes[s].objects[o].events+1] = {
                name = group.block[i].data.name,
                params = group.block[i].data.params,
                comment = group.block[i].data.comment,
                formulas = {}
              }
            elseif group.block[i].data.type == 'formula' and #data.scenes[s].objects[o].events > 0 then
              data.scenes[s].objects[o].events[#data.scenes[s].objects[o].events].formulas[#data.scenes[s].objects[o].events[#data.scenes[s].objects[o].events].formulas+1] = {
                name = group.block[i].data.name,
                params = group.block[i].data.params,
                comment = group.block[i].data.comment
              }
            end
          end
        end
      end
    end
  end

  local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/' .. activity.programs.name .. '.cc'
  local file = io.open(path, 'w')
  if file then file:write(jsonToCCode(data)) io.close(file) end
end
