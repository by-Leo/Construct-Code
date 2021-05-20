activity.inputColor = function(rgb, listener)
  local color = display.newGroup()
  local colorActive = false
  alertActive = true

  local onKeyEventInputColor = function(event)
    if color.isVisible then
      if (event.keyName == 'back' or event.keyName == 'escape') and not colorActive and event.phase == 'up' then
        alertActive = false
        Runtime:removeEventListener('key', onKeyEventInputColor)
        display.getCurrentStage():setFocus(nil)
        color:removeSelf()
        listener({input = false})
      end
    end
    return true
  end
  Runtime:addEventListener('key', onKeyEventInputColor)

  local bg = display.newRoundedRect(color, _x, _y - 120, 500, 700, 20)
  bg:setFillColor(0.18, 0.18, 0.2)

  local block = display.newRoundedRect(color, _x, 320, 200, 200, 10)
  block:setFillColor(rgb[1]/255, rgb[2]/255, rgb[3]/255)

  local colorText = display.newText(color, json.encode(rgb), _x, 470, 'ubuntu_!bold.ttf', 26)

  local red = display.newText(color, strings.red, _x - 120, _y - 100, 'ubuntu_!bold.ttf', 26)
  red:setFillColor(1, 0, 0)
  red.anchorX = 1

  local redSlider = widget.newSlider({
    x = 425, y = _y - 100,
    width = 250, value = math.round(rgb[1] / 2.55), listener = function(event)
      rgb[1] = math.round(event.value * 2.55)
      colorText.text = json.encode(rgb)
      block:setFillColor(rgb[1]/255, rgb[2]/255, rgb[3]/255)
    end
  })

  local redPlus = display.newRoundedRect(color, 580, _y - 100, 30, 30, 3)
  redPlus:setFillColor(0.18, 0.18, 0.2)
  redPlus.line1 = display.newRect(color, 580, _y - 100, 20, 3)
  redPlus.line2 = display.newRect(color, 580, _y - 100, 3, 20)

  local redMinus = display.newRoundedRect(color, 270, _y - 100, 30, 30, 3)
  redMinus:setFillColor(0.18, 0.18, 0.2)
  redMinus.line1 = display.newRect(color, 270, _y - 100, 20, 3)

  local green = display.newText(color, strings.green, _x - 120, _y - 50, 'ubuntu_!bold.ttf', 26)
  green:setFillColor(0, 1, 0)
  green.anchorX = 1

  local greenSlider = widget.newSlider({
    x = 425, y = _y - 50,
    width = 250, value = math.round(rgb[2] / 2.55), listener = function(event)
      rgb[2] = math.round(event.value * 2.55)
      colorText.text = json.encode(rgb)
      block:setFillColor(rgb[1]/255, rgb[2]/255, rgb[3]/255)
    end
  })

  local greenPlus = display.newRoundedRect(color, 580, _y - 50, 30, 30, 3)
  greenPlus:setFillColor(0.18, 0.18, 0.2)
  greenPlus.line1 = display.newRect(color, 580, _y - 50, 20, 3)
  greenPlus.line2 = display.newRect(color, 580, _y - 50, 3, 20)

  local greenMinus = display.newRoundedRect(color, 270, _y - 50, 30, 30, 3)
  greenMinus:setFillColor(0.18, 0.18, 0.2)
  greenMinus.line1 = display.newRect(color, 270, _y - 50, 20, 3)

  local blue = display.newText(color, strings.blue, _x - 120, _y, 'ubuntu_!bold.ttf', 26)
  blue:setFillColor(0, 0, 1)
  blue.anchorX = 1

  local blueSlider = widget.newSlider({
    x = 425, y = _y,
    width = 250, value = math.round(rgb[3] / 2.55), listener = function(event)
      rgb[3] = math.round(event.value * 2.55)
      colorText.text = json.encode(rgb)
      block:setFillColor(rgb[1]/255, rgb[2]/255, rgb[3]/255)
    end
  })

  local bluePlus = display.newRoundedRect(color, 580, _y, 30, 30, 3)
  bluePlus:setFillColor(0.18, 0.18, 0.2)
  bluePlus.line1 = display.newRect(color, 580, _y, 20, 3)
  bluePlus.line2 = display.newRect(color, 580, _y, 3, 20)

  local blueMinus = display.newRoundedRect(color, 270, _y, 30, 30, 3)
  blueMinus:setFillColor(0.18, 0.18, 0.2)
  blueMinus.line1 = display.newRect(color, 270, _y, 20, 3)

  color:insert(redSlider)
  color:insert(greenSlider)
  color:insert(blueSlider)

  local colorHex = display.newText(color, 'HEX', _x, _y + 60, 'ubuntu_!bold.ttf', 26)
  local colorHexRect = display.newRect(color, _x, _y + 60, 300, 50)
  colorHexRect:setFillColor(0.18, 0.18, 0.2)
  colorHex:toFront()

  colorHexRect:addEventListener('touch', function(e)
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
      e.target:setFillColor(0.16, 0.16, 0.18)
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
      display.getCurrentStage():setFocus(nil)
      e.target:setFillColor(0.18, 0.18, 0.2)
      if not colorActive then colorActive = true
        input(strings.inputHexTitle, strings.inputHexText, function(event)
          if event.phase == 'began' then inputPermission(true) end
        end, function(e)
          colorActive, alertActive = false, true
          if e.input then e.text = trim(e.text)
            if utf8.sub(e.text, 1, 1) == '#' then e.text = utf8.sub(e.text, 2, 7) end
            if utf8.len(e.text) ~= 6 then e.text = 'FFFFFF' end local errorHex = false
            local filterHex = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}
            for indexHex = 1, 6 do local symHex = utf8.upper(utf8.sub(e.text, indexHex, indexHex))
              for i = 1, #filterHex do
                if symHex == filterHex[i] then break elseif i == #filterHex then errorHex = true end
              end
            end if errorHex then e.text = 'FFFFFF' end
            rgb = hex(e.text)
            colorText.text = json.encode(rgb)
            redSlider:setValue(math.round(rgb[1] / 2.55))
            greenSlider:setValue(math.round(rgb[2] / 2.55))
            blueSlider:setValue(math.round(rgb[3] / 2.55))
            block:setFillColor(rgb[1]/255, rgb[2]/255, rgb[3]/255)
          end
        end)
      end
    end
    return true
  end)

  local colorButton = display.newRect(color, _x + 120, _y + 160, 248, 101.6)
  colorButton:setFillColor(0.18, 0.18, 0.2)

  local colorButtonText = display.newText({
    parent = color, font = 'sans_bold.ttf',
    width = 180, height = 80, text = strings.buttonInput,
    x = _x + 120, y = _y + 180, fontSize = 26, align = 'center'
  })

  colorButton:addEventListener('touch', function(e)
    if not colorActive then
      native.setKeyboardFocus(nil)
      if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target:setFillColor(0.16, 0.16, 0.18)
        e.target.click = true
      elseif e.phase == 'moved' then
        if math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30 then
          display:getCurrentStage():setFocus(nil)
          e.target:setFillColor(0.18, 0.18, 0.2)
          e.target.click = false
        end
      elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        e.target:setFillColor(0.18, 0.18, 0.2)
        if e.target.click then
          e.target.click = false
          alertActive = false
          Runtime:removeEventListener('key', onKeyEventInputColor)
          display.getCurrentStage():setFocus(nil)
          color:removeSelf()
          listener({input = true, color = {rgb[1], rgb[2], rgb[3]}})
        end
      end
    end
    return true
  end)

  local colorPlus = function(e, colorName)
    if not colorActive then
      if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target:setFillColor(0.16, 0.16, 0.18)
        e.target.click = true
      elseif e.phase == 'moved' then
        if math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30 then
          display:getCurrentStage():setFocus(nil)
          e.target:setFillColor(0.18, 0.18, 0.2)
          e.target.click = false
        end
      elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        e.target:setFillColor(0.18, 0.18, 0.2)
        if e.target.click then
          e.target.click = false
          if colorName == 'red' then
            rgb[1] = rgb[1] < 255 and rgb[1] + 1 or 255
            redSlider:setValue(math.round(rgb[1] / 2.55))
          elseif colorName == 'green' then
            rgb[2] = rgb[2] < 255 and rgb[2] + 1 or 255
            greenSlider:setValue(math.round(rgb[2] / 2.55))
          elseif colorName == 'blue' then
            rgb[3] = rgb[3] < 255 and rgb[3] + 1 or 255
            blueSlider:setValue(math.round(rgb[3] / 2.55))
          end
          colorText.text = json.encode(rgb)
          block:setFillColor(rgb[1]/255, rgb[2]/255, rgb[3]/255)
        end
      end
    end
  end

  local colorMinus = function(e, colorName)
    if not colorActive then
      if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target:setFillColor(0.16, 0.16, 0.18)
        e.target.click = true
      elseif e.phase == 'moved' then
        if math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30 then
          display:getCurrentStage():setFocus(nil)
          e.target:setFillColor(0.18, 0.18, 0.2)
          e.target.click = false
        end
      elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        e.target:setFillColor(0.18, 0.18, 0.2)
        if e.target.click then
          e.target.click = false
          if colorName == 'red' then
            rgb[1] = rgb[1] > 0 and rgb[1] - 1 or 0
            redSlider:setValue(math.round(rgb[1] / 2.55))
          elseif colorName == 'green' then
            rgb[2] = rgb[2] > 0 and rgb[2] - 1 or 0
            greenSlider:setValue(math.round(rgb[2] / 2.55))
          elseif colorName == 'blue' then
            rgb[3] = rgb[3] > 0 and rgb[3] - 1 or 0
            blueSlider:setValue(math.round(rgb[3] / 2.55))
          end
          colorText.text = json.encode(rgb)
          block:setFillColor(rgb[1]/255, rgb[2]/255, rgb[3]/255)
        end
      end
    end
  end

  redPlus:addEventListener('touch', function(e) colorPlus(e, 'red') return true end)
  redMinus:addEventListener('touch', function(e) colorMinus(e, 'red') return true end)
  greenPlus:addEventListener('touch', function(e) colorPlus(e, 'green') return true end)
  greenMinus:addEventListener('touch', function(e) colorMinus(e, 'green') return true end)
  bluePlus:addEventListener('touch', function(e) colorPlus(e, 'blue') return true end)
  blueMinus:addEventListener('touch', function(e) colorMinus(e, 'blue') return true end)
end
