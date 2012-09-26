--package snake_linghua/ models/food_model

local screenTop = display.screenOriginY
local screenBottom = display.viewableContentHeight + display.screenOriginY
local screenLeft = display.screenOriginX
local screenRight = display.viewableContentWidth + display.screenOriginX

food = {}

	function food:new()	
	
		local apple=display.newImage("img/food.png", screenRight/2, screenBottom/2)		
		return apple						
	end
	
	function food:bounce(food)	
		physics.addBody(food, { density = 1.0, friction = 0.3, bounce = 0.5, radius = 25 } )
	end
	
	function food:reset(food)
		food.x=screenRight/2
		food.y= screenBottom/2
		physics.removeBody(food)
	end
	
		
	function food:enterFrame(event)
	end
	Runtime:addEventListener( "enterFrame", food );
	

return food