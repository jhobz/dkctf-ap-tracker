-- Items
Tracker:AddItems("items/items.json")

-- Logic
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Maps
Tracker:AddMaps("maps/maps.json")

-- Locations
Tracker:AddLocations("locations/lostmangroves.json")
Tracker:AddLocations("locations/autumnheights.json")
Tracker:AddLocations("locations/brightsavannah.json")
Tracker:AddLocations("locations/seabreezecove.json")
Tracker:AddLocations("locations/juicyjungle.json")
Tracker:AddLocations("locations/donkeykongisland.json")
Tracker:AddLocations("locations/secretseclusion.json")

-- Layout
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/levels.json")
Tracker:AddLayouts("layouts/tabs.json")
Tracker:AddLayouts("layouts/tracker.json")

-- AutoTracking
if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
end