activity.editor = {}

-- Активити группа
activity.editor.group = display.newGroup()

-- Фон активити
activity.editor.bg = display.newRect(_x, _y, _aW, _aH)
activity.editor.bg:setFillColor(0.15, 0.15, 0.17)

-- Обработчик нажатия на кнопку 'Назад' на телефоне
activity.editor.onKeyEvent = function(event)
  if activity.editor.group.isVisible then
    if (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and event.phase == 'up' then
      activity.editor.group.isVisible = false
      activity.editor.undoredo = {}
      activity.editor.undoredoi = 1
      activity.editor.undoredocursor = {}
      activity.editor.targetGroup:removeSelf()
      timer.performWithDelay(1, function()
        activity.returnModule('editor')
        activity.blocks.view()
        activity.blocksFileUpdate()
      end)
      display.getCurrentStage():setFocus(nil)
    end
  end
  return true
end
Runtime:addEventListener('key', activity.editor.onKeyEvent)

local testText = display.newText('test', _x, _y - _aH/2 + 175, 'ubuntu_!bold.ttf', 40)
testText.isVisible = false

-- Скролл для текста
activity.editor.scroll = widget.newScrollView({
  x = _x,
  y = ((_y + _aH/2 - 840 + 200) + (_y - _aH/2 + 400)) / 2,
  width = _aW,
  height = (_y + _aH/2 - 840 + 200) - (_y - _aH/2 + 400),
  hideScrollBar = true,
  horizontalScrollDisabled = true,
  isBounceEnabled = true,
  backgroundColor = {0.11, 0.11, 0.13},
  listener = function(e) return true end
})

-- Необходимые модули для работы редактора
require 'Module.funcButtonsEditor'
require 'Module.genTextEditor'
require 'Module.genBlockEditor'

-- Название активити
activity.editor.title = display.newText(strings.editorTitle, _x - _aW/2 + 16, _y - _aH/2 + 32, 'ubuntu_!bold.ttf', 36)
activity.editor.title.anchorX = 0

-- Кнопка для выпадающего списка
activity.editor.listCopy = {}
activity.editor.list = display.newRoundedRect(_x + _aW/2 - 50, _y - _aH/2 + 37, 80, 60, 10)
activity.editor.list:setFillColor(0.15, 0.15, 0.17)
activity.editor.list.text = display.newText('⋮', _x + _aW/2 - 48, _y - _aH/2 + 32, 'ubuntu_!bold.ttf', 62)

activity.editor.list:addEventListener('touch', function(e)
  if e.phase == 'began' then
    display.getCurrentStage():setFocus(e.target)
    if not alertActive then
      e.target:setFillColor(0.18, 0.18, 0.2)
      e.target.click = true
    end
  elseif e.phase == 'moved' then
    if math.abs(e.y - e.yStart) > 30 or math.abs(e.x - e.xStart) > 60 then
      e.target:setFillColor(0.15, 0.15, 0.17)
      e.target.click = false
    end
  elseif e.phase == 'ended' then
    display.getCurrentStage():setFocus(nil)
    e.target:setFillColor(0.15, 0.15, 0.17)
    if e.target.click then
      e.target.click = false list({strings.paste, strings.copy, strings.removeAll, strings.hideAll, strings.docums},
      {x = e.target.x, y = e.target.y, targetHeight = e.target.height, activeBut = strings.paste}, function(event)
        if event.num == 4 then activity.editor.listScroll:scrollToPosition({y=0,time=0,onComplete=function()end})
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
        elseif event.num == 3 then
          activity.editor.cursor = {table.copy(activity.editor.cursor[1]), {'|', '|'}}
          activity.editor.cursorIndex[1] = 2
          activity.editor.cursorIndex[2] = '|'
          activity.editor.genText()
        elseif event.num == 2 then
          activity.editor.listCopy.cursor = {}
          activity.editor.listCopy.cursorIndex = {
            activity.editor.cursorIndex[1],
            activity.editor.cursorIndex[2]
          } for i = 2, #activity.editor.cursor do activity.editor.listCopy.cursor[i-1] = table.copy(activity.editor.cursor[i]) end
        elseif event.num == 1 and activity.editor.listCopy.cursor then
          local cursorFirstIndex = table.copy(activity.editor.cursor[1])
          activity.editor.cursor = table.copy(activity.editor.listCopy.cursor)
          activity.editor.cursorIndex = table.copy(activity.editor.listCopy.cursorIndex)
          table.insert(activity.editor.cursor, 1, table.copy(cursorFirstIndex))
          activity.editor.genText()
        elseif event.num == 5 then
          alert('В разработке', 'Я не супермен и работаю один, на мне висит допиливание ресурсов, подключение всех модулей для сборки в апк, редактор уровней, документация ко всем блоками и только потом буду писать документацию к редактору выражения', {strings.notexportok}, function(e) end)
        end
      end)
    end
  end return true
end)

-- Кнопки undo и redo
activity.editor.undoredo = {}
activity.editor.undoredoi = 1
activity.editor.undoredocursor = {}
activity.editor.undo = display.newRoundedRect(_x + _aW/2 - 250, _y - _aH/2 + 37, 80, 60, 10)
activity.editor.undo:setFillColor(0.15, 0.15, 0.17)
activity.editor.redo = display.newRoundedRect(_x + _aW/2 - 150, _y - _aH/2 + 37, 80, 60, 10)
activity.editor.redo:setFillColor(0.15, 0.15, 0.17)
activity.editor.undo.text = display.newText('⤺', _x + _aW/2 - 250, _y - _aH/2 + 22, 'ubuntu_!bold.ttf', 100)
activity.editor.redo.text = display.newText('⤺', _x + _aW/2 - 150, _y - _aH/2 + 22, 'ubuntu_!bold.ttf', 100)
activity.editor.redo.text.xScale = -1

local undoredo = function(e, type)
  if e.phase == 'began' then
    display.getCurrentStage():setFocus(e.target)
    if not alertActive then
      e.target:setFillColor(0.18, 0.18, 0.2)
      e.target.click = true
    end
  elseif e.phase == 'moved' then
    if math.abs(e.y - e.yStart) > 30 or math.abs(e.x - e.xStart) > 60 then
      e.target:setFillColor(0.15, 0.15, 0.17)
      e.target.click = false
    end
  elseif e.phase == 'ended' then
    display.getCurrentStage():setFocus(nil)
    e.target:setFillColor(0.15, 0.15, 0.17)
    if e.target.click then
      e.target.click = false
      if type == 'undo' then
        if activity.editor.undoredoi > 1 then
          activity.editor.undoredoi = activity.editor.undoredoi - 1
          activity.editor.cursor = table.copy(activity.editor.undoredo[activity.editor.undoredoi])
          activity.editor.cursorIndex = table.copy(activity.editor.undoredocursor[activity.editor.undoredoi])
          activity.editor.genText(true)
        end
      elseif type == 'redo' then
        if activity.editor.undoredoi < #activity.editor.undoredo then
          activity.editor.undoredoi = activity.editor.undoredoi + 1
          activity.editor.cursor = table.copy(activity.editor.undoredo[activity.editor.undoredoi])
          activity.editor.cursorIndex = table.copy(activity.editor.undoredocursor[activity.editor.undoredoi])
          activity.editor.genText(true)
        end
      end
    end
  end return true
end

activity.editor.undo:addEventListener('touch', function(e) undoredo(e, 'undo') return true end)
activity.editor.redo:addEventListener('touch', function(e) undoredo(e, 'redo') return true end)

-- Добавление графических элементов в активити группу
activity.editor.group:insert(activity.editor.bg)
activity.editor.group:insert(activity.editor.scroll)
activity.editor.group:insert(activity.editor.title)
activity.editor.group:insert(activity.editor.list)
activity.editor.group:insert(activity.editor.undo)
activity.editor.group:insert(activity.editor.redo)
activity.editor.group:insert(activity.editor.list.text)
activity.editor.group:insert(activity.editor.undo.text)
activity.editor.group:insert(activity.editor.redo.text)

-- Основные кнопки
activity.editor.buttons = {}

local buttonsX = _x - _aW/2 + 46
local buttonsY = _y + _aH/2 - 565

local editorGetFontSize = function(i)
  if i == 1 or i == 2 then return 24
  else return 36 end
end

local editorGetText = function(i)
  if i == 1 then return strings.editorInputText end
  if i == 2 then return strings.editorInputLocal end
  if i == 3 then return '(' end
  if i == 4 then return ')' end
  if i == 5 then return 1 end
  if i == 6 then return 2 end
  if i == 7 then return 3 end
  if i == 8 then return '+' end
  if i == 9 then return 4 end
  if i == 10 then return 5 end
  if i == 11 then return 6 end
  if i == 12 then return '-' end
  if i == 13 then return 7 end
  if i == 14 then return 8 end
  if i == 15 then return 9 end
  if i == 16 then return '*' end
  if i == 17 then return '.' end
  if i == 18 then return 0 end
  if i == 19 then return '=' end
  if i == 20 then return '/' end
  if i == 21 then return 'C' end
  if i == 22 then return '<-' end
  if i == 23 then return '->' end
  if i == 24 then return strings.buttonInput end
end

for i = 1, 24 do
  activity.editor.buttons[i] = display.newRoundedRect(buttonsX, buttonsY, 90, 90, 10)
  activity.editor.buttons[i]:setFillColor(0.15, 0.15, 0.17)
  activity.editor.buttons[i].text = display.newText(editorGetText(i), activity.editor.buttons[i].x, activity.editor.buttons[i].y, 'ubuntu_!bold.ttf', editorGetFontSize(i))
  activity.editor.buttons[i].text.id = activity.editor.buttons[i].text.text
  if i == 24 then activity.editor.buttons[i].text.id = 'ok'
  elseif i == 1 then activity.editor.buttons[i].text.id = 'text'
  elseif i == 2 then activity.editor.buttons[i].text.id = 'local' end
  buttonsX = i % 4 == 0 and _x - _aW/2 + 46 or buttonsX + 100
  buttonsY = i % 4 == 0 and buttonsY + 100 or buttonsY
  activity.editor.group:insert(activity.editor.buttons[i])
  activity.editor.group:insert(activity.editor.buttons[i].text)

  activity.editor.buttons[i]:addEventListener('touch', function(e)
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
      if not alertActive then
        e.target:setFillColor(0.18, 0.18, 0.2)
        e.target.click = true
        if e.target.text.id == '<-' then
          e.target.timer = timer.performWithDelay(700, function()
            if e.target.click then
              activity.editor.cursorIndex[2] = '|'
              timer.performWithDelay(50, function(event)
                if e.target.click then
                  if activity.editor.cursorIndex[1] > 2 then
                    table.insert(activity.editor.cursor, activity.editor.cursorIndex[1] - 1, {'|', '|'})
                    table.remove(activity.editor.cursor, activity.editor.cursorIndex[1] + 1)
                    activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] - 1
                    activity.editor.cursorIndex[2] = '|'
                    activity.editor.genText()
                  else timer.cancel(event.source) end
                else timer.cancel(event.source) end
              end, 0)
            end
          end)
        elseif e.target.text.id == '->' then
          e.target.timer = timer.performWithDelay(700, function()
            if e.target.click then
              activity.editor.cursorIndex[2] = '|'
              activity.editor.genText()
              timer.performWithDelay(50, function(event)
                if e.target.click then
                  if activity.editor.cursorIndex[1] < #activity.editor.cursor then
                    table.insert(activity.editor.cursor, activity.editor.cursorIndex[1] + 2, {'|', '|'})
                    table.remove(activity.editor.cursor, activity.editor.cursorIndex[1])
                    activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] + 1
                    activity.editor.cursorIndex[2] = '|'
                    activity.editor.genText()
                  else timer.cancel(event.source) end
                else timer.cancel(event.source) end
              end, 0)
            end
          end)
        elseif e.target.text.id == 'C' then
          e.target.timer = timer.performWithDelay(700, function()
            if e.target.click then
              timer.performWithDelay(50, function(event)
                if e.target.click then
                  if activity.editor.cursorIndex[1] > 2 then
                    table.remove(activity.editor.cursor, activity.editor.cursorIndex[1] - 1)
                    activity.editor.cursorIndex[1] = activity.editor.cursorIndex[1] - 1
                    activity.editor.cursorIndex[2] = '|'
                    activity.editor.genText()
                  else timer.cancel(event.source) end
                else timer.cancel(event.source) end
              end, 0)
            end
          end)
        end
      end
    elseif e.phase == 'moved' then
      if math.abs(e.y - e.yStart) > 30 or math.abs(e.x - e.xStart) > 60 then
        display.getCurrentStage():setFocus(nil)
        e.target:setFillColor(0.15, 0.15, 0.17)
        e.target.click = false
      end
    elseif e.phase == 'ended' then
      display.getCurrentStage():setFocus(nil)
      e.target:setFillColor(0.15, 0.15, 0.17)
      if e.target.click then
        e.target.click = false
        testText.text = e.target.text.id
        activity.editor.funcButtons(e.target.text.id)
        pcall(function() timer.cancel(e.target.timer) end)
      end
    end return true
  end)
end

-- Скролл для списка
activity.editor.listScroll = widget.newScrollView({
  x = ((_x + _aW / 2 - 10) + (activity.editor.buttons[4].x + activity.editor.buttons[4].width / 2 + 10)) / 2,
  y = (activity.editor.buttons[12].y + activity.editor.buttons[13].y) / 2,
  width = (_x + _aW / 2 - 10) - (activity.editor.buttons[4].x + activity.editor.buttons[4].width / 2 + 10),
  height = 590,
  hideScrollBar = true,
  horizontalScrollDisabled = true,
  isBounceEnabled = true,
  backgroundColor = {0.15, 0.15, 0.17},
  listener = function(e) return true end
})
activity.editor.group:insert(activity.editor.listScroll)

editorGetListTitle = function(i)
  if i == 1 then return strings.editorVar, 'var' end
  if i == 2 then return strings.editorTable, 'table' end
  if i == 3 then return strings.editorFun, 'fun' end
  if i == 4 then return strings.editorProp, 'prop' end
  if i == 5 then return strings.editorLog, 'log' end
  if i == 6 then return strings.editorObj, 'obj' end
  if i == 7 then return strings.editorDevice, 'device' end
end

activity.editor.listTitle = {}
activity.editor.listItem = {}
activity.editor.listScrollHeight = 490

local editorGetListItem = function(id, i, isOpen)
  if strings.editorList[id] then
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
  end

  if isOpen and strings.editorList[id] then
    local buttonsX = activity.editor.listScroll.width / 2
    local buttonsY = activity.editor.listTitle[i].y + 70
    activity.editor.listItem[id] = {}

    for i = 1, #strings.editorList[id] do
      activity.editor.listItem[id][i] = display.newRect( buttonsX, buttonsY, activity.editor.listScroll.width, 70)
      activity.editor.listItem[id][i]:setFillColor(0.14, 0.14, 0.16)

      activity.editor.listItem[id][i].text = display.newText(strings.editorList[id][i][1], 20, buttonsY, 'ubuntu_!bold.ttf', 22)
      activity.editor.listItem[id][i].text.id = strings.editorList[id][i][2]
      activity.editor.listItem[id][i].text.ID = id
      activity.editor.listItem[id][i].text.anchorX = 0

      buttonsY = buttonsY + 70
      activity.editor.listScroll:insert(activity.editor.listItem[id][i])
      activity.editor.listScroll:insert(activity.editor.listItem[id][i].text)

      activity.editor.listItem[id][i]:addEventListener('touch', function(e)
        if e.phase == 'began' then
          display.getCurrentStage():setFocus(e.target)
          if not alertActive then
            e.target:setFillColor(0.16, 0.16, 0.18)
            e.target.click = true
          end
        elseif e.phase == 'moved' then
          if math.abs(e.y - e.yStart) > 30 or math.abs(e.x - e.xStart) > 60 then
            activity.editor.listScroll:takeFocus(e)
            e.target:setFillColor(0.14, 0.14, 0.16)
            e.target.click = false
          end
        elseif e.phase == 'ended' then
          display.getCurrentStage():setFocus(nil)
          e.target:setFillColor(0.14, 0.14, 0.16)
          if e.target.click then
            e.target.click = false
            testText.text = e.target.text.id .. ' ' .. e.target.text.ID
            activity.editor.funcList(e.target.text.id, e.target.text.ID)
          end
        end
        return true
      end)
    end

    activity.editor.listScrollHeight = activity.editor.listScrollHeight + #strings.editorList[id] * 70
    activity.editor.listScroll:setScrollHeight(activity.editor.listScrollHeight)
  elseif strings.editorList[id] then
    activity.editor.listScrollHeight = activity.editor.listScrollHeight - #activity.editor.listItem[id] * 70

    for i = 1, #activity.editor.listItem[id] do
      activity.editor.listItem[id][i].text:removeSelf()
      activity.editor.listItem[id][i]:removeSelf()
    end

    activity.editor.listItem[id] = nil
    activity.editor.listScroll:setScrollHeight(activity.editor.listScrollHeight)
  end
end

local buttonsX = activity.editor.listScroll.width / 2
local buttonsY = 35

for i = 1, 7 do
  activity.editor.listTitle[i] = display.newRect(buttonsX, buttonsY, activity.editor.listScroll.width, 70)
  activity.editor.listTitle[i]:setFillColor(0.11, 0.11, 0.13)
  activity.editor.listTitle[i].isOpen = false

  activity.editor.listTitle[i].text = display.newText(select(1, editorGetListTitle(i)), 20, buttonsY, 'ubuntu_!bold.ttf', 28)
  activity.editor.listTitle[i].text.id = select(2, editorGetListTitle(i))
  activity.editor.listTitle[i].text.anchorX = 0

  activity.editor.listTitle[i].isOpenPolygon = display.newPolygon(activity.editor.listScroll.width - 30, buttonsY, {0, 0, 10, 10, -10, 10})

  buttonsY = buttonsY + 70
  activity.editor.listScroll:insert(activity.editor.listTitle[i])
  activity.editor.listScroll:insert(activity.editor.listTitle[i].text)
  activity.editor.listScroll:insert(activity.editor.listTitle[i].isOpenPolygon)

  activity.editor.listTitle[i]:addEventListener('touch', function(e)
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
      if not alertActive then
        e.target.click = true
      end
    elseif e.phase == 'moved' then
      if math.abs(e.y - e.yStart) > 30 or math.abs(e.x - e.xStart) > 60 then
        activity.editor.listScroll:takeFocus(e)
        e.target.click = false
      end
    elseif e.phase == 'ended' then
      display.getCurrentStage():setFocus(nil)
      if e.target.click then
        e.target.click = false
        e.target.isOpen = not e.target.isOpen
        activity.editor.listTitle[i].isOpenPolygon.rotation = (e.target.isOpen == true and strings.editorList[e.target.text.id]) and 180 or 0
        editorGetListItem(e.target.text.id, i, e.target.isOpen)
      end
    end
    return true
  end)
end
