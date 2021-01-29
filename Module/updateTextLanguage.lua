activity.updateTextLanguage = function(i)
  setting.title.text = strings.settingsTitle
  -- setting.stdImportText.text = strings.settingsStdImport
  -- setting.pictureViewText.text = strings.settingsPictureView
  setting.languageText.text = strings.settingsLanguage
  setting.selfLanguageText.text = stringsLanguage.langs[i][2]

  activity.programs.title.text = strings.programsTitle
  activity.scenes.title.text = strings.scenesTitle
  activity.resources.title.text = strings.resourcesTitle
  activity.objects.title.text = strings.objectsTitle
  activity.textures.title.text = strings.texturesTitle
  activity.blocks.title.text = strings.blocksTitle
  activity.editor.title.text = strings.editorTitle

  if activity.programs['nil'] then
    for p = 1, #activity.programs['nil'].block do
      pName = activity.programs['nil'].block[p].text.text
      if activity.scenes[pName] then
        for s = 1, #activity.scenes[pName].block do
          sName = pName .. '.' .. activity.scenes[pName].block[s].text.text
          if activity.objects[sName] then
            for o = 1, #activity.objects[sName].block do
              oName = sName .. '.' .. activity.objects[sName].block[o].text.text
              activity.objects.name = oName
              if activity.blocks[oName] then
                for i = 1, #activity.blocks[oName].block do
                  activity.blocks[oName].block[i].text.text = strings.blocks[activity.blocks[oName].block[i].data.name][1]
                  for j = 1, #activity.blocks[oName].block[i].params do
                    local oldX = activity.blocks[oName].block[i].params[j].name.x
                    local oldY = activity.blocks[oName].block[i].params[j].name.y
                    local oldAdditionX = activity.blocks[oName].block[i].params[j].name.additionX
                    local oldAdditionY = activity.blocks[oName].block[i].params[j].name.additionY

                    activity.blocks[oName].block[i].params[j].name:removeSelf()

                    local textGetHeight = display.newText({
                      text = strings.blocks[activity.blocks[oName].block[i].data.name][2][j], align = 'left',
                      x = 0, y = 0, font = 'ubuntu_!bold.ttf', fontSize = 22, width = 161
                    })

                    if textGetHeight.height > 53 then textGetHeight.height = 53 end

                    activity.blocks[oName].block[i].params[j].name = display.newText({
                      text = strings.blocks[activity.blocks[oName].block[i].data.name][2][j], align = 'left', height = textGetHeight.height,
                      x = oldX, y = oldY, font = 'ubuntu_!bold.ttf', fontSize = 22, width = 150
                    })
                    activity.blocks[oName].block[i].params[j].name.additionX = oldAdditionX
                    activity.blocks[oName].block[i].params[j].name.additionY = oldAdditionY

                    textGetHeight:removeSelf()

                    activity.blocks[oName].block[i].params[j].text.text = getTextParams(i, j)
                    activity.blocks[oName].scroll:insert(activity.blocks[oName].block[i].params[j].name)
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  activity.editor.buttons[1].text.text = strings.editorInputText
  activity.editor.buttons[2].text.text = strings.editorInputLocal
  activity.editor.buttons[24].text.text = strings.buttonInput

  for i = 1, 7 do
    activity.editor.listTitle[i].text.text = select(1, editorGetListTitle(i))
  end

  local typeblocks = {'event', 'data', 'object', 'controlother', 'control', 'network', 'physics', 'not'}
  for i = 1, #typeblocks do
    activity.newblocks[typeblocks[i]].text.text = strings['type' .. typeblocks[i]]
    if utf8.sub(typeblocks[i], 1, 3) ~= 'not' then
      for j = 1, #activity.newblocks[typeblocks[i]].blocks do
        activity.newblocks[typeblocks[i]].blocks[j].text.text = strings.blocks[activity.typeFormulas[typeblocks[i]][j]][1]
      end
    end
  end
end
