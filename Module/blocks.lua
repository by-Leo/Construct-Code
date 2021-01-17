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
    local create, data = data, data or ccodeToJson(activity.programs.name)
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
    activity.blocks[activity.objects.name].block = {}

    local group, name, k, genBlockOpt = activity.blocks[activity.objects.name], activity.objects.name, 0

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

    local c = #group.data
    local d = c % 300
    local u = c - d
    local b = c >= 300 and u / 300 or 1
    local a = 0
    local k = 1
    local r = 0
    local p = c >= 300

    local newKeyEvent = function()
      if not activity.createActivity[name] then
        activity.createActivity[name] = true
        group.onKeyEvent = function(event)
          if group then
            if (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and not group.alertActive and not group.targetActive and event.phase == 'up' and group.scroll.isVisible then
              group.scroll.isVisible = false
              timer.performWithDelay(1, function()
                activity.returnModule('blocks', name)
                activity.blocks.hide()
                activity.objects.view()
              end)
              display.getCurrentStage():setFocus(nil)
            elseif (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and group.alertActive and not group.targetActive and event.phase == 'up' and group.scroll.isVisible then
              group.alertActive = false
              group.listPressNum = 0

              activity.blocks.add.isVisible = true
              activity.blocks.play.isVisible = true
              activity.blocks.okay.isVisible = false
              for i = 1, #group.block do
                group.block[i].x = group.block[i].x - 20
                group.block[i].text.x = group.block[i].text.x - 20

                if group.block[i].data.type == 'formula' then
                  group.block[i].corner.x = group.block[i].corner.x - 20
                end

                if group.block[i].params then
                  for p = 1, #group.block[i].params do
                    group.block[i].params[p].name.x = group.block[i].params[p].name.x - 20
                    group.block[i].params[p].line.x = group.block[i].params[p].line.x - 20
                    group.block[i].params[p].text.x = group.block[i].params[p].text.x - 20
                    group.block[i].params[p].rect.isVisible = true
                  end
                end

                group.block[i].checkbox.isVisible = false
                group.block[i].checkbox:setState({isOn=false})
              end
              activity.blocks.act.text = ''
            end
          end
          return true
        end
        Runtime:addEventListener('key', group.onKeyEvent)
      end
    end

    timer.performWithDelay(1, function() k, r = k + 1, r + 1
      local r, k = r, k timer.performWithDelay(k, function() a = a + 1
        if p then for i = 1, 300 do
          activity.genBlock(i + (r - 1) * 300, group)
          countGenBlocks = countGenBlocks + 1
          if create then progressView:setProgress(countGenBlocks / countBlocks) end
        end end if a == b and d ~= 0 then
          timer.performWithDelay(1, function()
            local r = p and u or 0 for i = 1, d do
              activity.genBlock(r + i, group)
              countGenBlocks = countGenBlocks + 1
              if create then progressView:setProgress(countGenBlocks / countBlocks) end
            end
            activity.scrollHeightUpdate(group)
            group.scroll:setScrollHeight(group.scrollHeight)
            newKeyEvent() if create then genBlocks() else activity.blocks.view() end
          end)
        end
      end)
    end, b) if c == 0 then newKeyEvent() end if not create and c == 0 then activity.blocks.view() end
  end
end
