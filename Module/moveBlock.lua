-- Обработка таймера нажатия
activity.onTimer = function(target, types, names)
  if target.alpha < 0.85 and activity[types][names].scroll.isVisible then
    display.getCurrentStage():setFocus(nil)
    target.alpha = 0.9
    target.text.alpha = 1
    if types == 'objects' or types == 'textures' then
      target.container.alpha = 0.9
    end
    if #activity[types][names].block > 1 then activity.move(target, 'move', types, names) end
  end
end

-- Переместить блоки относительно позиции перетаскиваемого блока
activity.moveBlock = function(i, types, names)
  local buttonY = 79 + 153 * i
  for i = i, #activity[types][names].block do
    activity[types][names].block[i].y = buttonY
    activity[types][names].block[i].text.y = buttonY
    activity[types][names].block[i].checkbox.y = buttonY
    if types == 'objects' or types == 'textures' then activity[types][names].block[i].container.y = buttonY end
    buttonY = buttonY + 153
  end
end

-- Переместить блоки относительно нулевой позиции
activity.returnBlock = function(i, types, names)
  local buttonY = 79
  for i = 1, #activity[types][names].block do
    activity[types][names].block[i].y = buttonY
    activity[types][names].block[i].text.y = buttonY
    activity[types][names].block[i].checkbox.y = buttonY
    if types == 'objects' or types == 'textures' then activity[types][names].block[i].container.y = buttonY end
    buttonY = buttonY + 153
  end
  activity.moveBlock(i, types, names)
end

-- Найти позицию блока для перемещения других блоков относительно его позиции
activity.locateBlock = function(yTarget, types, names)
  for i = 1, #activity[types][names].block do
    if activity[types][names].block[i].y >= yTarget then activity.returnBlock(i, types, names) break
    elseif i == #activity[types][names].block then activity.returnBlock(i+1, types, names) end
  end
end

-- Добавить в таблицу новый блок
activity.setBlock = function(yTarget, textTarget, i, mode, types, names, import, json, num)
  local textCopy = textTarget
  local textCopyNum = 1
  local textCopyFun

  if mode == 'copy' then
    textTarget = textCopy .. '_' .. textCopyNum

    textCopyFun = function()
      textCopyNum = textCopyNum + 1
      for i = 1, #activity[types][names].block do
        if activity[types][names].block[i].text.text == textTarget then
          textTarget = textCopy .. '_' .. textCopyNum
          textCopyFun()
          break
        end
      end
    end

    textCopyFun()

    if utf8.len(textTarget) > 30 then
      textTarget = utf8.sub(textCopy, 1, 10) .. '_' .. math.random(111111111, 999999999) .. '_' .. math.random(111111111, 999999999)
      for i = 1, #activity[types][names].block do
        if activity[types][names].block[i].text.text == textTarget then
          textTarget = math.random(111111111, 999999999) .. '_' .. math.random(111111111, 999999999) .. '_' .. math.random(111111111, 999999999)
          break
        end
      end
    end

    for file in lfs.dir(system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name) do
      local theFile = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/' .. file
      if type(theFile) ~= 'string' then theFile = '' end

      if lfs.attributes(theFile, 'mode') ~= 'directory' then
        pcall(function()
          local nameScene, nameObject, nameTexture = utf8.match(file, '(.*)%.(.*)%.(.*)')
          if nameScene == textCopy and types == 'scenes' then
            os.execute(string.format('cp "%s" "%s"',
              system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                activity.programs.name, nameScene, nameObject, nameTexture),
              system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                activity.programs.name, textTarget, nameObject, nameTexture)))
          elseif nameScene == activity.scenes.scene and nameObject == textCopy and types == 'objects' then
            os.execute(string.format('cp "%s" "%s"',
              system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                activity.programs.name, nameScene, nameObject, nameTexture),
              system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                activity.programs.name, nameScene, textTarget, nameTexture)))
          elseif nameScene == activity.scenes.scene and nameObject == activity.objects.object and nameTexture == textCopy and types == 'textures' then
            os.execute(string.format('cp "%s" "%s"',
              system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                activity.programs.name, nameScene, nameObject, nameTexture),
              system.pathForFile('', system.DocumentsDirectory) .. string.format('/%s/%s.%s.%s',
                activity.programs.name, nameScene, nameObject, textTarget)))
          end
        end)
      end
    end
  end
  activity[types][names].targetActive = false
  activity[types][names].group:removeSelf()
  activity[types][names].scroll:setIsLocked(false, 'vertical')
  table.insert(activity[types][names].data, i, textTarget)
  activity.newBlock({
    i = i,
    copy = (mode == 'copy') and textCopy or nil,
    group = activity[types][names],
    type = types,
    name = names,
    import = import,
    json = json
  })
  activity.onFileRead[types]({
    name = mode,
    index = i
  })
  activity[types][names].block[i].copy = ''

  if types == 'textures' then
    for j = 1, #activity.objects[activity.scenes.name].block do
      if activity.objects[activity.scenes.name].block[j].text.text == activity.objects.object then
        activity.objects[activity.scenes.name].block[j].json = {}
        for j2 = 1, #activity.textures[activity.objects.texture].block do
          activity.objects[activity.scenes.name].block[j].json[j2] = activity.textures[activity.objects.texture].block[j2].text.text
        end
        break
      end
    end
  end

  if types == 'textures' and (i == 1 or num == 1) then
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
end

-- Найти позицию блока для установки блока в скролл
activity.locateNewBlock = function(yTarget, textTarget, mode, types, names, import, json, num)
  for i = 1, #activity[types][names].block do
    if activity[types][names].block[i].y > yTarget then activity.setBlock(yTarget, textTarget, i, mode, types, names, import, json, num) break
    elseif i == #activity[types][names].block then activity.setBlock(yTarget, textTarget, i+1, mode, types, names, import, json, num) end
  end
end

-- Удалить старый блок
activity.deleteBlock = function(target, numTarget, types, names)
  activity[types][names].scrollHeight = activity[types][names].scrollHeight - 153
  activity[types][names].scroll:setScrollHeight(activity[types][names].scrollHeight)

  if types == 'objects' or types == 'textures' then target.container:removeSelf() end
  target.checkbox:removeSelf()
  target.text:removeSelf()
  target:removeSelf()

  table.remove(activity[types][names].data, numTarget)
  table.remove(activity[types][names].block, numTarget)
end

-- Создать перемещаемый блок
activity.move = function(target, mode, types, names, isNewBlock)
  local scrollX, scrollY = activity[types][names].scroll:getContentPosition()
  local yTarget = _y - _aY + target.y + 165 + scrollY
  local importTarget = target.import
  local jsonTarget = target.json
  local pathTarget = (types == 'objects' or types == 'textures') and string.format('%s/%s.%s.%s', activity.programs.name, activity.scenes.scene, types == 'objects' and target.text.text or activity.objects.object, types == 'objects' and target.json[1] or target.text.text) or nil
  local numTarget = target.num
  local textTarget = target.text.text
  local textX = (types == 'programs' or types == 'scenes') and 150 or 290
  local textWidth = (types == 'programs' or types == 'scenes') and 440 + (_aW - _w) or 340 + (_aW - _w)
  local textHeight = 48

  activity[types][names].targetActive = true
  activity[types][names].scroll:setIsLocked(true, "vertical")

  if mode == 'move' and not isNewBlock then activity.deleteBlock(target, numTarget, types, names)
  elseif mode == 'copy' then yTarget = yTarget + 165 end

  activity[types][names].group = display.newGroup()

  display.newRect(activity[types][names].group, _x, _y, 5000, 5000):setFillColor(1, 0.05)

  local newTarget = display.newRoundedRect(activity[types][names].group, _x, yTarget, 576 + (_aW - _w), 138, 20)
  newTarget:setFillColor(25/255, 26/255, 32/255)

  local text = display.newText({
    text = textTarget, width = textWidth,
    x = 0, y = 0, font = 'ubuntu_!bold.ttf', fontSize = 40
  })

  if text.height > 50 then textHeight = 96 end
  text:removeSelf()

  newTarget.text = display.newText({
    text = textTarget, parent = activity[types][names].group, width = textWidth,
    height = textHeight, x = _x - _aX + textX, y = yTarget, fontSize = 40, font = 'ubuntu_!bold.ttf'
  })
  newTarget.text.anchorX = 0

  if (types == 'objects' or types == 'textures') then
    newTarget.container = display.newContainer(110, 110)
    newTarget.container.x = _x - _aX + 200
    newTarget.container.y = yTarget

    display.setDefault( 'magTextureFilter', importTarget)

    local image = display.newImage(pathTarget, system.DocumentsDirectory)

    if image then
      formula = image.width / 110
      image.width = 110
      image.height = image.height / formula
      if image.height > 110 then
        formula = image.height / 110
        image.height = 110
        image.width = image.width / formula
      end
      newTarget.container:insert(image, true)
    end

    activity[types][names].group:insert(newTarget.container)
  end

  newTarget:addEventListener('touch', function(e)
    if not alertActive and activity[types][names].scroll.isVisible then
      if e.phase == 'moved' then
        scrollX, scrollY = activity[types][names].scroll:getContentPosition()
        if e.y < _y - _aY + 200 and scrollY < 0 then
          activity[types][names].scroll:scrollToPosition({y = scrollY + 15, time = 0})
        elseif e.y > _y + _aY - 355 and activity[types][names].block[#activity[types][names].block].y + scrollY > 600 then
          activity[types][names].scroll:scrollToPosition({y = scrollY - 15, time = 0})
        end
        e.target.x = e.x
        e.target.y = e.y
        e.target.text.x = e.x - (_aX - textX)
        e.target.text.y = e.y
        if types == 'objects' or types == 'textures' then
          e.target.container.x = e.x - (_aX - 200)
          e.target.container.y = e.y
        end
        activity.locateBlock(e.target.y - 165 - scrollY + (_aH - _h) / 2, types, names)
      elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        scrollX, scrollY = activity[types][names].scroll:getContentPosition()
        activity.locateNewBlock(e.target.y - 165 - scrollY + (_aH - _h) / 2, e.target.text.text, mode, types, names, importTarget, jsonTarget, numTarget)
      end
    end
    return true
  end)
  display.getCurrentStage():setFocus(newTarget)
  scrollX, scrollY = activity[types][names].scroll:getContentPosition()
  activity.locateBlock(yTarget - 165 - scrollY + (_aH - _h) / 2, types, names)
end
