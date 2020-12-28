activity.onFileRead = {}

activity.onFileRead.scenes = function(t)
  if t.name == 'remove' or t.name == 'rename' then
    local codeTable = {}
    local num = 1

    local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
    local file = io.open(path, 'r')
    if file then
      for line in file:lines() do
        if utf8.sub(line, 1, 1) ~= 'p' then
          if utf8.sub(line, 1, 3) == '  s' then
            local lastName = utf8.match(line, '  s (.*)')
            num = num + 1
            if t.name == 'remove' then
              if lastName ~= activity.scenes[activity.programs.name].block[t.index].text.text then
                codeTable[num] = string.format('  s %s', lastName)
              else codeTable[num] = '' end
            elseif t.name == 'rename' then
              if lastName ~= t.oldTitle then
                codeTable[num] = string.format('  s %s', lastName)
              else codeTable[num] = string.format('  s %s', activity.scenes[activity.programs.name].block[t.index].text.text) end
            end
          else
            if codeTable[num] ~= '' then
              codeTable[num] = codeTable[num] .. '\n' .. line
            end
          end
        else
          codeTable[num] = line
        end
      end
      io.close(file)
    end

    activity.onFileWrite.scenes({
      codeTable = codeTable,
      name = t.name
    })
  elseif t.name == 'move' or t.name == 'copy' then
    local codeTable = {}
    local lastName = ''

    local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
    local file = io.open(path, 'r')
    if file then
      for line in file:lines() do
        if utf8.sub(line, 1, 1) ~= 'p' then
          if utf8.sub(line, 1, 3) == '  s' then
            lastName = utf8.sub(line, 5, utf8.len(line))
            codeTable[lastName] = string.format('  s %s', lastName)
            if lastName == activity.scenes[activity.programs.name].block[t.index].copy and t.name == 'copy' then
              codeTable[activity.scenes[activity.programs.name].block[t.index].text.text] = string.format('  s %s', activity.scenes[activity.programs.name].block[t.index].text.text)
            end
          else
            codeTable[lastName] = codeTable[lastName] .. '\n' .. line
            if lastName == activity.scenes[activity.programs.name].block[t.index].copy and t.name == 'copy' then
              codeTable[activity.scenes[activity.programs.name].block[t.index].text.text] = codeTable[activity.scenes[activity.programs.name].block[t.index].text.text] .. '\n' .. line
            end
          end
        else
          codeTable.program = line
        end
      end
      io.close(file)
    end

    activity.onFileWrite.scenes({
      codeTable = codeTable,
      name = t.name
    })
  end
end

activity.onFileRead.objects = function(t)
  if t.name == 'remove' or t.name == 'rename' then
    local codeTable = {}
    local num = 1

    local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
    local file = io.open(path, 'r')
    if file then
      for line in file:lines() do
        if utf8.sub(line, 1, 1) ~= 'p' then
          if utf8.sub(line, 1, 3) == '  s' then
            local scenesLastName = utf8.match(line, '  s (.*)')
            num = num + 1
            codeTable[num] = {}
            codeTable[num][#codeTable[num]+1] = string.format('  s %s', scenesLastName)
          else
            if utf8.sub(line, 1, 5) == '    o' and t.name == 'rename' then
              local lastName = utf8.match(line, '    o (.*):')
              local lastJson = utf8.match(line, ':(.*)/')
              local lastImport = utf8.match(line, '/(.*)')
              if t.oldTitle == lastName then
                codeTable[num][#codeTable[num]+1] = string.format('    o %s:%s/%s', activity.objects[activity.scenes.name].block[t.index].text.text, lastJson, lastImport)
              else
                codeTable[num][#codeTable[num]+1] = line
              end
            else
              codeTable[num][#codeTable[num]+1] = line
            end
          end
        else
          codeTable[num] = {line, t.index}
        end
      end
      io.close(file)
    end

    activity.onFileWrite.objects({
      name = t.name,
      codeTable = codeTable
    })
  elseif t.name == 'move' or t.name == 'copy' then
    local codeTable = {}
    local lastName = ''
    local scenesLastName = ''

    local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
    local file = io.open(path, 'r')
    if file then
      for line in file:lines() do
        if utf8.sub(line, 1, 1) ~= 'p' then
          if utf8.sub(line, 1, 3) == '  s' then
            scenesLastName = utf8.match(line, '  s (.*)')
            if activity.programs.name .. '.' .. scenesLastName == activity.scenes.name then
              codeTable[scenesLastName] = {}
              codeTable[scenesLastName].scene = string.format('  s %s', scenesLastName)
            else
              codeTable[scenesLastName] = string.format('  s %s', scenesLastName)
            end
          elseif utf8.sub(line, 1, 5) == '    o' and activity.programs.name .. '.' .. scenesLastName == activity.scenes.name then
            local lastImport = utf8.match(line, '/(.*)')
            local lastJson = utf8.match(line, ':(.*)/')
            lastName = utf8.match(line, '    o (.*):')
            codeTable[scenesLastName][lastName] = string.format('    o %s:%s/%s', lastName, lastJson, lastImport)
            if lastName == activity.objects[activity.scenes.name].block[t.index].copy and t.name == 'copy' then
              codeTable[scenesLastName][activity.objects[activity.scenes.name].block[t.index].text.text] = string.format('    o %s:%s/%s', activity.objects[activity.scenes.name].block[t.index].text.text, lastJson, lastImport)
            end
          else
            if activity.programs.name .. '.' .. scenesLastName == activity.scenes.name then
              codeTable[scenesLastName][lastName] = codeTable[scenesLastName][lastName] .. '\n' .. line
              if lastName == activity.objects[activity.scenes.name].block[t.index].copy and t.name == 'copy' then
                codeTable[scenesLastName][activity.objects[activity.scenes.name].block[t.index].text.text] = codeTable[scenesLastName][activity.objects[activity.scenes.name].block[t.index].text.text] .. '\n' .. line
              end
            else
              codeTable[scenesLastName] = codeTable[scenesLastName] .. '\n' .. line
            end
          end
        else
          codeTable.program = line
        end
      end
      io.close(file)
    end

    activity.onFileWrite.objects({
      name = t.name,
      codeTable = codeTable
    })
  end
end

activity.onFileRead.textures = function(t)
  if t.name == 'move' or t.name == 'copy' or t.name == 'remove' or t.name == 'rename' then
    local data = ccodeToJson(activity.programs.name)
    local texture = activity.textures[activity.objects.texture].block[t.index].text.text

    for sI = 1, #data.scenes do
      if data.scenes[sI].name == activity.scenes.scene then
        for oI = 1, #data.scenes[sI].objects do
          if data.scenes[sI].objects[oI].name == activity.objects.object then
            data.scenes[sI].objects[oI].textures = {}

            for i = 1, #activity.textures[activity.objects.texture].block do
              if t.name == 'remove' and activity.textures[activity.objects.texture].block[i].text.text ~= texture then
                data.scenes[sI].objects[oI].textures[#data.scenes[sI].objects[oI].textures+1] = activity.textures[activity.objects.texture].block[i].text.text
              elseif t.name ~= 'remove' then
                data.scenes[sI].objects[oI].textures[#data.scenes[sI].objects[oI].textures+1] = activity.textures[activity.objects.texture].block[i].text.text
              end
            end

            break
          end
        end
        break
      end
    end

    activity.onFileWrite.textures({
      name = t.name,
      codeTable = data
    })
  end
end
