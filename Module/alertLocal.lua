alertLocal = function(params, listener)
  local alertLocalParams = {
    ru = {
      my_key = 'my_key -> Ничего, изменяете на нужный вам ключ, который вы хотите получить из локальной таблицы',
      x = 'x -> Позиция по оси X, на которой сейчас находится палец',
      y = 'y -> Позиция по оси Y, на которой сейчас находится палец',
      xStart = 'xStart -> Позиция по оси X, на которой находился палец при первичном нажатии на экран',
      yStart = 'yStart -> Позиция по оси Y, на которой находился палец при первичном нажатии на экран',
      name = 'name -> Имя объекта или фигуры, на который(ую) было сделано нажатие',
      isShape = 'isShape -> Логическая переменная, является ли объект, на который было сделано нажатие, фигурой',
      self_id = 'self_id -> Номер конструкции текущего объекта',
      other_id = 'other_id -> Номер конструкции второго объекта',
      self_name = 'self_name -> Имя текущего объекта или текущей фигуры',
      other_name = 'other_name -> Имя второго объекта или второй фигуры',
      self_tag = 'self_tag -> Тег текущего объекта или текущей фигуры',
      other_tag = 'other_tag -> Тег второго объекта или второй фигуры',
      self_isShape = 'self_isShape -> Логическая переменная, является ли текущий столкнувшийся объект фигурой',
      other_isShape = 'other_isShape -> Логическая переменная, является ли второй столкнувшийся объект фигурой',
    }, en = {
      my_key = 'my_key -> Nothing, change to the key you want, which you want to get from the local table',
      x = 'x -> The X-axis position where the finger is currently located',
      y = 'y -> The Y-axis position where the finger is currently located',
      xStart = 'xStart -> The X-axis position where your finger was when you first tapped the screen',
      yStart = 'yStart -> The Y-axis position where your finger was when you first tapped the screen',
      name = 'name -> The name of the object or shape that was clicked',
      isShape = 'isShape -> Boolean whether the clicked object is a shape',
      self_id = 'self_id -> Construction number of the current object',
      other_id = 'other_id -> Construction number of the second object',
      self_name = 'self_name -> The name of the current object or current shape',
      other_name = 'other_name -> The name of the current object or second shape',
      self_tag = 'self_tag -> The tag of the current object or current shape',
      other_tag = 'other_tag -> The tag of the current object or second shape',
      self_isShape = 'self_isShape -> Boolean whether the current colliding object is a shape',
      other_isShape = 'other_isShape -> Boolean whether the second colliding object is a shape',
    }
  }

  local alertLocalGroup = display.newGroup() alertActive = true
  local alertLocalHeight = (100 * #params + 20) > 420 and 420 or 100 * #params + 20
  local alertLocalButtons = {}
  local alertLocalTexts = {}
  local alertLocalUpY = _y - alertLocalHeight / 2 - 100

  local function onKeyEventAlertLocal(event)
    if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' and alertActive then
      alertActive = false alertLocalGroup:removeSelf()
      Runtime:removeEventListener('key', onKeyEventAlertLocal)
      listener({text=''})
    end return true
  end Runtime:addEventListener('key', onKeyEventAlertLocal)

  local alertLocalRect = display.newRoundedRect(alertLocalGroup, _x, _y, _aW - 144, alertLocalHeight, 14)
  alertLocalRect:setFillColor(0.2, 0.2, 0.22)

  local alertLocalScroll = widget.newScrollView({
    x = _x,
    y = _y,
    width = _aW - 144,
    height = alertLocalHeight,
    hideBackground = true,
    hideScrollBar = true,
    horizontalScrollDisabled = true,
    isBounceEnabled = true,
    listener = function(e) return true end
  }) alertLocalGroup:insert(alertLocalScroll)

  for i = 1, #params do
    alertLocalButtons[i] = display.newRect(alertLocalGroup, (_aW - 144) / 2, 60 + 100 * (i - 1), _aW - 180, 90)
    alertLocalButtons[i]:setFillColor(0.2, 0.2, 0.22) alertLocalButtons[i].id = params[i]
    alertLocalButtons[i].text = display.newText({
      parent = alertLocalGroup, width = _aW - 200, height = 88,
      text = alertLocalParams[settings.language][params[i]], font = 'ubuntu.ttf', fontSize = 24,
      x = alertLocalButtons[i].x, y = alertLocalButtons[i].y
    }) alertLocalButtons[i]:addEventListener('touch', function(e)
      if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target:setFillColor(0.24, 0.24, 0.26)
        e.target.click = true
      elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 20) then
        alertLocalScroll:takeFocus(e)
        e.target:setFillColor(0.2, 0.2, 0.22)
        e.target.click = false
      elseif e.phase == 'ended' then
        display.getCurrentStage():setFocus(nil)
        e.target:setFillColor(0.2, 0.2, 0.22)
        if e.target.click then e.target.click = false
          alertActive = false alertLocalGroup:removeSelf()
          Runtime:removeEventListener('key', onKeyEventAlertLocal)
          listener({text=e.target.id})
        end
      end return true
    end) alertLocalScroll:insert(alertLocalButtons[i])
    alertLocalScroll:insert(alertLocalButtons[i].text)
  end
end
