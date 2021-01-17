blockList = function(num)
  local group = activity.blocks[activity.objects.name]
  local blockListGroup = display.newGroup()
  local y = _y - 190

  if #group.block[num].data.params > 4 then y = _y - 150
  elseif #group.block[num].data.params > 2 then y = _y - 170 end

  alertActive = true
  group.scroll:setIsLocked(true, 'vertical')

  local function onKeyEventBlockList(event)
    if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
      alertActive = false
      blockListGroup:removeSelf()
      group.scroll:setIsLocked(false, 'vertical')
      Runtime:removeEventListener('key', onKeyEventBlockList)
    end
    return true
  end
  Runtime:addEventListener('key', onKeyEventBlockList)

  local blockListBg = display.newRect(blockListGroup, _x, _y, 5000, 5000)
  blockListBg:setFillColor(1, 0.005)

  blockListBg:addEventListener('touch', function(e)
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
      display.getCurrentStage():setFocus(nil)

      alertActive = false
      blockListGroup:removeSelf()
      group.scroll:setIsLocked(false, 'vertical')
      Runtime:removeEventListener('key', onKeyEventBlockList)
    end
    return true
  end)

  local blockListRect = display.newRoundedRect(blockListGroup, _x, _y, 440, 480, 14)
  blockListRect:setFillColor(0.2, 0.2, 0.22)

  blockListRect:addEventListener('touch', function(e)
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
    elseif e.phase == 'moved' then
      if math.abs(e.y - e.yStart) > 20 then display.getCurrentStage():setFocus(nil) end
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
      display.getCurrentStage():setFocus(nil)
    end
    return true
  end)

  local blocksTarget = display.newImage(blockListGroup, group.block[num].path, _x, y)
  blocksTarget.width = 415
  blocksTarget.height = group.block[num].height / 1.6

  blocksTarget.text = display.newText({
    text = strings.blocks[group.block[num].data.name][1], align = 'left', height = 25 , parent = blockListGroup,
    x = _x - 10 / 1.6, y = y + group.block[num].text.additionY / 1.6, font = 'ubuntu', fontSize = 20, width = 375
  })

  if group.block[num].data.type == 'formula' then
    blocksTarget.corner = display.newImage(blockListGroup, 'Image/' .. group.block[num].cornerType .. '.png', _x, y)
    blocksTarget.corner.width = 415
    blocksTarget.corner.height = blocksTarget.corner.height / 1.6
  end

  blocksTarget.params = {}

  for j = 1, #group.block[num].params do
    blocksTarget.params[j] = {}

    blocksTarget.params[j].name = display.newText({
      parent = blockListGroup, text = group.block[num].params[j].name.text, align = 'left', height = math.ceil(group.block[num].params[j].name.height / 1.6),
      x = _x + group.block[num].params[j].name.additionX / 1.6, y = y + group.block[num].params[j].name.additionY / 1.6, font = 'ubuntu_!bold.ttf', fontSize = math.floor(22 / 1.6), width = math.ceil(150 / 1.6)
    })

    blocksTarget.params[j].line = display.newRect(blockListGroup, _x + group.block[num].params[j].line.additionX / 1.6, y + group.block[num].params[j].line.additionY / 1.6, group.block[num].params[j].line.width / 1.6, 1.8)
    blocksTarget.params[j].line:setFillColor(84/255,84/255,84/255)

    blocksTarget.params[j].text = display.newText({
      parent = blockListGroup, text = group.block[num].params[j].text.text, align = 'center', height = math.ceil(group.block[num].params[j].text.height / 1.6),
      x = _x + group.block[num].params[j].text.additionX / 1.6, y = y + group.block[num].params[j].text.additionY / 1.6, font = 'ubuntu_!bold.ttf', fontSize = math.floor(20 / 1.6), width = math.ceil(group.block[num].params[j].text.width / 1.6)
    })
  end

  blocksListButtons = {}
  y = y + blocksTarget.height / 2 + 43

  local getTextButton = function()
    if group.block[num].data.comment == 'false' then return strings.remove, strings.copy, strings.comment, strings.documentation
    else return strings.remove, strings.copy, strings.ucomment, strings.documentation end
  end

  for j = 1, 4 do
    blocksListButtons[j] = display.newRect(blockListGroup, _x, y, 415, 66)
    blocksListButtons[j]:setFillColor(0.2, 0.2, 0.22)
    blocksListButtons[j].click = false

    blocksListButtons[j].text = display.newText({
      parent = blockListGroup, text = select(j, getTextButton()), align = 'left',
      x = _x + 10, y = y, font = 'ubuntu_!bold.ttf', fontSize = 24, height = 27, width = 400
    })

    blocksListButtons[j]:addEventListener('touch', function(e)
      if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target:setFillColor(0.22, 0.22, 0.24)
        e.target.click = true
      elseif e.phase == 'moved' then
        local dy = math.abs(e.y - e.yStart)
        if dy > 20 then
          display.getCurrentStage():setFocus(nil)
          e.target:setFillColor(0.2, 0.2, 0.22)
          e.target.click = false
        end
      elseif (e.phase == 'ended' or e.phase == 'cancelled') and e.target.click then
        display.getCurrentStage():setFocus(nil)
        e.target:setFillColor(0.2, 0.2, 0.22)
        e.target.click = false

        alertActive = false
        blockListGroup:removeSelf()
        group.scroll:setIsLocked(false, 'vertical')
        Runtime:removeEventListener('key', onKeyEventBlockList)

        group.block[num].checkbox:setState({isOn=true})

        if group.block[num].data.type == 'event' then
          for i = num + 1, #group.block do
            if group.block[i].data.type == 'event' then break
            else
              if j == 3 then
                group.block[i].checkbox:setState({isOn=group.block[i].data.comment == group.block[num].data.comment})
              else
                group.block[i].checkbox:setState({isOn=true})
              end
            end
          end
        elseif group.block[num].data.name == 'if' or group.block[num].data.name == 'ifElse' or group.block[num].data.name == 'for'
        or group.block[num].data.name == 'enterFrame' or group.block[num].data.name == 'useTag' then
          local nestedFactor = 1
          local nameEnd = group.block[num].data.name .. 'End'
          if group.block[num].data.name == 'ifElse' then nameEnd = 'ifEnd' end

          for i = num + 1, #group.block do
            if j ~= 3 then
              group.block[i].checkbox:setState({isOn=true})
            else
              group.block[i].checkbox:setState({isOn=group.block[i].data.comment == group.block[num].data.comment})
            end

            if group.block[i].data.name == group.block[num].data.name then nestedFactor = nestedFactor + 1
            elseif group.block[i].data.name == nameEnd then nestedFactor = nestedFactor - 1 end
            if nestedFactor == 0 then break end
          end
        end

        activity.onClickButton.blocks[j+1](true)
      end
      return true
    end)

    y = y + 76
  end
end
