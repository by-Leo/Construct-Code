activity.onClickButton.scenes = {}

activity.onClickButton.scenes.add = function(e)
  activity.scenes[activity.programs.name].scroll:setIsLocked(true, 'vertical')

  input(strings.enterTitle, strings.enterTitleSceneText, function(event) activity.onInputEvent(event, activity.scenes[activity.programs.name].data, 'scenes') end, function(e)
    activity.scenes[activity.programs.name].scroll:setIsLocked(false, 'vertical')

    if e.input then
      e.text = activity.onInputEvent({phase='ok', text=e.text}, activity.scenes[activity.programs.name].data, 'scenes')

      local data = ccodeToJson(activity.programs.name)
      local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
      local file = io.open(path, 'w')

      data.scenes[#data.scenes + 1] = {name = e.text, objects = {}}

      if file then
        file:write(jsonToCCode(data))
        io.close(file)
      end

      if #activity.scenes[activity.programs.name].block == 0 then
        activity.scenes[activity.programs.name].data[1] = e.text
        activity.newBlock({
          i = 1,
          group = activity.scenes[activity.programs.name],
          type = 'scenes',
          name = activity.programs.name
        })
      else
        activity.move({
          text = {text = e.text},
          y = _y - 165
        }, 'move', 'scenes', activity.programs.name, true)
      end
    end
  end)
end

activity.onClickButton.scenes.play = function(e)
  activity.scenes.hide()
  startProject(activity.programs.name, 'scenes')
end

activity.onClickButton.scenes.list = function(e)
  if #activity.scenes[activity.programs.name].block > 0 then
    activity.scenes[activity.programs.name].scroll:setIsLocked(true, 'vertical')

    list({activity.programs.name, strings.remove, strings.copy, strings.editScene, strings.rename, strings.resource}, {x = e.target.x, y = e.target.y, targetHeight = e.target.height, activeBut = activity.programs.name}, function(event)
      activity.scenes[activity.programs.name].scroll:setIsLocked(false, 'vertical')

      activity.scenes[activity.programs.name].alertActive = event.num > 1 and event.num ~= 6
      activity.scenes[activity.programs.name].listMany = event.num == 2
      if event.num > 1 and event.num < 6 then
        activity.scenes.add.isVisible = false
        activity.scenes.play.isVisible = false
        activity.scenes.okay.isVisible = true
        activity.scenes.okay.num = event.num
        for i = 1, #activity.scenes[activity.programs.name].block do
          activity.scenes[activity.programs.name].block[i].checkbox.isVisible = true
        end
        activity.scenes.act.text = '(' .. event.text .. ')'
      elseif event.num == 6 then
        activity.scenes.hide()
        activity.resources.create()
      end
    end)
  end
end

activity.onClickButton.scenes.okay = function(e)
  activity.scenes[activity.programs.name].alertActive = false
  activity.scenes[activity.programs.name].listPressNum = 1
  activity.onClickButton.scenes[e.target.num]()

  activity.scenes.add.isVisible = true
  activity.scenes.play.isVisible = true
  activity.scenes.okay.isVisible = false
  for i = 1, #activity.scenes[activity.programs.name].block do
    activity.scenes[activity.programs.name].block[i].checkbox.isVisible = false
    activity.scenes[activity.programs.name].block[i].checkbox:setState({isOn=false})
  end
  activity.scenes.act.text = ''
end

activity.onClickButton.scenes.block = function(e)
  activity.scenes.name = activity.programs.name .. '.' .. e.target.text.text
  activity.scenes.scene = e.target.text.text
  activity.scenes.getVarFunTable()
  activity.scenes.hide()
  activity.objects.create()
end

activity.onClickButton.scenes[1] = function()
end

activity.onClickButton.scenes[2] = function()
  local i = 0
  while i < #activity.scenes[activity.programs.name].block do
    i = i + 1
    if activity.scenes[activity.programs.name].block[i].checkbox.isOn then
      activity.onFile.scenes('remove', i)

      table.remove(activity.scenes[activity.programs.name].data, i)

      local scenesName = activity.programs.name .. '.' .. activity.scenes[activity.programs.name].block[i].text.text
      local scenesScene = activity.scenes[activity.programs.name].block[i].text.text

      for file in lfs.dir(system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name) do
        local theFile = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/' .. file
        if type(theFile) ~= 'string' then theFile = '' end

        if lfs.attributes(theFile, 'mode') ~= 'directory' then
          pcall(function()
            local nameScene, nameObject, nameTexture = utf8.match(file, '(.*)%.(.*)%.(.*)')
            if nameScene == scenesScene then
              os.remove(theFile)
            end
          end)
        end
      end

      activity.scenes[activity.programs.name].scrollHeight = activity.scenes[activity.programs.name].scrollHeight - 153
      activity.scenes[activity.programs.name].scroll:setScrollHeight(activity.scenes[activity.programs.name].scrollHeight)

      activity.scenes[activity.programs.name].block[i].checkbox:removeSelf()
      activity.scenes[activity.programs.name].block[i].text:removeSelf()
      activity.scenes[activity.programs.name].block[i]:removeSelf()

      table.remove(activity.scenes[activity.programs.name].block, i)

      for j = 1, #activity.scenes[activity.programs.name].block do
        activity.scenes[activity.programs.name].block[j].y = 79 + 153 * (j-1)
        activity.scenes[activity.programs.name].block[j].num = j
        activity.scenes[activity.programs.name].block[j].text.y = 79 + 153 * (j-1)
        activity.scenes[activity.programs.name].block[j].checkbox.y = 79 + 153 * (j-1)
      end

      i = i - 1

      if activity.objects[scenesName] then
        for j = 1, #activity.objects[scenesName].block do
          local objectsTexture = scenesName .. '.' .. activity.objects[scenesName].block[j].text.text

          if activity.textures[objectsTexture] then
            activity.textures[objectsTexture].scroll:removeSelf()
            activity.textures[objectsTexture] = nil
          end

          if activity.blocks[objectsTexture] then
            activity.blocks[objectsTexture].scroll:removeSelf()
            activity.blocks[objectsTexture] = nil
          end
        end

        activity.objects[scenesName].scroll:removeSelf()
        activity.objects[scenesName] = nil
      end
    end
  end
end

activity.onClickButton.scenes[3] = function()
  for i = 1, #activity.scenes[activity.programs.name].block do
    if activity.scenes[activity.programs.name].block[i].checkbox.isOn then
      activity.move(activity.scenes[activity.programs.name].block[i], 'copy', 'scenes', activity.programs.name)
      break
    end
  end
end

activity.onClickButton.scenes[4] = function()
  alert('В разработке', 'Я не супермен и работаю один, поэтому, пока редактор уровней/групп/сцен не работает, в ближайшие 3 месяца он будет добавлен со всеми задуманными функциями', {strings.notexportok}, function(e) end)
end

activity.onClickButton.scenes[5] = function()
  for i = 1, #activity.scenes[activity.programs.name].block do
    if activity.scenes[activity.programs.name].block[i].checkbox.isOn then
      activity.scenes[activity.programs.name].scroll:setIsLocked(true, 'vertical')

      input(strings.enterTitle, strings.enterNewTitleSceneText, function(event) activity.onInputEvent(event, activity.scenes[activity.programs.name].data, 'scenes') end, function(event)
        activity.scenes[activity.programs.name].scroll:setIsLocked(false, 'vertical')

        if event.input then
          event.text = activity.onInputEvent({phase='ok', text=event.text}, activity.scenes[activity.programs.name].data, 'scenes')

          local oldTitle = activity.scenes[activity.programs.name].block[i].text.text
          local textY = activity.scenes[activity.programs.name].block[i].text.y
          local textX = activity.scenes[activity.programs.name].block[i].text.x

          local text = display.newText({
            text = event.text, width = 440,
            x = 0, y = 0, font = 'ubuntu_!bold.ttf', fontSize = 40
          })
          activity.scenes[activity.programs.name].block[i].text:removeSelf()

          local textHeight = 48
          if text.height > 50 then textHeight = 96 end
          text:removeSelf()

          activity.scenes[activity.programs.name].block[i].text = display.newText({
            text = event.text, width = 440, height = textHeight,
            font = 'ubuntu_!bold.ttf', fontSize = 40, x = textX, y = textY
          })
          activity.scenes[activity.programs.name].block[i].text.anchorX = 0

          activity.scenes[activity.programs.name].scroll:insert(activity.scenes[activity.programs.name].block[i].text)
          activity.scenes[activity.programs.name].data[i] = event.text

          activity.onFile.scenes('rename', i)

          local scenesName = activity.programs.name .. '.' .. oldTitle

          if activity.objects[scenesName] then
            for j = 1, #activity.objects[scenesName].block do
              local objectsTexture = scenesName .. '.' .. activity.objects[scenesName].block[j].text.text

              if activity.textures[objectsTexture] then
                activity.textures[objectsTexture].scroll:removeSelf()
                activity.textures[objectsTexture] = nil
              end

              if activity.blocks[objectsTexture] then
                activity.blocks[objectsTexture].scroll:removeSelf()
                activity.blocks[objectsTexture] = nil
              end
            end

            activity.objects[scenesName].scroll:removeSelf()
            activity.objects[scenesName] = nil
          end

          for file in lfs.dir(system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name) do
            local theFile = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/' .. file
            if type(theFile) ~= 'string' then theFile = '' end

            if lfs.attributes(theFile, 'mode') ~= 'directory' then
              pcall(function()
                local nameScene, nameObject, nameTexture = utf8.match(file, '(.*)%.(.*)%.(.*)')
                if nameScene == oldTitle then
                  os.execute(string.format('mv "%s" "%s"',
                    system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                      activity.programs.name, nameScene, nameObject, nameTexture),
                    system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                      activity.programs.name, event.text, nameObject, nameTexture)))
                end
              end)
            end
          end
        end
      end, activity.scenes[activity.programs.name].block[i].text.text)
      break
    end
  end
end
