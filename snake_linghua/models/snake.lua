--package snake_linghua/ models/snake_model

snake = {}
local snakebody;
local step=10;


function snake:new()

	snakebody=display.newImage("img/little_snake.png", 0, 0)
	return snakebody;
end

local function onTouch( event )
    if "began" == event.phase then
        snakebody.isFocus = true		
		
		if (event.x<snakebody.x) then 		
        	snakebody.x = snakebody.x-step
        end
        if (event.x>snakebody.x) then 		
        	snakebody.x = snakebody.x+step
        end	
        
        if (event.y<snakebody.y) then 		
        	snakebody.y = snakebody.y-step
        end
        if (event.y>snakebody.y) then 		
        	snakebody.y = snakebody.y+step
        end	
   
    end

    -- Return true if the touch event has been handled.
    return true
end

-- Only the background receives touches. 
Runtime:addEventListener( "touch", onTouch)




--function snake:getX(snake)
	--return snake.x;
--end

--function snake:getX(snake)
--	return snake.y;
--end

--function snake:moveLeft(snake)
--	print ('inner snake x', snake.x);
--	snake.x=snake.x-20;
--end
--
--

--function snake:moveRight(snake)
--	snake.x=snake.x+20;
--end
--
--function snake:moveUp(snake)
--	snake.x=snake.y-20;
--end
--
--function snake:moveDown(snake)
--	snake.x=snake.x+20;
--end

--	
--function snake:enterFrame(event)
--end
--Runtime:addEventListener( "enterFrame", snake );



return snake