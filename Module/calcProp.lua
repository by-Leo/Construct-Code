cprop = {}

cprop.genExp = function(exp, count)
  if count == 2 then
    table.remove(exp, 1) table.remove(exp, 1) table.remove(exp, #exp)
    local exp1, exp2 = {}, {}
    for i = 1, #exp do
      if exp[i][2] == 'sym' and exp[i][1] == ',' then
        for j = 1, i - 1 do exp1[#exp1 + 1] = exp[j] end
        for j = i + 1, #exp do exp2[#exp2 + 1] = exp[j] end
        break
      end
    end
    solution = {}
    parseExp(exp1) exp1 = solution
    parseExp(exp2) exp2 = solution
    return exp1, exp2
  elseif count == 1 then
    table.remove(exp, 1) table.remove(exp, 1) table.remove(exp, #exp)
    solution = {}
    parseExp(exp) exp = solution
    return exp
  elseif count == 0 then
    table.remove(exp, 1) table.remove(exp, 1) table.remove(exp, #exp)
    return nil
  end
end

cprop.tag = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].data.tag), 'text'}
      end
    end return {'false', 'log'}
  else
    return {tostring(game.objects[indexScene][indexObject].data.tag), 'text'}
  end
end

cprop.rotation = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].rotation), 'num'}
      end
    end return {'false', 'log'}
  else
    return {tostring(game.objects[indexScene][indexObject].rotation), 'num'}
  end
end

cprop.posZ = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].z), 'num'}
      end
    end return {'false', 'log'}
  else
    return {tostring(game.objects[indexScene][indexObject].z), 'num'}
  end
end

cprop.posY = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.y - game.objects[indexScene][i].y), 'num'}
      end
    end return {'false', 'log'}
  else
    return {tostring(game.y - game.objects[indexScene][indexObject].y), 'num'}
  end
end

cprop.posX = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].x - game.x), 'num'}
      end
    end return {'false', 'log'}
  else
    return {tostring(game.objects[indexScene][indexObject].x - game.x), 'num'}
  end
end

cprop.height = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].height), 'num'}
      end
    end return {'false', 'log'}
  else
    return {tostring(game.objects[indexScene][indexObject].height), 'num'}
  end
end

cprop.width = function(exp, indexScene, indexObject)
  local exp = cprop.genExp(exp, #exp - 3)
  if exp then
    for i = 1, #game.objects[indexScene] do
      if game.objects[indexScene][i].name == exp[1] then
        return {tostring(game.objects[indexScene][i].width), 'num'}
      end
    end return {'false', 'log'}
  else
    return {tostring(game.objects[indexScene][indexObject].width), 'num'}
  end
end
