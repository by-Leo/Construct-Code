activity.objects = {}

-- Активити группа
activity.objects.group = display.newGroup()

-- Фон активити
activity.objects.bg = display.newImage('Image/bg.png')
activity.objects.bg.x, activity.objects.bg.y = _x, _y - _tH / 2
activity.objects.bg.width, activity.objects.bg.height = _aW, _aH + _tH

-- Название активити
activity.objects.title = display.newText(strings.objectsTitle, _x - _aX + 50, _y - _aY + 80, 'ubuntu_!bold.ttf', 58)
activity.objects.title.anchorX = 0

-- Выполняемое действие
activity.objects.act = display.newText('', _x, _y - _aY + 40, 'ubuntu_!bold.ttf', 30)

-- Добавить блок
activity.objects.add = display.newImage('Image/add.png')
activity.objects.add.x, activity.objects.add.y = _x - _aX + 193, _y + _aY - 124
activity.objects.add.alpha, activity.objects.add.type = 0.9, 'add'

-- Импортировать проект
activity.objects.play = display.newImage('Image/play.png')
activity.objects.play.x, activity.objects.play.y = _x + _aX - 193, _y + _aY - 124
activity.objects.play.alpha, activity.objects.play.type = 0.9, 'play'

-- Выпадающий список действий
activity.objects.list = display.newImage('Image/listopenbut.png')
activity.objects.list.x, activity.objects.list.y = _x + _aX - 100, _y - _aY + 85
activity.objects.list.width, activity.objects.list.height = 103.2, 84
activity.objects.list.type = 'list'

-- Подтверждение действия
activity.objects.okay = display.newImage('Image/okay.png')
activity.objects.okay.x, activity.objects.okay.y = _x + _aX - 193, _y + _aY - 124
activity.objects.okay.alpha, activity.objects.okay.type = 0.9, 'okay'
activity.objects.okay.isVisible, activity.objects.okay.num = false, 0

-- Добавление графических элементов в активити группу
activity.objects.group:insert(activity.objects.bg)
activity.objects.group:insert(activity.objects.title)
activity.objects.group:insert(activity.objects.act)
activity.objects.group:insert(activity.objects.add)
activity.objects.group:insert(activity.objects.play)
activity.objects.group:insert(activity.objects.list)
activity.objects.group:insert(activity.objects.okay)

-- Слушатель прикосновений
activity.objects.onClick = function(e) activity.onClick(activity.scenes.name, 'objects', e) return true end
activity.objects.add:addEventListener('touch', activity.objects.onClick)
activity.objects.play:addEventListener('touch', activity.objects.onClick)
activity.objects.list:addEventListener('touch', activity.objects.onClick)
activity.objects.okay:addEventListener('touch', activity.objects.onClick)

activity.objects.hide = function()
  activity.objects.group.isVisible = false
  activity.objects[activity.scenes.name].scroll.isVisible = false
end

activity.objects.view = function()
  activity.objects.group.isVisible = true
  activity.objects[activity.scenes.name].scroll.isVisible = true
end

activity.objects.create = function(data)
  activity.objects.group.isVisible = true

  if activity.objects[activity.scenes.name] then activity.objects.view()
  else
    local data = data or ccodeToJson(activity.programs.name)
    activity.objects[activity.scenes.name] = {}

    -- Переменные активити
    activity.objects[activity.scenes.name].data = {}
    activity.objects[activity.scenes.name].dataOption = {}
    activity.objects[activity.scenes.name].scrollHeight = 20
    activity.objects[activity.scenes.name].listMany = false
    activity.objects[activity.scenes.name].listPressNum = 1
    activity.objects[activity.scenes.name].listActive = false
    activity.objects[activity.scenes.name].targetActive = false
    activity.objects[activity.scenes.name].importActive = false

    -- Скролл и блоков
    activity.objects[activity.scenes.name].scroll = widget.newScrollView(activity.scrollSettings)
    activity.objects[activity.scenes.name].scroll:setScrollHeight(20)
    activity.objects[activity.scenes.name].block = {}

    for i = 1, #data.scenes do
      if data.scenes[i].name == activity.scenes.scene then
        for j = 1, #data.scenes[i].objects do
          activity.objects[activity.scenes.name].data[#activity.objects[activity.scenes.name].data+1] = data.scenes[i].objects[j].name
          activity.objects[activity.scenes.name].dataOption[#activity.objects[activity.scenes.name].data] = {
            import = data.scenes[i].objects[j].import,
            json = data.scenes[i].objects[j].textures
          }
        end
        break
      end
    end

    for i = 1, #activity.objects[activity.scenes.name].data do
      activity.newBlock({
        i = i,
        group = activity.objects[activity.scenes.name],
        type = 'objects',
        name = activity.scenes.name,
        import = activity.objects[activity.scenes.name].dataOption[i].import,
        json = activity.objects[activity.scenes.name].dataOption[i].json
      })
    end

    activity.objects[activity.scenes.name].scroll:setScrollHeight(activity.objects[activity.scenes.name].scrollHeight)

    if not activity.createActivity[activity.scenes.name] then
      activity.createActivity[activity.scenes.name] = true
      activity.objects[activity.scenes.name].onKeyEvent = function(event)
        if activity.objects[activity.scenes.name] then
          if (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and not activity.objects[activity.scenes.name].alertActive and not activity.objects[activity.scenes.name].importActive and not activity.objects[activity.scenes.name].targetActive and event.phase == 'up' and activity.objects[activity.scenes.name].scroll.isVisible then
            activity.objects[activity.scenes.name].scroll.isVisible = false
            timer.performWithDelay(1, function()
              activity.returnModule('objects', activity.scenes.name)
              activity.objects.hide()
              activity.scenes.view()
            end)
            display.getCurrentStage():setFocus(nil)
          elseif (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and activity.objects[activity.scenes.name].alertActive and not activity.objects[activity.scenes.name].importActive and not activity.objects[activity.scenes.name].targetActive and event.phase == 'up' and activity.objects[activity.scenes.name].scroll.isVisible then
            activity.objects[activity.scenes.name].alertActive = false
            activity.objects[activity.scenes.name].listPressNum = 1

            activity.objects.add.isVisible = true
            activity.objects.play.isVisible = true
            activity.objects.okay.isVisible = false
            for i = 1, #activity.objects[activity.scenes.name].block do
              activity.objects[activity.scenes.name].block[i].checkbox.isVisible = false
              activity.objects[activity.scenes.name].block[i].checkbox:setState({isOn=false})
            end
            activity.objects.act.text = ''
          end
        end
        return true
      end
      Runtime:addEventListener('key', activity.objects[activity.scenes.name].onKeyEvent)
    end
  end
end
