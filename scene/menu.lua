local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

-- forward declaration for widgets
local background
local playButton


function scene:create( event )
	local sceneGroup = self.view
    local background=display.newImageRect("img/background.jpg", display.contentWidth*1.5, display.contentHeight*1.5)
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2



    -- Function to handle button events
    local function handleButtonEvent( event )
    
        if ( "ended" == event.phase ) then
            composer.gotoScene( "scene.game" )
        end
    end
    local title = display.newText( "POLAR", display.contentCenterX, 150, native.systemFontBold, 128)
    
    title:setFillColor( 1, 1, 1 )

    
    local playButton = widget.newButton(
        {
            label = "Play",
            fontSize =40,
            onEvent = handleButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 300,
            height = 100,
            cornerRadius = 45,
            fillColor = { default={0.133, 0.498, 0.788, 1}, over={0.275, 0.847, 1} },
            strokeColor = { default={1,1,1}, over={1,1,1} },
            strokeWidth = 0,
            labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1, 1 } },

            
        }
    )
    playButton.x = display.contentCenterX
    playButton.y = display.contentCenterY+150
    
    sceneGroup:insert( background )
    sceneGroup:insert( title )
    sceneGroup:insert( playButton )
end

function scene:show( event )

end

function scene:hide( event )

end

function scene:destroy( event )
    local sceneGroup = self.view
    if background then
		background:removeSelf()	-- widgets must be manually removed
		background = nil
	end
    if title then
		title:removeSelf()	-- widgets must be manually removed
		title = nil
	end
    if playButton then
		playButton:removeSelf()	-- widgets must be manually removed
		playButton = nil
    end
end

-- Scene listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene