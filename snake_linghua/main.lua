--snake prototype_v3
--email:linghua.jin@gmail.com

local width=20;

-- Get current edges of visible screen (accounting for the areas cropped by "zoomEven" scaling mode in config.lua)
local screenTop = display.screenOriginY-width
local screenBottom = display.viewableContentHeight + display.screenOriginY+width
local screenLeft = display.screenOriginX+width
local screenRight = display.viewableContentWidth + display.screenOriginX-width

--set globa params for the snake

local xdir=1;
local ydir=0;
local x_origin=math.floor(screenRight/2/width)*width;
local y_origin=math.floor(screenBottom/2/width)*width;

--other global variables
local score=0;
local point=1; --after each eat, how many score get update
local countEvent=0;-- this is used for adjust speed for timer



--------------------------------------------------------------builder functions
--add block to snake
--x, and y should be the next coordinates of the head. 
local function newRect( x,y )
	local x = x
    local y = y
	local rect = display.newRect( x, y, width,width );
	rect:setFillColor( 255,0,0);
	return rect
end

--addnew food
local function newFood(x,y)
	local x=x
	local y=y
	local food=display.newRect(x,y,width,width);
	food:setFillColor(0,0,255);
	return food
end

--after food been eat, change coordinate
--extra width to prevent not reachable food
local function changeFood()
	food.x=math.floor(math.random()*(screenRight-2*width)/width)*width
	food.y=math.floor(math.random()*(screenBottom-2*width)/width)*width
end

local function newText()
 local x = display.contentWidth / 2
 local y = display.contentWidth / 4

	local myText = display.newText("", x, y, native.systemFont, 40 )
	myText:setTextColor(255, 255, 255)
	myText.text = "Your Score"
	return myText
end 



local function updateText()
	text.text=score;
end

----------------------------------------------------------------initialize snake and food
-- build collection represent the snake bodys;
local collection={};
--add head to collection
collection[1]=newRect(x_origin, y_origin);
--now head and tail are same;
local tail_index=table.getn(collection);
local head_index=1;
local head=collection[head_index];
local tail=collection[tail_index];

--initialize food
food=newFood(x_origin+width,y_origin+width);
--initialize text
text=newText();
------------------------------------------------------------------status function for snake


--head is always the one after tail
local function searchCurrentHeadIndex(tail_index, collection)
	if (tail_index==table.getn(collection))then
		head_index=1;
	else
		head_index=tail_index+1;
	end
	return head_index;
end

local function searchTailIndex(head_index,collection)
	if (head_index>1) then
		tail_index=head_index-1; --we moved tail to front, so the tail_index changed;
	else
		tail_index=table.getn(collection)
	end
	return tail_index
end


local function update_head()
	head_index=tail_index;--save current tail 
	head=collection[head_index];--update the global variable here
	print('head_index',head_index);
	print('collection',collection);
	tail_index=searchTailIndex(head_index,collection)
	tail=collection[tail_index];
end

--get the coordinates of the head's next coordinate
local function get_next_coordinates()

	
		xNew = head.x + width*xdir
		yNew=  head.y + width*ydir

		if ( xNew > screenRight ) then
			xNew = screenLeft+width		
		end

		if ( xNew < screenLeft + width  ) then
			xNew = screenRight-width		
		end

		if ( yNew > screenBottom+width) then
			yNew = screenTop-width
		end

		if ( yNew < screenTop - width )  then
			 yNew=screenBottom+width
		
		end
		
		local coordinates={}
		coordinates[1]=xNew;
		coordinates[2]=yNew;
		return coordinates;
end


local function eatfood( )
		--step 1 get coordinates of next move of head;
		local coordinates=get_next_coordinates();
		--step 2 build new rect with the coordinates;
		local rect=newRect(coordinates[1]-width/2,coordinates[2]-width/2);
		--local rect=newRect(tail.x,tail.y);
		--step3, add to table.	
		--local size=table.getn(collection);
		tail_index=tail_index+1;
		table.insert(collection,tail_index,rect);--not size
		--table.insert(table, pos, value); should insert after old tail
		head_index=searchCurrentHeadIndex(tail_index,collection);
		
		--update_head();
		
		--step 4, change the food's position
		changeFood();
		score=score+point;
		updateText();
end
function isEnded()
	if (table.getn(collection)>0) then
	  for _,rect in ipairs( collection ) do
		print('rect',rect);
		print('head',head);
		print('x',rect.x,head.x); 
		print('y',rect.y,head.y);
			if(rect==head) then
			else
				if(math.abs(rect.x-head.x)<width)
					and (math.abs(rect.y-head.y)<width) then
							print('x2',rect.x,head.x); 
							print('y2',rect.y,head.y);
					return true;
				end
			end 
		end
	end
	return false;
end
-------------------------------------------------------------------strobe functions for timer

function food:enterFrame(event)
end

function text:enterFrame(event)

end

function collection:enterFrame( event )
--this is where I adjust the speed
	countEvent=countEvent+1;
	if ((countEvent%5)~=0) then
		return
	end

     update_head();
	 next_coordinates=get_next_coordinates();

	tail.x,tail.y= next_coordinates[1], next_coordinates[2];
	
        
	if(math.abs(head.x-food.x)<width)
		and (math.abs(head.y-food.y)<width) then
		eatfood();
	end

	if (isEnded()==true ) then
		remove_listeners();
	end
	
end



------------------------------------------------------------------------touch event
local myListener = function( event ) 
	--divide the screen into four parts.
     if (event.phase=='began') then
	     --top left
	if (event.x<screenRight/2) and (event.y<screenBottom/2) then
		  
			if (ydir==0) then
				xdir=0;
				ydir=-1;		

			else
				--if move vertical
				if (xdir==0) then			
					ydir=0;
					xdir=-1;
				end
			end
	
	end
	--top right corner
	if (event.x>screenRight/2) and (event.y<screenBottom/2) then
		
	 
			if (ydir==0) then
				xdir=0;
				ydir=-1;

			else
				--if move vertical
				if (xdir==0) then
					ydir=0;
					xdir=1;
				end
			end
	end
	--bottom left
	if (event.x<screenRight/2) and (event.y>screenBottom/2) then

		--horizontal
			if (ydir==0) then
				xdir=0;
				ydir=1;		

			else
				--if move vertical
				if (xdir==0) then			
					ydir=0;
					xdir=-1;
				end
			end
	end
--bottom right
	if (event.x>screenRight/2) and (event.y>screenBottom/2) then
			if (ydir==0) then
				xdir=0;
				ydir=1;		

			else
				--if move vertical
				if (xdir==0) then			
					ydir=0;
					xdir=1;
				end
			end
	end
end

end 

--runtime is a object
Runtime:addEventListener( "touch", myListener );
Runtime:addEventListener( "enterFrame", collection );
Runtime:addEventListener( "enterFrame", food );
Runtime:addEventListener( "enterFrame", text );



function remove_listeners()
	Runtime:removeEventListener( "enterFrame", collection );
	Runtime:removeEventListener( "enterFrame", food );
	Runtime:removeEventListener( "enterFrame", text );
end 

