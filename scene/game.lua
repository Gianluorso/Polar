local composer = require("composer")
local widget = require("widget")
local physics = require "physics"

local backgroundMusicChannel =
    audio.play(soundTable["background"], {loops = -1})
-- audio.stop()

physics.start()
-- physics.setDrawMode("hybrid")

local scene = composer.newScene()
----score----
scoreText = display.newText("0", display.contentCenterX, 30, native.systemFont,
                            36)

local sfondo3
local sfondo2
local sfondo1

local ground
local bearSheet
local bear
local runMusicChannel
local runMusicStarted = false
local jumpMusicChannel
local jumpMusicStarted = false
local waterChannel
local waterStarted = false

local bearRotation = 0

start_time = 0
trick_score = 0

local function stopAllSounds()
    audio.stop(backgroundMusicChannel)
    if (runMusicStarted) then
        audio.stop(runMusicChannel)
        runMusicStarted = false
    end
    if (jumpMusicStarted) then
        audio.stop(jumpMusicChannel)
        jumpMusicStarted = false
    end
    if (waterStarted) then
        audio.stop(waterChannel)
        --waterStarted = false
    end
end

-- bearSheet collision handler
local function sensorCollide(self, event)

    -- Confirm that the colliding elements are the foot sensor and a ground object
    if (event.selfElement == 2 and event.other.objType == "ground") then
        if (not runMusicStarted) then
            runMusicChannel = audio.play(soundTable["run"], {loops = -1})
            -- comment the following line to enable walk sound
            audio.setVolume(1, {channel = runMusicChannel})
            runMusicStarted = true
        end

        -- Foot sensor has entered (overlapped) a ground object
        if (event.phase == "began") then
            self.sensorOverlaps = self.sensorOverlaps + 1
            audio.resume(runMusicChannel)
            -- Foot sensor has exited a ground object
        elseif (event.phase == "ended") then
            self.sensorOverlaps = self.sensorOverlaps - 1
            audio.pause(runMusicChannel)
        end
    end
end

function scene:create(event)
    start_time = os.time()

    physics.start()
    local sceneGroup = self.view

    local sfondo3 = display.newImageRect("img/sfondo3.png",
                                         display.contentWidth * 2,
                                         display.contentHeight)
    sfondo3.anchorX = 0
    sfondo3.anchorY = 0
    sfondo3.x = display.contentWidth - 200
    sfondo3.y = display.contentHeight - sfondo3.height
    local sfondo3_next = display.newImageRect("img/sfondo3.png",
                                              display.contentWidth * 2,
                                              display.contentHeight)
    sfondo3_next.anchorX = 0
    sfondo3_next.anchorY = 0
    sfondo3_next.x = -200
    sfondo3_next.y = display.contentHeight - sfondo3_next.height

    local sfondo2 = display.newImageRect("img/sfondo2.png",
                                         display.contentWidth * 2,
                                         display.contentHeight)
    sfondo2.anchorX = 0
    sfondo2.anchorY = 0
    sfondo2.x = display.contentWidth - 200
    sfondo2.y = display.contentHeight - sfondo2.height
    local sfondo2_next = display.newImageRect("img/sfondo2.png",
                                              display.contentWidth * 2,
                                              display.contentHeight)
    sfondo2_next.anchorX = 0
    sfondo2_next.anchorY = 0
    sfondo2_next.x = -200
    sfondo2_next.y = display.contentHeight - sfondo2_next.height

    local sfondo1 = display.newImageRect("img/sfondo1.png", 2040,
                                         display.contentHeight)
    sfondo1.anchorX = 0
    sfondo1.anchorY = 0
    sfondo1.x = -1000
    sfondo1.y = display.contentHeight - sfondo1.height
    local sfondo1_next = display.newImageRect("img/sfondo1.png", 2040,
                                              display.contentHeight)
    sfondo1_next.anchorX = 0
    sfondo1_next.anchorY = 0
    sfondo1_next.x = 1030
    sfondo1_next.y = display.contentHeight - sfondo1_next.height

    local function scroller3(self, event)
        local speed = 1

        if self.x < -(display.contentWidth + 200 - speed * 2) then
            self.x = display.contentWidth - 200
        else
            self.x = self.x - speed
        end
    end

    local function scroller2(self, event)
        local speed = 2

        if self.x < -(display.contentWidth + 200 - speed * 2) then
            self.x = display.contentWidth - 200
        else
            self.x = self.x - speed
        end
    end

    local function scroller(self, event)
        local speed = 3

        if self.x < -2250 then
            self.x = self.x + 4060
        else
            self.x = self.x - speed
        end
    end
    local function scroller4(self, event)
        local speed = 6

        if self.x < -2250 then
            self.x = self.x + 4070
        else
            self.x = self.x - speed
        end
    end

    local ground = display.newImageRect("img/ground.png", 2040,
                                        display.contentHeight)
    ground.anchorX = 0
    ground.anchorY = 0
    ground.x = -1000
    ground.y = display.contentHeight - ground.height
    local ground_next = display.newImageRect("img/ground.png", 2040,
                                             display.contentHeight)

    ground_next.anchorX = 0
    ground_next.anchorY = 0
    ground_next.x = 1040
    ground_next.y = display.contentHeight - ground_next.height

    --[[local ground = display.newImage("img/ground.png")
    ground.x = 160
    ground.y = 700
        ground.objType = "ground"
    physics.addBody(ground, "static", {bounce = 0.0, friction = 0.3})]] --

    -- Platform
    local function createPlatform(size, posX, posY)
        local img = "img/platform2.png"
        local xOffset = 5
        local bboxHeight = 48 -- height of platform collider
        if (size == 3) then
            img = "img/platform1.png"
            bboxHeight = 48
            xOffset = 0
        elseif (size == 4) then
            img = "img/platform3.png"
            bboxHeight = 49
            xOffset = 0
        end

        local newPlatform = display.newImage(img)
        newPlatform.x = posX
        newPlatform.y = posY + 100

        newPlatform:setFillColor(1, 1, 1)
        newPlatform.objType = "ground"
        local scale = size
        physics.addBody(newPlatform, "kinematic", {
            bounce = 0.0,
            friction = 0.3,
            shape = {
                -60 * scale + xOffset, 100, 60 * scale + xOffset, 100,
                60 * scale + xOffset, -bboxHeight, -60 * scale + xOffset,
                -bboxHeight
            }
        })
        -- newPlatform.xScale = scale
        return newPlatform
    end

    local platformDistance = 600
    local maxPlatformDistance = 1200
    local platformSpeed = 2
    local maxPlatformSpeed = 5
    local platformNormal = createPlatform(3, platformDistance * 3, 400)
    local platformSmall = createPlatform(2, platformDistance * 2, 450)
    local platformBig = createPlatform(4, platformDistance,
                                       display.contentCenterY + 100)
    local fallingSpeed = 0.1
    local platformSmallFalling = false
    local platformNormalFalling = false
    local platformBigFalling = false

    local function checkAndRepositionPlatform(platform, isFalling)
        if (platform.x < -600) then
            platform.x = platformDistance * 2
            platform.y = 550 - math.random(150)

            if (platform.y < 450) then
                isFalling = true
            else
                isFalling = false
            end

            if (platformDistance < maxPlatformDistance) then
                platformDistance = platformDistance + 4
            end

            if (platformSpeed < maxPlatformSpeed) then
                platformSpeed = platformSpeed +
                                    ((maxPlatformSpeed - platformSpeed) / 100)
            end
        end
        return isFalling
    end

    local opt = {numFrames = 8, width = 512, height = 512}
    local bearSheet = graphics.newImageSheet("img/bear.png", opt)

    local runningSeqs = {
        count = 8,
        start = 1,
        loopCount = 0,
        loopDirection = "forward",
        time = 800
    }

    local bear = display.newSprite(bearSheet, runningSeqs)
    bear.xScale = 0.4
    bear.yScale = 0.4
    bear.timeScale = 2.0
    bear.x = 180
    bear.y = display.contentCenterY
    bear.isFixedRotation = true
    bear.sensorOverlaps = 0

    bear:play()

    -- Associate collision handler function with character
    bear.collision = sensorCollide
    bear:addEventListener("collision")

    local function onTouch(event)
        if (event.phase == "began" and bear.sensorOverlaps > 0) then
            jumpMusicChannel = audio.play(soundTable["jump"])
            jumpMusicStarted = true

            bear.gravityScale = 3.5
            bear:setLinearVelocity(17, -695)
            bear:pause()
        elseif (event.phase == "ended") then
            bear.gravityScale = 10
            bear:play()
        end
    end

    local flipTextShown
    local isTextShown = false
    --[[local rainbowColors = {
        {255, 0, 0}, {255, 165, 0}, {255, 255, 0}, {0, 180, 0}, {0, 0, 255},
        {75, 0, 130}, {238, 130, 238}
    }]] --
    local rainbowColors = {
        {0, 165, 255}, {0, 255, 255}, {0, 108, 255}, {200, 255, 255}
    }
    local rainbowRepetitions = 0
    local rainbowColorIndex = 1

    -- executex every frame
    local function on_frame(event)
        -- rainbow color
        if (isTextShown) then
            local textR = rainbowColors[rainbowColorIndex][1]
            local textG = rainbowColors[rainbowColorIndex][2]
            local textB = rainbowColors[rainbowColorIndex][3]
            rainbowRepetitions = rainbowRepetitions + 1
            if (rainbowRepetitions >= 20) then
                rainbowRepetitions = 0
                rainbowColorIndex = (rainbowColorIndex + 1) %
                                        table.getn(rainbowColors)
                -- apparently arrays in lua starts from 1 :/
                if (rainbowColorIndex == 0) then
                    rainbowColorIndex = rainbowColorIndex + 1
                end
            end
            flipTextShown:setFillColor(textR / 255.50, textG / 255.50,
                                       textB / 255.50)
        end
        -- check for frontflip or backflip
        local bearActualRotation = bear.rotation
        if (math.abs(math.abs(bearRotation) - math.abs(bearActualRotation)) >=
            350) then

            local flipText = "Frontflip!"
            trick_score = trick_score + 300

            if (bearActualRotation > bearRotation) then
                bearRotation = bearRotation + 360
            else
                bearRotation = bearRotation - 360
                flipText = "BackFlip!"
            end

            if (isTextShown) then
                isTextShown = false
                display.remove(flipTextShown)
            end

            flipTextShown = display.newText(flipText, display.contentCenterX,
                                            display.contentCenterY - 250,
                                            native.systemFont, 48)
            isTextShown = true

            local function hideText(event)
                if (isTextShown) then
                    isTextShown = false
                    display.remove(flipTextShown)
                end
            end

            timer.performWithDelay(2000, hideText)
        end

        -- move platforms
        platformSmall.x = platformSmall.x - platformSpeed
        platformNormal.x = platformNormal.x - platformSpeed
        platformBig.x = platformBig.x - platformSpeed

        platformSmallFalling = checkAndRepositionPlatform(platformSmall,
                                                          platformSmallFalling)
        platformNormalFalling = checkAndRepositionPlatform(platformNormal,
                                                           platformNormalFalling)
        platformBigFalling = checkAndRepositionPlatform(platformBig,
                                                        platformBigFalling)

        if (platformSmallFalling) then
            platformSmall.y = platformSmall.y + fallingSpeed
        end
        if (platformNormalFalling) then
            platformNormal.y = platformNormal.y + fallingSpeed
        end
        if (platformBigFalling) then
            platformBig.y = platformBig.y + fallingSpeed
        end

        -- controllo ad ogni frame se il giocatore e' rimasto indietro
        if (bear.x < -250) then
            audio.rewind(backgroundMusicChannel)
            stopAllSounds()
            if (isTextShown) then display.remove(flipTextShown) end
            composer.removeScene("scene.game")
            composer.gotoScene("scene.gameover")
        end
        -------------splash-----------
        if (bear.y > 600) then
            if (not waterStarted) then
                waterChannel = audio.play(soundTable["water"])
                waterStarted = true
            end
        end
        -------------splash reset-----------
        if (bear.y < 400) then
            if (waterStarted) then
                audio.stop(waterChannel)
                waterStarted = false
            end
        end
        -- controllo ad ogni frame se il giocatore e' caduto
        if (bear.y > 1900) then
            audio.rewind(backgroundMusicChannel)
            stopAllSounds()
            
            if (isTextShown) then display.remove(flipTextShown) end
            composer.removeScene("scene.game")
            composer.gotoScene("scene.gameover")
        end

        elapsed_time = os.difftime(os.time(), start_time)
        scoreText.text = elapsed_time + trick_score
    end
    sfondo3.enterFrame = scroller3
    Runtime:addEventListener("enterFrame", sfondo3)
    sfondo3_next.enterFrame = scroller3
    Runtime:addEventListener("enterFrame", sfondo3_next)
    Runtime:addEventListener("enterFrame", on_frame)

    sfondo2.enterFrame = scroller2
    Runtime:addEventListener("enterFrame", sfondo2)
    sfondo2_next.enterFrame = scroller2
    Runtime:addEventListener("enterFrame", sfondo2_next)
    Runtime:addEventListener("enterFrame", on_frame)

    sfondo1.enterFrame = scroller
    Runtime:addEventListener("enterFrame", sfondo1)
    sfondo1_next.enterFrame = scroller
    Runtime:addEventListener("enterFrame", sfondo1_next)
    Runtime:addEventListener("enterFrame", on_frame)

    ground.enterFrame = scroller4
    Runtime:addEventListener("enterFrame", ground)
    ground_next.enterFrame = scroller4
    Runtime:addEventListener("enterFrame", ground_next)
    Runtime:addEventListener("enterFrame", on_frame)

    Runtime:addEventListener("touch", onTouch)
    sceneGroup:insert(sfondo3)
    sceneGroup:insert(sfondo3_next)
    sceneGroup:insert(sfondo2)
    sceneGroup:insert(sfondo2_next)
    sceneGroup:insert(sfondo1)
    sceneGroup:insert(sfondo1_next)

    sceneGroup:insert(platformNormal)
    sceneGroup:insert(platformSmall)
    sceneGroup:insert(platformBig)
    sceneGroup:insert(bear)
    sceneGroup:insert(ground)
    sceneGroup:insert(ground_next)

    local limiteavanti = display.newRect(950, 350, 250, 650)
    limiteavanti:setFillColor(1, 0, 0, 0.6)
    limiteavanti.isVisible = false
    limiteavanti.rotation = 5
    physics.addBody(limiteavanti, "static", {bounce = 0.0, friction = 0.3})

    local limitealto = display.newRect(600, -50, 800, 50)
    limitealto:setFillColor(1, 0, 0, 0.6)
    limitealto.isVisible = false
    limitealto.objType = "ground"
    physics.addBody(limitealto, "static", {bounce = 0.0, friction = 0.3})

    -- local limitebasso = display.newRect(display.contentWidth/2, 600, 1700, 50)
    -- limitebasso:setFillColor(1, 0, 0, 0.6)
    -- limitebasso.isVisible = false
    -- limitebasso.objType = "ground"
    -- physics.addBody(limitebasso, "static", {bounce = 0.0, friction = 0.3})

    local contorno_bear = {-95, 50, -110, -50, 100, -50, 70, 50}
    physics.addBody(bear, "dinamic", {shape = contorno_bear}, -- Main body element
                    {
        box = {halfWidth = 85, halfHeight = 10, x = -10, y = 60},
        isSensor = true
    } -- Foot sensor element
    )
    -- Function to handle button events
    local function handleButtonEvent(event)

        if ("ended" == event.phase) then
            audio.stop(runMusicChannel)
            audio.rewind(backgroundMusicChannel)
            runMusicStarted = false
            composer.removeScene("scene.game")
            composer.gotoScene("scene.menu")
        end
    end

    --[[local reset = widget.newButton({
        label = "Reset",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 150,
        height = 70,
        cornerRadius = 45,
        fillColor = {default = {0.133, 0.498, 0.788, 1}, over = {0.275, 0.847, 1}},
        strokeColor = {default = {1, 1, 1}, over = {1, 1, 1}},
        strokeWidth = 0,
        labelColor = {default = {1, 1, 1}, over = {1, 1, 1, 1}}

    })
    reset.x = 800
    reset.y = 100

    sceneGroup:insert(reset)]] --

end

function scene:show(event) end

function scene:hide(event) end

function scene:destroy(event)
    local sceneGroup = self.view

    -- Removes all the runtime event listeners
    Runtime._functionListeners = nil

    if sfondo3 then
        sfondo3:removeSelf()
        sfondo3 = nil
    end
    if sfondo3_next then
        sfondo3_next:removeSelf()
        sfondo3_next = nil
    end
    if sfondo2 then
        sfondo2:removeSelf()
        sfondo2 = nil
    end
    if sfondo2_next then
        sfondo2_next:removeSelf()
        sfondo2_next = nil
    end
    if sfondo1 then
        sfondo1:removeSelf()
        sfondo1 = nil
    end
    if sfondo1_next then
        sfondo1_next:removeSelf()
        sfondo1_next = nil
    end

    if ground then
        ground:removeSelf()
        ground = nil
    end
    if ground_next then
        ground_next:removeSelf()
        ground_next = nil
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
        reset:removeSelf() -- widgets must be manually removed
        reset = nil
    end

    physics.stop()

    sceneGroup:removeSelf()
    sceneGroup = nil
end

-- Scene listener setup

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
