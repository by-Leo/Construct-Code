local library = require 'plugin.cnkFileManager'
local utf8 = require 'plugin.utf8'
local widget = require 'widget'
local lfs = require 'lfs'
local json = require 'json'
local physics = require 'physics'
local crypto = require 'crypto'
local socket = require 'socket'
local orientation = require 'plugin.orientation'

local _x = display.contentCenterX
local _y = display.contentCenterY
local _w = display.contentWidth
local _h = display.contentHeight
local _tH = system.getInfo 'environment' ~= 'simulator' and display.topStatusBarContentHeight or 0
local _bH = display.actualContentHeight - display.safeActualContentHeight
local _aW = display.actualContentWidth
local _aH = display.actualContentHeight - _bH - _tH
local _aX = _aW / 2
local _aY = _aH / 2

onParseBlock = function(indexScene, indexObject, params, localtable)
  local nestedNoEnd = 'setLinkTexture createTextField createTextBox inputText setTransitionHeight '
  nestedNoEnd = nestedNoEnd .. 'setTransitionPos setTransitionPosX setTransitionPosY setTransitionWidth '
  nestedNoEnd = nestedNoEnd .. 'setTransitionSize setTransitionRotation setTransitionAlpha setTransitionPosAngle '
  nestedNoEnd = nestedNoEnd .. 'putFirebase patchFirebase getFirebase deleteFirebase '
  nestedNoEnd = nestedNoEnd .. 'setGet setPost setPut setPatch setDelete createLinkVideo '
  nestedNoEnd = nestedNoEnd .. 'setTransitionPosShape setTransitionPosXShape setTransitionPosYShape '
  nestedNoEnd = nestedNoEnd .. 'setTransitionWidthShape setTransitionHeightShape setTransitionSizeShape '
  nestedNoEnd = nestedNoEnd .. 'setTransitionRotationShape setTransitionAlphaShape setTransitionPosAngleShape '
  nestedNoEnd = nestedNoEnd .. 'setTransitionPosTag setTransitionPosXTag setTransitionPosYTag setTransitionAlphaTag '
  local nestedNames = 'if ifElse for while forI forT enterFrame useTag useCopy fileLine timer '
  local nested, nestedIndex, nestedActive = false, 0, '' for i = 1, #params do if not nested then
  if utf8.find(nestedNames .. nestedNoEnd, params[i].name .. ' ') then nested, nestedIndex = true, 1 end
  if utf8.find(nestedNoEnd, params[i].name .. ' ') then nested = 0 end nestedActive = params[i].name
  if frm[params[i].name] and game.scene == indexScene then pcall(function()
  frm[params[i].name](indexScene, indexObject, table.copy(params[i].params), localtable, table.copy(params), i) end) end
  else if utf8.find(nestedNames, params[i].name .. ' ') then nestedIndex = nestedIndex + 1
  elseif utf8.sub(params[i].name, utf8.len(params[i].name)-2, utf8.len(params[i].name)) == 'End'
  then nestedIndex = nestedIndex - 1 if (nestedIndex == 0 and (not utf8.find(nestedNoEnd, nestedActive .. ' ')))
  or (utf8.find(nestedNoEnd, nestedActive .. ' ') and nestedIndex == -1) then nested = false end end end end
end

onFun = function(indexScene, indexObject, params, localtable) pcall(function()
  for i = 1, #params do
    if params[i].comment == 'true' then
      table.remove(params, i)
    end
  end onParseBlock(indexScene, indexObject, table.copy(params), table.copy(localtable))
end) end

genOnFun = function() pcall(function()
  for s = 1, #gameData do
    local scene = gameData[s]
    for o = 1, #scene.objects do
      local object = scene.objects[o]
      for e = 1, #object.events do
        local event = object.events[e]
        if event.name == 'onFun' then
          game.funs[#game.funs + 1] = {
            func = function(target) if target.indexScene == game.scene then
              onFun(target.indexScene, target.indexObject, table.copy(target.params), table.copy(target.localtable))
            end end, name = event.params[1][1] and event.params[1][1][1] or '',
            call = false, localtable = {}, indexScene = s, indexObject = o, params = table.copy(event.formulas)
          }
        elseif event.name == 'onBack' then game.back = true
        elseif event.name == 'onCondition' then
          local cond, counttimer = {
            value = table.copy(event.params[1]), indexScene = s,
            indexObject = o, params = table.copy(event.formulas)
          }, #game.timers + 1
          game.timers[counttimer] = timer.performWithDelay(1, function() pcall(function()
            if cond.indexScene == game.scene then
              local value = calc(cond.indexScene, cond.indexObject, table.copy(cond.value), {})
              if value[2] == 'log' and value[1] == 'true' then timer.cancel(game.timers[counttimer])
                onParseBlock(cond.indexScene, cond.indexObject, table.copy(cond.params), {})
              end
            end
          end) end, 0)
        elseif event.name == 'onConditionWhile' then
          local cond = {
            value = table.copy(event.params[1]), indexScene = s,
            indexObject = o, params = table.copy(event.formulas)
          } game.timers[#game.timers + 1] = timer.performWithDelay(1, function() pcall(function()
            if cond.indexScene == game.scene then
              local value = calc(cond.indexScene, cond.indexObject, table.copy(cond.value), {})
              if value[2] == 'log' and value[1] == 'true' then
                onParseBlock(cond.indexScene, cond.indexObject, table.copy(cond.params), {})
              end
            end
          end) end, 0)
        end
      end
    end
  end end)

  game.timers[#game.timers + 1] = timer.performWithDelay(1, function() pcall(function()
    if game.scene ~= 0 then game._fps = game._fps + 1 end
    if game.clicks > 0 then
      if game.displayclick then onClickDisplayMove()
      else game.displayclick = true onClickDisplay() end
    else game.displayclick = false onClickDisplayEnd() end
  end) end, 0)

  game.timers[#game.timers + 1] = timer.performWithDelay(1000, function() pcall(function()
    if game.scene ~= 0 then game.fps, game._fps = game._fps < 61 and game._fps or 60, 0 end
  end) end, 0)

  game.onCollision = function(event) pcall(function()
    if event.phase == 'began' and event.object1.data.scene == game.scene
    and event.object2.data.scene == game.scene then onCollisionStart(event)
    elseif event.phase == 'ended' and event.object1.data.scene == game.scene
    and event.object2.data.scene == game.scene then onCollisionEnd(event) end
  end) end

  game.onSystem = function(event) pcall(function()
    if event.type == 'applicationSuspend' then onHide()
    elseif event.type == 'applicationResume' then onView() end
  end) end

  game.onKey = function(event) pcall(function()
    if game.back and projectActive and (event.keyName == 'back' or event.keyName == 'escape')
    and event.phase == 'up' then onBack() end
  end) return true end

  game.onClickScreen = function(event) pcall(function()
    if event.x and event.y then
      game.touch_x, game.touch_y = event.x, event.y
      if game.taps[tostring(event.id)] then
        game.taps[tostring(event.id)].x = event.x
        game.taps[tostring(event.id)].y = event.y
    end end if event.phase == 'began' then
      game.clicks = game.clicks + 1
      game.count_taps = game.count_taps + 1
      game.taps[tostring(event.id)] = {x = event.x, y = event.y, id = game.count_taps}
      display.getCurrentStage():setFocus(event.target)
    elseif event.phase == 'ended' or event.phase == 'cancelled' then
      game.clicks = game.clicks - 1
      display.getCurrentStage():setFocus(nil)
    end
  end) end

  Runtime:addEventListener('key', game.onKey)
  Runtime:addEventListener('system', game.onSystem)
  Runtime:addEventListener('collision', game.onCollision)
  game.debugbackground:addEventListener('touch', game.onClickScreen)
end

onClickDisplayMove = function() pcall(function()
  local objects = gameData[game.scene].objects
  for o = 1, #objects do
    for e = 1, #objects[o].events do
      if objects[o].events[e].name == 'onClickDisplayMove' then
        onParseBlock(game.scene, o, table.copy(objects[o].events[e].formulas), {{
          ['x'] = {tostring(game.touch_x - game.x), 'num'},
          ['y'] = {tostring(game.y - game.touch_y), 'num'}
        }})
      end
    end
  end
end) end

onClickDisplayEnd = function() pcall(function()
  local objects = gameData[game.scene].objects
  for o = 1, #objects do
    for e = 1, #objects[o].events do
      if objects[o].events[e].name == 'onClickDisplayEnd' then
        onParseBlock(game.scene, o, table.copy(objects[o].events[e].formulas), {{
          ['x'] = {tostring(game.touch_x - game.x), 'num'},
          ['y'] = {tostring(game.y - game.touch_y), 'num'}
        }})
      end
    end
  end
end) end

onClickDisplay = function() pcall(function()
  local objects = gameData[game.scene].objects
  for o = 1, #objects do
    for e = 1, #objects[o].events do
      if objects[o].events[e].name == 'onClickDisplay' then
        onParseBlock(game.scene, o, table.copy(objects[o].events[e].formulas), {{
          ['x'] = {tostring(game.touch_x - game.x), 'num'},
          ['y'] = {tostring(game.y - game.touch_y), 'num'}
        }})
      end
    end
  end
end) end

onBack = function() pcall(function()
  local objects = gameData[game.scene].objects
  for o = 1, #objects do
    for e = 1, #objects[o].events do
      if objects[o].events[e].name == 'onBack' then
        onParseBlock(game.scene, o, table.copy(objects[o].events[e].formulas), {})
      end
    end
  end
end) end

onHide = function() pcall(function()
  local objects = gameData[game.scene].objects
  for o = 1, #objects do
    for e = 1, #objects[o].events do
      if objects[o].events[e].name == 'onHide' then
        onParseBlock(game.scene, o, table.copy(objects[o].events[e].formulas), {})
      end
    end
  end
end) end

onView = function() pcall(function()
  for i in pairs(game.shapes) do
    pcall(function()
      if game.shapes[i].data.sn then
        game.group:insert(game.shapes[i])
        game.snapshot.canvas:insert(game.shapes[i])
        game.snapshot:invalidate 'canvas'
      end
    end)
  end local objects = gameData[game.scene].objects
  for o = 1, #objects do
    for e = 1, #objects[o].events do
      if objects[o].events[e].name == 'onView' then
        onParseBlock(game.scene, o, table.copy(objects[o].events[e].formulas), {})
      end
    end
  end
end) end

onCollisionStart = function(event) pcall(function()
  if event.object1.data.lis then
    local indexObject, nameShape = event.object1.data.index, '' if indexObject == 0
    then nameShape, indexObject = event.object1.data.name, event.object1.data.obj_id end
    local object = gameData[game.scene].objects[indexObject]
    for e = 1, #object.events do
      if object.events[e].name == 'onCollisionStart' then local object, e = object, e
        timer.performWithDelay(1, function() if game.scene == event.object1.data.scene then
          onParseBlock(game.scene, indexObject, table.copy(object.events[e].formulas), {{
            ['self_id'] = {tostring(event.element1), 'num'},
            ['other_id'] = {tostring(event.element2), 'num'},
            ['self_name'] = {tostring(event.object1.name or event.object1.data.name), 'text'},
            ['other_name'] = {tostring(event.object2.name or event.object2.data.name), 'text'},
            ['self_tag'] = {tostring(event.object1.data.tag), 'text'},
            ['other_tag'] = {tostring(event.object2.data.tag), 'text'},
            ['self_isShape'] = {tostring(event.object1.data.index == 0), 'log'},
            ['other_isShape'] = {tostring(event.object2.data.index == 0), 'log'}
          }})
        end end)
      end
    end
  end if event.object2.data.lis then
    local indexObject, nameShape = event.object2.data.index, '' if indexObject == 0
    then nameShape, indexObject = event.object2.data.name, event.object2.data.obj_id end
    local object = gameData[game.scene].objects[indexObject]
    for e = 1, #object.events do
      if object.events[e].name == 'onCollisionStart' then local object, e = object, e
        timer.performWithDelay(1, function() if game.scene == event.object2.data.scene then
          onParseBlock(game.scene, indexObject, table.copy(object.events[e].formulas), {{
            ['self_id'] = {tostring(event.element2), 'num'},
            ['other_id'] = {tostring(event.element1), 'num'},
            ['self_name'] = {tostring(event.object2.name or event.object2.data.name), 'text'},
            ['other_name'] = {tostring(event.object1.name or event.object1.data.name), 'text'},
            ['self_tag'] = {tostring(event.object2.data.tag), 'text'},
            ['other_tag'] = {tostring(event.object1.data.tag), 'text'},
            ['self_isShape'] = {tostring(event.object2.data.index == 0), 'log'},
            ['other_isShape'] = {tostring(event.object1.data.index == 0), 'log'}
          }})
        end end)
      end
    end
  end
end) end

onCollisionEnd = function(event) pcall(function()
  if event.object1.data.lis then
    local indexObject, nameShape = event.object1.data.index, '' if indexObject == 0
    then nameShape, indexObject = event.object1.data.name, event.object1.data.obj_id end
    local object = gameData[game.scene].objects[indexObject]
    for e = 1, #object.events do
      if object.events[e].name == 'onCollisionEnd' then local object, e = object, e
        timer.performWithDelay(1, function() if game.scene == event.object1.data.scene then
          onParseBlock(game.scene, indexObject, table.copy(object.events[e].formulas), {{
            ['self_id'] = {tostring(event.element1), 'num'},
            ['other_id'] = {tostring(event.element2), 'num'},
            ['self_name'] = {tostring(event.object1.name or event.object1.data.name), 'text'},
            ['other_name'] = {tostring(event.object2.name or event.object2.data.name), 'text'},
            ['self_tag'] = {tostring(event.object1.data.tag), 'text'},
            ['other_tag'] = {tostring(event.object2.data.tag), 'text'},
            ['self_isShape'] = {tostring(event.object1.data.index == 0), 'log'},
            ['other_isShape'] = {tostring(event.object2.data.index == 0), 'log'}
          }})
        end end)
      end
    end
  end if event.object2.data.lis then
    local indexObject, nameShape = event.object2.data.index, '' if indexObject == 0
    then nameShape, indexObject = event.object2.data.name, event.object2.data.obj_id end
    local object = gameData[game.scene].objects[indexObject]
    for e = 1, #object.events do
      if object.events[e].name == 'onCollisionEnd' then local object, e = object, e
        timer.performWithDelay(1, function() if game.scene == event.object2.data.scene then
          onParseBlock(game.scene, indexObject, table.copy(object.events[e].formulas), {{
            ['self_id'] = {tostring(event.element2), 'num'},
            ['other_id'] = {tostring(event.element1), 'num'},
            ['self_name'] = {tostring(event.object2.name or event.object2.data.name), 'text'},
            ['other_name'] = {tostring(event.object1.name or event.object1.data.name), 'text'},
            ['self_tag'] = {tostring(event.object2.data.tag), 'text'},
            ['other_tag'] = {tostring(event.object1.data.tag), 'text'},
            ['self_isShape'] = {tostring(event.object2.data.index == 0), 'log'},
            ['other_isShape'] = {tostring(event.object1.data.index == 0), 'log'}
          }})
        end end)
      end
    end
  end
end) end

onClick = function(indexScene, indexObject, event) pcall(function()
  local nameShape = '' if indexObject == 0
  then nameShape, indexObject = event.target.data.name, event.target.data.obj_id end
  local object = gameData[indexScene].objects[indexObject]
  for e = 1, #object.events do
    if object.events[e].name == 'onClick' then
      onParseBlock(indexScene, indexObject, table.copy(object.events[e].formulas), {{
        ['x'] = {tostring(event.x - game.x), 'num'},
        ['y'] = {tostring(game.y - event.y), 'num'},
        ['xStart'] = {tostring(event.xStart - game.x), 'num'},
        ['yStart'] = {tostring(game.y - event.yStart), 'num'},
        ['name'] = {nameShape, nameShape == '' and 'obj' or 'text'},
        ['isShape'] = {tostring(nameShape ~= ''), 'log'}
      }})
    end
  end
end) end

onClickEnd = function(indexScene, indexObject, event) pcall(function()
  local nameShape = '' if indexObject == 0
  then nameShape, indexObject = event.target.data.name, event.target.data.obj_id end
  local object = gameData[indexScene].objects[indexObject] game.clicks = game.clicks - 1
  for e = 1, #object.events do
    if object.events[e].name == 'onClickEnd' then
      onParseBlock(indexScene, indexObject, table.copy(object.events[e].formulas), {{
        ['x'] = {tostring(event.x - game.x), 'num'},
        ['y'] = {tostring(game.y - event.y), 'num'},
        ['xStart'] = {tostring(event.xStart - game.x), 'num'},
        ['yStart'] = {tostring(game.y - event.yStart), 'num'},
        ['name'] = {nameShape, nameShape == '' and 'obj' or 'text'},
        ['isShape'] = {tostring(nameShape ~= ''), 'log'}
      }})
    end
  end
end) end

onClickMove = function(indexScene, indexObject, event) pcall(function()
  local nameShape = '' if indexObject == 0
  then nameShape, indexObject = event.target.data.name, event.target.data.obj_id end
  local object = gameData[indexScene].objects[indexObject]
  for e = 1, #object.events do
    if object.events[e].name == 'onClickMove' then
      local absX = calc(indexScene, indexObject, table.copy(object.events[e].params[1]), {})
      local absY = calc(indexScene, indexObject, table.copy(object.events[e].params[2]), {})

      if (absY[2] == 'num' and math.abs(event.y - event.yStart) >= tonumber(absY[1]))
      or (absX[2] == 'num' and math.abs(event.x - event.xStart) >= tonumber(absX[1])) then
        if indexShape == 0 then
          display.getCurrentStage():setFocus(game.shapes[nameShape], nil)
          game.shapes[nameShape].data.click = false
          onClickEnd(indexScene, indexObject, event)
        else
          display.getCurrentStage():setFocus(game.shapes[nameShape], nil)
          game.shapes[nameShape].data.click = false
          onClickEnd(indexScene, indexObject, event)
        end
      end

      if game.objects[indexScene][indexObject].data.click
      or (nameShape == '' and game.shapes[nameShape].data.click) then
        onParseBlock(indexScene, indexObject, table.copy(object.events[e].formulas), {{
          ['x'] = {tostring(event.x - game.x), 'num'},
          ['y'] = {tostring(game.y - event.y), 'num'},
          ['xStart'] = {tostring(event.xStart - game.x), 'num'},
          ['yStart'] = {tostring(game.y - event.yStart), 'num'},
          ['name'] = {nameShape, nameShape == '' and 'obj' or 'text'},
          ['isShape'] = {tostring(nameShape ~= ''), 'log'}
        }})
      end
    end
  end
end) end

onStart = function(indexScene) pcall(function()
  game.scenes[tostring(indexScene)] = true
  for o = 1, #gameData[indexScene].objects do
    local object = gameData[indexScene].objects[o]
    for e = 1, #object.events do
      if object.events[e].name == 'onStart' then
        onParseBlock(indexScene, o, table.copy(object.events[e].formulas), {})
      end
    end
  end
end) end

createScene = function(indexScene)
  local scene = gameData[indexScene]
  game.objects[indexScene] = {}

  for o = 1, #scene.objects do
    local res if #scene.objects[o].textures > 0 then
      res = gameName .. '/' .. scene.name .. '.' .. scene.objects[o].name .. '.' .. scene.objects[o].textures[1]
    end display.setDefault('magTextureFilter', scene.objects[o].import)

    pcall(function()
      if res then game.objects[indexScene][o] = display.newImage(res, game.basedir)
      else game.objects[indexScene][o] = display.newRect(0,0,0,0) end
    end)

    if game.objects[indexScene][o] then
      if not res then game.objects[indexScene][o]:setFillColor(0,0,0,0) end
      game.objects[indexScene][o].x, game.objects[indexScene][o].y = game.x, game.y
      game.objects[indexScene][o].name, game.objects[indexScene][o].z = scene.objects[o].name, 0
      game.objects[indexScene][o].data = {
        index = o, click = false, tag = '', import = scene.objects[o].import, scene = indexScene,
        width = game.objects[indexScene][o].width, height = game.objects[indexScene][o].height,
        vis = true, path = gameName .. '/' .. scene.name .. '.' .. scene.objects[o].name .. '.',
        texture = scene.objects[o].textures[1], textures = scene.objects[o].textures, physics = {
          density = 0, bounce = 1, friction = -1, gravityScale = 1, hitbox = {},
          fixedRotation = false, sensor = false, bullet = false, body = ''
        }, obj_id = 0, lis = true
      } game.objects[indexScene][o]:addEventListener('touch', function(e)
          if e.x and e.y then
            game.touch_x, game.touch_y = e.x, e.y
            if game.taps[tostring(e.id)] then
              game.taps[tostring(e.id)].x = e.x
              game.taps[tostring(e.id)].y = e.y
          end end if e.target.data.scene == game.scene then
            if e.phase == 'began' then
              game.count_taps = game.count_taps + 1
              game.taps[tostring(e.id)] = {x = e.x, y = e.y, id = game.count_taps}
              display.getCurrentStage():setFocus(e.target, e.id)
              e.target.data.click = true
              onClick(e.target.data.scene, e.target.data.index, e)
            elseif e.phase == 'moved' then
              if e.target.data.click then
                onClickMove(e.target.data.scene, e.target.data.index, e)
              end
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
              display.getCurrentStage():setFocus(e.target, nil)
              if e.target.data.click then
                e.target.data.click = false
                onClickEnd(e.target.data.scene, e.target.data.index, e)
              end
            end
          end return true
      end) game.debugbackground:toFront() game.objects[indexScene][o].isVisible = false
    end
  end
end

startProject = function(app, name)
  physics.start()
  projectActive = true
  projectActivity = name
  display.setDefault('background', 0)

  for file in lfs.dir(system.pathForFile('', system.TemporaryDirectory)) do
    local theFile = system.pathForFile(file, system.TemporaryDirectory)
    pcall(function() os.remove(theFile) end)
  end

  timer.performWithDelay(1, function()
    if projectActive then
      local data = ccodeToJson(app)
      local TOP_HEIGHT = system.getInfo 'environment' ~= 'simulator' and display.topStatusBarContentHeight or 0
      local BOTTOM_HEIGHT = display.actualContentHeight - display.safeActualContentHeight
      local CONTENT_WIDTH = display.actualContentWidth
      local CONTENT_HEIGHT = display.actualContentHeight
      local CENTER_X = display.contentCenterX
      local CENTER_Y = display.contentCenterY

      gameName = app
      gameData = {}
      game = {
        x = CENTER_X, y = CENTER_Y, w = _w, h = _h, aW = CONTENT_WIDTH, taps = {}, count_taps = 0,
        aH = CONTENT_HEIGHT, touch_x = CENTER_X, touch_y = CENTER_Y, bH = BOTTOM_HEIGHT,
        aX = CONTENT_WIDTH / 2, aY = CONTENT_HEIGHT / 2, token = '', tH = TOP_HEIGHT,
        raw_x = 0, raw_y = 0, raw_z = 0, scene = 1, scenes = {['1'] = true}, tags = {}, sounds = {},
        gravity_x = 0, gravity_y = 0, gravity_z = 0, tables = {}, texts = {}, funs = {}, videos = {},
        clicks = 0, objects = {}, vars = {}, timers = {}, fields = {}, shapes = {}, emitters = {},
        instant_x = 0, instant_y = 0, instant_z = 0, accelerometer = function(event)
          game.gravity_x, game.gravity_y, game.gravity_z = event.xGravity, event.yGravity, event.zGravity
          game.instant_x, game.instant_y, game.instant_z = event.xInstant, event.yInstant, event.zInstant
          game.raw_x, game.raw_y, game.raw_z = event.xRaw, event.yRaw, event.zRaw
        end, sim = true, baseDir = system.pathForFile('', system.DocumentsDirectory), displayclick = false, cond = {},
        basedir = system.DocumentsDirectory, debugrect = display.newRect(0,0,0,0), back = false, fps = 60, _fps = 0,
        debugbackground = display.newRect(_x, _y, _aW, _aH + _tH + _bH), snapshot = display.newSnapshot(2000, 2000)
      } game.debugbackground:setFillColor(0,0,0,0.01) game.snapshot:translate(_x, _y) game.group = display.newGroup()

      game.border = display.newGroup()
      game.borderView = display.newRect(game.border, _x, _y, _w-4, _h)
      game.borderView.strokeWidth = 4
      game.borderView:setStrokeColor(0.7)
      game.borderView:setFillColor(0.7, 0.01)
      game.borderY = display.newText(game.border, _y, _x, 25, 'ubuntu.ttf', 50)
      game.borderX = display.newText(game.border, _x, _w-50, _y, 'ubuntu.ttf', 50)
      game.borderY.alpha, game.borderX.alpha = 0.7, 0.7
      if not settings.border then game.border.isVisible = false end

      -- for file in lfs.dir(system.pathForFile('', system.DocumentsDirectory) .. '/' .. gameName) do
      --   pcall(function() if utf8.match(utf8.match(file, 'res %.(.*)'), '%.(.*)') == 'sound' then
      --     local theFile = gameName .. '/' .. file
      --     local nameSound = utf8.match(file, 'res %.(.*)')
      --     game.sounds[nameSound] = audio.loadSound(theFile, system.DocumentsDirectory)
      --   end end)
      -- end

      if data.program == 'landscape' then
        orientation.lock 'landscape'
        game.x, game.y = game.y, game.x
        game.w, game.h = game.h, game.w
        game.aW, game.aH = game.aH, game.aW
        game.aX, game.aY = game.aY, game.aX
        game.touch_x, game.touch_y = game.touch_y, game.touch_x
        game.debugbackground.x, game.debugbackground.y = game.x, game.y
        game.debugbackground.width, game.debugbackground.height = _aH + _tH + _bH, _aW
        game.borderView.x, game.borderView.y = _y, _x
        game.borderView.width, game.borderView.height = _h, _w-4
        game.borderY.x, game.borderY.text = _y, _x
        game.borderX.x, game.borderX.y, game.borderX.text = _h-50, _x, _y
      end

      for s = 1, #data.scenes do
        gameData[s] = {
          name = data.scenes[s].name,
          objects = {}
        }
        for o = 1, #data.scenes[s].objects do
          gameData[s].objects[o] = {
            name = data.scenes[s].objects[o].name,
            textures = data.scenes[s].objects[o].textures,
            import = data.scenes[s].objects[o].import,
            events = {}
          }
          for e = 1, #data.scenes[s].objects[o].events do
            if data.scenes[s].objects[o].events[e].comment == 'false' then
              local countE = #gameData[s].objects[o].events + 1
              gameData[s].objects[o].events[countE] = {
                name = data.scenes[s].objects[o].events[e].name,
                params = data.scenes[s].objects[o].events[e].params,
                formulas = {}
              }
              for f = 1, #data.scenes[s].objects[o].events[e].formulas do
                if data.scenes[s].objects[o].events[e].formulas[f].comment == 'false' then
                  local countF = #gameData[s].objects[o].events[countE].formulas + 1
                  gameData[s].objects[o].events[countE].formulas[countF] = {
                    name = data.scenes[s].objects[o].events[e].formulas[f].name,
                    params = data.scenes[s].objects[o].events[e].formulas[f].params
                  }
                end
              end
            end
          end
        end
      end timer.performWithDelay(1, function() genOnFun()
      for s = 1, #data.scenes do createScene(s) end pcall(function() for o = 1, #game.objects[1]
      do game.objects[1][o].isVisible, game.objects[1][o].data.vis = true, true end end) onStart(1) end)
    end
  end)
end

stopProject = function(name) pcall(function()
  audio.stop()
  physics.stop()
  game.taps = {}
  game.scene = 0
  game.vars = nil
  game.tables = nil
  projectActive = false
  native.setKeyboardFocus(nil)
  physics.setDrawMode('normal')
  system.deactivate('multitouch')
  display.getCurrentStage():setFocus(nil)
  Runtime:removeEventListener('key', game.onKey)
  display.setDefault('background', 0.15, 0.15, 0.17)
  Runtime:removeEventListener('system', game.onSystem)
  Runtime:removeEventListener('collision', game.onCollision)
  Runtime:removeEventListener('accelerometer', game.accelerometer)
  game.debugbackground:removeEventListener('touch', game.onClickScreen)
  game.debugbackground:removeSelf()
  game.debugrect:removeSelf()
  game.snapshot:removeSelf()
  game.border:removeSelf()
  game.group:removeSelf()

  for i = 1, #game.timers do pcall(function() timer.cancel(game.timers[i]) game.timers[i] = nil end) end
  for i in pairs(game.texts) do pcall(function() game.texts[i]:removeSelf() game.texts[i] = nil end) end
  for i in pairs(game.videos) do pcall(function() game.videos[i]:removeSelf() game.videos[i] = nil end) end
  for i in pairs(game.shapes) do pcall(function() game.shapes[i]:removeSelf() game.shapes[i] = nil end) end
  for i in pairs(game.fields) do pcall(function() game.fields[i]:removeSelf() game.fields[i] = nil end) end
  for i in pairs(game.emitters) do pcall(function() game.emitters[i]:removeSelf() game.emitters[i] = nil end) end
  for i = 1, #game.objects do for j = 1, #game.objects[i] do pcall(function() game.objects[i][j]:removeSelf() game.objects[i][j] = nil end) end end

  timer.performWithDelay(17, function() activity[name].create() end)
end) end

Runtime:addEventListener('key', function(event)
  if game and not game.back and projectActive and not alertActive and (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
    timer.performWithDelay(17, function() if not alertActive then orientation.lock('portrait') stopProject(projectActivity) end end)
  end return true
end)
