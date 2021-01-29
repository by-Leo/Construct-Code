activity.newblocks = {}

-- Активити группа
activity.newblocks.group = display.newGroup()

-- Фон активити
activity.newblocks.bg = display.newImage(activity.newblocks.group, 'Image/bg.png')
activity.newblocks.bg.x, activity.newblocks.bg.y = _x, _y
activity.newblocks.bg.width, activity.newblocks.bg.height = _aW, _aH

-- Фон выбора типа блока
activity.newblocks.rightbg = display.newRect(activity.newblocks.group, _x, _y + _aY - 300 + 85, _aW, 2)
activity.newblocks.rightbg:setFillColor(115/255)

local currentType = 'event'

local openScrollBlocksByType = function(e, type)
  if e.phase == 'began' then
    display.getCurrentStage():setFocus(e.target)
    e.target.alpha = 0.8
  elseif e.phase == 'moved' then
    local dy = math.abs(e.y - e.yStart)
    if dy > 20 then
      activity.newblocks[type].scroll:takeFocus(e)
      e.target.alpha = 1
    end
  elseif e.phase == 'ended' or e.phase == 'cancelled' then
    display.getCurrentStage():setFocus(nil)
    e.target.alpha = 1
    activity.newblocks[currentType].scroll.isVisible = false
    activity.newblocks[currentType].scroll:scrollTo('top', {time = 0})
    activity.newblocks[type].scroll.isVisible = true
    currentType = type
  end
  return true
end

local colorblocks = function(typeblock)
  if typeblock == 'event' then return {9/255, 155/255, 163/255}
  elseif typeblock == 'data' then return {200/255, 151/255, 77/255}
  elseif typeblock == 'object' then return {104/255, 172/255, 76/255}
  -- elseif typeblock == 'copy' then return {160/255, 179/255, 86/255}
  elseif typeblock == 'control' then return {158/255, 138/255, 109/255}
  elseif typeblock == 'controlother' then return {158/255, 136/255, 160/255}
  elseif typeblock == 'physics' then return {200/255, 74/255, 76/255}
  -- elseif typeblock == 'physicscopy' then return {161/255, 90/255, 183/255}
  elseif typeblock == 'network' then return {36/255, 102/255, 201/255}
  elseif typeblock == 'not' then return {152/255, 152/255, 154/255} end
end

local typeblocks = {'event', 'data', 'object', 'controlother', 'control', 'network', 'physics', 'not'}

local lastTypeY = _y + _aY - 236 + 85
local lastTypeX = 98

for i = 1, #typeblocks do
  activity.newblocks[typeblocks[i]] = display.newRoundedRect(activity.newblocks.group, lastTypeX, lastTypeY, 140, 62, 11)
  activity.newblocks[typeblocks[i]].blocks = {}
  activity.newblocks[typeblocks[i]]:setFillColor(unpack(colorblocks(typeblocks[i])))
  activity.newblocks[typeblocks[i]]:addEventListener('touch', function(e) openScrollBlocksByType(e, typeblocks[i]) end)

  local text = display.newText({
    text = strings['type' .. typeblocks[i]],
    x = 0, y = 0, width = 138, font = 'sans.ttf', fontSize = 20
  })

  local textheight = text.height > 55 and 55 or text.height
  text:removeSelf()

  activity.newblocks[typeblocks[i]].text = display.newText({
    text = strings['type' .. typeblocks[i]], parent = activity.newblocks.group,
    x = lastTypeX, y = lastTypeY, width = 138, height = textheight,
    font = 'sans.ttf', fontSize = 20, align = 'center'
  })

  if i % 4 == 0 then lastTypeY, lastTypeX = lastTypeY + 85, 98
  else lastTypeX = lastTypeX + 175 end

  activity.newblocks[typeblocks[i]].scroll = widget.newScrollView({
    x = _x,
    y = 490,
    width = _pW,
    height = _aH - 300,
    hideBackground = true,
    hideScrollBar = true,
    horizontalScrollDisabled = true,
    isBounceEnabled = true,
    listener = function(e) return true end
  })

  activity.newblocks.group:insert(activity.newblocks[typeblocks[i]].scroll)
  if i ~= 1 then activity.newblocks[typeblocks[i]].scroll.isVisible = false end

  local lastY = 0
  local lastHeight = 0
  local scrollHeight = 20

  if utf8.sub(typeblocks[i], 1, 3) ~= 'not' then
    for j = 1, #activity.typeFormulas[typeblocks[i]] do
      if (not utf8.find(activity.typeFormulas[typeblocks[i]][j], 'End') and activity.typeFormulas[typeblocks[i]][j] ~= 'else') or i == 1 then
        activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks + 1] = display.newImage('Image/' .. typeblocks[i] .. 'Block.png')
        activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].name = activity.typeFormulas[typeblocks[i]][j]
        activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].type = i == 1 and 'event' or 'formula'

        activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].width = activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].width / 1.1
        activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].height = activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].height / 1.1
        lastHeight = activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].height
        scrollHeight = scrollHeight + lastHeight + 20

        activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].x = _pW / 2
        activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].y = lastY == 0 and 25 + activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].height / 2 or lastY + lastHeight / 2 + activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].height / 2 + 20
        lastY = activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].y

        activity.newblocks[typeblocks[i]].scroll:insert(activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks])

        if i ~= 1 then
          local corner = display.newImage('Image/cornerShort.png')

          corner.x = _pW / 2
          corner.y = lastY
          corner.width = activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].width
          corner.height = activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].height

          activity.newblocks[typeblocks[i]].scroll:insert(corner)
        end

        activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].text = display.newText({
          text = strings.blocks[activity.typeFormulas[typeblocks[i]][j]][1], align = 'left', height = 40 / 1.1,
          x = _pW / 2 + 5, y = lastY, font = 'ubuntu.ttf', fontSize = 32 / 1.1, width = 630 / 1.1
        })

        activity.newblocks[typeblocks[i]].scroll:insert(activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks].text)

        activity.newblocks[typeblocks[i]].blocks[#activity.newblocks[typeblocks[i]].blocks]:addEventListener('touch', function(e)
          if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            e.target.alpha = 0.8
          elseif e.phase == 'moved' then
            local dy = math.abs(e.y - e.yStart)
            if dy > 20 then
              activity.newblocks[typeblocks[i]].scroll:takeFocus(e)
              e.target.alpha = 1
            end
          elseif e.phase == 'ended' or e.phase == 'cancelled' then
            display.getCurrentStage():setFocus(nil)
            e.target.alpha = 1

            local group = activity.blocks[activity.objects.name]
            local i = 1
            local oldCurrentType = currentType
            local height = 119
            local params = {}

            activity.newblocks[currentType].scroll.isVisible = false
            activity.newblocks[currentType].scroll:scrollTo('top', {time = 0})
            activity.newblocks.event.scroll.isVisible = true
            currentType = 'event'
            activity.newblocks.group.isVisible = false
            activity.blocks.view()

            for j = 1, #activity.paramsFormulas[e.target.name] do params[j] = {}
              if j == 3 then height = 179 elseif j == 5 then height = 239 end
            end

            if #group.block == 0 and e.target.type == 'formula' then
              i = 2
              group.data[1] = {
                name = 'onStart',
                params = {},
                comment = 'false',
                type = 'event'
              }
              activity.genBlock(1)
            elseif e.target.type == 'formula' then i = 2 end

            group.data[i] = {
              name = e.target.name,
              params = params,
              comment = 'false',
              type = e.target.type
            }
            activity.genBlock(i)

            if e.target.name == 'if' or e.target.name == 'ifElse' or e.target.name == 'for'
            or e.target.name == 'enterFrame' or e.target.name == 'useTag' then
              local c = 1 if e.target.name == 'ifElse' then
                group.data[i + 1] = {
                  name = 'else',
                  params = {},
                  comment = 'false',
                  type = 'formula'
                } c = 2 activity.genBlock(i + 1)
              end
              group.data[i + c] = {
                name = e.target.name .. 'End',
                params = {},
                comment = 'false',
                type = 'formula'
              } activity.genBlock(i + c)
            end

            for j = 1, #group.block do group.block[j].num = j end
            activity.blocksReturnBlock(1, group, 0)
            activity.blocksFileUpdate()
            activity.scrollHeightUpdate()
            group.scroll:setScrollHeight(group.scrollHeight)

            if #group.block > 1 then activity.blocksMove(group.block[i], 'create', group) end
          end
          return true
        end)
      end

      activity.newblocks[typeblocks[i]].scroll:setScrollHeight(scrollHeight)
    end
  end
end

activity.newblocks.onKeyEvent = function(event)
  if activity.newblocks.group.isVisible and (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
    timer.performWithDelay(1, function()
      activity.newblocks[currentType].scroll.isVisible = false
      activity.newblocks[currentType].scroll:scrollToPosition({y=0,time = 0})
      activity.newblocks.event.scroll.isVisible = true
      currentType = 'event'
      activity.newblocks.group.isVisible = false
      activity.blocks.view()
    end)
    display.getCurrentStage():setFocus(nil)
  end
  return true
end
Runtime:addEventListener('key', activity.newblocks.onKeyEvent)
