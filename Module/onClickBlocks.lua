activity.onClickButton.blocks = {}

activity.onClickButton.blocks.add = function(e)
  activity.blocks.hide()
  activity.newblocks.group.isVisible = true
end

activity.onClickButton.blocks.play = function(e)
  activity.blocks.hide()
  startProject(activity.programs.name, 'blocks')
end

activity.onClickButton.blocks.list = function(e)
  if #activity.blocks[activity.objects.name].block > 0 then
    activity.blocks[activity.objects.name].scroll:setIsLocked(true, 'vertical')

    list({activity.objects.object, strings.remove, strings.copy, strings.comment}, {x = e.target.x, y = e.target.y, targetHeight = e.target.height, activeBut = activity.objects.object}, function(event)
      activity.blocks[activity.objects.name].scroll:setIsLocked(false, 'vertical')

      activity.blocks[activity.objects.name].alertActive = event.num > 1
      activity.blocks[activity.objects.name].listMany = event.num ~= 3
      if event.num > 1 then
        activity.blocks.add.isVisible = false
        activity.blocks.play.isVisible = false
        activity.blocks.okay.isVisible = true
        activity.blocks.okay.num = event.num
        for i = 1, #activity.blocks[activity.objects.name].block do
          activity.blocks[activity.objects.name].block[i].x = activity.blocks[activity.objects.name].block[i].x + 20
          activity.blocks[activity.objects.name].block[i].text.x = activity.blocks[activity.objects.name].block[i].text.x + 20

          if activity.blocks[activity.objects.name].block[i].data.type == 'formula' then
            activity.blocks[activity.objects.name].block[i].corner.x = activity.blocks[activity.objects.name].block[i].corner.x + 20
          end

          if activity.blocks[activity.objects.name].block[i].params then
            for p = 1, #activity.blocks[activity.objects.name].block[i].params do
              activity.blocks[activity.objects.name].block[i].params[p].name.x = activity.blocks[activity.objects.name].block[i].params[p].name.x + 20
              activity.blocks[activity.objects.name].block[i].params[p].line.x = activity.blocks[activity.objects.name].block[i].params[p].line.x + 20
              activity.blocks[activity.objects.name].block[i].params[p].text.x = activity.blocks[activity.objects.name].block[i].params[p].text.x + 20
              activity.blocks[activity.objects.name].block[i].params[p].rect.isVisible = false
            end
          end

          local name = activity.blocks[activity.objects.name].block[i].data.name

          if name ~= 'ifEnd' and name ~= 'forEnd' then
            activity.blocks[activity.objects.name].block[i].checkbox.isVisible = true
          end
        end
        activity.blocks.act.text = '(' .. event.text .. ')'
      end
    end)
  end
end

activity.onClickButton.blocks.okay = function(e)
  activity.blocks[activity.objects.name].alertActive = false
  activity.blocks[activity.objects.name].listPressNum = 0
  activity.onClickButton.blocks[e.target.num]()

  activity.blocks.add.isVisible = true
  activity.blocks.play.isVisible = true
  activity.blocks.okay.isVisible = false
  for i = 1, #activity.blocks[activity.objects.name].block do
    activity.blocks[activity.objects.name].block[i].x = activity.blocks[activity.objects.name].block[i].x - 20
    activity.blocks[activity.objects.name].block[i].text.x = activity.blocks[activity.objects.name].block[i].text.x - 20

    if activity.blocks[activity.objects.name].block[i].data.type == 'formula' then
      activity.blocks[activity.objects.name].block[i].corner.x = activity.blocks[activity.objects.name].block[i].corner.x - 20
    end

    if activity.blocks[activity.objects.name].block[i].params then
      for p = 1, #activity.blocks[activity.objects.name].block[i].params do
        activity.blocks[activity.objects.name].block[i].params[p].name.x = activity.blocks[activity.objects.name].block[i].params[p].name.x - 20
        activity.blocks[activity.objects.name].block[i].params[p].line.x = activity.blocks[activity.objects.name].block[i].params[p].line.x - 20
        activity.blocks[activity.objects.name].block[i].params[p].text.x = activity.blocks[activity.objects.name].block[i].params[p].text.x - 20
        activity.blocks[activity.objects.name].block[i].params[p].rect.isVisible = true
      end
    end

    activity.blocks[activity.objects.name].block[i].checkbox.isVisible = false
    activity.blocks[activity.objects.name].block[i].checkbox:setState({isOn=false})
  end
  activity.blocks.act.text = ''
end

activity.onClickButton.blocks.block = function(e)
  if activity.blocks[activity.objects.name].block[e.target.num].data.name ~= 'ifEnd'
  and activity.blocks[activity.objects.name].block[e.target.num].data.name ~= 'forEnd'
  and not activity.blocks[activity.objects.name].alertActive then
    blockList(e.target.num)
  end
end

activity.onClickButton.blocks[1] = function() end

activity.onClickButton.blocks[2] = function()
  local group = activity.blocks[activity.objects.name]

  for i = #group.block, 1, -1 do
    if group.block[i].checkbox.isOn then
      activity.blocksDeleteBlock(group.block[i], group.block[i].num, group)
    end
  end

  for i = 1, #group.block do group.block[i].num = i end
  activity.blocksReturnBlock(1, group, 0)
  activity.blocksFileUpdate()
  activity.scrollHeightUpdate()
  group.scroll:setScrollHeight(group.scrollHeight)
end

activity.onClickButton.blocks[3] = function(inList)
  local group = activity.blocks[activity.objects.name]
  local count = 0
  local j = 0

  for i = 1, #group.block do
    if group.block[i].checkbox.isOn then
      if (group.block[i].data.name == 'if' or group.block[i].data.name == 'for' or group.block[i].data.type == 'event') and count == 0 then j = i count = count + 1
      elseif count > 0 then count = count + 1
      else j = i count = 1 break end
    end
  end

  if j > 0 then
    for i = j, #group.block do
      if group.block[i].checkbox.isOn then
        group.data[i + count] = {
          name = group.block[i].data.name,
          params = table.copy(group.block[i].data.params),
          comment = group.block[i].data.comment,
          type = group.block[i].data.type
        }
        activity.genBlock(i + count)

        if not inList then
          group.block[i + count].x = group.block[i + count].x + 20
          group.block[i + count].text.x = group.block[i + count].text.x + 20

          if group.block[i + count].data.type == 'formula' then
            group.block[i + count].corner.x = group.block[i + count].corner.x + 20
          end

          if group.block[i + count].params then
            for p = 1, #group.block[i + count].params do
              group.block[i + count].params[p].name.x = group.block[i + count].params[p].name.x + 20
              group.block[i + count].params[p].line.x = group.block[i + count].params[p].line.x + 20
              group.block[i + count].params[p].text.x = group.block[i + count].params[p].text.x + 20
            end
          end
        end
      else break end
    end

    for i = 1, #group.block do group.block[i].num = i end
    activity.blocksReturnBlock(1, group, 0)
    activity.blocksFileUpdate()
    activity.scrollHeightUpdate()
    group.scroll:setScrollHeight(group.scrollHeight)

    activity.blocksMove(group.block[j], 'move', group)
  end
end

activity.onClickButton.blocks[4] = function(inList)
  local group = activity.blocks[activity.objects.name]

  for i = #group.block, 1, -1 do
    if group.block[i].checkbox.isOn then
      local data = group.block[i].data
      local comment = data.comment == 'true' and 'false' or 'true'

      if group.block[i].parentIndex then
        comment = group.block[group.block[i].parentIndex].data.comment == 'true' and 'false' or 'true'
      end

      activity.blocksDeleteBlock(group.block[i], group.block[i].num, group)

      group.data[i] = {
        name = data.name,
        params = data.params,
        comment = comment,
        type = data.type
      }
      activity.genBlock(i)

      if not inList then
        group.block[i].x = group.block[i].x + 20
        group.block[i].text.x = group.block[i].text.x + 20

        if group.block[i].data.type == 'formula' then
          group.block[i].corner.x = group.block[i].corner.x + 20
        end

        if group.block[i].params then
          for p = 1, #group.block[i].params do
            group.block[i].params[p].name.x = group.block[i].params[p].name.x + 20
            group.block[i].params[p].line.x = group.block[i].params[p].line.x + 20
            group.block[i].params[p].text.x = group.block[i].params[p].text.x + 20
          end
        end
      end
    end
  end

  for i = 1, #group.block do group.block[i].num = i end
  activity.blocksReturnBlock(1, group, 0)
  activity.blocksFileUpdate()
  activity.scrollHeightUpdate()
  group.scroll:setScrollHeight(group.scrollHeight)
end

activity.onClickButton.blocks[5] = function()
  alert('Раздел недоступен', 'Данный раздел будет доступен лишь в самом конце, так как писать документацию к блокам - это 2-3 полноценных дня работы', {'Закрыть'}, function() end)
end
