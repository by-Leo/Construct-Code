activity.onClickButton.objects = {}

activity.onClickButton.objects.add = function(e)
  activity.objects[activity.scenes.name].scroll:setIsLocked(true, 'vertical')

  input(strings.enterTitle, strings.enterTitleObjectText, function(event) activity.onInputEvent(event, activity.objects[activity.scenes.name].data, 'objects') end, function(e)
    activity.objects[activity.scenes.name].scroll:setIsLocked(false, 'vertical')

    if e.input then
      e.text = activity.onInputEvent({phase='ok', text=e.text}, activity.objects[activity.scenes.name].data, 'objects')

      alert(strings.whichObject, strings.chooseTypeObject, {strings.noPixelImage, strings.pixelImage}, function(event)
        if event.num ~= 0 then
          local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
          local file = io.open(path, 'r')
          local bool = false
          local newData = ''
          local importType = event.num == 1 and 'linear' or 'nearest'

          if file then
            for line in file:lines() do
              if utf8.sub(line, 1, 3) == '  s' then
                if bool then newData = event.isOn == false and string.format('%s\n    o %s:["%s"]/%s\n      e onStart:[]/false', newData, e.text, e.text, importType) or string.format('%s\n    o %s:[]/%s\n      e onStart:[]/false', newData, e.text, importType) end
                bool = activity.programs.name .. '.' .. utf8.match(line, '  s (.*)') == activity.scenes.name
                newData = newData .. '\n' .. line
              else
                if newData == '' then newData = line
                else newData = newData .. '\n' .. line end
              end
            end
            if bool then
              newData = event.isOn == false and string.format('%s\n    o %s:["%s"]/%s\n      e onStart:[]/false', newData, e.text, e.text, importType) or string.format('%s\n    o %s:[]/%s\n      e onStart:[]/false', newData, e.text, importType)
            end
            io.close(file)
          end

          local completeImportPicture = function(import)
            if import.done then
              if import.done == 'ok' then
                local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
                local file = io.open(path, 'w')

                if file then
                  file:write(newData)
                  io.close(file)
                end

                if #activity.objects[activity.scenes.name].block == 0 then
                  activity.objects[activity.scenes.name].data[1] = e.text
                  activity.newBlock({
                    i = 1,
                    group = activity.objects[activity.scenes.name],
                    type = 'objects',
                    name = activity.scenes.name,
                    import = importType,
                    json = event.isOn == false and {e.text} or {}
                  })
                else
                  activity.move({
                    text = {text = e.text},
                    y = _y - 165,
                    import = importType,
                    json = event.isOn == false and {e.text} or {}
                  }, 'move', 'objects', activity.scenes.name, true)
                end
              end
            end
          end

          if event.isOn == false then
            if settings.stdImport then
              local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name
              local fileName = string.format('%s.%s.%s', activity.scenes.scene, e.text, e.text)
              library.pickFile(path, completeImportPicture, fileName, '', 'image/*', nil, nil, nil)
            else
              activity.objects.hide()
              activity.objects[activity.scenes.name].importActive = true
              fsd({
                toPath = {'.jpg', '.jpeg', '.png', '.bmp', '.gif'},
                toFile = string.format('%s/%s/%s.%s.%s',
                  system.pathForFile('', system.DocumentsDirectory), activity.programs.name, activity.scenes.scene, e.text, e.text),
                listener = function(import)
                  activity.objects.view()
                  if import then
                    completeImportPicture({done='ok'})
                  end
                  timer.performWithDelay(1, function() activity.objects[activity.scenes.name].importActive = false end)
                end
              })
            end
          else
            completeImportPicture({done='ok'})
          end
        end
      end, strings.noTexture)
    end
  end)
end

activity.onClickButton.objects.play = function(e)
end

activity.onClickButton.objects.list = function(e)
  if #activity.objects[activity.scenes.name].block > 0 then
    activity.objects[activity.scenes.name].scroll:setIsLocked(true, 'vertical')

    list({activity.scenes.scene, strings.remove, strings.copy, strings.textures, strings.rename}, {x = e.target.x, y = e.target.y, targetHeight = e.target.height, activeBut = activity.scenes.scene}, function(event)
      activity.objects[activity.scenes.name].scroll:setIsLocked(false, 'vertical')

      activity.objects[activity.scenes.name].alertActive = event.num > 1
      activity.objects[activity.scenes.name].listMany = event.num == 2
      if event.num > 1 then
        activity.objects.add.isVisible = false
        activity.objects.play.isVisible = false
        activity.objects.okay.isVisible = true
        activity.objects.okay.num = event.num
        for i = 1, #activity.objects[activity.scenes.name].block do
          activity.objects[activity.scenes.name].block[i].checkbox.isVisible = true
        end
        activity.objects.act.text = '(' .. event.text .. ')'
      end
    end)
  end
end

activity.onClickButton.objects.okay = function(e)
  activity.objects[activity.scenes.name].alertActive = false
  activity.objects[activity.scenes.name].listPressNum = 1
  activity.onClickButton.objects[e.target.num]()

  activity.objects.add.isVisible = true
  activity.objects.play.isVisible = true
  activity.objects.okay.isVisible = false
  for i = 1, #activity.objects[activity.scenes.name].block do
    activity.objects[activity.scenes.name].block[i].checkbox.isVisible = false
    activity.objects[activity.scenes.name].block[i].checkbox:setState({isOn=false})
  end
  activity.objects.act.text = ''
end

activity.onClickButton.objects.block = function(e)
  activity.objects.name = activity.scenes.name .. '.' .. e.target.text.text
  activity.objects.object = e.target.text.text
  activity.objects.hide()
  activity.blocks.create()
end

activity.onClickButton.objects[1] = function()
end

activity.onClickButton.objects[2] = function()
  local i = 0
  while i < #activity.objects[activity.scenes.name].block do
    i = i + 1
    if activity.objects[activity.scenes.name].block[i].checkbox.isOn then
      local objectsTexture = activity.scenes.name .. '.' .. activity.objects[activity.scenes.name].block[i].text.text

      activity.onFileRead.objects({
        name = 'remove',
        index = i
      })

      for file in lfs.dir(system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name) do
        local theFile = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/' .. file
        if type(theFile) ~= 'string' then theFile = '' end

        if lfs.attributes(theFile, 'mode') ~= 'directory' then
          pcall(function()
            local nameScene, nameObject, nameTexture = utf8.match(file, '(.*)%.(.*)%.(.*)')
            if nameScene == activity.scenes.scene and nameObject == activity.objects[activity.scenes.name].block[i].text.text then
              os.remove(theFile)
            end
          end)
        end
      end

      table.remove(activity.objects[activity.scenes.name].data, i)

      activity.objects[activity.scenes.name].scrollHeight = activity.objects[activity.scenes.name].scrollHeight - 153
      activity.objects[activity.scenes.name].scroll:setScrollHeight(activity.objects[activity.scenes.name].scrollHeight)

      activity.objects[activity.scenes.name].block[i].container:removeSelf()
      activity.objects[activity.scenes.name].block[i].checkbox:removeSelf()
      activity.objects[activity.scenes.name].block[i].text:removeSelf()
      activity.objects[activity.scenes.name].block[i]:removeSelf()

      table.remove(activity.objects[activity.scenes.name].block, i)

      for j = 1, #activity.objects[activity.scenes.name].block do
        activity.objects[activity.scenes.name].block[j].y = 79 + 153 * (j-1)
        activity.objects[activity.scenes.name].block[j].num = j
        activity.objects[activity.scenes.name].block[j].text.y = 79 + 153 * (j-1)
        activity.objects[activity.scenes.name].block[j].checkbox.y = 79 + 153 * (j-1)
        activity.objects[activity.scenes.name].block[j].container.y = 79 + 153 * (j-1)
      end

      i = i - 1

      if activity.textures[objectsTexture] then
        activity.textures[objectsTexture].scroll:removeSelf()
        activity.textures[objectsTexture] = nil
      end
    end
  end
end

activity.onClickButton.objects[3] = function()
  for i = 1, #activity.objects[activity.scenes.name].block do
    if activity.objects[activity.scenes.name].block[i].checkbox.isOn then
      activity.move(activity.objects[activity.scenes.name].block[i], 'copy', 'objects', activity.scenes.name)
      break
    end
  end
end

activity.onClickButton.objects[4] = function()
  for i = 1, #activity.objects[activity.scenes.name].block do
    if activity.objects[activity.scenes.name].block[i].checkbox.isOn then
      activity.objects.texture = activity.scenes.name .. '.' .. activity.objects[activity.scenes.name].block[i].text.text
      activity.objects.object = activity.objects[activity.scenes.name].block[i].text.text
      activity.objects.hide()
      activity.textures.create()
      break
    end
  end
end

activity.onClickButton.objects[5] = function()
  for i = 1, #activity.objects[activity.scenes.name].block do
    if activity.objects[activity.scenes.name].block[i].checkbox.isOn then
      activity.objects[activity.scenes.name].scroll:setIsLocked(true, 'vertical')

      input(strings.enterName, strings.enterNewTitleObjectText, function(event) activity.onInputEvent(event, activity.objects[activity.scenes.name].data, 'objects') end, function(event)
        activity.objects[activity.scenes.name].scroll:setIsLocked(false, 'vertical')

        if event.input then
          event.text = activity.onInputEvent({phase='ok', text=event.text}, activity.objects[activity.scenes.name].data, 'objects')

          local oldTitle = activity.objects[activity.scenes.name].block[i].text.text
          local textY = activity.objects[activity.scenes.name].block[i].text.y
          local textX = activity.objects[activity.scenes.name].block[i].text.x

          local text = display.newText({
            text = event.text, width = 340,
            x = 0, y = 0, font = 'ubuntu_!bold.ttf', fontSize = 40
          })
          activity.objects[activity.scenes.name].block[i].text:removeSelf()

          local textHeight = 48
          if text.height > 50 then textHeight = 96 end
          text:removeSelf()

          activity.objects[activity.scenes.name].block[i].text = display.newText({
            text = event.text, width = 340, height = textHeight,
            font = 'ubuntu_!bold.ttf', fontSize = 40, x = textX, y = textY
          })
          activity.objects[activity.scenes.name].block[i].text.anchorX = 0

          activity.objects[activity.scenes.name].scroll:insert(activity.objects[activity.scenes.name].block[i].text)
          activity.objects[activity.scenes.name].data[i] = event.text

          activity.onFileRead.objects({
            name = 'rename',
            index = i,
            oldTitle = oldTitle
          })

          local objectsTexture = activity.scenes.name .. '.' .. oldTitle

          if activity.textures[objectsTexture] then
            activity.textures[objectsTexture].scroll:removeSelf()
            activity.textures[objectsTexture] = nil
          end

          activity.objects[activity.scenes.name].block[i].container:removeSelf()

          for file in lfs.dir(system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name) do
            local theFile = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/' .. file
            if type(theFile) ~= 'string' then theFile = '' end

            if lfs.attributes(theFile, 'mode') ~= 'directory' then
              pcall(function()
                local nameScene, nameObject, nameTexture = utf8.match(file, '(.*)%.(.*)%.(.*)')
                if nameScene == activity.scenes.scene and nameObject == oldTitle then
                  os.execute(string.format('mv "%s" "%s"',
                    system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                      activity.programs.name, nameScene, nameObject, nameTexture),
                    system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                      activity.programs.name, nameScene, event.text, nameTexture)))
                end
              end)
            end
          end

          timer.performWithDelay(1, function()
            activity.newTexture(i, {
              group = activity.objects[activity.scenes.name],
              type = 'objects'
            })

            activity.objects[activity.scenes.name].scroll:insert(activity.objects[activity.scenes.name].block[i].container)
            activity.objects[activity.scenes.name].scroll:setScrollHeight(activity.objects[activity.scenes.name].scrollHeight)
          end)
        end
      end, activity.objects[activity.scenes.name].block[i].text.text)
      break
    end
  end
end
