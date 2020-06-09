backgroundMusic = audio.loadStream("sound/background.mp3")
jumpMusic = audio.loadStream("sound/jump.mp3")
runMusic = audio.loadStream("sound/ice.mp3")
clickMusic = audio.loadStream("sound/click.mp3")

soundTable = {
 
    jump = audio.loadSound( "sound/jump.mp3" ),
    click = audio.loadSound( "sound/click.mp3" ),
    ice = audio.loadSound( "sound/ice.mp3" ),
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
