cfun = {}

cfun.genExp = function(exp, count)
  if count == 3 then
    table.remove(exp, 1) table.remove(exp, 1) table.remove(exp, #exp)
    local exp1, exp2, exp3, count_sym, last_sym = {}, {}, {}, 0, 1
    for i = 1, #exp do
      if exp[i][2] == 'sym' and exp[i][1] == ',' then
        if count_sym == 0 then count_sym, last_sym = 1, i + 1
        for j = 1, i - 1 do exp1[#exp1 + 1] = exp[j] end end
        if count_sym == 1 then count_sym = 2
        for j = last_sym, i - 1 do exp2[#exp2 + 1] = exp[j] end
        for j = i + 1, #exp do exp3[#exp3 + 1] = exp[j] end break end
      end
    end
    solution = {}
    parseExp(exp1) exp1 = solution
    parseExp(exp2) exp2 = solution
    parseExp(exp3) exp3 = solution
    return exp1, exp2, exp3
  elseif count == 2 then
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
    table.remove(exp, 1) table.remove(exp, 1) table.remove(exp, #exp) exp[#exp + 1] = {',', 'sym'}
    local _exp, last_sym = {}, 1 for i = 1, #exp do if exp[i][2] == 'sym' and exp[i][1] == ','
    then _exp[#_exp + 1] = {} for j = last_sym, i - 1 do _exp[#_exp][#_exp[#_exp] + 1] = exp[j][1]
    end last_sym = i + 1 end end solution = {} for i = 1, #_exp
    do parseExp(_exp[i]) _exp[i] = solution end return _exp
  end
end

cfun.key_check = function(exp)
  local exp1, exp2 = cfun.genExp(exp, 2)
  if (exp1[2] == 'table' or exp1[2] == 'text') and utf8.sub(exp1[1], 1, 1) == '{' then
    local jt = json.decode(exp1[1]) for i in pairs(jt) do if i == tostring(exp2[1])
    then return {'true', 'log'} end end return {'false', 'log'}
  else return {'false', 'log'} end
end

cfun.table_size = function(exp)
  local exp = cfun.genExp(exp, 1)
  if (exp[2] == 'table' or exp[2] == 'text') and utf8.sub(exp[1], 1, 1) == '{' then
    local jt, count = json.decode(exp[1]), 0 for i in pairs(jt)
    do count = count + 1 end return {tostring(count), 'num'}
  else return {'false', 'log'} end
end

cfun.key = function(exp)
  local exp = cfun.genExp(exp, 0)
  return {json.encode(exp), 'key'}
end

cfun.len = function(exp)
  local exp = cfun.genExp(exp, 1)
  return {utf8.len(exp[1]), 'num'}
end

cfun.json_decode = function(exp)
  local exp = cfun.genExp(exp, 1)
  if (exp[2] == 'table' or exp[2] == 'text') and utf8.sub(exp[1], 1, 1) == '{' then
    local at, jt, jf = {}, json.decode(exp[1]) jf = function(at, t) for i in pairs(t) do
      if type(t[i]) == 'table' then at[i] = {} pcall(function() jf(at[i], t[i]) end)
      elseif type(t[i]) == 'string' then at[i] = {t[i], 'text'}
      elseif type(t[i]) == 'number' then at[i] = {tostring(t[i]), 'num'}
      elseif type(t[i]) == 'boolean' then at[i] = {tostring(t[i]), 'log'}
    end end end pcall(function() jf(at, jt) end) return {json.prettify(at), 'table'}
  else return {'false', 'log'} end
end

cfun.json_encode = function(exp)
  local exp = cfun.genExp(exp, 1)
  if (exp[2] == 'table' or exp[2] == 'text') and utf8.sub(exp[1], 1, 1) == '{' then
    local at, jt, jf = {}, json.decode(exp[1]) jf = function(at, t) for i in pairs(t) do
      if t[i][2] and t[i][2] == 'num' then at[i] = tonumber(t[i][1])
      elseif t[i][2] and t[i][2] == 'log' then at[i] = t[i][1] == 'true'
      elseif t[i][2] then at[i] = tostring(t[i][1])
      else at[i] = {} pcall(function() jf(at[i], t[i]) end)
    end end end pcall(function() jf(at, jt) end) return {json.prettify(at), 'table'}
  else return {'false', 'log'} end
end

cfun.sub = function(exp)
  local exp1, exp2, exp3 = cfun.genExp(exp, 3)
  if exp2[2] == 'num' and exp3[2] == 'num' then pcall(function()
    return {utf8.sub(exp1[1], tonumber(exp2[1]), tonumber(exp3[1])), 'text'} end)
  else return {'false', 'log'} end
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

cfun.power = function(exp)
  local exp1, exp2 = cfun.genExp(exp, 2)
  if exp1[2] == 'num' and exp2[2] == 'num' then
    return {tostring(math.pow(exp1[1], exp2[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.module = function(exp)
  local exp = cfun.genExp(exp, 1)
  if exp[2] == 'num' then
    return {tostring(math.abs(exp[1])), 'num'}
  else return {'false', 'log'} end
end

cfun.tonumber = function(exp)
  local exp = cfun.genExp(exp, 1)
  if tonumber(exp[1]) then return {exp[1], 'num'}
  else return {'false', 'log'} end
end

cfun.tostring = function(exp)
  local exp = cfun.genExp(exp, 1)
  return {exp[1], 'text'}
end

cfun['%'] = function(exp)
  local exp1, exp2 = cfun.genExp(exp, 2)

  if exp1[2] == 'num' and exp2[2] == 'num' then
    return {tostring(exp1[1] % exp2[1]), 'num'}
  else return {'false', 'log'} end
end
