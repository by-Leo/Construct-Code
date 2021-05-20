cprop = {}

cprop.angular_velocity = function()
  return [[
    function angular_velocity(exp)
      if not exp then
        if game.objects[indexScene][indexObject].data.physics.body ~= '' then
          return game.objects[indexScene][indexObject].angularVelocity
        end
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            if game.objects[indexScene][i].data.physics.body ~= '' then
              return game.objects[indexScene][i].angularVelocity
            end
          end
        end
      elseif game.shapes[exp] then
        if game.shapes[exp].data.physics.body ~= '' then
          return game.shapes[exp].angularVelocity
        end
      end
    end
  ]]
end

cprop.velocity_y = function()
  return [[
    function velocity_y(exp)
      if not exp then
        if game.objects[indexScene][indexObject].data.physics.body ~= '' then
          return select(2, game.objects[indexScene][indexObject]:getLinearVelocity())
        end
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            if game.objects[indexScene][i].data.physics.body ~= '' then
              select(2, game.objects[indexScene][i]:getLinearVelocity())
            end
          end
        end
      elseif game.shapes[exp] then
        if game.shapes[exp].data.physics.body ~= '' then
          return select(2, game.shapes[exp]:getLinearVelocity())
        end
      end
    end
  ]]
end

cprop.velocity_x = function()
  return [[
    function velocity_x(exp)
      if not exp then
        if game.objects[indexScene][indexObject].data.physics.body ~= '' then
          return select(1, game.objects[indexScene][indexObject]:getLinearVelocity())
        end
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            if game.objects[indexScene][i].data.physics.body ~= '' then
              select(1, game.objects[indexScene][i]:getLinearVelocity())
            end
          end
        end
      elseif game.shapes[exp] then
        if game.shapes[exp].data.physics.body ~= '' then
          return select(1, game.shapes[exp]:getLinearVelocity())
        end
      end
    end
  ]]
end

cprop.click = function()
  return [[
    function click(exp)
      if not exp then
        return game.objects[indexScene][indexObject].data.click
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            return game.objects[indexScene][i].data.click
          end
        end
      elseif game.shapes[exp] then
        return game.shapes[exp].data.click
      end
    end
  ]]
end

cprop.get_text = function()
  return [[
    function get_text(exp)
      if game.texts[exp] then
        return game.texts[exp].text
      end return ''
    end
  ]]
end

cprop.current_len_video = function()
  return [[
    function current_len_video(exp)
      if game.videos[exp] then
        return game.videos[exp].currentTime
      end return 0
    end
  ]]
end

cprop.total_len_video = function()
  return [[
    function total_len_video(exp)
      if game.videos[exp] then
        return game.videos[exp].totalTime
      end return 0
    end
  ]]
end

cprop.current_len_sound = function()
  return [[
    function current_len_sound(exp)
      if game.sounds[exp] then
        return game.sounds[exp].audio.getVolume()*100
      end return 0
    end
  ]]
end

cprop.total_len_sound = function()
  return [[
    function total_len_sound(exp)
      if game.sounds[exp] then
        return game.sounds[exp].audio.getDuration()*1000
      end return 0
    end
  ]]
end

cprop.tag = function()
  return [[
    function tag(exp)
      if not exp then
        return game.objects[indexScene][indexObject].data.tag
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            return game.objects[indexScene][i].data.tag
          end
        end
      elseif game.shapes[exp] then
        return game.shapes[exp].data.tag
      end
    end
  ]]
end

cprop.index_texture = function()
  return [[
    function name_texture(exp)
      if not exp then
        for j = 1, #game.objects[indexScene][indexObject].data.textures do
          if game.objects[indexScene][indexObject].data.textures[j] ==
          game.objects[indexScene][indexObject].data.texture then return j end
        end return 1
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            for j = 1, #game.objects[indexScene][i].data.textures do
              if game.objects[indexScene][i].data.textures[j] ==
              game.objects[indexScene][i].data.texture then return j end
            end return 1
          end
        end
      elseif game.shapes[exp] then
        for j = 1, #game.objects[indexScene][game.shapes[exp].data.obj_id].data.textures do
          if game.objects[indexScene][game.shapes[exp].data.obj_id].data.textures[j] ==
          game.shapes[exp].data.texture then return j end
        end return 1
      end
    end
  ]]
end

cprop.name_texture = function()
  return [[
    function name_texture(exp)
      if not exp then
        return game.objects[indexScene][indexObject].data.texture
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            return game.objects[indexScene][i].data.texture
          end
        end
      elseif game.shapes[exp] then
        return game.shapes[exp].data.texture
      end
    end
  ]]
end

cprop.alpha = function()
  return [[
    function alpha(exp)
      if not exp then
        return game.objects[indexScene][indexObject].alpha * 100
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            return game.objects[indexScene][i].alpha * 100
          end
        end
      elseif game.shapes[exp] then
        return game.shapes[exp].alpha * 100
      end
    end
  ]]
end

cprop.rotation = function()
  return [[
    function rotation(exp)
      if not exp then
        return game.objects[indexScene][indexObject].rotation
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            return game.objects[indexScene][i].rotation
          end
        end
      elseif game.shapes[exp] then
        return game.shapes[exp].rotation
      end
    end
  ]]
end

cprop.pos_z = function()
  return [[
    function pos_z(exp)
      if not exp then
        return game.objects[indexScene][indexObject].z
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            return game.objects[indexScene][i].z
          end
        end
      elseif game.shapes[exp] then
        return game.shapes[exp].z
      end
    end
  ]]
end

cprop.pos_y = function()
  return [[
    function pos_y(exp)
      if not exp then
        return game.objects[indexScene][indexObject].y
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            return game.objects[indexScene][i].y
          end
        end
      elseif game.shapes[exp] then
        return game.shapes[exp].y
      end
    end
  ]]
end

cprop.pos_x = function()
  return [[
    function pos_x(exp)
      if not exp then
        return game.objects[indexScene][indexObject].x
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            return game.objects[indexScene][i].x
          end
        end
      elseif game.shapes[tostring(exp)] then
        return game.shapes[tostring(exp)].x
      end
    end
  ]]
end

cprop.height = function()
  return [[
    function height(exp)
      if not exp then
        return game.objects[indexScene][indexObject].height
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            return game.objects[indexScene][i].height
          end
        end
      elseif game.shapes[exp] then
        return game.shapes[exp].height
      end
    end
  ]]
end

cprop.width = function()
  return [[
    function width(exp)
      if not exp then
        return game.objects[indexScene][indexObject].width
      elseif type(exp) == 'table' then
        for i = 1, #game.objects[indexScene] do
          if game.objects[indexScene][i].name == exp[1] then
            return game.objects[indexScene][i].width
          end
        end
      elseif game.shapes[exp] then
        return game.shapes[exp].width
      end
    end
  ]]
end
