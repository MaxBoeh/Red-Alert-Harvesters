require "harvester"

currentVersion = "1.0"

migrations = {
	["unversioned"] = function()
		for _, harv in pairs(global.harvesters) do
			-- Fix movement.
			if harv.filled then
				if harv.targetRefinery and harv.targetRefinery.valid then
					harv.onArrivalCallback = function(self) self.state = States.DroppingOre end
				else
					harv.onArrivalCallback = function(self) self.state = States.FindingRefinery end
				end
			elseif harv.refueling then
				if harv.targetRefinery and harv.targetRefinery.valid then
					harv.onArrivalCallback = function(self) self.state = States.ApproachedForRefuel end
				else
					harv.onArrivalCallback = function(self) self.state = States.FindingRefuelRefinery end
				end
			else
				harv.onArrivalCallback = function(self) self.state = States.FindingOre end
			end
			
		
			-- Stop animations.
			harv.animationState.currentAnimation = Animations.Rotating
			harv.animationState.animationState = AnimationStates.Rotating
			if harv.state == States.Animating then
				if harv.filled then
					harv.State = States.DroppingOre
				else
					harv.state = States.FindingOre
				end
			end
		end
	end,
	["0.0.3"] = function()
		migrations["unversioned"]()
		migrations["0.0.6"]()
	end,
	["0.0.4"] = function()
		migrations["unversioned"]()
		migrations["0.0.6"]()
	end,
	["0.0.6"] = function()
		-- Reset all harvesters to the default FindingOre state.
		for _, harvester in pairs(global.harvesters) do
			harvester.targetRefinery = false
			harvester.onArrivalCallback = function(self) self.state = States.FindingOre end
			harvester.animationState.currentAnimation = Animations.Rotating
			harvester.animationState.animationState = AnimationStates.Rotating
			harvester.state = States.FindingOre
		end
		
		for _, refinery in pairs(global.refineries) do
			refinery.entity = refinery.refinery
			refinery.refinery = nil
			refinery.reserved = false
			
			-- Changed the belt search interval to 4 seconds instead of 3 times per second.
			refinery.tickOffset = math.random(240)
		end
	end,
}