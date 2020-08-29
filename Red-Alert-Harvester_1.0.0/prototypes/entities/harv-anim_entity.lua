data:extend{
	{
		-- Changed lines as opposed to harv_entity.lua
	
		name = "harvester-anim",
		inventory_size = 0,
		minable = {mining_time = 1, result = "harvester", count = 0},
		selectable_in_game = false,
		collision_mask = {"object-layer"},
		order = "b[decorative]-b[asterisk]-b[green]",
		
		animation =
		{
			layers =
			{
				{
					width = 144,
					height = 144,
					frame_count = 1,
					axially_symmetrical = false,
					direction_count = 117,
					shift = {0, -0.1875},
					animation_speed = 8,
					max_advance = 0.2,
					stripes =
					{
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/harvester/harvester-up-1.png",
							width_in_frames = 1,
							height_in_frames = 14,
						},
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/harvester/harvester-up-2.png",
							width_in_frames = 1,
							height_in_frames = 14,
						},
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/harvester/harvester-up-3.png",
							width_in_frames = 1,
							height_in_frames = 14,
						},
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/harvester/harvester-up-4.png",
							width_in_frames = 1,
							height_in_frames = 14,
						},
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/harvester/harvester-up-5.png",
							width_in_frames = 1,
							height_in_frames = 14,
						},
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/harvester/harvester-up-6.png",
							width_in_frames = 1,
							height_in_frames = 14,
						},
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/harvester/harvester-up-7.png",
							width_in_frames = 1,
							height_in_frames = 14,
						},
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/harvester/harvester-up-8.png",
							width_in_frames = 1,
							height_in_frames = 14,
						},
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/harvester/harvester-up-9.png",
							width_in_frames = 1,
							height_in_frames = 5,
						},
					}
				},
				{ -- Not changed.
					width = 1,
					height = 1,
					frame_count = 1,
					apply_runtime_tint = true,
					axially_symmetrical = false,
					direction_count = 32,
					max_advance = 0.2,
					line_length = 2,
					shift = {0, -0.171875},
					stripes = util.multiplystripes(2,
					{
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/transparent.png",
							width_in_frames = 1,
							height_in_frames = 64,
						},
					})
				},
				{ -- Not changed.
					width = 1,
					height = 1,
					frame_count = 1,
					draw_as_shadow = true,
					axially_symmetrical = false,
					direction_count = 64,
					shift = {0.28125, 0.25},
					max_advance = 0.2,
					stripes = util.multiplystripes(2,
					{
						{
							filename = "__Red-Alert-Harvester__/graphics/entity/transparent.png",
							width_in_frames = 1,
							height_in_frames = 64,
						},
					})
				}
			}
		},
	
		-- End of changes.
	
	
		type = "car",
		icon = "__Red-Alert-Harvester__/graphics/icons/harv_icon.png",
		icon_size = 32,
		
		max_health = 200,
		
		
		
		flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
		corpse = "medium-remnants",
		dying_explosion = "medium-explosion",
		energy_per_hit_point = 1,
		resistances =
		{
			{
				type = "fire",
				percent = 50
			},
			{
				type = "impact",
				percent = 30,
				decrease = 30
			}
		},
		collision_box = {{-0.7, -1}, {0.7, 1}},
		selection_box = {{-0.7, -1}, {0.7, 1}},
		effectivity = 0.5,
		braking_power = "200kW",
		burner =
		{
			effectivity = 0.6,
			fuel_inventory_size = 1,
			smoke =
			{
				{
					name = "smoke",
					deviation = {0.25, 0.25},
					frequency = 50,
					position = {0, 1.5},
					slow_down_factor = 0.9,
					starting_frame = 3,
					starting_frame_deviation = 5,
					starting_frame_speed = 0,
					starting_frame_speed_deviation = 5
				}
			}
		},
		consumption = "150kW",
		friction = 2e-3,
		light =
		{
			{
				type = "oriented",
				minimum_darkness = 0.3,
				picture =
				{
					filename = "__core__/graphics/light-cone.png",
					priority = "medium",
					scale = 2,
					width = 200,
					height = 200
				},
				shift = {-0.6, -14},
				size = 2,
				intensity = 0.6
			},
			{
				type = "oriented",
				minimum_darkness = 0.3,
				picture =
				{
					filename = "__core__/graphics/light-cone.png",
					priority = "medium",
					scale = 2,
					width = 200,
					height = 200
				},
				shift = {0.6, -14},
				size = 2,
				intensity = 0.6
			}
		},
		--     turret_animation =
		--     {
		--       layers =
		--       {
		--         {
		--           filename = "__base__/graphics/entity/car/car-turret.png",
		--           line_length = 8,
		--           width = 36,
		--           height = 29,
		--           frame_count = 1,
		--           axially_symmetrical = false,
		--           direction_count = 64,
		--           shift = {0.03125, -0.890625},
		--           animation_speed = 8,
		--         },
		--         {
		--           filename = "__base__/graphics/entity/car/car-turret-shadow.png",
		--           line_length = 8,
		--           width = 46,
		--           height = 31,
		--           frame_count = 1,
		--           axially_symmetrical = false,
		--           draw_as_shadow = true,
		--           direction_count = 64,
		--           shift = {0.875, 0.359375},
		--         }
		--       }
		--     },
		--     turret_rotation_speed = 0.35 / 60,
		stop_trigger_speed = 0.2,
		stop_trigger =
		{
			{
				type = "play-sound",
				sound =
				{
					{
						filename = "__base__/sound/car-breaks.ogg",
						volume = 0.6
					},
				}
			},
		},
		crash_trigger = crash_trigger(),
		sound_minimum_speed = 0.2;
		working_sound =
		{
			sound =
			{
				filename = "__base__/sound/car-engine.ogg",
				volume = 0.6
			},
			activate_sound =
			{
				filename = "__base__/sound/car-engine-start.ogg",
				volume = 0.6
			},
			deactivate_sound =
			{
				filename = "__base__/sound/car-engine-stop.ogg",
				volume = 0.6
			},
			match_speed_to_activity = true,
		},
		open_sound = { filename = "__base__/sound/car-door-open.ogg", volume=0.7 },
		close_sound = { filename = "__base__/sound/car-door-close.ogg", volume = 0.7 },
		rotation_speed = 0.015,
		weight = 700,
	},
}
