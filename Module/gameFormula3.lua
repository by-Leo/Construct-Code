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
    if gameData[s].name == name then
      if frm.groupCreateOverflowIndex == s and frm.groupCreateOverflowTime + 2 > system.getTimer() then
        stopProject(projectActivity) else
        frm.groupCreateOverflowIndex = s
        frm.groupCreateOverflowTime = system.getTimer()
        display.getCurrentStage():setFocus(nil)
        for o = 1, #game.objects[game.scene] do
          game.objects[game.scene][o].isVisible = false
          game.objects[game.scene][o].data.click = false
        end for t = 1, #game.texts do game.texts[t].isVisible = false end game.scene = s
        if not game.scenes[tostring(game.scene)] then create = true end
        for o = 1, #game.objects[game.scene] do game.objects[game.scene][o].isVisible = true end
        for t = 1, #game.texts do game.texts[t].isVisible = false end if create then onStart(s) end
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

frm.openUrl = function(indexScene, indexObject, params, localtable)
  system.openURL(params[1][1] and params[1][1][1] or '')
end

frm.closeApp = function(indexScene, indexObject, params, localtable)
  if game.sim then stopProject(projectActivity) else native.requestExit() end
end

frm.nested = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, nestedType)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2 = params[2] and calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable)) or {}
  local value3 = params[3] and calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable)) or {}

  if nestedParams and ((nestedType == 'if' and value[2] == 'log' and value[1] == 'true') or nestedType == 'ifElse'
  or (nestedType == 'for' and value[2] == 'num') or (nestedType == 'timer' and value[2] == 'num')
  or (nestedType == 'link' and value[2] == 'text')
  or nestedType == 'enterFrame' or (nestedType == 'useTag' and value[2] == 'tag')
  or (nestedType == 'get' and value2[2] == 'text')) then
    local nestedIndex, nestedEndIndex, nestedNames = 1, nestedStartIndex + 1, 'if ifElse for enterFrame useTag '
    for i = nestedStartIndex + 1, #nestedParams do nestedEndIndex = i
      if utf8.find(nestedNames, nestedParams[i].name .. ' ') then nestedIndex = nestedIndex + 1
      elseif utf8.sub(nestedParams[i].name, utf8.len(nestedParams[i].name)-2, utf8.len(nestedParams[i].name)) == 'End'
      then nestedIndex = nestedIndex - 1 if nestedIndex == 0 then break end end
    end for i = 1, nestedStartIndex do table.remove(nestedParams, 1) end
    if nestedType ~= 'if' and nestedType ~= 'ifElse' and nestedType ~= 'for'
    and nestedType ~= 'enterFrame' and nestedType ~= 'useTag' then nestedEndIndex = nestedEndIndex + 1 end
    for i = nestedEndIndex - nestedStartIndex, #nestedParams do table.remove(nestedParams, nestedEndIndex - nestedStartIndex) end
    if nestedType == 'if' then onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
    elseif nestedType == 'ifElse' then
      local count, nestedList = 0, 'if ifElse for enterFrame useTag '
      for i = 1, #nestedParams do
        if utf8.find(nestedList, nestedParams[i].name .. ' ') then count = count + 1
        elseif nestedParams[i].name == 'else' then
          if count == 0 then
            if value[2] == 'log' and value[1] == 'true' then
              for j = i, #nestedParams do table.remove(nestedParams, i) end
            else
              for j = 1, i do table.remove(nestedParams, 1) end
            end break
          end
        elseif utf8.find(nestedParams[i].name, 'End') then count = count - 1 end
      end onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
    elseif nestedType == 'for' then for i = 1, value[1] do onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end
  elseif nestedType == 'useTag' then
      for o = 1, #game.objects[indexScene] do
        if game.objects[indexScene][o].data.tag == value[1] then
          onParseBlock(indexScene, o, table.copy(nestedParams), table.copy(localtable))
        end
      end
    elseif nestedType == 'timer' then
      game.timers[#game.timers + 1] = timer.performWithDelay(value[1] * 1000, function()
        if indexScene == game.scene then
          onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
        end
      end, tonumber((value2[1] and value2[2] == 'num') and value2[1] or 1))
    elseif nestedType == 'get' then
      network.request(value2[1], 'GET', function(event)
        if not event.isError and event.phase == 'ended' and value[2] == 'variable' then
          for i = 1, #game.vars + 1 do
            if game.vars[i] and game.vars[i].name == value[1] then
              game.vars[i].value = {tostring(event.response), 'text'} if game.texts[i] then
              game.texts[i].text = tostring(game.vars[i].value[1]) end break
            elseif i == #game.vars + 1 then
              game.vars[i] = {name = value[1], value = {tostring(event.response), 'text'}}
            end
          end 
        end onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end)
    elseif nestedType == 'link' then
      local filename = 'texture' .. indexObject .. math.random(111, 999) .. '.png'
      network.download(value[1], 'GET', function(event)
        if indexScene == game.scene and not event.isError and event.phase == 'ended' then
          display.setDefault('magTextureFilter', game.objects[indexScene][indexObject].data.import)

          local downloadImage = display.newImage(filename, system.TemporaryDirectory)
          local width, height = downloadImage.width, downloadImage.height

          game.objects[indexScene][indexObject].fill = {
            type = 'image', baseDir = system.TemporaryDirectory, filename = filename
          } downloadImage:removeSelf()

          game.objects[indexScene][indexObject].data.width = width
          game.objects[indexScene][indexObject].data.height = height
        end onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end, {progress = true}, filename, system.TemporaryDirectory)
    elseif nestedType == 'enterFrame' then
      game.timers[#game.timers + 1] = timer.performWithDelay(1, function()
        if indexScene == game.scene then
          onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
        end
      end, 0)
    end
  end
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
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'link')
end

frm['setGet'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'get')
end
