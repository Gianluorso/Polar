--caricamento file audio
soundTable = {
    background = audio.loadStream("sound/background.mp3"),
    jump = audio.loadSound( "sound/jump.mp3" ),
    click = audio.loadSound( "sound/click.mp3" ), --menu click
    run = audio.loadStream("sound/run.mp3"),
    water = audio.loadSound("sound/water.mp3")
}

--inserimento libreria composer
local composer = require "composer"

-- rimuovo la bar di Android 
display.setStatusBar(display.HiddenStatusBar)
if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 then
  native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
  native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
end

--avvio scena menu
composer.gotoScene( "scene.menu" )
