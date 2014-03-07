local gui = require "init"

require("AnAL")

function love.load()
    anim = {}
    fonts = {
        [12] = love.graphics.newFont(12),
        [20] = love.graphics.newFont(20),
    }
    love.graphics.setBackgroundColor(17,17,17)
    love.graphics.setFont(fonts[12])
    anim = newAnimation(love.graphics.newImage("img.png"), 32.5, 35, 0.1, 6)
    t=0
end

--this function receives 3 points, with x = {0, 0.5, 1} and return a quadratic function that passes through the 3 points
local F = function (Y1,Y2,Y3)
  A = 4*((Y3-Y1)/2-(Y2-Y1))
  B = 2*((Y2-Y1) - A*(0.25))
  C = Y1
  return function(x) return A*x*x + B*x + C end 
end

local input = {text = "./img.png"}--this will be a filepath someday
local w = {value = .5, mod = 60}
local h  = {value = .5, mod = 60}
local delay  = {value = .5}
local frames  = {value = .5, mod = 12}
local zoom  = {
  value = .5, 
  value_zero = 0,
  value_half = 2, --so as default it will be at original size
  value_full = 10
  }
--you have to declare the table before asking for it's content
zoom.f = F(zoom.value_zero,zoom.value_half,zoom.value_full)
zoom.mod = function(x) return zoom.f(x) end


function love.update(dt)
    if t > 2 then --responsive enough and dont block the anim
      anim = newAnimation(love.graphics.newImage("img.png"), 60*w.value, 60*h.value, delay.value, math.floor(frames.mod*frames.value))
      t = 0 
    end
    t = dt + t
    anim:update(dt)   
    
    text_detail = "newAnimation(love.graphics.newImage(\"img.png\"), ".. w.mod .. "*" .. w.value..", ".. h.mod .. "*" .. h.value ..", " .. delay.value .. ", " .. "math.floor(" .. frames.mod .. "*" .. frames.value..")"..")"

    text_simple = "newAnimation(love.graphics.newImage(\"img.png\"), ".. w.mod * w.value..", ".. h.mod * h.value ..", " .. delay.value .. ", " .. math.floor(frames.mod * frames.value) .. ")"
    
    
        gui.group{grow = "down", pos = {200, 80}, function() 
            gui.group{grow = "right", function()
                gui.Label{text = "Input", size = {70}}
                gui.Input{info = input, size = {300}}
            end}

            gui.group{grow = "right", function()
                gui.Label{text = "width", size = {70}}
                gui.Slider{info = w}
                gui.Label{text = ("Value: %.2f"):format(w.value), size = {70}}
            end}
            gui.group{grow = "right", function()
                gui.Label{text = "height", size = {70}}
                gui.Slider{info = h}
                gui.Label{text = ("Value: %.2f"):format(h.value), size = {70}}
            end}

           gui.group{grow = "right", function()
                gui.Label{text = "delay", size = {70}}
                gui.Slider{info = delay}
                gui.Label{text = ("Value: %.2f"):format(delay.value), size = {70}}
            end}
           gui.group{grow = "right", function()
                gui.Label{text = "frames", size = {70}}
                gui.Slider{info = frames}
                gui.Label{text = ("Value: %.2f"):format(frames.value), size = {70}}
            end}
            
            gui.group{grow = "right", function()
                gui.Label{text = "zoom", size = {70}}
                gui.Slider{info = zoom}
                gui.Label{text = ("Value: %.2f"):format(zoom.value), size = {70}}
            end}
            gui.Label{text = text_detail}
            gui.Label{text = text_simple}
          
    end}
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(zoom.mod(zoom.value), zoom.mod(zoom.value))
    anim:draw(400/zoom.mod(zoom.value), 400/zoom.mod(zoom.value))
    love.graphics.pop()

    gui.core.draw()
end

function love.keypressed(key, code)
    gui.keyboard.pressed(key)
    -- LÖVE 0.8: see if this code can be converted in a character
    if pcall(string.char, code) then
        gui.keyboard.textinput(string.char(code))
    end
end

-- LÖVE 0.9
function love.textinput(str)
    gui.keyboard.textinput(str)
end
