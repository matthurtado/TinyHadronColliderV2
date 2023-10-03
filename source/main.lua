import 'libraries/noble/Noble'
import 'libraries/AnimatedSprite/AnimatedSprite'

import 'utilities/Utilities'
import 'scenes/ShopScene'
import 'scenes/ColliderScene'
import 'scenes/MainMenu'

Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({
	score = 0,
	lastGMT = playdate.getGMTTime(),
	auto_multiplier = 0,
	manual_multiplier = 1,
	items = {
		{
			current_quantity = 1,
			item_description = "Increases the muons earned by each crank",
			item_id = 1,
			item_name = "Grease",
			base_price = 10,
			base_manual_multiplier = 1,
			base_auto_multiplier = 0
		},
		{
			current_quantity = 0,
			item_description = "Increases the muons earned automatically",
			item_id = 2,
			item_name = "Magnets",
			base_price = 100,
			base_manual_multiplier = 0,
			base_auto_multiplier = 1
		},
		{
			current_quantity = 0,
			item_description = "Somehow increases muons earned automatically",
			item_id = 3,
			item_name = "Rounding Errors",
			base_price = 1000,
			base_manual_multiplier = 0,
			base_auto_multiplier = 8
		},
		{
			current_quantity = 0,
			item_description = "Increases(??) the muons earned automatically",
			item_id = 4,
			item_name = "Detectors",
			base_price = 10000,
			base_manual_multiplier = 0,
			base_auto_multiplier = 47
		},
		{
			current_quantity = 0,
			item_description = "Magics muons into existence",
			item_id = 5,
			item_name = "Arcane Knowledge",
			base_price = 100000,
			base_manual_multiplier = 0,
			base_auto_multiplier = 260
		},
	}
}, 1, true, true)

-- update score based on seconds since the game was last played
Utilities.updateScoreSinceLastPlay()

function playdate.deviceWillLock()
	Utilities.saveCurrentTime()
end

function playdate.deviceDidUnlock()
	Utilities.updateScoreSinceLastPlay()
end

Noble.showFPS = false

Noble.new(MainMenu, .5, Noble.TransitionType.CROSS_DISSOLVE)
