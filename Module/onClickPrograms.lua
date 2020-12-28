activity.onClickButton.programs = {}

activity.onClickButton.programs.add = function(e)
  activity.programs['nil'].scroll:setIsLocked(true, "vertical")

  alert(strings.chooseOrientation, strings.chooseOrientationText, {strings.portrait, strings.landscape}, function(event)
    if event.num ~= 0 then
      input(strings.enterTitle, strings.enterTitleProgramText, function(event) activity.onInputEvent(event, activity.programs['nil'].data, 'programs') end, function(e)
        activity.programs['nil'].scroll:setIsLocked(false, "vertical")

        if e.input then
          e.text = activity.onInputEvent({phase='ok', text=e.text}, activity.programs['nil'].data, 'programs')

          local path = system.pathForFile('Programs.txt', system.DocumentsDirectory)
          local file = io.open(path, 'w')

          if file then
            local newData = ''
            for i = 1, #activity.programs['nil'].data do
              newData = newData .. activity.programs['nil'].data[i] .. '\n'
            end
            file:write(newData .. e.text)
            io.close(file)
          end

          lfs.mkdir(system.pathForFile(e.text, system.DocumentsDirectory))

          local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', e.text, e.text)
          local file = io.open(path, 'w')

          if file then
            local orientation = event.num == 1 and 'portrait' or 'landscape'
            file:write(string.format('p %s\n  s ' .. strings.firstScene, orientation))
            io.close(file)
          end

          activity.programs['nil'].data[#activity.programs['nil'].data+1] = e.text
          activity.newBlock({
            i = #activity.programs['nil'].data,
            group = activity.programs['nil'],
            type = 'programs',
            name = 'nil'
          })
        end
      end)
    else
      activity.programs['nil'].scroll:setIsLocked(false, "vertical")
    end
  end)
end

activity.onClickButton.programs.import = function(e)
end

activity.onClickButton.programs.list = function(e)
  if not activity.programs.okay.isVisible then
    if #activity.programs['nil'].block > 0 then
      activity.programs['nil'].scroll:setIsLocked(true, "vertical")
      list({strings.remove, strings.export, strings.exportApk, strings.rename}, {x = e.target.x, y = e.target.y, targetHeight = e.target.height, activeBut = strings.remove}, function(event)
        activity.programs['nil'].scroll:setIsLocked(false, "vertical")

        activity.programs['nil'].alertActive = true
        activity.programs['nil'].listMany = event.num == 1
        if event.num ~= 0 then
          activity.programs.add.isVisible = false
          activity.programs.import.isVisible = false
          activity.programs.okay.isVisible = true
          activity.programs.okay.num = event.num
          for i = 1, #activity.programs['nil'].block do
            activity.programs['nil'].block[i].checkbox.isVisible = true
          end
          activity.programs.act.text = '(' .. event.text .. ')'
        else
        activity.programs['nil'].alertActive = false
        end
      end)
    end
  end
end

activity.onClickButton.programs.okay = function(e)
  activity.programs['nil'].alertActive = false
  activity.programs['nil'].listPressNum = 1
  activity.onClickButton.programs[e.target.num]()

  activity.programs.add.isVisible = true
  activity.programs.import.isVisible = true
  activity.programs.okay.isVisible = false
  for i = 1, #activity.programs['nil'].block do
    activity.programs['nil'].block[i].checkbox.isVisible = false
    activity.programs['nil'].block[i].checkbox:setState({isOn=false})
  end
  activity.programs.act.text = ''
end

activity.onClickButton.programs.block = function(e)
  settings.lastApp = e.target.text.text
  activity.programs.name = e.target.text.text
  activity.programs.hide()
  activity.scenes.create()
  settingsSave()
end

activity.onClickButton.programs[1] = function()
  local i = 0
  while i < #activity.programs['nil'].block do
    i = i + 1
    if activity.programs['nil'].block[i].checkbox.isOn then
      local newData = ''
      local name = activity.programs['nil'].block[i].text.text

      settings.lastApp = ''
      settingsSave()

      os.execute('rm -rf "' .. system.pathForFile('', system.DocumentsDirectory) .. '/' .. name .. '"')

      local path = system.pathForFile('Programs.txt', system.DocumentsDirectory)
      local file = io.open(path, 'r')
      if file then
        for line in file:lines() do
          if line ~= activity.programs['nil'].block[i].text.text then
            if newData == '' then newData = line
            else newData = newData .. '\n' .. line end
          end
        end
        io.close(file)
      end

      local path = system.pathForFile('Programs.txt', system.DocumentsDirectory)
      local file = io.open(path, 'w')
      if file then
        file:write(newData)
        io.close(file)
      end

      table.remove(activity.programs['nil'].data, i)

      activity.programs['nil'].scrollHeight = activity.programs['nil'].scrollHeight - 153
      activity.programs['nil'].scroll:remove(activity.programs['nil'].block[i])
      activity.programs['nil'].scroll:setScrollHeight(activity.programs['nil'].scrollHeight)

      activity.programs['nil'].block[i].checkbox:removeSelf()
      activity.programs['nil'].block[i].text:removeSelf()
      activity.programs['nil'].block[i]:removeSelf()

      for j = i+1, #activity.programs['nil'].block do
        activity.programs['nil'].block[j].num = j
        activity.programs['nil'].block[j].y = activity.programs['nil'].block[j].y - 153
        activity.programs['nil'].block[j].text.y = activity.programs['nil'].block[j].text.y - 153
        activity.programs['nil'].block[j].checkbox.y = activity.programs['nil'].block[j].checkbox.y - 153
      end

      table.remove(activity.programs['nil'].block, i)
      i = i - 1

      if activity.scenes[name] then
        for j = 1, #activity.scenes[name].block do
          local scenesName = name .. '.' .. activity.scenes[name].block[j].text.text

          if activity.objects[scenesName] then
            for j2 = 1, #activity.objects[scenesName].block do
              local objectsTexture = scenesName .. '.' .. activity.objects[scenesName].block[j2].text.text

              if activity.textures[objectsTexture] then
                activity.textures[objectsTexture].scroll:removeSelf()
                activity.textures[objectsTexture] = nil
              end
            end

            activity.objects[scenesName].scroll:removeSelf()
            activity.objects[scenesName] = nil
          end
        end

        activity.scenes[name].scroll:removeSelf()
        activity.scenes[name] = nil
      end
    end
  end
end

activity.onClickButton.programs[2] = function()
end

activity.onClickButton.programs[3] = function()
end

activity.onClickButton.programs[4] = function()
  for i = 1, #activity.programs['nil'].block do
    if activity.programs['nil'].block[i].checkbox.isOn then
      activity.programs['nil'].scroll:setIsLocked(true, "vertical")

      input(strings.enterTitle, strings.enterNewTitleProgramText, function(event) activity.onInputEvent(event, activity.programs['nil'].data, 'programs') end, function(event)
        activity.programs['nil'].scroll:setIsLocked(false, "vertical")

        if event.input then
          event.text = activity.onInputEvent({phase='ok', text=event.text}, activity.programs['nil'].data, 'programs')

          local oldTitle = activity.programs['nil'].block[i].text.text
          local textX = activity.programs['nil'].block[i].text.x
          local textY = activity.programs['nil'].block[i].text.y
          local textHeight = 48
          local newData = ''

          settings.lastApp = event.text
          settingsSave()

          local text = display.newText({
            text = event.text, width = 440,
            x = 0, y = 0, font = 'ubuntu_!bold.ttf', fontSize = 40
          })
          activity.programs['nil'].block[i].text:removeSelf()

          if text.height > 50 then textHeight = 96 end
          text:removeSelf()

          activity.programs['nil'].block[i].text = display.newText({
            text = event.text, width = 440, height = textHeight,
            font = 'ubuntu_!bold.ttf', fontSize = 40, x = textX, y = textY
          })
          activity.programs['nil'].block[i].text.anchorX = 0

          activity.programs['nil'].scroll:insert(activity.programs['nil'].block[i].text)
          activity.programs['nil'].data[i] = event.text

          local path = system.pathForFile('Programs.txt', system.DocumentsDirectory)
          local file = io.open(path, 'r')
          if file then
            for line in file:lines() do
              if line ~= oldTitle then
                if newData == '' then newData = line
                else newData = newData .. '\n' .. line end
              else
                if newData == '' then newData = activity.programs['nil'].block[i].text.text
                else newData = newData .. '\n' .. activity.programs['nil'].block[i].text.text end
              end
            end
            io.close(file)
          end

          local path = system.pathForFile('Programs.txt', system.DocumentsDirectory)
          local file = io.open(path, 'w')
          if file then
            file:write(newData)
            io.close(file)
          end

          os.execute(string.format('mv "%s" "%s"',
            system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', oldTitle, oldTitle),
            system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.cc', oldTitle, event.text)))

          os.execute(string.format('mv "%s" "%s"',
            system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s', oldTitle),
            system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s', event.text)))

          if activity.scenes[oldTitle] then
            for j = 1, #activity.scenes[oldTitle].block do
              local scenesName = oldTitle .. '.' .. activity.scenes[oldTitle].block[j].text.text

              if activity.objects[scenesName] then
                for j2 = 1, #activity.objects[scenesName].block do
                  local objectsTexture = scenesName .. '.' .. activity.objects[scenesName].block[j2].text.text

                  if activity.textures[objectsTexture] then
                    activity.textures[objectsTexture].scroll:removeSelf()
                    activity.textures[objectsTexture] = nil
                  end
                end

                activity.objects[scenesName].scroll:removeSelf()
                activity.objects[scenesName] = nil
              end
            end

            activity.scenes[oldTitle].scroll:removeSelf()
            activity.scenes[oldTitle] = nil
          end
        end
      end, activity.programs['nil'].block[i].text.text)
      break
    end
  end
end
