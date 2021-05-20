frm = {}

frm.setVar = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  game.vars[name] = {value[1], value[2]}
end

frm.updVar = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    if not game.vars[name] then game.vars[name] = {value[1], value[2]} end
    game.vars[name] = {tostring(game.vars[name][1] + value[1]), value[2]}
  end
end

frm.setRemoveText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.texts[name] then game.texts[name]:removeSelf() game.texts[name]= nil end
end

frm.setHideText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.texts[name] then game.texts[name].isVisible, game.texts[name].vis = false, false end
end

frm.setViewText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.texts[name] then game.texts[name].isVisible, game.texts[name].vis = true, true end
end

frm.setText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))[1]
  if game.texts[name] then game.texts[name].text = value end
end

frm.setShowText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))[1]
  local font = params[3][1] and params[3][1][1] or ''
  local size = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  local color = params[5][1] and json.decode(params[5][1][1]) or {255,255,255}
  local alpha = calc(indexScene, indexObject, table.copy(params[6]), table.copy(localtable))

  local textConfig = {
    x = game.x, y = game.y, text = value, font = font,
    fontSize = size[2] == 'num' and tonumber(size[1]) or 36
  } if game.texts[name] then game.texts[name]:removeSelf() game.texts[name] = nil end

  game.texts[name] = display.newText(textConfig)
  game.texts[name].z, game.texts[name].color = 0, color
  game.texts[name].alpha = alpha[2] == 'num' and tonumber(alpha[1])/100 or 1
  game.texts[name].vis, game.texts[name].scene = true, indexScene
  game.texts[name]:setFillColor(color[1]/255, color[2]/255, color[3]/255)
end

frm.setShowText2 = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))[1]
  local font = params[3][1] and params[3][1][1] or ''
  local size = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  local width = calc(indexScene, indexObject, table.copy(params[5]), table.copy(localtable))
  local height = calc(indexScene, indexObject, table.copy(params[6]), table.copy(localtable))

  local textConfig = {
    x = game.x, y = game.y, text = value, font = font,
    fontSize = size[2] == 'num' and tonumber(size[1]) or 36
  } if game.texts[name] then game.texts[name]:removeSelf() end

  if width[2] == 'num' and height[2] == 'num'
  then textConfig.width, textConfig.height = tonumber(width[1]), tonumber(height[1])
  elseif width[2] == 'num' then textConfig.width = tonumber(width[1])
  elseif height[2] == 'num' then textConfig.height = tonumber(height[1]) end

  game.texts[name] = display.newText(textConfig)
  game.texts[name].z, game.texts[name].color = 0, {255,255,255}
  game.texts[name].vis, game.texts[name].scene = true, indexScene
end

frm.updTable = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'table' then game.tables[name] = value[1] end
end

frm.setTable = function(indexScene, indexObject, params, localtable)
  local name = params[2][1] and params[2][1][1]
  local key = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  if key[2] ~= 'key' then key = {'["' .. key[1] .. '"]', 'key'} end

  if key[2] == 'key' then key = json.decode(key[1])
    if game.tables[name] then local script = 'local json = require \'json\''
      .. ' local result = json.decode(\'' .. json.encode(game.tables[name]) .. '\') '
      for j = 1, #key do local script2 = 'result'
        for k = 1, j do script2 = script2 .. '[\'' .. key[k] .. '\']' end if j ~= #key then
        script = script .. ' if ' .. script2 .. '[1] and type(' .. script2 .. '[1]) ~= \'table\' then '
        .. script2 .. ' = {} end ' else script = script .. script2 .. ' = {[['
        .. value[1] .. ']], \'' .. value[2] .. '\'} return result' end end
      game.tables[name] = loadstring(script)()
    else local script = 'local result = {}'
      for j = 1, #key do script = script .. ' result'
        for k = 1, j do script = script .. '[\'' .. key[k] .. '\']'
        end if j ~= #key then script = script .. ' = {}' end
      end script = script .. ' = {[[' .. value[1] .. ']], \'' .. value[2] .. '\'} return result'
      game.tables[name] = loadstring(script)()
    end
  end
end

frm.removeTable = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1]
  local key = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if key[2] ~= 'key' then key = {'["' .. key[1] .. '"]', 'key'} end

  if key[2] == 'key' then key = json.decode(key[1])
    if game.tables[name] then
      local t = game.tables[name] for j = 1, #key do if t[key[j]] then
      if j == #key then t[key[j]] = nil else t = t[key[j]] end end end
    end
  end
end

frm.setPosText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value1 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if game.texts[name] then
    game.texts[name].x = value1[2] == 'num' and game.x + value1[1] or game.x
    game.texts[name].y = value2[2] == 'num' and game.y - value2[1] or game.y
  end
end

frm.setPosXText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'num' and game.texts[name] then game.texts[name].x = game.x + value[1] end
end

frm.setPosYText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'num' and game.texts[name] then game.texts[name].y = game.y - value[1] end
end

frm.setRotationText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'num' and game.texts[name] then game.texts[name].rotation = value[1] end
end

frm.setAlphaText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'num' and game.texts[name] then game.texts[name].alpha = value[1] / 100 end
end

frm.setAlignText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local alignX = params[2][1] and params[2][1][1] or ''
  local alignY = params[3][1] and params[3][1][1] or ''

  if game.texts[name] then
    game.texts[name].anchorX = alignX == 'rightAlign' and 1 or (alignX == 'leftAlign' and 0 or 0.5)
    game.texts[name].anchorY = alignY == 'bottomAlign' and 1 or (alignY == 'topAlign' and 0 or 0.5)
  end
end

frm.setColorText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local color = params[2][1] and json.decode(params[2][1][1]) or {255,255,255}

  if game.texts[name] then
    game.texts[name].color = table.copy(color)
    game.texts[name]:setFillColor(color[1]/255, color[2]/255, color[3]/255)
  end
end

frm.setRGBColorText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local color = {255, 255, 255}
  local r = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local g = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local b = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  if r[2] == 'num' and g[2] == 'num' and b[2] == 'num' then color = {r[1], g[1], b[1]} end

  if game.texts[name] then
    game.texts[name].color = table.copy(color)
    game.texts[name]:setFillColor(color[1]/255, color[2]/255, color[3]/255)
  end
end

frm.setHEXColorText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local color = {255, 255, 255}
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

  if game.texts[name] then
    game.texts[name].color = table.copy(color)
    game.texts[name]:setFillColor(color[1]/255, color[2]/255, color[3]/255)
  end
end

frm.updColorText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.texts[name] then
    local color = game.texts[name].color
    color[1], color[2], color[3] = color[1] + value[1], color[2] + value[1], color[3] + value[1]
    for j = 1, 3 do if color[j] > 255 then color[j] = color[j] - 255
    elseif color[j] < 0 then color[j] = color[j] + 255 end end
    game.texts[name]:setFillColor(color[1] / 255, color[2] / 255, color[3] / 255)
    game.texts[name].color = table.copy(color)
  end
end

frm.updRColorText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.texts[name] then
    local color = game.texts[name].color color[1] = color[1] + value[1]
    if color[1] > 255 then color[1] = color[1] - 255
    elseif color[1] < 0 then color[1] = color[1] + 255 end
    game.texts[name]:setFillColor(color[1] / 255, color[2] / 255, color[3] / 255)
    game.texts[name].color = table.copy(color)
  end
end

frm.updGColorText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.texts[name] then
    local color = game.texts[name].color color[2] = color[2] + value[1]
    if color[2] > 255 then color[2] = color[2] - 255
    elseif color[2] < 0 then color[2] = color[2] + 255 end
    game.texts[name]:setFillColor(color[1] / 255, color[2] / 255, color[3] / 255)
    game.texts[name].color = table.copy(color)
  end
end

frm.updBColorText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.texts[name] then
    local color = game.texts[name].color color[3] = color[3] + value[1]
    if color[3] > 255 then color[3] = color[3] - 255
    elseif color[3] < 0 then color[3] = color[3] + 255 end
    game.texts[name]:setFillColor(color[1] / 255, color[2] / 255, color[3] / 255)
    game.texts[name].color = table.copy(color)
  end
end

frm.setFrontText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.texts[name] then game.texts[name].z = game.texts[name].z + 1 game.texts[name]:toFront() end
end

frm.setBackText = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.texts[name] then game.texts[name].z = game.texts[name].z - 1 game.texts[name]:toBack() end
end

frm.readVar = function(indexScene, indexObject, params, localtable)
  local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/save.json'
  local name, file = params[1][1] and params[1][1][1] or '', io.open(path, 'r')
  local data = {} if file then data = json.decode(file:read('*a')) io.close(file) end
  if data[name] then game.vars[name] = table.copy(data[name]) end
end

frm.writeVar = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''

  local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/save.json'
  local file = io.open(path, 'r')
  local data = {} if file then data = json.decode(file:read('*a')) io.close(file) end
  data[name] = table.copy(game.vars[name])

  local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/save.json'
  local file = io.open(path, 'w')
  if file then file:write(json.encode(data)) io.close(file) end
end

frm.setTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if not game.tags[name] then game.tags[name] = display.newGroup() end
  game.objects[indexScene][indexObject].data.tag = name
  game.tags[name]:insert(game.objects[indexScene][indexObject])
end

frm.setTagShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local name2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))[1]
  if not game.tags[name] then game.tags[name] = display.newGroup() end if game.shapes[name2]
  then game.shapes[name2].data.tag = name game.tags[name]:insert(game.shapes[name2]) end
end

frm.setPosTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value1 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if game.tags[name] and value[2] == 'num' then
    game.tags[name].x = value1[2] == 'num' and tonumber(value1[1]) or 0
    game.tags[name].y = value2[2] == 'num' and -tonumber(value2[1]) or 0
  end
end

frm.setXTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if game.tags[name] and value[2] == 'num' then
    game.tags[name].x = tonumber(value[1])
  end
end

frm.setYTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if game.tags[name] and value[2] == 'num' then
    game.tags[name].y = -tonumber(value[1])
  end
end

frm.updXTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if game.tags[name] and value[2] == 'num' then
    game.tags[name].x = game.tags[name].x + value[1]
  end
end

frm.updYTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if game.tags[name] and value[2] == 'num' then
    game.tags[name].y = game.tags[name].y - value[1]
  end
end

frm.setHideTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.tags[name] then game.tags[name].isVisible = false end
end

frm.setViewTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.tags[name] then game.tags[name].isVisible = true end
end

frm.setAlphaTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if game.tags[name] and value[2] == 'num' then
    game.tags[name].alpha = value[1] / 100
  end
end

frm.updAlphaTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if game.tags[name] and value[2] == 'num' then
    game.tags[name].alpha = game.tags[name].alpha + value[1] / 100
  end
end

frm._setTransitionPosTag = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and value2[2] == 'num' and game.tags[name] then
    transition.to(game.tags[name], {
    x = tonumber(value[1]), y = -tonumber(value2[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionPosXTag = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and game.tags[name] then
    transition.to(game.tags[name], {
    x = tonumber(value[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionPosYTag = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and game.tags[name] then
    transition.to(game.tags[name], {
    y = -tonumber(value[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionAlphaTag = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and game.tags[name] then
    transition.to(game.tags[name], {
    alpha = value[1] / 100, time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm.setFrontTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.tags[name] then game.tags[name]:toFront() end
end

frm.setBackTag = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.tags[name] then game.tags[name]:toBack() end
end

frm.setXSnapshot = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'num' then game.snapshot.x = game.x + value[1] end
end

frm.setYSnapshot = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'num' then game.snapshot.y = game.y - value[1] end
end

frm.updXSnapshot = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'num' then game.snapshot:translate(tonumber(value[1]), 0) end
end

frm.updYSnapshot = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'num' then game.snapshot:translate(0, -tonumber(value[1])) end
end

frm.setAlphaSnapshot = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'num' then game.snapshot.alpha = value[1] / 100 end
end

frm.updAlphaSnapshot = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'num' then game.snapshot.alpha = game.snapshot.alpha + value[1] / 100 end
end

frm.setHideSnapshot = function(indexScene, indexObject, params, localtable) game.snapshot.isVisible = false end
frm.setViewSnapshot = function(indexScene, indexObject, params, localtable) game.snapshot.isVisible = true end
