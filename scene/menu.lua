--caricamento librerie della scena
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

--dichiarazione variabili
local background
local playButton
local logo

--elementi visualizzati nella scena
function scene:create( event )

    --creazione variabile per posizionare nel giusto ordine gli elementi visivi
    local sceneGroup = self.view
    
    --inserimento background
    local background=display.newImageRect("img/background_menu.jpg", display.contentWidth*1.2, display.contentHeight*1.2)
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2

    --inserimento logo università
    local logo =display.newImageRect("img/logo.png", 360, 63)
    logo.x = display.contentCenterX-460
    logo.y = display.contentCenterY+200

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

    --nome del gioco
    local title = display.newText( "POLAR", display.contentCenterX, 150, native.systemFontBold, 128)
    title:setFillColor( 1, 1, 1 )

    --creazione bottone play
    local playButton = widget.newButton(
        {
            --specifico diverse proprietà del bottone
            label = "Play",
            fontSize =40,
            onEvent = handleButtonEvent,
            emboss = false,
            shape = "roundedRect",
            width = 300,
            height = 100,
            cornerRadius = 45,
            fillColor = { default = { 0, 0.549, 0.713, 1}, over={0, 0.694, 0.713, 1} },
            strokeColor = { default = { 1, 1, 1 }, over = { 1, 1, 1 } },
            strokeWidth = 0,
            labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1, 1 } },            
        }
    )
    playButton.x = display.contentCenterX
    playButton.y = display.contentCenterY+150
    
    --ordine degli elementi attraverso sceneGroup
    sceneGroup:insert( background )
    sceneGroup:insert( title )
    sceneGroup:insert( playButton )
    sceneGroup:insert( logo )
end

function scene:show( event )

end

function scene:hide( event )

end

--funzione con la quale eliminare gli elementi al cambio di scena
function scene:destroy( event )
    local sceneGroup = self.view

    if background then
		background:removeSelf()	
		background = nil
    end
    
    if title then
		title:removeSelf()	
		title = nil
    end
    
    if playButton then
		playButton:removeSelf()	
		playButton = nil
    end

    if logo then
		logo:removeSelf()	
		logo = nil
    end
end

--ascolto eventi nelle varie funzioni
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene