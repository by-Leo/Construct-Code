local composer = require 'composer'

local scene = composer.newScene()

local bg
local title
local vktg
local myprogrambut, myprogramtext
local donatebut, donatetext
local settingsbut, settingstext
local buildtext
--[[ Номер билда ]] buildVersion = 968

function visibleMenu(visible)
  bg.isVisible = visible
  -- snowflakes.isVisible = visible
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

function openHiddenTesting()
  title.text = 'Construct Code\n   Hidden Test'
  title.y = _y - _aY + 222
  buildtext.text = 'Build: Test'
end

function scene:create( event )
    local sceneGroup = self.view

    bg = display.newImage(sceneGroup, 'Image/menu.png')
      bg.x = _x
      bg.y = _y - _tH / 2
      bg.width = _aW
      bg.height = _aH + _tH

    -- snowflakes = display.newImage(sceneGroup, 'Image/snowflakes.png')
    --   snowflakes.x = _x
    --   snowflakes.y = _y
    --   snowflakes.alpha = 0.5

    title = display.newText(sceneGroup, 'Construct Code', _x, _y - _aY + 182, 'ubuntu_!bold.ttf', 60)

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
          visibleMenu(false)
          if settings.lastApp == '' then activity.programs.create()
          else activity.onClickButton.programs.block({target={text={text=settings.lastApp}}}) end
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
    activity.programs.create()
    activity.programs.hide()
end

scene:addEventListener('create', scene)
return scene
