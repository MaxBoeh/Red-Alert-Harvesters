Stats = {
	RotationSpeed = 0.01, -- Per tick, 1.0 is a complete loop.
	MovementSpeed = 0.085, -- Tiles to move per tick.
	OreMinedPerScoop = 9, -- At least N, at most N+8 due to underlying mechanics. (The 8 is dependent on the MiningRadius)
	ScoopsPerLocation = 3, -- Amount of scoops to take in a single location.
	MiningRadius = 1.1, -- Radius in which to search for ores when currently scooping.
	-- Radii automatically increase if no ore is found.
	DefaultSearchRadius = 15, -- Starting radius to search for a random ore when at a refinery.
	CloseMineSearchRadius = 7, -- Starting radius to search for a random ore when it's just finished scooping a location. Lower will result in less driving between scoops.
	MiningRadius = 1.1, -- Radius in which to search for ores when currently scooping.
	
	EnergyUsedPerTick = 1200000 / 60, -- 1200kW. Energy is only consumed when animating or driving.
	
	TicksPerAnimationFrame = 4, -- Less means faster animations.
	TotalAnimationFrames = 117, -- Technical, can not adjust.
	
	RefineryApproachOffset = {5, 2}, -- Location to drive to before approaching a refinery.
	RefineryDumpOffset = {1, 2.5}, -- Location to dump the ores.
	
	-- Adjust this in the prototype definition as well! (prototypes/entities/harv_entity.lua, line 8) Mismatch will result in issues.
	HarvesterCargoSlots = 20,
}