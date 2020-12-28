raycasting = {}

raycasting.lib = display.newGroup()
display.setDefault('background', 1)
_x = 256
_y = 256

local image_size = 512
local image_resize = 16
local player_x = 3.456
local player_y = 2.345
local player_a = 1.523

local mapString = [[0000222222220000
1              0
1      11111   0
1     0        0
0     0  1110000
0     3        0
0   10000      0
0   0   11100  0
0   0   0      0
0   0   1  00000
0       1      0
2       1      0
0       0      0
0 0000000      0
0              0
0002222222200000
]]

local map = {}

for i = 1, 16 do
  map[i] = {}
  for j = 1, 17 do
    if j ~= 17 then
      map[i][j] = utf8.sub(mapString, j+17*(i-1), j+17*(i-1))
    end
  end
end

local draw = function(group, x, y, w, h, rgb)
  display.newRect(
    group,
    image_size/image_resize/2+image_size/image_resize*(x-1)+_x-image_size/2,
    image_size/image_resize/2+image_size/image_resize*(y-1)+_y-image_size/2,
    w, h
  ):setFillColor(rgb[1], rgb[2], rgb[3])
end

local image = display.newImage(raycasting.lib, 'Image/step1.png')
  image.x = _x
  image.y = _y

for i = 1, #map do
  for j = 1, #map[i] do
    if not utf8.find(map[i][j], '%s') then
      draw(raycasting.lib, j, i, image_size/image_resize, image_size/image_resize, {0, 1, 1})
    else
      draw(raycasting.lib, j, i, image_size/image_resize, image_size/image_resize, {1, 1, 1})
    end
  end
end

draw(raycasting.lib, player_x, player_y, 5, 5, {1, 1, 1})

local renderGroup = display.newGroup()
local render = function()
  renderGroup:removeSelf()
  renderGroup = display.newGroup()
  vector = {}
  local player_angle = player_a - 0.512
  for i = 1, 512 do
    player_angle = player_angle + 0.002
    local c = 0
    while c < 20 do
      c = c + .05
      local x = player_x + c*math.cos(player_angle)
      local y = player_y + c*math.sin(player_angle)
      if map[math.round(y)][math.round(x)] ~= ' ' then
        vector[#vector+1] = c
        break
      end
    end
  end

  local x = 0
  for i = 1, #vector do
    x = x + 0.045
    draw(renderGroup, x, 25, 1.37, 512/vector[i]*1.5, {0, 1, 1})
  end
end

render()

local keyName = {}
keyName['d'] = 'up'
keyName['a'] = 'up'
keyName['w'] = 'up'
keyName['s'] = 'up'

local function onKeyEvent(event)
  keyName[event.keyName] = event.phase
  return true
end
Runtime:addEventListener("key", onKeyEvent)

local update = function()
  if keyName['w'] == 'down' then
    if keyName['d'] == 'down' then
      player_a = player_a + 0.05
    elseif keyName['a'] == 'down' then
      player_a = player_a - 0.05
    end
    player_x = player_x + ((player_x + .025*math.cos(player_a))-player_x)
    player_y = player_y + ((player_y + .025*math.sin(player_a))-player_y)
    render()
  elseif keyName['s'] == 'down' then
    if keyName['d'] == 'down' then
      player_a = player_a + 0.05
    elseif keyName['a'] == 'down' then
      player_a = player_a - 0.05
    end
    player_x = player_x - ((player_x + .025*math.cos(player_a))-player_x)
    player_y = player_y - ((player_y + .025*math.sin(player_a))-player_y)
    render()
  elseif keyName['d'] == 'down' then
    player_a = player_a + 0.05
    render()
  elseif keyName['a'] == 'down' then
    player_a = player_a - 0.05
    render()
  end
end
Runtime:addEventListener("enterFrame", update)
