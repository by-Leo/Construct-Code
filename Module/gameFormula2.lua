frm.setSize = function(indexScene, indexObject, params, localtable)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  if value[2] == 'num' then
    game.objects[indexScene][indexObject].width = game.objects[indexScene][indexObject].data.width * (value[1] / 100)
    game.objects[indexScene][indexObject].height = game.objects[indexScene][indexObject].data.height * (value[1] / 100)
  end
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

frm.setPos = function(indexScene, indexObject, params, localtable)
  local value1 = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2 = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  
  if value1[2] == 'num' and value2[2] == 'num' then
    game.objects[indexScene][indexObject].x = game.x + value[1]
    game.objects[indexScene][indexObject].y = game.y - value[2]
  end
end
