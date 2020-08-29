require "harvester"
require "migrations"
require "refinery"

--remote.addinterface("harvester", {
--	Error = function()
--		Error()
--	end,
--})

script.on_init(function() On_Load() end)
script.on_load(function() On_Load() end)
script.on_event(defines.events.on_tick, function() On_Tick() end)

script.on_event(defines.events.on_built_entity, function(event) On_Built(event) end)
script.on_event(defines.events.on_robot_built_entity, function(event) On_Built(event) end)

script.on_event(defines.events.on_pre_player_mined_item, function(event) On_Removed(event) end)
script.on_event(defines.events.on_robot_pre_mined, function(event) On_Removed(event) end)
script.on_event(defines.events.on_entity_died, function(event) On_Removed(event) end)

function On_Load()
	if not global.harvesters then
		global.harvesters = {}
	else
		for _, harvester in pairs(global.harvesters) do
			-- Allow it to re-set its metatable.
			Harvester.Onload(harvester)
		end
	end
	
	if not global.refineries then
		global.refineries = {}
	else
		for _, refinery in pairs(global.refineries) do
			-- Allow it to re-set its metatable.
			Refinery.Onload(refinery)
		end
	end
	
	CheckVersion()
end

function On_Tick()
	for _, harvester in pairs(global.harvesters) do
		harvester:Tick()
	end
	for _, refinery in pairs(global.refineries) do
		refinery:Tick()
	end
end

function On_Built(event)
	local ent = event.created_entity or event.entity
	if not ( entity and entity.valid ) then return end
	if ent.name == "harvester" then
	if not ent.name == "harvester" then return end
		table.insert(global.harvesters, Harvester.New(ent))
	end
	if ent.name == "refinery" then
	if not ent.name == "refinery" then return end
		table.insert(global.refineries, Refinery.New(ent))
	end
end

function On_Removed(event)
	local ent = event.entity
	if ent.name == "harvester" then
		for i, harvester in pairs(global.harvesters) do
			if harvester.vehicle == ent then
				harvester:Delete()
				table.remove(global.harvesters, i)
				return
			end
		end
	elseif ent.name == "harvester-anim" then
		for i, harvester in pairs(global.harvesters) do
			if harvester.animEntity == ent then
				harvester:Delete()
				table.remove(global.harvesters, i)
				return
			end
		end
	elseif ent.name == "refinery" then
		for i, refinery in pairs(global.refineries) do
			if refinery.refinery == ent then
				refinery:Delete()
				table.remove(global.refineries, i)
				return
			end
		end
	elseif ent.name == "refinery-chest" then
		for i, refinery in pairs(global.refineries) do
			if  refinery.chest == ent then
				refinery:Delete()
				table.remove(global.refineries, i)
				return
			end
		end
	elseif not ent.name == ("harvester" and "harvester-anim" and "refinery" and "refinery-chest") then return end
end

function CheckVersion()
	if not global.harvesterVersion then
		for _, player in pairs(game.players) do
			player.print("Harvesters: Migrating to version " .. currentVersion)
		end
		migrations["unversioned"]()
	elseif global.harvesterVersion ~= currentVersion then
		if migrations[global.harvesterVersion] then
			for _, player in pairs(game.players) do
				game.player.print("Harvesters: Migrating from version " .. global.harvesterVersion .. " to version " .. currentVersion)
			end
			migrations[global.harvesterVersion]()
		end
	end
	global.harvesterVersion = currentVersion
end