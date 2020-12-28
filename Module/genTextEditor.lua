local sortText
local lasttype
local lastvalue

activity.editor.newText = function()
  activity.editor.cursor = table.copy(activity.editor.table)
  activity.editor.cursor[#activity.editor.cursor + 1] = {'|', '|'}

  for i = 2, #activity.editor.cursor do
    if activity.editor.cursor[i][2] == 'num' then
      for j = utf8.len(activity.editor.cursor[i][1]), 1, -1 do
        if utf8.sub(activity.editor.cursor[i][1], j, j) == '.' then
          table.insert(activity.editor.cursor, i + 1, {'.', 'sym'})
        else
          table.insert(activity.editor.cursor, i + 1, {utf8.sub(activity.editor.cursor[i][1], j, j), 'num'})
        end
      end
      table.remove(activity.editor.cursor, i)
    end
  end

  activity.editor.cursorIndex = {#activity.editor.cursor, '|'}
  activity.editor.undoredo = {[1] = table.copy(activity.editor.cursor)}
  activity.editor.genText()
end

activity.editor.text = display.newText({text = '', width = activity.editor.scroll.width - 30, x = 15, y = 15, font = 'ubuntu_!bold.ttf', fontSize = 40})
activity.editor.text.anchorX = 0
activity.editor.text.anchorY = 0
activity.editor.scroll:insert(activity.editor.text)

-- Отображение текста из таблицы
activity.editor.genText = function(undoredo)
  if not undoredo and activity.editor.undoredoi then
    activity.editor.undoredoi = activity.editor.undoredoi + 1
    activity.editor.undoredo[activity.editor.undoredoi] = table.copy(activity.editor.cursor)
    activity.editor.undoredocursor[activity.editor.undoredoi] = table.copy(activity.editor.cursorIndex)
    for j = activity.editor.undoredoi + 1, #activity.editor.undoredo do
      activity.editor.undoredo[j] = nil
      activity.editor.undoredocursor[j] = nil
    end
  end

  activity.editor.text.text = ''
  lasttype = ''
  lastvalue = ''

  sortText = function(type, value, i)
    if type == 'text' then
      if (lastvalue == '(' and lasttype == 'sym') or (lastvalue == '[' and lasttype == 'table') then
        activity.editor.text.text = activity.editor.text.text .. '\'' .. value .. '\''
      else
        activity.editor.text.text = activity.editor.text.text .. '  \'' .. value .. '\''
      end
    elseif type == 'table' and value ~= '[' and value ~= ']' then
      if (lastvalue == '(' and lasttype == 'sym') or (lastvalue == '[' and lasttype == 'table') then
        activity.editor.text.text = activity.editor.text.text .. value
      else
        activity.editor.text.text = activity.editor.text.text .. '  ' .. value
      end
    elseif type == 'local' then
      if (lastvalue == '(' and lasttype == 'sym') or (lastvalue == '[' and lasttype == 'table') then
        activity.editor.text.text = activity.editor.text.text .. '{' .. strings.editorLocalTable .. '}'
      else
        activity.editor.text.text = activity.editor.text.text .. '  {' .. strings.editorLocalTable .. '}'
      end
    elseif type == 'num' or (type == 'sym' and value == '.') or (type == 'sym' and value == ',') then
      if not (lasttype == '|' and activity.editor.cursorIndex[2] == 'text') and ((type == 'sym' and value == ',') or lasttype == 'num' or (lasttype == 'sym' and lastvalue == '.') or lasttype == '|' or (lastvalue == '(' and lasttype == 'sym') or (lastvalue == '[' and lasttype == 'table')) then
        activity.editor.text.text = activity.editor.text.text .. value
      else
        activity.editor.text.text = activity.editor.text.text .. '  ' .. value
      end
    elseif type == '|' or type == 'sym' or type == 'table' then
      if (type == '|' and activity.editor.cursorIndex[2] == '|') and ((lasttype == 'sym' and lastvalue == '.') or lasttype == 'num' or (lastvalue == '(' and lasttype == 'sym') or (lastvalue == '[' and lasttype == 'table')) and i < #activity.editor.cursor  then
        activity.editor.text.text = activity.editor.text.text .. value
      elseif (value == ')' and type == 'sym') or (value == '(' and type == 'sym' and (lasttype ~= 'sym' or lastvalue == '(' or lastvalue == ')'))
      or (value == ')' and type == 'sym') or (value == '(' and type == 'sym' and (lasttype ~= 'sym' or lastvalue == '(' or lastvalue == ')'))
      or (value == ']' and type == 'table') or (value == '[' and type == 'table' and (lasttype ~= 'sym' or lastvalue == '[' or lastvalue == ']'))
      or (value == ']' and type == 'table') or (value == '[' and type == 'table' and (lasttype ~= 'sym' or lastvalue == '[' or lastvalue == ']'))
      or (type == 'sym' and lasttype == 'sym' and lastvalue == '(')  or (type == 'sym' and lasttype == 'table' and lastvalue == '[')  then
        activity.editor.text.text = activity.editor.text.text .. value
      elseif (type == '|' and activity.editor.cursorIndex[2] == 'text') then
        activity.editor.text.text = utf8.sub(activity.editor.text.text, 1, utf8.len(activity.editor.text.text) - 1) .. '  |\''
      else
        activity.editor.text.text = activity.editor.text.text .. '  ' .. value
      end
    elseif type == 'fun' or type == 'prop' or type == 'log' then
      for j = 1, #strings.editorList[type] do
        if strings.editorList[type][j][2] == value then
          if (lastvalue == '(' and lasttype == 'sym') or (lastvalue == '[' and lasttype == 'table') then
            activity.editor.text.text = activity.editor.text.text .. strings.editorList[type][j][1]
          else
            activity.editor.text.text = activity.editor.text.text .. '  ' .. strings.editorList[type][j][1]
          end
          break
        end
      end
    end
  end

  for i = 2, #activity.editor.cursor do
    sortText(activity.editor.cursor[i][2], activity.editor.cursor[i][1], i)
    lasttype, lastvalue = activity.editor.cursor[i][2], activity.editor.cursor[i][1]
    if i == 2 then activity.editor.text.text = trimLeft(activity.editor.text.text) end
  end

  activity.editor.scroll:setScrollHeight(activity.editor.text.height + 30)
end
