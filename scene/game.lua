local composer = require( "composer" )
local widget = require( "widget" )
local physics= require "physics"


audio.play(backgroundMusic)
audio.setVolume( 0.05 )
--local function run(onTouch)
--audio.play(soundTable["ice"],{loops=-1}) 
 --   if (event.phase=="began"); 
 --   then 
--        audio.stop(soundTable["ice"]);
  --  end
--end

--function onTouch(event)
 --   if (event.phase == "began") then 
  --      audio.play(soundTable["jump"]);
 --   end
--end
physics.start()
--physics.setDrawMode("hybrid")

local scene = composer.newScene()
local background
local ground
local bearSheet
local bear
local runMusicChannel
local runMusicStarted = false

local bearRotation = 0

-- bearSheet collision handler
local function sensorCollide( self, event )
 
    -- Confirm that the colliding elements are the foot sensor and a ground object
    if ( event.selfElement == 2 and event.other.objType == "ground" ) then
        if (not runMusicStarted) then
            runMusicChannel = audio.play( runMusic, { loops=-1 }  )
            runMusicStarted = true
        end        
 
        -- Foot sensor has entered (overlapped) a ground object
        if ( event.phase == "began" ) then
            self.sensorOverlaps = self.sensorOverlaps + 1
            audio.resume(runMusicChannel)
        -- Foot sensor has exited a ground object
        elseif ( event.phase == "ended" ) then
            self.sensorOverlaps = self.sensorOverlaps - 1
            audio.pause(runMusicChannel)
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
    platform.y = 400
    
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
        transition.to(platform, {x = -300, time = transitionTime, onComplete = 
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
            audio.play( jumpMusic )
            bear.gravityScale = 4 
            bear:setLinearVelocity(20,-800)
        elseif (event.phase == "ended") then
            bear.gravityScale= 10
        end
    end
    

    local flipTextShown
    local isTextShown = false
    local rainbowColors = { {255, 0 ,0}, {255, 165, 0}, {255, 255, 0}, {0, 128, 0}, {0, 0, 255}, {75, 0, 130}, {238, 130, 238} }
    local rainbowRepetitions = 0
    local rainbowColorIndex = 1

    --executex every frame
    local function on_frame( event )
        --rainbow color
        if(isTextShown) then
            local textR = rainbowColors[rainbowColorIndex][1]
            local textG = rainbowColors[rainbowColorIndex][2]
            local textB = rainbowColors[rainbowColorIndex][3]
            rainbowRepetitions = rainbowRepetitions + 1
            if(rainbowRepetitions >= 3) then
                rainbowRepetitions = 0
                rainbowColorIndex = (rainbowColorIndex + 1) % table.getn(rainbowColors)
                --apparently arrays in lua starts from 1 :/
                if(rainbowColorIndex == 0) then
                    rainbowColorIndex = rainbowColorIndex + 1
                end
            end            
            flipTextShown:setFillColor( textR/255.0, textG/255.0, textB/255.0 )
        end
        --check for frontflip or backflip
        local bearActualRotation = bear.rotation
        if(math.abs(math.abs(bearRotation)-math.abs(bearActualRotation)) >= 350) then

            local flipText = "Frontflip!"

            if(bearActualRotation>bearRotation) then
                bearRotation = bearRotation + 360
            else
                bearRotation = bearRotation - 360
                flipText = "BackFlip!"
            end

            flipTextShown  = display.newText( flipText, display.contentCenterX, display.contentCenterY - 250, native.systemFont, 32 )
            isTextShown = true

            local function hideText( event )
                isTextShown = false
                display.remove(flipTextShown)
                textR = 1
                textG = 1
                textB = 1
            end
                
            timer.performWithDelay( 2000, hideText )
        end

        --controllo ad ogni frame se il giocatore e' rimasto indietro
        if (bear.x < -150) then
            audio.stop(runMusicChannel)
            composer.removeScene("scene.game")
            composer.gotoScene( "scene.gameover" )
        end
    end 
    
    Runtime:addEventListener( "enterFrame", on_frame )

    Runtime:addEventListener("touch", onTouch)
    sceneGroup:insert(background)
    sceneGroup:insert( ground )
    sceneGroup:insert( bear )
    sceneGroup:insert( platform )

    local limiteavanti = display.newRect( 1050, 350, 250, 650 )
    limiteavanti:setFillColor( 1, 0, 0, 0.6 )
    limiteavanti.isVisible = false
    --limiteavanti.rotation = -5
    physics.addBody( limiteavanti, "static", { bounce=0.0, friction=0.3 } )

    local limitealto = display.newRect(600, -20, 800, 50 )
    limitealto:setFillColor( 1, 0, 0, 0.6 )
    limitealto.isVisible = false
    limitealto.objType = "ground"
    physics.addBody( limitealto, "static", { bounce=0.0, friction=0.3 } )

    local contorno_bear = {-100,50, -100, -50, 100, -50, 100, 50}
    physics.addBody( 
        bear,"dinamic",{shape=contorno_bear},  -- Main body element
        { box={ halfWidth=100, halfHeight=10, x=0, y=60 }, isSensor=true }  -- Foot sensor element
    )
     -- Function to handle button events
    local function handleButtonEvent( event )
    
        if ( "ended" == event.phase ) then
            audio.stop(runMusicChannel)
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