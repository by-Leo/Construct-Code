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

frm.openUrl = function(indexScene, indexObject, params, localtable)
  system.openURL(params[1][1] and params[1][1][1] or '')
end

frm.nested = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, nestedType)
  local value = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local value2 = params[2] and calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable)) or {}
  local value3 = params[3] and calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable)) or {}

  if nestedParams and ((nestedType == 'if' and value[2] == 'log' and value[1] == 'true') or (nestedType == 'for' and value[2] == 'num') or (nestedType == 'timer' and value[2] == 'num')) then
    local nestedIndex, nestedEndIndex, nestedNames = 1, nestedStartIndex + 1, 'if for '
    for i = nestedStartIndex + 1, #nestedParams do nestedEndIndex = i
      if utf8.find(nestedNames, nestedParams[i].name .. ' ') then nestedIndex = nestedIndex + 1
      elseif utf8.sub(nestedParams[i].name, utf8.len(nestedParams[i].name)-2, utf8.len(nestedParams[i].name)) == 'End'
      then nestedIndex = nestedIndex - 1 if nestedIndex == 0 then break end end
    end for i = 1, nestedStartIndex do table.remove(nestedParams, 1) end
    if nestedType ~= 'if' and nestedType ~= 'for' then nestedEndIndex = nestedEndIndex + 1 end
    for i = nestedEndIndex - nestedStartIndex, #nestedParams do table.remove(nestedParams, nestedEndIndex - nestedStartIndex) end
    if nestedType == 'if' then onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
    elseif nestedType == 'for' then for i = 1, value[1] do onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable)) end
    elseif nestedType == 'timer' then
      timer.performWithDelay(value[1] * 1000, function()
        onParseBlock(indexScene, indexObject, table.copy(nestedParams), table.copy(localtable))
      end, tonumber((value2[1] and value2[2] == 'num') and value2[1] or 1))
    end
  end
end

frm['if'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'if')
end

frm['for'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'for')
end

frm['timer'] = function(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex)
  frm.nested(indexScene, indexObject, params, localtable, nestedParams, nestedStartIndex, 'timer')
end
