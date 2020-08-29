SpecialOres = {	silica = function() return "raw-silica" end,
				gems = function()
					local num = math.random(235333) / 100000
					if num < 0.2 then return "ruby-ore"
					elseif num < 0.6 then return "ruby-orex"
					elseif num < 0.8 then return "sapphire-ore"
					elseif num < 1.2 then return "sapphire-orex"
					elseif num < 1.35 then return "emerald-ore"
					elseif num < 1.65 then return "emerald-orex"
					elseif num < 1.75 then return "diamond-ore"
					elseif num < 1.95 then return "diamond-orex"
					elseif num < 2.22 then return "topaz-orex"
					else return "topaz-ore"
					end
				end,
}