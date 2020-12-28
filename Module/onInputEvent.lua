activity.onInputEvent = function(event, data, types)
  if event.phase == 'editing' then
    inputPermission(true)
    for i = 1, utf8.len(event.text) do
      if utf8.find(filterInput, utf8.sub(event.text, i, i), 1, true) or string.len(utf8.sub(event.text, i, i)) > 3 then
        inputPermission(false)
        break
      end
    end
    if utf8.find(event.text, '\n', 1, true) or utf8.len(event.text) == 0 or utf8.len(event.text) > 30 or utf8.byte(utf8.sub(event.text, 1, 1)) == 32 or utf8.byte(utf8.sub(event.text, utf8.len(event.text), utf8.len(event.text))) == 32 then
      inputPermission(false)
    end
    for i = 1, #data do
      if data[i] == event.text then
        inputPermission(false)
        break
      end
    end
  elseif event.phase == 'ok' then
    local newEventText = ''
    for i = 1, utf8.len(event.text) do
      if not utf8.find(filterInput, utf8.sub(event.text, i, i), 1, true) or string.len(utf8.sub(event.text, i, i)) > 3 then
        newEventText = newEventText .. utf8.sub(event.text, i, i)
      end
    end
    if utf8.len(newEventText) == 0 or utf8.len(newEventText) > 30 or utf8.byte(utf8.sub(newEventText, 1, 1)) == 32 or utf8.byte(utf8.sub(newEventText, utf8.len(newEventText), utf8.len(newEventText))) == 32 then
      newEventText = 'Не используй T9_' .. math.random(111111111, 999999999)
    end
    for i = 1, #data do
      if data[i] == newEventText then
        newEventText = 'Не используй T9_' .. math.random(111111111, 999999999)
        break
      end
    end
    return newEventText
  end
end
