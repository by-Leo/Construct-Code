activity.resources = {}

-- Активити группа
activity.resources.group = display.newGroup()

-- Фон активити
activity.resources.bg = display.newImage('Image/bg.png')
activity.resources.bg.x, activity.resources.bg.y = _x, _y - _tH / 2
activity.resources.bg.width, activity.resources.bg.height = _aW, _aH + _tH

-- Название активити
activity.resources.title = display.newText(strings.resourcesTitle, _x - _aX + 50, _y - _aY + 80, 'ubuntu_!bold.ttf', 58)
activity.resources.title.anchorX = 0

-- Выполняемое действие
activity.resources.act = display.newText('', _x, _y - _aY + 40, 'ubuntu_!bold.ttf', 30)

-- Добавить блок
activity.resources.add = display.newImage('Image/add.png')
activity.resources.add.x, activity.resources.add.y = _x - _aX + 193, _y + _aY - 124
activity.resources.add.alpha, activity.resources.add.type = 0.9, 'add'

-- Импортировать проект
activity.resources.play = display.newImage('Image/play.png')
activity.resources.play.x, activity.resources.play.y = _x + _aX - 193, _y + _aY - 124
activity.resources.play.alpha, activity.resources.play.type = 0.9, 'play'

-- Выпадающий список действий
activity.resources.list = display.newImage('Image/listopenbut.png')
activity.resources.list.x, activity.resources.list.y = _x + _aX - 100, _y - _aY + 85
activity.resources.list.width, activity.resources.list.height = 103.2, 84
activity.resources.list.type = 'list'

-- Подтверждение действия
activity.resources.okay = display.newImage('Image/okay.png')
activity.resources.okay.x, activity.resources.okay.y = _x + _aX - 193, _y + _aY - 124
activity.resources.okay.alpha, activity.resources.okay.type = 0.9, 'okay'
activity.resources.okay.isVisible, activity.resources.okay.num = false, 0

-- Добавление графических элементов в активити группу
activity.resources.group:insert(activity.resources.bg)
activity.resources.group:insert(activity.resources.title)
activity.resources.group:insert(activity.resources.act)
activity.resources.group:insert(activity.resources.add)
activity.resources.group:insert(activity.resources.play)
activity.resources.group:insert(activity.resources.list)
activity.resources.group:insert(activity.resources.okay)

-- Слушатель прикосновений
activity.resources.onClick = function(e) activity.onClick(activity.programs.name, 'resources', e) return true end
activity.resources.add:addEventListener('touch', activity.resources.onClick)
activity.resources.play:addEventListener('touch', activity.resources.onClick)
activity.resources.list:addEventListener('touch', activity.resources.onClick)
activity.resources.okay:addEventListener('touch', activity.resources.onClick)

activity.resources.hide = function()
  activity.resources.group.isVisible = false
  activity.resources[activity.programs.name].scroll.isVisible = false
end

activity.resources.view = function()
  activity.resources.group.isVisible = true
  activity.resources[activity.programs.name].scroll.isVisible = true
end

activity.resources.create = function(data)
  activity.resources.group.isVisible = true

  if activity.resources[activity.programs.name] then activity.resources.view()
  else
    local data = data or ccodeToJson(activity.programs.name)
    activity.resources[activity.programs.name] = {}

    -- Переменные активити
    activity.resources[activity.programs.name].data = {}
    activity.resources[activity.programs.name].scrollHeight = 20
    activity.resources[activity.programs.name].listMany = false
    activity.resources[activity.programs.name].listPressNum = 1
    activity.resources[activity.programs.name].listActive = false
    activity.resources[activity.programs.name].targetActive = false

    -- Скролл и блоков
    activity.resources[activity.programs.name].scroll = widget.newScrollView(activity.scrollSettings)
    activity.resources[activity.programs.name].scroll:setScrollHeight(20)
    activity.resources[activity.programs.name].block = {}

    for file in lfs.dir(system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name) do
      local theFile = system.pathForFile('', system.DocumentsDirectory) .. '/' .. activity.programs.name .. '/' .. file
      if type(theFile) ~= 'string' then theFile = '' end

      if lfs.attributes(theFile, 'mode') ~= 'directory' then
        pcall(function()
          local isRes, nameRes, extensionRes = utf8.match(file, '(.*)%.(.*)%.(.*)')
          if isRes and isRes == 'res ' then
            activity.resources[activity.programs.name].data[#activity.resources[activity.programs.name].data + 1] = nameRes .. '.' .. extensionRes
          end
        end)
      end
    end

    for i = 1, #activity.resources[activity.programs.name].data do
      activity.newBlock({
        i = i,
        group = activity.resources[activity.programs.name],
        type = 'resources',
        name = activity.programs.name
      })
    end

    activity.resources[activity.programs.name].scroll:setScrollHeight(activity.resources[activity.programs.name].scrollHeight)

    if not activity.createActivity[activity.programs.name .. '.res '] then
      activity.createActivity[activity.programs.name .. '.res '] = true
      activity.resources[activity.programs.name].onKeyEvent = function(event)
        if activity.resources[activity.programs.name] then
          if (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and not activity.resources[activity.programs.name].targetActive and not activity.resources[activity.programs.name].alertActive and event.phase == 'up' and activity.resources[activity.programs.name].scroll.isVisible then
            activity.resources[activity.programs.name].scroll.isVisible = false
            timer.performWithDelay(1, function() if not alertActive then
              activity.returnModule('resources', activity.programs.name)
              activity.resources.hide()
              activity.scenes.create()
            else activity.resources[activity.programs.name].scroll.isVisible = true
            end end) display.getCurrentStage():setFocus(nil)
          elseif (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and not activity.resources[activity.programs.name].targetActive and activity.resources[activity.programs.name].alertActive and event.phase == 'up' and activity.resources[activity.programs.name].scroll.isVisible then
            activity.resources[activity.programs.name].alertActive = false
            activity.resources[activity.programs.name].listPressNum = 1

            activity.resources.add.isVisible = true
            activity.resources.play.isVisible = true
            activity.resources.okay.isVisible = false
            for i = 1, #activity.resources[activity.programs.name].block do
              activity.resources[activity.programs.name].block[i].checkbox.isVisible = false
              activity.resources[activity.programs.name].block[i].checkbox:setState({isOn=false})
            end
            activity.resources.act.text = ''
          end
        end
        return true
      end
      Runtime:addEventListener('key', activity.resources[activity.programs.name].onKeyEvent)
    end
  end
end
