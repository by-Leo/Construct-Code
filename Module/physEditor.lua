activity.physedit = {}
activity.physedit.table = {}

activity.physedit.onKeyEvent = function(event)
  if activity.physedit.group then
    if (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and event.phase == 'up' then
      timer.performWithDelay(1, function() activity.physedit.hide() end)
    end
  end return true
end Runtime:addEventListener('key', activity.physedit.onKeyEvent)

activity.physedit.hide = function()
  physics.pause()
  physics.setDrawMode('normal')
  activity.physedit.group:removeSelf()
  activity.physedit.group = nil
  display.setDefault('magTextureFilter', 'linear')
  Runtime:removeEventListener('enterFrame', activity.physedit.lineSet)
  activity.blocks.view()
end

activity.physedit.view = function()
  physics.start()
  activity.physedit.group = display.newGroup()
  display.setDefault('magTextureFilter', activity.physedit.table.import)

  local rect = display.newImage(activity.physedit.table.path, system.DocumentsDirectory, _x, _y + _aY - 620)

  if rect then
    local rect_width = rect.width
    local rect_height = rect.height

    local size_formula = rect.width / 600
    rect.width = 600
    rect.height = rect.height / size_formula
    if rect.height > 600 then
      size_formula = rect.height / 600
      rect.height = 600
      rect.width = rect.width / size_formula
    end

    local plat = display.newRect(_x, _y + _aY - 220, _aW, 80)
    plat.rotation = 0
    plat:setFillColor(0, 0.6, 0)

    physics.addBody(plat, 'static')
    activity.physedit.group:insert(rect)
    activity.physedit.group:insert(plat)

    local but
    local but2
    local but3
    local but4
    local but5

    local cBool = true
    local cBool2 = true
    local points_active = 4
    local points_table_active = 1
    local points = {{}}
    local lines = {{}}

    local points_reposition = function(i)
      if i == 1 then return _x - rect.width/2, rect.y - rect.height/2 end
      if i == 2 then return _x + rect.width/2, rect.y - rect.height/2 end
      if i == 3 then return _x + rect.width/2, rect.y + rect.height/2 end
      if i == 4 then return _x - rect.width/2, rect.y + rect.height/2 end
    end

    for i = 1, 4 do
      local x, y = points_reposition(i)
      points[1][i] = display.newCircle(x, y, 15)
      points[1][i].i, points[1][i].j = i, 1
      points[1][i]:setFillColor(0, 0.8, 0.5)

      points[1][i]:addEventListener('touch', function(e)
        points_active, points_table_active = e.target.i, e.target.j
        if e.phase == 'began' then display.getCurrentStage():setFocus(e.target)
        elseif e.phase == 'moved' then e.target.x, e.target.y = e.x, e.y
        elseif e.phase == 'ended' or e.phase == 'cancelled' then display.getCurrentStage():setFocus(nil)
        end return true
      end) activity.physedit.group:insert(points[1][i])
    end points[1][4]:setFillColor(0, 0.3, 1)

    for i = 1, 4 do
      lines[1][i] = display.newRect(0,0,0,0)
      activity.physedit.group:insert(lines[1][i])
    end

    local shape_width = rect.width / rect_width
    local shape_height = rect.height / rect_height

    if utf8.len(activity.physedit.table.box) > 0 then
      pcall(function() local box = json.decode(activity.physedit.table.box)
        for j = 1, #box do
          if j > 1 then
            points_active, points_table_active = 4, #points + 1

            points[#points+1] = {} lines[#points] = {}
            points[#points][1] = display.newCircle(_x - rect.width/2, rect.y - rect.height/2, 15)
            points[#points][1]:setFillColor(0, 0.8, 0.5)
            points[#points][2] = display.newCircle(_x + rect.width/2, rect.y - rect.height/2, 15)
            points[#points][2]:setFillColor(0, 0.8, 0.5)
            points[#points][3] = display.newCircle(_x + rect.width/2, rect.y + rect.height/2, 15)
            points[#points][3]:setFillColor(0, 0.8, 0.5)
            points[#points][4] = display.newCircle(_x - rect.width/2, rect.y + rect.height/2, 15)
            points[#points][4]:setFillColor(0, 0.3, 1)

            for i = 1, 4 do
              points[#points][i].i, points[#points][i].j = i, #points
              points[#points][i]:addEventListener('touch', function(e)
                points_active, points_table_active = e.target.i, e.target.j
                if e.phase == 'began' then display.getCurrentStage():setFocus(e.target)
                elseif e.phase == 'moved' then e.target.x, e.target.y = e.x, e.y
                elseif e.phase == 'ended' or e.phase == 'cancelled' then display.getCurrentStage():setFocus(nil)
                end return true
              end) activity.physedit.group:insert(points[#points][i])
            end

            for i = 1, 4 do
              lines[#points][i] = display.newRect(0,0,0,0)
              activity.physedit.group:insert(lines[#points][i])
            end
          end
          for i = 1, #box[j] do
            if i + (i - 1) > #box[j] then break end
            points[j][i].x = box[j][i + (i - 1)] * shape_width + _x
            points[j][i].y = box[j][i + i] * shape_height + rect.y
          end
        end
      end)
    end

    activity.physedit.lineSet = function()
      if cBool2 then
        for j = 1, #lines do
          for i = 1, #lines[j] do
            if lines[j][i] then
              lines[j][i]:removeSelf()
            end
          end
        end
      end

      if cBool and but3.text.text == strings.hideLines then cBool2 = true
        for j = 1, #lines do
          for i = 1, #lines[j] do
            if i == #lines[j] then
              lines[j][i] = display.newLine(points[j][i].x, points[j][i].y, points[j][1].x, points[j][1].y)
              lines[j][i]:setStrokeColor(0, 0.8, 0.5)
              lines[j][i].strokeWidth = 4
            else
              lines[j][i] = display.newLine(points[j][i].x, points[j][i].y, points[j][i+1].x, points[j][i+1].y)
              lines[j][i]:setStrokeColor(0, 0.8, 0.5)
              lines[j][i].strokeWidth = 4
            end activity.physedit.group:insert(lines[j][i])
          end
        end points[points_table_active][points_active]:toFront()
        for j = 1, #points do
          for i = 1, #points[j] do
            points[j][i]:setFillColor(0, 0.8, 0.5)
          end
        end points[points_table_active][points_active]:setFillColor(0, 0.3, 1)
        for j = 1, #points do
          for i = 1, #points[j] do
            if not (points_table_active == j and points_active == i) then
              if but6.text.text == strings.offMagnetX
              and math.abs(points[j][i].x - points[points_table_active][points_active].x) <= 5 then
                points[points_table_active][points_active].x = points[j][i].x
              end if but7.text.text == strings.offMagnetY
              and math.abs(points[j][i].y - points[points_table_active][points_active].y) <= 5 then
                points[points_table_active][points_active].y = points[j][i].y
              end
            end
          end
        end
      else cBool2 = false end
    end

    local plus = display.newGroup()
    local minus = display.newGroup()

    local plus2 = display.newGroup()
    local minus2 = display.newGroup()

    display.newRect(plus, 0, 0, 60, 60):addEventListener('touch', function(e)
      if e.phase == 'began' then
        if cBool and but3.text.text == strings.hideLines and #points[points_table_active] < 8 then points_active_last = points_active + 1
          if points_active_last > #points[points_table_active] then points_active_last = 1 end
          table.insert(points[points_table_active], points_active+1, display.newCircle((points[points_table_active][points_active].x + points[points_table_active][points_active_last].x) / 2, (points[points_table_active][points_active].y + points[points_table_active][points_active_last].y) / 2, 15))
          activity.physedit.group:insert(points[points_table_active][points_active+1])
          for i = points_active+2, #points[points_table_active] do points[points_table_active][i].i = points[points_table_active][i].i + 1 end
          points[points_table_active][points_active+1]:setFillColor(0, 0.8, 0.5)
          points[points_table_active][points_active+1]:addEventListener('touch', function(e)
            points_active, points_table_active = e.target.i, e.target.j
            if e.phase == 'began' then
              display.getCurrentStage():setFocus(e.target)
            elseif e.phase == 'moved' then
              e.target.x = e.x
              e.target.y = e.y
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
              display.getCurrentStage():setFocus(nil)
            end return true
          end)
          points[points_table_active][points_active+1].i = points_active+1
          points[points_table_active][points_active+1].j = points_table_active
          table.insert(lines[points_table_active], points_active+1, '')
          lines[points_table_active][points_active+1] = display.newRect(0,0,0,0)
          activity.physedit.group:insert(lines[points_table_active][points_active+1])
        end
      end
    end)
    display.newRect(minus, 0, 0, 60, 60):addEventListener('touch', function(e)
      if e.phase == 'began' then
        if cBool and but3.text.text == strings.hideLines and #points[points_table_active] > 3 then
          points[points_table_active][points_active]:removeSelf()
          lines[points_table_active][points_active]:removeSelf()
          table.remove(points[points_table_active], points_active)
          table.remove(lines[points_table_active], points_active)
          for i = points_active, #points[points_table_active] do points[points_table_active][i].i = points[points_table_active][i].i - 1 end
          if points_active > #points[points_table_active] then points_active = #points[points_table_active] end
        end
      end
    end)

    display.newRect(plus2, 0, 0, 60, 60):addEventListener('touch', function(e)
      if e.phase == 'began' and but3.text.text == strings.hideLines then
        points_active, points_table_active = 4, #points + 1

        points[#points+1] = {} lines[#points] = {}
        points[#points][1] = display.newCircle(_x - rect.width/2, rect.y - rect.height/2, 15)
        points[#points][1]:setFillColor(0, 0.8, 0.5)
        points[#points][2] = display.newCircle(_x + rect.width/2, rect.y - rect.height/2, 15)
        points[#points][2]:setFillColor(0, 0.8, 0.5)
        points[#points][3] = display.newCircle(_x + rect.width/2, rect.y + rect.height/2, 15)
        points[#points][3]:setFillColor(0, 0.8, 0.5)
        points[#points][4] = display.newCircle(_x - rect.width/2, rect.y + rect.height/2, 15)
        points[#points][4]:setFillColor(0, 0.3, 1)

        for i = 1, 4 do
          points[#points][i].i, points[#points][i].j = i, #points
          points[#points][i]:addEventListener('touch', function(e)
            points_active, points_table_active = e.target.i, e.target.j
            if e.phase == 'began' then display.getCurrentStage():setFocus(e.target)
            elseif e.phase == 'moved' then e.target.x, e.target.y = e.x, e.y
            elseif e.phase == 'ended' or e.phase == 'cancelled' then display.getCurrentStage():setFocus(nil)
            end return true
          end) activity.physedit.group:insert(points[#points][i])
        end

        for i = 1, 4 do
          lines[#points][i] = display.newRect(0,0,0,0)
          activity.physedit.group:insert(lines[#points][i])
        end
      end
    end)
    display.newRect(minus2, 0, 0, 60, 60):addEventListener('touch', function(e)
      if e.phase == 'began' and but3.text.text == strings.hideLines and #points > 1 then
        for i = 1, #points[points_table_active] do
          points[points_table_active][i]:removeSelf()
          lines[points_table_active][i]:removeSelf()
        end
        table.remove(points, points_table_active)
        table.remove(lines, points_table_active)
        points_table_active, points_active = points_table_active - 1, 4
        if points_table_active == 0 then points_table_active = 1 end
        if #points[points_table_active] == 3 then points_active = 3 end
        for j = 1, #points do for i = 1, #points[j] do if points[j][i] then points[j][i].j = j end end end
      end
    end)

    display.newRect(plus, 0, 0, 45, 4):setFillColor(0)
    display.newRect(plus, 0, 0, 4, 45):setFillColor(0)
    display.newText(plus, strings.addPoint, 50, 0, 'ubuntu.ttf', 26).anchorX = 0
    display.newRect(minus, 0, 0, 45, 4):setFillColor(0)
    display.newText(minus, strings.removePoint, 50, 0, 'ubuntu.ttf', 26).anchorX = 0

    display.newRect(plus2, 0, 0, 45, 4):setFillColor(0)
    display.newRect(plus2, 0, 0, 4, 45):setFillColor(0)
    display.newText(plus2, strings.addBox, 50, 0, 'ubuntu.ttf', 26).anchorX = 0
    display.newRect(minus2, 0, 0, 45, 4):setFillColor(0)
    display.newText(minus2, strings.removeBox, 50, 0, 'ubuntu.ttf', 26).anchorX = 0

    plus.x = _x - _aX + 50
    plus.y = _y + _aY - 125
    minus.x = _x - _aX + 50
    minus.y = _y + _aY - 50

    plus2.x = _x
    plus2.y = _y + _aY - 125
    minus2.x = _x
    minus2.y = _y + _aY - 50

    but = display.newRect(_x - _aX + 50, _y - _aY + 50, 60, 60)
    but.text = display.newText(strings.viewHitbox, _x - _aX + 100, _y - _aY + 50, 'ubuntu.ttf', 30)
    but.text.anchorX = 0
    but:setFillColor(0, 0.5, 0.8)

    but2 = display.newRect(_x - _aX + 50, _y - _aY + 125, 60, 60)
    but2.text = display.newText(strings.onPhysics, _x - _aX + 100, _y - _aY + 125, 'ubuntu.ttf', 30)
    but2.text.anchorX = 0
    but2:setFillColor(0.8, 0.1, 0.3)

    but3 = display.newRect(_x - _aX + 50, _y - _aY + 200, 60, 60)
    but3.text = display.newText(strings.hideLines, _x - _aX + 100, _y - _aY + 200, 'ubuntu.ttf', 30)
    but3.text.anchorX = 0
    but3:setFillColor(0.2, 0.6, 0.3)

    but4 = display.newRect(_x - _aX + 50, _y - _aY + 275, 60, 60)
    but4.text = display.newText(strings.viewIndexBox, _x - _aX + 100, _y - _aY + 275, 'ubuntu.ttf', 30)
    but4.text.anchorX = 0
    but4:setFillColor(0.8, 0.5, 0.3)

    but5 = display.newRect(_x - _aX + 50, _y - _aY + 350, 60, 60)
    but5.text = display.newText(strings.saveAndExit, _x - _aX + 100, _y - _aY + 350, 'ubuntu.ttf', 30)
    but5.text.anchorX = 0
    but5:setFillColor(0.4, 0.2, 0.5)

    but6 = display.newRect(_x - _aX + 50, _y - _aY + 425, 60, 60)
    but6.text = display.newText(strings.onMagnetX, _x - _aX + 100, _y - _aY + 425, 'ubuntu.ttf', 30)
    but6.text.anchorX = 0
    but6:setFillColor(0.8, 0.8, 0.3)

    but7 = display.newRect(_x - _aX + 50, _y - _aY + 500, 60, 60)
    but7.text = display.newText(strings.onMagnetY, _x - _aX + 100, _y - _aY + 500, 'ubuntu.ttf', 30)
    but7.text.anchorX = 0
    but7:setFillColor(0.2, 0.7, 0.7)

    but:addEventListener('touch', function(e)
      if e.phase == 'began' then
        if cBool and but3.text.text == strings.hideLines then physics.removeBody(rect)
          rect.x, rect.y, rect.rotation = _x, _y + _aY - 620, 0
          local shape, _shape = {}, {}
          for j = 1, #points do shape[j] = {}
            for i = 1, #points[j] do
              shape[j][#shape[j]+1] = points[j][i].x - _x
              shape[j][#shape[j]+1] = points[j][i].y - rect.y
            end _shape[j] = {shape=shape[j]}
          end physics.addBody(rect, 'static', unpack(_shape))
        end if but.text.text == strings.viewHitbox
        then physics.setDrawMode('hybrid') but.text.text = strings.hideHitbox
        else physics.setDrawMode('normal') but.text.text = strings.viewHitbox end
      end
    end)

    but2:addEventListener('touch', function(e)
      if e.phase == 'began' then
        if cBool and but3.text.text == strings.hideLines then physics.removeBody(rect)
          rect.x, rect.y, rect.rotation = _x, _y + _aY - 620, 0
          local shape, _shape = {}, {}
          for j = 1, #points do shape[j] = {}
            for i = 1, #points[j] do
              shape[j][#shape[j]+1] = points[j][i].x - _x
              shape[j][#shape[j]+1] = points[j][i].y - rect.y
            end _shape[j] = {friction=-1, shape=shape[j]}
          end physics.addBody(rect, 'dynamic', unpack(_shape))
          timer.performWithDelay(1, function() rect.x, rect.y, rect.rotation = _x, _y + _aY - 620, 0 end)
        end
      end
    end)

    but3:addEventListener('touch', function(e)
      if e.phase == 'began' then
        if but3.text.text == strings.hideLines then but3.text.text = strings.viewLines
          for j = 1, #points do for i = 1, #points[j] do points[j][i].isVisible = false end end
        else but3.text.text = strings.hideLines
          for j = 1, #points do for i = 1, #points[j] do points[j][i].isVisible = true end end
        end
      end
    end)

    but4:addEventListener('touch', function(e)
      if e.phase == 'began' and cBool and but3.text.text == strings.hideLines then
        alert(strings.indexBox, strings.index .. points_table_active, {strings.buttonInput}, function(e) end)
      end
    end)

    but5:addEventListener('touch', function(e)
      if e.phase == 'began' and cBool then
        local shape = {}
        local shape_width = rect_width / rect.width
        local shape_height = rect_height / rect.height
        local shape_x = true
        local shape_object = {}

        for j = 1, #points do shape[j] = {}
          for i = 1, #points[j] do
            shape[j][#shape[j]+1] = points[j][i].x - _x
            shape[j][#shape[j]+1] = points[j][i].y - rect.y
          end
        end

        for i = 1, #shape do shape_object[i] = {}
          for j = 1, #shape[i] do
            if shape_x then
              shape_x = false
              shape_object[i][j] = shape[i][j] * shape_width
            else
              shape_x = true
              shape_object[i][j] = shape[i][j] * shape_height
            end
          end
        end

        local shape_object = json.encode(shape_object)
        local group = activity.blocks[activity.objects.name]
        local k, n = activity.physedit.table.k, activity.physedit.table.n
        local paramsTable = {}

        for f = 1, #group.block[k].data.params[n] do
          if group.block[k].data.params[n][f] then
            paramsTable[f] = table.copy(group.block[k].data.params[n][f])
          end
        end paramsTable[1] = table.copy({shape_object, 'boxphys'})

        group.block[k].data.params[n] = table.copy(paramsTable)
        group.block[k].params[n].text.text = getTextParams(k, n, group)
        activity.physedit.hide()
        activity.blocksFileUpdate()
      end
    end)

    but6:addEventListener('touch', function(e)
      if e.phase == 'began' then
        if but6.text.text == strings.onMagnetX
        then but6.text.text = strings.offMagnetX
        else but6.text.text = strings.onMagnetX end
      end
    end)

    but7:addEventListener('touch', function(e)
      if e.phase == 'began' then
        if but7.text.text == strings.onMagnetY
        then but7.text.text = strings.offMagnetY
        else but7.text.text = strings.onMagnetY end
      end
    end)

    activity.physedit.group:insert(plus)
    activity.physedit.group:insert(minus)
    activity.physedit.group:insert(plus2)
    activity.physedit.group:insert(minus2)
    activity.physedit.group:insert(but)
    activity.physedit.group:insert(but.text)
    activity.physedit.group:insert(but2)
    activity.physedit.group:insert(but2.text)
    activity.physedit.group:insert(but3)
    activity.physedit.group:insert(but3.text)
    activity.physedit.group:insert(but4)
    activity.physedit.group:insert(but4.text)
    activity.physedit.group:insert(but5)
    activity.physedit.group:insert(but5.text)
    activity.physedit.group:insert(but6)
    activity.physedit.group:insert(but6.text)
    activity.physedit.group:insert(but7)
    activity.physedit.group:insert(but7.text)

    Runtime:addEventListener('enterFrame', activity.physedit.lineSet)
  else activity.physedit.hide() end
end
