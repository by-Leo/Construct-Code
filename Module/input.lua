input = function(title, text, textListener, listener, oldText)
  local inputGroup = display.newGroup()
  local inputButtonResizeWidth = 225
  local inputButtonResizeHeight = 92
  alertActive = true

  local function onKeyEventInput( event )
    if (event.keyName == "back" or event.keyName == "escape") and event.phase == 'up' then
      native.setKeyboardFocus(nil)
      alertActive = false
      inputGroup:removeSelf()
      Runtime:removeEventListener( "key", onKeyEventInput )
      listener({input = false})
    end
    return true
  end
  Runtime:addEventListener( "key", onKeyEventInput )

  local defaultBox = native.newTextBox( 5000, _y - 190, 510, 85 )
  timer.performWithDelay(1, function()
    defaultBox.x = _x
    defaultBox.isEditable = true
    defaultBox.hasBackground = false
    defaultBox.placeholder = text
    defaultBox.font = native.newFont( 'sans.ttf', 30 )
    defaultBox.text = type(oldText) == 'string' and oldText or ''

    if system.getInfo 'platform' == 'android' and system.getInfo 'environment' ~= 'simulator' then
      defaultBox:setTextColor(0.9)
    else
      defaultBox:setTextColor(0.1)
    end

    defaultBox:addEventListener( "userInput", textListener )
    inputGroup:insert(defaultBox)

    local inputRect = display.newRoundedRect(inputGroup, _x, _y - 150, 576, 360, 14)
    inputRect:setFillColor(0.2, 0.2, 0.22)
    local inputLine = display.newRect(inputGroup, _x, _y - 138, 504, 3)

    local inputTitle = display.newText({
      parent = inputGroup, text = title,
      width = 500, height = 50,
      font = 'sans_bold.ttf', fontSize = 36,
      x = _x - 252, y = _y - 275
    })
    inputTitle.anchorX = 0

    -- inputButton = display.newImage(inputGroup, 'Image/listbut.png')
    --   inputButton.x = _x + 128
    --   inputButton.y = _y - 56
    --   inputButton.width = 248
    --   inputButton.height = 101.6

    inputButton = display.newRect(inputGroup, _x + 128, _y - 56, 248, 101.6)
    inputButton:setFillColor(0.2, 0.2, 0.22)
    inputText = display.newText({
      parent = inputGroup, font = 'sans_bold.ttf',
      width = 180, height = 80, text = strings.buttonInput,
      x = _x + 128, y = _y - 36, fontSize = 26, align = 'center'
    })
    inputText.alpha = 0.2

    inputButton:addEventListener('touch', function(e)
      if inputText.alpha > 0.5 then
        native.setKeyboardFocus(nil)
        if e.phase == 'began' then
          display.getCurrentStage():setFocus( e.target )
          e.target:setFillColor(0.22, 0.22, 0.24)
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
          display.getCurrentStage():setFocus( nil )
          e.target:setFillColor(0.2, 0.2, 0.22)

          alertActive = false
          inputGroup:removeSelf()
          Runtime:removeEventListener( "key", onKeyEventInput )
          listener({text = defaultBox.text, input = true})
        end
      end
      return true
    end)

    -- native.setKeyboardFocus(defaultBox)
  end)
end

inputPermission = function(permission)
  if permission then
    inputText.alpha = 1
  else
    inputText.alpha = 0.2
  end
end
