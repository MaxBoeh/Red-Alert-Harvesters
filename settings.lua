data:extend(
	{
		{
			type = "bool-setting",
			name = "Auto-cncharvester-testing",
			setting_type = "startup",
			default_value = false,
			per_user = false,
		},
		{
			type = "bool-setting",
			name = "harvester-auto-by-default",
			setting_type = "startup",
			default_value = false,
			per_user = false,
		}
		--[[ ,
		{
			type = "int-setting",
			name = "Auto-cncharvester-Ragne",
			Setting_type = "startup"
			default_value = 200,
			maximum_value = 1000,
			minimum_value = 50,
			per_user = false,
		} ]]
	}
)