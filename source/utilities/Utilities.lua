-- Put your utilities and other helper functions here.
-- The "Utilities" table is already defined in "noble/Utilities.lua."
-- Try to avoid name collisions.

function Utilities.getZero()
	return 0
end

function Utilities.getIndex(tab, val)
	local index = nil
	for i, v in ipairs(tab) do
		if (v.id == val) then
			index = i
		end
	end
	return index
end

function Utilities.getHorizontalCenterForText(text, font)
	local current_font = Noble.Text.getCurrentFont()
	if(font ~= nil) then
		current_font = font
	end
	local screen_width = playdate.display.getWidth()
	return screen_width / 2 - current_font:getTextWidth(text) / 2
end

function Utilities.rotateAroundPoint(theta, pX, pY, oX, oY)
	local newX = math.cos(theta) * (pX - oX) - math.sin(theta) * (pY - oY) + oX
	local newY = math.sin(theta) * (pX - oX) + math.cos(theta) * (pY - oY) + oY
	return newX, newY
end

function Utilities.calculateNextItemPrice(base_price, current_quantity)
	return math.floor(base_price * (1.5 ^ current_quantity))
end

function Utilities.tryPurchaseItem(item)
	local current_score = Noble.GameData.get("score")
	local next_price = Utilities.calculateNextItemPrice(tonumber(item.base_price), tonumber(item.current_quantity))
	local items = Noble.GameData.get("items")

	if (current_score >= next_price) then
		Noble.GameData.set("score", current_score - next_price)
		item.current_quantity = item.current_quantity + 1
		items[item.item_id] = item
		Noble.GameData.set("items", items)
		Noble.GameData.set("auto_multiplier", Noble.GameData.get("auto_multiplier") + item.base_auto_multiplier)
		Noble.GameData.set("manual_multiplier", Noble.GameData.get("manual_multiplier") + item.base_manual_multiplier)
		Utilities.saveCurrentTime()
		Noble.GameData.save()
		return true
	else
		print("Not enough money!")
		return false
	end
end

--find distance between two gmt time tables (taken from https://github.com/TotsIsTots/Cookie-Cranker/blob/30d47814a58f0c2c863e75c3014b9159cde032b0/source/main.lua#L20-L31)
function Utilities.getTimeDiffInSeconds(t1, t2)
	local yearDiff = t2["year"] - t1["year"]
	local monthDiff = t2["month"] - t1["month"]
	local dayDiff = t2["day"] - t1["day"]
	local hourDiff = t2["hour"] - t1["hour"]
	local minuteDiff = t2["minute"] - t1["minute"]
	local secondDiff = t2["second"] - t1["second"]
	local millisecondDiff = t2["millisecond"] - t1["millisecond"]
	return (yearDiff * 31536000) + (monthDiff * 2592000) + (dayDiff * 86400) + (hourDiff * 3600) + (minuteDiff * 60) +
			secondDiff + (millisecondDiff / 1000)
end

function Utilities.saveCurrentTime()
	Noble.GameData.set("lastGMT", playdate.getGMTTime())
end