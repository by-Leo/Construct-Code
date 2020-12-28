activity.onFileWrite = {}

activity.onFileWrite.scenes = function(t)
  if t.name == 'remove' or t.name == 'rename' then
    local newData = t.codeTable[1]

    for i = 2, #t.codeTable do
      if t.codeTable[i] ~= '' then
        newData = newData .. '\n' .. t.codeTable[i]
      end
    end

    local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
    local file = io.open(path, 'w')
    if file then
      file:write(newData)
      io.close(file)
    end
  elseif t.name == 'move' or t.name == 'copy' then
    local newData = t.codeTable.program

    for i = 1, #activity.scenes[activity.programs.name].block do
      newData = newData .. '\n' .. t.codeTable[activity.scenes[activity.programs.name].block[i].text.text]
    end

    local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
    local file = io.open(path, 'w')
    if file then
      file:write(newData)
      io.close(file)
    end
  end
end

activity.onFileWrite.objects = function(t)
  if t.name == 'remove' or t.name == 'rename' then
    local newData = t.codeTable[1][1]
    local bool = true
    local scene = ''
    local name = ''

    for i = 2, #t.codeTable do
      for j = 1, #t.codeTable[i] do
        if utf8.sub(t.codeTable[i][j], 1, 3) == '  s' then
          scene = utf8.match(t.codeTable[i][j], '  s (.*)')
          name = ''
        end
        if utf8.sub(t.codeTable[i][j], 1, 5) == '    o' then
          name = utf8.match(t.codeTable[i][j], '    o (.*):')
        end
        bool = scene .. '.' .. name == activity.scenes.scene .. '.' .. activity.objects[activity.scenes.name].block[t.codeTable[1][2]].text.text
        if not bool or t.name == 'rename' then
          newData = newData .. '\n' .. t.codeTable[i][j]
        end
      end
    end

    local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
    local file = io.open(path, 'w')
    if file then
      file:write(newData)
      io.close(file)
    end
  elseif t.name == 'move' or t.name == 'copy' then
    local newData = t.codeTable.program

    for i = 1, #activity.scenes[activity.programs.name].block do
      if activity.programs.name .. '.' .. activity.scenes[activity.programs.name].block[i].text.text == activity.scenes.name then
        newData = newData .. '\n' .. t.codeTable[activity.scenes[activity.programs.name].block[i].text.text].scene
        for j = 1, #activity.objects[activity.scenes.name].block do
          newData = newData .. '\n' .. t.codeTable[activity.scenes[activity.programs.name].block[i].text.text][activity.objects[activity.scenes.name].block[j].text.text]
        end
      else
        newData = newData .. '\n' .. t.codeTable[activity.scenes[activity.programs.name].block[i].text.text]
      end
    end

    local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
    local file = io.open(path, 'w')
    if file then
      file:write(newData)
      io.close(file)
    end
  end
end

activity.onFileWrite.textures = function(t)
  if t.name == 'move' or t.name == 'copy' or t.name == 'remove' or t.name == 'rename' then
    local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
    local file = io.open(path, 'w')

    print(json.prettify(t.codeTable))

    if file then
      file:write(jsonToCCode(t.codeTable))
      io.close(file)
    end
  end
end

activity.blocksFileUpdate = function(editor)
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
            elseif group.block[i].data.type == 'formula' then
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

  if file then
    file:write(jsonToCCode(data))
    io.close(file)
  end
end
