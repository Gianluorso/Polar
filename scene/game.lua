local composer = require( "composer" )
local widget = require( "widget" )
local physics= require "physics"
physics.start()
--physics.setDrawMode("hybrid")

local scene = composer.newScene()
local background
local ground
local bearSheet
local bear


-- bearSheet collision handler
local function sensorCollide( self, event )
 
    -- Confirm that the colliding elements are the foot sensor and a ground object
    if ( event.selfElement == 2 and event.other.objType == "ground" ) then
 
        -- Foot sensor has entered (overlapped) a ground object
        if ( event.phase == "began" ) then
            self.sensorOverlaps = self.sensorOverlaps + 1
        -- Foot sensor has exited a ground object
        elseif ( event.phase == "ended" ) then
            self.sensorOverlaps = self.sensorOverlaps - 1
        end
    end
end

function scene:create( event )
    physics.start()
    local sceneGroup = self.view
    local background=display.newImageRect("img/background.jpg", display.contentWidth*2, display.contentHeight*2)
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
   
    local ground = display.newImage("img/ground.png")
    ground.x = 160
    ground.y = 700
    ground:setFillColor( 1, 1, 1 )
    ground.objType = "ground"
    physics.addBody( ground, "static", { bounce=0.0, friction=0.3 } )

    --Platform
    local platform = display.newImage("img/platform.png")
    platform.x = 1000
    platform.y = 500
    
    platform:setFillColor( 1, 1, 1 )
    platform.objType = "ground"
    physics.addBody( platform, "kinematic", { bounce=0.0, friction=0.3, shape = { -60*3,15, 60*3,15, 60*3,-15, -60*3,-15 } } )
    platform.xScale=3
    --Platform Movement
    local function movePlatform(firstTime)
        local transitionTime = 1500
        if(firstTime) then
            firstTime = false
            transitionTime = transitionTime + 2000 --aggiungo 2s
            platform.x = platform.x + 2000 --aggiungo un po' di distanza
        end
        transition.to(platform, {x = -100, time = transitionTime, onComplete = 
        function()
            platform.y = 450 + math.random(100)
            platform.x = 1000
            movePlatform(false)        
        end})
    end
    movePlatform(true)
    


    local opt = { numFrames=8, width=512, height=512 }
    local bearSheet = graphics.newImageSheet("img/bear.png",opt)
    
    local runningSeqs = {
        count = 8,
        start = 1, 
        loopCount = 0, 
        loopDirection = "forward",
        time = 800, 
    }
                
    local bear = display.newSprite(bearSheet, runningSeqs)
    bear.xScale= 0.4
    bear.yScale=0.4
    bear.timeScale = 2.0
    bear.x = 180
    bear.y = display.contentCenterY
    bear.isFixedRotation = true
    bear.sensorOverlaps = 0
    
    bear:play()

    -- Associate collision handler function with character
    bear.collision = sensorCollide
    bear:addEventListener( "collision" )

    local function onTouch(event)
        if (event.phase == "began" and bear.sensorOverlaps > 0) then
            
            bear.gravityScale = 4 
            bear:setLinearVelocity(0,-800)
        elseif (event.phase == "ended") then
            bear.gravityScale= 10
        end
    end

    Runtime:addEventListener("touch", onTouch)
    sceneGroup:insert(background)
    sceneGroup:insert( ground )
    sceneGroup:insert( bear )
    sceneGroup:insert( platform )

    local contorno_bear = {-100,50, -100, -50, 100, -50, 100, 50}

    physics.addBody( 
        bear,"dinamic",{shape=contorno_bear},  -- Main body element
        { box={ halfWidth=100, halfHeight=10, x=0, y=60 }, isSensor=true }  -- Foot sensor element
    )
     -- Function to handle button events
    local function handleButtonEvent( event )
    
        if ( "ended" == event.phase ) then
            composer.removeScene("scene.game")
            composer.gotoScene( "scene.menu" )
        end
    end
    
    local reset = widget.newButton(
        {
            label = "Reset",
            onEvent = handleButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 150,
            height = 70,
            cornerRadius = 45,
            fillColor = { default={0.157,0.949,1,1}, over={0.275, 0.847, 1} },
            strokeColor = { default={1,1,1}, over={1,1,1} },
            strokeWidth = 0,
            labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1, 1 } },

            
        }
    )
    reset.x = 800
    reset.y = 100
    
   
    sceneGroup:insert( reset )
    
end

function scene:show( event )
    
end

function scene:hide( event )

end

function scene:destroy( event )
    local sceneGroup = self.view

    --Removes all the runtime event listeners
    Runtime._functionListeners = nil
  

    if background then
        background:removeSelf()
        background = nil
    end
    
    if ground then
		ground:removeSelf()
		ground = nil
    end

    if bear then
		bear:removeSelf()
		bear = nil
    end

    if bearSheet then
        bearSheet:removeSelf()
		bearSheet = nil
    end

    if bear then
        bear:removeSelf()
		bear = nil
    end
        
        if reset then
		reset:removeSelf()	-- widgets must be manually removed
		reset = nil
    end

    physics.stop()

    sceneGroup:removeSelf()
    sceneGroup = nil
end



-- Scene listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene