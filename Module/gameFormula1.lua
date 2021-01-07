frm = {}

frm.setVar = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  for i = 1, #game.vars + 1 do
    if game.vars[i] and game.vars[i].name == name then
      game.vars[i].value = value break
    elseif i == #game.vars + 1 then
      game.vars[i] = {name = name, value = value}
    end
  end
end

frm.hideShowText = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''

  for i = 1, #game.vars do
    if game.vars[i].name == name then
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
  local align = params[5][1] and params[5][1][1] or 'center'
  local alpha = calc(indexScene, indexObject, table.copy(params[6]), table.copy(localtable))

  if not font then
    if font ~= 'ubuntu.ttf' and font ~= 'sans.ttf' and font ~= 'system.ttf' then
      font = game.baseDir .. '/' .. gameName .. '/res .' .. font
    elseif font == 'system.ttf' then font = nil 
    else font = system.pathForFile(font, system.ResourcesDirectory) end
  end

  for i = 1, #game.vars do
    if game.vars[i].name == name then
      if game.vars[i].value[2] == 'log' then game.vars[i].value[1] = 'log' end
      if game.vars[i].value[2] == 'table' then game.vars[i].value[1] = 'table' end
      game.texts[i] = display.newText(game.vars[i].value[1], game.x, game.y, font, size[2] == 'num' and size[1] or 36)
      game.texts[i]:setFillColor(color[1]/255, color[2]/255, color[3]/255)
      game.texts[i].anchorX = align == 'centerAlign' and game.texts[i].anchorX or align == 'leftAlign' and 0 or align == 'rightAlign' and 1
      game.texts[i].alpha = alpha[2] == 'num' and alpha[1] / 100 or 1
      break
    end
  end
end

frm.updVar = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' then
    for i = 1, #game.vars + 1 do
      if game.vars[i] and game.vars[i].name == name and game.vars[i].value[2] == 'num' then
        game.vars[i].value[1] = game.vars[i].value[1] + value[1] break
      elseif i == #game.vars + 1 then
        game.vars[i] = {name = name, value = value}
      end
    end
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
