activity.onClickButton.textures = {}

activity.onClickButton.textures.add = function(e)
  activity.textures[activity.objects.texture].scroll:setIsLocked(true, 'vertical')

  input(strings.enterTitle, strings.enterTitleTextureText, function(event) activity.onInputEvent(event, activity.textures[activity.objects.texture].data, 'textures') end, function(e)
    activity.textures[activity.objects.texture].scroll:setIsLocked(false, 'vertical')

    if e.input then
      e.text = activity.onInputEvent({phase='ok', text=e.text}, activity.textures[activity.objects.texture].data, 'textures')

      local data = ccodeToJson(activity.programs.name)
      local importType = 'linear'

      for i = 1, #activity.objects[activity.scenes.name].block do
        if activity.objects[activity.scenes.name].block[i].text.text == activity.objects.object then
          importType = activity.objects[activity.scenes.name].block[i].import
          break
        end
      end

      for i = 1, #data.scenes do
        if data.scenes[i].name == activity.scenes.scene then
          for j = 1, #data.scenes[i].objects do
            if data.scenes[i].objects[j].name == activity.objects.object then
              data.scenes[i].objects[j].textures[#data.scenes[i].objects[j].textures + 1] = e.text
            end
          end
        end
      end

      local completeImportPicture = function(import)
        if import.done then
          if import.done == 'ok' then
            local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', activity.programs.name, activity.programs.name)
            local file = io.open(path, 'w')
            if file then file:write(jsonToCCode(data)) io.close(file) end

            if #activity.textures[activity.objects.texture].block == 0 then
              activity.textures[activity.objects.texture].data[1] = e.text
              activity.newBlock({
                i = 1,
                group = activity.textures[activity.objects.texture],
                type = 'textures',
                name = activity.objects.texture,
                import = importType
              })

              for j = 1, #activity.objects[activity.scenes.name].block do
                if activity.objects[activity.scenes.name].block[j].text.text == activity.objects.object then
                  activity.objects[activity.scenes.name].block[j].json = {[1] = e.text}
                  break
                end
              end

              for j = 1, #activity.objects[activity.scenes.name].block do
                if activity.objects[activity.scenes.name].block[j].text.text == activity.objects.object then
                  activity.objects[activity.scenes.name].block[j].container:removeSelf()

                  timer.performWithDelay(1, function()
                    activity.newTexture(j, {
                      group = activity.objects[activity.scenes.name],
                      type = 'objects'
                    })

                    activity.objects[activity.scenes.name].scroll:insert(activity.objects[activity.scenes.name].block[j].container)
                    activity.objects[activity.scenes.name].scroll:setScrollHeight(activity.objects[activity.scenes.name].scrollHeight)
                  end)

                  break
                end
              end
            else
              activity.move({
                text = {text = e.text},
                y = _y - 165,
                import = importType
              }, 'move', 'textures', activity.objects.texture, true)
            end
          end
        end
      end

      if settings.stdImport then
        local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name
        local fileName = string.format('%s.%s.%s', activity.scenes.scene, activity.objects.object, e.text)
        library.pickFile(path, completeImportPicture, fileName, '', 'image/*', nil, nil, nil)
      else
        activity.textures.hide()
        activity.textures[activity.objects.texture].importActive = true
        fsd({
          toPath = {'.jpg', '.jpeg', '.png', '.bmp', '.gif'},
          toFile = string.format('%s/%s/%s.%s.%s',
            system.pathForFile('', system.DocumentsDirectory), activity.programs.name, activity.scenes.scene, activity.objects.object, e.text),
          listener = function(import)
            activity.textures.view()
            if import then
              completeImportPicture({done='ok'})
            end
            timer.performWithDelay(1, function() activity.textures[activity.objects.texture].importActive = false end)
          end
        })
      end
    end
  end)
end

activity.onClickButton.textures.play = function(e)
  activity.textures.hide()
  startProject(activity.programs.name, 'textures')
end

activity.onClickButton.textures.list = function(e)
  if #activity.textures[activity.objects.texture].block > 0 then
    activity.textures[activity.objects.texture].scroll:setIsLocked(true, 'vertical')

    list({activity.objects.object, strings.remove, strings.copy, strings.changeTexture, strings.rename}, {x = e.target.x, y = e.target.y, targetHeight = e.target.height, activeBut = activity.objects.object}, function(event)
      activity.textures[activity.objects.texture].scroll:setIsLocked(false, 'vertical')

      activity.textures[activity.objects.texture].alertActive = event.num > 1
      activity.textures[activity.objects.texture].listMany = event.num == 2
      if event.num > 1 then
        activity.textures.add.isVisible = false
        activity.textures.play.isVisible = false
        activity.textures.okay.isVisible = true
        activity.textures.okay.num = event.num
        for i = 1, #activity.textures[activity.objects.texture].block do
          activity.textures[activity.objects.texture].block[i].checkbox.isVisible = true
        end
        activity.textures.act.text = '(' .. event.text .. ')'
      end
    end)
  end
end

activity.onClickButton.textures.okay = function(e)
  activity.textures[activity.objects.texture].alertActive = false
  activity.textures[activity.objects.texture].listPressNum = 1
  activity.onClickButton.textures[e.target.num]()

  activity.textures.add.isVisible = true
  activity.textures.play.isVisible = true
  activity.textures.okay.isVisible = false
  for i = 1, #activity.textures[activity.objects.texture].block do
    activity.textures[activity.objects.texture].block[i].checkbox.isVisible = false
    activity.textures[activity.objects.texture].block[i].checkbox:setState({isOn=false})
  end
  activity.textures.act.text = ''
end

activity.onClickButton.textures.block = function(e)
  -- Блок никуда не должен перекидывать
  -- Так что бессмысленно писать что-то сюда
  -- Но без этой функции будет ошибка
end

activity.onClickButton.textures[1] = function()
  -- Кнопка никуда не должна перекидывать
  -- Так что бессмысленно писать что-то сюда
  -- Но без этой функции будет ошибка
end

activity.onClickButton.textures[2] = function()
  local i = 0
  while i < #activity.textures[activity.objects.texture].block do
    i = i + 1
    if activity.textures[activity.objects.texture].block[i].checkbox.isOn then
      activity.onFile.textures('remove', i)

      for file in lfs.dir(system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name) do
        local theFile = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/' .. file
        if type(theFile) ~= 'string' then theFile = '' end

        if lfs.attributes(theFile, 'mode') ~= 'directory' then
          pcall(function()
            local nameScene, nameObject, nameTexture = utf8.match(file, '(.*)%.(.*)%.(.*)')
            if nameScene == activity.scenes.scene and nameObject == activity.objects.object and nameTexture == activity.textures[activity.objects.texture].block[i].text.text then
              os.remove(theFile)
            end
          end)
        end
      end

      table.remove(activity.textures[activity.objects.texture].data, i)

      activity.textures[activity.objects.texture].scrollHeight = activity.textures[activity.objects.texture].scrollHeight - 153
      activity.textures[activity.objects.texture].scroll:setScrollHeight(activity.textures[activity.objects.texture].scrollHeight)

      activity.textures[activity.objects.texture].block[i].container:removeSelf()
      activity.textures[activity.objects.texture].block[i].checkbox:removeSelf()
      activity.textures[activity.objects.texture].block[i].text:removeSelf()
      activity.textures[activity.objects.texture].block[i]:removeSelf()

      table.remove(activity.textures[activity.objects.texture].block, i)

      for j = 1, #activity.textures[activity.objects.texture].block do
        activity.textures[activity.objects.texture].block[j].y = 79 + 153 * (j-1)
        activity.textures[activity.objects.texture].block[j].num = j
        activity.textures[activity.objects.texture].block[j].text.y = 79 + 153 * (j-1)
        activity.textures[activity.objects.texture].block[j].checkbox.y = 79 + 153 * (j-1)
        activity.textures[activity.objects.texture].block[j].container.y = 79 + 153 * (j-1)
      end

      for j = 1, #activity.objects[activity.scenes.name].block do
        if activity.objects[activity.scenes.name].block[j].text.text == activity.objects.object then
          table.remove(activity.objects[activity.scenes.name].block[j].json, i)
          break
        end
      end

      if i == 1 then
        for j = 1, #activity.objects[activity.scenes.name].block do
          if activity.objects[activity.scenes.name].block[j].text.text == activity.objects.object then
            activity.objects[activity.scenes.name].block[j].container:removeSelf()

            timer.performWithDelay(1, function()
              activity.newTexture(j, {
                group = activity.objects[activity.scenes.name],
                type = 'objects'
              })

              activity.objects[activity.scenes.name].scroll:insert(activity.objects[activity.scenes.name].block[j].container)
              activity.objects[activity.scenes.name].scroll:setScrollHeight(activity.objects[activity.scenes.name].scrollHeight)
            end)

            break
          end
        end
      end

      i = i - 1
    end
  end
end

activity.onClickButton.textures[3] = function()
  for i = 1, #activity.textures[activity.objects.texture].block do
    if activity.textures[activity.objects.texture].block[i].checkbox.isOn then
      activity.move(activity.textures[activity.objects.texture].block[i], 'copy', 'textures', activity.objects.texture)
      break
    end
  end
end

activity.onClickButton.textures[4] = function()
  for i = 1, #activity.textures[activity.objects.texture].block do
    if activity.textures[activity.objects.texture].block[i].checkbox.isOn then
      local importType = activity.textures[activity.objects.texture].block[i].import

      local completeImportPicture = function(import)
        if import.done then
          if import.done == 'ok' then
            activity.textures[activity.objects.texture].block[i].container:removeSelf()

            if i == 1 then
              for j = 1, #activity.objects[activity.scenes.name].block do
                if activity.objects[activity.scenes.name].block[j].text.text == activity.objects.object then
                  activity.objects[activity.scenes.name].block[j].container:removeSelf()

                  timer.performWithDelay(1, function()
                    activity.newTexture(j, {
                      group = activity.objects[activity.scenes.name],
                      type = 'objects'
                    })

                    activity.objects[activity.scenes.name].scroll:insert(activity.objects[activity.scenes.name].block[j].container)
                    activity.objects[activity.scenes.name].scroll:setScrollHeight(activity.objects[activity.scenes.name].scrollHeight)

                    activity.newTexture(i, {
                      group = activity.textures[activity.objects.texture],
                      type = 'textures'
                    })

                    activity.textures[activity.objects.texture].scroll:insert(activity.textures[activity.objects.texture].block[i].container)
                    activity.textures[activity.objects.texture].scroll:setScrollHeight(activity.textures[activity.objects.texture].scrollHeight)
                  end)

                  break
                end
              end
            else
              timer.performWithDelay(1, function()
                activity.newTexture(i, {
                  group = activity.textures[activity.objects.texture],
                  type = 'textures'
                })

                activity.textures[activity.objects.texture].scroll:insert(activity.textures[activity.objects.texture].block[i].container)
                activity.textures[activity.objects.texture].scroll:setScrollHeight(activity.textures[activity.objects.texture].scrollHeight)
              end)
            end
          end
        end
      end

      if settings.stdImport then
        local path = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name
        local fileName = string.format('%s.%s.%s', activity.scenes.scene, activity.objects.object, activity.textures[activity.objects.texture].block[i].text.text)
        library.pickFile(path, completeImportPicture, fileName, '', 'image/*', nil, nil, nil)
      else
        activity.textures.hide()
        activity.textures[activity.objects.texture].importActive = true
        fsd({
          toPath = {'.jpg', '.jpeg', '.png', '.bmp', '.gif'},
          toFile = string.format('%s/%s/%s.%s.%s',
            system.pathForFile('', system.DocumentsDirectory), activity.programs.name, activity.scenes.scene, activity.objects.object, activity.textures[activity.objects.texture].block[i].text.text),
          listener = function(import)
            activity.textures.view()
            if import then
              completeImportPicture({done='ok'})
            end
            timer.performWithDelay(1, function() activity.textures[activity.objects.texture].importActive = false end)
          end
        })
      end
      break
    end
  end
end

activity.onClickButton.textures[5] = function()
  for i = 1, #activity.textures[activity.objects.texture].block do
    if activity.textures[activity.objects.texture].block[i].checkbox.isOn then
      activity.textures[activity.objects.texture].scroll:setIsLocked(true, 'vertical')

      input(strings.enterName, strings.enterNewTitleObjectText, function(event) activity.onInputEvent(event, activity.textures[activity.objects.texture].data, 'textures') end, function(event)
        activity.textures[activity.objects.texture].scroll:setIsLocked(false, 'vertical')

        if event.input then
          event.text = activity.onInputEvent({phase='ok', text=event.text}, activity.textures[activity.objects.texture].data, 'textures')

          local oldTitle = activity.textures[activity.objects.texture].block[i].text.text
          local textY = activity.textures[activity.objects.texture].block[i].text.y
          local textX = activity.textures[activity.objects.texture].block[i].text.x

          local text = display.newText({
            text = event.text, width = 340,
            x = 0, y = 0, font = 'ubuntu_!bold.ttf', fontSize = 40
          })
          activity.textures[activity.objects.texture].block[i].text:removeSelf()

          local textHeight = 48
          if text.height > 50 then textHeight = 96 end
          text:removeSelf()

          activity.textures[activity.objects.texture].block[i].text = display.newText({
            text = event.text, width = 340, height = textHeight,
            font = 'ubuntu_!bold.ttf', fontSize = 40, x = textX, y = textY
          })
          activity.textures[activity.objects.texture].block[i].text.anchorX = 0

          activity.textures[activity.objects.texture].scroll:insert(activity.textures[activity.objects.texture].block[i].text)
          activity.textures[activity.objects.texture].data[i] = event.text

          activity.onFile.textures('rename', i)

          for file in lfs.dir(system.pathForFile(activity.programs.name, system.DocumentsDirectory)) do
            local theFile = system.pathForFile(file, system.DocumentsDirectory)
            if type(theFile) ~= 'string' then theFile = '' end

            if lfs.attributes(theFile, 'mode') ~= 'directory' then
              pcall(function()
                local nameScene, nameObject, nameTexture = utf8.match(file, '(.*)%.(.*)%.(.*)')
                if nameScene == activity.scenes.scene and nameObject == activity.objects.object and nameTexture == oldTitle then
                  os.execute(string.format('mv "%s" "%s"',
                    system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                      activity.programs.name, nameScene, nameObject, nameTexture),
                    system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                      activity.programs.name, nameScene, nameObject, event.text)))
                end
              end)
            end
          end

          activity.textures[activity.objects.texture].block[i].container:removeSelf()

          for j = 1, #activity.objects[activity.scenes.name].block do
            if activity.objects[activity.scenes.name].block[j].text.text == activity.objects.object then
              activity.objects[activity.scenes.name].block[j].json[i] = event.text
              break
            end
          end

          if i == 1 then
            for j = 1, #activity.objects[activity.scenes.name].block do
              if activity.objects[activity.scenes.name].block[j].text.text == activity.objects.object then
                activity.objects[activity.scenes.name].block[j].container:removeSelf()

                timer.performWithDelay(1, function()
                  activity.newTexture(j, {
                    group = activity.objects[activity.scenes.name],
                    type = 'objects'
                  })

                  activity.objects[activity.scenes.name].scroll:insert(activity.objects[activity.scenes.name].block[j].container)
                  activity.objects[activity.scenes.name].scroll:setScrollHeight(activity.objects[activity.scenes.name].scrollHeight)

                  activity.newTexture(i, {
                    group = activity.textures[activity.objects.texture],
                    type = 'textures'
                  })

                  activity.textures[activity.objects.texture].scroll:insert(activity.textures[activity.objects.texture].block[i].container)
                  activity.textures[activity.objects.texture].scroll:setScrollHeight(activity.textures[activity.objects.texture].scrollHeight)
                end)

                break
              end
            end
          else
            timer.performWithDelay(1, function()
              activity.newTexture(i, {
                group = activity.textures[activity.objects.texture],
                type = 'textures'
              })

              activity.textures[activity.objects.texture].scroll:insert(activity.textures[activity.objects.texture].block[i].container)
              activity.textures[activity.objects.texture].scroll:setScrollHeight(activity.textures[activity.objects.texture].scrollHeight)
            end)
          end
        end
      end, activity.textures[activity.objects.texture].block[i].text.text)
      break
    end
  end
end
