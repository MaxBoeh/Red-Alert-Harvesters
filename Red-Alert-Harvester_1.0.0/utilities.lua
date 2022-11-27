function Error(text)
	for _, harvester in pairs(global.harvesters) do
		harvester:ErrorDump()
	end
	for _, refinery in pairs(global.refineries) do
		refinery:ErrorDump()
	end
	for _, player in pairs(game.players) do
		if text then
			player.print(text)
		end
		player.print("Active harvesters/refineries: " .. #global.harvesters .. "/" .. #global.refineries)
	end
	game.speed = 0
end
		

function DeltaposToOrientation(dPos)
	if dPos.x == 0 then
		if dPos.y > 0 then
			return 0.5
		else
			return 0
		end
	elseif dPos.x > 0 then
		return (math.atan(dPos.y / dPos.x) / (2 * math.pi) + 0.25)
	else
		return (math.atan(dPos.y / dPos.x) / (2 * math.pi) + 0.75)
	end
end

function GetBoundingBox(position, radius)
	return {{position.x - radius, position.y - radius}, {position.x + radius, position.y + radius}}
end

function FindNearestEntity(baseEntity, entList)
	local closestEntity = false
	local minDist = math.huge
	for _, entity in pairs(entList) do
		local dPos = vector.subtract(baseEntity.position, entity.position)
		local dist = vector.length(dPos)
		
		if dist < minDist then
			closestEntity = entity
			minDist = dist
		end
	end
	return closestEntity
end

function GetOccupiedSlots(inventory)
	local slotsOccupied = 0	
	for itemName, count in pairs(inventory.get_contents()) do
		slotsOccupied = slotsOccupied + math.ceil(count / game.item_prototypes[itemName].stack_size)
	end
	return slotsOccupied
end

vector = {
	add = function(p1, p2)
		if not p2.x then
			return {x = p1.x + p2[1], y = p1.y + p2[2]}
		end
		return {x = p1.x + p2.x, y = p1.y + p2.y}
	end,

	subtract = function(p1, p2)
		if not p2.x then
			return {x = p1.x - p2[1], y = p1.y - p2[2]}
		end
		return {x = p1.x - p2.x, y = p1.y - p2.y}
	end,
	
	mul = function(p1, c)
		return {x = p1.x * c, y = p1.y * c}
	end,
	
	div = function(p1, c)
		return {x = p1.x / c, y = p1.y / c}
	end,
	
	dist = function(p1, p2)
		return vector.length(vector.subtract(p1, p2))
	end,
	
	distsq = function(p1, p2)
		return vector.lengthsq(vector.subtract(p1, p2))
	end,
	
	length = function(vector)
		return math.sqrt((vector.x * vector.x) + (vector.y * vector.y))
	end,
	
	lengthsq = function(vector)
		return (vector.x * vector.x) + (vector.y * vector.y)
	end,
	
	normalized = function(vector)
		local length = vector.length(vector)
		return {x = vector.x / length, y = vector.y / length}
	end,
}