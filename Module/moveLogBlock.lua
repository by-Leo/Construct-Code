-- Обработка таймера нажатия
activity.blocksOnTimer = function(target, group)
  if target.press and group.scroll.isVisible then
    display.getCurrentStage():setFocus(nil)
    target.press = false
    if #group.block > 1 then
      if target.data.name ~= 'ifEnd' and target.data.name ~= 'forEnd' then
        if target.data.type == 'event' then
          local events = 0

          for i = 1, #group.block do if group.block[i].data.type == 'event' then events = events + 1 end end

          if events > 1 then activity.blocksMove(target, 'move', group) end
        else
          activity.blocksMove(target, 'move', group)
        end
      end
    end
  end
end

-- Переместить блоки относительно позиции перетаскиваемого блока
activity.blocksReturnBlock = function(i, group, height)
  if activity.blocksMoveOptimization ~= i or height == 0 then activity.blocksMoveOptimization = i
    local y = -66

    for j = 1, #group.block do
      local newHeight = 146

      if j > 1 then
        if group.block[j].data.type == 'event' then newHeight = 146
          if #group.block[j-1].data.params == 3 or #group.block[j-1].data.params == 4 then newHeight = 176 end
        elseif #group.block[j].data.params < 3 then newHeight = 116
          if #group.block[j-1].data.params == 3 or #group.block[j-1].data.params == 4 then newHeight = 146 end
        elseif #group.block[j].data.params < 5 then newHeight = 146
          if #group.block[j-1].data.params == 3 or #group.block[j-1].data.params == 4 then newHeight = 176 end
        elseif #group.block[j].data.params < 7 then newHeight = 176
          if #group.block[j-1].data.params == 3 or #group.block[j-1].data.params == 4 then newHeight = 206 end
        end
      end

      if j == i then y = y + height end

      y = y + newHeight

      group.block[j].y = y
      group.block[j].text.y = y + group.block[j].text.additionY
      group.block[j].checkbox.y = y

      if group.block[j].data.type == 'formula' then
        group.block[j].corner.y = y
      end

      if group.block[j].params then
        for p = 1, #group.block[j].params do
          group.block[j].params[p].name.y = y + group.block[j].params[p].name.additionY
          group.block[j].params[p].line.y = y + group.block[j].params[p].line.additionY
          group.block[j].params[p].rect.y = y + group.block[j].params[p].rect.additionY
          group.block[j].params[p].text.y = y + group.block[j].params[p].text.additionY
        end
      end
    end
  end
end

-- Найти позицию блока для перемещения других блоков относительно его позиции
activity.blocksLocateBlock = function(y, group, height)
  for i = 1, #group.block do
    if group.block[i].y >= y then activity.blocksReturnBlock(i, group, height) break
    elseif i == #group.block then activity.blocksReturnBlock(i+1, group, height) end
  end
end

-- Добавить в таблицу новый блок
activity.blocksSetBlock = function(i, data, mode, group, relatedBlocks, relatedEvent)
  local relatedCount = 0
  local relatedHeight = 0
  local splitEvent = false
  local num = i

  group.targetActive = false
  group.group:removeSelf()
  group.scroll:setIsLocked(false, 'vertical')
  group.data[i] = data

  activity.genBlock(i)

  if group.block[1].data.type == 'formula' then
    group.data[1] = {
      name = 'onStart',
      params = {},
      comment = 'false',
      type = 'event'
    }
    activity.genBlock(1)
    i = i + 1
    num = num + 1
  end

  if #relatedBlocks > 0 and group.block[i + 1] and group.block[i + 1].data.type == 'formula' and relatedEvent then
    splitEvent = true
    for j = i - 1, 1, -1 do
      if group.block[j].data.type == 'event' then
        group.data[i + 1] = {
          name = group.block[j].data.name,
          params = group.block[j].data.params,
          comment = group.block[j].data.comment,
          type = 'event'
        }
        activity.genBlock(i + 1)
        break
      end
    end
  end

  for j = 1, #relatedBlocks do
    group.data[j + i] = {
      name = relatedBlocks[j].name,
      params = relatedBlocks[j].params,
      comment = relatedBlocks[j].comment,
      type = 'formula'
    }
    activity.genBlock(j + i)
    relatedCount = relatedCount + 1
    if relatedCount < 7 then relatedHeight = relatedHeight + group.block[j + i].height end
  end

  local i = 1
  while i <= #group.block do
    if group.block[i].relatedBlocks then
      for j = 1, #group.block[i].relatedBlocks do
        group.data[j + i] = {
          name = group.block[i].relatedBlocks[j].name,
          params = group.block[i].relatedBlocks[j].params,
          comment = group.block[i].relatedBlocks[j].comment,
          type = 'formula'
        }
        activity.genBlock(j + i)

        if j + i <= num then num = num + 1 end
      end

      local j = i
      i = i + #group.block[i].relatedBlocks
      group.block[j].relatedBlocks = nil
    end

    i = i + 1
  end

  if splitEvent then
    for j = 1, #group.block do
      if group.block[j].data.type == 'event' then
        if group.block[j + 1] and group.block[j + 1].data.type == 'event' then
          activity.blocksDeleteBlock(group.block[j], group.block[j].num, group)
          break
        end
      end
    end
  end

  for i = 1, #group.block do group.block[i].num = i end
  activity.blocksReturnBlock(1, group, 0)
  activity.blocksFileUpdate()

  if data.type == 'event' then
    group.scroll:scrollToPosition {y = _aH - 100 - relatedHeight - group.block[num].y > 0 and 0 or _aH - 100 - relatedHeight - group.block[num].y, time = 10}
  end
end

-- Найти позицию блока для установки блока в скролл
activity.blocksLocateNewBlock = function(y, data, mode, group, relatedBlocks, relatedEvent)
  for i = 1, #group.block do
    if group.block[i].y > y then activity.blocksSetBlock(i, data, mode, group, relatedBlocks, relatedEvent) break
    elseif i == #group.block then activity.blocksSetBlock(i + 1, data, mode, group, relatedBlocks, relatedEvent) end
  end
end

-- Удалить старый блок
activity.blocksDeleteBlock = function(target, num, group)
  if group.block[num].params then
    for p = 1, #group.block[num].params do
      group.block[num].params[p].name:removeSelf()
      group.block[num].params[p].line:removeSelf()
      group.block[num].params[p].rect:removeSelf()
      group.block[num].params[p].text:removeSelf()
    end
  end

  target.text:removeSelf()
  target.checkbox:removeSelf()
  if target.data.type == 'formula' then target.corner:removeSelf() end
  target:removeSelf()

  table.remove(group.block, num)

  for i = 1, #group.block do group.block[i].num = i end

  activity.scrollHeightUpdate()
  group.scroll:setScrollHeight(group.scrollHeight)
end

-- Создать перемещаемый блок
activity.blocksMove = function(target, mode, group)
  local scrollX, scrollY = group.scroll:getContentPosition()
  local y = mode == 'create' and _y or _y - _aY + target.y + scrollY + 165
  local data = target.data
  local path = target.path
  local height = target.height
  local textAdditionY = target.text.additionY
  local relatedBlocks = {}
  local relatedEvent = true
  local relatedHeight = 0

  if data.type == 'event' then
    for i = target.num + 1, #group.block do
      if group.block[i].data.type == 'event' then break
      else
        relatedBlocks[#relatedBlocks+1] = {
          name = group.block[i].data.name,
          params = group.block[i].data.params,
          comment = group.block[i].data.comment,
          type = 'formula',
          num = i
        }
      end
    end
  end

  if data.name == 'if' or data.name == 'for' then
    local nestedFactor = 1

    relatedEvent = false

    for i = target.num + 1, #group.block do
      relatedBlocks[#relatedBlocks+1] = {
        name = group.block[i].data.name,
        params = group.block[i].data.params,
        comment = group.block[i].data.comment,
        type = 'formula',
        num = i
      }

      if group.block[i].data.name == data.name then nestedFactor = nestedFactor + 1
      elseif group.block[i].data.name == data.name .. 'End' then nestedFactor = nestedFactor - 1 end
      if nestedFactor == 0 then break end
    end
  end

  for i = #relatedBlocks, 1, -1 do
    activity.blocksDeleteBlock(group.block[relatedBlocks[i].num], group.block[relatedBlocks[i].num].num, group)
  end

  if data.type == 'event' then
    local i = 0
    while i < #group.block do
      i = i + 1
      if group.block[i].data.name == 'if' or group.block[i].data.name == 'for' then
        local nestedFactor = 1

        group.block[i].relatedBlocks = {}

        for j = i + 1, #group.block do
          group.block[i].relatedBlocks[#group.block[i].relatedBlocks+1] = {
            name = group.block[j].data.name,
            params = group.block[j].data.params,
            comment = group.block[j].data.comment,
            type = 'formula',
            num = j
          }

          if group.block[j].data.name == group.block[i].data.name then nestedFactor = nestedFactor + 1
          elseif group.block[j].data.name == group.block[i].data.name .. 'End' then nestedFactor = nestedFactor - 1 end
          if nestedFactor == 0 then break end
        end

        i = i + #group.block[i].relatedBlocks
      end
    end
  end

  for i = #group.block, 1, -1 do
    if group.block[i].relatedBlocks then
      for j = #group.block[i].relatedBlocks, 1, -1 do
        relatedHeight = relatedHeight + group.block[group.block[i].relatedBlocks[j].num].height - 3
        activity.blocksDeleteBlock(group.block[group.block[i].relatedBlocks[j].num], group.block[group.block[i].relatedBlocks[j].num].num, group)
      end
    end
  end

  if data.type == 'event' then
    group.scroll:scrollToPosition {y = scrollY + relatedHeight > 0 and 0 or scrollY + relatedHeight, time = 10}
  end

  activity.blocksMoveOptimization = 0
  group.targetActive = true
  group.scroll:setIsLocked(true, 'vertical')

  group.group = display.newGroup()

  display.newRect(group.group, _x, _y, 5000, 5000):setFillColor(0, 0.2)

  local newTarget = display.newImage(group.group, path, _x, y)

  newTarget.height = height

  newTarget.text = display.newText({
    text = strings.blocks[data.name][1], align = 'left', height = 40, parent = group.group,
    x = _x + 10, y = y + textAdditionY, font = 'ubuntu', fontSize = 32, width = 620
  })

  if data.type == 'formula' then
    newTarget.corner = display.newImage(group.group, 'Image/' .. target.cornerType .. '.png', _x, y)
  end

  newTarget.params = {}

  for j = 1, #target.params do
    newTarget.params[j] = {}

    newTarget.params[j].name = display.newText({
      parent = group.group, text = target.params[j].name.text, align = 'left', height = target.params[j].name.height,
      x = _x + target.params[j].name.additionX, y = y + target.params[j].name.additionY, font = 'ubuntu_!bold.ttf', fontSize = 22, width = 150
    })
    newTarget.params[j].name.additionX = target.params[j].name.additionX
    newTarget.params[j].name.additionY = target.params[j].name.additionY

    newTarget.params[j].line = display.newRect(group.group, _x + target.params[j].line.additionX, y + target.params[j].line.additionY, target.params[j].line.width, 3)
    newTarget.params[j].line:setFillColor(84/255,84/255,84/255)
    newTarget.params[j].line.additionX = target.params[j].line.additionX
    newTarget.params[j].line.additionY = target.params[j].line.additionY

    newTarget.params[j].text = display.newText({
      parent = group.group, text = target.params[j].text.text, align = 'center', height = target.params[j].text.height,
      x = _x + target.params[j].text.additionX, y = y + target.params[j].text.additionY, font = 'ubuntu_!bold.ttf', fontSize = 20, width = target.params[j].text.width
    })
    newTarget.params[j].text.additionX = target.params[j].text.additionX
    newTarget.params[j].text.additionY = target.params[j].text.additionY
  end

  if mode == 'move' or mode == 'create' then activity.blocksDeleteBlock(target, target.num, group) end

  newTarget:addEventListener('touch', function(e)
    if not alertActive and group.scroll.isVisible then
      if e.phase == 'moved' then
        scrollX, scrollY = group.scroll:getContentPosition()
        if e.y < 200 and scrollY < 0 then
          group.scroll:scrollToPosition({y = scrollY + 15, time = 0})
        elseif e.y > 925 and group.block[#group.block].y + scrollY > 600 then
          group.scroll:scrollToPosition({y = scrollY - 15, time = 0})
        end
        e.target.x = e.x
        e.target.y = e.y
        e.target.text.x = e.x + 10
        e.target.text.y = e.y + textAdditionY
        if data.type == 'formula' then
          e.target.corner.x = e.x
          e.target.corner.y = e.y
        end
        for i = 1, #e.target.params do
          e.target.params[i].name.x = e.x + e.target.params[i].name.additionX
          e.target.params[i].name.y = e.y + e.target.params[i].name.additionY
          e.target.params[i].line.x = e.x + e.target.params[i].line.additionX
          e.target.params[i].line.y = e.y + e.target.params[i].line.additionY
          e.target.params[i].text.x = e.x + e.target.params[i].text.additionX
          e.target.params[i].text.y = e.y + e.target.params[i].text.additionY
        end
        activity.blocksLocateBlock(e.target.y - 165 - scrollY + (_aH - _h) / 2, group, data.type == 'event' and height + 30 or height)
      elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        scrollX, scrollY = group.scroll:getContentPosition()
        activity.blocksLocateNewBlock(e.target.y - 165 - scrollY + (_aH - _h) / 2, data, mode, group, relatedBlocks, relatedEvent)
      end
    end
    return true
  end)
  display.getCurrentStage():setFocus(newTarget)
  scrollX, scrollY = group.scroll:getContentPosition()
  activity.blocksReturnBlock(1, group, 0)
  activity.blocksLocateBlock(y - 165 - scrollY + (_aH - _h) / 2, group, data.type == 'event' and height + 30 or height)
end
