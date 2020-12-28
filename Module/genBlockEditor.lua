activity.editor.genBlock = function()
  local group = activity.blocks[activity.objects.name]
  local num = activity.editor.cursor[1][1]
  activity.editor.targetGroup = display.newGroup()

  activity.editor.target = display.newImage(activity.editor.targetGroup, group.block[num].path, _x, _y - _aY + 230)
  activity.editor.target.width = 664
  activity.editor.target.height = group.block[num].height

  activity.editor.target.text = display.newText({
    text = strings.blocks[group.block[num].data.name][1], align = 'left', height = 40 , parent = activity.editor.targetGroup,
    x = _x - 10, y = _y - _aY + 230 + group.block[num].text.additionY, font = 'ubuntu', fontSize = 32, width = 600
  })

  if group.block[num].data.type == 'formula' then
    activity.editor.target.corner = display.newImage(activity.editor.targetGroup, 'Image/' .. group.block[num].cornerType .. '.png', _x, _y - _aY + 230)
    activity.editor.target.corner.width = 664
  end

  activity.editor.target.params = {}

  for j = 1, #group.block[num].params do
    activity.editor.target.params[j] = {}

    activity.editor.target.params[j].name = display.newText({
      parent = activity.editor.targetGroup, text = group.block[num].params[j].name.text, align = 'left', height = group.block[num].params[j].name.height,
      x = _x + group.block[num].params[j].name.additionX, y = _y - _aY + 230 + group.block[num].params[j].name.additionY, font = 'ubuntu_!bold.ttf', fontSize = 22, width = 150
    })

    activity.editor.target.params[j].line = display.newRect(activity.editor.targetGroup, _x + group.block[num].params[j].line.additionX, _y - _aY + 230 + group.block[num].params[j].line.additionY, group.block[num].params[j].line.width, 3)
    activity.editor.target.params[j].line:setFillColor(84/255,84/255,84/255)

    activity.editor.target.params[j].rect = display.newRect(activity.editor.targetGroup, _x + group.block[num].params[j].line.additionX, _y - _aY + 230 + group.block[num].params[j].line.additionY - 21.5, group.block[num].params[j].line.width, 40)
    activity.editor.target.params[j].rect:setFillColor(1, 0.005)
    activity.editor.target.params[j].rect.num = j

    activity.editor.target.params[j].rect:addEventListener('touch', function(e)
      if not alertActive and activity.editor.group.isVisible then
        if e.phase == 'began' then
          display.getCurrentStage():setFocus(e.target)
          e.target:setFillColor(0.8, 0.8, 1, 0.2)
          e.target.click = true
        elseif e.phase == 'moved' then
          local dy = math.abs(e.y - e.yStart)
          if dy > 20 then
            display.getCurrentStage():setFocus(nil)
            e.target:setFillColor(1, 0.005)
            e.target.click = false
          end
        elseif e.phase == 'ended' then
          display.getCurrentStage():setFocus(nil)
          e.target:setFillColor(1, 0.005)
          if e.target.click then
            if e.target.num ~= activity.editor.cursor[1][2] and activity.paramsFormulas[activity.blocks[activity.objects.name].block[activity.editor.cursor[1][1]].data.name][e.target.num] == 'value' then
              for i2 = 2, #activity.editor.cursor do
                if activity.editor.cursor[i2][2] == '|' then
                  table.remove(activity.editor.cursor, i2)
                  for j2 = 2, #activity.editor.cursor do
                    if activity.editor.cursor[j2] and activity.editor.cursor[j2][2] == 'num' then
                      for k = j2 + 1, #activity.editor.cursor do
                        if not (activity.editor.cursor[k][2] == 'num' or (activity.editor.cursor[k][2] == 'sym' and activity.editor.cursor[k][1] == '.')) then
                          for n = j2 + 1, k - 1 do
                            activity.editor.cursor[j2][1] = activity.editor.cursor[j2][1] .. activity.editor.cursor[j2 + 1][1]
                            table.remove(activity.editor.cursor, j2 + 1)
                          end
                          break
                        elseif k == #activity.editor.cursor then
                          for n = j2 + 1, k do
                            activity.editor.cursor[j2][1] = activity.editor.cursor[j2][1] .. activity.editor.cursor[j2 + 1][1]
                            table.remove(activity.editor.cursor, j2 + 1)
                          end
                          break
                        end
                      end
                    end
                  end
                  break
                end
              end
              local k = activity.editor.cursor[1][1]
              local n = activity.editor.cursor[1][2]
              table.remove(activity.editor.cursor, 1)
              activity.blocks[activity.objects.name].block[k].data.params[n] = table.copy(activity.editor.cursor)
              activity.blocks[activity.objects.name].block[k].params[n].text.text = getTextParams(k, n)
              activity.editor.undoredo = {}
              activity.editor.undoredoi = 1
              activity.editor.targetGroup:removeSelf()
              activity.blocksFileUpdate()
              activity.editor.undoredo = {}
              activity.editor.undoredoi = 1
              activity.editor.table = {{k, e.target.num}}
              for u = 1, #group.block[k].data.params[e.target.num] do
                activity.editor.table[#activity.editor.table+1] = table.copy(group.block[k].data.params[e.target.num][u])
              end
              activity.editor.newText()
              activity.editor.genBlock()
            end
          end
        end
      end
      return true
    end)

    activity.editor.target.params[j].text = display.newText({
      parent = activity.editor.targetGroup, text = group.block[num].params[j].text.text, align = 'center', height = group.block[num].params[j].text.height,
      x = _x + group.block[num].params[j].text.additionX, y = _y - _aY + 230 + group.block[num].params[j].text.additionY, font = 'ubuntu_!bold.ttf', fontSize = 20, width = group.block[num].params[j].text.width
    })
  end
end
