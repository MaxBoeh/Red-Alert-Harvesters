require "utilities"
require "harvesterstats"

Animations = {
	Rotating = 1,
	ScoopOre = 2,
	DumpOre = 3
}

AnimationStates = {
	Rotating = 1,
	ScoopOre = {
		Rotating = 11,
		Mining = 12,
	},
	DumpOre = {
		Rotating = 21,
		Dumping = 22,
	},
}

StartAnimationStates = {
	[Animations.Rotating] = AnimationStates.Rotating,
	[Animations.ScoopOre] = AnimationStates.ScoopOre.Rotating,
	[Animations.DumpOre] = AnimationStates.DumpOre.Rotating,
}

HarvesterAnimator = {
	New = function(parent)
		local self = {
			vehicle = parent.vehicle,
			animEntity = parent.animEntity,
		
			currentAnimation = Animations.Rotating,
			animationState = AnimationStates.Rotating,
			visibleOrientation = 0,
			
			animationCompleteCallback = false,
			
			animationFrame = 0,
			animationTick = 0,
		}
		setmetatable(self, {__index=HarvesterAnimator})
		
		return self
	end,
  
	Delete = function(self)
	
	end,
	
	Onload = function(self)
		setmetatable(self, {__index=HarvesterAnimator})
	end,
	
	Tick = function(self)
		HarvesterAnimator.AnimationStateFunctions[self.animationState](self)
	end,
	
	ErrorDump = function(self)
		--game.player.print("self.currentAnimation = " .. self.currentAnimation)
		--game.player.print("self.animationState = " .. self.animationState)
		--game.player.print("self.vehicle.orientation = " .. self.vehicle.orientation)
	end,
	
	GetParent = function(self)
		for _, harv in pairs(global.harvesters) do
			if harv.animationState == self then
				return harv
			end
		end
		game.speed = 0
		return false
	end,
	
	PlayAnimation = function(self, animation, onCompleteCallback)
		if self.animationState ~= Animations.Rotating then
			--game.player.print("ERROR: Tried to start animation before completing old animation. (" .. self.currentAnimation .. ", " .. self.animationState .. ")")
			Error()
			return
		end
		self.currentAnimation = animation
		self.animationCompleteCallback = onCompleteCallback
		self.animationState = StartAnimationStates[animation]
		--game.player.print("Starting animation (" .. self.currentAnimation .. "), state = " .. self.animationState)
		self.animationFrame = 0
		self.animationTick = 0
	end,
	
	SetOrientation = function(self, orientation)
		if 	self.animationState ~= AnimationStates.Rotating 
		and self.animationState ~= AnimationStates.ScoopOre.Rotating 
		and self.animationState ~= AnimationStates.DumpOre.Rotating then
			--game.player.print("ERROR: Tried to set orientation during animation. (" .. self.currentAnimation .. ", " .. self.animationState .. ")")
			return
		end
		self.animEntity.orientation = self.vehicle.orientation * (32 / Stats.TotalAnimationFrames)
		self.vehicle.orientation = orientation
		
	end,
	
	RotateTowardsOrientation = function(self, orientation)
		-- First rotate to face the target.
		if math.abs(self.vehicle.orientation - orientation) > 0.01 then
			-- Check if it's faster to rotate the other way.
			if orientation - self.vehicle.orientation > 0.5 then
				orientation = orientation - 1
			elseif orientation - self.vehicle.orientation < -0.5 then
				orientation = orientation + 1
			end
			-- Rotate up to RotationSpeed.
			self:SetOrientation(self.vehicle.orientation + math.max(math.min((orientation - self.vehicle.orientation), Stats.RotationSpeed), -Stats.RotationSpeed))
			return false
		end
		return true
	end,
	
	SetAnimationFrame = function(self, frame)
		--game.player.print("frame = " .. frame)
		self.animEntity.orientation = frame / Stats.TotalAnimationFrames
	end,
	
	AnimationCompleted = function(self)
		if self.animationCompleteCallback then
			self.animationCompleteCallback(self:GetParent())
		end
		self.currentAnimation = Animations.Rotating
		self.animationState = AnimationStates.Rotating
		--game.player.print("Animation completed.")
	end,
	
	AnimationStateFunctions = {
		[AnimationStates.Rotating] = function(self)
		end,
		[AnimationStates.ScoopOre.Rotating] = function(self)
			nearestOrientation = math.floor(self.vehicle.orientation * 8 + 0.5) / 8
			
			if self:RotateTowardsOrientation(nearestOrientation) then
				self.animationState = AnimationStates.ScoopOre.Mining
				self.animationFrame = 0
			end
		end,
		[AnimationStates.ScoopOre.Mining] = function(self)
		
			--game.player.print("self.vehicle.orientation = " .. self.vehicle.orientation)
			orientation = math.floor(self.vehicle.orientation * 8 + 0.5) % 8
			
			--game.player.print("frame = 32 + 8 * " .. orientation .. " + " .. self.animationFrame .. " = " .. 32 + 8 * orientation + self.animationFrame)
			desiredFrame = 32 + 8 * orientation + self.animationFrame
			self:SetAnimationFrame(desiredFrame)
			
			self.animationTick = self.animationTick + 1
			if self.animationTick == Stats.TicksPerAnimationFrame then
				self.animationTick = 0
				self.animationFrame = self.animationFrame + 1
			end
			
			if self.animationFrame == 8 then
				self:AnimationCompleted()
			end
		end,
		[AnimationStates.DumpOre.Rotating] = function(self)
			if self:RotateTowardsOrientation(0.75) then
				self.animationState = AnimationStates.DumpOre.Dumping
				self.animationFrame = 0
			end
		end,
		[AnimationStates.DumpOre.Dumping] = function(self)
			desiredFrame = 96 + self.animationFrame
			self:SetAnimationFrame(desiredFrame)
			
			self.animationTick = self.animationTick + 1
			if self.animationTick == Stats.TicksPerAnimationFrame then
				self.animationTick = 0
				self.animationFrame = self.animationFrame + 1
			end
			
			if self.animationFrame == 21 then
				self:AnimationCompleted()
			end
		end,
	},
}
