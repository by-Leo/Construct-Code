local composer = require 'composer'

local scene = composer.newScene()

local bg
local title
local vktg
local myprogrambut, myprogramtext
local donatebut, donatetext
local settingsbut, settingstext
local buildtext
--[[ Номер билда ]] buildVersion = 931

function visibleMenu(visible)
  bg.isVisible = visible
  snowflakes.isVisible = visible
  title.isVisible = visible
  vktg.isVisible = visible
  myprogrambut.isVisible = visible
  myprogramtext.isVisible = visible
  donatebut.isVisible = visible
  donatetext.isVisible = visible
  settingsbut.isVisible = visible
  settingstext.isVisible = visible
  buildtext.isVisible = visible
  delimiter1.isVisible = visible
  delimiter2.isVisible = visible
  myprogramtext.text = strings.myProgramText
  settingstext.text = strings.settingsText
  donatetext.text = settings.lastApp
  testtext = display.newText({text = settings.lastApp, font = 'ubuntu_!bold.ttf', fontSize = 40, x = _x, y = _y - 200, align = 'center', width = 380})
  if testtext.height > 100 then donatetext.anchorY = 0.54 elseif testtext.height > 50 then donatetext.anchorY = 0.36 else donatetext.anchorY = 0.18 end
  if donatetext.text == '' then donatetext.text = strings.continueText end
  testtext:removeSelf()
end

function scene:create( event )
    local sceneGroup = self.view

    bg = display.newImage(sceneGroup, 'Image/menu.png')
      bg.x = _x
      bg.y = _y - _tH / 2
      bg.width = _aW
      bg.height = _aH + _tH

    snowflakes = display.newImage(sceneGroup, 'Image/snowflakes.png')
      snowflakes.x = _x
      snowflakes.y = _y
      snowflakes.alpha = 0.5

    title = display.newText(sceneGroup, '🎄Construct Code🎄', _x, _y - _aY + 182, 'ubuntu_!bold.ttf', 60)

    vktg = display.newImage(sceneGroup, 'Image/vk.png')
      vktg.x = _x - _aX + 95 - 48
      vktg.y = _y + _aY - 65

    myprogrambut = display.newImage(sceneGroup, 'Image/menubut.png')
      myprogrambut.x = _x
      myprogrambut.y = _y
      myprogrambut.alpha = 0.9
      myprogrambut.width = 396
      myprogrambut.height = 138
      myprogramtext = display.newText(sceneGroup, strings.myProgramText, _x, _y, 'ubuntu_!bold.ttf', 42)

    delimiter1 = display.newRect(sceneGroup, _x, _y - 100, 300, 5)
    delimiter1:setFillColor(0.3)

    donatebut = display.newImage(sceneGroup, 'Image/menubut.png')
      donatebut.x = _x
      donatebut.y = _y - 200
      donatebut.alpha = 0.9
      donatebut.width = 396
      donatebut.height = 138
      donatetext = display.newText({parent = sceneGroup, text = settings.lastApp, font = 'ubuntu_!bold.ttf', fontSize = 40, x = _x, y = _y - 200, width = 380, height = 136, align = 'center'})
      testtext = display.newText({text = settings.lastApp, font = 'ubuntu_!bold.ttf', fontSize = 40, x = _x, y = _y - 200, align = 'center', width = 380})
      if testtext.height > 100 then donatetext.anchorY = 0.54 elseif testtext.height > 50 then donatetext.anchorY = 0.36 else donatetext.anchorY = 0.18 end
      if donatetext.text == '' then donatetext.text = strings.continueText end
      testtext:removeSelf()

    delimiter2 = display.newRect(sceneGroup, _x, _y + 100, 300, 5)
    delimiter2:setFillColor(0.3)

    settingsbut = display.newImage(sceneGroup, 'Image/menubut.png')
      settingsbut.x = _x
      settingsbut.y = _y + 200
      settingsbut.alpha = 0.9
      settingsbut.width = 396
      settingsbut.height = 138
      settingstext = display.newText(sceneGroup, strings.settingsText, _x, _y + 200, 'ubuntu_!bold.ttf', 42)

    buildtext = display.newText(sceneGroup, 'Build: ' .. buildVersion, _x + _aX - 120, _y + _aH / 2 - 65, 'sans_light.ttf', 27)

    myprogrambut:addEventListener('touch', function(e)
      if not alertActive then
        if e.phase == 'began' then
          display.getCurrentStage():setFocus( e.target )
          e.target.alpha = 0.5
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
          display.getCurrentStage():setFocus( nil )
          e.target.alpha = 0.9
          visibleMenu(false)
          activity.programs.create()
        end
      end
    end)

    donatebut:addEventListener('touch', function(e)
      if not alertActive then
        if e.phase == 'began' then
          display.getCurrentStage():setFocus( e.target )
          e.target.alpha = 0.5
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
          display.getCurrentStage():setFocus( nil )
          e.target.alpha = 0.9
          if settings.lastApp == '' then
            visibleMenu(false)
            activity.programs.create()
          else
            visibleMenu(false)
            activity.programs.create()
            activity.programs.name = settings.lastApp
            activity.programs.hide()
            activity.scenes.create()
          end
        end
      end
    end)

    settingsbut:addEventListener('touch', function(e)
      if not alertActive then
        if e.phase == 'began' then
          display.getCurrentStage():setFocus( e.target )
          e.target.alpha = 0.5
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
          display.getCurrentStage():setFocus( nil )
          e.target.alpha = 0.9
          visibleMenu(false)
          setting.show()
        end
      end
    end)

    vktg:addEventListener('touch', function(e)
      if not alertActive then
        if e.phase == 'began' then
          display.getCurrentStage():setFocus( e.target )
          e.target.alpha = 0.5
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
          display.getCurrentStage():setFocus( nil )
          e.target.alpha = 0.9

          system.openURL 'https://m.vk.com/constructcode'

          -- local function onComplete( event )
          --   if event.num == 1 then
          --     if system.getInfo 'platform' == 'android' then
          --       system.openURL( 'https://m.vk.com/constructcode' )
          --     else
          --       system.openURL( 'https://vk.com/constructcode' )
          --     end
          --   elseif event.num == 2 then
          --     system.openURL( 'https://t-do.ru/constructcode' )
          --   end
          -- end
          --
          -- alert(strings.social, strings.socialText, {strings.vk, strings.tg}, onComplete)
        end
      end
    end)

    activity.downloadApp = {}
    if settings.lastApp ~= '' then
      local rectDownloadApp = display.newRect(_x, _y, 600, 200)
      rectDownloadApp:setFillColor(0.18, 0.18, 0.2)

      local rectDownloadAppShadow = display.newRect(_x, _y, _aW, _aH)
      rectDownloadAppShadow:setFillColor(0, 0.005)

      local rectDownloadAppText = display.newText({
        text = 'Подождите, пожалуйста. Идёт подгрузка последнего открытого приложения для более удобной работы (можно отключить в настройках): ' .. settings.lastApp,
        font = 'ubuntu_!bold.ttf', fontSize = 30, width = 560, x = _x - 280, y = _y - 80
      })

      activity.downloadApp[1] = settings.lastApp
      rectDownloadApp.height = rectDownloadAppText.height + 40
      rectDownloadAppText.anchorX, rectDownloadAppText.anchorY = 0, 0
      rectDownloadAppText.y = _y - rectDownloadApp.height / 2 + 20

      rectDownloadAppShadow:addEventListener('touch', function(e)
        if e.phase == 'began' then display.getCurrentStage():setFocus(e.target)
        elseif e.phase == 'ended' then display.getCurrentStage():setFocus(nil)
        end return true
      end)

      timer.performWithDelay(1, function()
        activity.programs.create()
        activity.programs.name = settings.lastApp
        activity.programs.hide()
        activity.resources.create()
        activity.resources.hide()
        activity.scenes.create()
        activity.scenes.hide()
        for i = 1, #activity.scenes[activity.programs.name].block do
          activity.scenes.name = activity.programs.name .. '.' .. activity.scenes[activity.programs.name].block[i].text.text
          activity.scenes.scene = activity.scenes[activity.programs.name].block[i].text.text
          -- rectDownloadAppText.text = rectDownloadAppText.text .. '\nПодгрузка сцены (' .. i .. '): ' .. activity.scenes.scene
          activity.objects.create()
          activity.objects.hide()
          for j = 1, #activity.objects[activity.scenes.name].block do
            activity.objects.name = activity.scenes.name .. '.' .. activity.objects[activity.scenes.name].block[j].text.text
            activity.objects.texture = activity.objects.name
            activity.objects.object = activity.objects[activity.scenes.name].block[j].text.text
            -- rectDownloadAppText.text = rectDownloadAppText.text .. '\nПодгрузка объекта (' .. j .. '): ' .. activity.objects.object
            -- rectDownloadAppText.text = rectDownloadAppText.text .. '\nПодгрузка текстур объекта (' .. j .. '): ' .. activity.objects.object
            activity.textures.create()
            activity.textures.hide()
            -- rectDownloadAppText.text = rectDownloadAppText.text .. '\nПодгрузка блоков объекта (' .. j .. '): ' .. activity.objects.object
            activity.blocks.create()
            activity.blocks.hide()
          end
        end
        alertActive = false
        rectDownloadApp:removeSelf()
        rectDownloadAppText:removeSelf()
        timer.performWithDelay(1, function() rectDownloadAppShadow:removeSelf() end)
        activity.scenes.name, activity.scenes.scene, activity.programs.name = '', '', ''
        activity.objects.name, activity.objects.texture, activity.objects.object = '', '', ''
        -- timer.performWithDelay(2, function()
        --   visibleMenu(false)
        --   activity.game.startProject()
          -- activity.programs.create()
          -- activity.programs.name = 'App'
          -- activity.programs.hide()
        --   activity.scenes.create()
        --   activity.scenes.hide()
        --   activity.scenes.name = 'App.Основная группа'
        --   activity.scenes.scene = 'Основная группа'
        --   activity.scenes.hide()
        --   activity.objects.create()
        --   activity.objects.name = 'App.Основная группа.Гусь'
        --   activity.objects.object = 'Гусь'
        --   activity.objects.hide()
        --   activity.blocks.create()
          -- activity.objects.texture = 'App.Основная группа.Гусь'
          -- activity.textures.create()
          -- activity.blocks['App.Основная группа.Гусь'].block[2].data.params[1]
          -- activity.blocks.hide()
          -- activity.editor.table = {{2, 2}}
          -- for u = 1, #activity.blocks[activity.objects.name].block[2].data.params[2] do
          --   activity.editor.table[#activity.editor.table+1] = table.copy(activity.blocks[activity.objects.name].block[2].data.params[2][u])
          -- end
          -- activity.editor.group.isVisible = true
          -- activity.editor.newText()
          -- activity.editor.genBlock()
        -- end)
      end)
    else
      alertActive = false
      activity.programs.create()
      activity.programs.hide()
    end
end

scene:addEventListener('create', scene)
return scene
