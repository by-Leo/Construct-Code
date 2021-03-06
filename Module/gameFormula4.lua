frm.createBody = function(indexScene, indexObject)
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then frm.removeBody(indexScene, indexObject) end
  if game.objects[indexScene][indexObject].width > 0 and game.objects[indexScene][indexObject].height > 0 then
    local hitbox = table.copy(game.objects[indexScene][indexObject].data.physics.hitbox)
    local _hitbox, x_hitbox = {}, true
    local paramsbody = {{
      bounce = game.objects[indexScene][indexObject].data.physics.bounce,
      density = game.objects[indexScene][indexObject].data.physics.density,
      friction = game.objects[indexScene][indexObject].data.physics.friction
    }}

    if hitbox and hitbox[2] == 'box' then
      local width1 = game.objects[indexScene][indexObject].width
      local width2 = game.objects[indexScene][indexObject].data.width
      local height1 = game.objects[indexScene][indexObject].height
      local height2 = game.objects[indexScene][indexObject].data.height
      local resizeWidth = width1 / width2
      local resizeHeight = height1 / height2

      for j = 1, #hitbox[1] do _hitbox[j] = {}
        for i = 1, #hitbox[1][j] do
          if x_hitbox then x_hitbox = false
            _hitbox[j][i] = hitbox[1][j][i] * resizeWidth
          else x_hitbox = true
            _hitbox[j][i] = hitbox[1][j][i] * resizeHeight
          end
        end
      end hitbox[1] = _hitbox

      for i = 2, #hitbox[1] do
        paramsbody[i] = {
          bounce = game.objects[indexScene][indexObject].data.physics.bounce,
          density = game.objects[indexScene][indexObject].data.physics.density,
          friction = game.objects[indexScene][indexObject].data.physics.friction,
          shape = hitbox[1][i]
        }
      end paramsbody[1].shape = hitbox[1][1]
    elseif hitbox and hitbox[2] == 'mesh' then
      local texture = game.objects[indexScene][indexObject].data.texture
      local path, basedir = game.objects[indexScene][indexObject].data.path, game.basedir
      if utf8.sub(texture, 1, 1) == '.' then basedir = system.TemporaryDirectory end

      local outline = graphics.newOutline(tonumber(hitbox[1]), path .. texture, basedir)
      paramsbody[1].outline = outline
    elseif hitbox and hitbox[2] == 'radius' then paramsbody[1].radius = tonumber(hitbox[1]) end

    physics.addBody(game.objects[indexScene][indexObject], game.objects[indexScene][indexObject].data.physics.body, unpack(paramsbody))

    game.objects[indexScene][indexObject].isSensor = game.objects[indexScene][indexObject].data.physics.sensor
    game.objects[indexScene][indexObject].isBullet = game.objects[indexScene][indexObject].data.physics.bullet
    game.objects[indexScene][indexObject].gravityScale = game.objects[indexScene][indexObject].data.physics.gravityScale
    game.objects[indexScene][indexObject].isFixedRotation = game.objects[indexScene][indexObject].data.physics.fixedRotation
  end
end

frm.setBody = function(indexScene, indexObject, params, localtable)
  local body = params[1][1] and params[1][1][1] or ''
  local density = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local bounce = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local friction = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))

  game.objects[indexScene][indexObject].data.physics.body = body == 'staticBody' and 'static' or 'dynamic'
  game.objects[indexScene][indexObject].data.physics.bounce = bounce[2] == 'num' and bounce[1] or 1
  game.objects[indexScene][indexObject].data.physics.density = density[2] == 'num' and density[1] or 0
  game.objects[indexScene][indexObject].data.physics.friction = friction[2] == 'num' and friction[1] or -1

  frm.createBody(indexScene, indexObject)
end

frm.removeBody = function(indexScene, indexObject, params, localtable)
  pcall(function() physics.removeBody(game.objects[indexScene][indexObject]) end)
end

frm.updHitbox = function(indexScene, indexObject, params, localtable)
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    frm.createBody(indexScene, indexObject)
  end
end

frm.setNewBody = function(indexScene, indexObject, params, localtable)
  local body = params[1][1] and params[1][1][1] or ''

  body = body == 'staticBody' and 'static' or 'dynamic'
  game.objects[indexScene][indexObject].data.physics.body = body
  game.objects[indexScene][indexObject].bodyType = body
end

frm.setGravity = function(indexScene, indexObject, params, localtable)
  local gravityScale = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  gravityScale = gravityScale[2] == 'num' and gravityScale[1] or 1
  game.objects[indexScene][indexObject].data.physics.gravityScale = gravityScale
  game.objects[indexScene][indexObject].gravityScale = gravityScale
end

frm.setLinearVelocity = function(indexScene, indexObject, params, localtable)
  local currentLinearX, currentLinearY = game.objects[indexScene][indexObject]:getLinearVelocity()
  local linearX = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local linearY = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  linearX = linearX[2] == 'num' and linearX[1] or currentLinearX
  linearY = linearY[2] == 'num' and -linearY[1] or currentLinearY
  game.objects[indexScene][indexObject]:setLinearVelocity(linearX, linearY)
end

frm.setLinearVelocityX = function(indexScene, indexObject, params, localtable)
  local currentLinearX, currentLinearY = game.objects[indexScene][indexObject]:getLinearVelocity()
  local linearX = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local linearY = currentLinearY

  linearX = linearX[2] == 'num' and linearX[1] or currentLinearX
  game.objects[indexScene][indexObject]:setLinearVelocity(linearX, linearY)
end

frm.setLinearVelocityY = function(indexScene, indexObject, params, localtable)
  local currentLinearX, currentLinearY = game.objects[indexScene][indexObject]:getLinearVelocity()
  local linearY = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local linearX = currentLinearX

  linearY = linearY[2] == 'num' and -linearY[1] or currentLinearY
  game.objects[indexScene][indexObject]:setLinearVelocity(linearX, linearY)
end

frm.setSensor = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].data.physics.sensor = true
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].isSensor = true
  end
end

frm.setNotSensor = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].data.physics.sensor = false
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].isSensor = false
  end
end

frm.setFixedRotation = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].data.physics.fixedRotation = true
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].isFixedRotation = true
  end
end

frm.setNotFixedRotation = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].data.physics.fixedRotation = false
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].isFixedRotation = false
  end
end

frm.setWorldGravity = function(indexScene, indexObject, params, localtable)
  local gravityX = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local gravityY = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  gravityX = gravityX[2] == 'num' and gravityX[1] or 0
  gravityY = gravityY[2] == 'num' and gravityY[1] or 9.8

  physics.setGravity(gravityX, gravityY)
end

frm.setBullet = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].data.physics.bullet = true
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].isBullet = true
  end
end

frm.setNotBullet = function(indexScene, indexObject, params, localtable)
  game.objects[indexScene][indexObject].data.physics.bullet = false
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].isBullet = false
  end
end

frm.setAwake = function(indexScene, indexObject, params, localtable)
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].isAwake = true
  end
end

frm.setAngularVelocity = function(indexScene, indexObject, params, localtable)
  local velocity = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  velocity = velocity[2] == 'num' and velocity[1] or 0
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].angularVelocity = velocity
  end
end

frm.setAngularDamping = function(indexScene, indexObject, params, localtable)
  local damping = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  damping = damping[2] == 'num' and damping[1] or 0
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].angularDamping = damping
  end
end

frm.setLinearDamping = function(indexScene, indexObject, params, localtable)
  local damping = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  damping = damping[2] == 'num' and damping[1] or 0
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].linearDamping = damping
  end
end

frm.setForce = function(indexScene, indexObject, params, localtable)
  local bodyX = game.objects[indexScene][indexObject].x
  local bodyY = game.objects[indexScene][indexObject].y
  local forceX = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local forceY = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  forceX = forceX[2] == 'num' and forceX[1] or 0
  forceY = forceY[2] == 'num' and forceY[1] or 0
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject]:applyForce(forceX, forceY, bodyX, bodyY)
  end
end

frm.setLinearImpulse = function(indexScene, indexObject, params, localtable)
  local bodyX = game.objects[indexScene][indexObject].x
  local bodyY = game.objects[indexScene][indexObject].y
  local forceX = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  local forceY = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  forceX = forceX[2] == 'num' and forceX[1] or 0
  forceY = forceY[2] == 'num' and forceY[1] or 0
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject]:applyLinearImpulse(forceX, forceY, bodyX, bodyY)
  end
end

frm.setTorque = function(indexScene, indexObject, params, localtable)
  local force = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  force = force[2] == 'num' and force[1] or 0
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject]:applyTorque(force)
  end
end

frm.setAngularImpulse = function(indexScene, indexObject, params, localtable)
  local force = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  force = force[2] == 'num' and force[1] or 0
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject]:applyAngularImpulse(force)
  end
end

frm.setHitboxMesh = function(indexScene, indexObject, params, localtable)
  local mesh = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if mesh[2] == 'num' and tonumber(mesh[1]) > 100 then mesh[1] = '100'
  elseif mesh[2] == 'num' and tonumber(mesh[1]) < 1 then mesh[1] = '1' end
  if game.objects[indexScene][indexObject].data.physics.body ~= '' and mesh[2] == 'num' then
    game.objects[indexScene][indexObject].data.physics.hitbox = {mesh[1], 'mesh'}
    frm.createBody(indexScene, indexObject, params, localtable)
  elseif mesh[2] == 'num' then
    game.objects[indexScene][indexObject].data.physics.hitbox = {mesh[1], 'mesh'}
  end
end

frm.setHitboxBox = function(indexScene, indexObject, params, localtable)
  local hitbox = params[1][1] and params[1][1][1] or ''
  if game.objects[indexScene][indexObject].data.physics.body ~= '' then
    game.objects[indexScene][indexObject].data.physics.hitbox = {json.decode(hitbox), 'box'}
    frm.createBody(indexScene, indexObject, params, localtable)
  else
    game.objects[indexScene][indexObject].data.physics.hitbox = {json.decode(hitbox), 'box'}
  end
end

frm.setHitboxCircle = function(indexScene, indexObject, params, localtable)
  local radius = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))
  if game.objects[indexScene][indexObject].data.physics.body ~= '' and radius[2] == 'num' then
    game.objects[indexScene][indexObject].data.physics.hitbox = {radius[1], 'radius'}
    frm.createBody(indexScene, indexObject, params, localtable)
  elseif radius[2] == 'num' then
    game.objects[indexScene][indexObject].data.physics.hitbox = {radius[1], 'radius'}
  end
end

frm.setPowerPhysics = function(indexScene, indexObject, params, localtable)
  local power = params[1][1] and params[1][1][1] or ''

  physics.setScale(30*tonumber(power))
  physics.setPositionIterations(3*tonumber(power))
  physics.setVelocityIterations(8*tonumber(power))
end

frm.setVisiblePhysics = function(indexScene, indexObject, params, localtable)
  game.debugrect.width, game.debugrect.height = 0, 0 physics.setDrawMode('hybrid')
end

frm.setNotVisiblePhysics = function(indexScene, indexObject, params, localtable)
  game.debugrect.width, game.debugrect.height = 0, 0 physics.setDrawMode('normal')
end

frm.startPhysics = function(indexScene, indexObject, params, localtable) physics.start() end
frm.stopPhysics = function(indexScene, indexObject, params, localtable) physics.pause() end

frm.createBodyShape = function(name)
  if game.shapes[name].data.physics.body ~= '' then physics.removeBody(game.shapes[name]) end
  if game.shapes[name].width > 0 and game.shapes[name].height > 0 then
    local hitbox = table.copy(game.shapes[name].data.physics.hitbox)
    local _hitbox, x_hitbox = {}, true
    local paramsbody = {{
      bounce = game.shapes[name].data.physics.bounce,
      density = game.shapes[name].data.physics.density,
      friction = game.shapes[name].data.physics.friction
    }}

    if hitbox and hitbox[2] == 'box' then
      local width1 = game.shapes[name].width
      local width2 = game.shapes[name].data.width
      local height1 = game.shapes[name].height
      local height2 = game.shapes[name].data.height
      local resizeWidth = width1 / width2
      local resizeHeight = height1 / height2

      for j = 1, #hitbox[1] do _hitbox[j] = {}
        for i = 1, #hitbox[1][j] do
          if x_hitbox then x_hitbox = false
            _hitbox[j][i] = hitbox[1][j][i] * resizeWidth
          else x_hitbox = true
            _hitbox[j][i] = hitbox[1][j][i] * resizeHeight
          end
        end
      end hitbox[1] = _hitbox

      for i = 2, #hitbox[1] do
        paramsbody[i] = {
          bounce = game.shapes[name].data.physics.bounce,
          density = game.shapes[name].data.physics.density,
          friction = game.shapes[name].data.physics.friction,
          shape = hitbox[1][i]
        }
      end paramsbody[1].shape = hitbox[1][1]
    elseif hitbox and hitbox[2] == 'mesh' then
      local texture = game.shapes[name].data.texture
      local path, basedir = game.shapes[name].data.path, game.basedir
      if utf8.sub(texture, 1, 1) == '.' then basedir = system.TemporaryDirectory end

      local outline = graphics.newOutline(tonumber(hitbox[1]), path .. texture, basedir)
      paramsbody[1].outline = outline
    elseif hitbox and hitbox[2] == 'radius' then paramsbody[1].radius = tonumber(hitbox[1]) end

    physics.addBody(game.shapes[name], game.shapes[name].data.physics.body, unpack(paramsbody))

    game.shapes[name].isSensor = game.shapes[name].data.physics.sensor
    game.shapes[name].isBullet = game.shapes[name].data.physics.bullet
    game.shapes[name].gravityScale = game.shapes[name].data.physics.gravityScale
    game.shapes[name].isFixedRotation = game.shapes[name].data.physics.fixedRotation
  end
end

frm.setBodyShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local body = params[2][1] and params[2][1][1] or ''
  local density = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))
  local bounce = calc(indexScene, indexObject, table.copy(params[4]), table.copy(localtable))
  local friction = calc(indexScene, indexObject, table.copy(params[5]), table.copy(localtable))

  if game.shapes[name] then
    game.shapes[name].data.physics.body = body == 'staticBody' and 'static' or 'dynamic'
    game.shapes[name].data.physics.bounce = bounce[2] == 'num' and bounce[1] or 1
    game.shapes[name].data.physics.density = density[2] == 'num' and density[1] or 0
    game.shapes[name].data.physics.friction = friction[2] == 'num' and friction[1] or -1

    frm.createBodyShape(name)
  end
end

frm.removeBodyShape = function(indexScene, indexObject, params, localtable) pcall(function()
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  if game.shapes[name] then physics.removeBody(game.shapes[name]) end end)
end

frm.updHitboxShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]

  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' then
    frm.createBodyShape(name)
  end
end

frm.setNewBodyShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local body = params[2][1] and params[2][1][1] or ''

  if game.shapes[name] then
    body = body == 'staticBody' and 'static' or 'dynamic'
    game.shapes[name].data.physics.body = body
    game.shapes[name].bodyType = body
  end
end

frm.setGravityShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local gravityScale = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  if game.shapes[name] then
    gravityScale = gravityScale[2] == 'num' and gravityScale[1] or 1
    game.shapes[name].data.physics.gravityScale = gravityScale
    game.shapes[name].gravityScale = gravityScale
  end
end

frm.setLinearVelocityShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local currentLinearX, currentLinearY = game.shapes[name]:getLinearVelocity()
  local linearX = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local linearY = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  if game.shapes[name] then
    linearX = linearX[2] == 'num' and linearX[1] or currentLinearX
    linearY = linearY[2] == 'num' and -linearY[1] or currentLinearY
    game.shapes[name]:setLinearVelocity(linearX, linearY)
  end
end

frm.setLinearVelocityXShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local currentLinearX, currentLinearY = game.shapes[name]:getLinearVelocity()
  local linearX = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local linearY = currentLinearY

  if game.shapes[name] then
    linearX = linearX[2] == 'num' and linearX[1] or currentLinearX
    game.shapes[name]:setLinearVelocity(linearX, linearY)
  end
end

frm.setLinearVelocityYShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local currentLinearX, currentLinearY = game.shapes[name]:getLinearVelocity()
  local linearY = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local linearX = currentLinearX

  if game.shapes[name] then
    linearY = linearY[2] == 'num' and -linearY[1] or currentLinearY
    game.shapes[name]:setLinearVelocity(linearX, linearY)
  end
end

frm.setSensorShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]

  if game.shapes[name] then
    game.shapes[name].data.physics.sensor = true
    if game.shapes[name].data.physics.body ~= '' then
      game.shapes[name].isSensor = true
    end
  end
end

frm.setNotSensorShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]

  if game.shapes[name] then
    game.shapes[name].data.physics.sensor = false
    if game.shapes[name].data.physics.body ~= '' then
      game.shapes[name].isSensor = false
    end
  end
end

frm.setFixedRotationShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]

  if game.shapes[name] then
    game.shapes[name].data.physics.fixedRotation = true
    if game.shapes[name].data.physics.body ~= '' then
      game.shapes[name].isFixedRotation = true
    end
  end
end

frm.setNotFixedRotationShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]

  if game.shapes[name] then
    game.shapes[name].data.physics.fixedRotation = false
    if game.shapes[name].data.physics.body ~= '' then
      game.shapes[name].isFixedRotation = false
    end
  end
end

frm.setBulletShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]

  if game.shapes[name] then
    game.shapes[name].data.physics.bullet = true
    if game.shapes[name].data.physics.body ~= '' then
      game.shapes[name].isBullet = true
    end
  end
end

frm.setNotBulletShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]

  if game.shapes[name] then
    game.shapes[name].data.physics.bullet = false
    if game.shapes[name].data.physics.body ~= '' then
      game.shapes[name].isBullet = false
    end
  end
end

frm.setAwakeShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]

  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' then
    game.shapes[name].isAwake = true
  end
end

frm.setAngularVelocityShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local velocity = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  velocity = velocity[2] == 'num' and velocity[1] or 0
  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' then
    game.shapes[name].angularVelocity = velocity
  end
end

frm.setAngularDampingShape = function(indexScene, indexObject, params, localtable)
  local damping = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))

  damping = damping[2] == 'num' and damping[1] or 0
  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' then
    game.shapes[name].angularDamping = damping
  end
end

frm.setLinearDampingShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local damping = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  damping = damping[2] == 'num' and damping[1] or 0
  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' then
    game.shapes[name].linearDamping = damping
  end
end

frm.setForceShape = function(indexScene, indexObject, params, localtable)
  local bodyX = game.objects[indexScene][indexObject].x
  local bodyY = game.objects[indexScene][indexObject].y
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local forceX = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local forceY = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  forceX = forceX[2] == 'num' and forceX[1] or 0
  forceY = forceY[2] == 'num' and forceY[1] or 0
  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' then
    game.shapes[name]:applyForce(forceX, forceY, bodyX, bodyY)
  end
end

frm.setLinearImpulseShape = function(indexScene, indexObject, params, localtable)
  local bodyX = game.objects[indexScene][indexObject].x
  local bodyY = game.objects[indexScene][indexObject].y
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local forceX = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  local forceY = calc(indexScene, indexObject, table.copy(params[3]), table.copy(localtable))

  forceX = forceX[2] == 'num' and forceX[1] or 0
  forceY = forceY[2] == 'num' and forceY[1] or 0
  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' then
    game.shapes[name]:applyLinearImpulse(forceX, forceY, bodyX, bodyY)
  end
end

frm.setTorqueShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local force = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  force = force[2] == 'num' and force[1] or 0
  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' then
    game.shapes[name]:applyTorque(force)
  end
end

frm.setAngularImpulseShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local force = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))

  force = force[2] == 'num' and force[1] or 0
  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' then
    game.shapes[name]:applyAngularImpulse(force)
  end
end

frm.setHitboxMeshShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local mesh = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if mesh[2] == 'num' and tonumber(mesh[1]) > 100 then mesh[1] = '100'
  elseif mesh[2] == 'num' and tonumber(mesh[1]) < 1 then mesh[1] = '1' end
  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' and mesh[2] == 'num' then
    game.shapes[name].data.physics.hitbox = {mesh[1], 'mesh'}
    frm.createBodyShape(name)
  elseif game.shapes[name] and mesh[2] == 'num' then
    game.shapes[name].data.physics.hitbox = {mesh[1], 'mesh'}
  end
end

frm.setHitboxBoxShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local hitbox = params[2][1] and params[2][1][1] or ''
  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' then
    game.shapes[name].data.physics.hitbox = {json.decode(hitbox), 'box'}
    frm.createBodyShape(name)
  elseif game.shapes[name] then
    game.shapes[name].data.physics.hitbox = {json.decode(hitbox), 'box'}
  end
end

frm.setHitboxCircleShape = function(indexScene, indexObject, params, localtable)
  local name = calc(indexScene, indexObject, table.copy(params[1]), table.copy(localtable))[1]
  local radius = calc(indexScene, indexObject, table.copy(params[2]), table.copy(localtable))
  if game.shapes[name] and game.shapes[name].data.physics.body ~= '' and radius[2] == 'num' then
    game.shapes[name].data.physics.hitbox = {radius[1], 'radius'}
    frm.createBodyShape(name)
  elseif game.shapes[name] and radius[2] == 'num' then
    game.shapes[name].data.physics.hitbox = {radius[1], 'radius'}
  end
end
