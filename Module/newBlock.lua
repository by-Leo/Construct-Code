activity.newTexture = function(index, config)
  pcall(function() config.group.block[index].container:removeSelf() end)

  config.group.block[index].container = display.newContainer(110, 110)
  config.group.block[index].container.x = 200
  config.group.block[index].container.y = 79 + 153 * (index-1)
  config.group.block[index].container.alpha = 1

  display.setDefault( 'magTextureFilter', config.group.block[index].import)

  pcall(function()
    local image

    if config.type == 'objects' then
      image = display.newImage(string.format('%s/%s.%s.%s', activity.programs.name, activity.scenes.scene, activity.objects[activity.scenes.name].data[index], activity.objects[activity.scenes.name].block[index].json[1]), system.DocumentsDirectory)
    elseif config.type == 'textures' then
      image = display.newImage(string.format('%s/%s.%s.%s', activity.programs.name, activity.scenes.scene, activity.objects.object, activity.textures[activity.objects.texture].data[index]), system.DocumentsDirectory)
    end

    if image then
      formula = image.width / 110
      image.width = 110
      image.height = image.height / formula
      if image.height > 110 then
        formula = image.height / 110
        image.height = 110
        image.width = image.width / formula
      end
      config.group.block[index].container:insert(image, true)
    end
  end)
end

activity.newBlock = function(config)
  local i = config.i
  local textData = config.group.data[i]
  local textX = (config.type == 'programs' or config.type == 'scenes') and 150 or 290
  local textWidth = (config.type == 'programs' or config.type == 'scenes') and 440 + (_aW - _w) or 340 + (_aW - _w)
  local textHeight = 48

  -- Добавление нового блока в таблицу
  table.insert(config.group.block, i, {})
  config.group.block[i] = display.newRoundedRect(_aX, 79 + 153 * (i-1), 576 + (_aW - _w), 138, 20)
  config.group.block[i]:setFillColor(25/255, 26/255, 32/255)
  config.group.block[i].alpha, config.group.block[i].num = 0.9, i

  if config.copy then config.group.block[i].copy = config.copy
  else config.group.block[i].copy = '' end

  -- Создание текста по-умолчанию для получения высоты текста
  local text = display.newText({
    text = textData, width = textWidth,
    x = 0, y = 0, font = 'ubuntu_!bold.ttf', fontSize = 40
  })

  if text.height > 50 then textHeight = 96 end
  config.group.block[i].newTextX = (config.type == 'programs' or config.type == 'scenes') and _aX + 15 or _aX + 90
  config.group.block[i].oldTextX = textX
  text:removeSelf()

  -- Добавление нового текста в таблицу
  config.group.block[i].text = display.newText({
    text = textData, width = textWidth, height = textHeight,
    font = 'ubuntu_!bold.ttf', fontSize = 40, x = textX, y = 79 + 153 * (i-1)
  })
  config.group.block[i].text.anchorX = 0

  -- Добавление нового чекбокса в таблицу
  config.group.block[i].checkbox = widget.newSwitch({
    x = 110, y = 79 + 153 * (i-1), style = 'checkbox', width = 60, height = 60,
    onPress = function(event) event.target:setState({isOn=not event.target.isOn}) end
  })
  config.group.block[i].checkbox.isVisible = false

  -- Добавление новой текстуры в таблицу
  config.group.block[i].import = config.import
  config.group.block[i].json = config.json
  if config.type == 'objects' or config.type == 'textures' then activity.newTexture(i, config) end

  -- Переустановка локальной переменной `num` каждого блока
  for j = 1, #config.group.block do config.group.block[j].num = j end

  -- Увеличение высоты прокручивания скролла и добавление новых элементов в него
  config.group.scroll:insert(config.group.block[i])
  config.group.scroll:insert(config.group.block[i].text)
  config.group.scroll:insert(config.group.block[i].checkbox)
  if config.type == 'objects' or config.type == 'textures' then config.group.scroll:insert(config.group.block[i].container) end

  config.group.scrollHeight = config.group.scrollHeight + 153
  config.group.scroll:setScrollHeight(config.group.scrollHeight)

  -- Слушатель прикосновений
  config.group.block[i]:addEventListener('touch', function(e) activity.onClickBlock(config.name, config.type, e) return true end)
end
