import 'libraries/noble/Noble'
import 'libraries/AnimatedSprite/AnimatedSprite'

import 'utilities/Utilities'
import 'scenes/ExampleScene'
import 'scenes/ExampleScene2'
import 'scenes/ColliderScene'
import 'scenes/MainMenu'

Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({
	score = 0,
	auto_multiplier = 0,
	manual_multiplier = 1,
	items = {
		{
			current_count = 1,
			item_description = "Increases the muons earned by each crank",
			item_id = 1,
			item_name = "Grease",
			item_next_price = 10,
		},
		{
			current_count = 0,
			item_description = "Increases the muons earned automatically",
			item_id = 2,
			item_name = "Magnets",
			item_next_price = 100,
		},
		{
			current_count = 0,
			item_description = "Somehow increases muons earned automatically",
			item_id = 3,
			item_name = "Rounding Errors",
			item_next_price = 1000,
		},
		{
			current_count = 0,
			item_description = "Increases(??) the muons earned automatically",
			item_id = 4,
			item_name = "Detectors",
			item_next_price = 10000,
		},
		{
			current_count = 0,
			item_description = "Magics muons into existence",
			item_id = 5,
			item_name = "Arcane Knowledge",
			item_next_price = 100000,
		},
	}
}, 1, true, true)

Noble.showFPS = false

Noble.new(MainMenu, .5, Noble.TransitionType.CROSS_DISSOLVE)
