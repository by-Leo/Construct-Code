list = function(buttons, config, listener)
  local listGroup = display.newGroup()
  alertActive = true

  for i = 1, #buttons do
    if buttons[i] == config.activeBut then
      table.remove(buttons, i)
      table.insert(buttons, 1, config.activeBut)
      break
    end
  end

  local function onKeyEventList(event)
    if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
      alertActive = false
      listGroup:removeSelf()
      Runtime:removeEventListener('key', onKeyEventList)
      listener({num = 0})
    end
    return true
  end
  Runtime:addEventListener('key', onKeyEventList)

  local listBg = display.newRect(listGroup, _x, _y, 5000, 5000)
  listBg:setFillColor(1, 0.005)

  listBg:addEventListener('touch', function(e)
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
      display.getCurrentStage():setFocus(nil)

      alertActive = false
      listGroup:removeSelf()
      Runtime:removeEventListener('key', onKeyEventList)
      listener({num = 0})
    end
    return true
  end)

  config.realHeight = #buttons * 100
  config.height = #buttons * 100
  config.width = 0

  if (config.y + config.height / 2 - config.targetHeight / 2) + config.height / 2 > 1200 and config.y <= _y then
    local buts = math.round((1200 - config.y) / 100)
    config.height = buts * 100
  elseif config.y > _y and (config.y - config.height / 2 - config.targetHeight / 2) - config.height / 2 < 80 then
    local buts = math.round((config.y-80) / 100)
    config.height = buts * 100
  end

  for i = 1, #buttons do
    local text = display.newText({
      text = buttons[i], x = 0, y = 0,
      font = 'ubuntu_!bold.ttf', fontSize = 36, height = 44
    })

    if text.width > config.width and text.width <= _aW then config.width = text.width
    elseif text.width > config.width then config.width = _aW end
    text:removeSelf()
  end

  if config.width < _aW then config.width = config.width + 60 end
  if config.width > _aW then config.width = _aW end
  if config.x + config.width / 2 > _x + _aX then config.x = _x + _aX - config.width / 2 end

  local listRoundedRect = display.newRoundedRect(listGroup, config.x, config.y > _y and config.y - config.height / 2 + config.targetHeight / 2 or config.y + config.height / 2 - config.targetHeight / 2, config.width, config.height + 20, 14)
  listRoundedRect:setFillColor(0.2, 0.2, 0.22)

  local listScroll = widget.newScrollView({
    x = config.x,
    y = config.y > _y and config.y - config.height / 2 + config.targetHeight / 2 or config.y + config.height / 2 - config.targetHeight / 2,
    width = config.width,
    height = config.height,
    hideBackground = true,
    hideScrollBar = true,
    horizontalScrollDisabled = true,
    isBounceEnabled = true,
    listener = function(e)
      return true
    end
  })
  listGroup:insert(listScroll)

  local listRect = display.newRect(config.width / 2, config.height / 2, config.width, config.realHeight + 5000)
  listRect:setFillColor(0.2, 0.2, 0.22)
  listScroll:insert(listRect)

  for i = 1, #buttons do
    local but = display.newRect(config.width / 2, 50 + 100 * (i-1) , config.width, 100)
    but:setFillColor(0.2, 0.2, 0.22)
    but.num = i

    local text = display.newText({
      text = buttons[i], width = config.width - 40, height = 44, align = 'left',
      fontSize = 36, x = config.width / 2 + 10, y = 50 + 100 * (i-1), font = 'ubuntu_!bold.ttf'
    })

    listScroll:insert(but)
    listScroll:insert(text)

    but:addEventListener('touch', function(e)
      if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target:setFillColor(0.22, 0.22, 0.24)
      elseif e.phase == 'moved' then
        local dy = math.abs(e.y - e.yStart)
        if dy > 20 then
          listScroll:takeFocus(e)
          e.target:setFillColor(0.2, 0.2, 0.22)
        end
      elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        e.target:setFillColor(0.2, 0.2, 0.22)

        alertActive = false
        listGroup:removeSelf()
        Runtime:removeEventListener('key', onKeyEventList)
        listener({num = e.target.num, text = buttons[e.target.num]})
      end
      return true
    end)
  end

  listScroll:setScrollHeight(70 * #buttons)
end
