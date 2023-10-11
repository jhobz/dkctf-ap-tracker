---Determine if the user has the ability to fight a given boss.
---@param world string
---@return boolean
function CanReachBoss(world)
    local levelReqs = {4, 6, 6, 5, 6, 8}
    return Has(string.format('%s-boss', world)) and LevelCount(tonumber(world)) >= levelReqs[tonumber(world)]
end

---Get the total number of levels acquired. Can optionally filter for a specific world.
---@param world? number
---@return number
function LevelCount(world)
    local levels = {
        Count('1-1') + Count('1-2') + Count('1-3') + Count('1-4') + Count('1-a') + Count('1-b') + Count('1-k'),
        Count('2-1') + Count('2-2') + Count('2-3') + Count('2-4') + Count('2-5') + Count('2-6') + Count('2-a') + Count('2-b') + Count('2-k'),
        Count('3-1') + Count('3-2') + Count('3-3') + Count('3-4') + Count('3-5') + Count('3-6') + Count('3-a') + Count('3-b') + Count('3-k'),
        Count('4-1') + Count('4-2') + Count('4-3') + Count('4-4') + Count('4-5') + Count('4-6') + Count('4-a') + Count('4-b') + Count('4-k'),
        Count('5-1') + Count('5-2') + Count('5-3') + Count('5-4') + Count('5-5') + Count('5-6') + Count('5-a') + Count('5-b') + Count('5-k'),
        Count('6-1') + Count('6-2') + Count('6-3') + Count('6-4') + Count('6-5') + Count('6-6') + Count('6-7') + Count('6-8') + Count('6-a') + Count('6-b') + Count('6-k'),
        Count('7-1') + Count('7-2') + Count('7-3') + Count('7-4') + Count('7-5') + Count('7-6') + Count('7-a') + Count('7-b') + Count('7-k')
    }

    if not world then
        return levels[1] + levels[2] + levels[3] + levels[4] + levels[5] + levels[6] + levels[7]
    end

    return levels[world]
end