cdevice = {}

cdevice.genExp = function(exp)
  table.remove(exp, 1) table.remove(exp, 1) table.remove(exp, #exp)
  solution = {}
  parseExp(exp) exp = solution
  return exp
end
