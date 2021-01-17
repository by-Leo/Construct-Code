frm = {}

frm.setVar = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  for i = 1, #game.vars + 1 do
    if game.vars[i] and game.vars[i].name == name then
      game.vars[i].value = value
      if game.texts[i] and game.vars[i].value[2] ~= 'table' then
      game.texts[i].text = tostring(game.vars[i].value[1]) end break
    elseif i == #game.vars + 1 then
      game.vars[i] = {name = name, value = value}
    end
  end
end

frm.updVar = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    for i = 1, #game.vars + 1 do
      if game.vars[i] and game.vars[i].name == name and game.vars[i].value[2] == 'num' then
        game.vars[i].value[1] = game.vars[i].value[1] + value[1]
        if game.texts[i] and game.vars[i].value[2] ~= 'table' then
        game.texts[i].text = tostring(game.vars[i].value[1]) end break
      elseif i == #game.vars + 1 then
        game.vars[i] = {name = name, value = value}
      end
    end
  end
end

frm.setHideText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''

  for i = 1, #game.vars do
    if game.vars[i].name == name and game.texts[i] then
      game.texts[i]:removeSelf()
      break
    end
  end
end

frm.setShowText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local font = params[2][1] and params[2][1][1] or nil
  local color = params[3][1] and json.decode(params[3][1][1]) or {255,255,255}
  local size = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  local align = params[5][1] and params[5][1][1] or 'centerAlign'
  local alpha = calc(indexScene, indexObject, table.copy(params[6]), table.copy(localtable))

  if not font then
    if font ~= 'ubuntu.ttf' and font ~= 'sans.ttf' and font ~= 'system.ttf' then
      font = game.baseDir .. '/' .. gameName .. '/res .' .. font
    elseif font == 'system.ttf' then font = nil
    else font = system.pathForFile(font, system.ResourcesDirectory) end
  end

  for i = 1, #game.vars do
    if game.vars[i].name == name and game.vars[i].value[2] ~= 'table' then
      if game.texts[i] then game.texts[i]:removeSelf() end
      game.texts[i] = display.newText(game.vars[i].value[1], game.x, game.y, font, size[2] == 'num' and size[1] or 36)
      game.texts[i]:setFillColor(color[1]/255, color[2]/255, color[3]/255)
      game.texts[i].anchorX = align == 'centerAlign' and 0.5 or align == 'leftAlign' and 0 or align == 'rightAlign' and 1
      game.texts[i].alpha = alpha[2] == 'num' and alpha[1] / 100 or 1
      game.texts[i].z = 0 break
    end
  end
end

frm.updTable = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local name2 = params[2][1] and params[2][1][1] or ''
  local t = {}

  for i = 1, #game.vars do
    if game.vars[i].name == name2 and game.vars[i].value[2] == 'table' then
      local name3 = game.vars[i].value[1]
      if utf8.sub(name3, 1, 6) == '#table'
      then t = json.decode(utf8.sub(name3, 7, utf8.len(name3)))
      else for i = 1, #game.tables do if game.tables[i].name == name3
      then t = game.tables[i].value break end end end break
    end
  end

  for i = 1, #game.tables + 1 do
    if game.tables[i] and game.tables[i].name == name then game.tables[i].value = t break
    elseif i == #game.tables + 1 then game.tables[i] = {name = name, value = t} end
  end
end

frm.setTable = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local key = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  if key[1] then key = key[1] else key = '' end

  for i = 1, #game.tables + 1 do
    if game.tables[i] and game.tables[i].name == name then
      for j = 1, #game.tables[i].value + 1 do
        if game.tables[i].value[j].key == key then
          game.tables[i].value[j].value = value break
        elseif j == #game.tables[i].value + 1 then
          game.tables[i].value[j] = {key = key, value = value}
        end
      end break
    elseif i == #game.tables + 1 then
      game.tables[i] = {name = name, value = {{key = key, value = value}}}
    end
  end
end

frm.removeTable = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local key = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if key[1] then key = key[1] else key = '' end

  for i = 1, #game.tables + 1 do
    if game.tables[i] and game.tables[i].name == name then
      for j = 1, #game.tables[i].value + 1 do
        if game.tables[i].value[j].key == key then
          table.remove(game.tables[i].value, j) break
        end
      end break
    end
  end
end

frm.setPosText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value1 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  for i = 1, #game.vars do
    if game.vars[i].name == name and game.texts[i] then
      game.texts[i].x = value1[2] == 'num' and game.x + value1[1] or game.x
      game.texts[i].y = value2[2] == 'num' and game.y - value2[1] or game.y break
    end
  end
end

frm.setPosXText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    for i = 1, #game.vars do
      if game.vars[i].name == name and game.texts[i] then
        game.texts[i].x = game.x + value[1] break
      end
    end
  end
end

frm.setPosYText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    for i = 1, #game.vars do
      if game.vars[i].name == name and game.texts[i] then
        game.texts[i].y = game.y - value[1] break
      end
    end
  end
end

frm.setRotationText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    for i = 1, #game.vars do
      if game.vars[i].name == name and game.texts[i] then
        game.texts[i].rotation = value[1] break
      end
    end
  end
end

frm.setAlignText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local align = params[2][1] and params[2][1][1] or 'centerAlign'

  if value[2] == 'num' then
    for i = 1, #game.vars do
      if game.vars[i].name == name and game.texts[i] then
        game.texts[i].anchorX = align == 'centerAlign' and 0.5 or align == 'leftAlign' and 0 or align == 'rightAlign' and 1
        break
      end
    end
  end
end

frm.setAlphaText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    for i = 1, #game.vars do
      if game.vars[i].name == name and game.texts[i] then
        game.texts[i].alpha = value[1] / 100 break
      end
    end
  end
end

frm.setColorText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local color = params[3][1] and json.decode(params[3][1][1]) or {255,255,255}

  if value[2] == 'num' then
    for i = 1, #game.vars do
      if game.vars[i].name == name and game.texts[i] then
        game.texts[i]:setFillColor(color[1]/255, color[2]/255, color[3]/255) break
      end
    end
  end
end

frm.setFrontText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''

  for i = 1, #game.vars do
    if game.vars[i].name == name and game.texts[i] then
      game.texts[i].z = game.texts[i].z + 1
      game.texts[i]:toFront() break
    end
  end
end

frm.setBackText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''

  for i = 1, #game.vars do
    if game.vars[i].name == name and game.texts[i] then
      game.texts[i].z = game.texts[i].z - 1
      game.texts[i]:toBack() break
    end
  end
end

frm.readVar = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''

  local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/save.json'
  local file = io.open(path, 'r')
  local data = {} if file then data = json.decode(file:read('*a')) io.close(file) end

  if data[name] then
    for i = 1, #game.vars + 1 do
      if game.vars[i] and game.vars[i].name == name then
        game.vars[i].value = table.copy(data[name])
        if game.texts[i] and game.vars[i].value[2] ~= 'table' then
        game.texts[i].text = tostring(game.vars[i].value[1]) end break
      elseif i == #game.vars + 1 then
        game.vars[i] = {name = name, value = table.copy(data[name])}
      end
    end
  end
end

frm.writeVar = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''

  local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/save.json'
  local file = io.open(path, 'r')
  local data = {} if file then data = json.decode(file:read('*a')) io.close(file) end

  for i = 1, #game.vars do
    if game.vars[i].name == name then
      data[name] = table.copy(game.vars[i].value) break
    end
  end

  local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/save.json'
  local file = io.open(path, 'w')
  if file then file:write(json.encode(data)) io.close(file) end
end
