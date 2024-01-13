-- Import necessary modules
local Components = require(script.Parent.Parent.components)
local Matter = require(game.ReplicatedStorage.Modules.Matter)

-- Extract required components
local Health = Components.Health
local Healing = Components.Healing 

-- Function to apply healing to entities in the world
local function applyHealing(world)
    -- Query entities with both Health and Healing components
    for id, health, healing in world:query(Health, Healing) do
        -- Check if the healing should be applied based on throttle
        if Matter.useThrottle(healing.throttle) then
            -- Apply healing to health value, ensuring it doesn't exceed the maximum health
            local newHealthValue = math.min(health.max, health.value + healing.value)

            -- Insert updated health component back into the world
            world:insert(id, health:patch({ value = newHealthValue }))
        end

        -- Check if the healing has a duration
        if Matter.useDuration(healing.duration) then
            -- Remove the Healing component once its duration is complete
            world:remove(id, Healing)
        end
    end
end

-- Return the function for external use
return applyHealing
