MainMenu = {}
class("MainMenu").extends(NobleScene)

MainMenu.baseColor = Graphics.kColorWhite

local logo_tiny
local logo_hadron
local logo_collider

local collider_sequence
local hadron_sequence
local tiny_sequence
local hadron_sequence_started = false
local start_text_width = 0

function MainMenu:init()
    MainMenu.super.init(self)

    logo_tiny = Graphics.image.new("assets/images/logo_tiny")
    logo_hadron = Graphics.image.new("assets/images/logo_hadron")
    logo_collider = Graphics.image.new("assets/images/logo_collider")

    MainMenu.inputHandler = {
        upButtonDown = function()
        end,
        downButtonDown = function()
        end,
        cranked = function(change, acceleratedChange)
        end,
        AButtonDown = function()
            Noble.transition(ColliderScene, 1, Noble.TransitionType.DIP_TO_WHITE)
        end,
        BButtonDown = function()
            Noble.transition(ExampleScene, 1, Noble.TransitionType.DIP_TO_WHITE)
        end,
    }

    start_text_width = Utilities.getHorizontalCenterForText("Press A To Start")

end

function MainMenu:enter()
    MainMenu.super.enter(self)
    collider_sequence = Sequence.new():from(0):to(155, 1.5, Ease.outBounce):start()
    tiny_sequence = Sequence.new():from(0):to(15, 1.5, Ease.outBounce):start()
    hadron_sequence = Sequence.new():from(0):to(60, 1, Ease.outElastic)
end



function MainMenu:start()
    MainMenu.super.start(self)

end

function MainMenu:drawBackground()
    MainMenu.super.drawBackground(self)

end

function MainMenu:update()
    MainMenu.super.update(self)
    logo_collider:draw(20, collider_sequence:get())
    logo_tiny:draw(125, tiny_sequence:get())

    if(tiny_sequence:isDone()) then
        if(not hadron_sequence_started) then
            hadron_sequence_started = true
            hadron_sequence:start()
        end
        logo_hadron:draw(10, hadron_sequence:get())
    end
    if(hadron_sequence:isDone()) then
        Noble.Text.draw("Press A to start", start_text_width, 220)
    end
end

function MainMenu:exit()
    MainMenu.super.exit(self)

    collider_sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
    collider_sequence:start();

end

function MainMenu:finish()
    MainMenu.super.finish(self)
end
