calc = function(indexScene, indexObject, params, localtable)
  local exp, func, calcresult = '', '', {'false', 'log'}

  for i = 1, #params do pcall(function()
    if params[i][2] == 'var' then
      if game.vars[params[i][1]] then
        params[i] = table.copy(game.vars[params[i][1]])
      else params[i] = {'false', 'log'} end
    elseif params[i][2] == 'table' then
      params[i] = {json.prettify(game.tables[params[i][1]]), 'table'}
    elseif params[i][2] == 'fun' then
      func = func .. cfun[params[i][1]]()
    elseif params[i][2] == 'prop' then
      func = func .. cprop[params[i][1]]()
    elseif params[i][1] == 'pi' and params[i][2] == 'fun' then
      params[i] = {tostring(math.pi), 'num'}
    elseif params[i][1] == 'unix_time' and params[i][2] == 'fun' then
      params[i] = {tostring(os.time()), 'num'}
    elseif params[i][1] == 'fps' and params[i][2] == 'device' then
      params[i] = {tostring(game.fps), 'num'}
    elseif params[i][1] == 'width_screen' and params[i][2] == 'device' then
      params[i] = {tostring(game.aW), 'num'}
    elseif params[i][1] == 'height_screen' and params[i][2] == 'device' then
      params[i] = {tostring(game.aH), 'num'}
    elseif params[i][1] == 'top_point_screen' and params[i][2] == 'device' then
      params[i] = {tostring(game.aY), 'num'}
    elseif params[i][1] == 'bottom_point_screen' and params[i][2] == 'device' then
      params[i] = {tostring(-game.aY), 'num'}
    elseif params[i][1] == 'rigth_point_screen' and params[i][2] == 'device' then
      params[i] = {tostring(game.aX), 'num'}
    elseif params[i][1] == 'left_point_screen' and params[i][2] == 'device' then
      params[i] = {tostring(-game.aX), 'num'}
    elseif params[i][1] == 'height_top' and params[i][2] == 'device' then
      params[i] = {tostring(game.tH), 'num'}
    elseif params[i][1] == 'height_bottom' and params[i][2] == 'device' then
      params[i] = {tostring(game.bH), 'num'}
    elseif params[i][1] == 'finger_touching_screen' and params[i][2] == 'device' then
      params[i] = {tostring(game.clicks > 0), 'log'}
    elseif params[i][1] == 'count_touch' and params[i][2] == 'device' then
      params[i] = {tostring(game.clicks), 'num'}
    elseif params[i][1] == 'count_tap' and params[i][2] == 'device' then
      params[i] = {tostring(game.count_taps), 'num'}
    elseif params[i][1] == 'gravity_x' and params[i][2] == 'device' then
      params[i] = {tostring(game.gravity_x), 'num'}
    elseif params[i][1] == 'gravity_y' and params[i][2] == 'device' then
      params[i] = {tostring(game.gravity_y), 'num'}
    elseif params[i][1] == 'gravity_z' and params[i][2] == 'device' then
      params[i] = {tostring(game.gravity_z), 'num'}
    elseif params[i][1] == 'instant_x' and params[i][2] == 'device' then
      params[i] = {tostring(game.instant_x), 'num'}
    elseif params[i][1] == 'instant_y' and params[i][2] == 'device' then
      params[i] = {tostring(game.instant_y), 'num'}
    elseif params[i][1] == 'instant_z' and params[i][2] == 'device' then
      params[i] = {tostring(game.instant_z), 'num'}
    elseif params[i][1] == 'raw_x' and params[i][2] == 'device' then
      params[i] = {tostring(game.raw_x), 'num'}
    elseif params[i][1] == 'raw_y' and params[i][2] == 'device' then
      params[i] = {tostring(game.raw_y), 'num'}
    elseif params[i][1] == 'raw_z' and params[i][2] == 'device' then
      params[i] = {tostring(game.raw_z), 'num'}
    elseif params[i][1] == 'local' and params[i][2] == 'local' and localtable and localtable[1] then
      params[i] = {json.prettify(localtable[1]), 'table'}
    end
  end) end

  for i = 1, #params do pcall(function()
    if params[i][2] == 'num' or params[i][2] == 'fun' or params[i][2] == 'prop' then
      exp = exp .. params[i][1] .. ' '
    elseif params[i][2] == 'obj' then
      if utf8.find(params[i][1], '"', 1, true) then
        local j = 0 while j < utf8.len(params[i][1]) do j = j + 1
          if utf8.sub(params[i][1], j, j) == '"' then j = j + 2
            params[i][1] = utf8.sub(params[i][1], 1, j-3) .. '\\' .. utf8.sub(params[i][1], j-2, utf8.len(params[i][1]))
          end
        end
      end exp = exp .. '{"' .. params[i][1] .. '"} '
    elseif params[i][2] == 'log' then
      if params[i][1] == '=' then exp = exp .. '== '
      else exp = exp .. params[i][1] .. ' ' end
    elseif params[i][2] == 'text' or params[i][2] == 'obj' then
      if utf8.find(params[i][1], '"', 1, true) then
        local j = 0 while j < utf8.len(params[i][1]) do j = j + 1
          if utf8.sub(params[i][1], j, j) == '"' then j = j + 2
            params[i][1] = utf8.sub(params[i][1], 1, j-3) .. '\\' .. utf8.sub(params[i][1], j-2, utf8.len(params[i][1]))
          end
        end
      end exp = exp .. '"' .. params[i][1] .. '" '
    elseif params[i][2] == 'sym' then
      if params[i][1] == '+' and params[i-1] and params[i+1] and (params[i-1][2] == 'text' or params[i+1][2] == 'text')
      then exp = exp .. '.. ' else exp = exp .. params[i][1] .. ' ' end
    end
  end) end

  -- print('2:', 'local indexScene, indexObject = ' .. indexScene
  -- .. ',' .. indexObject .. ' ' .. func .. 'local a = ' .. exp .. 'return a')

  pcall(function()
    local result, types = loadstring('local indexScene, indexObject = ' .. indexScene
    .. ',' .. indexObject .. ' ' .. func .. 'local a = ' .. exp .. 'return a')(), ''
    if type(result) == 'number' then types = 'num'
    elseif type(result) == 'string' then types = 'text'
    elseif type(result) == 'boolean' then types = 'log' end

    print('result:', tostring(result), tostring(types))
    calcresult = {tostring(result), tostring(types)}
  end) return calcresult
end
