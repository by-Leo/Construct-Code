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
    local filename = '' pcall(function() if tonumber(value[1]) > #game.objects[indexScene][indexObject].data.textures
    then value = {'1', 'num'} end filename = gameName .. '/' ..
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

frm.setResourceTexture = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'resimage' then
    local filename = gameName .. '/res .' .. value[1] pcall(function()
    game.objects[indexScene][indexObject].data.texture = 'res .' .. value[1] end)

    display.setDefault('magTextureFilter', 'nearest')

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

frm.createRect = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local width = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local height = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  if value[2] ~= 'num' then value = {'0', 'num'} end if game.shapes[name]
  then game.shapes[name]:removeSelf() game.shapes[name] = nil end if width[2] == 'num' and height[2] == 'num'
  then game.shapes[name] = display.newRoundedRect(game.x, game.y, width[1] + 0, height[1] + 0, value[1] + 0)
  game.shapes[name].data = {index = 0, click = false, tag = '',
    width = width[1], height = height[1], vis = true, texture = '', physics = {
      density = 0, bounce = 1, friction = -1, gravityScale = 1, hitbox = {},
      fixedRotation = false, sensor = false, bullet = false, body = ''
    }, obj_id = indexObject, scene = indexScene, lis = false, name = name, sn = false
  } game.debugbackground:toFront() game.shapes[name].z = 0 frm.setTouchListenerShape(name) end
end

frm.createCircle = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local radius = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.shapes[name] then game.shapes[name]:removeSelf() game.shapes[name] = nil end if radius[2] == 'num'
  then game.shapes[name] = display.newCircle(game.x, game.y, radius[1] + 0)
  game.shapes[name].data = {index = 0, click = false, tag = '', vis = true, texture = '',
    width = game.shapes[name].width, height = game.shapes[name].height, physics = {
      density = 0, bounce = 1, friction = -1, gravityScale = 1, hitbox = {},
      fixedRotation = false, sensor = false, bullet = false, body = ''
    }, obj_id = indexObject, scene = indexScene, lis = false, name = name, sn = false
  } game.debugbackground:toFront() game.shapes[name].z = 0 frm.setTouchListenerShape(name) end
end

frm.createPolygon = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value, t = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable)), {}
  if value[2] == 'table' and game.shapes[name] then game.shapes[name]:removeSelf() game.shapes[name] = nil end
  if value[2] == 'table' then for k,v in pairs(json.decode(value[1])) do t[tonumber(k)] = tonumber(v[1])
  end game.shapes[name] = display.newPolygon(game.x, game.y, t)
  game.shapes[name].data = {index = 0, click = false, tag = '', vis = true, texture = '',
    width = game.shapes[name].width, height = game.shapes[name].height, physics = {
      density = 0, bounce = 1, friction = -1, gravityScale = 1, hitbox = {},
      fixedRotation = false, sensor = false, bullet = false, body = ''
    }, obj_id = indexObject, scene = indexScene, lis = false, name = name, sn = false
  } game.debugbackground:toFront() game.shapes[name].z = 0 frm.setTouchListenerShape(name) end
end

frm.createCopy = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local width, i_texture = game.objects[indexScene][indexObject].width, '1'
  local height = game.objects[indexScene][indexObject].height
  local rotation = game.objects[indexScene][indexObject].rotation
  local texture = game.objects[indexScene][indexObject].data.texture
  local vis = game.objects[indexScene][indexObject].data.vis
  local density = game.objects[indexScene][indexObject].data.physics.density
  local bounce = game.objects[indexScene][indexObject].data.physics.bounce
  local friction = game.objects[indexScene][indexObject].data.physics.friction
  local gravityScale = game.objects[indexScene][indexObject].data.physics.gravityScale
  local hitbox = game.objects[indexScene][indexObject].data.physics.hitbox
  local fixedRotation = game.objects[indexScene][indexObject].data.physics.fixedRotation
  local sensor = game.objects[indexScene][indexObject].data.physics.sensor
  local bullet = game.objects[indexScene][indexObject].data.physics.bullet
  local body = game.objects[indexScene][indexObject].data.physics.body
  local x, y = game.objects[indexScene][indexObject].x, game.objects[indexScene][indexObject].y
  if game.shapes[name] then game.shapes[name]:removeSelf() game.shapes[name] = nil
  end game.shapes[name] = display.newRect(x, y, width, height) frm.setTouchListenerShape(name)
  game.shapes[name].data = {index = 0, click = false, tag = '', sn = false,
    width = width, height = height, vis = vis, texture = texture, physics = {
      density = density, bounce = bounce, friction = friction, gravityScale = gravityScale,
      hitbox = hitbox, fixedRotation = fixedRotation, sensor = sensor, bullet = bullet, body = body
    }, obj_id = indexObject, scene = indexScene, lis = false, name = name
  } game.debugbackground:toFront() game.shapes[name].z = 0 game.shapes[name].rotation = rotation
  for j = 1, #game.objects[indexScene][indexObject].data.textures do
  if game.objects[indexScene][indexObject].data.textures[j] == game.objects[indexScene][indexObject].data.texture
  then i_texture = tostring(j) break end end frm.setIndexTextureShape(indexScene, indexObject,
  {table.copy(params[1]), {{i_texture, 'num'}}}, table.copy(localtable))
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.createBodyShape(name) end
end

frm.removeShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] then game.shapes[name]:removeSelf() game.snapshot:invalidate 'canvas' game.shapes[name] = nil end
end

frm.setSnapshotShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] and not game.shapes[name].data.sn then game.shapes[name].data.sn = true
    game.snapshot.canvas:insert(game.shapes[name]) game.snapshot:invalidate 'canvas'
    game.shapes[name].x = game.shapes[name].x - game.snapshot.x
    game.shapes[name].y = game.shapes[name].y - game.snapshot.y
  end
end

frm.removeSnapshotShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] and game.shapes[name].data.sn then game.shapes[name].data.sn = false
    game.group:insert(game.shapes[name]) game.snapshot:invalidate 'canvas'
    game.shapes[name].x = game.shapes[name].x + game.snapshot.x
    game.shapes[name].y = game.shapes[name].y + game.snapshot.y
  end
end

frm.setTouchListenerShape = function(name)
  game.shapes[name]:addEventListener('touch', function(e)
    if e.x and e.y then game.touch_x, game.touch_y = e.x, e.y end
    if e.target.data.scene == game.scene and e.target.data.lis then
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
  end) game.snapshot:invalidate 'canvas'
end

frm.setListenerShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] then game.shapes[name].data.lis = true end
end

frm.removeListenerShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] then game.shapes[name].data.lis = false end
end

frm.setPosShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value1 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if game.shapes[name] then
    if game.shapes[name].data.sn then
      game.shapes[name].x = value1[2] == 'num' and
      game.x + value1[1] - game.snapshot.x or game.x - game.snapshot.x
      game.shapes[name].y = value2[2] == 'num' and
      game.y - value2[1] - game.snapshot.y or game.y - game.snapshot.y
    else
      game.shapes[name].x = value1[2] == 'num' and game.x + value1[1] or game.x
      game.shapes[name].y = value2[2] == 'num' and game.y - value2[1] or game.y
    end game.snapshot:invalidate 'canvas'
  end
end

frm.setPosXShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    if game.shapes[name].data.sn
    then game.shapes[name].x = game.x + value[1] - game.snapshot.x
    else game.shapes[name].x = game.x + value[1] end game.snapshot:invalidate 'canvas'
  end
end

frm.setPosYShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    if game.shapes[name].data.sn
    then game.shapes[name].y = game.y - value[1] - game.snapshot.y
    else game.shapes[name].y = game.y - value[1] end game.snapshot:invalidate 'canvas'
  end
end

frm.setWidthShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].width = tonumber(value[1]) game.snapshot:invalidate 'canvas'
  end
end

frm.setHeightShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].height = tonumber(value[1]) game.snapshot:invalidate 'canvas'
  end
end

frm.setSizeShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].width = game.shapes[name].data.width * (value[1] / 100)
    game.shapes[name].height = game.shapes[name].data.height * (value[1] / 100)
    game.snapshot:invalidate 'canvas'
  end
end

frm.setRadiusShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].path.radius = tonumber(value[1]) game.snapshot:invalidate 'canvas'
  end
end

frm.updPosXShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].x = game.shapes[name].x + value[1] game.snapshot:invalidate 'canvas'
  end
end

frm.updPosYShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].y = game.shapes[name].y - value[1] game.snapshot:invalidate 'canvas'
  end
end

frm.updWidthShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].width = game.shapes[name].width + value[1] game.snapshot:invalidate 'canvas'
  end
end

frm.updHeightShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].height = game.shapes[name].height + value[1] game.snapshot:invalidate 'canvas'
  end
end

frm.updSizeShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].width = game.shapes[name].width + game.shapes[name].data.width * (value[1] / 100)
    game.shapes[name].height = game.shapes[name].height + game.shapes[name].data.height * (value[1] / 100)
    game.snapshot:invalidate 'canvas'
  end
end

frm.setRotationShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].rotation = value[1] game.snapshot:invalidate 'canvas'
  end
end

frm.setAlphaShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].alpha = value[1] / 100 game.snapshot:invalidate 'canvas'
  end
end

frm.updRotationShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].rotation = game.shapes[name].rotation + value[1] game.snapshot:invalidate 'canvas'
  end
end

frm.updAlphaShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    game.shapes[name].alpha = game.shapes[name].alpha + value[1] / 100 game.snapshot:invalidate 'canvas'
  end
end

frm.setFlipXShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] then game.shapes[name]:scale(-1, 1) game.snapshot:invalidate 'canvas' end
end

frm.setFlipYShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] then game.shapes[name]:scale(1, -1) game.snapshot:invalidate 'canvas' end
end

frm.setHideShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] then game.shapes[name].isVisible, game.shapes[name].data.vis = false, false
  end game.snapshot:invalidate 'canvas'
end

frm.setViewShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] then game.shapes[name].isVisible, game.shapes[name].data.vis = true, true
  end game.snapshot:invalidate 'canvas'
end

frm.setColorShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local color = params[2][1] and json.decode(params[2][1][1]) or {255,255,255}
  if game.shapes[name] then game.shapes[name]:setFillColor(color[1]/255, color[2]/255, color[3]/255)
  end game.snapshot:invalidate 'canvas'
end

frm.setRGBColorShape = function(indexScene, indexObject, params, localtable)
  local name, color = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1], {255, 255, 255}
  local r = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local g = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local b = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  if r[2] == 'num' and g[2] == 'num' and b[2] == 'num' then color = {r[1], g[1], b[1]} end
  if game.shapes[name] then game.shapes[name]:setFillColor(color[1]/255, color[2]/255, color[3]/255)
  end game.snapshot:invalidate 'canvas'
end

frm.setHEXColorShape = function(indexScene, indexObject, params, localtable)
  local name, color = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1], {255, 255, 255}
  local colorhex = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if colorhex[2] ~= 'text' then colorhex = {'FFFFFF', 'text'} end
  if utf8.sub(colorhex[1], 1, 1) == '#' then colorhex[1] = utf8.sub(colorhex[1], 2, 7) end
  if utf8.len(colorhex[1]) ~= 6 then colorhex[1] = 'FFFFFF' end local errorHex = false
  local filterHex = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}
  for indexHex = 1, 6 do local symHex = utf8.upper(utf8.sub(colorhex[1], indexHex, indexHex))
  for i = 1, #filterHex do if symHex == filterHex[i] then break
  elseif i == #filterHex then errorHex = true end end
  end if errorHex then colorhex[1] = 'FFFFFF' end color = hex(colorhex[1])
  if game.shapes[name] then game.shapes[name]:setFillColor(color[1]/255, color[2]/255, color[3]/255)
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionPosShape = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and value2[2] == 'num' and game.shapes[name] then
    transition.to(game.shapes[name], {
    x = game.x + value[1], y = game.y - value2[1], time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionPosXShape = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and game.shapes[name] then
    transition.to(game.shapes[name], {
    x = game.x + value[1], time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionPosYShape = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and game.shapes[name] then
    transition.to(game.shapes[name], {
    y = game.y - value[1], time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionWidthShape = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and game.shapes[name] then
    transition.to(game.shapes[name], {
    width = tonumber(value[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionHeightShape = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and game.shapes[name] then
    transition.to(game.shapes[name], {
    height = tonumber(value[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionSizeShape = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and game.shapes[name] then
    transition.to(game.shapes[name], {time = time[1] * 1000,
    height = game.objects[indexScene][indexObject].data.height * (value[1] / 100),
    width = game.objects[indexScene][indexObject].data.width * (value[1] / 100),
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionRotationShape = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and game.shapes[name] then
    transition.to(game.shapes[name], {
    rotation = tonumber(value[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionAlphaShape = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local value = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if time[2] == 'num' and value[2] == 'num' and game.shapes[name] then
    transition.to(game.shapes[name], {
    alpha = value[1] / 100, time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm._setTransitionPosAngleShape = function(indexScene, indexObject, nestedParams, localtable, params)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local time = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local angle = params[3][1] and params[3][1][1] or ''
  local posX = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  local posY = calc(indexScene, indexObject, table.copy(params[5]), table.copy(localtable))

  if time[2] == 'num' and posX[2] == 'num' and posY[2] == 'num' and game.shapes[name] then
    transition.to(game.shapes[name].path, {
    ['x' .. angle] = tonumber(posX[1]), ['y' .. angle] = -tonumber(posY[1]), time = time[1] * 1000,
    onComplete = function() if indexScene == game.scene then
    onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end end})
  end game.snapshot:invalidate 'canvas'
end

frm.setAnchorShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local valueX = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local valueY = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if valueX[2] == 'num' and valueY[2] == 'num' and game.shapes[name] then
    game.shapes[name].anchorX = valueX[1] / 100
    game.shapes[name].anchorY = valueY[1] / 100
    game.snapshot:invalidate 'canvas'
  end
end

frm.setNameTextureShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'texture' and game.shapes[name] then
    local filename = gameName .. '/' .. gameData[indexScene].name .. '.' ..
    game.objects[indexScene][indexObject].name .. '.' .. value[1]
    game.shapes[name].data.texture = value[1]
    display.setDefault('magTextureFilter', game.objects[indexScene][indexObject].data.import)

    local downloadImage = display.newImage(filename, game.basedir)
    local width, height = downloadImage.width, downloadImage.height

    game.shapes[name].fill = {
      type = 'image', baseDir = game.basedir, filename = filename
    } downloadImage:removeSelf()

    game.shapes[name].data.width = width
    game.shapes[name].data.height = height
    game.snapshot:invalidate 'canvas'
  end
end

frm.setIndexTextureShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'num' and game.shapes[name] then
    local filename = '' pcall(function() if tonumber(value[1]) > #game.objects[indexScene][indexObject].data.textures
    then value = {'1', 'num'} end filename = gameName .. '/' ..
    gameData[indexScene].name .. '.' .. game.objects[indexScene][indexObject].name .. '.' ..
    game.objects[indexScene][indexObject].data.textures[tonumber(value[1])]
    game.shapes[name].data.texture = game.objects[indexScene][indexObject].data.textures[tonumber(value[1])] end)

    display.setDefault('magTextureFilter', game.objects[indexScene][indexObject].data.import)

    local downloadImage = display.newImage(filename, game.basedir)
    local width, height = downloadImage.width, downloadImage.height

    game.shapes[name].fill = {
      type = 'image', baseDir = game.basedir, filename = filename
    } downloadImage:removeSelf()

    game.shapes[name].data.width = width
    game.shapes[name].data.height = height
    game.snapshot:invalidate 'canvas'
  end
end

frm.setSdcardTextureShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local path = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))[1]
  local filename, filepath = '/sdcard/' .. path, 'texture' .. indexObject .. math.random(111111, 999999) .. '.png'

  if game.shapes[name] then
    os.execute(string.format('mv "%s" "%s"', filename, system.pathForFile(filepath, system.TemporaryDirectory)))
    display.setDefault('magTextureFilter', game.objects[indexScene][indexObject].data.import)

    local downloadImage = display.newImage(filepath, system.TemporaryDirectory)
    local width, height = downloadImage.width, downloadImage.height

    game.shapes[name].fill = {
      type = 'image', baseDir = system.TemporaryDirectory, filename = filepath
    } downloadImage:removeSelf()

    game.shapes[name].data.texture = '.' .. filepath
    game.shapes[name].data.width = width
    game.shapes[name].data.height = height
    game.snapshot:invalidate 'canvas'
  end
end

frm.setMediaTextureShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local filename = 'texture' .. indexObject .. math.random(111111, 999999) .. '.png'

  library.pickFile(system.pathForFile('', system.TemporaryDirectory), function(import)
    if import.done and import.done == 'ok' and game.shapes[name] and indexScene == game.scene then
      display.setDefault('magTextureFilter', game.objects[indexScene][indexObject].data.import)

      local downloadImage = display.newImage(filename, system.TemporaryDirectory)
      local width, height = downloadImage.width, downloadImage.height

      game.shapes[name].fill = {
        type = 'image', baseDir = system.TemporaryDirectory, filename = filename
      } downloadImage:removeSelf()

      game.shapes[name].data.texture = '.' .. filename
      game.shapes[name].data.width = width
      game.shapes[name].data.height = height
      game.snapshot:invalidate 'canvas'
    end
  end, filename, '', 'image/*', nil, nil, nil)
end

frm.setResourceTextureShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local value = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if value[2] == 'resimage' and game.shapes[name] then
    local filename = gameName .. '/res .' .. value[1] pcall(function()
    game.shapes[name].data.texture = 'res .' .. value[1] end)

    display.setDefault('magTextureFilter', 'nearest')

    local downloadImage = display.newImage(filename, game.basedir)
    local width, height = downloadImage.width, downloadImage.height

    game.shapes[name].fill = {
      type = 'image', baseDir = game.basedir, filename = filename
    } downloadImage:removeSelf()

    game.shapes[name].data.width = width
    game.shapes[name].data.height = height
    game.snapshot:invalidate 'canvas'
  end
end

frm.setFrontShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] then game.shapes[name].z = game.shapes[name].z + 1 game.shapes[name]:toFront()
  end game.snapshot:invalidate 'canvas'
end

frm.setBackShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] then game.shapes[name].z = game.shapes[name].z - 1 game.shapes[name]:toBack()
  end game.snapshot:invalidate 'canvas'
end

frm.resetSizeShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1] if game.shapes[name] then
  game.shapes[name].width, game.shapes[name].height = game.shapes[name].data.width, game.shapes[name].data.height
  end game.snapshot:invalidate 'canvas'
end
