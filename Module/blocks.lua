activity.blocks = {}

-- Активити группа
activity.blocks.group = display.newGroup()

-- Фон активити
activity.blocks.bg = display.newImage('Image/bg.png')
activity.blocks.bg.x, activity.blocks.bg.y = _x, _y - _tH / 2
activity.blocks.bg.width, activity.blocks.bg.height = _aW, _aH + _tH

-- Название активити
activity.blocks.title = display.newText(strings.blocksTitle, _x - _aX + 50, _y - _aY + 80, 'ubuntu_!bold.ttf', 58)
activity.blocks.title.anchorX = 0

-- Выполняемое действие
activity.blocks.act = display.newText('', _x, _y - _aY + 40, 'ubuntu_!bold.ttf', 30)

-- Добавить блок
activity.blocks.add = display.newImage('Image/add.png')
activity.blocks.add.x, activity.blocks.add.y = _x - _aX + 193, _y + _aY - 124
activity.blocks.add.alpha, activity.blocks.add.type = 0.9, 'add'

-- Импортировать проект
activity.blocks.play = display.newImage('Image/play.png')
activity.blocks.play.x, activity.blocks.play.y = _x + _aX - 193, _y + _aY - 124
activity.blocks.play.alpha, activity.blocks.play.type = 0.9, 'play'

-- Выпадающий список действий
activity.blocks.list = display.newImage('Image/listopenbut.png')
activity.blocks.list.x, activity.blocks.list.y = _x + _aX - 100, _y - _aY + 85
activity.blocks.list.width, activity.blocks.list.height = 103.2, 84
activity.blocks.list.type = 'list'

-- Подтверждение действия
activity.blocks.okay = display.newImage('Image/okay.png')
activity.blocks.okay.x, activity.blocks.okay.y = _x + _aX - 193, _y + _aY - 124
activity.blocks.okay.alpha, activity.blocks.okay.type = 0.9, 'okay'
activity.blocks.okay.isVisible, activity.blocks.okay.num = false, 0

-- Добавление графических элементов в активити группу
activity.blocks.group:insert(activity.blocks.bg)
activity.blocks.group:insert(activity.blocks.title)
activity.blocks.group:insert(activity.blocks.act)
activity.blocks.group:insert(activity.blocks.add)
activity.blocks.group:insert(activity.blocks.play)
activity.blocks.group:insert(activity.blocks.list)
activity.blocks.group:insert(activity.blocks.okay)

-- Слушатель прикосновений
activity.blocks.onClick = function(e) activity.onClick(activity.objects.name, 'blocks', e) return true end
activity.blocks.add:addEventListener('touch', activity.blocks.onClick)
activity.blocks.play:addEventListener('touch', activity.blocks.onClick)
activity.blocks.list:addEventListener('touch', activity.blocks.onClick)
activity.blocks.okay:addEventListener('touch', activity.blocks.onClick)

activity.blocks.hide = function()
  activity.blocks.group.isVisible = false
  activity.blocks[activity.objects.name].scroll.isVisible = false
end

activity.blocks.view = function()
  activity.blocks.group.isVisible = true
  activity.blocks[activity.objects.name].scroll.isVisible = true
end

activity.blocks.create = function(data)
  activity.blocks.group.isVisible = true

  if activity.blocks[activity.objects.name] then activity.blocks.view()
  else
    local data = data or ccodeToJson(activity.programs.name)
    activity.blocks[activity.objects.name] = {}

    -- Переменные активити
    activity.blocks[activity.objects.name].data = {}
    activity.blocks[activity.objects.name].scrollHeight = 20
    activity.blocks[activity.objects.name].blockY = -66
    activity.blocks[activity.objects.name].listMany = false
    activity.blocks[activity.objects.name].listPressNum = 0
    activity.blocks[activity.objects.name].listActive = false
    activity.blocks[activity.objects.name].targetActive = false

    -- Скролл и блоки
    activity.blocks[activity.objects.name].scroll = widget.newScrollView({
      x = _x,
      y = _y - 35,
      width = _pW,
      height = _aH-400,
      hideBackground = true,
      hideScrollBar = true,
      horizontalScrollDisabled = true,
      isBounceEnabled = true,
      listener = function(e)
        return true
      end
    })
    activity.blocks[activity.objects.name].scroll:setScrollHeight(20)
    activity.blocks[activity.objects.name].block = {}

    for i = 1, #data.scenes do
      if data.scenes[i].name == activity.scenes.scene then
        for j = 1, #data.scenes[i].objects do
          if data.scenes[i].objects[j].name == activity.objects.object then
            for e = 1, #data.scenes[i].objects[j].events do
              activity.blocks[activity.objects.name].data[#activity.blocks[activity.objects.name].data+1] = {
                name = data.scenes[i].objects[j].events[e].name,
                params = data.scenes[i].objects[j].events[e].params,
                comment = data.scenes[i].objects[j].events[e].comment,
                type = 'event'
              }
              for f = 1, #data.scenes[i].objects[j].events[e].formulas do
                activity.blocks[activity.objects.name].data[#activity.blocks[activity.objects.name].data+1] = {
                  name = data.scenes[i].objects[j].events[e].formulas[f].name,
                  params = data.scenes[i].objects[j].events[e].formulas[f].params,
                  comment = data.scenes[i].objects[j].events[e].formulas[f].comment,
                  type = 'formula'
                }
              end
            end
            break
          end
        end
        break
      end
    end

    for i = 1, #activity.blocks[activity.objects.name].data do activity.genBlock(i) end
    activity.scrollHeightUpdate()
    activity.blocks[activity.objects.name].scroll:setScrollHeight(
    activity.blocks[activity.objects.name].scrollHeight)

    if not activity.createActivity[activity.objects.name] then
      activity.createActivity[activity.objects.name] = true
      activity.blocks[activity.objects.name].onKeyEvent = function(event)
        if activity.blocks[activity.objects.name] then
          if (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and not activity.blocks[activity.objects.name].alertActive and not activity.blocks[activity.objects.name].targetActive and event.phase == 'up' and activity.blocks[activity.objects.name].scroll.isVisible then
            activity.blocks[activity.objects.name].scroll.isVisible = false
            timer.performWithDelay(1, function()
              activity.returnModule('blocks', activity.objects.name)
              activity.blocks.hide()
              activity.objects.view()
            end)
            display.getCurrentStage():setFocus(nil)
          elseif (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and activity.blocks[activity.objects.name].alertActive and not activity.blocks[activity.objects.name].targetActive and event.phase == 'up' and activity.blocks[activity.objects.name].scroll.isVisible then
            activity.blocks[activity.objects.name].alertActive = false
            activity.blocks[activity.objects.name].listPressNum = 0

            activity.blocks.add.isVisible = true
            activity.blocks.play.isVisible = true
            activity.blocks.okay.isVisible = false
            for i = 1, #activity.blocks[activity.objects.name].block do
              activity.blocks[activity.objects.name].block[i].x = activity.blocks[activity.objects.name].block[i].x - 20
              activity.blocks[activity.objects.name].block[i].text.x = activity.blocks[activity.objects.name].block[i].text.x - 20

              if activity.blocks[activity.objects.name].block[i].data.type == 'formula' then
                activity.blocks[activity.objects.name].block[i].corner.x = activity.blocks[activity.objects.name].block[i].corner.x - 20
              end

              if activity.blocks[activity.objects.name].block[i].params then
                for p = 1, #activity.blocks[activity.objects.name].block[i].params do
                  activity.blocks[activity.objects.name].block[i].params[p].name.x = activity.blocks[activity.objects.name].block[i].params[p].name.x - 20
                  activity.blocks[activity.objects.name].block[i].params[p].line.x = activity.blocks[activity.objects.name].block[i].params[p].line.x - 20
                  activity.blocks[activity.objects.name].block[i].params[p].text.x = activity.blocks[activity.objects.name].block[i].params[p].text.x - 20
                  activity.blocks[activity.objects.name].block[i].params[p].rect.isVisible = true
                end
              end

              activity.blocks[activity.objects.name].block[i].checkbox.isVisible = false
              activity.blocks[activity.objects.name].block[i].checkbox:setState({isOn=false})
            end
            activity.blocks.act.text = ''
          end
        end
        return true
      end
      Runtime:addEventListener('key', activity.blocks[activity.objects.name].onKeyEvent)
    end
  end
end
