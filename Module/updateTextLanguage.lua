activity.updateTextLanguage = function(i)
  setting.title.text = strings.settingsTitle
  -- setting.stdImportText.text = strings.settingsStdImport
  -- setting.pictureViewText.text = strings.settingsPictureView
  setting.languageText.text = strings.settingsLanguage
  setting.selfLanguageText.text = stringsLanguage.langs[i][2]

  activity.programs.title.text = strings.programsTitle
  activity.scenes.title.text = strings.scenesTitle
  activity.objects.title.text = strings.objectsTitle
  activity.textures.title.text = strings.texturesTitle
  activity.blocks.title.text = strings.blocksTitle
  activity.editor.title.text = strings.editorTitle

  if activity.blocks[activity.objects.name] then
    for i = 1, #activity.blocks[activity.objects.name].block do
      activity.blocks[activity.objects.name].block[i].text.text = strings.blocks[activity.blocks[activity.objects.name].block[i].data.name][1]
      for j = 1, #activity.blocks[activity.objects.name].block[i].params do
        activity.blocks[activity.objects.name].block[i].params[j].name.text = strings.blocks[activity.blocks[activity.objects.name].block[i].data.name][2][j]
        activity.blocks[activity.objects.name].block[i].params[j].text.text = getTextParams(i, j)
      end
    end
  end

  activity.editor.buttons[1].text.text = strings.editorInputText
  activity.editor.buttons[2].text.text = strings.editorInputLocal
  activity.editor.buttons[24].text.text = strings.buttonInput

  for i = 1, 7 do
    activity.editor.listTitle[i].text.text = select(1, editorGetListTitle(i))
  end

  local typeblocks = {'event', 'data', 'object', 'copy', 'control', 'network', 'physics', 'physicscopy', 'not1', 'not2', 'not3', 'not4'}
  for i = 1, #typeblocks do
    activity.newblocks[typeblocks[i]].text.text = strings['type' .. typeblocks[i]]
    if typeblocks[i] ~= 'not' then
      for j = 1, #activity.newblocks[typeblocks[i]].blocks do
        activity.newblocks[typeblocks[i]].blocks[j].text.text = strings.blocks[activity.typeFormulas[typeblocks[i]][j]][1]
      end
    end
  end
end
