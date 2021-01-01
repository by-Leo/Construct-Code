activity.onClickButton = {}

activity.onClick = function(names, types, e)
  if not alertActive and activity[types][names].scroll.isVisible then
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
      if e.target.type == 'list' then e.target.width, e.target.height, e.target.alpha = 93.8, 76.3, 0.9 else e.target.alpha = 0.6 end
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
      display.getCurrentStage():setFocus(nil)
      if e.target.type == 'list' then e.target.width, e.target.height, e.target.alpha = 103.2, 84, 1 else e.target.alpha = 0.9 end
      if e.target.type == 'okay' or #activity[types][names].block == 0 then
        activity.onClickButton[types][e.target.type](e)
      elseif not activity[types][names].block[1].checkbox.isVisible then
        activity.onClickButton[types][e.target.type](e)
      end
    end
  end
end

activity.onClickLogBlock = function(e)
  local group = activity.blocks[activity.objects.name]

  if not alertActive and group.scroll.isVisible then
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
      if not e.target.checkbox.isVisible then
        e.target.press = true
        e.target.timer = timer.performWithDelay(300, function() activity.blocksOnTimer(e.target, group) end)
      end
    elseif e.phase == 'moved' then
      local dy = math.abs(e.y - e.yStart)
      if dy > 20 then
        group.scroll:takeFocus(e)
        e.target.press = false
        if e.target.timer then timer.cancel(e.target.timer) end
      end
    elseif e.phase == 'ended' then
      display.getCurrentStage():setFocus(nil)

      if e.target.checkbox.isVisible then group.block[e.target.num].onPressCheckbox(e.target.num)
      else
        e.target.press = false
        if e.target.timer then if not e.target.timer._removed then timer.cancel(e.target.timer) activity.onClickButton.blocks.block(e) end end
      end
    end
  end
  return true
end

activity.onClickBlock = function(names, types, e)
  if not alertActive and activity[types][names].scroll.isVisible then
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
      if not e.target.checkbox.isVisible then
        e.target:setFillColor(30/255, 31/255, 37/255)
        e.target.alpha = 0.8
        if types == 'objects' or types == 'textures' then e.target.container.alpha = 0.9 end
        if types ~= 'programs' and types ~= 'resources' then e.target.timer = timer.performWithDelay(300, function() activity.onTimer(e.target, types, names) end) end
      end
    elseif e.phase == 'moved' then
      local dy = math.abs(e.y - e.yStart)
      if dy > 20 then
        activity[types][names].scroll:takeFocus(e)
        e.target:setFillColor(25/255, 26/255, 32/255)
        e.target.alpha = 0.9
        if types == 'objects' or types == 'textures' then e.target.container.alpha = 1 end
        if types ~= 'programs' and types ~= 'resources' then if e.target.timer then timer.cancel(e.target.timer) end end
      end
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
      display.getCurrentStage():setFocus(nil)
      if e.target.checkbox.isVisible then
        e.target.checkbox:setState({isOn=not e.target.checkbox.isOn})
        if not activity[types][names].listMany then
          if e.target.num ~= activity[types][names].listPressNum then
            activity[types][names].block[activity[types][names].listPressNum].checkbox:setState({isOn=false})
          end
          activity[types][names].listPressNum = e.target.num
        end
      else
        e.target:setFillColor(25/255, 26/255, 32/255)
        e.target.alpha = 0.9
        if types == 'objects' or types == 'textures' then e.target.container.alpha = 1 end
        if types ~= 'programs' and types ~= 'resources' then if e.target.timer then if not e.target.timer._removed then
          timer.cancel(e.target.timer) activity.onClickButton[types].block(e) end end
        else activity.onClickButton[types].block(e) end
      end
    end
  end
end
