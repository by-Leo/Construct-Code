activity.scenes = {}

-- Активити группа
activity.scenes.group = display.newGroup()

-- Фон активити
activity.scenes.bg = display.newImage('Image/bg.png')
activity.scenes.bg.x, activity.scenes.bg.y = _x, _y - _tH / 2
activity.scenes.bg.width, activity.scenes.bg.height = _aW, _aH + _tH

-- Название активити
activity.scenes.title = display.newText(strings.scenesTitle, _x - _aX + 50, _y - _aY + 80, 'ubuntu_!bold.ttf', 58)
activity.scenes.title.anchorX = 0

-- Выполняемое действие
activity.scenes.act = display.newText('', _x, _y - _aY + 40, 'ubuntu_!bold.ttf', 30)

-- Добавить блок
activity.scenes.add = display.newImage('Image/add.png')
activity.scenes.add.x, activity.scenes.add.y = _x - _aX + 193, _y + _aY - 124
activity.scenes.add.alpha, activity.scenes.add.type = 0.9, 'add'

-- Импортировать проект
activity.scenes.play = display.newImage('Image/play.png')
activity.scenes.play.x, activity.scenes.play.y = _x + _aX - 193, _y + _aY - 124
activity.scenes.play.alpha, activity.scenes.play.type = 0.9, 'play'

-- Выпадающий список действий
activity.scenes.list = display.newImage('Image/listopenbut.png')
activity.scenes.list.x, activity.scenes.list.y = _x + _aX - 100, _y - _aY + 85
activity.scenes.list.width, activity.scenes.list.height = 103.2, 84
activity.scenes.list.type = 'list'

-- Подтверждение действия
activity.scenes.okay = display.newImage('Image/okay.png')
activity.scenes.okay.x, activity.scenes.okay.y = _x + _aX - 193, _y + _aY - 124
activity.scenes.okay.alpha, activity.scenes.okay.type = 0.9, 'okay'
activity.scenes.okay.isVisible, activity.scenes.okay.num = false, 0

-- Добавление графических элементов в активити группу
activity.scenes.group:insert(activity.scenes.bg)
activity.scenes.group:insert(activity.scenes.title)
activity.scenes.group:insert(activity.scenes.act)
activity.scenes.group:insert(activity.scenes.add)
activity.scenes.group:insert(activity.scenes.play)
activity.scenes.group:insert(activity.scenes.list)
activity.scenes.group:insert(activity.scenes.okay)

-- Слушатель прикосновений
activity.scenes.onClick = function(e) activity.onClick(activity.programs.name, 'scenes', e) return true end
activity.scenes.add:addEventListener('touch', activity.scenes.onClick)
activity.scenes.play:addEventListener('touch', activity.scenes.onClick)
activity.scenes.list:addEventListener('touch', activity.scenes.onClick)
activity.scenes.okay:addEventListener('touch', activity.scenes.onClick)

activity.scenes.hide = function()
  activity.scenes.group.isVisible = false
  activity.scenes[activity.programs.name].scroll.isVisible = false
end

activity.scenes.getVarFunTable = function()
  local data = ccodeToJson(activity.programs.name)
  activity.scenes[activity.programs.name].vars = {}
  activity.scenes[activity.programs.name].funs = {}
  activity.scenes[activity.programs.name].tables = {}

  for s = 1, #data.scenes do
    for o = 1, #data.scenes[s].objects do
      for e = 1, #data.scenes[s].objects[o].events do
        for f = 1, #data.scenes[s].objects[o].events[e].formulas do
          local nameFormula = data.scenes[s].objects[o].events[e].formulas[f].name
          local paramsFormula = data.scenes[s].objects[o].events[e].formulas[f].params
          for p = 1, #activity.paramsFormulas[nameFormula] do
            if activity.paramsFormulas[nameFormula][p] == 'variable' then
              if paramsFormula[p][1] and paramsFormula[p][1][1] then
                for u = 1, #activity.scenes[activity.programs.name].vars + 1 do
                  if activity.scenes[activity.programs.name].vars[u] and paramsFormula[p][1][1] == activity.scenes[activity.programs.name].vars[u] then break
                  elseif u == #activity.scenes[activity.programs.name].vars + 1 then
                    activity.scenes[activity.programs.name].vars[#activity.scenes[activity.programs.name].vars + 1] = paramsFormula[p][1][1]
                  end
                end
              end
            elseif activity.paramsFormulas[nameFormula][p] == 'func' then
              if paramsFormula[p][1] and paramsFormula[p][1][1] then
                for u = 1, #activity.scenes[activity.programs.name].funs + 1 do
                  if activity.scenes[activity.programs.name].funs[u] and paramsFormula[p][1][1] == activity.scenes[activity.programs.name].funs[u] then break
                  elseif u == #activity.scenes[activity.programs.name].funs + 1 then
                    activity.scenes[activity.programs.name].funs[#activity.scenes[activity.programs.name].funs + 1] = paramsFormula[p][1][1]
                  end
                end
              end
            elseif activity.paramsFormulas[nameFormula][p] == 'tabl' then
              if paramsFormula[p][1] and paramsFormula[p][1][1] then
                for u = 1, #activity.scenes[activity.programs.name].tables + 1 do
                  if activity.scenes[activity.programs.name].tables[u] and paramsFormula[p][1][1] == activity.scenes[activity.programs.name].tables[u] then break
                  elseif u == #activity.scenes[activity.programs.name].tables + 1 then
                    activity.scenes[activity.programs.name].tables[#activity.scenes[activity.programs.name].tables + 1] = paramsFormula[p][1][1]
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

activity.scenes.view = function()
  activity.scenes.group.isVisible = true
  activity.scenes[activity.programs.name].scroll.isVisible = true
  activity.scenes.getVarFunTable()
end

activity.scenes.create = function(data)
  activity.scenes.group.isVisible = true

  if activity.scenes[activity.programs.name] then activity.scenes.view()
  else
    local data = data or ccodeToJson(activity.programs.name)
    activity.scenes[activity.programs.name] = {}

    -- Переменные активити
    activity.scenes[activity.programs.name].data = {}
    activity.scenes[activity.programs.name].scrollHeight = 20
    activity.scenes[activity.programs.name].listMany = false
    activity.scenes[activity.programs.name].listPressNum = 1
    activity.scenes[activity.programs.name].listActive = false
    activity.scenes[activity.programs.name].targetActive = false

    -- Скролл и блоков
    activity.scenes[activity.programs.name].scroll = widget.newScrollView(activity.scrollSettings)
    activity.scenes[activity.programs.name].scroll:setScrollHeight(20)
    activity.scenes[activity.programs.name].block = {}

    for i = 1, #data.scenes do
      activity.scenes[activity.programs.name].data[#activity.scenes[activity.programs.name].data+1] = data.scenes[i].name
    end

    for i = 1, #activity.scenes[activity.programs.name].data do
      activity.newBlock({
        i = i,
        group = activity.scenes[activity.programs.name],
        type = 'scenes',
        name = activity.programs.name
      })
    end

    activity.scenes[activity.programs.name].scroll:setScrollHeight(activity.scenes[activity.programs.name].scrollHeight)

    if not activity.createActivity[activity.programs.name] then
      activity.createActivity[activity.programs.name] = true
      activity.scenes[activity.programs.name].onKeyEvent = function(event)
        if activity.scenes[activity.programs.name] then
          if (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and not activity.scenes[activity.programs.name].targetActive and not activity.scenes[activity.programs.name].alertActive and event.phase == 'up' and activity.scenes[activity.programs.name].scroll.isVisible then
            activity.scenes[activity.programs.name].scroll.isVisible = false
            timer.performWithDelay(1, function()
              activity.returnModule('scenes', activity.programs.name)
              activity.scenes.hide()
              activity.programs.view()
            end)
            display.getCurrentStage():setFocus(nil)
          elseif (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and not activity.scenes[activity.programs.name].targetActive and activity.scenes[activity.programs.name].alertActive and event.phase == 'up' and activity.scenes[activity.programs.name].scroll.isVisible then
            activity.scenes[activity.programs.name].alertActive = false
            activity.scenes[activity.programs.name].listPressNum = 1

            activity.scenes.add.isVisible = true
            activity.scenes.play.isVisible = true
            activity.scenes.okay.isVisible = false
            for i = 1, #activity.scenes[activity.programs.name].block do
              activity.scenes[activity.programs.name].block[i].checkbox.isVisible = false
              activity.scenes[activity.programs.name].block[i].checkbox:setState({isOn=false})
            end
            activity.scenes.act.text = ''
          end
        end
        return true
      end
      Runtime:addEventListener('key', activity.scenes[activity.programs.name].onKeyEvent)
    end
  end
end
