-- Map special ores, such as silica where the resource is called "silica" and the item is called "raw-silica".
SpecialOres = {
    ["harvester-example-ore"] = function() return "raw-harvester-example-ore" end,
    ["tibGrowthNode"] = function() return "tiberium-ore" end,
    ["tibGrowthNode_infinite"] = function() return "tiberium-ore-blue" end,
}
