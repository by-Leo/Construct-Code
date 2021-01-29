cfun = {}

cfun.genExp = function(exp, count)
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
  end
end

cfun.round = function(exp)
  local exp1, exp2 = cfun.genExp(exp, 2)
  if exp1[2] == 'num' and exp2[2] == 'num' then
    return {tostring(tonumber(string.format('%.' .. exp2[1] .. 'f', tonumber(exp1[1])))), 'num'}
  else return {'false', 'log'} end
end

cfun.random = function(exp)
  local exp1, exp2 = cfun.genExp(exp, 2)
  if exp1[2] == 'num' and exp2[2] == 'num' then
    return {math.random(exp1[1], exp2[1]), 'num'}
  else return {'false', 'log'} end
end

-- cfun.decode_json = function(exp)
--   local exp = cfun.genExp(exp, 1)
--   if (exp[2] == 'text' or exp[2] == 'table') and utf8.sub(exp[1], 1, 1) == '{'
--   then return {exp[1], 'table'}
--   else return {'false', 'log'} end
-- end

cfun.arcctan = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(1/math.atan(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.arctan = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(math.atan(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.arccos = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(math.acos(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.arcsin = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(math.asin(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.ctan = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(1/math.tan(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.tan = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(math.tan(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.cos = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(math.cos(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.sin = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(math.sin(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.log10 = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(math.log10(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.log = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(math.log(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.radical = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(math.sqrt(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun['%'] = function(exp)
  local exp1, exp2 = cfun.genExp(exp, 2)

  if exp1[2] == 'num' and exp2[2] == 'num' then
    return {tostring(exp1[1] % exp2[1]), 'num'}
  else return {'false', 'log'} end
end
