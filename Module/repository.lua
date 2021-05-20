repository = function(params)
  local repGroup, repActive = display.newGroup(), false alertActive = true

  function onKeyEventRepository(event)
    if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' and not repActive then
      alertActive = false
      repGroup:removeSelf()
      Runtime:removeEventListener('key', onKeyEventRepository)
    end return true
  end Runtime:addEventListener('key', onKeyEventRepository)

  local bg, blocks = display.newImage('Image/bg.png'), {}
  local title = display.newText(strings.repository, _x - _aX + 50, _y - _aY + 80, 'ubuntu_!bold.ttf', 58)
  local scroll = widget.newScrollView({
    x = _x, y = _y + 75,
    width = _aW, height = _aH - 150,
    hideBackground = true, hideScrollBar = true,
    horizontalScrollDisabled = true, isBounceEnabled = true,
    listener = function(e) return true end
  }) bg.x, bg.y, bg.width, bg.height, title.anchorX = _x, _y - _tH / 2, _aW, _aH + _tH, 0

  repGroup:insert(bg)
  repGroup:insert(title)
  repGroup:insert(scroll)

  for i in pairs(settings.repository) do
    blocks[#blocks + 1] = display.newRoundedRect(repGroup, _x, 60 + 110 * #blocks, _aW - 40, 100, 20)
    blocks[#blocks]:setFillColor(25/255, 26/255, 32/255)

    blocks[#blocks].text = display.newText({
      parent = repGroup, text = i, x = _x, y = blocks[#blocks].y,
      font = 'ubuntu', fontSize = 30, width = _aW - 80
    }) blocks[#blocks].id = #blocks

    scroll:insert(blocks[#blocks])
    scroll:insert(blocks[#blocks].text)

    blocks[#blocks]:addEventListener('touch', function(e)
      if e.phase == 'began' then e.target.click = true
        display.getCurrentStage():setFocus(e.target)
      elseif e.phase == 'moved' and math.abs(e.yStart-e.y) > 20 then
        scroll:takeFocus(e) e.target.click = false
      elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        if e.target.click and not repActive then
          e.target.click, repActive = false, true
          alert(strings.repositoryChooseAct, e.target.text.text, {strings.repositoryAlertTake, strings.repositoryAlertRemove},
          function(event) if event.num ~= 1 then repActive, alertActive = false, true end if event.num == 1 then
            local group = activity.blocks[activity.objects.name]
            alertActive = false repGroup:removeSelf()
            Runtime:removeEventListener('key', onKeyEventRepository)

            table.insert(group.data, 1, {
              name = settings.repository[i].name,
              params = table.copy(settings.repository[i].params),
              comment = settings.repository[i].comment,
              type = 'event'
            }) activity.genBlock(1)

            for j = 1, #settings.repository[i].formulas do
              table.insert(group.data, j + 1, {
                name = settings.repository[i].formulas[j].name,
                params = table.copy(settings.repository[i].formulas[j].params),
                comment = settings.repository[i].formulas[j].comment,
                type = 'formula'
              }) activity.genBlock(j + 1)
            end for j = 1, #group.block do group.block[j].num = j end

            activity.blocksReturnBlock(1, group, 0)
            activity.blocksFileUpdate()
            activity.scrollHeightUpdate()
            group.scroll:setScrollHeight(group.scrollHeight) activity.scenes.getVarFunTable()
            if #group.block > 1 then activity.blocksMove(group.block[1], 'create', group) end
          elseif event.num == 2 then scroll:remove(e.target.text) scroll:remove(e.target)
            local index = e.target.id e.target.text:removeSelf() e.target:removeSelf()
            table.remove(blocks, index) for j = 1, #blocks do blocks[j].id = j
              blocks[j].y = 60 + 110 * (j - 1) blocks[j].text.y = blocks[j].y
            end settings.repository[i] = nil settingsSave()
          end end)
        end
      end return true
    end)
  end
end
