frm.fun = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''

  for i = 1, #game.funs do
    if game.funs[i].name == name then
      game.funs[i].call = true
    end
  end
end

frm.funParams = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local nameTable = params[2][1] and params[2][1][1] or ''
  local localTable = {}

  for i = 1, #game.tables do
    if game.tables[i].name == nameTable then
      localTable = table.copy(game.tables[i].value)
    end
  end

  for i = 1, #game.funs do
    if game.funs[i].name == name then
      game.funs[i].localtable = table.copy(localTable)
      game.funs[i].call = true
    end
  end
end

frm.groupCreateOverflowIndex = 0
frm.groupCreateOverflowTime = 0
frm.group = function(indexScene, indexObject, params, localtable, create)
  local name = params[1][1] and params[1][1][1] or ''

  for s = 1, #gameData do
    if not alertActive and gameData[s].name == name then
      if frm.groupCreateOverflowIndex == s and frm.groupCreateOverflowTime + 2 > system.getTimer() then
        stopProject(projectActivity) else
        frm.groupCreateOverflowIndex = s
        frm.groupCreateOverflowTime = system.getTimer()
        display.getCurrentStage():setFocus(nil)

        for o = 1, #game.objects[game.scene] do
          game.objects[game.scene][o].isVisible = false
          game.objects[game.scene][o].data.click = false
          if game.objects[game.scene][o].data.physics.body ~= '' then frm.removeBody(game.scene, o) end
        end for f in pairs(game.fields) do game.fields[f].isVisible = false end
        for t in pairs(game.texts) do game.texts[t].isVisible = false end game.scene = s

        if not game.scenes[tostring(game.scene)] then create = true end
        for o = 1, #game.objects[game.scene] do
          game.objects[game.scene][o].isVisible = game.objects[game.scene][o].data.vis
          if game.objects[game.scene][o].data.physics.body ~= ''
          then frm.createBody(game.scene, o) end if create then
          game.objects[game.scene][o].width = game.objects[game.scene][o].data.width
          game.objects[game.scene][o].height = game.objects[game.scene][o].data.height
          game.objects[game.scene][o].x, game.objects[game.scene][o].y = game.x, game.y
          game.objects[game.scene][o].rotation, game.objects[game.scene][o].alpha = 0, 1 end
        end for f in pairs(game.fields) do game.fields[f].isVisible = game.fields[f].vis end
        for t in pairs(game.texts) do game.texts[t].isVisible = false end if create then onStart(s) end
      end break
    end
  end
end

frm.groupCreate = function(indexScene, indexObject, params, localtable)
  frm.group(indexScene, indexObject, params, localtable, true)
end

frm.groupView = function(indexScene, indexObject, params, localtable)
  frm.group(indexScene, indexObject, params, localtable, false)
end

frm.onMultitouch = function(indexScene, indexObject, params, localtable)
  system.activate('multitouch')
end

frm.offMultitouch = function(indexScene, indexObject, params, localtable)
  system.deactivate('multitouch')
end

frm.setColorBackground = function(indexScene, indexObject, params, localtable)
  local color = params[1][1] and json.decode(params[1][1][1]) or {255,255,255}
  display.setDefault('background', color[1]/255, color[2]/255, color[3]/255)
end

frm.setRGBColorBackground = function(indexScene, indexObject, params, localtable)
  local color = {255, 255, 255}
  local r = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local g = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local b = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  if r[2] == 'num' and g[2] == 'num' and b[2] == 'num' then color = {r[1], g[1], b[1]} end
  display.setDefault('background', color[1]/255, color[2]/255, color[3]/255)
end

frm.setHEXColorBackground = function(indexScene, indexObject, params, localtable)
  local color = {255, 255, 255}
  local colorhex = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if colorhex[2] ~= 'text' then colorhex = {'FFFFFF', 'text'} end
  if utf8.sub(colorhex[1], 1, 1) == '#' then colorhex[1] = utf8.sub(colorhex[1], 2, 7) end
  if utf8.len(colorhex[1]) ~= 6 then colorhex[1] = 'FFFFFF' end local errorHex = false
  local filterHex = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}
  for indexHex = 1, 6 do local symHex = utf8.upper(utf8.sub(colorhex[1], indexHex, indexHex))
  for i = 1, #filterHex do if symHex == filterHex[i] then break
  elseif i == #filterHex then errorHex = true end end
  end if errorHex then colorhex[1] = 'FFFFFF' end color = hex(colorhex[1])
  display.setDefault('background', color[1]/255, color[2]/255, color[3]/255)
end

frm.openUrl = function(indexScene, indexObject, params, localtable)
  system.openURL(params[1][1] and params[1][1][1] or '')
end

frm.closeApp = function(indexScene, indexObject, params, localtable)
  if game.sim then stopProject(projectActivity) else native.requestExit() end
end

frm._if = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'log' and value[1] == 'true' then onParseBlock(indexScene, indexObject,
  table.copy(nestedParams), table.copy(localtable)) end
end

frm._ifElse = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local count, nestedList = 0, 'if ifElse for enterFrame useTag '
  for i = 1, #nestedParams do
    if utf8.find(nestedList, nestedParams[i].name .. ' ') then count = count + 1
    elseif nestedParams[i].name == 'else' then
      if count == 0 then if value[2] == 'log' and value[1] == 'true' then
      for j = i, #nestedParams do table.remove(nestedParams, i) end else
      for j = 1, i do table.remove(nestedParams, 1) end end break end
    elseif utf8.find(nestedParams[i].name, 'End') then count = count - 1 end
  end onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
end

frm._for = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'num' then for i = 1, value[1] do onParseBlock(indexScene, indexObject,
  table.copy(nestedParams), table.copy(localtable)) end end
end

frm._useTag = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = params[1][1] and params[1][1][1] or ''
  if value[2] == 'tag' then for o = 1, #game.objects[indexScene] do
  if game.objects[indexScene][o].data.tag == value[1] then onParseBlock(indexScene, o,
  table.copy(nestedParams), table.copy(localtable)) end end end
end

frm._timer = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'num' then game.timers[#game.timers + 1] = timer.performWithDelay(value[1] * 1000,
  function() if indexScene == game.scene then onParseBlock(indexScene, indexObject,
  table.copy(nestedParams), table.copy(localtable)) end end,
  tonumber((value2[1] and value2[2] == 'num') and value2[1] or 1)) end
end

frm._get = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2 = params[2][1] and params[2][1][1] or ''
  if value[2] == 'text' then
    network.request(value2[1], 'GET', function(event)
      if not event.isError and event.phase == 'ended' and value[2] == 'variable' then
        for i = 1, #game.vars + 1 do
          if game.vars[i] and game.vars[i].name == value[1] then
            game.vars[i].value = {tostring(event.response), 'text'} if game.texts[i] then
            game.texts[i].text = tostring(game.vars[i].value[1]) end break
          elseif i == #game.vars + 1 then
            game.vars[i] = {name = value[1], value = {tostring(event.response), 'text'}}
          end
        end onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      elseif event.isError and value[2] == 'variable' then
        for i = 1, #game.vars + 1 do
          if game.vars[i] and game.vars[i].name == value[1] then
            game.vars[i].value = {'isError', 'text'} if game.texts[i] then
            game.texts[i].text = tostring(game.vars[i].value[1]) end break
          elseif i == #game.vars + 1 then
            game.vars[i] = {name = value[1], value = {'isError', 'text'}}
          end
        end onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end
    end)
  end
end

frm._post = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value3 = params[3][1] and params[3][1][1] or ''
  local value4 = params[4][1] and params[4][1][1] or ''
  local headers, body, _params = {}, value2[1], {}

  for i = 1, #game.tables do
    if game.tables[i].name == value4 then
      for j = 1, #game.tables[i].value do
        headers[game.tables[i].value[j].key] = game.tables[i].value[j].value[1]
      end break
    end
  end _params.headers, _params.body = headers, body

  if value[2] == 'text' then
    network.request(value[1], 'POST', function(event)
      if not event.isError and event.phase == 'ended' and value3 and event.response then
        for i = 1, #game.vars + 1 do
          if game.vars[i] and game.vars[i].name == value3 then
            game.vars[i].value = {tostring(event.response), 'text'} if game.texts[i] then
            game.texts[i].text = tostring(game.vars[i].value[1]) end break
          elseif i == #game.vars + 1 then
            game.vars[i] = {name = value3, value = {tostring(event.response), 'text'}}
          end
        end onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      elseif event.isError and value3 then
        for i = 1, #game.vars + 1 do
          if game.vars[i] and game.vars[i].name == value3 then
            game.vars[i].value = {'isError', 'text'} if game.texts[i] then
            game.texts[i].text = tostring(game.vars[i].value[1]) end break
          elseif i == #game.vars + 1 then
            game.vars[i] = {name = value3, value = {'isError', 'text'}}
          end
        end onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end
    end, _params)
  end
end

frm._setLinkTexture = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'text' then local filename = 'texture' .. indexObject .. math.random(111, 999) .. '.png'
    network.download(value[1], 'GET', function(event)
      if indexScene == game.scene and not event.isError and event.phase == 'ended' then
        display.setDefault('magTextureFilter', game.objects[indexScene][indexObject].data.import)

        local downloadImage = display.newImage(filename, system.TemporaryDirectory)
        local width, height = downloadImage.width, downloadImage.height

        game.objects[indexScene][indexObject].fill = {
          type = 'image', baseDir = system.TemporaryDirectory, filename = filename
        } downloadImage:removeSelf()

        game.objects[indexScene][indexObject].data.texture = '.' .. filename
        game.objects[indexScene][indexObject].data.width = width
        game.objects[indexScene][indexObject].data.height = height
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      elseif indexScene == game.scene and event.isError then
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end
    end, {progress = true}, filename, system.TemporaryDirectory)
  end
end

frm._enterFrame = function(indexScene, indexObject, nestedParams, localtable)
  game.timers[#game.timers + 1] = timer.performWithDelay(1, function() if indexScene == game.scene then
  onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end, 0)
end

frm._createTextField = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._createText(indexScene, indexObject, nestedParams, localtable, params, 'field')
end

frm._createTextBox = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._createText(indexScene, indexObject, nestedParams, localtable, params, 'box')
end

frm.removeTextField = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  if game.fields[value] then game.fields[value]:removeSelf() end
end

frm.setPosField = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value3 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  if game.fields[value] then if value2[2] == 'num' then game.fields[value].x = game.x + value2[1] end
  if value3[2] == 'num' then game.fields[value].y = game.y - value3[1] end end
end

frm.setSizeField = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value3 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  if game.fields[value] then if value2[2] == 'num' then game.fields[value].width = value2[1] end
  if value3[2] == 'num' then game.fields[value].height = value3[1] end end
end

frm.setTextField = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.fields[value] then if value2[1] then game.fields[value].text = value2[1] end end
end

frm.getTextField = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  local value2 = params[2][1] and params[2][1][1] or ''

  if game.fields[value] then
    for j = 1, #game.vars do
      if game.vars[j].name == value2 then
        game.vars[j].value = {game.fields[value].text, 'text'}
        if game.texts[j] then game.texts[j].text = tostring(game.vars[j].value[1]) end break
      end
    end
  end
end

frm.getOldTextField = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  local value2 = params[2][1] and params[2][1][1] or ''

  if game.fields[value] then if not game.fields[value].oldText then game.fields[value].oldText = '' end
    for j = 1, #game.vars do
      if game.vars[j].name == value2 then
        game.vars[j].value = {game.fields[value].oldText, 'text'}
        if game.texts[j] then game.texts[j].text = tostring(game.vars[j].value[1]) end break
      end
    end
  end
end

frm.setHideField = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  if game.fields[value] then game.fields[value].isVisible, game.fields[value].vis = false, false end
end

frm.setViewField = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  if game.fields[value] then game.fields[value].isVisible, game.fields[value].vis = true, true end
end

frm.setInputTypeField = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  local value2 = params[2][1] and utf8.sub(params[2][1][1], 10, utf8.len(params[2][1][1])) or ''
  if value2 == 'noemoji' then value2 = 'no-emoji' end
  if game.fields[value] then game.fields[value].inputType = value2 end
end

frm.setEditField = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  local value2 = params[2][1] and params[2][1][1] or ''
  if game.fields[value] then game.fields[value].isEditable = value2 ~= 'editfieldfalse' end
end

frm.closeKeyboard = function(indexScene, indexObject, params, localtable)
  native.setKeyboardFocus(nil)
end

frm._inputText = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = params[2][1] and params[2][1][1] or ''
  local value2 = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  input('Введите текст', value2[1], function() inputPermission(true) end, function(e)
    if e.input and e.text then
      for j = 1, #game.vars do
        if game.vars[j].name == value then
          game.vars[j].value = {e.text, 'text'}
          if game.texts[j] then game.texts[j].text = tostring(game.vars[j].value[1]) end break
        end
      end
    end onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
  end)
end

frm._createText = function(indexScene, indexObject, nestedParams, localtable, params, fieldORbox)
  local value = params[1][1] and params[1][1][1] or ''
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value3 = params[3][1] and json.decode(params[3][1][1]) or {255,255,255}
  local value4 = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  local value5 = params[5][1] and params[5][1][1] or ''
  local value6 = params[6][1] and params[6][1][1] or ''

  --[[ if value6 ~= 'ubuntu.ttf' and value6 ~= 'sans.ttf' and value6 ~= 'system.ttf' then
    local res_path = system.pathForFile('file.png', system.ResourcesDirectory)
    local font_path = game.baseDir .. '/' .. gameName .. '/res .' .. value6
    local res_count, font_path = 0, utf8.sub(font_path, 2, utf8.len(font_path))
    local res_path, res_count = utf8.gsub(res_path, '%/', '/')
    for i = 1, res_count do res_path = res_path .. '../'
    end res_path = res_path .. font_path value6 = res_path
  end --]] if value2[2] == 'log' then value2 = {'', 'text'} end

  if game.fields[value] then game.fields[value]:removeSelf() end
  if fieldORbox == 'box' then game.fields[value] = native.newTextBox(game.x, game.y + 10000, 500, 100)
  else game.fields[value] = native.newTextField(game.x, game.y + 10000, 500, 50) end
  timer.performWithDelay(1, function()
    game.fields[value].y, game.fields[value].oldText = game.y, ''
    game.fields[value].vis, game.fields[value].placeholder = true, value2[1]
    game.fields[value].hasBackground, game.fields[value].isEditable = value5 ~= 'bgfieldfalse', true
    game.fields[value].font = native.newFont(value6, value4[2] == 'num' and value4[1] or 30)
    game.fields[value]:setTextColor(value3[1]/255, value3[2]/255, value3[3]/255)
    game.fields[value]:addEventListener('userInput', function(event) event.target.oldText = event.oldText
    end) onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
  end)
end

frm.nested = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, nestedType)
  local nestedIndex, nestedEndIndex, nestedNames = 1, nestedStartIndex + 1, 'if ifElse for enterFrame useTag '
  for i = nestedStartIndex + 1, #nestedParams do nestedEndIndex = i
  if utf8.find(nestedNames, nestedParams[i].name .. ' ') then nestedIndex = nestedIndex + 1
  elseif utf8.sub(nestedParams[i].name, utf8.len(nestedParams[i].name)-2, utf8.len(nestedParams[i].name)) == 'End'
  then nestedIndex = nestedIndex - 1 if nestedIndex == 0 then break end end
  end for i = 1, nestedStartIndex do table.remove(nestedParams, 1) end
  if not utf8.find(nestedNames, nestedType .. ' ') then nestedEndIndex = nestedEndIndex + 1 end
  for i = nestedEndIndex - nestedStartIndex, #nestedParams do
  table.remove(nestedParams, nestedEndIndex - nestedStartIndex) end
  pcall(function() frm['_' .. nestedType](indexScene, indexObject,
  table.copy(nestedParams), table.copy(localtable), table.copy(params)) end)
end

frm['if'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'if')
end

frm['ifElse'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'ifElse')
end

frm['for'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'for')
end

frm['timer'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'timer')
end

frm['enterFrame'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'enterFrame')
end

frm['useTag'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'useTag')
end

frm['setLinkTexture'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setLinkTexture')
end

frm['setGet'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'get')
end

frm['setPost'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'post')
end

frm['createTextField'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'createTextField')
end

frm['createTextBox'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'createTextBox')
end

frm['inputText'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'inputText')
end
