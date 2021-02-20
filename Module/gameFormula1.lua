frm = {}

frm.setVar = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  for i = 1, #game.vars + 1 do
    if game.vars[i] and game.vars[i].name == name then
      game.vars[i].value = {value[1], value[2]} if game.texts[i] then
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
        game.vars[i].value = {tostring(game.vars[i].value[1] + value[1]), 'num'}
        if game.texts[i] then game.texts[i].text = tostring(game.vars[i].value[1]) end break
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
  local font = params[2][1] and params[2][1][1] or ''
  local color = params[3][1] and json.decode(params[3][1][1]) or {255,255,255}
  local size = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  local width = calc(indexScene, indexObject, table.copy(params[5]), table.copy(localtable))
  local height = calc(indexScene, indexObject, table.copy(params[6]), table.copy(localtable))

  for i = 1, #game.vars + 1 do
    if game.vars[i] and game.vars[i].name == name then break
    elseif i == #game.vars + 1 then game.vars[i] = {name = name, value = {'0', 'num'}} end
  end

  for i = 1, #game.vars do
    if game.vars[i].name == name then
      local textConfig = {
        x = game.x, y = game.y, text = game.vars[i].value[1],
        font = font, fontSize = size[2] == 'num' and tonumber(size[1]) or 36
      } if game.texts[i] then game.texts[i]:removeSelf() end

      if width[2] == 'num' and height[2] == 'num'
      then textConfig.width, textConfig.height = tonumber(width[1]), tonumber(height[1])
      elseif width[2] == 'num' then textConfig.width = tonumber(width[1])
      elseif height[2] == 'num' then textConfig.height = tonumber(height[1]) end

      game.texts[i] = display.newText(textConfig)
      game.texts[i].z, game.texts[i].color = 0, color
      game.texts[i]:setFillColor(color[1]/255, color[2]/255, color[3]/255) break
    end
  end
end

frm.updTable = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'table' then
    for i = 1, #game.tables + 1 do
      if game.tables[i] and game.tables[i].name == name then
        game.tables[i] = {name = name, val = value[1]}
      elseif i == #game.tables + 1 then
        game.tables[i] = {name = name, val = value[1]}
      end
    end
  end
end

frm.setTable = function(indexScene, indexObject, params, localtable)
  local name = params[2][1] and params[2][1][1]
  local key = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if key[2] == 'key' then key = json.decode(key[1])
    for i = 1, #game.tables + 1 do
      if game.tables[i] and game.tables[i].name == name then
        local t = game.tables[i].val for j = 1, #key - 1 do if t[key[j]]
        then t = t[key[j]] end end t[key[#key]] = {value[1], value[2]} break
      elseif i == #game.tables + 1 then
        local t = {} game.tables[i] = {name = name, val = t} for j = 1, #key - 1
        do t[key[j]] = {} t = t[key[j]] end t[key[#key]] = {value[1], value[2]}
      end
    end
  end
end

frm.removeTable = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1]
  local key = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if key[2] == 'key' then key = json.decode(key[1])
    for i = 1, #game.tables do
      if game.tables[i].name == name then
        local t = game.tables[i].val for j = 1, #key do if t[key[j]] then
        if j == #key then t[key[j]] = nil else t = t[key[j]] end end end
      end
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

frm.setAlignText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local alignX = params[2][1] and params[2][1][1] or ''
  local alignY = params[3][1] and params[3][1][1] or ''

  for i = 1, #game.vars do
    if game.vars[i].name == name and game.texts[i] then
      game.texts[i].anchorX = alignX == 'rightAlign' and 1 or alignX == 'leftAlign' and 0 or 0.5
      game.texts[i].anchorY = alignY == 'bottomAlign' and 1 or alignY == 'topAlign' and 0 or 0.5 break
    end
  end
end

frm.setColorText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local color = params[2][1] and json.decode(params[2][1][1]) or {255,255,255}

  for i = 1, #game.vars do
    if game.vars[i].name == name and game.texts[i] then
      game.texts[i].color = table.copy(color)
      game.texts[i]:setFillColor(color[1]/255, color[2]/255, color[3]/255) break
    end
  end
end

frm.setRGBColorText = function(indexScene, indexObject, params, localtable)
  local name, color = params[1][1] and params[1][1][1] or '', {255, 255, 255}
  local r = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local g = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local b = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  if r[2] == 'num' and g[2] == 'num' and b[2] == 'num' then color = {r[1], g[1], b[1]} end

  for i = 1, #game.vars do
    if game.vars[i].name == name and game.texts[i] then
      game.texts[i].color = table.copy(color)
      game.texts[i]:setFillColor(color[1]/255, color[2]/255, color[3]/255) break
    end
  end
end

frm.setHEXColorText = function(indexScene, indexObject, params, localtable)
  local name, color = params[1][1] and params[1][1][1] or '', {255, 255, 255}
  local colorhex = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if colorhex[2] ~= 'text' then colorhex = {'FFFFFF', 'text'} end

  if utf8.sub(colorhex[1], 1, 1) == '#' then colorhex[1] = utf8.sub(colorhex[1], 2, 7) end
  if utf8.len(colorhex[1]) ~= 6 then colorhex[1] = 'FFFFFF' end local errorHex = false
  local filterHex = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}
  for indexHex = 1, 6 do local symHex = utf8.upper(utf8.sub(colorhex[1], indexHex, indexHex))
    for i = 1, #filterHex do
      if symHex == filterHex[i] then break elseif i == #filterHex then errorHex = true end
    end
  end if errorHex then colorhex[1] = 'FFFFFF' end color = hex(colorhex[1])

  for i = 1, #game.vars do
    if game.vars[i].name == name and game.texts[i] then
      game.texts[i].color = table.copy(color)
      game.texts[i]:setFillColor(color[1]/255, color[2]/255, color[3]/255) break
    end
  end
end

frm.updColorText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    for i = 1, #game.vars do
      if game.vars[i].name == name and game.texts[i] then
        local color = game.texts[i].color
        color[1], color[2], color[3] = color[1] + value[1], color[2] + value[1], color[3] + value[1]
        for j = 1, 3 do if color[j] > 255 then color[j] = color[j] - 255
        elseif color[j] < 0 then color[j] = color[j] + 255 end end
        game.texts[i]:setFillColor(color[1] / 255, color[2] / 255, color[3] / 255)
        game.texts[i].color = table.copy(color) break
      end
    end
  end
end

frm.updRColorText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    for i = 1, #game.vars do
      if game.vars[i].name == name and game.texts[i] then
        local color = game.texts[i].color color[1] = color[1] + value[1]
        if color[1] > 255 then color[1] = color[1] - 255
        elseif color[1] < 0 then color[1] = color[1] + 255 end
        game.texts[i]:setFillColor(color[1] / 255, color[2] / 255, color[3] / 255)
        game.texts[i].color = table.copy(color) break
      end
    end
  end
end

frm.updGColorText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    for i = 1, #game.vars do
      if game.vars[i].name == name and game.texts[i] then
        local color = game.texts[i].color color[2] = color[2] + value[1]
        if color[2] > 255 then color[2] = color[2] - 255
        elseif color[2] < 0 then color[2] = color[2] + 255 end
        game.texts[i]:setFillColor(color[1] / 255, color[2] / 255, color[3] / 255)
        game.texts[i].color = table.copy(color) break
      end
    end
  end
end

frm.updBColorText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    for i = 1, #game.vars do
      if game.vars[i].name == name and game.texts[i] then
        local color = game.texts[i].color color[3] = color[3] + value[1]
        if color[3] > 255 then color[3] = color[3] - 255
        elseif color[3] < 0 then color[3] = color[3] + 255 end
        game.texts[i]:setFillColor(color[1] / 255, color[2] / 255, color[3] / 255)
        game.texts[i].color = table.copy(color) break
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
        if game.texts[i] then
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
