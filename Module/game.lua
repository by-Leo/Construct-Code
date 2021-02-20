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
  nestedNoEnd = nestedNoEnd .. 'setGet setPost setPut setPatch setDelete '
  local nestedNames = 'if ifElse for while forI forT enterFrame useTag useCopy timer '
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

onFun = function(indexScene, indexObject, params, localtable)
  for i = 1, #params do
    if params[i].comment == 'true' then
      table.remove(params, i)
    end
  end onParseBlock(indexScene, indexObject, table.copy(params), localtable)
end

genOnFun = function()
  for s = 1, #gameData do
    local scene = gameData[s]
    for o = 1, #scene.objects do
      local object = scene.objects[o]
      for e = 1, #object.events do
        local event = object.events[e]
        if event.name == 'onFun' then
          game.funs[#game.funs + 1] = {
            call = false, localtable = {},
            indexScene = s, indexObject = o,
            params = table.copy(event.formulas),
            name = event.params[1][1] and event.params[1][1][1] or ''
          }
        elseif event.name == 'onBack' then game.back = true end
      end
    end
  end

  game.timers[#game.timers + 1] = timer.performWithDelay(1, function()
    for i = 1, #game.funs do
      if game.funs[i].call then game.funs[i].call = false
        if game.funs[i].indexScene == game.scene then
          onFun(game.funs[i].indexScene, game.funs[i].indexObject, table.copy(game.funs[i].params), table.copy(game.funs[i].localtable))
        end
      end
    end
  end, 0)

  game.onCollision = function(event)
    if event.phase == 'began' and event.object1.data.scene == game.scene
    and event.object2.data.scene == game.scene then onCollisionStart(event)
    elseif event.phase == 'ended' and event.object1.data.scene == game.scene
    and event.object2.data.scene == game.scene then onCollisionEnd(event) end
  end

  game.onSystem = function(event)
    if event.type == 'applicationSuspend' then onHide()
    elseif event.type == 'applicationResume' then onView() end
  end

  game.onKey = function(event)
    if game.back and projectActive and (event.keyName == 'back' or event.keyName == 'escape')
    and event.phase == 'up' then onBack() end return true
  end

  game.onClickScreen = function(event)
    if event.x and event.y then game.touch_x, game.touch_y = event.x, event.y end
    if event.phase == 'began' then game.clicks = game.clicks + 1
      display.getCurrentStage():setFocus(event.target, event.id)
    elseif event.phase == 'ended' then game.clicks = game.clicks - 1
      display.getCurrentStage():setFocus(event.target, nil)
    end return true
  end

  Runtime:addEventListener('key', game.onKey)
  Runtime:addEventListener('system', game.onSystem)
  Runtime:addEventListener('touch', game.onClickScreen)
  Runtime:addEventListener('collision', game.onCollision)
end

onBack = function()
  local objects = gameData[game.scene].objects
  for o = 1, #objects do
    for e = 1, #objects[o].events do
      if objects[o].events[e].name == 'onBack' then
        onParseBlock(game.scene, o, table.copy(objects[o].events[e].formulas), {})
      end
    end
  end
end

onHide = function()
  local objects = gameData[game.scene].objects
  for o = 1, #objects do
    for e = 1, #objects[o].events do
      if objects[o].events[e].name == 'onHide' then
        onParseBlock(game.scene, o, table.copy(objects[o].events[e].formulas), {})
      end
    end
  end
end

onView = function()
  local objects = gameData[game.scene].objects
  for o = 1, #objects do
    for e = 1, #objects[o].events do
      if objects[o].events[e].name == 'onView' then
        onParseBlock(game.scene, o, table.copy(objects[o].events[e].formulas), {})
      end
    end
  end
end

onCollisionStart = function(event)
  local object = gameData[game.scene].objects[event.object1.data.index]
  for e = 1, #object.events do
    if object.events[e].name == 'onCollisionStart' then local object, e = object, e
      timer.performWithDelay(1, function() if game.scene == event.object1.data.scene then
        onParseBlock(game.scene, event.object1.data.index, table.copy(object.events[e].formulas), {{
          ['self_id'] = {tostring(event.element1), 'num'},
          ['other_id'] = {tostring(event.element2), 'num'},
          ['self_name'] = {tostring(event.object1.name), 'text'},
          ['other_name'] = {tostring(event.object2.name), 'text'},
          ['self_tag'] = {tostring(event.object1.data.tag), 'text'},
          ['other_tag'] = {tostring(event.object2.data.tag), 'text'},
          ['obj_id'] = (game.objects[game.scene][event.object1.data.index]
          and game.objects[game.scene][event.object1.data.index].data.copy)
          and {tostring(game.objects[game.scene][event.object1.data.index].data.obj_id), 'num'} or nil,
          ['obj_name'] = (game.objects[game.scene][event.object1.data.index]
          and game.objects[game.scene][event.object1.data.index].data.copy)
          and {tostring(game.objects[game.scene][game.objects[game.scene][event.object1.data.index].data.obj_id].text), 'text'} or nil,
          ['copy_id'] = (game.objects[game.scene][event.object1.data.index]
          and game.objects[game.scene][event.object1.data.index].data.copy)
          and {tostring(event.object1.data.index), 'num'} or nil,
          ['copy_name'] = (game.objects[game.scene][event.object1.data.index]
          and game.objects[game.scene][event.object1.data.index].data.copy)
          and {'.copy' .. event.object1.data.index, 'text'} or nil
        }})
      end end)
    end
  end object = gameData[game.scene].objects[event.object2.data.index]
  for e = 1, #object.events do
    if object.events[e].name == 'onCollisionStart' then local object, e = object, e
      timer.performWithDelay(1, function() if game.scene == event.object2.data.scene then
        onParseBlock(game.scene, event.object2.data.index, table.copy(object.events[e].formulas), {{
          ['self_id'] = {tostring(event.element2), 'num'},
          ['other_id'] = {tostring(event.element1), 'num'},
          ['self_name'] = {tostring(event.object2.name), 'text'},
          ['other_name'] = {tostring(event.object1.name), 'text'},
          ['self_tag'] = {tostring(event.object2.data.tag), 'text'},
          ['other_tag'] = {tostring(event.object1.data.tag), 'text'},
          ['obj_id'] = (game.objects[game.scene][event.object2.data.index]
          and game.objects[game.scene][event.object2.data.index].data.copy)
          and {tostring(game.objects[game.scene][event.object2.data.index].data.obj_id), 'num'} or nil,
          ['obj_name'] = (game.objects[game.scene][event.object2.data.index]
          and game.objects[game.scene][event.object2.data.index].data.copy)
          and {tostring(game.objects[game.scene][game.objects[game.scene][event.object2.data.index].data.obj_id].text), 'text'} or nil,
          ['copy_id'] = (game.objects[game.scene][event.object2.data.index]
          and game.objects[game.scene][event.object2.data.index].data.copy)
          and {tostring(event.object2.data.index), 'num'} or nil,
          ['copy_name'] = (game.objects[game.scene][event.object2.data.index]
          and game.objects[game.scene][event.object2.data.index].data.copy)
          and {'.copy' .. event.object2.data.index, 'text'} or nil
        }})
      end end)
    end
  end
end

onCollisionEnd = function(event)
  local object = gameData[game.scene].objects[event.object1.data.index]
  for e = 1, #object.events do
    if object.events[e].name == 'onCollisionEnd' then local object, e = object, e
      timer.performWithDelay(1, function() if game.scene == event.object1.data.scene then
        onParseBlock(game.scene, event.object1.data.index, table.copy(object.events[e].formulas), {{
          ['self_id'] = {tostring(event.element1), 'num'},
          ['other_id'] = {tostring(event.element2), 'num'},
          ['self_name'] = {tostring(event.object1.name), 'text'},
          ['other_name'] = {tostring(event.object2.name), 'text'},
          ['self_tag'] = {tostring(event.object1.data.tag), 'text'},
          ['other_tag'] = {tostring(event.object2.data.tag), 'text'},
          ['obj_id'] = (game.objects[game.scene][event.object1.data.index]
          and game.objects[game.scene][event.object1.data.index].data.copy)
          and {tostring(game.objects[game.scene][event.object1.data.index].data.obj_id), 'num'} or nil,
          ['obj_name'] = (game.objects[game.scene][event.object1.data.index]
          and game.objects[game.scene][event.object1.data.index].data.copy)
          and {tostring(game.objects[game.scene][game.objects[game.scene][event.object1.data.index].data.obj_id].text), 'text'} or nil,
          ['copy_id'] = (game.objects[game.scene][event.object1.data.index]
          and game.objects[game.scene][event.object1.data.index].data.copy)
          and {tostring(event.object1.data.index), 'num'} or nil,
          ['copy_name'] = (game.objects[game.scene][event.object1.data.index]
          and game.objects[game.scene][event.object1.data.index].data.copy)
          and {'.copy' .. event.object1.data.index, 'text'} or nil
        }})
      end end)
    end
  end object = gameData[game.scene].objects[event.object2.data.index]
  for e = 1, #object.events do
    if object.events[e].name == 'onCollisionEnd' then local object, e = object, e
      timer.performWithDelay(1, function() if game.scene == event.object2.data.scene then
        onParseBlock(game.scene, event.object2.data.index, table.copy(object.events[e].formulas), {{
          ['self_id'] = {tostring(event.element2), 'num'},
          ['other_id'] = {tostring(event.element1), 'num'},
          ['self_name'] = {tostring(event.object2.name), 'text'},
          ['other_name'] = {tostring(event.object1.name), 'text'},
          ['self_tag'] = {tostring(event.object2.data.tag), 'text'},
          ['other_tag'] = {tostring(event.object1.data.tag), 'text'},
          ['obj_id'] = (game.objects[game.scene][event.object2.data.index]
          and game.objects[game.scene][event.object2.data.index].data.copy)
          and {tostring(game.objects[game.scene][event.object2.data.index].data.obj_id), 'num'} or nil,
          ['obj_name'] = (game.objects[game.scene][event.object2.data.index]
          and game.objects[game.scene][event.object2.data.index].data.copy)
          and {tostring(game.objects[game.scene][game.objects[game.scene][event.object2.data.index].data.obj_id].text), 'text'} or nil,
          ['copy_id'] = (game.objects[game.scene][event.object2.data.index]
          and game.objects[game.scene][event.object2.data.index].data.copy)
          and {tostring(event.object2.data.index), 'num'} or nil,
          ['copy_name'] = (game.objects[game.scene][event.object2.data.index]
          and game.objects[game.scene][event.object2.data.index].data.copy)
          and {'.copy' .. event.object2.data.index, 'text'} or nil
        }})
      end end)
    end
  end
end

onClick = function(indexScene, indexObject, event)
  local object = gameData[indexScene].objects[indexObject] game.clicks = game.clicks + 1
  for e = 1, #object.events do
    if object.events[e].name == 'onClick' then
      onParseBlock(indexScene, indexObject, table.copy(object.events[e].formulas), {{
        ['x'] = {tostring(event.x - game.x), 'num'},
        ['y'] = {tostring(game.y - event.y), 'num'},
        ['xStart'] = {tostring(event.xStart - game.x), 'num'},
        ['yStart'] = {tostring(game.y - event.yStart), 'num'},
        ['obj_id'] = (game.objects[indexScene][indexObject]
        and game.objects[indexScene][indexObject].data.copy)
        and {tostring(game.objects[indexScene][indexObject].data.obj_id), 'num'} or nil,
        ['obj_name'] = (game.objects[indexScene][indexObject]
        and game.objects[indexScene][indexObject].data.copy)
        and {tostring(game.objects[indexScene][game.objects[indexScene][indexObject].data.obj_id].text), 'text'} or nil,
        ['copy_id'] = (game.objects[indexScene][indexObject]
        and game.objects[indexScene][indexObject].data.copy)
        and {tostring(indexObject), 'num'} or nil,
        ['copy_name'] = (game.objects[indexScene][indexObject]
        and game.objects[indexScene][indexObject].data.copy)
        and {'.copy' .. indexObject, 'text'} or nil
      }})
    end
  end
end

onClickEnd = function(indexScene, indexObject, event)
  local object = gameData[indexScene].objects[indexObject] game.clicks = game.clicks - 1
  for e = 1, #object.events do
    if object.events[e].name == 'onClickEnd' then
      onParseBlock(indexScene, indexObject, table.copy(object.events[e].formulas), {{
        ['x'] = {tostring(event.x - game.x), 'num'},
        ['y'] = {tostring(game.y - event.y), 'num'},
        ['xStart'] = {tostring(event.xStart - game.x), 'num'},
        ['yStart'] = {tostring(game.y - event.yStart), 'num'},
        ['obj_id'] = (game.objects[indexScene][indexObject]
        and game.objects[indexScene][indexObject].data.copy)
        and {tostring(game.objects[indexScene][indexObject].data.obj_id), 'num'} or nil,
        ['obj_name'] = (game.objects[indexScene][indexObject]
        and game.objects[indexScene][indexObject].data.copy)
        and {tostring(game.objects[indexScene][game.objects[indexScene][indexObject].data.obj_id].text), 'text'} or nil,
        ['copy_id'] = (game.objects[indexScene][indexObject]
        and game.objects[indexScene][indexObject].data.copy)
        and {tostring(indexObject), 'num'} or nil,
        ['copy_name'] = (game.objects[indexScene][indexObject]
        and game.objects[indexScene][indexObject].data.copy)
        and {'.copy' .. indexObject, 'text'} or nil
      }})
    end
  end
end

onClickMove = function(indexScene, indexObject, event)
  local object = gameData[indexScene].objects[indexObject]
  for e = 1, #object.events do
    if object.events[e].name == 'onClickMove' then
      local absX = calc(indexScene, indexObject, table.copy(object.events[e].params[1]), {})
      local absY = calc(indexScene, indexObject, table.copy(object.events[e].params[2]), {})

      if absX[2] == 'num' and math.abs(event.x - event.xStart) >= tonumber(absX[1]) then
        display.getCurrentStage():setFocus(game.objects[indexScene][indexObject], nil)
        game.objects[indexScene][indexObject].data.click = false
        onClickEnd(indexScene, indexObject, event)
      end

      if absY[2] == 'num' and math.abs(event.y - event.yStart) >= tonumber(absY[1]) then
        display.getCurrentStage():setFocus(game.objects[indexScene][indexObject], nil)
        game.objects[indexScene][indexObject].data.click = false
        onClickEnd(indexScene, indexObject, event)
      end

      if game.objects[indexScene][indexObject].data.click then
        onParseBlock(indexScene, indexObject, table.copy(object.events[e].formulas), {{
          ['x'] = {tostring(event.x - game.x), 'num'},
          ['y'] = {tostring(game.y - event.y), 'num'},
          ['xStart'] = {tostring(event.xStart - game.x), 'num'},
          ['yStart'] = {tostring(game.y - event.yStart), 'num'},
          ['obj_id'] = (game.objects[indexScene][indexObject]
          and game.objects[indexScene][indexObject].data.copy)
          and {tostring(game.objects[indexScene][indexObject].data.obj_id), 'num'} or nil,
          ['obj_name'] = (game.objects[indexScene][indexObject]
          and game.objects[indexScene][indexObject].data.copy)
          and {tostring(game.objects[indexScene][game.objects[indexScene][indexObject].data.obj_id].text), 'text'} or nil,
          ['copy_id'] = (game.objects[indexScene][indexObject]
          and game.objects[indexScene][indexObject].data.copy)
          and {tostring(indexObject), 'num'} or nil,
          ['copy_name'] = (game.objects[indexScene][indexObject]
          and game.objects[indexScene][indexObject].data.copy)
          and {'.copy' .. indexObject, 'text'} or nil
        }})
      end
    end
  end
end

onStart = function(indexScene)
  game.scenes[tostring(indexScene)] = true
  for o = 1, #gameData[indexScene].objects do
    local object = gameData[indexScene].objects[o]
    for e = 1, #object.events do
      if object.events[e].name == 'onStart' then
        onParseBlock(indexScene, o, table.copy(object.events[e].formulas), {})
      end
    end
  end
end

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
        vis = false, path = gameName .. '/' .. scene.name .. '.' .. scene.objects[o].name .. '.',
        texture = scene.objects[o].textures[1], textures = scene.objects[o].textures, physics = {
          density = 0, bounce = 1, friction = -1, gravityScale = 1, hitbox = {},
          fixedRotation = false, sensor = false, bullet = false, body = ''
        }, copy = false, copies = {}
      } game.objects[indexScene][o]:addEventListener('touch', function(e)
          if e.x and e.y then game.touch_x, game.touch_y = e.x, e.y end
          if e.target.data.scene == game.scene then
            if e.phase == 'began' then
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
      end) game.objects[indexScene][o].isVisible = false
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

      gameName = app
      gameData = {}
      game = {
        x = _x, y = _y,
        w = _w, h = _h,
        aW = _aW, aH = _aH,
        touch_x = 0, touch_y = 0,
        aX = _aX, aY = _aY, token = '',
        raw_x = 0, raw_y = 0, raw_z = 0,
        scene = 1, scenes = {['1'] = true},
        gravity_x = 0, gravity_y = 0, gravity_z = 0,
        tables = {}, texts = {}, funs = {}, clicks = 0,
        objects = {}, vars = {}, timers = {}, fields = {},
        instant_x = 0, instant_y = 0, instant_z = 0, accelerometer = function(event)
          game.xGravity, game.yGravity, game.zGravity = event.xGravity, event.yGravity, event.zGravity
          game.xInstant, game.yInstant, game.zInstant = event.xInstant, event.yInstant, event.zInstant
          game.xRaw, game.yRaw, game.zRaw = event.xRaw, event.yRaw, event.zRaw
        end, sim = true, baseDir = system.pathForFile('', system.DocumentsDirectory),
        basedir = system.DocumentsDirectory, debugrect = display.newRect(0,0,0,0), back = false
      }

      if data.program == 'landscape' then
        orientation.lock 'landscape'
        game.x, game.y = _y, _x
        game.w, game.h = _h, _w
        game.aW, game.aH = _aH, _aW
        game.aX, game.aY = _aY, _aX
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
      for s = 1, #data.scenes do createScene(s) end
      for o = 1, #game.objects[1] do game.objects[1][o].isVisible = true
      game.objects[1][o].data.vis = true end onStart(1) end)
    end
  end)
end

stopProject = function(name)
  physics.stop()
  game.scene = 0
  projectActive = false
  native.setKeyboardFocus(nil)
  physics.setDrawMode('normal')
  system.deactivate('multitouch')
  display.getCurrentStage():setFocus(nil)
  Runtime:removeEventListener('key', game.onKey)
  display.setDefault('background', 0.15, 0.15, 0.17)
  Runtime:removeEventListener('system', game.onSystem)
  Runtime:removeEventListener('touch', game.onClickScreen)
  Runtime:removeEventListener('collision', game.onCollision)
  Runtime:removeEventListener('accelerometer', game.accelerometer)

  for i in pairs(game.texts) do pcall(function() game.texts[i]:removeSelf() end) end
  for i in pairs(game.fields) do pcall(function() game.fields[i]:removeSelf() end) end
  for i = 1, #game.timers do pcall(function() timer.cancel(game.timers[i]) end) end
  for i = 1, #game.objects do for j = 1, #game.objects[i] do pcall(function() game.objects[i][j]:removeSelf() end) end end

  timer.performWithDelay(1, function() orientation.lock('portrait')
    timer.performWithDelay(1, function() activity[name].create() end)
  end)
end

Runtime:addEventListener('key', function(event)
  if game and not game.back and projectActive and not alertActive and (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
    timer.performWithDelay(1, function() stopProject(projectActivity) end)
  end return true
end)
