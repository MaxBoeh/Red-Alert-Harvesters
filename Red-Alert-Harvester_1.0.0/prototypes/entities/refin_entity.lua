data:extend(
{ 
	{
		type = "container",
		name = "refinery-chest",
		icon = "__Red-Alert-Harvester__/graphics/icons/refin_icon.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation"},
		--collision_box = {{-2.49, -2.49}, {2.49, 2.49}},
		--selection_box = {{-2.5, -1.5}, {2.5, 2.5}},
		--collision_mask = {"object-layer"},
		collision_box = {{-2.85, -2.85}, {2.85, 2.35}},
		selection_box = {{-3, -3}, {3, 2.5}},
-- 		collision_box = {{-0.8, -2.5}, {3.5, .6}},
-- 		selection_box = {{-0.8, -3}, {3.5, 1.2}},
		minable = {mining_time = 1, result = "refinery", count = 1},
		max_health = 1000,
		corpse = "big-remnants",
		repair_sound = { filename = "__base__/sound/manual-repair-simple.ogg" },
		mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
		
		picture =
		{
		
			filename = "__Red-Alert-Harvester__/graphics/entity/refinery/refinery-top.png",
			width = 216,
			height = 216,
			shift = {0, -0.5}
		},
		connection_point =
		{
			shadow =
			{
				red = {2.6, -1.5},
				green = {2.6, -1.5}
			},
			wire =
			{
				red = {2.0, -2.6},
				green = {2.0, -2.6}
			}
		},
		inventory_size = 150,
	},
	{
		type = "optimized-decorative",
		name = "refinery",
		icon = "__Red-Alert-Harvester__/graphics/icons/refin_icon.png",
		flags = {"placeable-neutral", "not-on-map"},
		--collision_box = {{-2.49, -2.49}, {2.49, 2.49}},
		--selection_box = {{-2.5, -1.5}, {2.5, 2.5}},
		collision_mask = {"object-layer"},
		collision_box = {{-2.9, -2.9}, {2.9, 2.4}},
		selection_box = {{-3, -3}, {3, 2.5}},
		selectable_in_game = false,
		--order = "b[decorative]-b[asterisk]-b[green]",
		max_health = 1000,
		corpse = "big-remnants",
		repair_sound = { filename = "__base__/sound/manual-repair-simple.ogg" },
		mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
		render_layer = "decorative",
		
		pictures =
		{
			{
				filename = "__Red-Alert-Harvester__/graphics/entity/refinery/refinery.png",
				width = 216,
				height = 216,
				shift = {0, -0.5}
			}
		},
	},
   {
     type = "container",
     name = "refinery",
	 icon = "__Red-Alert-Harvester__/graphics/icons/refin_icon.png",
	 icon_size = 32,
     flags = {"placeable-neutral", "player-creation"},
     minable = {mining_time = 1, result = "refinery"},
     max_health = 10000,
     corpse = "big-remnants",
     collision_box = {{-0.8, -2.5}, {3.5, .6}},
     selection_box = {{-0.8, -3}, {3.5, 1.2}},
 				  --{{left,up}{right,down}},--
     inventory_size = 160,
     picture =
     {
       filename = "__Red-Alert-Harvester__/graphics/entity/refinery/refinery.png",
       priority = "extra-high",
       width = 216,
       height = 216,
       shift = {0.3, 0}
     },
    }
  }
)