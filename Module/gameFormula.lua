frm = {}

frm.setVar = function(params)
  local nameVar = params[1][1][1]
  print(json.prettify(params[2]))
  local valueVar = calc(params[2])
  print(json.prettify(valueVar))

  for i = 1, #game.vars + 1 do
    if game.vars[i] and game.vars[i].name == nameVar then
      game.vars[i].value = valueVar break
    elseif i == #game.vars + 1 then
      game.vars[#game.vars + 1] = {name = nameVar, value = valueVar}
    end
  end
end
