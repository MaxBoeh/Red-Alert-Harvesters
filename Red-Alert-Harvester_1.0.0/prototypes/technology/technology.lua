data:extend({
  {
    type = "technology",
    name = "Old-World-Harvesting",
	    prerequisites = {"steel-processing", "engine"},
    icon = "__Red-Alert-Harvester__/graphics/icons/refin_icon.png",
    icon_size = 32,
    effects =
    {
      {
         type = "unlock-recipe",
         recipe = "harvester"
        },
      {
         type = "unlock-recipe",
         recipe = "refinery"
        },
     },
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 2},
        {"logistic-science-pack", 1}
      },
      time = 20
    }
  }
})