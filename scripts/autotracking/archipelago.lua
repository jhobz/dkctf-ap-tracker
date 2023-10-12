ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

local currentItemIndex = -1

local function resetLocations()
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format('onClear: clearing location %s', v[1]))
            end

            local location = Tracker:FindObjectForCode(v[1])
            if location then
                if v[1]:sub(1, 1) == '@' then
                    location.AvailableChestCount = location.ChestCount
                else
                    location.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format('onClear: could not find object for code %s', v[1]))
            end
        end
    end
end

local function resetItems()
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format('onClear: clearing item %s', v[1]))
            end

            local item = Tracker:FindObjectForCode(v[1])
            if item then
                if item.Type == 'toggle' then
                    item.Active = false
                elseif item.Type == 'progressive' then
                    item.CurrentStage = 0
                    item.Active = false
                elseif item.Type == 'consumable' then
                    item.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format('onClear: unknown item type %s for code %s', item.Type, v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format('onClear: could not find object for code %s', v[1]))
            end
        end
    end
end


local function onClear(sData)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format('called onClear, slot_data:\n%s', DumpTable(sData)))
    end

    currentItemIndex = -1
    resetLocations()
    resetItems()
end

local function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, currentItemIndex))
    end

    if index <= currentItemIndex then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    currentItemIndex = index

    local item_code = ITEM_MAPPING[item_id]
    if not item_code or not item_code[1] then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end

        return
    end

    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s", item_code[1]))
    end

    local item = Tracker:FindObjectForCode(item_code[1])
    if item then
        if item.Type == "toggle" then
            item.Active = true
        elseif item.Type == "progressive" then
            if item.Active then
                item.CurrentStage = item.CurrentStage + 1
            else
                item.Active = true
            end
        elseif item.Type == "consumable" then
            item.AcquiredCount = item.AcquiredCount + item.Increment
            -- Boss Barrel
            -- if item_code == 15873677077 then
                
            -- end
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", item.Type, item_code[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", item_code[1]))
    end
end

local function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end

    local locationPath = LOCATION_MAPPING[location_id]
    if not locationPath or not locationPath[1] then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onLocation: could not find location mapping for id %s", location_id))
        end

        return
    end

    local location = Tracker:FindObjectForCode(locationPath[1])
    if location then
        if locationPath[1]:sub(1, 1) == '@' then
            location.AvailableChestCount = location.AvailableChestCount - 1
        else
            location.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find object for code %s", locationPath[1]))
    end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
