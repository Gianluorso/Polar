--caricamento librerie della scena
local composer = require( "composer" )
local widget = require( "widget" )
local loadsave = require( "loadsave" )
local scene = composer.newScene()

--dichiarazione variabili
local background
local playAgainButton
local shownHighScoreText
local newHighScore

--elementi visualizzati nella scena
function scene:create( event )
    local sceneGroup = self.view
    
    --inserimento immagine background
    local background=display.newImageRect("img/background3.png", display.contentWidth*1.3, display.contentHeight*1.3)
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2

    --funzione per la riproduzione del suono del bottone
    local function handleButtonEvent( event )
        local function delayTime(event)
            composer.gotoScene( "scene.game" )
        end    
        if ( "began" == event.phase )  then
            timer.performWithDelay( 2, delayTime )
            audio.play(soundTable["click"])

        end
        
    end

        --scritta game over, stm e high score
        local gameover = display.newText( "GAME OVER", display.contentCenterX-250, 130, native.systemFontBold, 85)
        local uniud = display.newText( "Laboratorio di Game Programming, STM", display.contentCenterX+300, 340, native.systemFontBold, 24)
        uniud:setFillColor( 0, 0.549, 0.713, 1 )
        gameover:setFillColor( 1, 1, 1 )
        local hText = display.newText( "High Score", display.contentCenterX-250, 390, native.systemFontBold, 65)
        hText:setFillColor( 0, 0.549, 0.713, 1 )
  
    --bottone per rigiocare
    local playAgainButton = widget.newButton(
        {
            label = "Restart",
            fontSize =30,
            onEvent = handleButtonEvent,
            emboss = false,
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
    
    --ordine degli elementi attraverso sceneGroup
    sceneGroup:insert( background )
    sceneGroup:insert( gameover )
    sceneGroup:insert( playAgainButton )
    sceneGroup:insert(hText)
    sceneGroup:insert(uniud)
end

function scene:show( event )
    local phase = event.phase
 
    if ( phase == "will" ) then
        --codice avviato prima di essere mostrato a schermo  
        --controllo vecchio highscore all'interno di scoreText.text e se è stato superato con il nuovo risultato ottenuto
        local loadedSettings = loadsave.loadTable( "settings.json" )
        local loadedHighScore = 0
        if(loadedSettings == nil) then --primo avvio
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

        --mostro l'high score
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
            
            return highScoreText, isNew
        end

        local sceneGroup = self.view
        shownHighScoreText, isNew = punteggio()
        sceneGroup:insert( shownHighScoreText )
        
        --scritta new nel caso il punteggio sia stato superato
        if(isNew)then
            newHighScore = display.newText( "New", display.contentCenterX-250, 340, native.systemFontBold, 32)
            newHighScore:setFillColor( 0, 0.549, 0.713, 1 )
            sceneGroup:insert( newHighScore )
        end

        


    elseif ( phase == "did" ) then
        --codice avviato successivamente alla schermata
    end
end

--inserire questo codice permette di riportare l'high score a zero
--[[reset high score
    local loadsave = require( "loadsave" )
    local gameSettings = {
        highScore = 0
    }        
    loadsave.saveTable( gameSettings, "settings.json" )]]--

function scene:hide( event )
    if shownHighScoreText then
		shownHighScoreText:removeSelf()
		shownHighScoreText = nil
    end
    if newHighScore then
		newHighScore:removeSelf()
		newHighScore = nil
    end
end

function scene:destroy( event )
    local sceneGroup = self.view
    if background then
		background:removeSelf()
		background = nil
	end
    if gameover then
		gameover:removeSelf()
		gameover = nil
    end

    if playButton then
		playButton:removeSelf()
		playButton = nil
    end

    if punteggio then
		punteggio:removeSelf()
		punteggio = nil
    end
    
    if value then
		value:removeSelf()
		value = nil
    end

    if hText then
		hText:removeSelf()
		hText = nil
    end

    if uniud then
		uniud:removeSelf()
		uniud = nil
    end
end

--ascolto eventi nelle varie funzioni
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene