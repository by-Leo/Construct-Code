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
    if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.createBody(indexScene, indexObject) end
  end
end

frm.setHeight = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].height = value[1]
    if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.createBody(indexScene, indexObject) end
  end
end

frm.setSize = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].width = game.objects[indexScene][indexObject].data.width * (value[1] / 100)
    game.objects[indexScene][indexObject].height = game.objects[indexScene][indexObject].data.height * (value[1] / 100)
    if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.createBody(indexScene, indexObject) end
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
    if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.createBody(indexScene, indexObject) end
  end
end

frm.updHeight = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].height = game.objects[indexScene][indexObject].height + value[1]
    if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.createBody(indexScene, indexObject) end
  end
end

frm.updSize = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].width = game.objects[indexScene][indexObject].width
    + game.objects[indexScene][indexObject].data.width * (value[1] / 100)
    game.objects[indexScene][indexObject].height = game.objects[indexScene][indexObject].height
    + game.objects[indexScene][indexObject].data.height * (value[1] / 100)
    if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.createBody(indexScene, indexObject) end
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

frm.setTag = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'tag' then
    game.objects[indexScene][indexObject].data.tag = value[1]
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
    if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.createBody(indexScene, indexObject) end
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
    if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.createBody(indexScene, indexObject) end
  end
end

frm.setFront = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].z = game.objects[indexScene][indexObject].z + 1
  game.objects[indexScene][indexObject]:setFront()
end

frm.setBack = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].z = game.objects[indexScene][indexObject].z - 1
  game.objects[indexScene][indexObject]:setBack()
end

frm.resetSize = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].width = game.objects[indexScene][indexObject].data.width
  game.objects[indexScene][indexObject].height = game.objects[indexScene][indexObject].data.height
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.createBody(indexScene, indexObject) end
end
