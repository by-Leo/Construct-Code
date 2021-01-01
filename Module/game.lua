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

local gameData = {}
local seed = (socket.gettime()*10000)%10^9
math.randomseed(seed)

onStart = function(app, indexScene, indexObject)
  local object = gameData[indexScene].objects[indexObject]

  for e = 1, #object.events do
    if object.events[e].name == 'onStart' then
      for f = 1, #object.events[e].formulas do
        frm[object.events[e].formulas[f].name](object.events[e].formulas[f].params)
      end
    end
  end
end

createScene = function(app, indexScene)
  local scene = gameData[indexScene]
  game.objects[scene.name] = {}

  for o = 1, #scene.objects do
    local res = app .. '/' .. scene.name .. '.' .. scene.objects[o].name .. '.' .. scene.objects[o].textures[1]

    if scene.objects[o].import == 'linear' then display.setDefault('magTextureFilter', 'linear')
    else display.setDefault('magTextureFilter', 'nearest') end

    pcall(function() game.objects[scene.name][o] = display.newImage(res, system.DocumentsDirectory) end)

    if game.objects[scene.name][o] then
      game.objects[scene.name][o].events = {}
      game.objects[scene.name][o].x, game.objects[scene.name][o].y = _x, _y

      game.objects[scene.name][o].data = {
        index = o, x = 0, y = 0,
        width = game.objects[scene.name][o].width, height = game.objects[scene.name][o].height,
        image_width = game.objects[scene.name][o].width, image_height = game.objects[scene.name][o].height,
      } onStart(app, indexScene, o)
    end
  end
end

startProject = function(app)
  local data = ccodeToJson(app)

  game = {
    objects = {},
    vars = {}
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
          gameData[s].objects[o].events[e] = {
            name = data.scenes[s].objects[o].events[e].name,
            params = data.scenes[s].objects[o].events[e].params,
            formulas = {}
          }
          for f = 1, #data.scenes[s].objects[o].events[e].formulas do
            if data.scenes[s].objects[o].events[e].formulas[f].comment == 'false' then
              gameData[s].objects[o].events[e].formulas[f] = {
                name = data.scenes[s].objects[o].events[e].formulas[f].name,
                params = data.scenes[s].objects[o].events[e].formulas[f].params
              }
            end
          end
        end
      end
    end
  end

  display.setDefault('background', 0, 0)
  createScene(app, 1)
end
