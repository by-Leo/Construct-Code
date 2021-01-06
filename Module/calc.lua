calc = function(indexScene, indexObject, params, localtable)
  local result = {'false', 'log'}
  pcall(function()
    local solve = function(exp)
      local sym = exp[2][1]
      local value1, type1 = exp[1][1], exp[1][2]
      local value2, type2 = exp[3][1], exp[3][2]

      if sym == '-' then
        if type1 == 'num' and type2 == 'num' then return {tostring(value1 - value2), 'num'}
        else return {'false', 'log'} end
      elseif sym == '+' then
        if type1 == 'num' and type2 == 'num' then return {tostring(value1 + value2), 'num'}
        elseif type1 == 'text' or type2 == 'text' then return {value1 .. value2, 'text'}
        else return {'false', 'log'} end
      elseif sym == '/' then
        if type1 == 'num' and type2 == 'num' then return {tostring(value1 / value2), 'num'}
        else return {'false', 'log'} end
      elseif sym == '*' then
        if type1 == 'num' and type2 == 'num' then return {tostring(value1 * value2), 'num'}
        elseif type1 == 'text' and type2 == 'num' then return {string.rep(value1, value2), 'text'}
        else return {'false', 'log'} end
      elseif sym == '=' then
        return {tostring(value1 == value2), 'log'}
      elseif sym == '>' then
        return {tostring(tonumber(value1) > tonumber(value2)), 'log'}
      elseif sym == '<' then
        return {tostring(tonumber(value1) < tonumber(value2)), 'log'}
      elseif sym == '>=' then
        return {tostring(tonumber(value1) >= tonumber(value2)), 'log'}
      elseif sym == '<=' then
        return {tostring(tonumber(value1) <= tonumber(value2)), 'log'}
      elseif sym == '~=' then
        return {tostring(tonumber(value1) ~= tonumber(value2)), 'log'}
      elseif sym == 'and' then
        return {tostring(value1 and value2), 'log'}
      elseif sym == 'or' then
        return {tostring(value1 or value2), 'log'}
      elseif sym == 'not' then
        return {tostring(value1 ~= 'true'), 'log'}
      end
    end

    for i = 1, #params do
      if params[i][2] == 'var' then
        for j = 1, #game.vars do
          if game.vars[j].name == params[i][1] then
            table.remove(params, i)
            table.insert(params, i, game.vars[j].value)
          end
        end
      end
    end

    for i = 1, #params do
      if params[i][1] == 'pi' and params[i][2] == 'fun' then
        table.remove(params, i)
        table.insert(params, i, {tostring(math.pi), 'num'})
      elseif params[i][1] == 'unix_time' and params[i][2] == 'fun' then
        table.remove(params, i)
        table.insert(params, i, {tostring(os.time()), 'num'})
      end
    end

    local multiAndDiv = true
    local plusAndMinus = true
    local orAndNot = true
    local solveExp = function(exp, i)
      if exp[i - 1] and exp[i + 1]
      and (exp[i - 1][2] == 'num' or exp[i - 1][2] == 'text' or (exp[i - 1][2] == 'log' and exp[i - 1][1] ~= 'not'))
      and (exp[i + 1][2] == 'num' or exp[i + 1][2] == 'text' or (exp[i - 1][2] == 'log' and exp[i - 1][1] ~= 'not')) then
        local solution = solve({
          {exp[i - 1][1], exp[i - 1][2]},
          {exp[i][1], exp[i][2]},
          {exp[i + 1][1], exp[i + 1][2]}
        })
        for j = 1, 3 do table.remove(exp, i - 1) end
        table.insert(exp, i - 1, solution)
      elseif exp[i + 1] and exp[i + 1][2] == 'log' and (exp[i + 1][1] == 'true' or exp[i + 1][1] == 'false') and exp[i][2] == 'log' and exp[i][1] == 'not' then
        local solution = solve({
          {exp[i + 1][1], exp[i + 1][2]},
          {exp[i][1], exp[i][2]},
          {exp[i + 1][1], exp[i + 1][2]}
        })
        for j = 1, 2 do table.remove(exp, i) end
        table.insert(exp, i, solution)
      end parseExp(exp)
    end

    parseExp = function(exp)
      if #exp > 1 then
        if exp[1][2] == 'fun' then solution = cfun[exp[1][1]](exp, indexScene, indexObject, table.copy(localtable))
        elseif exp[1][2] == 'prop' then solution = cprop[exp[1][1]](exp, indexScene, indexObject, table.copy(localtable))
        else
          for i = 1, #exp do
            if exp[i][2] == 'sym' and (exp[i][1] == '*' or exp[i][1] == '/') then
              solveExp(exp, i) break
            elseif not multiAndDiv and exp[i][2] == 'sym' and (exp[i][1] == '+' or exp[i][1] == '-') then
              solveExp(exp, i) break
            elseif not plusAndMinus and exp[i][2] == 'log' and exp[i][1] ~= 'true' and exp[i][1] ~= 'false' and exp[i][1] ~= 'and' and exp[i][1] ~= 'or' and exp[i][1] ~= 'not' then
              solveExp(exp, i) break
            elseif not orAndNot and exp[i][2] == 'log' and exp[i][1] ~= 'true' and exp[i][1] ~= 'false' then
              solveExp(exp, i) break
            elseif i == #exp then
              if multiAndDiv then multiAndDiv = false
              elseif plusAndMinus then plusAndMinus = false
              elseif orAndNot then orAndNot = false
              end parseExp(exp)
            end
          end
        end
      elseif exp[1][2] == 'fun' then solution = cfun[exp[1][1]]({}, indexScene, indexObject, table.copy(localtable))
      elseif exp[1][2] == 'prop' then solution = cprop[exp[1][1]]({}, indexScene, indexObject, table.copy(localtable))
      else solution = exp[1] end
    end

    parseBrackets = function(exp)
      local indexFirstBracket = 0
      local indexSecondBracket = 0
      for i = 1, #exp do
        if exp[i][2] == 'sym' and exp[i][1] == '(' then
          if exp[i - 1] and (exp[i - 1][2] == 'fun' or exp[i - 1][2] == 'prop') then indexFirstBracket = i - 1
          else indexFirstBracket = i + 1 end
        elseif exp[i][2] == 'sym' and exp[i][1] == ')' and indexFirstBracket > 0 then
          if exp[indexFirstBracket] and (exp[indexFirstBracket][2] == 'fun' or exp[indexFirstBracket][2] == 'prop') then indexSecondBracket = i
          else indexSecondBracket = i - 1 end
          local _exp = {} solution = {}
          for j = indexFirstBracket, indexSecondBracket do
            _exp[#_exp + 1] = {exp[j][1], exp[j][2]}
          end parseExp(_exp)
          if exp[indexFirstBracket] and (exp[indexFirstBracket][2] == 'fun' or exp[indexFirstBracket][2] == 'prop') then
            for j = indexFirstBracket, indexSecondBracket do table.remove(exp, indexFirstBracket) end
            table.insert(exp, indexFirstBracket, solution)
          else
            for j = indexFirstBracket - 1, indexSecondBracket + 1 do table.remove(exp, indexFirstBracket - 1) end
            table.insert(exp, indexFirstBracket - 1, solution)
          end
          parseBrackets(exp) break
        elseif i == #exp then solution = {} parseExp(exp) result = solution end
      end
    end parseBrackets(params)
  end) return result
end
