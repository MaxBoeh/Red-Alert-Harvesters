require "utilities"

local beltAreas = {
	N = { -- North.
		{-1, -4}, {2, -3}
	},
	--E = { -- East.
	--	{3, -3}, {4, 3}
	--},
	--S = { -- South.
	--	--{-3, 3}, {3, 4}
	--},
	--W = { -- West.
	--	{-3, -3}, {-4, 3}
	--},
}

local beltDirections = {
	N = 0,
	E = 2,
	S = 4,
	W = 8,
}

local laneOff = 0.25
local dropOff = 0.35
local dropOffsets = {
	N = {{-laneOff,  dropOff}, { laneOff,  dropOff}},
	E = {{-dropOff, -laneOff}, {-dropOff,  laneOff}},
	S = {{ laneOff, -dropOff}, {-laneOff, -dropOff}},
	W = {{ dropOff,  laneOff}, { dropOff, -laneOff}},
}

Refinery = {
	--------------------------------------------------++--------------------------------------------------
	--										   Static functions											--
	--------------------------------------------------++--------------------------------------------------
	-- Static functions.
	NearestUnoccupied = function(position)
		return Refinery.NearestWithCondition(position, function(refinery) return not refinery:IsOccupied() and not refinery:IsFull() end)
	end,
	
	NearestWithFuel = function(position)
		local refinery = Refinery.NearestWithCondition(position, function(refinery) return not refinery:IsOccupied() and refinery:HasFuel() end)
		-- If we cannot find an unoccupied refinery, simply head for the nearest with fuel.
		if not refinery then
			refinery = Refinery.NearestWithCondition(position, function(refinery) return refinery:HasFuel() end)
		end
		return refinery
	end,
	
	Nearest = function(position)
		return Refinery.NearestWithCondition(position, function(refinery) return true end)
	end,
	
	NearestWithCondition = function(position, conditionFunc)
		if #global.refineries < 1 then
			return false
		end
		local closestRefinery = false
		local minDistSq = math.huge
		for _, refinery in pairs(global.refineries) do
			if conditionFunc(refinery) then
				local dPos = vector.subtract(position, refinery.entity.position)
				local distSq = vector.lengthsq(dPos)
				
				if distSq < minDistSq then
					closestRefinery = refinery
					minDistSq = distSq
				end
			end
		end
		
		return closestRefinery
	end,
	


	--------------------------------------------------++--------------------------------------------------
	--										   Class functions											--
	--------------------------------------------------++--------------------------------------------------
	New = function(entity)
		local self = {
			entity = entity,
			chest = false,
			inventory = false,

			-- Make sure not all refineries check for belts in the same tick.
			tickOffset = game.tick % 240,

			hasBelts = false,
			belts = {N = {}, E = {}, S = {}, W = {}},
			reserved = false,
		}
		setmetatable(self, {__index=Refinery})
		
		-- It's placed by placing "refinery", so place the "refinery-chest".
		self.chest = game.surfaces.nauvis.create_entity({name="refinery-chest", force=self.entity.force, position=self.entity.position})
		self.inventory = self.chest.get_inventory(defines.inventory.chest)

		return self
	end,

	Delete = function(self)
		if self.entity and self.entity.valid then
			self.entity.destroy()
		end
		if self.chest and self.chest.valid then
			self.chest.destroy()
		end
	end,
	
	Onload = function(self)
		setmetatable(self, {__index=Refinery})
	end,

	Tick = function(self)
		if ((game.tick + self.tickOffset) % 240) == 0 then
			self:CheckForBelts()
		end

		if self.hasBelts and self.inventory.get_item_count() > 0 then
			self:DropOnBelts()
		end
	end,
	
	ErrorDump = function(self)
		-- Nothing.
	end,
	
	FloatingText = function(self, text, color)
		local color = color or {r = 1, g = 1, b = 1}
		game.surfaces.nauvis.create_entity({name="flying-text", position=self.entity.position, text=text, color=color})
	end,
	
	Reserve = function(self)
		if self.reserved then
			Error("Reserved an already reserved refinery.")
		end
		self.reserved = true
	end,
	
	UnReserve = function(self)
		if not self.reserved then
			Error("Unreserved a non-reserved refinery.")
		end
		self.reserved = false
	end,
	
	IsOccupied = function(self)
		return self.reserved
-- 		local results = game.findentitiesfiltered{name = "harvester", area = GetBoundingBox(vector.add(self.entity.position, Stats.RefineryDumpOffset), 1)}
-- 		return #results > 0
	end,

	GetAvailableSlots = function(self)
		if self:IsFull() then return 0 end
		local inv = self.chest.get_inventory(defines.inventory.chest)

		local totalSlots = inv.getbar()
		local slotsTaken = GetOccupiedSlots(inv)
		return math.max(0, totalSlots - slotsTaken)
	end,

	HasFuel = function(self)
		for itemName, count in pairs(self.chest.get_inventory(defines.inventory.chest).get_contents()) do
			-- Is this item a fuel?
			if game.item_prototypes[itemName].fuel_value > 0 then
				self:FloatingText("Fuel -----")
				return true
			end
		end
		self:FloatingText("No fuel.")
		return false
	end,
	
	-- Returns whether or not there is a free slot in the refinery.
	IsFull = function(self)
		return not self.chest.get_inventory(defines.inventory.chest).can_insert({name = "refinery", count = 1})
	end,

	CheckForBelts = function(self)
		self.hasBelts = false
		self.belts = {N = {}, E = {}, S = {}, W = {}}
		for dir, area in pairs(beltAreas) do
			local results = game.player.surface.find_entities_filtered{type = "transport-belt", area = {vector.add(self.entity.position, area[1]), vector.add(self.entity.position, area[2])}}
			for _, belt in pairs(results) do
				if belt.direction == beltDirections[dir] then
					table.insert(self.belts[dir], belt)
					self.hasBelts = true
				end
			end
		end
	end,

	DropOnBelts = function(self)
		for dir, belts in pairs(self.belts) do
			for _, belt in pairs(belts) do
				if not belt.valid then
					self:CheckForBelts()
					return
				end
				self:DropOnBelt(belt, dir)
			end
		end
	end,

	DropOnBelt = function(self, belt, dir)
		local dropped = 0
		for itemName, itemCount in pairs(self.inventory.get_contents()) do
			-- If it contains fuel.
			local count = itemCount
			if game.item_prototypes[itemName].fuel_value > 0 then
				-- Keep at least a stack.
				count = count - game.item_prototypes[itemName].stacksize
			end
			local stack = {name = itemName, count = 1}

			-- If there's two of the current item, drop it on both lanes if possible.
			if count > 1 then
				dropped = 2
				for _, offset in pairs(dropOffsets[dir]) do
					local possiblePos = game.get_surface(1).find_non_colliding_position("item-on-ground", vector.add(belt.position, offset), 0.01, 0.01)
					if possiblePos then
						game.surfaces.nauvis.create_entity{position = possiblePos, name = "item-on-ground", stack=stack}
						self.inventory.remove(stack)
					end
				end
			-- Otherwise drop one. The next item loop will drop on the other side.
			elseif count == 1 then
				dropped = dropped + 1
				local offset = dropOffsets[dir][dropped]
				local possiblePos = game.get_surface(1).find_non_colliding_position("item-on-ground", vector.add(belt.position, offset), 0.01, 0.01)
				if possiblePos then
					game.surfaces.nauvis.create_entity{position = possiblePos, name = "item-on-ground", stack=stack}
					self.inventory.remove(stack)
				end
			end

			if dropped == 2 then
				break
			end
		end
	end,
}
