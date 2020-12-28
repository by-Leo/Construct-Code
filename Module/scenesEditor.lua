scenesEditor = {}

-- Модуль 'Редактор сцен'
scenesEditor.lib = display.newGroup()

scenesEditor.orientation = {width=540, height=960}

scenesEditor.canvas = display.newRect(scenesEditor.lib, _x, _y, scenesEditor.orientation.width, scenesEditor.orientation.height)

local function onKeyEventScenesEditor( event )
  if (event.keyName == "back" or event.keyName == "escape") and not alertActive and event.phase == 'up' and scenesEditor.lib.isVisible then
    -- scenes.view()
    display.getCurrentStage():setFocus(nil)
  end
  return true
end
Runtime:addEventListener('key', onKeyEventScenesEditor)
