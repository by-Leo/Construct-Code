setting = {}

setting.lib = display.newGroup()

setting.bg = display.newImage(setting.lib, 'Image/bg.png')
setting.bg.x = _x
setting.bg.y = _y - _tH / 2
setting.bg.width = _aW
setting.bg.height = _aH + _tH

setting.bg:addEventListener('touch', function(e)
  if e.phase == 'began' then
    display.getCurrentStage():setFocus(e.target)
  elseif e.phase == 'ended' or e.phase == 'cancelled' then
    display.getCurrentStage():setFocus(nil)
    setting.scroll.isVisible = false
  end
  return true
end)

setting.title = display.newText(setting.lib, strings.settingsTitle, _x, _y - _aY + 90, 'ubuntu_!bold.ttf', 58)

-- setting.stdImportText = display.newText(strings.settingsStdImport, 30, _y - _aY + 200, 'ubuntu_!bold.ttf', 36)
-- setting.stdImportText.anchorX = 0
--
-- setting.stdImportCheckbox = widget.newSwitch({
--   x = 640, y = _y - _aY + 200, style = 'checkbox', width = 75, height = 75,
--   onPress = function(event)
--     settings.stdImport = event.target.isOn
--     settingsSave()
--
--     setting.pictureViewText.isVisible = true
--     setting.pictureViewCheckbox.isVisible = true
--     setting.languageText.y = _y - _aY + 400
--     setting.languageButton.y = _y - _aY + 400
--     setting.selfLanguageText.y = _y - _aY + 400
--     setting.scroll.y = _y - _aY + 400 + 70 * #stringsLanguage.langs / 2 - 30
--
--     if settings.stdImport then
--       setting.pictureViewText.isVisible = false
--       setting.pictureViewCheckbox.isVisible = false
--       setting.languageText.y = _y - _aY + 300
--       setting.languageButton.y = _y - _aY + 300
--       setting.selfLanguageText.y = _y - _aY + 300
--       setting.scroll.y = _y - _aY + 300 + 70 * #stringsLanguage.langs / 2 - 30
--     end
--   end
-- })
--
-- setting.pictureViewText = display.newText(strings.settingsPictureView, 30, _y - _aY + 300, 'ubuntu_!bold.ttf', 36)
-- setting.pictureViewText.anchorX = 0
--
-- setting.pictureViewCheckbox = widget.newSwitch({
--   x = 640, y = _y - _aY + 300, style = 'checkbox', width = 75, height = 75,
--   onPress = function(event)
--     settings.pictureView = event.target.isOn
--     settingsSave()
--   end
-- })

setting.languageButton = display.newRect(_x + 175, _y - _aY + 400, 225, 60)
setting.languageButton:setFillColor(0, 0, 0, 0.005)

setting.languageButton:addEventListener('touch', function(e)
  if e.phase == 'began' then
    display.getCurrentStage():setFocus(e.target)
    e.target:setFillColor(0.18, 0.18, 0.2)
  elseif e.phase == 'ended' or e.phase == 'cancelled' then
    display.getCurrentStage():setFocus(nil)
    e.target:setFillColor(0, 0, 0, 0.005)
    setting.scroll.isVisible = true
  end
  return true
end)

setting.languageText = display.newText(strings.settingsLanguage, 30, _y - _aY + 200, 'ubuntu_!bold.ttf', 36)
setting.languageText.anchorX = 0

setting.selfLanguageText = display.newText(settings.language, _x + 175, _y - _aY + 200, 'ubuntu_!bold.ttf', 36)

setting.scroll = widget.newScrollView({
  x = _x + 175,
  y = _y - _aY + 200 + 70 * #stringsLanguage.langs / 2 - 30,
  width = 225,
  height = 70 * #stringsLanguage.langs,
  hideBackground = true,
  hideScrollBar = true,
  horizontalScrollDisabled = true,
  isBounceEnabled = true,
  listener = function(e)
    return true
  end
})

local rect = display.newRect(112.5, _y - _aY + 70 * #stringsLanguage.langs / 2, 225, 70 * #stringsLanguage.langs + 5000)
rect:setFillColor(0.2, 0.2, 0.22)
setting.scroll:insert(rect)

for i = 1, #stringsLanguage.langs do
  local but = display.newRect(112.5, 35 + 70 * (i-1) , 225, 70)
  but:setFillColor(0.2, 0.2, 0.22)

  local text = display.newText({
    text = stringsLanguage.langs[i][2], width = 200, height = 44, align = 'center',
    fontSize = 36, x = 112.5, y = 35 + 70 * (i-1), font = 'ubuntu_!bold.ttf'
  })

  if stringsLanguage.langs[i][1] == settings.language then setting.selfLanguageText.text = stringsLanguage.langs[i][2] end

  setting.scroll:insert(but)
  setting.scroll:insert(text)

  but:addEventListener('touch', function(e)
    if e.phase == 'began' then
      display.getCurrentStage():setFocus(e.target)
      e.target:setFillColor(0.22, 0.22, 0.24)
    elseif e.phase == 'moved' then
      local dy = math.abs(e.y - e.yStart)
      if dy > 20 then
        setting.scroll:takeFocus(e)
        e.target:setFillColor(0.2, 0.2, 0.22)
      end
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
      display.getCurrentStage():setFocus(nil)
      e.target:setFillColor(0.2, 0.2, 0.22)
      setting.scroll.isVisible = false

      settings.language = stringsLanguage.langs[i][1]
      strings = stringsLanguage[settings.language]
      settingsSave()

      activity.updateTextLanguage(i)
    end
    return true
  end)
end

setting.scroll:setScrollHeight(70 * #stringsLanguage.langs)
setting.scroll.isVisible = false

-- setting.lib:insert(setting.stdImportText)
-- setting.lib:insert(setting.stdImportCheckbox)
-- setting.lib:insert(setting.pictureViewText)
-- setting.lib:insert(setting.pictureViewCheckbox)
setting.lib:insert(setting.languageText)
setting.lib:insert(setting.languageButton)
setting.lib:insert(setting.selfLanguageText)
setting.lib:insert(setting.scroll)

setting.show = function()
  setting.lib.isVisible = true
  -- setting.stdImportCheckbox:setState({isOn=settings.stdImport})
  -- setting.pictureViewCheckbox:setState({isOn=settings.pictureView})

  -- setting.pictureViewText.isVisible = true
  -- setting.pictureViewCheckbox.isVisible = true
  setting.languageText.y = _y - _aY + 200
  setting.languageButton.y = _y - _aY + 200
  setting.selfLanguageText.y = _y - _aY + 200
  setting.scroll.y = _y - _aY + 200 + 70 * #stringsLanguage.langs / 2 - 30

  -- if settings.stdImport then
  --   setting.pictureViewText.isVisible = false
  --   setting.pictureViewCheckbox.isVisible = false
  --   setting.languageText.y = _y - _aY + 300
  --   setting.languageButton.y = _y - _aY + 300
  --   setting.selfLanguageText.y = _y - _aY + 300
  --   setting.scroll.y = _y - _aY + 300 + 70 * #stringsLanguage.langs / 2 - 30
  -- end
end

local function onKeyEventSettings( event )
  if (event.keyName == 'back' or event.keyName == 'escape') and not alertActive and event.phase == 'up' and setting.lib.isVisible then
    setting.scroll.isVisible = false
    setting.lib.isVisible = false
    visibleMenu(true)
  end
  return true
end
Runtime:addEventListener( 'key', onKeyEventSettings )
