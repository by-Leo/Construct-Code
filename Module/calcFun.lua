cfun = {}

cfun.len = function()
  return [[
    function len(exp1)
      local result pcall(function()
      result = utf8.len(exp1) end)
      if result then return result else return false end
    end
  ]]
end

cfun.gsub = function()
  return [[
    function gsub(exp1, exp2, exp3, exp4)
      local result pcall(function()
      result = utf8.gsub(exp1, exp2, exp3, exp4 or 1) end)
      if result then return result else return false end
    end
  ]]
end

cfun.sub = function()
  return [[
    function sub(exp1, exp2, exp3)
      local result pcall(function()
      result = utf8.sub(exp1, exp2, exp3) end)
      if result then return result else return false end
    end
  ]]
end

cfun.find = function()
  return [[
    function find(exp1, exp2)
      local result pcall(function()
      result = utf8.find(exp1, exp2) end)
      if result then return result else return false end
    end
  ]]
end

cfun.match = function()
  return [[
    function match(exp1, exp2)
      local result pcall(function()
      result = utf8.match(exp1, exp2) end)
      if result then return result else return false end
    end
  ]]
end

cfun.max = function()
  return [[
    function max(...)
      local result pcall(function()
      result = math.max(unpack(arg)) end)
      if result then return result else return false end
    end
  ]]
end

cfun.min = function()
  return [[
    function min(...)
      local result pcall(function()
      result = math.min(unpack(arg)) end)
      if result then return result else return false end
    end
  ]]
end

cfun.round = function()
  return [[
    function round(exp1, exp2)
      local result pcall(function()
      result = tonumber(string.format('%.' .. exp2 .. 'f', tonumber(exp1))) end)
      if result then return result else return false end
    end
  ]]
end

cfun.random = function()
  return [[
    function random(exp1, exp2)
      local result pcall(function()
      result = math.random(exp1, exp2) end)
      if result then return result else return false end
    end
  ]]
end

cfun.random_str = function()
  return [[
    function random_str(...)
      local result pcall(function()
      result = arg[math.random(1, #arg)] end)
      if result then return result else return false end
    end
  ]]
end

cfun.arctan2 = function()
  return [[
    function arctan2(exp1, exp2)
      local result pcall(function()
      result = math.atan2(exp1 * math.pi / 180, exp2 * math.pi / 180) end)
      if result then return result else return false end
    end
  ]]
end

cfun.arcctan = function()
  return [[
    function arcctan(exp1)
      local result pcall(function()
      result = 1/math.atan(exp1 * math.pi / 180) end)
      if result then return result else return false end
    end
  ]]
end

cfun.arctan = function()
  return [[
    function arctan(exp1)
      local result pcall(function()
      result = math.atan(exp1 * math.pi / 180) end)
      if result then return result else return false end
    end
  ]]
end

cfun.arccos = function()
  return [[
    function arccos(exp1)
      local result pcall(function()
      result = math.acos(exp1 * math.pi / 180) end)
      if result then return result else return false end
    end
  ]]
end

cfun.arcsin = function()
  return [[
    function arcsin(exp1)
      local result pcall(function()
      result = math.asin(exp1 * math.pi / 180) end)
      if result then return result else return false end
    end
  ]]
end

cfun.ctan = function()
  return [[
    function ctan(exp1)
      local result pcall(function()
      result = 1/math.tan(exp1 * math.pi / 180) end)
      if result then return result else return false end
    end
  ]]
end

cfun.tan = function()
  return [[
    function tan(exp1)
      local result pcall(function()
      result = math.tan(exp1 * math.pi / 180) end)
      if result then return result else return false end
    end
  ]]
end

cfun.cos = function()
  return [[
    function tan(exp1)
      local result pcall(function()
      result = math.cos(exp1 * math.pi / 180) end)
      if result then return result else return false end
    end
  ]]
end

cfun.sin = function()
  return [[
    function tan(exp1)
      local result pcall(function()
      result = math.sin(exp1 * math.pi / 180) end)
      if result then return result else return false end
    end
  ]]
end

cfun.log10 = function()
  return [[
    function log10(exp1)
      local result pcall(function()
      result = math.log10(exp1) end)
      if result then return result else return false end
    end
  ]]
end

cfun.log = function()
  return [[
    function log(exp1)
      local result pcall(function()
      result = math.log(exp1) end)
      if result then return result else return false end
    end
  ]]
end

cfun.radical = function()
  return [[
    function radical(exp1)
      local result pcall(function()
      result = math.sqrt(exp1) end)
      if result then return result else return false end
    end
  ]]
end

cfun.power = function()
  return [[
    function power(exp1, exp2)
      local result pcall(function()
      result = math.pow(exp1, exp2) end)
      if result then return result else return false end
    end
  ]]
end

cfun.module = function()
  return [[
    function module(exp1)
      local result pcall(function()
      result = math.abs(exp1) end)
      if result then return result else return false end
    end
  ]]
end

cfun.tonumber = function()
  return [[
    function tonumber(exp1)
      local result pcall(function()
      result = tonumber(exp1) end)
      if result then return result else return false end
    end
  ]]
end

cfun.tostring = function()
  return [[
    function tostring(exp1)
      return tostring(exp1)
    end
  ]]
end

cfun.remainder = function()
  return [[
    function remainder(exp1, exp2)
      local result pcall(function()
      result = exp1 % exp2 end)
      if result then return result else return false end
    end
  ]]
end

cfun.key_check = function()
  -- return [[
  --   function key_check(exp1, exp2)
  --     pcall(function() if utf8.sub(exp1, 1, 1) == '{' then
  --       local jt = json.decode(exp1) for i in pairs(jt) do if i == tostring(exp2)
  --       then return true end end return false
  --     end end) return false
  --   end
  -- ]]
end

cfun.table_size = function()
  -- return [[
  --   function table_size(exp1)
  --     pcall(function() if utf8.sub(exp1, 1, 1) == '{' then
  --       local jt, count = json.decode(exp1), 0 for i in pairs(jt)
  --       do count = count + 1 end return count
  --     end end) return false
  --   end
  -- ]]
end

cfun.key = function()
  -- return [[
  --   function key(...)
  --     local result pcall(function()
  --     result = json.encode(arg) end)
  --     if result then return result else return false end
  --   end
  -- ]]
end

cfun.json_decode = function()
  -- local exp = cfun.genExp(exp, 1)
  -- if (exp[2] == 'table' or exp[2] == 'text') and (utf8.sub(exp[1], 1, 1) == '{' or utf8.sub(exp[1], 1, 1) == '[')
  -- then local at, jt, jf = {}, json.decode(exp[1]) jf = function(at, t) for i in pairs(t) do
  --     if type(t[i]) == 'table' then at[i] = {} pcall(function() jf(at[i], t[i]) end)
  --     elseif type(t[i]) == 'string' then at[i] = {t[i], 'text'}
  --     elseif type(t[i]) == 'number' then at[i] = {tostring(t[i]), 'num'}
  --     elseif type(t[i]) == 'boolean' then at[i] = {tostring(t[i]), 'log'}
  --   end end end pcall(function() jf(at, jt) end) return {json.prettify(at), 'table'}
  -- else return {'false', 'log'} end
end

cfun.json_encode = function()
  -- local exp = cfun.genExp(exp, 1)
  -- if (exp[2] == 'table' or exp[2] == 'text') and utf8.sub(exp[1], 1, 1) == '{' then
  --   local at, jt, jf = {}, json.decode(exp[1]) jf = function(at, t) for i in pairs(t) do
  --     if t[i][2] and t[i][2] == 'num' then at[i] = tonumber(t[i][1])
  --     elseif t[i][2] and t[i][2] == 'log' then at[i] = t[i][1] == 'true'
  --     elseif t[i][2] then at[i] = tostring(t[i][1])
  --     else at[i] = {} pcall(function() jf(at[i], t[i]) end)
  --   end end end pcall(function() jf(at, jt) end) return {json.prettify(at), 'table'}
  -- else return {'false', 'log'} end
end
