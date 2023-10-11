ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

local function onClear(slot_data)
    print('clear')
    print(DumpTable(slot_data))
end

local function onItem(index, item_id, item_name, player_number)
    print('item received')
    print(index,item_id,item_name,player_number)

    local item_code = ITEM_MAPPING[item_id]
    if not item_code or not item_code[1] then
        print(string.format("onItem: could not find item mapping for id %s", item_id))
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
        end
    else
        print(string.format("onItem: could not find object for code %s", item_code[1]))
    end
end

local function onLocation(location_id, location_name)
    print("onLocation: fired")
    local locationPath = LOCATION_MAPPING[location_id]
    if not locationPath or not locationPath[1] then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end

    local location = Tracker:FindObjectForCode(locationPath[1])
    if location then
        location.AvailableChestCount = 0
    else
        print(string.format("onLocation: could not find object for code %s", locationPath[1]))
    end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
