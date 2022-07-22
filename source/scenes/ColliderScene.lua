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
local sparkSprite
local sparkSprites         = {}
local radialPosition       = 0
local particleImageTable   = playdate.graphics.imagetable.new("assets/images/pulp-tile-0-layer-Sprites-fps-20-count-4-table-8-8")
local particleSpritesIndex = 1
local gTime                = 0
local scoreTextWidth       = 0

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
end

local function SpawnNewSprite(x, y)
	particleSpritesIndex = particleSpritesIndex + 1
	local sprite = AnimatedSprite.new(particleImageTable)
	sprite:setZIndex(particleSpritesIndex)
	sprite:setImageDrawMode(playdate.graphics.kDrawModeNXOR)
	sprite:moveTo(x, y)
	sprite:playAnimation()
	sprite:add()
	sparkSprites[particleSpritesIndex] = sprite
end

-- This runs once a transition from another scene is complete.
function ColliderScene:start()
	ColliderScene.super.start(self)
	-- Add sprites to the scene
	thcSprite:add()
	thcSprite:moveTo(200, 120)
	thcSprite:setRotation(0)
	outerWallSprite:add()
	outerWallSprite:moveTo(200, 120)
	particleSprite:add()
	particleSprite:moveTo(200, 59)
	Noble.Input.setCrankIndicatorStatus(true)
	scoreTextWidth = Utilities.getHorizontalCenterForText("Score: 999")
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
	local xOffset = sine * 5

	-- Play intro sequence
	thcSprite:setRotation(introSequence:get())
	gfx.pushContext(outerWallSprite)
	gfx.setDitherPattern(introSequenceBg:get())
	gfx.popContext()

	gfx.pushContext()
	gfx.setImageDrawMode(playdate.graphics.kDrawModeNXOR)
	local scoreText = "Score: " .. tostring(Noble.GameData.get("score"))
	Noble.Text.draw(scoreText, scoreTextWidth, 20)
	gfx.popContext()
	-- Check if crank has made full rotation, and add to score if so
	if (radialPosition >= 360) then
		radialPosition = 0
		particleSprite:setImageDrawMode(playdate.graphics.kDrawModeNXOR)
		Noble.GameData.set("score", Noble.GameData.get("score") + Noble.GameData.get("manual_multiplier") + Noble.GameData.get("auto_multiplier"))
		SpawnNewSprite(200, 120)
	end

	-- Update spark particles
	gfx.pushContext()
	for i = #sparkSprites, 1, -1 do
		local sprite = sparkSprites[i]
		if (sprite) then
			sprite:moveTo(sprite.x + xOffset, sprite.y + 5)
			if (sprite.y > 240) then
				sprite:remove()
				sparkSprites[sprite] = nil
			end
		end
	end
	gfx.popContext()
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
end

-- This runs once a transition to another scene completes.
function ColliderScene:finish()
	ColliderScene.super.finish(self)
	-- Your code here
end

function ColliderScene:pause()
	ColliderScene.super.pause(self)
	-- Your code here
end

function ColliderScene:resume()
	ColliderScene.super.resume(self)
	-- Your code here
end

local previous_crank_angle = 0
-- You can define this here, or within your scene's init() function.
ColliderScene.inputHandler = {
	AButtonDown = function()
	end,
	BButtonDown = function()
	end,
	leftButtonDown = function()
	end,
	rightButtonDown = function()
	end,
	cranked = function(change, acceleratedChange)
		radialPosition += (1 * math.abs(change))
		local theta = math.rad(change)
		local newX, newY = Utilities.rotateAroundPoint(theta, particleSprite.x, particleSprite.y, 200, 120)
		particleSprite:moveTo(newX, newY)
	end,
	crankDocked = function()
	end,
	crankUndocked = function()
	end
}
