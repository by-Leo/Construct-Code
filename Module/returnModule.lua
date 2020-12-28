activity.returnModule = function(types, names)
  if types == 'editor' then
    activity.editor.scroll:scrollTo('top',{time=0,onComplete=function()end})
    activity.editor.listScroll:scrollTo('top',{time=0,onComplete=function()end})
    for i = 1, 24 do
      activity.editor.buttons[i]:setFillColor(0.15, 0.15, 0.17)
      activity.editor.buttons[i].click = false
    end
    for i = 1, 7 do
      local id = select(2, editorGetListTitle(i))
      activity.editor.listTitle[i].click = false
      activity.editor.listTitle[i].isOpen = false
      activity.editor.listTitle[i].isOpenPolygon.rotation = 0
      if activity.editor.listItem[id] then
        for j = i + 1, 7 do
          activity.editor.listTitle[j].y = isOpen == true
          and activity.editor.listTitle[j].y + 70 * #strings.editorList[id]
          or activity.editor.listTitle[j].y - 70 * #strings.editorList[id]
          activity.editor.listTitle[j].text.y = activity.editor.listTitle[j].y
          activity.editor.listTitle[j].isOpenPolygon.y = activity.editor.listTitle[j].y
          if activity.editor.listItem[activity.editor.listTitle[j].text.id] and activity.editor.listTitle[j].text.id ~= id then
            for i = 1, #activity.editor.listItem[activity.editor.listTitle[j].text.id] do
              activity.editor.listItem[activity.editor.listTitle[j].text.id][i].y = isOpen == true
              and activity.editor.listItem[activity.editor.listTitle[j].text.id][i].y + 70 * #strings.editorList[id]
              or activity.editor.listItem[activity.editor.listTitle[j].text.id][i].y - 70 * #strings.editorList[id]
              activity.editor.listItem[activity.editor.listTitle[j].text.id][i].text.y = activity.editor.listItem[activity.editor.listTitle[j].text.id][i].y
            end
          end
        end
        activity.editor.listScrollHeight = activity.editor.listScrollHeight - #activity.editor.listItem[id] * 70
        for j = 1, #activity.editor.listItem[id] do
          activity.editor.listItem[id][j].text:removeSelf()
          activity.editor.listItem[id][j]:removeSelf()
        end
        activity.editor.listItem[id] = nil
        activity.editor.listScroll:setScrollHeight(activity.editor.listScrollHeight)
      end
    end
  else
    for i = 1, #activity[types][names].block do
      if activity[types][names].block[i].alpha < 0.85 then
        activity[types][names].block[i]:setFillColor(25/255, 26/255, 32/255)
        activity[types][names].block[i].alpha = 0.9
        if types == 'objects' or types == 'textures' then activity[types][names].block[i].container.alpha = 1 end
      end
      if types == 'blocks' then
        for j = 1, #activity[types][names].block[i].params do
          if activity[types][names].block[i].params[j].rect.alpha > 0.1 then
            activity[types][names].block[i].params[j].rect:setFillColor(1)
            activity[types][names].block[i].params[j].rect.alpha = 0.005
          end
        end
      end
    end
    activity[types][names].scroll:scrollTo('top',{time=0,onComplete=function()end})
    activity[types].add.width, activity[types].add.height, activity[types].add.alpha = 306, 107, 0.9
    activity[types].okay.width, activity[types].okay.height, activity[types].okay.alpha = 306, 107, 0.9
    activity[types].list.width, activity[types].list.height, activity[types].list.alpha = 103.2, 84, 1
    if types == 'programs' then activity[types].import.width, activity[types].import.height, activity[types].import.alpha = 306, 107, 0.9
    else activity[types].play.width, activity[types].play.height, activity[types].play.alpha = 306, 107, 0.9 end
  end
end
