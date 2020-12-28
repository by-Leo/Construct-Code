local fsdScroll
local fsdConfig
local fsdCreate
local fsdFile

local fsdOnKeyEvent = function(event)
  if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' and fsdScroll then
    pcall(function() fsdScroll:removeSelf() end)

    for file in lfs.dir(system.pathForFile('', system.TemporaryDirectory)) do
      pcall(function()
        local theFile = system.pathForFile('', system.TemporaryDirectory) .. '/' .. file

        if lfs.attributes(theFile, 'mode') ~= 'directory' then
          os.execute('rm "' .. theFile .. '"')
        end
      end)
    end

    timer.performWithDelay(1, function()
      fsdConfig.listener(false)
    end)
  end
  return true
end
Runtime:addEventListener('key', fsdOnKeyEvent)

fsd = function(config)
  fsdConfig = config

  local checkStorageBool = true
  local checkStorage = pcall(function()
    local file = io.open('/sdcard/.cc', 'w')

    if file then file:write('checking access to storage') io.close(file)
    else checkStorageBool = false end
  end)

  if system.getInfo 'platform' ~= 'android' or system.getInfo 'environment' == 'simulator'
  then checkStorageBool = true end

  if checkStorage and checkStorageBool then
    local fsdPath = path_platform
    local fsdNewPath
    local fsdNewPathPlatform = path_platform

    fsdFile = function()
      pcall(function() fsdScroll:removeSelf() end)

      for file in lfs.dir(system.pathForFile('', system.TemporaryDirectory)) do
        pcall(function()
          local theFile = system.pathForFile('', system.TemporaryDirectory) .. '/' .. file

          if lfs.attributes(theFile, 'mode') ~= 'directory' then
            os.execute('rm "' .. theFile .. '"')
          end
        end)
      end

      timer.performWithDelay(1, function()
        local copyToHome = pcall(function()
          os.execute(string.format('cp "%s" "%s"', fsdPath, config.toFile))

          local checkFile = io.open(config.toFile, 'r')
          if checkFile then config.listener(true) io.close(checkFile) else config.listener(false) end
        end)

        if not copyToHome then config.listener(false) end
      end)
    end

    fsdCreate = function()
      pcall(function() fsdScroll:removeSelf() end)

      timer.performWithDelay(1, function()
        local lastPositionY = 100
        local scrollHeight = 0

        local onTargetTouch = function(e)
          if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            e.target:setFillColor(0.18, 0.18, 0.2)
          elseif e.phase == 'moved' then
            local dy = math.abs(e.y - e.yStart)
            if dy > 20 then
              fsdScroll:takeFocus(e)
              e.target:setFillColor(0.15, 0.15, 0.17)
            end
          elseif e.phase == 'ended' or e.phase == 'cancelled' then
            display:getCurrentStage():setFocus(nil)
            e.target:setFillColor(0.15, 0.15, 0.17)

            if e.target.type == 'folder' then
              if e.target.text.text == '..' then
                local symFind = utf8.find(utf8.reverse(fsdPath), '/', 1, true)
                if symFind then
                  fsdPath = utf8.reverse(utf8.sub(utf8.reverse(fsdPath), symFind+1, utf8.len(fsdPath)))
                end
                if fsdPath == '' then
                  if system.getInfo 'platform' == 'android' and system.getInfo 'environment' ~= 'simulator' then
                    fsdPath = '/sdcard'
                  else
                    fsdPath = 'C:/Users'
                  end
                end
              else
                fsdPath = fsdPath .. '/' .. e.target.text.text
              end
              fsdCreate()
            elseif e.target.type == 'file' then
              fsdNewPathPlatform = fsdPath
              fsdPath = fsdPath .. '/' .. e.target.text.text
              fsdFile()
            end
          end
          return true
        end

        local newTarget = function(file, theFile)
          local isFolder = lfs.attributes(theFile, 'mode') == 'directory'
          local endFile = utf8.reverse(utf8.sub(utf8.reverse(file), 1, utf8.find(utf8.reverse(file), '%.')))
          local isPicture = endFile == '.png' or endFile == '.jpg' or endFile == '.gif' or endFile == '.bmp' or endFile == '.jpeg'
          local path = isFolder == true and 'folder.png' or 'file.png'

          if settings.pictureView and isPicture then
            path = file
            os.execute(string.format('cp "%s" "%s"', theFile, system.pathForFile('', system.TemporaryDirectory) .. '/' .. file))
          end

          local picture = display.newImage(path, system.ResourceDirectory, 80, lastPositionY)

          if settings.pictureView and isPicture then
            picture = display.newImage(path, system.TemporaryDirectory, 80, lastPositionY)
          end

          if picture then
            local pictureScalling = picture.width / 80
            picture.width = 80
            picture.height = picture.height / pictureScalling
            if picture.height > 80 then
              pictureScalling = picture.height / 80
              picture.height = 80
              picture.width = picture.width / pictureScalling
            end
          else
            picture = display.newImage(isFolder == true and 'folder.png' or 'file.png', 80, lastPositionY)
            picture.width, picture.height = 80, 80
          end

          local target = display.newRoundedRect(_x + 70, lastPositionY, 540, 120, 20)
          target.type = isFolder == true and 'folder' or 'file'
          target:setFillColor(0.15, 0.15, 0.17)
          target:addEventListener('touch', onTargetTouch)

          target.text = display.newText({
            text = file, x = _x + 75, y = lastPositionY,
            font = 'ubuntu_!bold.ttf', fontSize = 40,
            width = 500, height = 48, align = 'left'
          })

          fsdScroll:insert(picture)
          fsdScroll:insert(target)
          fsdScroll:insert(target.text)

          lastPositionY = lastPositionY + 150
          scrollHeight = scrollHeight + 150
        end

        fsdScroll = widget.newScrollView({
          x = _x, y = _y,
          width = _w, height = _h,
          hideBackground = true, hideScrollBar = true,
          horizontalScrollDisabled = true, isBounceEnabled = true,
          listener = function(e) return true end
        })

        newTarget('..', fsdPath .. '/..')

        for file in lfs.dir(fsdPath) do
          local theFile = fsdPath .. '/' .. file
          local boolFile = type(file) == 'string' and utf8.sub(file, 1, 1) ~= '.' or false

          if type(file) == 'string' and boolFile then
            if lfs.attributes(theFile, 'mode') == 'directory' then
              newTarget(file, theFile)
            else
              for i = 1, #config.toPath do
                if config.toPath[i] == utf8.reverse(utf8.sub(utf8.reverse(file), 1, utf8.find(utf8.reverse(file), '%.'))) then
                  newTarget(file, theFile)
                  break
                end
              end
            end
          end
        end

        scrollHeight = scrollHeight + 50
        fsdScroll:setScrollHeight(scrollHeight)
      end)
    end

    fsdCreate()
  else
    alert(strings.errorPermissionTitle, strings.errorPermissionText, {strings.close}, function(e) config.listener(false) end)
  end
end
