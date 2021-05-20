activity.programs = {}

-- Активити группа
activity.programs.group = display.newGroup()

-- Фон активити
activity.programs.bg = display.newImage('Image/bg.png')
activity.programs.bg.x, activity.programs.bg.y = _x, _y - _tH / 2
activity.programs.bg.width, activity.programs.bg.height = _aW, _aH + _tH

-- Название активити
activity.programs.title = display.newText(strings.programsTitle, _x - _aX + 50, _y - _aY + 80, 'ubuntu_!bold.ttf', 58)
activity.programs.title.anchorX = 0

-- Выполняемое действие
activity.programs.act = display.newText('', _x, _y - _aY + 40, 'ubuntu_!bold.ttf', 30)

-- Добавить блок
activity.programs.add = display.newImage('Image/add.png')
activity.programs.add.x, activity.programs.add.y = _x - _aX + 193, _y + _aY - 124
activity.programs.add.alpha, activity.programs.add.type = 0.9, 'add'

-- Импортировать проект
activity.programs.import = display.newImage('Image/import.png')
activity.programs.import.x, activity.programs.import.y = _x + _aX - 193, _y + _aY - 124
activity.programs.import.alpha, activity.programs.import.type = 0.9, 'import'

-- Выпадающий список действий
activity.programs.list = display.newImage('Image/listopenbut.png')
activity.programs.list.x, activity.programs.list.y = _x + _aX - 100, _y - _aY + 85
activity.programs.list.width, activity.programs.list.height = 103.2, 84
activity.programs.list.type = 'list'

-- Подтверждение действия
activity.programs.okay = display.newImage('Image/okay.png')
activity.programs.okay.x, activity.programs.okay.y = _x + _aX - 193, _y + _aY - 124
activity.programs.okay.alpha, activity.programs.okay.type = 0.9, 'okay'
activity.programs.okay.isVisible, activity.programs.okay.num = false, 0

-- Добавление графических элементов в активити группу
activity.programs.group:insert(activity.programs.bg)
activity.programs.group:insert(activity.programs.title)
activity.programs.group:insert(activity.programs.act)
activity.programs.group:insert(activity.programs.add)
activity.programs.group:insert(activity.programs.import)
activity.programs.group:insert(activity.programs.list)
activity.programs.group:insert(activity.programs.okay)

-- Слушатель прикосновений
activity.programs.onClick = function(e) activity.onClick('nil', 'programs', e) return true end
activity.programs.add:addEventListener('touch', activity.programs.onClick)
activity.programs.import:addEventListener('touch', activity.programs.onClick)
activity.programs.list:addEventListener('touch', activity.programs.onClick)
activity.programs.okay:addEventListener('touch', activity.programs.onClick)

activity.programs.hide = function()
  activity.programs.group.isVisible = false
  activity.programs['nil'].scroll.isVisible = false
end

activity.programs.view = function()
  activity.programs.group.isVisible = true
  activity.programs['nil'].scroll.isVisible = true
end

activity.programs.create = function()
  activity.programs.group.isVisible = true

  if activity.programs['nil'] then activity.programs.view()
  else
    activity.programs['nil'] = {}

    -- Переменные активити
    activity.programs['nil'].data = {}
    activity.programs['nil'].scrollHeight = 20
    activity.programs['nil'].listMany = false
    activity.programs['nil'].listPressNum = 1
    activity.programs['nil'].listActive = false
    activity.programs['nil'].targetActive = false

    -- Скролл и блоков
    activity.programs['nil'].scroll = widget.newScrollView(activity.scrollSettings)
    activity.programs['nil'].scroll:setScrollHeight(20)
    activity.programs['nil'].block = {}

    local path = system.pathForFile('Programs.txt', system.DocumentsDirectory)
    local file = io.open(path, 'r')

    if file then
      for line in file:lines() do
        activity.programs['nil'].data[#activity.programs['nil'].data+1] = line
      end
      io.close(file)
    end

    for i = 1, #activity.programs['nil'].data do
      activity.newBlock({
        i = i,
        group = activity.programs['nil'],
        type = 'programs',
        name = 'nil'
      })
    end activity.programs['nil'].scroll:setScrollHeight(activity.programs['nil'].scrollHeight)

    activity.programs['nil'].onKeyEvent = function(event)
      if (event.keyName == "back" or event.keyName == "escape") and not alertActive and not activity.programs['nil'].alertActive and event.phase == 'up' and activity.programs['nil'].scroll.isVisible then
        timer.performWithDelay(1, function() if not alertActive then
          activity.returnModule('programs', 'nil')
          activity.programs.hide()
          visibleMenu(true)
        end end) display.getCurrentStage():setFocus(nil)
      elseif (event.keyName == "back" or event.keyName == "escape") and not alertActive and activity.programs['nil'].alertActive and event.phase == 'up' and activity.programs['nil'].scroll.isVisible then
        activity.programs['nil'].alertActive = false
        activity.programs['nil'].listPressNum = 1

        activity.programs.add.isVisible = true
        activity.programs.import.isVisible = true
        activity.programs.okay.isVisible = false
        for i = 1, #activity.programs['nil'].block do
          activity.programs['nil'].block[i].checkbox.isVisible = false
          activity.programs['nil'].block[i].checkbox:setState({isOn=false})
        end
        activity.programs.act.text = ''
      end
      return true
    end
    Runtime:addEventListener('key', activity.programs['nil'].onKeyEvent)
  end
end
