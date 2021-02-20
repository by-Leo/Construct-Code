cprop = {}

cprop.genExp = function(exp, count)
  if count == 1 then
    table.remove(exp, 1) table.remove(exp, 1) table.remove(exp, #exp)
    solution = {}
    parseExp(exp) exp = solution
    return exp
  elseif count == 0 then
    table.remove(exp, 1) table.remove(exp, 1) table.remove(exp, #exp)
    return nil
  end
end

cprop.angular_velocity = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.objects[indexScene][copy_id].angularVelocity), 'num'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        if game.objects[indexScene][i].data.physics.body ~= '' then
          return {tostring(game.objects[indexScene][i].angularVelocity), 'num'}
        end return {'false', 'log'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject]
    and game.objects[indexScene][indexObject].data.physics.body ~= '' then
    return {tostring(game.objects[indexScene][indexObject].angularVelocity), 'num'}
  end return {'false', 'log'}
end

cprop.velocity_y = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(select(2, game.objects[indexScene][copy_id]:getLinearVelocity())), 'num'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        if game.objects[indexScene][i].data.physics.body ~= '' then
          return {tostring(select(2, game.objects[indexScene][i]:getLinearVelocity())), 'num'}
        end return {'false', 'log'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject]
    and game.objects[indexScene][indexObject].data.physics.body ~= '' then
    return {tostring(select(2, game.objects[indexScene][indexObject]:getLinearVelocity())), 'num'}
  end return {'false', 'log'}
end

cprop.velocity_x = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(select(1, game.objects[indexScene][copy_id]:getLinearVelocity())), 'num'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        if game.objects[indexScene][i].data.physics.body ~= '' then
          return {tostring(select(1, game.objects[indexScene][i]:getLinearVelocity())), 'num'}
        end return {'false', 'log'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject]
    and game.objects[indexScene][indexObject].data.physics.body ~= '' then
    return {tostring(select(1, game.objects[indexScene][indexObject]:getLinearVelocity())), 'num'}
  end return {'false', 'log'}
end

cprop.click = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.objects[indexScene][copy_id].data.click), 'log'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].data.click), 'log'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    return {tostring(game.objects[indexScene][indexObject].data.click), 'log'}
  end return {'false', 'log'}
end

cprop.count_copies = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) ~= '.copy' then for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(#game.objects[indexScene][i].data.copies), 'num'}
      end
    end end return {'false', 'log'}
  else
    if game.objects[indexScene][indexObject]
    and not game.objects[indexScene][indexObject].data.copy then
      return {tostring(#game.objects[indexScene][indexObject].data.copies), 'num'}
    else return {'false', 'log'} end
  end
end

cprop.tag = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.objects[indexScene][copy_id].data.tag), 'text'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].data.tag), 'text'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    return {tostring(game.objects[indexScene][indexObject].data.tag), 'text'}
  end return {'false', 'log'}
end

cprop.index_texture = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        for j = 1, #game.objects[indexScene][copy_id].data.textures do
          if game.objects[indexScene][copy_id].data.textures[j]
          == game.objects[indexScene][copy_id].data.texture then
            return {tostring(j), 'num'}
          end
        end return {'false', 'log'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        for j = 1, #game.objects[indexScene][i].data.textures do
          if game.objects[indexScene][i].data.textures[j]
          == game.objects[indexScene][i].data.texture then
            return {tostring(j), 'num'}
          end
        end return {'false', 'log'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    for j = 1, #game.objects[indexScene][indexObject].data.textures do
      if game.objects[indexScene][indexObject].data.textures[j]
      == game.objects[indexScene][indexObject].data.texture then
        return {tostring(j), 'num'}
      end
    end return {'false', 'log'}
  end return {'false', 'log'}
end

cprop.name_texture = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.objects[indexScene][copy_id].data.texture), 'text'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].data.texture), 'text'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    return {tostring(game.objects[indexScene][indexObject].data.texture), 'text'}
  end return {'false', 'log'}
end

cprop.alpha = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.objects[indexScene][copy_id].alpha), 'num'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].alpha), 'num'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    return {tostring(game.objects[indexScene][indexObject].alpha), 'num'}
  end return {'false', 'log'}
end

cprop.rotation = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.objects[indexScene][copy_id].rotation), 'num'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].rotation), 'num'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    return {tostring(game.objects[indexScene][indexObject].rotation), 'num'}
  end return {'false', 'log'}
end

cprop.pos_z = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.objects[indexScene][copy_id].z), 'num'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].z), 'num'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    return {tostring(game.objects[indexScene][indexObject].z), 'num'}
  end return {'false', 'log'}
end

cprop.pos_y = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.y - game.objects[indexScene][copy_id].y), 'num'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.y - game.objects[indexScene][i].y), 'num'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    return {tostring(game.y - game.objects[indexScene][indexObject].y), 'num'}
  end return {'false', 'log'}
end

cprop.pos_x = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.objects[indexScene][copy_id].x - game.x), 'num'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].x - game.x), 'num'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    return {tostring(game.objects[indexScene][indexObject].x - game.x), 'num'}
  end return {'false', 'log'}
end

cprop.height = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.objects[indexScene][copy_id].height), 'num'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].height), 'num'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    return {tostring(game.objects[indexScene][indexObject].height), 'num'}
  end return {'false', 'log'}
end

cprop.width = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    if utf8.sub(exp[1], 1, 5) == '.copy' then
      local copy_id = tonumber(utf8.sub(exp[1], 6, utf8.len(exp[1])))
      if game.objects[indexScene][copy_id] and game.objects[indexScene][copy_id].data.physics.body ~= '' then
        return {tostring(game.objects[indexScene][copy_id].width), 'num'}
      end return {'false', 'log'}
    else for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i] and game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].width), 'num'}
      end
    end end return {'false', 'log'}
  elseif game.objects[indexScene][indexObject] then
    return {tostring(game.objects[indexScene][indexObject].width), 'num'}
  end return {'false', 'log'}
end
