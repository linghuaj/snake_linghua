local physics = require "physics"
local widget = require "widget"

require "models.snake"
require "models.food"


physics.start();

local little_snake=snake:new();
local food_apple=food:new();
--food:reset(food_apple);
print ('snakex', little_snake.x);




----add buttons and listeners, adjust animation in main
 
    local bounceAppleEvent = function (event )
        if event.phase == "release" then
        	food:bounce(food_apple)
            print( "You pressed and released a button!" )
        end
    end
 
    local myButton = widget.newButton{
        id = "btn001",
        left = 200,
        top = 300,
        label = "Bounce Apple",
        width = 150, height = 28,
        cornerRadius = 8,
        onEvent = bounceAppleEvent
    }
    
    local resetAppleEvent = function (event )
        if event.phase == "release" then
        	food:reset(food_apple)
            print( "You pressed and released a button!" )
        end
    end
 
    local myButton = widget.newButton{
        id = "btn002",
        left = 200,
        top = 400,
        label = "Reset Apple",
        width = 150, height = 28,
        cornerRadius = 8,
        onEvent = resetAppleEvent
    }