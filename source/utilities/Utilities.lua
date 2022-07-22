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

function Utilities.getHorizontalCenterForText(text)
	local current_font = Noble.Text.getCurrentFont()
	local screen_width = playdate.display.getWidth()
	return screen_width / 2 - current_font:getTextWidth(text) / 2
end

function Utilities.rotateAroundPoint(theta, pX, pY, oX, oY)
	local newX = math.cos(theta) * (pX - oX) - math.sin(theta) * (pY - oY) + oX
	local newY = math.sin(theta) * (pX - oX) + math.cos(theta) * (pY - oY) + oY
	return newX, newY
end