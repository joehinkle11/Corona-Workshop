-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
print("hello world")

-- load in box2d
local physics = require("physics")
physics.start()
physics.setDrawMode( "normal" )

-- vars
local accelY = .1
local alive = false

local background = display.newImageRect( "background.png", display.actualContentWidth, display.actualContentHeight )
background.x = display.contentWidth*.5
background.y = display.contentHeight*.5


local myText = display.newText( "Tap to Start", 100, 100, nil, 28 )
myText.x = display.contentWidth*.5
myText:setFillColor( 0 )

-- bird
local bird = display.newImage( "bird.png" )
bird.x, bird.y = 50, 150
bird.speedY = 0
bird.xScale = 2
bird.yScale = 2
physics.addBody( bird, "dynamic", {friction = .5, box = {halfWidth = bird.width, halfHeight = bird.height}} )

-- reset pipe
function resetPipe( top, bot )
	-- set x
	top.x = top.x + 500
	bot.x = top.x
	-- setting y randomly
	top.y = math.random( -100, 100 )
	bot.y = top.y + 400
end

-- pipes
local pipeTop1 = display.newImage( "pipe.png" )
pipeTop1.xScale, pipeTop1.yScale = 2, 2
physics.addBody( pipeTop1, "static", {box = {halfWidth = pipeTop1.width, halfHeight = pipeTop1.height}} )
local pipeBot1 = display.newImage( "pipe.png" )
pipeBot1.xScale, pipeBot1.yScale = 2, -2
physics.addBody( pipeBot1, "static", {box = {halfWidth = pipeTop1.width, halfHeight = pipeTop1.height}} )

resetPipe(pipeTop1,pipeBot1)


local pipeTop2 = display.newImage( "pipe.png" )
pipeTop2.xScale, pipeTop2.yScale = 2, 2
pipeTop2.x = 250
physics.addBody( pipeTop2, "static", {box = {halfWidth = pipeTop1.width, halfHeight = pipeTop1.height}} )
local pipeBot2 = display.newImage( "pipe.png" )
pipeBot2.xScale, pipeBot2.yScale = 2, -2
physics.addBody( pipeBot2, "static", {box = {halfWidth = pipeTop1.width, halfHeight = pipeTop1.height}} )

resetPipe(pipeTop2,pipeBot2)

-- ground
local ground1 = display.newImageRect( "ground.png", display.actualContentWidth, 75 )
ground1.x = display.contentCenterX
ground1.y = display.actualContentHeight - ground1.height*.5
physics.addBody( ground1, "static" )
local ground2 = display.newImageRect( "ground.png", display.actualContentWidth, 75 )
ground2.x = display.contentCenterX + ground2.width
ground2.y = display.actualContentHeight - ground2.height*.5
physics.addBody( ground2, "static" )



-- enter frame
function onEveryFrame( event )
	if alive then
		-- update ground
		ground1.x = ground1.x - 1.5
		ground2.x = ground2.x - 1.5
		if ground1.x < -ground1.width*.5 then
			ground1.x = ground1.x + ground1.width*2
		end
		if ground2.x < -ground2.width*.5 then
			ground2.x = ground2.x + ground2.width*2
		end

		-- update pipes
		pipeTop1.x = pipeTop1.x - 1.5
		pipeBot1.x = pipeTop1.x
		pipeTop2.x = pipeTop2.x - 1.5
		pipeBot2.x = pipeTop2.x

		-- check if pipe leaves
		if pipeTop1.x < -100 then
			resetPipe(pipeTop1,pipeBot1)
		end
		if pipeTop2.x < -100 then
			resetPipe(pipeTop2,pipeBot2)
		end

		bird.x = 50
	end
end
Runtime:addEventListener( "enterFrame", onEveryFrame )

-- transtion
local birdTransition

-- tap
function onTap( event )
	if event.phase == "began" then
		if alive then
			bird:setLinearVelocity( 0, -150 )
			bird.rotation = -45
			transition.cancel( birdTransition )
			birdTransition = transition.to( bird, {transition = easing.inOutQuint, time = 1000, delay = 150, rotation = 45} )
		else
			alive = true
			bird.y = 100
			pipeTop1.x = 0
			pipeTop2.x = 250
			resetPipe(pipeTop1,pipeBot1)
			resetPipe(pipeTop2,pipeBot2)
			myText.isVisible = false
		end
	end
end
Runtime:addEventListener( "touch", onTap)


-- collisions
function onCollide( self, event )
	alive = false
	myText.isVisible = true
end
bird.collision = onCollide
bird:addEventListener( "collision", bird )



