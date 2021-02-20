frm.setPos = function(indexScene, indexObject, params, localtable)
  local value1 = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  game.objects[indexScene][indexObject].x = value1[2] == 'num' and game.x + value1[1] or game.x
  game.objects[indexScene][indexObject].y = value2[2] == 'num' and game.y - value2[1] or game.y
end

frm.setX = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].x = game.x + value[1]
  end
end

frm.setY = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].y = game.y - value[1]
  end
end

frm.setWidth = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].width = value[1]
  end
end

frm.setHeight = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].height = value[1]
  end
end

frm.setSize = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].width = game.objects[indexScene][indexObject].data.width * (value[1] / 100)
    game.objects[indexScene][indexObject].height = game.objects[indexScene][indexObject].data.height * (value[1] / 100)
  end
end

frm.updX = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].x = game.objects[indexScene][indexObject].x + value[1]
  end
end

frm.updY = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].y = game.objects[indexScene][indexObject].y - value[1]
  end
end

frm.updWidth = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].width = game.objects[indexScene][indexObject].width + value[1]
  end
end

frm.updHeight = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].height = game.objects[indexScene][indexObject].height + value[1]
  end
end

frm.updSize = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].width = game.objects[indexScene][indexObject].width
    + game.objects[indexScene][indexObject].data.width * (value[1] / 100)
    game.objects[indexScene][indexObject].height = game.objects[indexScene][indexObject].height
    + game.objects[indexScene][indexObject].data.height * (value[1] / 100)
  end
end

frm.setHide = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].isVisible = false
  game.objects[indexScene][indexObject].data.vis = false
end

frm.setView = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].isVisible = true
  game.objects[indexScene][indexObject].data.vis = true
end

frm.setRotation = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].rotation = value[1]
  end
end

frm.setAlpha = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].alpha = value[1] / 100
  end
end

frm.updRotation = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].rotation = game.objects[indexScene][indexObject].rotation + value[1]
  end
end

frm.updAlpha = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].alpha = game.objects[indexScene][indexObject].alpha + value[1] / 100
  end
end

frm.setCopy = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  local target = game.objects[indexScene][indexObject]

  if value ~= '.self' and not game.objects[indexScene][indexObject].data.copy then
  for o = 1, #game.objects[indexScene] do if game.objects[indexScene][o].name == value
  then indexObject = o target = game.objects[indexScene][indexObject] end end end

  local res = target.data.texture and target.data.path .. target.data.texture or nil
  local indexCopy = #game.objects[indexScene] + 1 pcall(function()
  if res and not game.objects[indexScene][indexObject].data.copy
  then game.objects[indexScene][indexCopy] = display.newImage(res, game.basedir) end end)

  if game.objects[indexScene][indexCopy] and not game.objects[indexScene][indexObject].data.copy then
    gameData[indexScene].objects[indexCopy] = {
      name = gameData[indexScene].objects[indexObject].name,
      textures = gameData[indexScene].objects[indexObject].textures,
      import = gameData[indexScene].objects[indexObject].import,
      events = gameData[indexScene].objects[indexObject].events
    } game.objects[indexScene][indexObject].data.copies[#target.data.copies + 1] = indexCopy
    game.objects[indexScene][indexCopy].x, game.objects[indexScene][indexCopy].y  = target.x, target.y
    game.objects[indexScene][indexCopy].name, game.objects[indexScene][indexCopy].z  = target.name, target.z
    game.objects[indexScene][indexCopy].width, game.objects[indexScene][indexCopy].height = target.width, target.height
    game.objects[indexScene][indexCopy].xScale, game.objects[indexScene][indexCopy].yScale = target.xScale, target.yScale
    game.objects[indexScene][indexCopy].data = {
      obj_id = target.data.index, index = indexCopy, click = false, import = target.data.import,
      width = target.data.width, height = target.data.height, tag = target.data.tag,
      vis = target.data.vis, path = target.data.path, scene = indexScene,
      texture = target.data.textures[1], textures = target.data.textures, physics = {
        density = target.data.physics.density, bounce = target.data.physics.bounce,
        friction = target.data.physics.friction, gravityScale = target.data.physics.gravityScale,
        hitbox = {target.data.physics.hitbox[1], target.data.physics.hitbox[2]},
        fixedRotation = target.data.physics.fixedRotation, body = target.data.physics.body,
        sensor = target.data.physics.sensor, bullet = target.data.physics.bullet
      }, copy = true
    } game.objects[indexScene][indexCopy]:addEventListener('touch', function(e)
      if e.target.data.scene == game.scene then
        if e.phase == 'began' then
          display.getCurrentStage():setFocus(e.target, e.id)
          e.target.data.click = true
          onClick(e.target.data.scene, e.target.data.index, e)
        elseif e.phase == 'moved' then
          if e.target.data.click then
            onClickMove(e.target.data.scene, e.target.data.index, e)
          end
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
          display.getCurrentStage():setFocus(e.target, nil)
          if e.target.data.click then
            e.target.data.click = false
            onClickEnd(e.target.data.scene, e.target.data.index, e)
          end
        end
      end return true
    end) game.objects[indexScene][indexCopy].isVisible = target.data.vis
    if target.data.physics.body ~= '' then frm.createBody(indexScene, indexCopy) end
  end
end

frm.removeCopy = function(indexScene, indexObject, params, localtable)
  local value = params[1][1] and params[1][1][1] or ''
  local indexCopy, countCopy = indexObject

  if value ~= 'allCopy' then
    if not game.objects[indexScene][indexObject].data.copy then
      countCopy = #game.objects[indexScene][indexObject].data.copies
      indexCopy = game.objects[indexScene][indexObject].data.copies[countCopy]
    elseif value == 'lastCopy' then
      indexObject = game.objects[indexScene][indexObject].data.obj_id
      countCopy = #game.objects[indexScene][indexObject].data.copies
      indexCopy = game.objects[indexScene][indexObject].data.copies[countCopy]
    end if game.objects[indexScene][indexObject].data.copy
    then indexObject = game.objects[indexScene][indexObject].data.obj_id end

    pcall(function() game.objects[indexScene][indexCopy]:removeSelf()
      table.remove(game.objects[indexScene], indexCopy)
      for i = 1, #game.objects[indexScene][indexObject].data.copies do
        if game.objects[indexScene][indexObject].data.copies[i] == indexCopy then
          table.remove(game.objects[indexScene][indexObject].data.copies, i) break
        end
      end
    end)

    for i = 1, #game.objects[indexScene] do
      game.objects[indexScene][i].data.index = i
      if not game.objects[indexScene][i].data.copy and #game.objects[indexScene][i].data.copies > 0 then
        for j = 1, #game.objects[indexScene][i].data.copies do
          if game.objects[indexScene][i].data.copies[j] > indexCopy then
            game.objects[indexScene][i].data.copies[j] = game.objects[indexScene][i].data.copies[j] - 1
          end
        end
      end
    end
  else if not game.objects[indexScene][indexObject].data.copy
    then countCopy = #game.objects[indexScene][indexObject].data.copies else
    indexObject = game.objects[indexScene][indexObject].data.obj_id
    countCopy = #game.objects[indexScene][indexObject].data.copies end
    if game.objects[indexScene][indexObject].data.copy
    then indexObject = game.objects[indexScene][indexObject].data.obj_id end

    for c = 1, countCopy do indexCopy = game.objects[indexScene][indexObject].data.copies[c]
      pcall(function() game.objects[indexScene][indexCopy]:removeSelf()
        table.remove(game.objects[indexScene], indexCopy)
        for i = 1, #game.objects[indexScene][indexObject].data.copies do
          if game.objects[indexScene][indexObject].data.copies[i] == indexCopy then
            table.remove(game.objects[indexScene][indexObject].data.copies, i) break
          end
        end
      end)

      for i = 1, #game.objects[indexScene] do
        game.objects[indexScene][i].data.index = i
        if not game.objects[indexScene][i].data.copy and #game.objects[indexScene][i].data.copies > 0 then
          for j = 1, #game.objects[indexScene][i].data.copies do
            if game.objects[indexScene][i].data.copies[j] > indexCopy then
              game.objects[indexScene][i].data.copies[j] = game.objects[indexScene][i].data.copies[j] - 1
            end
          end
        end
      end
    end
  end
end

frm.setTag = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'tag' then
    game.objects[indexScene][indexObject].data.tag = value[1]
  end
end

frm.setFlipX = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject]:scale(-1, 1)
end

frm.setFlipY = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject]:scale(1, -1)
end

frm._setTransitionPos = function(indexScene, indexObject, nestedParams, localtable, params)
  local time = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and value2[2] == 'num' then
    transition.to(game.objects[indexScene][indexObject], {
    x = game.x + value[1], y = game.y - value2[1], time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end
end

frm._setTransitionPosX = function(indexScene, indexObject, nestedParams, localtable, params)
  local time = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' then
    transition.to(game.objects[indexScene][indexObject], {
    x = game.x + value[1], time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end
end

frm._setTransitionPosY = function(indexScene, indexObject, nestedParams, localtable, params)
  local time = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' then
    transition.to(game.objects[indexScene][indexObject], {
    y = game.y - value[1], time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end
end

frm._setTransitionWidth = function(indexScene, indexObject, nestedParams, localtable, params)
  local time = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' then
    transition.to(game.objects[indexScene][indexObject], {
    width = tonumber(value[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end
end

frm._setTransitionHeight = function(indexScene, indexObject, nestedParams, localtable, params)
  local time = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' then
    transition.to(game.objects[indexScene][indexObject], {
    height = tonumber(value[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end
end

frm._setTransitionSize = function(indexScene, indexObject, nestedParams, localtable, params)
  local time = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' then
    transition.to(game.objects[indexScene][indexObject], {time = time[1] * 1000,
    height = game.objects[indexScene][indexObject].data.height * (value[1] / 100),
    width = game.objects[indexScene][indexObject].data.width * (value[1] / 100),
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end
end

frm._setTransitionRotation = function(indexScene, indexObject, nestedParams, localtable, params)
  local time = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' then
    transition.to(game.objects[indexScene][indexObject], {
    rotation = tonumber(value[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end
end

frm._setTransitionAlpha = function(indexScene, indexObject, nestedParams, localtable, params)
  local time = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' then
    transition.to(game.objects[indexScene][indexObject], {
    alpha = value[1] / 100, time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end
end

frm._setTransitionPosAngle = function(indexScene, indexObject, nestedParams, localtable, params)
  local time = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local angle = params[2][1] and params[2][1][1] or ''
  local posX = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local posY = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))

  if time[2] == 'num' and posX[2] == 'num' and posY[2] == 'num' then
    transition.to(game.objects[indexScene][indexObject].path, {
    ['x' .. angle] = tonumber(posX[1]), ['y' .. angle] = -tonumber(posY[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end
end

frm.setAnchorX = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].anchorX = value[1] / 100
  end
end

frm.setAnchorY = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].anchorY = value[1] / 100
  end
end

frm.setNameTexture = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'texture' then
    local filename = gameName .. '/' .. gameData[indexScene].name .. '.' ..
    game.objects[indexScene][indexObject].name .. '.' .. value[1]
    game.objects[indexScene][indexObject].data.texture = value[1]
    display.setDefault('magTextureFilter', game.objects[indexScene][indexObject].data.import)

    local downloadImage = display.newImage(filename, game.basedir)
    local width, height = downloadImage.width, downloadImage.height

    game.objects[indexScene][indexObject].fill = {
      type = 'image', baseDir = game.basedir, filename = filename
    } downloadImage:removeSelf()

    game.objects[indexScene][indexObject].data.width = width
    game.objects[indexScene][indexObject].data.height = height
  end
end

frm.setIndexTexture = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    local filename = '' pcall(function() filename = gameName .. '/' ..
    gameData[indexScene].name .. '.' .. game.objects[indexScene][indexObject].name .. '.' ..
    game.objects[indexScene][indexObject].data.textures[tonumber(value[1])]
    game.objects[indexScene][indexObject].data.texture =
    game.objects[indexScene][indexObject].data.textures[tonumber(value[1])] end)

    display.setDefault('magTextureFilter', game.objects[indexScene][indexObject].data.import)

    local downloadImage = display.newImage(filename, game.basedir)
    local width, height = downloadImage.width, downloadImage.height

    game.objects[indexScene][indexObject].fill = {
      type = 'image', baseDir = game.basedir, filename = filename
    } downloadImage:removeSelf()

    game.objects[indexScene][indexObject].data.width = width
    game.objects[indexScene][indexObject].data.height = height
  end
end

frm.setFront = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].z = game.objects[indexScene][indexObject].z + 1
  game.objects[indexScene][indexObject]:toFront()
end

frm.setBack = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].z = game.objects[indexScene][indexObject].z - 1
  game.objects[indexScene][indexObject]:toBack()
end

frm.resetSize = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].width = game.objects[indexScene][indexObject].data.width
  game.objects[indexScene][indexObject].height = game.objects[indexScene][indexObject].data.height
end
