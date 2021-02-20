local alertUpload = true

alert = function(title, text, buttons, listener, checkboxText)
  local alertGroup = display.newGroup()
  local alertButtonResizeWidth = 225
  local alertButtonResizeHeight = 92
  alertActive = true

  local function onKeyEventAlert( event )
    if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
      alertActive = false
      alertGroup:removeSelf()
      Runtime:removeEventListener('key', onKeyEventAlert)
      listener({num = 0, isOn = false})
    end
    return true
  end
  Runtime:addEventListener('key', onKeyEventAlert)

  local alertHeightText = display.newText({
    text = text, font = 'sans.ttf',
    width = 500, x = 0, y = 0, fontSize = 22
  })

  local alertHeight = 240 + alertHeightText.height
  local alertDetermineY = (360 - alertHeight) / 2
  alertHeightText:removeSelf()

  -- local alertRect = display.newImage(alertGroup, 'Image/alert.png')
  --   alertRect.x = _x
  --   alertRect.y = type(checkboxText) == 'nil' and _y or _y + 40
  --   alertRect.width = 576
  --   alertRect.height = type(checkboxText) == 'nil' and alertHeight or alertHeight + 80

  local alertRect = display.newRoundedRect(alertGroup, _x, type(checkboxText) == 'nil' and _y or _y + 40, 576, type(checkboxText) == 'nil' and alertHeight or alertHeight + 80, 14)
  alertRect:setFillColor(0.2, 0.2, 0.22)

  local alertTitle = display.newText({
    parent = alertGroup, text = title,
    width = 500, height = 50,
    font = 'sans_bold.ttf', fontSize = 36,
    x = _x - 252, y = _y - 125 + alertDetermineY
  })
  alertTitle.anchorX = 0

  local alertText = display.newText({
    parent = alertGroup, font = 'sans.ttf',
    width = 500, height = alertHeight - 240, text = text,
    x = _x - 252, y = _y - 90 + alertDetermineY, fontSize = 22
  })
  alertText.anchorX = 0
  alertText.anchorY = 0

  -- local alertButton1 = display.newImage(alertGroup, 'Image/listbut.png')
  --   alertButton1.x = #buttons == 1 and _x + 128 or _x - 128
  --   alertButton1.y = type(checkboxText) == 'nil' and _y + 94 - alertDetermineY or _y + 174 - alertDetermineY
  --   alertButton1.width = 248
  --   alertButton1.height = 101.6

  local alertButton1 = display.newRect(alertGroup, #buttons == 1 and _x + 128 or _x - 128, type(checkboxText) == 'nil' and _y + 94 - alertDetermineY or _y + 174 - alertDetermineY, 248, 101.6)
    alertButton1:setFillColor(0.2, 0.2, 0.22)

  local alertText1 = display.newText({
    parent = alertGroup, font = 'sans_bold.ttf',
    width = 220, height = 80, text = buttons[1],
    x = #buttons == 1 and _x + 128 or _x - 128, y = type(checkboxText) == 'nil' and _y + 94 - alertDetermineY or _y + 174 - alertDetermineY, fontSize = 20, align = 'center'
  })

  local alertButton2
  local alertText2
  local alertCheckboxText
  local alertCheckbox

  alertButton1:addEventListener('touch', function(e)
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
      e.target:setFillColor(0.22, 0.22, 0.24)
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
      display.getCurrentStage():setFocus(nil)
      e.target:setFillColor(0.2, 0.2, 0.22)

      alertActive = false
      alertGroup:removeSelf()
      Runtime:removeEventListener('key', onKeyEventAlert)
      if checkboxText then listener({num = 1, isOn = alertCheckbox.isOn})
      else listener({num = 1, isOn = false}) end
    end
    return true
  end)

  if alertUpload then
    alertUpload = false
    alertActive = false
    alertGroup:removeSelf()
    Runtime:removeEventListener('key', onKeyEventAlert)
    listener({num = 0, isOn = false})
  end

  if #buttons > 1 then
    alertButton2 = display.newImage(alertGroup, 'Image/listbut.png')
      alertButton2.x = _x + 128
      alertButton2.y = type(checkboxText) == 'nil' and _y + 94 - alertDetermineY or _y + 174 - alertDetermineY
      alertButton2.width = 248
      alertButton2.height = 101.6

    alertButton2 = display.newRect(alertGroup, _x + 128, type(checkboxText) == 'nil' and _y + 94 - alertDetermineY or _y + 174 - alertDetermineY, 248, 101.6)
      alertButton2:setFillColor(0.2, 0.2, 0.22)

    alertText2 = display.newText({
      parent = alertGroup, font = 'sans_bold.ttf',
      width = 220, height = 80, text = buttons[2],
      x = _x + 128, y = type(checkboxText) == 'nil' and _y + 94 - alertDetermineY or _y + 174 - alertDetermineY, fontSize = 20, align = 'center'
    })

    alertButton2:addEventListener('touch', function(e)
      if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target:setFillColor(0.22, 0.22, 0.24)
      elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        e.target:setFillColor(0.2, 0.2, 0.22)

        alertActive = false
        alertGroup:removeSelf()
        Runtime:removeEventListener('key', onKeyEventAlert)
        if checkboxText then listener({num = 2, isOn = alertCheckbox.isOn})
        else listener({num = 2, isOn = false}) end
      end
      return true
    end)
  end

  if checkboxText then
    local text = display.newText({
      text = checkboxText, x = 0, y = 0,
      height = 36, fontSize = 26, font = 'sans_bold.ttf'
    })

    if text.width > 400 then text.width = 400 end

    alertCheckboxText = display.newText({
      text = checkboxText, x = _x - 250, y = _y + 74 - alertDetermineY,
      width = text.width, height = 36, fontSize = 26, font = 'sans_bold.ttf'
    })
    alertCheckboxText.anchorX = 0

    alertCheckbox = widget.newSwitch({
      x = _x - 200 + text.width, y = _y + 74 - alertDetermineY, style = 'checkbox', width = 80, height = 80
    })

    alertGroup:insert(alertCheckboxText)
    alertGroup:insert(alertCheckbox)
    text:removeSelf()
  end
end
