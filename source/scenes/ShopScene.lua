ShopScene = {}
class("ShopScene").extends(NobleScene)

ShopScene.baseColor = Graphics.kColorWhite

local gfx = playdate.graphics
local itemNameMenu
local itemQtyMenu
local itemPriceMenu
local sequence
local items

local function selectNextItems()
	itemNameMenu:selectNext()
	itemQtyMenu:selectNext()
	itemPriceMenu:selectNext()
end

local function selectPreviousItems()
	itemNameMenu:selectPrevious()
	itemQtyMenu:selectPrevious()
	itemPriceMenu:selectPrevious()
end

local function tryPurchaseItem(item)
	if (Utilities.tryPurchaseItem(item)) then
		local current_quantity = Noble.GameData.get("items")[item.item_id].current_quantity
		itemQtyMenu:setItemDisplayName(item.item_name, current_quantity)
		itemPriceMenu:setItemDisplayName(item.item_name,
			Utilities.calculateNextItemPrice(tonumber(item.base_price), tonumber(current_quantity)))
	end
end

function ShopScene:init()
	ShopScene.super.init(self)
	itemNameMenu = Noble.Menu.new(false, Noble.Text.ALIGN_LEFT, false, Graphics.kColorWhite, 4, 6, 0, Noble.Text.FONT_MEDIUM)
	itemQtyMenu = Noble.Menu.new(false, Noble.Text.ALIGN_LEFT, false, Graphics.kColorWhite, 4, 6, 0, Noble.Text.FONT_MEDIUM)
	itemPriceMenu = Noble.Menu.new(false, Noble.Text.ALIGN_LEFT, false, Graphics.kColorWhite, 4, 6, 0,
		Noble.Text.FONT_MEDIUM)
	items = Noble.GameData.get("items")
	
	for _, value in ipairs(items) do
		itemNameMenu:addItem(value.item_name, function()
			tryPurchaseItem(value)
		end)
		itemQtyMenu:addItem(value.item_name, nil, nil, value.current_quantity)
		itemPriceMenu:addItem(value.item_name, nil, nil,
			tostring(Utilities.calculateNextItemPrice(tonumber(value.base_price), tonumber(value.current_quantity))))
	end

	local crankTick = 0
	ShopScene.inputHandler = {
		upButtonDown = function()
			selectPreviousItems()
		end,
		downButtonDown = function()
			selectNextItems()
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				selectNextItems()
			elseif (crankTick < -30) then
				crankTick = 0
				selectPreviousItems()
			end
		end,
		AButtonDown = function()
			itemNameMenu:click()
		end,
		BButtonDown = function()
			Noble.transition(ColliderScene, 1, Noble.TransitionType.DIP_TO_WHITE)
		end
	}

end

function ShopScene:enter()
	ShopScene.super.enter(self)
	sequence = Sequence.new():from(0):to(50, 1.5, Ease.outBounce)
	sequence:start();

end

function ShopScene:start()
	ShopScene.super.start(self)
	itemNameMenu:activate()
	itemQtyMenu:activate()
	itemPriceMenu:activate()
	print(Utilities.getHorizontalCenterForText("(B) to return to the T.H.C.", Noble.Text.FONT_LARGE))
end

function ShopScene:drawBackground()
	ShopScene.super.drawBackground(self)
end

function ShopScene:update()
	ShopScene.super.update(self)

	gfx.setColor(Graphics.kColorBlack)
	Noble.Text.draw("Upgrades", 100, 25, Noble.Text.ALIGN_CENTER)
	Noble.Text.draw("Owned", 220, 25, Noble.Text.ALIGN_CENTER)
	Noble.Text.draw("Price", 315, 25, Noble.Text.ALIGN_CENTER)
	Noble.Text.draw("(B) to return to the T.H.C.", 56.5, 220, nil, nil, Noble.Text.FONT_LARGE )
	gfx.fillRoundRect(15, 45, 175, 150, 15)
	gfx.fillRoundRect(195, 45, 55, 150, 15)
	gfx.fillRoundRect(255, 45, 130, 150, 15)
	itemNameMenu:draw(30, 60)
	itemQtyMenu:draw(210, 60)
	itemPriceMenu:draw(270, 60)
end

function ShopScene:exit()
	ShopScene.super.exit(self)
	Utilities.updateTimeAndSave()
	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();

end

function ShopScene:finish()
	ShopScene.super.finish(self)
end
