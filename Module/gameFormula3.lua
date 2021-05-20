frm.fun = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''

  for i = 1, #game.funs do
    if game.funs[i].name == name then
      game.funs[i].func(game.funs[i])
    end
  end
end

frm.funParams = function(indexScene, indexObject, params, localtable)
  local name = params[1][1] and params[1][1][1] or ''
  local nameTable = params[2][1] and params[2][1][1] or ''
  local localTable = {}

  for i = 1, #game.tables do
    if game.tables[i].name == nameTable then
      localTable = table.copy({game.tables[i].val})
    end
  end

  for i = 1, #game.funs do
    if game.funs[i].name == name then
      game.funs[i].localtable = table.copy(localTable)
      game.funs[i].func(game.funs[i])
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

        for o = 1, #game.objects[game.scene] do pcall(function()
          game.objects[game.scene][o].isVisible = false
          game.objects[game.scene][o].data.click = false
          if game.objects[game.scene][o].data.physics.body ~= '' then frm.removeBody(game.scene, o) end
        end) end for o in pairs(game.shapes) do pcall(function() if game.shapes[o].data.scene == game.scene
          then game.shapes[o].isVisible, game.shapes[o].data.click = false, false
          if game.shapes[o].data.physics.body ~= '' then frm.removeBodyShape(o) end end
        end) end for f in pairs(game.fields) do pcall(function()
        if game.fields[f].scene == game.scene then game.fields[f].isVisible = false end end)
        end for t in pairs(game.texts) do pcall(function()
        if game.texts[t].scene == game.scene then game.texts[t].isVisible = false end end)
        end for t in pairs(game.videos) do pcall(function()
        if game.videos[t].scene == game.scene then game.videos[t].isVisible = false end end)
        end for i = 1, #game.timers do pcall(function()
        if game.timers[i].scene == game.scene then timer.pause(game.timers[i]) end end)
        end for t in pairs(game.emitters) do pcall(function()
        game.emitters[t]:removeSelf() game.emitters[t] = nil end) end game.scene = s

        if not game.scenes[tostring(game.scene)] then create = true end
        for o = 1, #game.objects[game.scene] do pcall(function()
          game.objects[game.scene][o].isVisible = game.objects[game.scene][o].data.vis
          if game.objects[game.scene][o].data.physics.body ~= ''
          then frm.createBody(game.scene, o) end if create then
          game.objects[game.scene][o].width = game.objects[game.scene][o].data.width
          game.objects[game.scene][o].height = game.objects[game.scene][o].data.height
          game.objects[game.scene][o].x, game.objects[game.scene][o].y = game.x, game.y
          game.objects[game.scene][o].rotation, game.objects[game.scene][o].alpha = 0, 1 end
        end) end for o in pairs(game.shapes) do pcall(function() if game.shapes[o].data.scene == game.scene
          then game.shapes[o].isVisible = game.shapes[o].data.vis
          if game.shapes[o].data.physics.body ~= '' and not create then frm.createBodyShape(o)
          end if create then game.shapes[o]:removeSelf() end end
        end) end for f in pairs(game.fields) do pcall(function()
          if game.fields[f].scene == game.scene and create then game.fields[f]:removeSelf() game.fields[f] = nil
          elseif game.fields[f].scene == game.scene then game.fields[f].isVisible = game.fields[f].vis
        end end) end for f in pairs(game.texts) do pcall(function()
          if game.texts[f].scene == game.scene and create then game.texts[f]:removeSelf() game.texts[f] = nil
          elseif game.texts[f].scene == game.scene then game.texts[f].isVisible = game.texts[f].vis
        end end) end for f in pairs(game.videos) do pcall(function()
          if game.videos[f].scene == game.scene and create then game.videos[f]:removeSelf() game.videos[f] = nil
          elseif game.videos[f].scene == game.scene then game.videos[f].isVisible = game.videos[f].vis
        end end) end if create then
      for i = 1, #game.timers do pcall(function() if game.timers[i].scene == game.scene
        then timer.cancel(game.timers[i]) end end) end onStart(s)
      else for i = 1, #game.timers do pcall(function() if game.timers[i].scene == game.scene
        then timer.resume(game.timers[i]) end end)
      end end end break
    end
  end
end

frm.groupCreate = function(indexScene, indexObject, params, localtable)
  frm.group(indexScene, indexObject, params, localtable, true)
end

frm.groupView = function(indexScene, indexObject, params, localtable)
  frm.group(indexScene, indexObject, params, localtable, false)
end

frm.file = function(path, mode, value, path2)
  if utf8.find(path, '..', 1, true) or utf8.find(path2, '..', 1, true) then return {'false', 'log'} end
  local file, data = io.open(path, mode), {'false', 'log'} if file then if mode == 'r'
  then data = {file:read('*a'), 'text'} io.close(file) elseif mode == 'w' or mode == 'a'
  then file:write(value) io.close(file) elseif mode == 'mv' or mode == 'cp'
  then os.execute('mv -r"' .. path .. '" ' .. '"' .. path2 .. '"') elseif mode == 'rm'
  then os.execute('rm -f "' .. path .. '"') end end return {data[1], data[2]}
end

frm.fileRead = function(indexScene, indexObject, params, localtable)
  local name, data = params[1][1] and params[1][1][1] or '', {'false', 'log'}
  local path = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local catalog = params[3][1] and params[3][1][1] or 'Documents'

  if path[2] == 'text' then
    if catalog == 'External' then
      native.showPopup('requestAppPermission', {
        appPermission = 'Storage', urgency = 'Critical', listener = function(event) end
      }) data = frm.file('/sdcard/' .. path[1], 'r')
    elseif catalog == 'Documents' then
      lfs.mkdir(system.pathForFile('', system.DocumentsDirectory) .. '/Documents')
      data = frm.file(system.pathForFile('', system.DocumentsDirectory) .. '/Documents/' .. path[1], 'r')
    elseif catalog == 'Temporary' then
      data = frm.file(system.pathForFile('', system.TemporaryDirectory) .. '/' .. path[1], 'r')
    end game.vars[name] = {data[1], data[2]}
  end
end

frm.fileWrite = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local path = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local catalog, data = params[3][1] and params[3][1][1] or 'Documents', {'false', 'log'}

  if path[2] == 'text' then
    if catalog == 'External' then
      native.showPopup('requestAppPermission', {
        appPermission = 'Storage', urgency = 'Critical', listener = function(event) end
      }) frm.file('/sdcard/' .. path[1], 'w', value[1])
    elseif catalog == 'Documents' then
      lfs.mkdir(system.pathForFile('', system.DocumentsDirectory) .. '/Documents')
      frm.file(system.pathForFile('', system.DocumentsDirectory) .. '/Documents/' .. path[1], 'w', value[1])
    elseif catalog == 'Temporary' then
      frm.file(system.pathForFile('', system.TemporaryDirectory) .. '/' .. path[1], 'w', value[1])
    end
  end
end

frm.fileUpdate = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local path = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local catalog, data = params[3][1] and params[3][1][1] or 'Documents', {'false', 'log'}

  if path[2] == 'text' then
    if catalog == 'External' then
      native.showPopup('requestAppPermission', {
        appPermission = 'Storage', urgency = 'Critical', listener = function(event) end
      }) frm.file('/sdcard/' .. path[1], 'a', value[1])
    elseif catalog == 'Documents' then
      lfs.mkdir(system.pathForFile('', system.DocumentsDirectory) .. '/Documents')
      frm.file(system.pathForFile('', system.DocumentsDirectory) .. '/Documents/' .. path[1], 'a', value[1])
    elseif catalog == 'Temporary' then
      frm.file(system.pathForFile('', system.TemporaryDirectory) .. '/' .. path[1], 'a', value[1])
    end
  end
end

frm.fileOperation = function(indexScene, indexObject, params, localtable, mode)
  local path = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local catalog, data = params[2][1] and params[2][1][1] or 'Documents', {'false', 'log'}
  local path2 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local catalog2 = params[4][1] and params[4][1][1] or 'Documents'

  if path[2] == 'text' and path2[2] == 'text' then
    if catalog == 'External' or catalog2 == 'External' then native.showPopup('requestAppPermission',
    {appPermission = 'Storage', urgency = 'Critical', listener = function(event) end})
    end if catalog == 'Documents' then
      lfs.mkdir(system.pathForFile('', system.DocumentsDirectory) .. '/Documents')
      path = system.pathForFile('', system.DocumentsDirectory) .. '/Documents/' .. path[1]
    elseif catalog == 'Temporary' then path = system.pathForFile('', system.TemporaryDirectory) .. '/' .. path[1]
    elseif catalog == 'External' then path = '/sdcard/' .. path[1] end
    if catalog2 == 'Documents' then
      lfs.mkdir(system.pathForFile('', system.DocumentsDirectory) .. '/Documents')
      path2 = system.pathForFile('', system.DocumentsDirectory) .. '/Documents/' .. path2[1]
    elseif catalog2 == 'Temporary' then path2 = system.pathForFile('', system.TemporaryDirectory) .. '/' .. path2[1]
    elseif catalog2 == 'External' then path2 = '/sdcard/' .. path2[1] end
    frm.file(path, mode, nil, path2)
  end
end

frm.fileMove = function(indexScene, indexObject, params, localtable)
  frm.fileOperation(indexScene, indexObject, params, localtable, 'mv')
end

frm.fileCopy = function(indexScene, indexObject, params, localtable)
  frm.fileOperation(indexScene, indexObject, params, localtable, 'cp')
end

frm.fileRemove = function(indexScene, indexObject, params, localtable)
  local path = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local catalog, data = params[2][1] and params[2][1][1] or 'Documents', {'false', 'log'}

  if path[2] == 'text' then
    if catalog == 'Documents' then
      lfs.mkdir(system.pathForFile('', system.DocumentsDirectory) .. '/Documents')
      path = system.pathForFile('', system.DocumentsDirectory) .. '/Documents/' .. path[1]
    elseif catalog == 'Temporary' then path = system.pathForFile('', system.TemporaryDirectory) .. '/' .. path[1]
    elseif catalog == 'External' then native.showPopup('requestAppPermission',
    {appPermission = 'Storage', urgency = 'Critical', listener = function(event) end})
    path = '/sdcard/' .. path[1] end frm.file(path, 'rm -f')
  end
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

frm.setAccelerometer = function(indexScene, indexObject, params, localtable)
  Runtime:removeEventListener('accelerometer', game.accelerometer)
  Runtime:addEventListener('accelerometer', game.accelerometer)
end

frm.setAccelerometerInterval = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'num' then system.setAccelerometerInterval(tonumber(value[1])) end
end

frm.setNotifications = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local second = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local sound = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if sound[2] == 'ressound' then
    local path = game.baseDir .. '/' .. gameName .. '/res .' .. sound[1]
    os.execute('cp "' .. path .. '" "' .. system.pathForFile('sound.mp3', system.ResourceDirectory) .. '"')
  end if second[2] == 'num' then
    notifications.scheduleNotification(tonumber(second[1]), {alert = value[1], sound = 'sound.mp3'})
  end
end

frm.setPortraitOrientation = function(indexScene, indexObject, params, localtable)
  if game.scene ~= 0 then
    orientation.lock 'portrait'
    game.x, game.y = game.x, game.y
    game.w, game.h = game.w, game.h
    game.aW, game.aH = game.aW, game.aH
    game.aX, game.aY = game.aX, game.aY
    game.touch_x, game.touch_y = game.touch_x, game.touch_y
    game.debugbackground.x, game.debugbackground.y = game.x, game.y
    game.debugbackground.width, game.debugbackground.height = _aW, _aH + _tH + _bH
    game.borderView.x, game.borderView.y = _x, _y
    game.borderView.width, game.borderView.height = _w-4, _h
    game.borderY.x, game.borderY.text = _x, _y
    game.borderX.x, game.borderX.y, game.borderX.text = _x, _w-50, _x
  end
end

frm.setLandscapeOrientation = function(indexScene, indexObject, params, localtable)
  if game.scene ~= 0 then
    orientation.lock 'landscape'
    game.x, game.y = game.y, game.x
    game.w, game.h = game.h, game.w
    game.aW, game.aH = game.aH, game.aW
    game.aX, game.aY = game.aY, game.aX
    game.touch_x, game.touch_y = game.touch_y, game.touch_x
    game.debugbackground.x, game.debugbackground.y = game.x, game.y
    game.debugbackground.width, game.debugbackground.height = _aH + _tH + _bH, _aW
    game.borderView.x, game.borderView.y = _y, _x
    game.borderView.width, game.borderView.height = _h, _w-4
    game.borderY.x, game.borderY.text = _y, _x
    game.borderX.x, game.borderX.y, game.borderX.text = _h-50, _x, _y
  end
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
  local count, nestedList = 0, 'if ifElse for while forI forT enterFrame useTag useCopy fileLine timer '
  for i = 1, #nestedParams do
    if utf8.find(nestedList, nestedParams[i].name .. ' ') then count = count + 1
    elseif nestedParams[i].name == 'else' then
      if count == 0 then if value[2] == 'log' and value[1] == 'true' then
      for j = i, #nestedParams do table.remove(nestedParams, i) end else
      for j = 1, i do table.remove(nestedParams, 1) end end break end
    elseif utf8.find(nestedParams[i].name, 'End') then count = count - 1 end
  end onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
end

frm._while = function(indexScene, indexObject, nestedParams, localtable, params)
  local value while true do value = calc(indexScene, indexObject,
  table.copy(params[1]), table.copy(localtable)) if value[2] == 'log'
  and value[1] == 'true' then onParseBlock(indexScene, indexObject,
  table.copy(nestedParams), table.copy(localtable)) else break end end
end

frm._for = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'num' then for i = 1, value[1] do onParseBlock(indexScene, indexObject,
  table.copy(nestedParams), table.copy(localtable)) end end
end

frm._forI = function(indexScene, indexObject, nestedParams, localtable, params)
  local name, index, value = params[1][1] and params[1][1][1] or '', 0, {'0', 'num'}
  local value1 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local value3 = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))

  if name ~= '' then value = game.vars[name]
    if value3[2] ~= 'num' then value3 = {'1', 'num'} end
    if value1[2] == 'num' and value2[2] == 'num' and value3[2] == 'num' then
      for i = tonumber(value1[1]), tonumber(value2[1]), tonumber(value3[1]) do
        game.vars[name] = {tostring(i), 'num'}
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end game.vars[name] = value
    end
  end
end

frm._fileLine = function(indexScene, indexObject, nestedParams, localtable, params)
  local name, index, value = params[1][1] and params[1][1][1] or '', 0, {'', 'text'}
  local path = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local catalog = params[3][1] and params[3][1][1] or 'Documents'

  if path[2] == 'text' then
    if catalog == 'Documents' then path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. path[1]
    elseif catalog == 'Temporary' then path = system.pathForFile('', system.TemporaryDirectory) .. '/' .. path[1]
    elseif catalog == 'External' then native.showPopup('requestAppPermission', {appPermission = 'Storage',
    urgency = 'Critical', listener = function(event) end}) path = '/sdcard/' .. path[1] end
  end

  if name ~= '' then value = game.vars[name]
    local file = io.open(path, 'r') if file then for line in file:lines() do
      game.vars[name] = {tostring(line), 'text'}
      onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
    end game.vars[name] = value io.close(file) end
  end
end

frm._forT = function(indexScene, indexObject, nestedParams, localtable, params)
  local name, index1, value1, index2, value2 = params[1][1] and params[1][1][1] or '', 0, {'0', 'num'}, 0, {'0', 'key'}
  local name1, name2, create1 = params[2][1] and params[2][1][1] or '', params[3][1] and params[3][1][1] or '', false

  if name ~= '' and name1 ~= '' and name2 ~= '' then
    value1, value2 = game.vars[name1], game.vars[name2]
    if game.vars[name1] then create1 = true end
    if game.vars[name2] then create2 = true end

    for i = 1, #game.tables do
      if game.tables[i].name == name then for k, v in pairs(json.decode(game.tables[i].val)) do
        game.vars[name1], game.vars[name2] = {v[1], v[2]}, {k, 'text'}
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end break end
    end game.vars[name1], game.vars[name2] = value1, value2
  end
end

frm._useTag = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = params[1][1] and params[1][1][1] or ''
  for o = 1, #game.objects[indexScene] do if game.objects[indexScene][o].data.tag == value
  then onParseBlock(indexScene, o, table.copy(nestedParams), table.copy(localtable)) end end
end

frm._timer = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'num' then game.timers[#game.timers + 1] = timer.performWithDelay(value[1] * 1000,
  function() if indexScene == game.scene then onParseBlock(indexScene, indexObject,
  table.copy(nestedParams), table.copy(localtable)) end end,
  tonumber((value2[1] and value2[2] == 'num') and value2[1] or 1))
  game.timers[#game.timers].scene = indexScene end
end

frm._setRequest = function(indexScene, indexObject, nestedParams, localtable, params, req)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value3 = params[3][1] and params[3][1][1] or ''
  local value4 = params[4][1] and params[4][1][1] or ''
  local body, _params, headers = value2[1], {}, {['User-Agent']
  = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36'}

  for i = 1, #game.tables do
    if game.tables[i].name == value4 then
      for j = 1, #game.tables[i].value do
        headers[game.tables[i].value[j].key] = game.tables[i].value[j].value[1]
      end break
    end
  end _params.headers, _params.body = headers, body

  if value[2] == 'text' then
    network.request(value[1], req, function(event)
      if not event.isError and event.phase == 'ended' and value3 ~= '' and event.response and indexScene == game.scene then
        game.vars[value3] = {tostring(event.response), 'text'}
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      elseif event.isError and event.phase == 'ended' and value3 and indexScene == game.scene then
        game.vars[value3] = {'isError', 'text'}
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      elseif value2 == '' and event.phase == 'ended' and indexScene == game.scene then
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end
    end, _params)
  end
end

frm._setRequest2 = function(indexScene, indexObject, nestedParams, localtable, params, req)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2 = params[2][1] and params[2][1][1] or ''
  local _headers = {['User-Agent']
  = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36'}

  if value[2] == 'text' then
    network.request(value[1], req, function(event)
      if not event.isError and event.phase == 'ended' and value2 ~= '' and indexScene == game.scene then
        game.vars[value2] = {tostring(event.response), 'text'}
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      elseif event.isError and event.phase == 'ended' and value2 ~= '' and indexScene == game.scene then
        game.vars[value2] = {'isError', 'text'}
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      elseif value2 == '' and event.phase == 'ended' and indexScene == game.scene then
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end
    end, {headers=_headers})
  end
end

frm._setPost = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._setRequest(indexScene, indexObject, nestedParams, localtable, params, 'POST')
end

frm._setPut = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._setRequest(indexScene, indexObject, nestedParams, localtable, params, 'PUT')
end

frm._setPatch = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._setRequest(indexScene, indexObject, nestedParams, localtable, params, 'PATCH')
end

frm._setGet = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._setRequest2(indexScene, indexObject, nestedParams, localtable, params, 'GET')
end

frm._setDelete = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._setRequest2(indexScene, indexObject, nestedParams, localtable, params, 'DELETE')
end

frm.setToken = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'text' then game.token = value[1] end
end

frm._setRequestFirebase = function(indexScene, indexObject, nestedParams, localtable, params, req)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2, link = params[2][1] and params[2][1][1] or '', 'https://' .. game.token .. '.firebaseio.com/'
  local value3 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  if utf8.sub(value3[1], 1, 1) ~= '{' then value3[1] = '"' .. value3[1] .. '"' end
  if value[2] ~= 'text' then value = {'', 'text'} end

  network.request(link .. value[1] .. '.json', req, function(event)
    if event.response and event.response == 'null' then event.response = '' end
    if event.response and utf8.sub(event.response, 1, 1) == '"'
    then event.response = utf8.sub(event.response, 2, utf8.len(event.response) - 1) end
    if not event.isError and event.phase == 'ended' and value2 ~= '' and event.response and indexScene == game.scene then
      game.vars[value2] = {tostring(event.response), 'text'}
      onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
    elseif event.isError and event.phase == 'ended' and value2 ~= '' and indexScene == game.scene then
      game.vars[value2] = {'isError', 'text'}
      onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
    elseif value2 == '' and event.phase == 'ended' and indexScene == game.scene then
      onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
    end
  end, {body=value3[1]})
end

frm._setRequestFirebase2 = function(indexScene, indexObject, nestedParams, localtable, params, req)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2, link = params[2][1] and params[2][1][1] or '', 'https://' .. game.token .. '.firebaseio.com/'
  if value[2] ~= 'text' then value = {'', 'text'} end

  network.request(link .. value[1] .. '.json', req, function(event)
    if event.response and event.response == 'null' then event.response = '' end
    if event.response and utf8.sub(event.response, 1, 1) == '"'
    then event.response = utf8.sub(event.response, 2, utf8.len(event.response) - 1) end
    if not event.isError and event.phase == 'ended' and value2 ~= '' and event.response and indexScene == game.scene then
      game.vars[value2] = {tostring(event.response), 'text'}
      onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
    elseif event.isError and event.phase == 'ended' and value2 ~= '' and indexScene == game.scene then
      game.vars[value2] = {'isError', 'text'}
      onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
    elseif value2 == '' and event.phase == 'ended' and indexScene == game.scene then
      onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
    end
  end)
end

frm._putFirebase = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._setRequestFirebase(indexScene, indexObject, nestedParams, localtable, params, 'PUT')
end

frm._patchFirebase = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._setRequestFirebase(indexScene, indexObject, nestedParams, localtable, params, 'PATCH')
end

frm._getFirebase = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._setRequestFirebase2(indexScene, indexObject, nestedParams, localtable, params, 'GET')
end

frm._deleteFirebase = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._setRequestFirebase2(indexScene, indexObject, nestedParams, localtable, params, 'DELETE')
end

frm._setLinkTexture = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'text' then local filename = 'texture' .. indexObject .. math.random(111111111, 999999999) .. '.png'
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

frm._createLinkVideo = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.videos[name] then game.videos[name]:removeSelf() game.videos[name] = nil end

  if value[2] == 'text' then local filename = 'video' .. indexObject .. math.random(111111111, 999999999) .. '.mp4'
    network.download(value[1], 'GET', function(event)
      if indexScene == game.scene and not event.isError and event.phase == 'ended' then
        game.videos[name] = native.newVideo(_x, _y, _w, _h)
        game.videos[name]:load(filename, system.TemporaryDirectory)
        game.videos[name]:seek(1)
        timer.performWithDelay(1, function() if game.scene == 0 then game.videos[name]:removeSelf() end end)
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      elseif indexScene == game.scene and event.isError then
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end
    end, {progress = true}, filename, system.TemporaryDirectory)
  end
end

frm._enterFrame = function(indexScene, indexObject, nestedParams, localtable)
  onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
  game.timers[#game.timers + 1] = timer.performWithDelay(1, function() if indexScene == game.scene then
  onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end, 0)
  game.timers[#game.timers].scene = indexScene
end

frm.nested = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, nestedType)
  local nestedIndex, nestedEndIndex = 1, nestedStartIndex + 1
  local nestedNames = 'if ifElse for while forI forT enterFrame useTag useCopy fileLine timer '
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

frm['while'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'while')
end

frm['for'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'for')
end

frm['forI'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'forI')
end

frm['forT'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'forT')
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

frm['useCopy'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'useCopy')
end

frm['fileLine'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'fileLine')
end

frm['createLinkVideo'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'createLinkVideo')
end

frm['setLinkTexture'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setLinkTexture')
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

frm['setTransitionPos'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPos')
end

frm['setTransitionPosX'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPosX')
end

frm['setTransitionPosY'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPosY')
end

frm['setTransitionWidth'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionWidth')
end

frm['setTransitionHeight'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionHeight')
end

frm['setTransitionSize'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionSize')
end

frm['setTransitionRotation'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionRotation')
end

frm['setTransitionAlpha'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionAlpha')
end

frm['setTransitionPosAngle'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPosAngle')
end

frm['setTransitionPosShape'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPosShape')
end

frm['setTransitionPosXShape'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPosXShape')
end

frm['setTransitionPosYShape'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPosYShape')
end

frm['setTransitionWidthShape'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionWidthShape')
end

frm['setTransitionHeightShape'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionHeightShape')
end

frm['setTransitionSizeShape'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionSizeShape')
end

frm['setTransitionRotationShape'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionRotationShape')
end

frm['setTransitionAlphaShape'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionAlphaShape')
end

frm['setTransitionPosAngleShape'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPosAngleShape')
end

frm['setTransitionPosTag'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPosTag')
end

frm['setTransitionPosXTag'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPosXTag')
end

frm['setTransitionPosYTag'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionPosYTag')
end

frm['setTransitionAlphaTag'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setTransitionAlphaTag')
end

frm['setGet'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setGet')
end

frm['setPost'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setPost')
end

frm['setPut'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setPut')
end

frm['setPatch'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setPatch')
end

frm['setDelete'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'setDelete')
end

frm['putFirebase'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'putFirebase')
end

frm['patchFirebase'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'patchFirebase')
end

frm['getFirebase'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'getFirebase')
end

frm['deleteFirebase'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'deleteFirebase')
end

frm.closeKeyboard = function(indexScene, indexObject, params, localtable) native.setKeyboardFocus(nil) end
frm.stopSound = function(indexScene, indexObject, params, localtable) audio.stop() end
