--
-- ColliderScene.lua
--
-- Use this as a starting point for your game's scenes. Copy this file to your root "scenes" directory,
-- rename it as you like, and then replace all instances of "ColliderScene" with your scene's name.
--

ColliderScene = {}
class("ColliderScene").extends(NobleScene)

local gfx = playdate.graphics
local introSequence
local introSequenceBg

-- Local vars
local thcSprite
local outerWallSprite
local particleSprite
local sparkSprites         = {}
local radialPosition       = 0
local particleImageTable   = playdate.graphics.imagetable.new("assets/images/sparks.gif")
local particleSpritesIndex = 1
local gTime                = 0
local scoreTextWidth       = 0
local auto_timer = nil

ColliderScene.backgroundColor = Graphics.kColorWhite
math.randomseed(playdate.getSecondsSinceEpoch())

-- This runs when your scene's object is created, which is the first thing that happens when transitining away from another scene.
function ColliderScene:init()
	ColliderScene.super.init(self)
	thcSprite = NobleSprite("assets/images/thc.png")
	outerWallSprite = NobleSprite("assets/images/outer_wall.png")
	particleSprite = NobleSprite("assets/images/particle2.png")
end

-- When transitioning from another scene, this runs as soon as this scene needs to be visible (this moment depends on which transition type is used).
function ColliderScene:enter()
	ColliderScene.super.enter(self)

	introSequence = Sequence.new():from(0.0):to(360.0, 2.5, Ease.outBounce)
	introSequence:start();
	introSequenceBg = Sequence.new():from(0):to(1, 4.5, Ease.outBounce)
	introSequenceBg:start();

	-- Add sprites to the scene
	thcSprite:add()
	thcSprite:moveTo(200, 120)
	thcSprite:setRotation(0)
	outerWallSprite:add()
	outerWallSprite:moveTo(200, 120)
	particleSprite:add()
	particleSprite:moveTo(200, 59)

	scoreTextWidth = Utilities.getHorizontalCenterForText("Score: 999", Noble.Text.FONT_LARGE)
end

local function SpawnNewSprite(x, y)
	local sprite = AnimatedSprite.new(particleImageTable)
	sprite:addState("falling",nil, nil, nil, {loop = false}, true)
	sprite.states["falling"].onFrameChangedEvent = function(self)
		if(self._currentFrame == 17) then
			self:remove()
		end
	end
	sprite:setZIndex(particleSpritesIndex)
	sprite:setImageDrawMode(playdate.graphics.kDrawModeNXOR)
	sprite:moveTo(x, y)
	sprite:playAnimation()
	sprite:add()
end

local function SpawnNewSprites(numberOfSprites, x,y)
	for i = 1, numberOfSprites do
		SpawnNewSprite(x, y)
	end
end


-- This runs once a transition from another scene is complete.
function ColliderScene:start()
	ColliderScene.super.start(self)
	Noble.Input.setCrankIndicatorStatus(true)
	auto_timer = playdate.timer.keyRepeatTimerWithDelay(1000, 1000, function ()
		local auto_multiplier = Noble.GameData.get("auto_multiplier")
		Noble.GameData.set("score", Noble.GameData.get("score") + auto_multiplier)
		Utilities.saveCurrentTime()
		if(auto_multiplier < 10) then
			SpawnNewSprites(auto_multiplier, 200, 120)
		else
			SpawnNewSprites(10, 200, 120)
		end
	end)
end

-- This runs once per frame.
function ColliderScene:update()
	ColliderScene.super.update(self)
	-- Setup delta time for update drawing calculations
	local time_delta = 0

	local current_time <const> = playdate.getCurrentTimeMilliseconds()
	if self.last_sample_time then
		time_delta = (current_time - self.last_sample_time)
	end
	self.last_sample_time = current_time
	gTime = gTime + time_delta
	local sine = math.sin(gTime)

	-- Play intro sequence
	thcSprite:setRotation(introSequence:get())
	gfx.pushContext(outerWallSprite)
	gfx.setDitherPattern(introSequenceBg:get())
	gfx.popContext()

	gfx.pushContext()
	gfx.setImageDrawMode(playdate.graphics.kDrawModeNXOR)

	local current_score = Noble.GameData.get("score")
	local current_manual_multiplier = Noble.GameData.get("manual_multiplier")
	local current_auto_multiplier = Noble.GameData.get("auto_multiplier")

	local scoreText = "Score: " .. tostring(current_score)
	local menuText = "(B): Item Shop"
	Noble.Text.draw(scoreText, scoreTextWidth, 20, nil, nil, Noble.Text.FONT_LARGE)
	Noble.Text.draw(menuText, Utilities.getHorizontalCenterForText(menuText, Noble.Text.FONT_LARGE), 220, nil, nil,
		Noble.Text.FONT_LARGE)
	gfx.popContext()
	-- Check if crank has made full rotation, and add to score if so
	if (radialPosition >= 360) then
		radialPosition = 0
		particleSprite:setImageDrawMode(playdate.graphics.kDrawModeNXOR)
		Noble.GameData.set("score", current_score + current_manual_multiplier + current_auto_multiplier)
		Utilities.saveCurrentTime()
		SpawnNewSprite(math.random(5,395), 150)
	end
end

-- This runs once per frame, and is meant for drawing code.
function ColliderScene:drawBackground()
	ColliderScene.super.drawBackground(self)
	-- Your code here
end

-- This runs as as soon as a transition to another scene begins.
function ColliderScene:exit()
	ColliderScene.super.exit(self)
	-- Your code here
	thcSprite:remove()
	outerWallSprite:remove()
	particleSprite:remove()
	auto_timer:remove()
	playdate.graphics.sprite.removeAll()
end

-- This runs once a transition to another scene completes.
function ColliderScene:finish()
	ColliderScene.super.finish(self)
	-- Your code here
end

function ColliderScene:pause()
	ColliderScene.super.pause(self)
	Utilities.saveCurrentTime()
end

function ColliderScene:resume()
	ColliderScene.super.resume(self)
	Utilities.updateScoreSinceLastPlay()
end

local previous_crank_angle = 0
-- You can define this here, or within your scene's init() function.
ColliderScene.inputHandler = {
	AButtonDown = function()
	end,
	BButtonDown = function()
		Noble.transition(ShopScene, 1, Noble.TransitionType.DIP_TO_WHITE)
	end,
	leftButtonDown = function()
	end,
	rightButtonDown = function()
	end,
	cranked = function(change, acceleratedChange)
		radialPosition = radialPosition + (1 * math.abs(change))
		local theta = math.rad(change)
		local newX, newY = Utilities.rotateAroundPoint(theta, particleSprite.x, particleSprite.y, 200, 120)
		particleSprite:moveTo(newX, newY)
	end,
	crankDocked = function()
	end,
	crankUndocked = function()
	end
}
