activity.paramsFormulas = {
  -- event
  ['onStart'] = {},
  ['onClick'] = {},
  ['onClickEnd'] = {},
  ['onFun'] = {'fun'},
  ['onBack'] = {},
  ['onHide'] = {},
  ['onView'] = {},

  -- data
  ['setVar'] = {'variable', 'value'},
  ['updVar'] = {'variable', 'value'},
  ['setShowText'] = {'variable', 'font', 'color', 'value'},
  ['setHideText'] = {'variable'},
  ['setTable'] = {'table', 'value', 'value'},

  -- object
  ['setPos'] = {'value', 'value'},
  ['setX'] = {'value'},
  ['setY'] = {'value'},
  ['setSize'] = {'value'},

  -- copy
  ['setCopy'] = {'setcopy'},
  ['removeCopy'] = {'copy'},
  ['setPosCopy'] = {'copy', 'value', 'value'},

  -- control
  ['if'] = {'value'},
  ['ifEnd'] = {},
  ['for'] = {'value'},
  ['forEnd'] = {},
  ['timer'] = {'value'},
  ['fileLine'] = {'variable', 'value', 'basedir'},
  ['fileLineEnd'] = {},
  ['fileRead'] = {'variable', 'value', 'basedir'},
  ['fileWrite'] = {'value', 'value', 'basedir'},
  ['fileUpdate'] = {'value', 'value', 'basedir'},
  ['fileMove'] = {'value', 'basedir', 'value', 'basedir'},
  ['fileCopy'] = {'value', 'basedir', 'value', 'basedir'},
  ['fileRemove'] = {'value', 'basedir'},

  -- physics
  ['setBody'] = {'body', 'value', 'value', 'value'},
  ['removeBody'] = {},
  ['startPhysics'] = {},
  ['stopPhysics'] = {},

  -- physicscopy
  ['setGravityCopy'] = {'copy', 'value'},
  ['setSensorCopy'] = {'copy', 'sensor'},
  ['setPhyRotationCopy'] = {'copy', 'phyrotation'},

  -- network
  ['openUrl'] = {'value'},
  ['setGet'] = {'variable', 'value'},
  ['setPost'] = {'table', 'variable', 'value'}
}

activity.typeFormulas = {
  event = {
    'onStart',
    'onClick',
    'onClickEnd',
    'onFun',
    'onBack',
    'onHide',
    'onView'
  },
  data = {
    'setVar',
    'updVar',
    'setShowText',
    'setHideText',
    'setTable'
  },
  object = {
    'setPos',
    'setX',
    'setY',
    'setSize'
  },
  copy = {
    'setCopy',
    'removeCopy',
    'setPosCopy'
  },
  control = {
    'if',
    'ifEnd',
    'for',
    'forEnd',
    'timer',
    'fileLine',
    'fileLineEnd',
    'fileRead',
    'fileWrite',
    'fileUpdate',
    'fileMove',
    'fileCopy',
    'fileRemove'
  },
  physics = {
    'setBody',
    'removeBody',
    'startPhysics',
    'stopPhysics'
  },
  physicscopy = {
    'setGravityCopy',
    'setSensorCopy',
    'setPhyRotationCopy'
  },
  network = {
    'openUrl',
    'setGet',
    'setPost'
  }
}

activity.genType = function(i)
  local group = activity.blocks[activity.objects.name]
  local types = {'data', 'object', 'copy', 'control', 'physics', 'physicscopy', 'network'}

  if group.data[i].comment == 'false' and group.data[i].type == 'event' then return 'event'
  elseif group.data[i].comment == 'true' and group.data[i].type == 'event' then return 'ecomment'
  elseif group.data[i].comment == 'true' and group.data[i].type == 'formula' then return 'comment' end

  for d = 1, #types do
    for j = 1, #activity.typeFormulas[types[d]] do
      if activity.typeFormulas[types[d]][j] == group.data[i].name then
        return types[d]
      end
    end
  end
end

activity.putBlockParams = function(i)
  local group = activity.blocks[activity.objects.name]

  local getXParams = function(targetName)
    if targetName == 'text' then
      if #group.block[i].data.params < 3 then return _pW / 2 - 240, _pW / 2 + 80
      elseif #group.block[i].data.params == 3 then return _pW / 2 - 240, _pW / 2 - 240, _pW / 2 + 80
      elseif #group.block[i].data.params == 4 then return _pW / 2 - 240, _pW / 2 + 80, _pW / 2 - 240, _pW / 2 + 80
      elseif #group.block[i].data.params == 5 then return _pW / 2 - 240, _pW / 2 - 240, _pW / 2 + 80, _pW / 2 - 240, _pW / 2 + 80
      elseif #group.block[i].data.params == 6 then return _pW / 2 - 240, _pW / 2 + 80, _pW / 2 - 240, _pW / 2 + 80, _pW / 2 - 240, _pW / 2 + 80
      end
    elseif targetName == 'line' then
      if #group.block[i].data.params == 1 then return _pW / 2 + 75
      elseif #group.block[i].data.params == 2 then return _pW / 2 - 85, _pW / 2 + 235
      elseif #group.block[i].data.params == 3 then return _pW / 2 + 75, _pW / 2 - 85, _pW / 2 + 235
      elseif #group.block[i].data.params == 4 then return _pW / 2 - 85, _pW / 2 + 235, _pW / 2 - 85, _pW / 2 + 235
      elseif #group.block[i].data.params == 5 then return _pW / 2 + 75, _pW / 2 - 85, _pW / 2 + 235, _pW / 2 - 85, _pW / 2 + 235
      elseif #group.block[i].data.params == 6 then return _pW / 2 - 85, _pW / 2 + 235, _pW / 2 - 85, _pW / 2 + 235, _pW / 2 - 85, _pW / 2 + 235
      end
    end
  end

  local getYParams = function(targetName)
    if targetName == 'text' then
      if #group.block[i].data.params < 3 then return group.blockY + 22, group.blockY + 22
      elseif #group.block[i].data.params == 3 then return group.blockY - 8, group.blockY + 52, group.blockY + 52
      elseif #group.block[i].data.params == 4 then return group.blockY - 8, group.blockY - 8, group.blockY + 52, group.blockY + 52
      elseif #group.block[i].data.params == 5 then return group.blockY - 38, group.blockY + 22, group.blockY + 22, group.blockY + 82, group.blockY + 82
      elseif #group.block[i].data.params == 6 then return group.blockY - 38, group.blockY - 38, group.blockY + 22, group.blockY + 22, group.blockY + 82, group.blockY + 82
      end
    elseif targetName == 'line' then
      if #group.block[i].data.params < 3 then return group.blockY + 42, group.blockY + 42
      elseif #group.block[i].data.params == 3 then return group.blockY + 12, group.blockY + 72, group.blockY + 72
      elseif #group.block[i].data.params == 4 then return group.blockY + 12, group.blockY + 12, group.blockY + 72, group.blockY + 72
      elseif #group.block[i].data.params == 5 then return group.blockY - 18, group.blockY + 42, group.blockY + 42, group.blockY + 102, group.blockY + 102
      elseif #group.block[i].data.params == 6 then return group.blockY - 18, group.blockY - 18, group.blockY + 42, group.blockY + 42, group.blockY + 102, group.blockY + 102
      end
    elseif targetName == 'textParams' then
      if #group.block[i].data.params < 3 then return group.blockY + 27, group.blockY + 27
      elseif #group.block[i].data.params == 3 then return group.blockY - 3, group.blockY + 57, group.blockY + 57
      elseif #group.block[i].data.params == 4 then return group.blockY - 3, group.blockY - 3, group.blockY + 57, group.blockY + 57
      elseif #group.block[i].data.params == 5 then return group.blockY - 33, group.blockY + 27, group.blockY + 27, group.blockY + 87, group.blockY + 87
      elseif #group.block[i].data.params == 6 then return group.blockY - 33, group.blockY - 33, group.blockY + 27, group.blockY + 27, group.blockY + 87, group.blockY + 87
      end
    end
  end

  local getWidthLine = function()
    if #group.block[i].data.params == 1 then return 470
    elseif #group.block[i].data.params == 2 then return 150, 150
    elseif #group.block[i].data.params == 3 then return 470, 150, 150
    elseif #group.block[i].data.params == 4 then return 150, 150, 150, 150
    elseif #group.block[i].data.params == 5 then return 470, 150, 150, 150, 150
    elseif #group.block[i].data.params == 6 then return 150, 150, 150, 150, 150, 150
    end
  end

  group.block[i].params = {}

  getTextParams = function(i, j)
    local group = activity.blocks[activity.objects.name]
    local textFromParams = ''

    for p = 1, #group.block[i].data.params[j] do
      local value = group.block[i].data.params[j][p][1]

      if group.block[i].data.params[j][p][2] == 'text' then value = '\'' .. utf8.gsub(value, '\n', '\\n') .. '\''
      elseif group.block[i].data.params[j][p][2] == 'var' then value = '"' .. value .. '"'
      elseif group.block[i].data.params[j][p][2] == 'table' and group.block[i].data.params[j][p][1] ~= '[' and group.block[i].data.params[j][p][1] ~= ']' then value = '{' .. value .. '}'
      elseif group.block[i].data.params[j][p][2] == 'local' then value = '{' .. strings.editorLocalTable .. '}'
      elseif group.block[i].data.params[j][p][2] == 'fun' or group.block[i].data.params[j][p][2] == 'prop' or group.block[i].data.params[j][p][2] == 'log' then
        for n = 1, #strings.editorList[group.block[i].data.params[j][p][2]] do
          if strings.editorList[group.block[i].data.params[j][p][2]][n][2] == value then
            value =  strings.editorList[group.block[i].data.params[j][p][2]][n][1]
          end
        end
      end

      textFromParams = textFromParams == '' and textFromParams .. value or textFromParams .. ' ' .. value
    end

    return textFromParams
  end

  for j = 1, #activity.paramsFormulas[group.block[i].data.name] do
    group.block[i].params[j] = {}

    local textGetHeight = display.newText({
      text = strings.blocks[group.block[i].data.name][2][j], align = 'left',
      x = 0, y = 0, font = 'ubuntu_!bold.ttf', fontSize = 22, width = 150
    })

    if textGetHeight.height > 53 then textGetHeight.height = 53 end

    group.block[i].params[j].name = display.newText({
      text = strings.blocks[group.block[i].data.name][2][j], align = 'left', height = textGetHeight.height,
      x = select(j, getXParams('text')), y = select(j, getYParams('text')), font = 'ubuntu_!bold.ttf', fontSize = 22, width = 150
    })
    group.block[i].params[j].name.additionX = select(j, getXParams('text')) - _pW / 2
    group.block[i].params[j].name.additionY = select(j, getYParams('text')) - group.blockY

    textGetHeight:removeSelf()

    group.block[i].params[j].line = display.newRect(select(j, getXParams('line')), select(j, getYParams('line')), select(j, getWidthLine()), 3)
    group.block[i].params[j].line:setFillColor(84/255,84/255,84/255)
    group.block[i].params[j].line.additionX = select(j, getXParams('line')) - _pW / 2
    group.block[i].params[j].line.additionY = select(j, getYParams('line')) - group.blockY

    group.block[i].params[j].rect = display.newRect(select(j, getXParams('line')), select(j, getYParams('line')) - 21.5, select(j, getWidthLine()), 40)
    group.block[i].params[j].rect:setFillColor(1)
    group.block[i].params[j].rect.alpha = 0.005
    group.block[i].params[j].rect.targetX = group.block[i].params[j].rect.x
    group.block[i].params[j].rect.additionY = select(j, getYParams('line')) - 21.5 - group.blockY

    group.block[i].params[j].rect:addEventListener('touch', function(e)
      if not alertActive and group.scroll.isVisible then
        if e.phase == 'began' then
          display.getCurrentStage():setFocus(e.target)

          if e.target.targetX == e.target.x then
            e.target:setFillColor(0.8, 0.8, 1)
            e.target.alpha = 0.2
          end
        elseif e.phase == 'moved' then
          local dy = math.abs(e.y - e.yStart)
          if dy > 20 then
            group.scroll:takeFocus(e)
            e.target:setFillColor(1)
            e.target.alpha = 0.005
          end
        elseif e.phase == 'ended' then
          display.getCurrentStage():setFocus(nil)

          if e.target.targetX == e.target.x then
            e.target:setFillColor(1)
            e.target.alpha = 0.005

            local _break = false
            for k = 1, #group.block do
              if _break then break end
              for n = 1, #group.block[k].params do
                if group.block[k].params[n].rect.y == e.target.y and group.block[k].params[n].rect.x == e.target.x then
                  if activity.paramsFormulas[group.block[k].data.name][n] == 'value' then
                    activity.blocks.hide()
                    activity.editor.table = {{k, n}}
                    for u = 1, #group.block[k].data.params[n] do
                      activity.editor.table[#activity.editor.table+1] = table.copy(group.block[k].data.params[n][u])
                    end
                    activity.editor.group.isVisible = true
                    activity.editor.newText()
                    activity.editor.genBlock()
                  end
                  _break = true
                  break
                end
              end
            end
          end
        end
      end
      return true
    end)

    group.block[i].params[j].text = display.newText({
      text = getTextParams(i, j), align = 'center', height = 26,
      x = select(j, getXParams('line')), y = select(j, getYParams('textParams')), font = 'ubuntu_!bold.ttf', fontSize = 20, width = select(j, getWidthLine())-5
    })
    group.block[i].params[j].text.additionX = select(j, getXParams('line')) - _pW / 2
    group.block[i].params[j].text.additionY = select(j, getYParams('textParams')) - group.blockY

    group.scroll:insert(group.block[i].params[j].name)
    group.scroll:insert(group.block[i].params[j].line)
    group.scroll:insert(group.block[i].params[j].rect)
    group.scroll:insert(group.block[i].params[j].text)
  end

  group.block[i].onPressCheckbox = function(i)
    group.block[i].checkbox:setState({isOn=not group.block[i].checkbox.isOn})
    if not group.listMany then
      if group.block[i].num ~= group.listPressNum and group.listPressNum > 0 then
        local name = group.block[group.listPressNum].data.name

        group.block[group.listPressNum].checkbox:setState({isOn=false})

        if group.block[group.listPressNum].data.type == 'event' then
          for j = group.listPressNum + 1, #group.block do
            if group.block[j].data.type == 'event' then break
            else
              local name = group.block[j].data.name

              if name ~= 'ifEnd' then
                group.block[j].checkbox.isVisible = true
              end

              group.block[j].checkbox:setState({isOn=false})
            end
          end
        else
          if name == 'if' then
            local nestedFactor = 1

            for j = group.listPressNum + 1, #group.block do
              local name2 = group.block[j].data.name

              if name2 ~= name .. 'End' then
                group.block[j].checkbox.isVisible = true
              end

              group.block[j].checkbox:setState({isOn=false})

              if group.block[j].data.name == name then nestedFactor = nestedFactor + 1
              elseif group.block[j].data.name == name .. 'End' then nestedFactor = nestedFactor - 1 end
              if nestedFactor == 0 then break end
            end
          end
        end

        group.listPressNum = group.block[i].num
      elseif group.block[i].num ~= group.listPressNum then
        group.listPressNum = group.block[i].num
      else
        group.listPressNum = 0
      end
    end

    local name = group.block[i].data.name

    if group.block[i].data.type == 'event' then
      for j = i + 1, #group.block do
        if group.block[j].data.type == 'event' then break
        else
          local name = group.block[j].data.name

          if name ~= 'ifEnd' then
            group.block[j].checkbox.isVisible = not group.block[i].checkbox.isOn
          end

          group.block[j].checkbox:setState({isOn=group.block[i].checkbox.isOn})
          group.block[j].parentIndex = i
        end
      end
    else
      if name == 'if' then
        local nestedFactor = 1

        for j = i + 1, #group.block do
          local name = group.block[j].data.name

          if name ~= group.block[i].data.name .. 'End' then
            group.block[j].checkbox.isVisible = not group.block[i].checkbox.isOn
          end

          group.block[j].checkbox:setState({isOn=group.block[i].checkbox.isOn})
          group.block[j].parentIndex = i

          if name == group.block[i].data.name then nestedFactor = nestedFactor + 1
          elseif name == group.block[i].data.name .. 'End' then nestedFactor = nestedFactor - 1 end
          if nestedFactor == 0 then break end
        end
      end
    end
  end

  group.block[i].checkbox = widget.newSwitch({
    x = _pW / 2 - 336, y = group.blockY, style = 'checkbox', width = 60, height = 60,
    onPress = function(event) event.target:setState({isOn=not event.target.isOn}) end
  })
  group.block[i].checkbox.isVisible = false

  group.scroll:insert(group.block[i].checkbox)
end

activity.putBlock = function(i)
  local group = activity.blocks[activity.objects.name]

  table.insert(group.block, i, {})
  group.block[i] = display.newImage('Image/' .. activity.genType(i) .. 'Block.png', _pW / 2, group.blockY)
  group.block[i].num = i
  group.block[i].data = group.data[i]
  group.block[i].press = false
  group.block[i].path = 'Image/' .. activity.genType(i) .. 'Block.png'

  if group.block[i].data.type == 'formula' then
    if #group.block[i].data.params < 3 then
      group.block[i].height = 119
      group.block[i].cornerType = 'cornerShort'
    elseif #group.block[i].data.params < 5 then
      group.block[i].height = 179
      group.block[i].cornerType = 'corner'
    elseif #group.block[i].data.params < 7 then
      group.block[i].height = 239
      group.block[i].cornerType = 'cornerLong'
    end

    group.block[i].corner = display.newImage('Image/' .. group.block[i].cornerType .. '.png', _pW / 2, group.blockY)
  end

  local textHeight = 0

  if #group.block[i].data.params < 3 then textHeight = group.blockY - 32
  elseif #group.block[i].data.params < 5 then textHeight = group.blockY - 62
  elseif #group.block[i].data.params < 7 then textHeight = group.blockY - 92 end

  group.block[i].text = display.newText({
    text = strings.blocks[group.block[i].data.name][1], align = 'left', height = 40,
    x = _pW / 2 + 10, y = textHeight, font = 'ubuntu.ttf', fontSize = 32, width = 620
  })
  group.block[i].text.additionY = textHeight - group.blockY

  group.scroll:insert(group.block[i])
  group.scroll:insert(group.block[i].text)
  if group.block[i].data.type == 'formula' then group.scroll:insert(group.block[i].corner) end

  activity.putBlockParams(i)

  group.block[i]:addEventListener('touch', activity.onClickLogBlock)

  group.scroll:setScrollHeight(group.scrollHeight)
end

activity.scrollHeightUpdate = function()
  local group = activity.blocks[activity.objects.name]

  group.scrollHeight = 20

  for j = 1, #group.block do
    local newHeight = 0

    if group.block[j].data.type == 'event' then newHeight = 146
    elseif #group.block[j].data.params < 3 then newHeight = 116
    elseif #group.block[j].data.params < 5 then newHeight = 176
    elseif #group.block[j].data.params < 7 then newHeight = 236 end

    group.scrollHeight = group.scrollHeight + newHeight
  end
end

activity.genBlock = function(i)
  local group = activity.blocks[activity.objects.name]

  group.blockY = -66

  for j = 1, i-1 do
    local newHeight = 0

    if group.block[j].data.type == 'event' then newHeight = 146
    elseif #group.block[j].data.params < 3 then newHeight = 116
    elseif #group.block[j].data.params < 5 then newHeight = 176
    elseif #group.block[j].data.params < 7 then newHeight = 236 end

    group.blockY = group.blockY + newHeight
  end

  activity.scrollHeightUpdate()

  local newHeight = 0

  if group.data[i].type == 'event' then newHeight = 146
  elseif #group.data[i].params < 3 then newHeight = 116
  elseif #group.data[i].params < 5 then newHeight = 146
  elseif #group.data[i].params < 7 then newHeight = 176 end

  group.blockY, group.scrollHeight = group.blockY + newHeight, group.scrollHeight + newHeight

  activity.putBlock(i)
end
