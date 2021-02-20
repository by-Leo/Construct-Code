activity.onClickButton.programs = {}

activity.onClickButton.programs.add = function(e)
  activity.programs['nil'].scroll:setIsLocked(true, "vertical")

  alert(strings.chooseOrientation, strings.chooseOrientationText, {strings.portrait, strings.landscape}, function(event)
    if event.num ~= 0 then
      input(strings.enterTitle, strings.enterTitleProgramText, function(event) activity.onInputEvent(event, activity.programs['nil'].data, 'programs') end, function(e)
        activity.programs['nil'].scroll:setIsLocked(false, "vertical")

        if e.input then
          e.text = activity.onInputEvent({phase='ok', text=e.text}, activity.programs['nil'].data, 'programs')
          e.filter = 'group bg act title add play list okay onClick hide view getVarFunTable create name scene '
          if utf8.find(e.filter, e.text .. ' ') then e.text = e.text .. '_' .. math.random(111111111, 999999999) end

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
          local data = {
            program = event.num == 1 and 'portrait' or 'landscape',
            scenes = {{name = strings.firstScene, objects = {}}}
          } if file then file:write(jsonToCCode(data)) io.close(file) end

          local path = system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/save.json', e.text)
          local file = io.open(path, 'w') if file then file:write('{}') io.close(file) end

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
  activity.programs['nil'].scroll:setIsLocked(true, 'vertical')

  local basedir, name, _name = system.pathForFile('', system.DocumentsDirectory), '', ''
  local filter = 'group bg act title add play list okay onClick hide view getVarFunTable create name scene '
  local completeImportCCode = function(ev)
    if ev.done and ev.done == 'ok' then
      local rectDownloadApp = display.newRect(_x, _y - 5, 600, 210)
      rectDownloadApp:setFillColor(0.18, 0.18, 0.2)

      local rectDownloadAppShadow = display.newRect(_x, _y, _aW, _aH)
      rectDownloadAppShadow:setFillColor(0, 0.005)

      local rectDownloadAppText = display.newText({
        text = strings.importCCode,
        font = 'ubuntu_!bold.ttf', fontSize = 40, width = 560, x = _x - 280, y = _y - 80
      })

      rectDownloadApp.height = rectDownloadAppText.height + 20
      rectDownloadAppText.anchorX, rectDownloadAppText.anchorY = 0, 0
      rectDownloadAppText.y = _y - rectDownloadApp.height / 2 + 5

      rectDownloadAppShadow:addEventListener('touch', function(e)
        if e.phase == 'began' then display.getCurrentStage():setFocus(e.target)
        elseif e.phase == 'ended' then display.getCurrentStage():setFocus(nil)
        end return true
      end) alertActive = true

      local exportStop = function()
        alertActive = false
        rectDownloadApp:removeSelf()
        rectDownloadAppText:removeSelf()
        activity.programs['nil'].scroll:setIsLocked(false, 'vertical')
        timer.performWithDelay(1, function() rectDownloadAppShadow:removeSelf() end)
      end

      zip.uncompress {
        zipFile = 'import.ccode',
        zipBaseDir = system.DocumentsDirectory,
        dstBaseDir = system.DocumentsDirectory,
        files = {'list'}, listener = function(event)
          if not event.isError then pcall(function()
            local file, data = io.open(basedir .. '/list', 'r')
            if file then data = json.decode(file:read('*a')) io.close(file) end
            if type(data) == 'table' then for i = 1, #data do
              if utf8.sub(data[i], utf8.len(data[i])-2, utf8.len(data[i])) == '.cc'
              and not utf8.find(utf8.sub(data[i], 1, utf8.len(data[i])-3), '%.') then
              name = utf8.sub(data[i], 1, utf8.len(data[i])-3) end end
              zip.uncompress {
                zipFile = 'import.ccode',
                zipBaseDir = system.DocumentsDirectory,
                dstBaseDir = system.DocumentsDirectory,
                files = data, listener = function(event) pcall(function()
                  local file, _hash = io.open(basedir .. '/hash', 'r'), ''
                  if file then _hash = file:read('*a') io.close(file) end
                  local file, code = io.open(basedir .. '/' .. name .. '.cc', 'r'), ''
                  if file then code = file:read('*a') io.close(file) end
                  local file = io.open(basedir .. '/save.json', 'r')
                  if file then code = code .. file:read('*a') io.close(file) end
                  local hash = crypto.hmac(crypto.md4, crypto.hmac(crypto.md4, code, 'ccpassword'), 'ccpassword')
                  if hash == _hash then if utf8.find(filter, name .. ' ') then _name = name name = utf8.sub(name, 1, utf8.len(name) > 20 and 20
                  or utf8.len(name)) .. '_' .. math.random(111111111, 999999999) os.execute(string.format('mv "%s" "%s"',
                  basedir .. '/' .. _name .. '.cc', basedir .. '/' .. name .. '.cc')) end for i = 1, #activity.programs['nil'].data do
                    if activity.programs['nil'].data[i] == name then _name = name
                      name = utf8.sub(name, 1, utf8.len(name) > 20 and 20
                      or utf8.len(name)) .. '_' .. math.random(111111111, 999999999)
                      os.execute(string.format('mv "%s" "%s"', basedir .. '/' .. _name .. '.cc', basedir .. '/' .. name .. '.cc'))
                    end end lfs.mkdir(basedir .. '/' .. name) for i = 1, #data do
                      if utf8.sub(data[i], utf8.len(data[i])-2, utf8.len(data[i])) == '.cc' and
                      not utf8.find(utf8.sub(data[i], 1, utf8.len(data[i])-3), '%.') then data[i] = name .. '.cc' end
                      os.execute('rm "' .. basedir .. '/' .. name .. '/' .. data[i] .. '"')
                      os.execute(string.format('mv "%s" "%s"', basedir .. '/' .. data[i], basedir .. '/' .. name .. '/' .. data[i]))
                      os.execute('rm "' .. basedir .. '/' .. data[i] .. '"')
                    end local path = system.pathForFile('Programs.txt', system.DocumentsDirectory)
                    local file, newData = io.open(path, 'r'), name if file then for line in file:lines() do
                    if line ~= name then newData = newData .. '\n' .. line end end io.close(file) end
                    local file = io.open(path, 'w') if file then file:write(newData) io.close(file) end
                    activity.programs['nil'].data[#activity.programs['nil'].data + 1] = name
                    activity.newBlock({i = #activity.programs['nil'].data,
                    group = activity.programs['nil'], type = 'programs', name = 'nil'})
                  end os.execute('rm "' .. basedir .. '/import.ccode"')
                  os.execute('rm "' .. basedir .. '/list"') os.execute('rm "' .. basedir .. '/' .. name .. '/hash"')
                end) exportStop()
              end}
            end
          end) else exportStop() end
      end}
    end
  end library.pickFile(basedir, completeImportCCode, 'import.ccode', '', '*/*', nil, nil, nil)
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
  local data = ccodeToJson(e.target.text.text)
  countBlocks = #data.scenes
  countGenBlocks = 0
  settings.lastApp = e.target.text.text
  activity.programs.name = e.target.text.text
  activity.programs.hide()
  activity.scenes.create(data)
  activity.scenes.hide()
  settingsSave()

  for i = 1, #activity.downloadApp + 1 do
    if activity.downloadApp[i] == e.target.text.text then activity.scenes.view() break
    elseif i == #activity.downloadApp + 1 then
      local rectDownloadApp = display.newRect(_x, _y - 5, 600, 210)
      rectDownloadApp:setFillColor(0.18, 0.18, 0.2)

      local rectDownloadAppShadow = display.newRect(_x, _y, _aW, _aH)
      rectDownloadAppShadow:setFillColor(0, 0.005)

      local rectDownloadAppText = display.newText({
        text = 'Подождите, пожалуйста. Идёт подгрузка приложения для более удобной работы: ' .. e.target.text.text,
        font = 'ubuntu_!bold.ttf', fontSize = 30, width = 560, x = _x - 280, y = _y - 80
      })

      progressView = widget.newProgressView({x = _x, y = _y - 65, width = 560, isAnimated = false})
      progressView:setProgress(0)

      activity.downloadApp[#activity.downloadApp + 1] = e.target.text.text
      rectDownloadApp.height = rectDownloadAppText.height + 40
      rectDownloadAppText.anchorX, rectDownloadAppText.anchorY = 0, 0
      rectDownloadAppText.y = _y - rectDownloadApp.height / 2 + 20

      rectDownloadAppShadow:addEventListener('touch', function(e)
        if e.phase == 'began' then display.getCurrentStage():setFocus(e.target)
        elseif e.phase == 'ended' then display.getCurrentStage():setFocus(nil)
        end return true
      end)

      timer.performWithDelay(1, function()
        for s = 1, #data.scenes do
          countBlocks = countBlocks + #data.scenes[s].objects
          for o = 1, #data.scenes[s].objects do
            countBlocks = countBlocks + #data.scenes[s].objects[o].textures
            countBlocks = countBlocks + #data.scenes[s].objects[o].events
            for e = 1, #data.scenes[s].objects[o].events do
              countBlocks = countBlocks +  #data.scenes[s].objects[o].events[e].formulas
            end
          end
        end

        timer.performWithDelay(1, function(event)
          if countGenBlocks == countBlocks then
            timer.cancel(event.source)
            countGenBlocks = 0
            alertActive = false
            progressView.isVisible = false
            rectDownloadApp:removeSelf()
            rectDownloadAppText:removeSelf()
            timer.performWithDelay(1, function() progressView = nil rectDownloadAppShadow:removeSelf() activity.scenes.view() end)
            activity.scenes.name, activity.scenes.scene = '', ''
            activity.objects.name, activity.objects.texture, activity.objects.object = '', '', ''
          end
        end, 0)

        activity.resources.create(data)
        activity.resources.hide()
        progressView:setProgress(countGenBlocks / countBlocks)

        genObjectsIndex = 0
        genBlocksIndex = 0

        genObjects = function()
          if genObjectsIndex < #activity.scenes[activity.programs.name].block then
            genObjectsIndex = genObjectsIndex + 1
            progressView:setProgress(countGenBlocks / countBlocks)
            activity.scenes.name = activity.programs.name .. '.' .. activity.scenes[activity.programs.name].block[genObjectsIndex].text.text
            activity.scenes.scene = activity.scenes[activity.programs.name].block[genObjectsIndex].text.text
            activity.objects.create(data)
            activity.objects.hide()
          end
        end

        genBlocks = function()
          if genBlocksIndex < #activity.objects[activity.scenes.name].block then
            genBlocksIndex = genBlocksIndex + 1
            progressView:setProgress(countGenBlocks / countBlocks)
            activity.objects.name = activity.scenes.name .. '.' .. activity.objects[activity.scenes.name].block[genBlocksIndex].text.text
            activity.objects.texture = activity.objects.name
            activity.objects.object = activity.objects[activity.scenes.name].block[genBlocksIndex].text.text
            activity.textures.create(data)
            activity.textures.hide()
            activity.blocks.create(data)
            activity.blocks.hide()
          else genBlocksIndex = 0 genObjects() end
        end genObjects()
      end)
    end
  end
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

      for i = 1, #activity.downloadApp do
        if activity.downloadApp[i] == name then
          table.remove(activity.downloadApp, i)
        end
      end

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
  for i = 1, #activity.programs['nil'].block do
    if activity.programs['nil'].block[i].checkbox.isOn then
      activity.programs['nil'].scroll:setIsLocked(true, 'vertical')

      native.showPopup('requestAppPermission', {
        appPermission = 'Storage', urgency = 'Critical',
        listener = function(event) end
      })

      local rectDownloadApp = display.newRect(_x, _y - 5, 600, 210)
      rectDownloadApp:setFillColor(0.18, 0.18, 0.2)

      local rectDownloadAppShadow = display.newRect(_x, _y, _aW, _aH)
      rectDownloadAppShadow:setFillColor(0, 0.005)

      local rectDownloadAppText = display.newText({
        text = strings.exportCCode,
        font = 'ubuntu_!bold.ttf', fontSize = 40, width = 560, x = _x - 280, y = _y - 80
      })

      rectDownloadApp.height = rectDownloadAppText.height + 20
      rectDownloadAppText.anchorX, rectDownloadAppText.anchorY = 0, 0
      rectDownloadAppText.y = _y - rectDownloadApp.height / 2 + 5

      rectDownloadAppShadow:addEventListener('touch', function(e)
        if e.phase == 'began' then display.getCurrentStage():setFocus(e.target)
        elseif e.phase == 'ended' then display.getCurrentStage():setFocus(nil)
        end return true
      end) alertActive = true

      local exportStop = function()
        alertActive = false
        rectDownloadApp:removeSelf()
        rectDownloadAppText:removeSelf()
        activity.programs['nil'].scroll:setIsLocked(false, 'vertical')
        timer.performWithDelay(1, function() rectDownloadAppShadow:removeSelf() end)
      end

      timer.performWithDelay(1, function()
        local basedir = system.pathForFile('', system.DocumentsDirectory)
        local name, data = activity.programs['nil'].block[i].text.text, ''
        local list, _list = {name .. '/hash'}, {'hash'}

        for file in lfs.dir(system.pathForFile('', system.DocumentsDirectory) .. '/' .. name) do
          local theFile = name .. '/' .. file if file ~= '..' and file ~= '.'
          then list[#list + 1], _list[#_list + 1] = theFile, file end
        end

        local path = basedir .. '/' .. name .. '/' .. name .. '.cc'
        local file = io.open(path, 'r') if file then data = file:read('*a') io.close(file) end
        local path = basedir .. '/' .. name .. '/save.json'
        local file = io.open(path, 'r') if file then data = data .. file:read('*a') io.close(file) end
        local hash = crypto.hmac(crypto.md4, crypto.hmac(crypto.md4, code, 'ccpassword'), 'ccpassword')
        local path = basedir .. '/' .. name .. '/hash'
        local file = io.open(path, 'w') if file then file:write(hash) io.close(file) end
        local path = basedir .. '/' .. name .. '/list'
        local file = io.open(path, 'w') if file then file:write(json.encode(_list)) io.close(file) end

        timer.performWithDelay(1, function()
          list[#list + 1] = name .. '/list' zip.compress {
            zipFile = name .. '.ccode',
            zipBaseDir = system.DocumentsDirectory,
            srcBaseDir = system.DocumentsDirectory,
            srcFiles = list, listener = function(event) pcall(function() exportStop()
              os.execute('rm -f "' .. basedir .. '/' .. name .. '/hash"')
              os.execute('rm -f "' .. basedir .. '/' .. name .. '/list"')
              lfs.mkdir('/sdcard/ExportCC') timer.performWithDelay(1, function()
              os.execute(string.format('mv "%s" "%s"',
              basedir .. '/' .. name .. '.ccode', '/sdcard/ExportCC/' .. name .. '.ccode'))
              os.execute('rm -f "' .. basedir .. '/' .. name .. '.ccode"')
            end) end)
          end}
        end)
      end)
    end
  end
end

activity.onClickButton.programs[3] = function()
end

activity.onClickButton.programs[4] = function()
  for i = 1, #activity.programs['nil'].block do
    if activity.programs['nil'].block[i].checkbox.isOn then
      activity.programs['nil'].scroll:setIsLocked(true, 'vertical')

      input(strings.enterTitle, strings.enterNewTitleProgramText, function(event) activity.onInputEvent(event, activity.programs['nil'].data, 'programs') end, function(event)
        activity.programs['nil'].scroll:setIsLocked(false, 'vertical')

        if event.input then
          event.text = activity.onInputEvent({phase='ok', text=event.text}, activity.programs['nil'].data, 'programs')
          event.filter = 'group bg act title add play list okay onClick hide view getVarFunTable create name scene '
          if utf8.find(event.filter, event.text .. ' ') then event.text = event.text .. '_' .. math.random(111111111, 999999999) end

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
