cdevice = {}

cdevice.genExp = function(exp)
  table.remove(exp, 1) table.remove(exp, 1) table.remove(exp, #exp)
  solution = {}
  parseExp(exp) exp = solution
  return exp
end

cdevice.finger_touching_screen_x = function(exp)
  if #exp < 4 then return {tostring(game.touch_x - game.x), 'num'} end
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    for key, tap in pairs(game.taps) do
      if tap.id == tonumber(exp[1]) then
        return {tostring(tap.x - game.x), 'num'}
    end end return {'false', 'log'}
  else return {'false', 'log'} end
end

cdevice.finger_touching_screen_y = function(exp)
  if #exp < 4 then return {tostring(game.y - game.touch_y), 'num'} end
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    for key, tap in pairs(game.taps) do
      if tap.id == tonumber(exp[1]) then
        return {tostring(game.y - tap.y), 'num'}
    end end return {'false', 'log'}
  else return {'false', 'log'} end
end
