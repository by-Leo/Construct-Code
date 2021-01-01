cfun = {}

cfun.random = function(exp)
  table.remove(exp, 1)
  table.remove(exp, 1)
  table.remove(exp, #exp)
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

  if exp1[2] == 'num' and exp2[2] == 'num' then return {math.random(exp1[1], exp2[1]), 'num'}
  else return {'nil', 'nil'} end
end

cfun.radical = function(exp)
  table.remove(exp, 1)
  table.remove(exp, 1)
  table.remove(exp, #exp)

  solution = {}
  parseExp(exp) exp = solution

  if exp[2] == 'num' then return {math.sqrt(exp[1]), 'num'}
  else return {'nil', 'nil'} end
end
