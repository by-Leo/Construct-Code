-- Глобальные библиотеки и модули
composer = require 'composer'
library = require 'plugin.cnkFileManager'
utf8 = require 'plugin.utf8'
widget = require 'widget'
lfs = require 'lfs'
json = require 'json'
physics = require 'physics'
crypto = require 'crypto'
zip = require 'plugin.zip'
orientation = require 'plugin.orientation'

-- Глобальные переменные с учётом харак-ик экрана
_x = display.contentCenterX
_y = display.contentCenterY
_w = display.contentWidth
_h = display.contentHeight
_aW = display.actualContentWidth
_aH = display.actualContentHeight
_aX = _aW / 2
_aY = _aH / 2
_pW = display.actualContentWidth
_pH = display.actualContentHeight
_tH = system.getInfo 'environment' ~= 'simulator' and display.topStatusBarContentHeight or 0
_bH = display.actualContentHeight - display.safeActualContentHeight
_aH = _aH - _bH - _tH
_aY = _aH / 2

-- sceneViewer = ''
-- gameStart = 'sceneCC'
-- gameDisplay = ''
-- openScene = ''
-- openScenes = ''
-- openObject = ''
-- getResponse = ''
filterInput = '?:"*|/\\<>.!@#$&~%()[]{}\';`'
alertActive = false

if system.getInfo 'platform' == 'android' and system.getInfo 'environment' ~= 'simulator' then
  path_platform = '/storage/emulated/0'
else
  path_platform = utf8.match(system.pathForFile('', system.DocumentsDirectory), '(.*)\\AppData')
  if type(path_platform) ~= 'string' then path_platform = ''
  else path_platform = utf8.gsub(path_platform, '\\', '/') end
end

-- Сохранение настроек
function settingsSave()
  local settingsPath = system.pathForFile('settings.json', system.DocumentsDirectory)
  local settingsFile = io.open(settingsPath, 'w')

  if settingsFile then
    settingsFile:write(json.encode(settings))
    io.close(settingsFile)
  end
end

-- Считывание настроек
local settingsPath = system.pathForFile('settings.json', system.DocumentsDirectory)
local settingsFile = io.open(settingsPath, 'r')

if settingsFile then
  settings = json.decode(settingsFile:read('*a'))
  io.close(settingsFile)
else
  local language = 'ru'--system.getPreference('locale', 'language')

  settings = {
    stdImport = true,
    language = language,
    pictureView = false,
    lastApp = ''
  }

  settingsSave()
end

require 'Module.strings'
if not stringsLanguage[settings.language] then settings.language = 'en' settingsSave() end
strings = stringsLanguage[settings.language]

-- Включение рандомайзера
math.randomseed(os.time())

-- Инициализация плагинов
orientation.init()
-- orientation.lock( "landscape" )
-- orientation.lock( "portrait" )

widget.setTheme('widget_theme_android_holo_dark')
display.setDefault('background', 0.15, 0.15, 0.17)
display.setStatusBar(display.HiddenStatusBar)

-- display.setDefault('background', 0, 0, 0, 0)
-- print(display.colorSample( _x, _y, function(e) print(json.encode(e)) end ))

local function onKeyEvent(event)
  if event.keyName == "back" or event.keyName == "escape" then
    return true
  end
end
Runtime:addEventListener("key", onKeyEvent)

-- function errorHandler(event)
--   print(event.errorMessage)
--   return true
-- end
-- Runtime:addEventListener("unhandledError", errorHandler)

encoder = function(stroke, types, key)
  local stroke_encoder = ''
  for i = 1, utf8.len(stroke) do
    math.randomseed(i)
    local simbol_byte = utf8.byte(stroke, i, i)
    local simbol_char = ''
    local key_byte = 0
    for j = 1, utf8.len(key) do
      key_byte = key_byte + utf8.byte(key, j, j)
    end
    if types == 'encode' then simbol_char = utf8.char(simbol_byte+math.random(1, i+100)+key_byte)
    else simbol_char = utf8.char(simbol_byte-math.random(1, i+100)-key_byte) end
    stroke_encoder = stroke_encoder .. simbol_char
  end
  math.randomseed(os.time())
  return stroke_encoder
end
-- print(encoder('', '', '?.cc_ode' ))

jsonToCCode = function(data)
  return json.prettify(data)
end

ccodeToJson = function(name)
  local file = io.open(system.pathForFile('', system.DocumentsDirectory) .. '/' .. name .. '/' .. name .. '.cc', 'r')
  local data = {} if file then data = json.decode(file:read('*a')) io.close(file) end return data
end

hex = function(hex)
	local r, g, b = hex:match('(..)(..)(..)')
	return {tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)}
end

trim = function(s)
  return utf8.gsub(utf8.gsub(s, '^%s+', ''), '%s+$', '')
end

trimLeft = function(s)
  return utf8.gsub(s, '^%s+', '')
end

trimRight = function(s)
  return utf8.gsub(s, '%s+$', '')
end

activity = {}
activity.createActivity = {}
activity.scrollSettings = {
  x = _x,
  y = _y - 35,
  width = _aW,
  height = _aH-400,
  hideBackground = true,
  hideScrollBar = true,
  horizontalScrollDisabled = true,
  isBounceEnabled = true,
  listener = function(e) return true end
}

require 'Module.alert'
require 'Module.input'
require 'Module.list'
require 'Module.fsd'
require 'Module.blockList'

require 'Module.paramsColorInBlocks'
require 'Module.updateTextLanguage'
require 'Module.returnModule'
require 'Module.moveBlock'
require 'Module.moveLogBlock'
require 'Module.newBlock'
require 'Module.genBlock'

require 'Module.onInputEvent'
require 'Module.onFile'
require 'Module.onClick'
require 'Module.onClickPrograms'
require 'Module.onClickScenes'
require 'Module.onClickResources'
require 'Module.onClickObjects'
require 'Module.onClickTextures'
require 'Module.onClickBlocks'

require 'Module.setting'
require 'Module.programs'
require 'Module.scenes'
require 'Module.resources'
require 'Module.objects'
require 'Module.textures'
require 'Module.blocks'
require 'Module.newblocks'
require 'Module.formulasEditor'

require 'Module.calc'
require 'Module.calcFun'
require 'Module.calcProp'
require 'Module.game'
require 'Module.gameFormula1'
require 'Module.gameFormula2'
require 'Module.gameFormula3'

-- Предварительная подгрузка виджета
alert('', '', {''}, function() end)
setting.lib.isVisible = false
activity.programs.group.isVisible = false
activity.scenes.group.isVisible = false
activity.resources.group.isVisible = false
activity.objects.group.isVisible = false
activity.textures.group.isVisible = false
activity.blocks.group.isVisible = false
activity.newblocks.group.isVisible = false
activity.editor.group.isVisible = false

-- Запуск
timer.performWithDelay(1, function()
  alertActive = true
  composer.gotoScene 'Module.menu'
end)
