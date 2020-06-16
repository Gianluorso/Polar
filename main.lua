soundTable = {
    background = audio.loadStream("sound/background.mp3"),
    jump = audio.loadSound( "sound/jump.mp3" ),
    click = audio.loadSound( "sound/click.mp3" ), --menu click
    run = audio.loadStream("sound/ice.mp3"),
    water = audio.loadSound("sound/splash.mp3")
}
local composer = require "composer"

display.setStatusBar(display.HiddenStatusBar)
-- Removes bottom bar on Android 
if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 then
  native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
  native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
end


composer.gotoScene( "scene.menu" )
