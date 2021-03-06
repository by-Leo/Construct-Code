-- Глобальные библиотеки и модули
composer = require 'composer'
particles = require 'Emitter.particleDesigner'
library = require 'plugin.cnkFileManager'
utf8 = require 'plugin.utf8'
widget = require 'widget'
lfs = require 'lfs'
json = require 'json'
physics = require 'physics'
crypto = require 'crypto'
zip = require 'plugin.zip'
orientation = require 'plugin.orientation'
notifications = require 'plugin.notifications.v2'

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
  local language = system.getPreference('locale', 'language')

  settings = {
    stdImport = true,
    language = language,
    pictureView = false,
    lastApp = '',
    border = false,
    statusBar = false,
    firstMessage = true,
    repository = {}
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
if settings.statusBar then display.setStatusBar(display.TranslucentStatusBar) end

-- display.setDefault('background', 0, 0, 0, 0)
-- print(display.colorSample( _x, _y, function(e) print(json.encode(e)) end ))

local function onKeyEvent(event)
  if event.keyName == "back" or event.keyName == "escape" then
    return true
  end
end
Runtime:addEventListener("key", onKeyEvent)

function errorHandler(event)
  alert('Runtime Error', 'Ты получил ошибку, сделай скриншот и скинь мне его, пожалуйста: \n\n' .. event.errorMessage,
  {'Ок'}, function(e) end) return true
end Runtime:addEventListener("unhandledError", errorHandler)

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
  if system.getInfo 'environment' ~= 'simulator' then return json.encode(data)
  else return json.prettify(data) end
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

-- print(1, system.getTimer())
-- local text1 = display.newText({
--   text = 'Пиздец нахой блять', align = 'left',
--   x = 300, y = 0, font = 'ubuntu_!bold.ttf', fontSize = 22, width = 161
-- }) print(2, system.getTimer())
--
-- print(3, system.getTimer())
-- local text2 = display.newText({
--   text = 'Пиздец нахой блять', align = 'left',
--   x = 600, y = 0, font = 'ubuntu_!bold.ttf', fontSize = 22, width = 161
-- }) print(4, system.getTimer())

-- local s = widget.newScrollView(activity.scrollSettings)

-- display.newText('TestTestTest', 0, 0, 'ubuntu_!bold.ttf', 30)

-- local c = 50000
-- local d = c % 6000
-- local u = c - d
-- local b = u / 6000
-- local a = 0
-- local k = 1
--
-- print(system.getTimer())
-- timer.performWithDelay(1, function() k = k + 0.001
--   timer.performWithDelay(k, function()
--     a = a + 1
--     for i = 1, 6000 do
--       display.newText('TestTestTest', 0, 0, 'ubuntu_!bold.ttf', 30)
--     end
--
--     if a == b then
--       print(system.getTimer())
--       timer.performWithDelay(1, function() print(system.getTimer())  end)
--     end
--   end)
-- end, b)

-- display.newText('TestTestTest', -100000, 0, 'ubuntu_!bold.ttf', 30)
-- print(system.getTimer())
-- for i = 1, c do
--   display.newText('TestTestTest', 0, 0, 'ubuntu_!bold.ttf', 30)
-- end print(system.getTimer())
--
-- timer.performWithDelay(1, function() print(system.getTimer()) end)

-- local sTime = system.getTimer()
-- local i = 0
-- timer.performWithDelay(34, function(event)
--   if i < 4001 then i = i + 1
--     display.newText('TestTestTest', 0, 0, 'ubuntu_!bold.ttf', 30)
--     if i == 4000 then print((system.getTimer() - sTime) / 1000) end
--   end
-- end, 0)

-- local physics = require 'physics'
--
-- physics.setDrawMode('hybrid')
-- physics.setScale(60)
-- physics.setPositionIterations(6)
-- physics.setVelocityIterations(16)
-- physics.setAverageCollisionPositions(true)
-- physics.start()
--
-- local rect1 = display.newRect(0, 0, 200, 200)
-- rect1.x, rect1.y = _x, _y
-- rect1.rotation = 45
--
-- physics.addBody(rect1, 'static', {bounce=0})
--
-- local rect2 = display.newRect(_x, _y, 200, 200)
--
-- rect2.x, rect2.y = _x, _y - 400
--
-- physics.addBody(rect2, 'dynamic', {bounce=0})
--
-- local function onLocalCollision( self, event )
--   if event.phase == "began" then
--     print(event.x, event.y)
--     display.newRect(rect1.x + event.x / 2, rect1.y - event.y, 30, 30):setFillColor(0)
--   end
-- end
--
-- rect1.collision = onLocalCollision
-- rect1:addEventListener( "collision" )

-- physics.setDrawMode('hybrid')
-- physics.setScale(60)
-- physics.setPositionIterations(6)
-- physics.setVelocityIterations(16)
-- physics.setAverageCollisionPositions(true)
-- physics.start()
--
-- -- local camera = display.newGroup()
--
-- local rect1 = display.newRect(_x, _y + 200, 400, 20)
-- rect1:setFillColor(0.1, 0.5, 0.1)
--
-- physics.addBody(rect1, 'static', {bounce=0, friction=-1})
--
-- local rect2 = display.newRect(_x, _y + 140, 40, 100)
--
-- physics.addBody(rect2, 'dynamic', {bounce=0, friction=-1})
--
-- local rect3 = display.newRect(_x + 150, _y + 139, 40, 100)
--
-- physics.addBody(rect3, 'static', {bounce=0, friction=-1})
--
-- -- camera:insert(rect1)
-- -- camera:insert(rect2)
-- -- camera:insert(rect3)
--
-- local but1 = display.newRect(_x + 200, _y + 500, 100, 100)
-- local but2 = display.newRect(_x - 200, _y + 500, 100, 100)
-- but1.press = false
-- but2.press = false
--
-- local enterFrame = function()
--   if but1.press then
--     local x, y = rect2:getLinearVelocity()
--     rect2:setLinearVelocity(0, y)
--     rect2:applyLinearImpulse(0.02, 0, rect2.x, rect2.y)
--     -- rect1:setLinearVelocity(-50, 0)
--     -- rect3:setLinearVelocity(-50, 0)
--     -- rect1.angularDamping = -50
--     -- rect1.x = rect1.x - 2
--     -- rect3.x = rect3.x - 2
--     -- rect2.isAwake = true
--     -- rect2:setLinearVelocity(0.00000001, -0.00000001)
--     -- transition.to(camera, {x=camera.x-2, time=0})
--   elseif but2.press then
--     local x, y = rect2:getLinearVelocity()
--     rect2:setLinearVelocity(0, y)
--     rect2:applyLinearImpulse(-0.02, 0, rect2.x, rect2.y)
--     -- rect1:setLinearVelocity(50, 0)
--     -- rect3:setLinearVelocity(50, 0)
--     -- rect1.x = rect1.x + 2
--     -- rect3.x = rect3.x + 2
--     -- rect2.isAwake = true
--     -- rect2:setLinearVelocity(0.00000001, -0.00000001)
--     -- transition.to(camera, {x=camera.x+2, time=0})
--   end
-- end
--
-- Runtime:addEventListener('enterFrame', enterFrame)
--
-- local click = function(e)
--   if e.phase == 'began' then
--     display.getCurrentStage():setFocus(e.target)
--     e.target.press = true
--   elseif e.phase == 'ended' or e.phase == 'cancelled' then
--     display.getCurrentStage():setFocus(nil)
--     rect2:setLinearVelocity(0, 0)
--     e.target.press = false
--   end return true
-- end
--
-- but1:addEventListener('touch', click)
-- but2:addEventListener('touch', click)

-- physics.start ''
--
-- local a = display.newRect(_x, _y, 100, 100)
-- local b = display.newRect(_x, _y + 100, 500, 100)
-- b:setFillColor(0)
--
-- physics.addBody(a, 'dynamic', {bounce=0})
-- physics.addBody(b, 'static', {bounce=0})
--
-- local x, y = a:getLinearVelocity()
-- a:setLinearVelocity(1000, y)
-- -- a:applyLinearImpulse(1, 0, a.x, a.y)
-- timer.performWithDelay(100, function()
--   a:setLinearVelocity(0, y)
-- end)

-- local function onGlobalCollision(event)
--   print(json.prettify(event))
-- end
--
-- Runtime:addEventListener('collision', onGlobalCollision)

-- activity.physedit.table = {
--   import = 'nearest', box = '',
--   path = 'App/Основная группа.Бедрок.Бедрок'
-- } activity.physedit.view()

-- notifications.scheduleNotification(1, {alert = 'Охуеть =)'})

-- local xGravity = display.newText('xGravity:  0', 20, _y - 500, 'ubuntu.ttf', 50)
-- xGravity.anchorX = 0
--
-- local yGravity = display.newText('yGravity:  0', 20, _y - 400, 'ubuntu.ttf', 50)
-- yGravity.anchorX = 0
--
-- local zGravity = display.newText('zGravity:  0', 20, _y - 300, 'ubuntu.ttf', 50)
-- zGravity.anchorX = 0
--
-- local xInstant = display.newText('xInstant:  0', 20, _y - 100, 'ubuntu.ttf', 50)
-- xInstant.anchorX = 0
--
-- local yInstant = display.newText('yInstant:  0', 20, _y, 'ubuntu.ttf', 50)
-- yInstant.anchorX = 0
--
-- local zInstant = display.newText('zInstant:  0', 20, _y + 100, 'ubuntu.ttf', 50)
-- zInstant.anchorX = 0
--
-- local xRaw = display.newText('xRaw:  0', 20, _y + 300, 'ubuntu.ttf', 50)
-- xRaw.anchorX = 0
--
-- local yRaw = display.newText('yRaw:  0', 20, _y + 400, 'ubuntu.ttf', 50)
-- yRaw.anchorX = 0
--
-- local zRaw = display.newText('zRaw:  0', 20, _y + 500, 'ubuntu.ttf', 50)
-- zRaw.anchorX = 0
--
-- local round = function(num, count)
--   return tonumber(string.format('%.' .. count .. 'f', tostring(num)))
-- end
--
-- Runtime:addEventListener('accelerometer', function(event)
--   xGravity.text = round(event.xGravity, 2)
--   yGravity.text = round(event.yGravity, 2)
--   zGravity.text = round(event.zGravity, 2)
--   xInstant.text = round(event.xInstant, 2)
--   yInstant.text = round(event.yInstant, 2)
--   zInstant.text = round(event.zInstant, 2)
--   xRaw.text = round(event.xRaw, 2)
--   yRaw.text = round(event.yRaw, 2)
--   zRaw.text = round(event.zRaw, 2)
-- end)

-- local js = '{"data":{"text":"hello world"}}'
-- local at = {}
--
-- local jt = json.decode(js)
-- local jf
--
-- jf = function(at, t)
--   for i in pairs(t) do
--     if type(t[i]) == 'table' then
--       at[i] = {} jf(at[i], t[i])
--     elseif type(t[i]) == 'string' then
--       at[i] = {t[i], 'text'}
--     elseif type(t[i]) == 'number' then
--       at[i] = {tostring(t[i]), 'num'}
--     elseif type(t[i]) == 'boolean' then
--       at[i] = {tostring(t[i]), 'log'}
--     end
--   end
-- end jf(at, jt) print(json.prettify(at))

-- local jf = function(t)
--   for i in t do
--     if type(t[i]) == 'table' then
--       jf(t[i])
--     else
--       at[]
--     end
--   end
-- end jf(jt)

-- local path = system.pathForFile('build.sh', system.DocumentsDirectory)
-- local file = io.open(path, 'w')
-- local text = display.newText('text', _x, _y, nil, 30)

-- os.execute('CCODE=/data/data/com.ccode.test983/files/coronaResources & ls CCODE > "/sdcard/log.txt"')

-- local file = io.open('/sdcard/log.txt', 'w')
-- if file then
--   io.close(data)
--   file:write(data)
--   io.close(file)
-- end

-- os.execute('cp /data/data/com.ccode.test983/files/coronaResources/keytool /data/user/0/com.ccode.test983/app_data/keytool')
--
-- file:write([[#!/system/bin/sh
-- cd "/data/user/0/com.ccode.test983/app_data/"
-- KEYTOOL="/data/user/0/com.ccode.test983/app_data/keytool"
-- chmod 777 $KEYTOOL
-- $KEYTOOL > "/sdcard/log.txt"
-- $KEYTOOL 2> "/sdcard/error.txt"
-- ]])

-- file:write([[#!/system/bin/sh
-- JAVA="]] .. system.pathForFile('java', system.ResourcesDirectory) .. [["
-- XML2AXML="]] .. system.pathForFile('xml2axml.jar', system.ResourcesDirectory) .. [["
-- MANIFEST="]] .. system.pathForFile('AndroidManifest.xml', system.ResourcesDirectory) .. [["
-- JAVA_HOME="]] .. system.pathForFile('java', system.DocumentsDirectory) .. [["
-- XML2AXML_HOME="]] .. system.pathForFile('xml2axml.jar', system.DocumentsDirectory) .. [["
-- MANIFEST_HOME="]] .. system.pathForFile('AndroidManifest.xml', system.DocumentsDirectory) .. [["
-- NEW_MANIFEST_HOME="]] .. system.pathForFile('NewAndroidManifest.xml', system.DocumentsDirectory) .. [["
-- cp "${JAVA}" "${JAVA_HOME}"
-- cp "${XML2AXML}" "${XML2AXML_HOME}"
-- cp "${MANIFEST}" "${MANIFEST_HOME}"
-- "${JAVA_HOME}" -jar "${XML2AXML_HOME}" d "${MANIFEST_HOME}" "${NEW_MANIFEST_HOME}"
-- cp "${NEW_MANIFEST_HOME}" "/sdcard/Build/Manifest.xml"
-- ]])

-- print([[#!/system/bin/sh
-- ls /data/data/com.ccode.test983/files/coronaResources > "/sdcard/log.txt"
-- ]])

-- io.close(file)
--
-- if system.getInfo 'environment' ~= 'simulator' then
--   os.execute('/system/bin/sh "' .. path .. '"')
-- end

-- local f = 0
-- local a = false
-- local x, y = _x, _y
-- local t = {}
-- local s = display.newText('0', _x, _y - 400, 'ubuntu', 50)
-- local p = display.newText('fps: ', _x, _y - 500, 'ubuntu', 50)
-- local l, r = false, false
--
-- local snapshot = display.newSnapshot(10000, 10000)
-- snapshot:translate(_x, _y)
--
-- p:addEventListener('touch', function(e)
--   if e.phase == 'began' then l = true
--   elseif e.phase == 'ended' then l = false
--   end return true
-- end)
--
-- s:addEventListener('touch', function(e)
--   if e.phase == 'began' then r = true
--   elseif e.phase == 'ended' then r = false
--   end return true
-- end)
--
-- local a = display.newText('0', _x, _y, nil, 50)
-- timer.performWithDelay(1000, function() p.text, f = 'fps: ' .. f, 0 end, 0)
-- timer.performWithDelay(16.7, function() f = f + 1
--   for i = 1, 100000, 1 do
--     a.text = math.random(111111111, 999999999)
--   end
-- end, 0)
--
-- Runtime:addEventListener('enterFrame', function()
--   if r then
--     snapshot.x = snapshot.x + 5
--     snapshot:translate(_x, _y)
--   elseif l then
--     snapshot.x = snapshot.x - 5
--   end if a then for i = 1, 10 do
--     t[#t+1] = display.newCircle(x, y, 25)
--     snapshot.canvas:insert(t[#t])
--     -- snapshot.canvas:insert(t[#t])
--     snapshot:invalidate('canvas')
--     s.text = tostring(#t)
--   end end
-- end)
--
-- Runtime:addEventListener('touch', function(e)
--   x, y = e.x - snapshot.x, e.y - snapshot.y
--   if e.phase == 'began' then a = true
--   elseif e.phase == 'ended' then a = false
--   end return true
-- end)

-- input('Ваш deviceID', 'deviceID', function(e)
-- end, function(event)
-- end, system.getInfo('deviceID'))

-- local _box_ = native.newTextBox(_x, _y, _w - 20, 120)
-- _box_.text = system.getInfo('deviceID')
-- _box_.font = native.newFont('ubuntu', 50)
-- _box_.isEditable = true
-- _box_:addEventListener('userInput', function(e) if e.phase == 'editing' then e.target.text = e.oldText end end)

--[[
  gravityy
  gravityx
  speed
  angle
  startColor(Reg/Green/Blue/Alpha)
  finishColor(Reg/Green/Blue/Alpha)
]]

-- local emitter = particles.newEmitter('Emitter/giving.json', system.ResourceDirectory, 'Emitter/')
-- emitter.x, emitter.y = _x, _y

require 'Module.alert'
require 'Module.doc'
require 'Module.input'
require 'Module.list'
require 'Module.fsd'
require 'Module.blockList'
require 'Module.alertLocal'

require 'Module.paramsColorInBlocks'
require 'Module.updateTextLanguage'
require 'Module.returnModule'
require 'Module.moveBlock'
require 'Module.moveLogBlock'
require 'Module.newBlock'
require 'Module.listBlocks'
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
require 'Module.repository'
require 'Module.physEditor'
require 'Module.formulasEditor'

require 'Module.calc'
require 'Module.calcFun'
require 'Module.calcProp'
require 'Module.calcDevice'
require 'Module.game'
require 'Module.gameFormula1'
require 'Module.gameFormula2'
require 'Module.gameFormula3'
require 'Module.gameFormula4'
require 'Module.gameFormula5'

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

-- display.setDefault('background', .1, .2, .3)
--
-- display.newSnapshot(2000, 2000):translate(_x, _y)
--
-- timer.performWithDelay(1000, function()
--   display.setDefault('background', .3, .2, .3)
-- end)

-- Запуск
testersList = {
  ['dbfaf215e5f04d19'] = 'Версия Тестеров:  Лёня Ганин',
  ['3899216020f2cf4c'] = 'Версия Тестеров:  Danil Nik',
  ['eb27b7765273fd1a'] = 'Версия Тестеров:  Danil Nik',
  ['908e1f611a8c2b0a'] = 'Версия Тестеров:  Дмитрий Морозов',
  ['18b7ab196f5ecd23'] = 'Версия Тестеров:  Макс Кишкель',
  ['037a865ed3eb2266'] = 'Версия Тестеров:  Дмитрий Котов',
  ['637c8abb8ce1c7dd'] = 'Версия Тестеров:  Арен Елчинян',
  ['e42132d66d98f2f7'] = 'Версия Тестеров:  Максим Корпусов',
  ['fb2dd6b3c620ec2b'] = 'Версия Тестеров:  Алексей Полежаров',
  ['a9cbcc60541683c1'] = 'Версия Тестеров:  Алексей Полежаров',
  ['b69ae3492f4df904'] = 'Версия Тестеров:  Александр Вайлюк-Каурцев',
  ['651df389613d7eed8462832d8624a41d'] = 'Версия Тестеров:  Лёня Ганин'
} composer.gotoScene 'Module.menu'
