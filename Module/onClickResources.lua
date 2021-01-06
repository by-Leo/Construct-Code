activity.onClickButton.resources = {}

activity.onClickButton.resources.add = function(e)
  activity.resources[activity.programs.name].scroll:setIsLocked(true, 'vertical')

  input(strings.enterTitle, strings.enterTitleResourceText, function(event)
    if event.phase == 'editing' then
      inputPermission(true)
      for i = 1, #activity.resources[activity.programs.name].block do
        if activity.resources[activity.programs.name].block[i].text.text == event.text then
          inputPermission(false)
          break
        end
      end
      for i = 1, utf8.len(event.text) do
        if utf8.find('?:"*|/\\<>!@#$&~%()[]{}\';`', utf8.sub(event.text, i, i), 1, true) or string.len(utf8.sub(event.text, i, i)) > 3 then
          inputPermission(false)
          break
        end
      end
      if utf8.find(event.text, '\n', 1, true) or utf8.len(event.text) == 0 or utf8.len(event.text) > 30 or utf8.byte(utf8.sub(event.text, 1, 1)) == 32 or utf8.byte(utf8.sub(event.text, utf8.len(event.text), utf8.len(event.text))) == 32 then
        inputPermission(false)
      end
    end
  end, function(e)
    activity.resources[activity.programs.name].scroll:setIsLocked(false, 'vertical')

    if e.input then
      for i = 1, #activity.resources[activity.programs.name].block do
        if activity.resources[activity.programs.name].block[i].text.text == e.text then
          e.text = 'Не используй T9_' .. math.random(111111111, 999999999)
          break
        end
      end
      for i = 1, utf8.len(e.text) do
        if utf8.find('?:"*|/\\<>!@#$&~%()[]{}\';`', utf8.sub(e.text, i, i), 1, true) or string.len(utf8.sub(e.text, i, i)) > 3 then
          e.text = 'Не используй T9_' .. math.random(111111111, 999999999)
          break
        end
      end
      if utf8.find(e.text, '\n', 1, true) or utf8.len(e.text) == 0 or utf8.len(e.text) > 30 or utf8.byte(utf8.sub(e.text, 1, 1)) == 32 or utf8.byte(utf8.sub(e.text, utf8.len(e.text), utf8.len(e.text))) == 32 then
        e.text = 'Не используй T9_' .. math.random(111111111, 999999999)
      end

      local completeImportPicture = function(import)
        if import.done then
          if import.done == 'ok' then
            activity.resources[activity.programs.name].data[#activity.resources[activity.programs.name].data + 1] = e.text
            activity.newBlock({
              i = #activity.resources[activity.programs.name].data,
              group = activity.resources[activity.programs.name],
              type = 'resources',
              name = activity.programs.name
            })
          end
        end
      end

      local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name
      local fileName = string.format('res .%s', e.text)
      library.pickFile(path, completeImportPicture, fileName, '', '*/*', nil, nil, nil)
    end
  end)
end

activity.onClickButton.resources.play = function(e)
  activity.resources.hide()
  startProject('App', 'resources')
end

activity.onClickButton.resources.list = function(e)
  if #activity.resources[activity.programs.name].block > 0 then
    activity.resources[activity.programs.name].scroll:setIsLocked(true, 'vertical')

    list({activity.programs.name, strings.remove, strings.rename}, {x = e.target.x, y = e.target.y, targetHeight = e.target.height, activeBut = activity.programs.name}, function(event)
      activity.resources[activity.programs.name].scroll:setIsLocked(false, 'vertical')

      activity.resources[activity.programs.name].alertActive = event.num > 1
      activity.resources[activity.programs.name].listMany = event.num == 2
      if event.num > 1 then
        activity.resources.add.isVisible = false
        activity.resources.play.isVisible = false
        activity.resources.okay.isVisible = true
        activity.resources.okay.num = event.num
        for i = 1, #activity.resources[activity.programs.name].block do
          activity.resources[activity.programs.name].block[i].checkbox.isVisible = true
        end
        activity.resources.act.text = '(' .. event.text .. ')'
      end
    end)
  end
end

activity.onClickButton.resources.okay = function(e)
  activity.resources[activity.programs.name].alertActive = false
  activity.resources[activity.programs.name].listPressNum = 1
  activity.onClickButton.resources[e.target.num]()

  activity.resources.add.isVisible = true
  activity.resources.play.isVisible = true
  activity.resources.okay.isVisible = false
  for i = 1, #activity.resources[activity.programs.name].block do
    activity.resources[activity.programs.name].block[i].checkbox.isVisible = false
    activity.resources[activity.programs.name].block[i].checkbox:setState({isOn=false})
  end
  activity.resources.act.text = ''
end

activity.onClickButton.resources.block = function() end

activity.onClickButton.resources[1] = function() end

activity.onClickButton.resources[2] = function()
  local i = 0
  while i < #activity.resources[activity.programs.name].block do
    i = i + 1
    if activity.resources[activity.programs.name].block[i].checkbox.isOn then
      local theFile = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/res .' .. activity.resources[activity.programs.name].block[i].text.text
      table.remove(activity.resources[activity.programs.name].data, i)
      os.remove(theFile)

      activity.resources[activity.programs.name].scrollHeight = activity.resources[activity.programs.name].scrollHeight - 153
      activity.resources[activity.programs.name].scroll:setScrollHeight(activity.resources[activity.programs.name].scrollHeight)

      activity.resources[activity.programs.name].block[i].checkbox:removeSelf()
      activity.resources[activity.programs.name].block[i].text:removeSelf()
      activity.resources[activity.programs.name].block[i]:removeSelf()

      table.remove(activity.resources[activity.programs.name].block, i)

      for j = 1, #activity.resources[activity.programs.name].block do
        activity.resources[activity.programs.name].block[j].y = 79 + 153 * (j-1)
        activity.resources[activity.programs.name].block[j].num = j
        activity.resources[activity.programs.name].block[j].text.y = 79 + 153 * (j-1)
        activity.resources[activity.programs.name].block[j].checkbox.y = 79 + 153 * (j-1)
      end i = i - 1
    end
  end
end

activity.onClickButton.resources[3] = function()
  local i = 0
  while i < #activity.resources[activity.programs.name].block do
    i = i + 1
    if activity.resources[activity.programs.name].block[i].checkbox.isOn then
      activity.scenes[activity.programs.name].scroll:setIsLocked(true, 'vertical')
      input(strings.enterTitle, strings.enterNewTitleResourceText, function(event)
        if event.phase == 'editing' then
          inputPermission(true)
          for i = 1, #activity.resources[activity.programs.name].block do
            if activity.resources[activity.programs.name].block[i].text.text == event.text then
              inputPermission(false)
              break
            end
          end
          for i = 1, utf8.len(event.text) do
            if utf8.find('?:"*|/\\<>!@#$&~%()[]{}\';`', utf8.sub(event.text, i, i), 1, true) or string.len(utf8.sub(event.text, i, i)) > 3 then
              inputPermission(false)
              break
            end
          end
          if utf8.find(event.text, '\n', 1, true) or utf8.len(event.text) == 0 or utf8.len(event.text) > 30 or utf8.byte(utf8.sub(event.text, 1, 1)) == 32 or utf8.byte(utf8.sub(event.text, utf8.len(event.text), utf8.len(event.text))) == 32 then
            inputPermission(false)
          end
        end
      end, function(e)
        activity.scenes[activity.programs.name].scroll:setIsLocked(false, 'vertical')
        if e.input then
          for i = 1, #activity.resources[activity.programs.name].block do
            if activity.resources[activity.programs.name].block[i].text.text == e.text then
              e.text = 'Не используй T9_' .. math.random(111111111, 999999999)
              break
            end
          end
          for i = 1, utf8.len(e.text) do
            if utf8.find('?:"*|/\\<>!@#$&~%()[]{}\';`', utf8.sub(e.text, i, i), 1, true) or string.len(utf8.sub(e.text, i, i)) > 3 then
              e.text = 'Не используй T9_' .. math.random(111111111, 999999999)
              break
            end
          end
          if utf8.find(e.text, '\n', 1, true) or utf8.len(e.text) == 0 or utf8.len(e.text) > 30 or utf8.byte(utf8.sub(e.text, 1, 1)) == 32 or utf8.byte(utf8.sub(e.text, utf8.len(e.text), utf8.len(e.text))) == 32 then
            e.text = 'Не используй T9_' .. math.random(111111111, 999999999)
          end
          local oldFile = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/res .' .. activity.resources[activity.programs.name].block[i].text.text
          local theFile = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/res .' .. e.text
          activity.resources[activity.programs.name].data[i] = e.text
          activity.resources[activity.programs.name].block[i].text.text = e.text
          os.rename(oldFile, theFile)
        end
      end, activity.resources[activity.programs.name].block[i].text.text) break
    end
  end
end
