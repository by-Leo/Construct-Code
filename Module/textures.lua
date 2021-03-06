activity.textures = {}

-- Активити группа
activity.textures.group = display.newGroup()

-- Фон активити
activity.textures.bg = display.newImage('Image/bg.png')
activity.textures.bg.x, activity.textures.bg.y = _x, _y - _tH / 2
activity.textures.bg.width, activity.textures.bg.height = _aW, _aH + _tH

-- Название активити
activity.textures.title = display.newText(strings.texturesTitle, _x - _aX + 50, _y - _aY + 80, 'ubuntu_!bold.ttf', 58)
activity.textures.title.anchorX = 0

-- Выполняемое действие
activity.textures.act = display.newText('', _x, _y - _aY + 40, 'ubuntu_!bold.ttf', 30)

-- Добавить блок
activity.textures.add = display.newImage('Image/add.png')
activity.textures.add.x, activity.textures.add.y = _x - _aX + 193, _y + _aY - 124
activity.textures.add.alpha, activity.textures.add.type = 0.9, 'add'

-- Импортировать проект
activity.textures.play = display.newImage('Image/play.png')
activity.textures.play.x, activity.textures.play.y = _x + _aX - 193, _y + _aY - 124
activity.textures.play.alpha, activity.textures.play.type = 0.9, 'play'

-- Выпадающий список действий
activity.textures.list = display.newImage('Image/listopenbut.png')
activity.textures.list.x, activity.textures.list.y = _x + _aX - 100, _y - _aY + 85
activity.textures.list.width, activity.textures.list.height = 103.2, 84
activity.textures.list.type = 'list'

-- Подтверждение действия
activity.textures.okay = display.newImage('Image/okay.png')
activity.textures.okay.x, activity.textures.okay.y = _x + _aX - 193, _y + _aY - 124
activity.textures.okay.alpha, activity.textures.okay.type = 0.9, 'okay'
activity.textures.okay.isVisible, activity.textures.okay.num = false, 0

-- Добавление графических элементов в активити группу
activity.textures.group:insert(activity.textures.bg)
activity.textures.group:insert(activity.textures.title)
activity.textures.group:insert(activity.textures.act)
activity.textures.group:insert(activity.textures.add)
activity.textures.group:insert(activity.textures.play)
activity.textures.group:insert(activity.textures.list)
activity.textures.group:insert(activity.textures.okay)

-- Слушатель прикосновений
activity.textures.onClick = function(e) activity.onClick(activity.objects.texture, 'textures', e) return true end
activity.textures.add:addEventListener('touch', activity.textures.onClick)
activity.textures.play:addEventListener('touch', activity.textures.onClick)
activity.textures.list:addEventListener('touch', activity.textures.onClick)
activity.textures.okay:addEventListener('touch', activity.textures.onClick)

activity.textures.hide = function()
  activity.textures.group.isVisible = false
  activity.textures[activity.objects.texture].scroll.isVisible = false
end

activity.textures.view = function()
  activity.textures.group.isVisible = true
  activity.textures[activity.objects.texture].scroll.isVisible = true
end

activity.textures.create = function(data)
  activity.textures.group.isVisible = true

  if activity.textures[activity.objects.texture] then activity.textures.view()
  else
    local data = data or ccodeToJson(activity.programs.name)
    activity.textures[activity.objects.texture] = {}

    -- Переменные активити
    activity.textures[activity.objects.texture].data = {}
    activity.textures[activity.objects.texture].dataOption = {}
    activity.textures[activity.objects.texture].scrollHeight = 20
    activity.textures[activity.objects.texture].listMany = false
    activity.textures[activity.objects.texture].listPressNum = 1
    activity.textures[activity.objects.texture].listActive = false
    activity.textures[activity.objects.texture].targetActive = false
    activity.textures[activity.objects.texture].importActive = false

    -- Скролл и блоков
    activity.textures[activity.objects.texture].scroll = widget.newScrollView(activity.scrollSettings)
    activity.textures[activity.objects.texture].scroll:setScrollHeight(20)
    activity.textures[activity.objects.texture].block = {}

    for i = 1, #data.scenes do
      if data.scenes[i].name == activity.scenes.scene then
        for j = 1, #data.scenes[i].objects do
          if data.scenes[i].objects[j].name == activity.objects.object then
            local import = data.scenes[i].objects[j].import
            local json = data.scenes[i].objects[j].textures
            for k = 1, #json do
              activity.textures[activity.objects.texture].data[#activity.textures[activity.objects.texture].data+1] = json[k]
              activity.textures[activity.objects.texture].dataOption[#activity.textures[activity.objects.texture].data] = import
            end
          end
        end
      end
    end

    for i = 1, #activity.textures[activity.objects.texture].data do
      countGenBlocks = countGenBlocks + 1
      activity.newBlock({
        i = i,
        group = activity.textures[activity.objects.texture],
        type = 'textures',
        name = activity.objects.texture,
        import = activity.textures[activity.objects.texture].dataOption[i]
      })
    end

    activity.textures[activity.objects.texture].scroll:setScrollHeight(activity.textures[activity.objects.texture].scrollHeight)

    if not activity.createActivity[activity.objects.texture .. '_texture'] then
      activity.createActivity[activity.objects.texture .. '_texture'] = true
      activity.textures[activity.objects.texture].onKeyEvent = function(event)
        if activity.textures[activity.objects.texture] then
          if (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and not activity.textures[activity.objects.texture].alertActive and not activity.textures[activity.objects.texture].importActive and not activity.textures[activity.objects.texture].targetActive and event.phase == 'up' and activity.textures[activity.objects.texture].scroll.isVisible then
            activity.textures[activity.objects.texture].scroll.isVisible = false
            timer.performWithDelay(1, function() if not alertActive then
              activity.returnModule('textures', activity.objects.texture)
              activity.textures.hide()
              activity.objects.view()
            else activity.textures[activity.objects.texture].scroll.isVisible = true
            end end) display.getCurrentStage():setFocus(nil)
          elseif (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and activity.textures[activity.objects.texture].alertActive and not activity.textures[activity.objects.texture].importActive and not activity.textures[activity.objects.texture].targetActive and event.phase == 'up' and activity.textures[activity.objects.texture].scroll.isVisible then
            activity.textures[activity.objects.texture].alertActive = false
            activity.textures[activity.objects.texture].listPressNum = 1

            activity.textures.add.isVisible = true
            activity.textures.play.isVisible = true
            activity.textures.okay.isVisible = false
            for i = 1, #activity.textures[activity.objects.texture].block do
              activity.textures[activity.objects.texture].block[i].checkbox.isVisible = false
              activity.textures[activity.objects.texture].block[i].checkbox:setState({isOn=false})
            end
            activity.textures.act.text = ''
          end
        end
        return true
      end
      Runtime:addEventListener('key', activity.textures[activity.objects.texture].onKeyEvent)
    end
  end
end
