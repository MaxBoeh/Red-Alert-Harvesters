data:extend(
 {
  {
    type = "recipe",
    name = "cncharvester",
    enabled = "false",
    ingredients =
    {
      {"engine-unit", 8},
      {"iron-plate", 20},
      {"steel-plate", 5},
	    {"iron-chest",  1},
	    {"steel-chest", 1}
    },
    result = "cncharvester",
	result_count = 1
  },
  {
    type = "recipe",
    name = "cncharvester-type2",
    enabled = "false",
    ingredients =
    {
      {"cncharvester", 1},
      {"engine-unit", 10},
      {"iron-plate", 100},
      {"steel-plate", 25},
	    {"steel-chest", 2}
    },
    result = "cncharvester-type2",
	result_count = 1
  }
  --[[{
    type = "recipe",
    name = "cncharvester-remote",
    enabled = false,
    ingredients =
    {
      {"engine-unit", 1},
      {"radar", 1}
    },
    result = "spidertron-remote"
  },]]
    --[[{
    type = "recipe",
    name = "Hybrid-drive",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {"solar-panel", 1},
      {"advanced-circuit", 2},
      {"steel-plate", 5}
    },
    result = "Hybrid-drive"
  }]]
 }
)
