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

local seed = (socket.gettime()*10000)%10^9
math.randomseed(seed)

onParseBlock = function(indexScene, indexObject, params, localtable)
  local nestedNoEnd = 'timer setLinkTexture setGet '
  local nestedNames = 'if ifElse for timer setLinkTexture enterFrame useTag setGet '
  local nested, nestedIndex, nestedActive = false, 0, ''
  for i = 1, #params do
    if not nested then
      if utf8.find(nestedNames, params[i].name .. ' ') then nested, nestedIndex = true, 1 end
      if utf8.find(nestedNoEnd, params[i].name .. ' ') then nested = 0 end nestedActive = params[i].name
      if frm[params[i].name] then frm[params[i].name](indexScene, indexObject, table.copy(params[i].params), localtable, table.copy(params), i) end
    else
      if params[i].name == 'if' or params[i].name == 'ifElse' or params[i].name == 'for'
      or params[i].name == 'enterFrame' or params[i].name == 'useTag' then nestedIndex = nestedIndex + 1
      elseif utf8.sub(params[i].name, utf8.len(params[i].name)-2, utf8.len(params[i].name)) == 'End'
      then nestedIndex = nestedIndex - 1 if (nestedIndex == 0 and (not utf8.find(nestedNoEnd, nestedActive .. ' ')))
      or (utf8.find(nestedNoEnd, nestedActive .. ' ') and nestedIndex == -1) then nested = false end end
    end
  end
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
        end
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
end

onClick = function(indexScene, indexObject)
  local object = gameData[indexScene].objects[indexObject]
  for e = 1, #object.events do
    if object.events[e].name == 'onClick' then
      onParseBlock(indexScene, indexObject, table.copy(object.events[e].formulas), {})
    end
  end
end

onClickEnd = function(indexScene, indexObject)
  local object = gameData[indexScene].objects[indexObject]
  for e = 1, #object.events do
    if object.events[e].name == 'onClickEnd' then
      onParseBlock(indexScene, indexObject, table.copy(object.events[e].formulas), {})
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
      if res then game.objects[indexScene][o] = display.newImage(res, system.DocumentsDirectory)
      else game.objects[indexScene][o] = display.newRect(0,0,0,0) end
    end)

    if game.objects[indexScene][o] then
      if not res then game.objects[indexScene][o]:setFillColor(0,0,0,0) end
      game.objects[indexScene][o].x, game.objects[indexScene][o].y = _x, _y
      game.objects[indexScene][o].name, game.objects[indexScene][o].z = scene.objects[o].name, 0
      game.objects[indexScene][o].data = {
        index = o, click = false, tag = '', import = scene.objects[o].import, scene = indexScene,
        width = game.objects[indexScene][o].width, height = game.objects[indexScene][o].height,
      }
      game.objects[indexScene][o]:addEventListener('touch', function(e)
        if e.target.data.scene == game.scene then
          if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            e.target.data.click = true
            onClick(e.target.data.scene, e.target.data.index)
          elseif e.phase == 'ended' or e.phase == 'cancelled' then
            display.getCurrentStage():setFocus(nil)
            if e.target.data.click then
              e.target.data.click = false
              onClickEnd(e.target.data.scene, e.target.data.index)
            end
          end
        end return true
      end) if indexScene ~= game.scene then game.objects[indexScene][o].isVisible = false end
    end
  end
end

startProject = function(app, name)
  projectActive = true
  projectActivity = name
  display.setDefault('background', 0, 0)

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
        aX = _aX, aY = _aY,
        scene = 1, scenes = {['1'] = true},
        tables = {}, texts = {}, funs = {},
        objects = {}, vars = {}, timers = {},
        sim = true, baseDir = system.pathForFile('', system.DocumentsDirectory)
      }

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
              for f = 1, #data.scenes[s].objects[o].events[countE].formulas do
                if data.scenes[s].objects[o].events[countE].formulas[f].comment == 'false' then
                  local countF = #gameData[s].objects[o].events[countE].formulas + 1
                  gameData[s].objects[o].events[countE].formulas[countF] = {
                    name = data.scenes[s].objects[o].events[countE].formulas[f].name,
                    params = data.scenes[s].objects[o].events[countE].formulas[f].params
                  }
                end
              end
            end
          end
        end
      end genOnFun() for s = 1, #data.scenes do createScene(s) end onStart(1)
    end
  end)
end

stopProject = function(name)
  projectActive = false
  display.getCurrentStage():setFocus(nil)
  display.setDefault('background', 0.15, 0.15, 0.17)

  for i = 1, #game.texts do pcall(function() game.texts[i]:removeSelf() end) end
  for i = 1, #game.timers do pcall(function() timer.cancel(game.timers[i]) end) end
  for i = 1, #game.objects do for j = 1, #game.objects[i] do pcall(function() game.objects[i][j]:removeSelf() end) end end

  timer.performWithDelay(1, function() activity[name].create() end)
end

Runtime:addEventListener('key', function(event)
  if projectActive and (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
    timer.performWithDelay(1, function() stopProject(projectActivity) end)
  end return true
end)
