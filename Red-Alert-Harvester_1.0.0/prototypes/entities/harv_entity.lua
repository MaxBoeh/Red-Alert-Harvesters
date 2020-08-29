--[[
Mining power is 3, same as electric miner
Mining Speeds, for reference, burner is 0.35, electric is 0.5
]]--
local animation_speed = 60
    local vehicle = {
        type = "car",
        name = "harvester",
        icon = "__Red-Alert-Harvester__/graphics/icons/harv_icon.png",
        icon_size = 32,
        flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
        minable = {mining_time = 1, result = "harvester"},
        max_health = 600,
        corpse = "medium-remnants",
        dying_explosion = "medium-explosion",
        energy_per_hit_point = 0.5,
        resistances = {
            {
                type = "fire",
                decrease = 15,
                percent = 50
            },
            {
                type = "physical",
                decrease = 0,
                percent = 20
            },
            {
                type = "impact",
                decrease = 50,
                percent = 60
            },
        },
        selection_box = {{-2, -2.4}, {2, 2.4}},
        collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
        burner =
        {
            effectivity = 1,
            fuel_inventory_size = 2,
            smoke = {
                {
                    name = "tank-smoke",
                    deviation = {0.25, 0.25},
                    frequency = 50,
                    position = {0, 1.5},
                    starting_frame = 0,
                    starting_frame_deviation = 60
                }
            }
        },
        effectivity = 2,
        --weight = 15000,
        weight = 6000,
        consumption = "150kW",
        braking_power = "150kW",
        terrain_friction_modifier = 0.01,
        --friction = 0.03,
        friction = 0.045,
        rotation_speed = 0.003,
        turret_rotation_speed = 0.01,
        turret_return_timeout = 300,
        tank_driving = true,
        light =
        {
            {
                intensity = 0.6,
                minimum_darkness = 0.3,
                size = 30
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
                shift = {0, -14},
                size = 2,
                intensity = 0.6
            }
        },
        animation =
        {
            layers =
            {
              {
                    width = 1,
                    height = 1,
                    frame_count = 1,
                    direction_count = 32,
                    shift = {0.0, -0.1875},
                    animation_speed = 8,
                    max_advance = 0.2,
                    priority = "low",
                    stripes =
                    {
                        {
                            filename = "__Red-Alert-Harvester__/graphics/entity/transparent.png",
                            width_in_frames = 1,
                            height_in_frames = 64,
						},
                    }
                },
            }
        },
        stop_trigger_speed = 0.2,
        sound_no_fuel = { { filename = "__base__/sound/fight/tank-no-fuel-1.ogg", volume = 0.6 }, },
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
        sound_minimum_speed = 0.15;
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        working_sound =
        {
            sound = { filename = "__base__/sound/fight/tank-engine.ogg", volume = 0.6 },
            activate_sound = { filename = "__base__/sound/fight/tank-engine-start.ogg", volume = 0.6 },
            deactivate_sound = { filename = "__base__/sound/fight/tank-engine-stop.ogg", volume = 0.6 },
            match_speed_to_activity = true,
        },
        open_sound = { filename = "__base__/sound/car-door-open.ogg", volume=0.7 },
        close_sound = { filename = "__base__/sound/car-door-close.ogg", volume = 0.7 },
        inventory_size = 50,
        track_particle_triggers = data.raw.car.tank.track_particle_triggers
    }
    --vehicle.animation = data.raw.car.car.animation
    data:extend{vehicle}