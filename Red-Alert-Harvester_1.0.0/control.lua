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

function On_Tick() --tell game we want to do stuff every tick (60 times per second)
	if game.tick % 60 == 0 then -- do this only once per second, you can decrease 60 if needed...but it'd probably be better to increase the amount of ore being removed
		for _,player in pairs(game.connected_players) do
		local vehicle = player.vehicle
		if vehicle and vehicle.name == "harvester" then -- if the player is in a vehicle and it is a harvester
		local ore = vehicle.surface.find_entities_filtered{type = "resource", area=getBoundingBox(vehicle.position, 2)} -- get a table of the ore within a (square) radius of 10 around the harvester, thankfully that was fairly easy, change the '10' to any value you think is appropriate, the 'type = "resource"' might allow it to 'mine' trees as well...if so and you didn't want that you'd need to have multiple tables and instead search using 'name = "name_of_ores"'
		local oreAmount = 2 -- amount of ore to mine from each resource spot
		for _, ore in ipairs(ore) do -- loop through those ores
		  if ore.name ~= "crude-oil" and ore.name:sub(-4) ~= "tree" then
			if vehicle.can_insert{name = ore.name, count = oreAmount} then -- if the harvester is not full
			 if ore.amount > oreAmount then -- if there is more than enough ore
				ore.amount = ore.amount - oreAmount -- decrement the ore by oreAmount
				vehicle.insert{name = ore.name, count = oreAmount} -- and insert it into the harvester
			  elseif ore.amount > 0 and ore.amount <= oreAmount then
				vehicle.insert{name = ore.name, count = ore.amount} -- insert first so that we don't need a local variable to store the amount
				ore.destroy() -- we used all the ore so destroy it
			  elseif ore.amount == 0 then
				ore.destroy() -- I thought the game would destroy it when the amount was set to 0 but maybe not..so do so explicitly
			  else -- the only other else is if the ore has a negative count (which can be used for infinite ore)
				  vehicle.insert{name = ore.name, count = oreAmount} -- just insert oreAmount
			  end
			end
		  end
		end
	end
	  -- find refinery's within a 4x4 square centered around the vehicle
  local refineries = vehicle.surface.find_entities_filtered{name="refinery", area=getBoundingBox(vehicle.position, 4)}
  if #refineries > 0 then -- if the returned table has at least one entry
	 -- I think this is the correct inventory...I might be wrong
	local inventory = vehicle.get_inventory(2)
	local contents = inventory.get_contents()
	local itemstack = {} -- temp var
	for name, count in pairs(contents) do
	  itemstack.name = name
	  itemstack.count = count
	  -- loop through found refineries (err on side of caution, a radius of 5 might find more than one refinery)
	  for _, refinery in pairs(refineries) do 
		if refinery.can_insert(itemstack) then -- if this refinery can hold the items
		  refinery.insert(itemstack)
		  inventory.remove(itemstack) -- remove from inventory (the harvester)
		  break
		  -- do not continue looking at the next refinery...this might be optimized by
		  -- removing the full refinery from the refineries table...
		  -- but it has a few caveats, if the refinery can accept say, 
		  -- copper but not iron, then if you had both in the harvester the refinery 
		  -- might not be filled properly, you'd also need a check for if
		  -- the one you removed was the last possible refinery
		end
	  end
	end
   end
  end
	  --auto coal placement into burner from trunk
	  if vehicle and vehicle.name == "harvester" then
		local burnerCoal = vehicle.getinventory(1)
		local trunkCoal = vehicle.getinventory(2)
		-- notice that I combined these since you won't do anything if only one is true
		if burnerCoal.getitemcount() <= 19 and trunkCoal.getitemcount("coal") > 0  then
		  trunkCoal.remove({name="coal", count="1"})
		  burnerCoal.insert({name="coal", count="1"})
		end
	  end
  
   -- start of refinery code
	  for index, refinery in ipairs(global.refineries) do
		if refinery.valid then
		  if refinery.getitemcount() > 0 then -- if the refinery has items
			-- the inventory number may be wrong... the [1] selects
			-- the first item stack in the inventory
			local item
  
			-- bit of a 'hack' here...
			-- the bug did occur where just selecting the first inventory
			-- would be nil fairly quickly...but the for loop I posted
			-- on the forums didn't work because the slot is 'userdata'
			-- and you can not index userdata...
			-- so I use getcontents() which returns a regular lua table
			-- but it returns it indexed by the item name...and that's
			-- one of the pieces of info that we actually need to get back
			-- soo here's a for loop that simply selects whatever lua gives
			-- back first (since associative arrays have no guarenteed order)
			-- and uses that as the 'first' item
			for name, count in pairs(refinery.getinventory(defines.inventory.chest).getcontents()) do
			  item = {name=name, count=count}
			  break
			end
  
			local itemAmount = 4 --stack size
			-- make item.count reflect the amount we are inserting/removing
			-- only checking for > because we don't want to insert more if
			-- if there are actually less than itemAmount in the refinery
			if item.count > itemAmount then item.count = itemAmount end
  
			-- you'll probably need to play with these number to get it to
			-- place where you want it to...
			-- there is also refinery.direction which tells you whether
			-- the refinery is pointing north, south etc. so if you get
			-- ambitious you can try to make it place the output to the
			-- same relative side rather than always in one direction...
			local storagePos = {x = refinery.position.x + 3.8, y = refinery.position.y + 0 }
			-- get any entities at that storagePosition
			local storageEntities = game.findentities(getBoundingBox(storagePos, 0))
			local storageEntity = false -- temp bool
			for _, entity in ipairs(storageEntities) do
			  if entity.caninsert(item) then
				storageEntity = entity -- save a reference to this entity
				break -- and break out of the loop
			  end
			end
			if storageEntity then -- if an entity that we can place the item into was found
			  storageEntity.insert(item)
			  refinery.getinventory(defines.inventory.chest).remove(item)
			  -- no entities at all (just an else statement would allow dropping them even if there was, say, a wall there
			elseif #storageEntities >= 0 then
			  -- just place the item on the ground
			  game.createentity{name="item-on-ground", position=storagePos, stack=item}
			  refinery.getinventory(defines.inventory.chest).remove(item)
			else --storageEntities is not 0
			  local belt = false
			  for _, entity in pairs(storageEntities) do
				if entity.type == "transport-belt" then
				  belt = true
				  break
				end
			  end
			  if belt then
				game.createentity{name="item-on-ground", position=storagePos, stack=item}
				refinery.getinventory(defines.inventory.chest).remove(item)
			  end
			end
		  end
		else -- not a valid refinery anymore
		  table.remove(glob.refineries, index) -- remove from table
		end
	  end -- end of refinery code
	end -- end of ontick%60
  end -- end anonymous function and onevent/ontick calls
  
  function getBoundingBox(position, radius)
	return {{position.x - radius, position.y - radius}, {position.x + radius, position.y + radius}}
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