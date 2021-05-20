activity.editor.funcButtons = function(id) pcall(function()
  local cursor = activity.editor.cursor
  local type = ''

  if id == '0' or id == '1' or id == '2' or id == '3' or id == '4' or id == '5' or id == '6' or id == '7' or id == '8' or id == '9' then type = 'num'
  elseif id == '+' or id == '-' or id == '*' or id == '/' or id == ',' or id == '.' or id == '(' or id == ')' then type = 'sym' end

  -- print(json.prettify(activity.editor.cursor))
  -- print(json.prettify(activity.editor.cursorIndex))

  if id == '<-' then
    if activity.editor.cursorIndex[1] > 2 and activity.editor.cursorIndex[2] == '|' then
      if cursor[activity.editor.cursorIndex[1] - 1] and cursor[activity.editor.cursorIndex[1] - 1][2] == 'text' then
        activity.editor.cursorIndex[2] = 'text'
      else
        table.insert(cursor, activity.editor.cursorIndex[1] - 1, {'|', '|'})
        table.remove(cursor, activity.editor.cursorIndex[1] + 1)
        activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] - 1
        activity.editor.cursorIndex[2] = '|'
      end activity.editor.genText()
    elseif activity.editor.cursorIndex[2] == 'text' then
      table.insert(cursor, activity.editor.cursorIndex[1] - 1, {'|', '|'})
      table.remove(cursor, activity.editor.cursorIndex[1] + 1)
      activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] - 1
      activity.editor.cursorIndex[2] = '|' activity.editor.genText()
    end
  elseif id == '->' then
    if activity.editor.cursorIndex[1] < #cursor and activity.editor.cursorIndex[2] == '|' then
      table.insert(cursor, activity.editor.cursorIndex[1] + 2, {'|', '|'})
      table.remove(cursor, activity.editor.cursorIndex[1])
      activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 1
      activity.editor.cursorIndex[2] = '|' activity.editor.genText()
    elseif activity.editor.cursorIndex[2] == 'text' then
      activity.editor.cursorIndex[2] = '|' activity.editor.genText()
    end
  elseif id == 'C' then
    if activity.editor.cursorIndex[1] > 2 and activity.editor.cursorIndex[2] == '|' then
      table.remove(cursor, activity.editor.cursorIndex[1] - 1)
      activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] - 1
      activity.editor.cursorIndex[2] = '|' activity.editor.genText()
    elseif activity.editor.cursorIndex[2] == 'text' then
      table.remove(cursor, activity.editor.cursorIndex[1] - 1)
      activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] - 1
      activity.editor.cursorIndex[2] = '|' activity.editor.genText()
    end
  elseif id == '=' then
    if activity.editor.cursorIndex[2] == '|' then
      table.insert(cursor, activity.editor.cursorIndex[1], {id, 'log'})
      activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 1
      activity.editor.cursorIndex[2] = '|' activity.editor.genText()
    end
  elseif id == 'local' then
    if activity.editor.cursorIndex[2] == '|' then
      alertLocal({'my_key',
        'x', 'y', 'xStart', 'yStart', 'name', 'isShape',
        'self_id', 'other_id', 'self_name', 'other_name',
        'self_tag', 'other_tag', 'self_isShape', 'other_isShape'
      }, function(e) if e.text ~= '' then
        table.insert(cursor, activity.editor.cursorIndex[1], {id, id})
        activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 1
        activity.editor.cursorIndex[2] = '|'
        table.insert(cursor, activity.editor.cursorIndex[1], {'(', 'sym'})
        activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 1
        activity.editor.cursorIndex[2] = '|'
        table.insert(cursor, activity.editor.cursorIndex[1], {e.text, 'text'})
        activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 1
        activity.editor.cursorIndex[2] = '|'
        table.insert(cursor, activity.editor.cursorIndex[1], {')', 'sym'})
        activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 1
        activity.editor.cursorIndex[2] = '|' activity.editor.genText()
      end end)
    end
  elseif id == 'text' then
    local oldText = activity.editor.cursorIndex[2] == 'text'
    and activity.editor.cursor[activity.editor.cursorIndex[1] - 1][1] or ''
    input(strings.enterText, strings.enterTextDescription, function(event) inputPermission(true) end, function(e)
      if e.input then
        if oldText == '' then
          table.insert(cursor, activity.editor.cursorIndex[1], {e.text, 'text'})
          activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 1
        else
          cursor[activity.editor.cursorIndex[1] - 1] = {e.text, 'text'}
        end
        activity.editor.cursorIndex[2] = '|'
        activity.editor.genText()
      end
    end, oldText)
  elseif id == 'ok' then
    if activity.editor.cursorIndex[2] == 'text' then
      activity.editor.cursorIndex[2] = '|'
    end
    table.remove(cursor, activity.editor.cursorIndex[1])
    activity.editor.cursorIndex[1] = 1
    activity.editor.cursorIndex[2] = '|'
    for j = 2, #cursor do
      if cursor[j] and cursor[j][2] == 'num' then
        for k = j + 1, #cursor do
          if not (cursor[k][2] == 'num' or (cursor[k][2] == 'sym' and cursor[k][1] == '.')) then
            for n = j + 1, k - 1 do
              cursor[j][1] = cursor[j][1] .. cursor[j + 1][1]
              table.remove(cursor, j + 1)
            end
            break
          elseif k == #cursor then
            for n = j + 1, k do
              cursor[j][1] = cursor[j][1] .. cursor[j + 1][1]
              table.remove(cursor, j + 1)
            end
            break
          end
        end
      end
    end
    local i = cursor[1][1]
    local j = cursor[1][2]
    table.remove(cursor, 1)
    activity.blocks[activity.objects.name].block[i].data.params[j] = table.copy(cursor)
    activity.blocks[activity.objects.name].block[i].params[j].text.text = getTextParams(i, j)
    activity.editor.group.isVisible = false
    activity.editor.undoredo = {}
    activity.editor.undoredoi = 1
    activity.editor.undoredocursor = {}
    activity.editor.targetGroup:removeSelf()
    activity.returnModule('editor')
    activity.blocks.view()
    activity.blocksFileUpdate()
  else if activity.editor.cursorIndex[2] == '|' then
    table.insert(cursor, activity.editor.cursorIndex[1], {id, type})
    activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 1
    activity.editor.cursorIndex[2] = '|' activity.editor.genText()
  end end
end) end

activity.editor.funcList = function(id, ID)
  local cursor = activity.editor.cursor

  if id == ',' and ID == 'log' then ID = 'sym' end table.insert(cursor, activity.editor.cursorIndex[1], {id, ID})
  if not ((id == ',' and ID == 'sym') or id == 'pi' or id == 'unix_time' or ID == 'log' or ID == 'table' or ID == 'var'
  or ID == 'obj' or (ID == 'device' and not (id == 'finger_touching_screen_x' or id == 'finger_touching_screen_y'))) then
    table.insert(cursor, activity.editor.cursorIndex[1] + 1, {'(', 'sym'})
    table.insert(cursor, activity.editor.cursorIndex[1] + 2, {')', 'sym'})
    table.insert(cursor, activity.editor.cursorIndex[1] + 2, {'|', '|'})
    table.remove(cursor, activity.editor.cursorIndex[1] + 4)
    activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 2
    activity.editor.cursorIndex[2] = '|'
    if id == 'random' or id == 'round' or id == '%' or id == 'sub' or id == 'gsub' or id == 'power'
    or id == 'find' or id == 'match' or id == 'arctan2' then
      table.insert(cursor, activity.editor.cursorIndex[1] + 1, {',', 'sym'})
    end if id == 'sub' or id == 'gsub' then
      table.insert(cursor, activity.editor.cursorIndex[1] + 1, {',', 'sym'})
    end
  else
    activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 1
    activity.editor.cursorIndex[2] = '|'
  end

  activity.editor.genText()
end
