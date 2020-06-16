local composer = require( "composer" )
local widget = require( "widget" )
local loadsave = require( "loadsave" )
local scene = composer.newScene()

-- forward declaration for widgets
local background
local playAgainButton
local shownHighScoreText

function scene:create( event )
	local sceneGroup = self.view
    local background=display.newImageRect("img/background3.png", display.contentWidth*1.3, display.contentHeight*1.3)
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2

    -- Function to handle button events
    local function handleButtonEvent( event )
    
        if ( "ended" == event.phase ) then
            scoreText:removeSelf()
            composer.gotoScene( "scene.game" )
        end
    end
        local gameover = display.newText( "GAME OVER", display.contentCenterX-250, 130, native.systemFontBold, 85)
    
    gameover:setFillColor( 1, 1, 1 )
    
            local hText = display.newText( "High Score", display.contentCenterX-250, 390, native.systemFontBold, 65)
    
    hText:setFillColor( 0, 0.549, 0.713, 1 )
  
    local playAgainButton = widget.newButton(
        {
            label = "Rigioca",
            fontSize =30,
            onEvent = handleButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 300,
            height = 100,
            cornerRadius = 45,
            fillColor = { default={0, 0.549, 0.713, 1}, over={0, 0.694, 0.713, 1} },
            strokeColor = { default={1,1,1}, over={1,1,1} },
            strokeWidth = 0,
            labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1, 1 } },

            
        }
    )
    playAgainButton.x = display.contentCenterX + 300
    playAgainButton.y = display.contentCenterY+125
    
    sceneGroup:insert( background )
    sceneGroup:insert( gameover )
    sceneGroup:insert( playAgainButton )
    sceneGroup:insert(hText)
end

function scene:show( event )
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        
        --check old highscore
        local loadedSettings = loadsave.loadTable( "settings.json" )
        local loadedHighScore = 0
        if(loadedSettings == nil) then --first game
            local gameSettings = {
                loadedHighScore = tonumber(scoreText.text)
            }        
            loadsave.saveTable( gameSettings, "settings.json" )
        else
            loadedHighScore = loadedSettings.highScore
        end
        print(string.format("%d %s", loadedHighScore, scoreText.text))
        if(tonumber(scoreText.text) > loadedHighScore)then
            local gameSettings = {
                highScore = tonumber(scoreText.text)
            }        
            loadsave.saveTable( gameSettings, "settings.json" )
        end

-----------show highscore
        local function punteggio()
            local highScoreText
            local isNew = false
            
            local value= tonumber(scoreText.text)
            if (loadedHighScore>value) then 
                highScoreText = display.newText( loadedHighScore, display.contentCenterX-250, 500, native.systemFontBold, 120)

            else
                highScoreText = display.newText( value, display.contentCenterX-250, 500, native.systemFontBold, 120)
                isNew = true
            end
            highScoreText:setFillColor( 0, 0.549, 0.713, 1 )
            
            return highScoreText, isnNew
        end

        local sceneGroup = self.view
        local shownHighScoreText, isNew = punteggio()
        sceneGroup:insert( shownHighScoreText )

        if(isNew)then
            local newHighScore = display.newText( "New", display.contentCenterX-250, 340, native.systemFontBold, 32)
            newHighScore:setFillColor( 0, 0.549, 0.713, 1 )
            sceneGroup:insert( newHighScore )
        end

        


    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end
--[[local loadsave = require( "loadsave" )
local gameSettings = {
    highScore = 0
 }        
loadsave.saveTable( gameSettings, "settings.json" )]]--

function scene:hide( event )
    if shownHighScoreText then
		shownHighScoreText:removeSelf()	-- widgets must be manually removed
		shownHighScoreText = nil
	end
end

function scene:destroy( event )
    local sceneGroup = self.view
    if background then
		background:removeSelf()	-- widgets must be manually removed
		background = nil
	end
    if gameover then
		gameover:removeSelf()	-- widgets must be manually removed
		gameover = nil
    end
    if playButton then
		playButton:removeSelf()	-- widgets must be manually removed
		playButton = nil
    end

    if punteggio then
		punteggio:removeSelf()	-- widgets must be manually removed
		punteggio = nil
    end
    
    if value then
		value:removeSelf()	-- widgets must be manually removed
		value = nil
    end

    if hText then
		hText:removeSelf()	-- widgets must be manually removed
		hText = nil
    end
    if newHighScore then
		newHighScore:removeSelf()	-- widgets must be manually removed
		newHighScore = nil
    end
end

-- Scene listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene