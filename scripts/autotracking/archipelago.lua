ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")

function onClear(slot_data)
    print('clear')
    print(dump_table(slot_data))
end

function onItem(index, item_id, item_name, player_number)
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

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
