-- remote.addinterface("cncharvester", {
--	Error = function()
--		Error()
--	end,
-- })
require "utilities"
require "chuncksearcher"
local autocncharvestertesting = settings.startup["Auto-cncharvester-testing"].value

function on_init()
    global.tibchunk = {}
    global.orechunk = {}
    global.cncharvesters = {}
    global.refineries = {}
end




--script.on_load(function() On_Load() end)
script.on_event(defines.events.on_tick, function() On_Tick() end)


--[[ function Consume_fuel_or_battery(cncharvesters)
    local vehicle = player.vehicle
    if vehicle.grid and vehicle.grid.available_in_batteries > 10000 and vehicle.grid.available_in_batteries > vehicle.grid.battery_capacity * 0.5 then
        if fuel_items <1 then

        end
    end
end ]]

--[[function On_Load()
     for _, cncharvester in pairs(global.cncharvesters) do
        -- Allow it to re-set its metatable.
           cncharvester.Onload(cncharvester)
       end
       for _, refinery in pairs(global.refineries) do
           -- Allow it to re-set its metatable.
           Refinery.Onload(refinery)
       end
end]]

--[[function On_Built(event)
    local ent = event.created_entity or event.entity
    if not (entity and entity.valid) then return end
        if ent.name == "cncharvester" then
        table.insert(global.cncharvesters, cncharvester.New(ent))
    end
    elseif ent.name == "refinery" then
        table.insert(global.refineries, Refinery.New(ent))
    end
--end]]

--[[function On_Removed(event)
    local ent = event.entity
    if ent.name == "cncharvester" then
        for i, cncharvester in pairs(global.cncharvesters) do
            if cncharvester.vehicle == ent then
                cncharvester:Delete()
                table.remove(global.cncharvesters, i)
                return
            end
        end
    elseif ent.name == "refinery" then
        for i, refinery in pairs(global.refineries) do
            if refinery.refinery == ent then
                refinery:Delete()
                table.remove(global.refineries, i)
                return
            end
        end
    elseif not ent.name == ("cncharvester" and "refinery") then
        return
    end
end]]

script.on_event(defines.events.on_player_driving_changed_state, on_player_driving_changed_state)
function on_player_driving_changed_state(event)
    local ent = event.entity
    local iscncharvester = (ent and ent.valid and ent.name =="cncharvester") and true or false
    if iscncharvester then
        local vehgrid = ent.grid
        if not vehgrid.get_contents()["Hybrid-drive"] then
            vehgrid.put{name="Hybrid-drive"}
            vehgrid.put{name="Hybrid-drive-battery"}
        end
    end
end

function On_Tick()
    if game.tick % 60 == 0 then
        for _, player in pairs(game.connected_players) do
            local vehicle = player.vehicle
            if vehicle and (vehicle.name == 'cncharvester' or vehicle.name == 'cncharvester-ai' or vehicle.name == 'cncharvester-type2' or vehicle.name == 'cncharvester-type2-ai') then
                local ore = vehicle.surface.find_entities_filtered {
                    type = "resource",
                    area = getBoundingBox(vehicle.position, 2)
                }
                for _, entity in pairs(ore) do
                    if (entity.prototype.resource_category == "basic-solid") or
                        (entity.prototype.resource_category == "basic-solid-tiberium") then
                         for i = 1, 2 do
                            if entity.valid and vehicle.can_insert{name=entity.prototype.name} then
                                entity.mine({inventory = vehicle.get_inventory(defines.inventory.car_trunk)})
                               else
                                rendering.draw_text{text="Inventory full", target=player.vehicle, surface=vehicle.surface.name, scale=1.4, scale_with_zoom=true, color={r = 1, g = 1, b = 1, a = 1}, time_to_live=20}
                            end
                        end
                    end
                end
            --end
            -- find refinery's within a 4x4 square centered around the vehicle
            local refineries = vehicle.surface.find_entities_filtered {
                name = "refinery",
                area = getBoundingBox(vehicle.position, 5)
            }
            if #refineries > 0 then -- if the returned table has at least one entry
                -- I think this is the correct inventory...I might be wrong
                local inventory = vehicle.get_inventory(2)
                local contents = inventory.get_contents()
                local itemstack = {} -- temp var
                for name, count in pairs(contents) do
                    itemstack.name = name
                    itemstack.count = count
                    -- loop through found refineries (err on side of caution, a radius of 5 might find more than one refinery)
                    for _, refinery in pairs(refineries) do
                        if refinery.can_insert(itemstack) then -- if this refinery can hold the items
                            refinery.insert(itemstack)
                            inventory.remove(itemstack) -- remove from inventory (the cncharvester)
                            break
                        end
                    end
                end
                --[[while get_fuel_inventory(vehicle) find_empty_stack == true then
                    local fuel = fuel_items]]


            end
        end
    end
end -- end of ontick%60
end -- end anonymous function and onevent/ontick calls

function getBoundingBox(position, radius)
    return {
        {position.x - radius, position.y - radius},
        {position.x + radius, position.y + radius}
    }
end