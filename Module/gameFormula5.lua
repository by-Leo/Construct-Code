frm.createEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.emitters[name] then game.emitters[name]:removeSelf() game.emitters[name] = nil end

  if value[2] == 'emitter' then
    game.emitters[name] = particles.newEmitter('Emitter/' .. value[1] .. '.json', nil, 'Emitter/')
    game.emitters[name].x, game.emitters[name].y = game.x, game.y
    game.emitters[name].data = {width = game.emitters[name].width, height = game.emitters[name].height}
    game.emitters[name].gravityx, game.emitters[name].gravityy = 0, 0
  end
end

frm.setPosEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local valueX = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local valueY = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if game.emitters[name] then
    if valueX[2] == 'num' then game.emitters[name].x = game.x + valueX[1] end
    if valueY[2] == 'num' then game.emitters[name].y = game.y - valueY[1] end
  end
end

frm.setSizeEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if game.emitters[name] and value[2] == 'num' then
    game.emitters[name].width = game.emitters[name].data.width * (value[1] / 100)
    game.emitters[name].height = game.emitters[name].data.height * (value[1] / 100)
  end
end

frm.setSpeedEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'num' and game.emitters[name] then game.emitters[name].speed = tonumber(value[1]) end
end

frm.setRotationEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'num' and game.emitters[name] then game.emitters[name].angle = tonumber(value[1]) end
end

frm.setGravityEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local valueX = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local valueY = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if game.emitters[name] then
    if valueX[2] == 'num' then game.emitters[name].gravityx = tonumber(valueX[1]) end
    if valueY[2] == 'num' then game.emitters[name].gravityy = -tonumber(valueY[1]) end
  end
end

frm.removeEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.emitters[name] then game.emitters[name]:removeSelf() game.emitters[name] = nil end
end

frm.removeAllEmitter = function(indexScene, indexObject, params, localtable)
  for i in pairs(game.emitters) do game.emitters[i]:removeSelf() game.emitters[i] = nil end
end

frm.setColorEmitter = function(name, type, color, value)
  game.emitters[name][type .. 'Color' .. color] = value
end

frm.setStartRedColorEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.emitters[name] and value[2] == 'num' then frm.setColorEmitter(name, 'start', 'Red', value[1]/100) end
end

frm.setStartGreenColorEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.emitters[name] and value[2] == 'num' then frm.setColorEmitter(name, 'start', 'Green', value[1]/100) end
end

frm.setStartBlueColorEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.emitters[name] and value[2] == 'num' then frm.setColorEmitter(name, 'start', 'Blue', value[1]/100) end
end

frm.setStartAlphaColorEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.emitters[name] and value[2] == 'num' then frm.setColorEmitter(name, 'start', 'Alpha', value[1]/100) end
end

frm.setFinishRedColorEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.emitters[name] and value[2] == 'num' then frm.setColorEmitter(name, 'finish', 'Red', value[1]/100) end
end

frm.setFinishGreenColorEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.emitters[name] and value[2] == 'num' then frm.setColorEmitter(name, 'finish', 'Green', value[1]/100) end
end

frm.setFinishBlueColorEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.emitters[name] and value[2] == 'num' then frm.setColorEmitter(name, 'finish', 'Blue', value[1]/100) end
end

frm.setFinishAlphaColorEmitter = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.emitters[name] and value[2] == 'num' then frm.setColorEmitter(name, 'finish', 'Alpha', value[1]/100) end
end

frm.playSound = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local loops = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if loops[2] ~= 'num' then loops = {'1', 'num'} end

  if value[2] == 'ressound' then if not game.sounds[value[1]] then
    game.sounds[value[1]] = {
      audio = audio.loadSound(gameName .. '/res .' .. value[1], system.DocumentsDirectory),
      channel = audio.findFreeChannel()
    } end audio.stop(game.sounds[value[1]].channel)
    audio.play(game.sounds[value[1]].audio, {channel=game.sounds[value[1]].channel, loops=tonumber(loops[1])})
  end
end

frm.pauseSound = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'ressound' and game.sounds[value[1]] then audio.pause(game.sounds[value[1]].channel) end
end

frm.resumeSound = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if value[2] == 'ressound' and game.sounds[value[1]] then audio.resume(game.sounds[value[1]].channel) end
end

frm.rewindSound = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local seconds = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'ressound' and seconds[2] == 'num' and game.sounds[value[1]] then
    audio.seek(seconds[1]*1000, {channel=game.sounds[value[1]].channel})
  end
end

frm.setVolumeSound = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local volume = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'ressound' and volume[2] == 'num' and game.sounds[value[1]] then
    audio.setVolume(volume[1]/100, {channel=game.sounds[value[1]].channel})
  end
end

frm.setTotalVolumeSound = function(indexScene, indexObject, params, localtable)
  local volume = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if volume[2] == 'num' then audio.setVolume(volume[1]/100) end
end

frm.createVideo = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.videos[name] then game.videos[name]:removeSelf() game.videos[name] = nil end

  if value[2] == 'resvideo' then
    game.videos[name] = native.newVideo(_x, _y, _w, _h)
    game.videos[name]:load(activity.programs.name .. '/res .' .. value[1], system.DocumentsDirectory)
    game.videos[name]:seek(1) game.videos[name].vis, game.videos[name].scene = true, indexScene
  end
end

frm.rewindVideo = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'num' and game.videos[name] then game.videos[name]:seek(tonumber(value[1])) end
end

frm.playVideo = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.videos[name] then game.videos[name]:play() end
end

frm.pauseVideo = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.videos[name] then game.videos[name]:pause() end
end

frm.viewVideo = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.videos[name] then game.videos[name].isVisible, game.videos[name].vis = true, true end
end

frm.hideVideo = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.videos[name] then game.videos[name].isVisible, game.videos[name].vis = false, false end
end

frm.muteVideo = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.videos[name] then game.videos[name].isMuted = true end
end

frm.unmuteVideo = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.videos[name] then game.videos[name].isMuted = false end
end

frm.setPosVideo = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local valueX = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local valueY = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  if valueX[2] == 'num' and game.videos[name] then game.videos[name].x = game.x + valueX[1] end
  if valueY[2] == 'num' and game.videos[name] then game.videos[name].y = game.y - valueY[1] end
end

frm.setWidthVideo = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if value[2] == 'num' and game.videos[name] then game.videos[name].width = tonumber(value[1]) end
end

frm._createTextField = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._createText(indexScene, indexObject, nestedParams, localtable, params, 'field')
end

frm._createTextBox = function(indexScene, indexObject, nestedParams, localtable, params)
  frm._createText(indexScene, indexObject, nestedParams, localtable, params, 'box')
end

frm.removeTextField = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.fields[value] then game.fields[value]:removeSelf() game.fields[value] = nil end
end

frm.setPosField = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value3 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  if game.fields[value] then if value2[2] == 'num' then game.fields[value].x = game.x + value2[1] end
  if value3[2] == 'num' then game.fields[value].y = game.y - value3[1] end end
end

frm.setSizeField = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value3 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  if game.fields[value] then if value2[2] == 'num' then game.fields[value].width = value2[1] end
  if value3[2] == 'num' then game.fields[value].height = value3[1] end end
end

frm.setTextField = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.fields[value] then if value2[1] then game.fields[value].text = value2[1] end end
end

frm.getTextField = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value2 = params[2][1] and params[2][1][1] or ''
  if game.fields[value] then game.vars[value2] = {game.fields[value].text, 'text'} end
end

frm.getOldTextField = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value2 = params[2][1] and params[2][1][1] or ''

  if game.fields[value] then
    if not game.fields[value].oldText then game.fields[value].oldText = '' end
    game.vars[value2] = {game.fields[value].oldText, 'text'}
  end
end

frm.setHideField = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.fields[value] then game.fields[value].isVisible, game.fields[value].vis = false, false end
end

frm.setViewField = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.fields[value] then game.fields[value].isVisible, game.fields[value].vis = true, true end
end

frm.setInputTypeField = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value2 = params[2][1] and utf8.sub(params[2][1][1], 10, utf8.len(params[2][1][1])) or ''
  if value2 == 'noemoji' then value2 = 'no-emoji' end
  if game.fields[value] then game.fields[value].inputType = value2 end
end

frm.setEditField = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value2 = params[2][1] and params[2][1][1] or ''
  if game.fields[value] then game.fields[value].isEditable = value2 ~= 'editfieldfalse' end
end

frm._inputText = function(indexScene, indexObject, nestedParams, localtable, params)
  local value = params[2][1] and params[2][1][1] or ''
  local value2 = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if not alertActive then input('Введите текст', value2[1], function() inputPermission(true) end,
  function(e) if e.input and e.text then
    game.vars[value] = {e.text, 'text'} end
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
  end) end
end

frm._createText = function(indexScene, indexObject, nestedParams, localtable, params, fieldORbox)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value3 = params[3][1] and json.decode(params[3][1][1]) or {255,255,255}
  local value4 = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  local value5 = params[5][1] and params[5][1][1] or ''
  local value6 = params[6][1] and params[6][1][1] or ''
  if value2[2] == 'log' then value2 = {'', 'text'} end

  if game.fields[value] then game.fields[value]:removeSelf() end
  if fieldORbox == 'box' then game.fields[value] = native.newTextBox(game.x, game.y + 10000, 500, 100)
  else game.fields[value] = native.newTextField(game.x, game.y + 10000, 500, 50) end
  timer.performWithDelay(1, function() if game.scene == indexScene then
    game.fields[value].y, game.fields[value].oldText, game.fields[value].vis = game.y, '', true
    game.fields[value].scene, game.fields[value].placeholder = indexScene, value2[1]
    game.fields[value].hasBackground, game.fields[value].isEditable = value5 ~= 'bgfieldfalse', true
    game.fields[value].font = native.newFont(value6, value4[2] == 'num' and value4[1] or 30)
    game.fields[value]:setTextColor(value3[1]/255, value3[2]/255, value3[3]/255)
    game.fields[value]:addEventListener('userInput', function(event) event.target.oldText = event.oldText
    end) onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
  end end)
end
