--[[
    VANGELICO HEIST SCRIPT
    CLIENT-SIDE
    AUTHOR: MANI
]]

-- Array holding coords for all cases and the robbed status
local cases = {
    [1] = {x = -626.5326, y = -238.3758,z = 38.05, robbed = false},
	[2] = {x = -625.6032, y = -237.5273, z = 38.05, robbed = false},
	[3] = {x = -626.9178, y = -235.5166, z = 38.05, robbed = false},
	[4] = {x = -625.6701, y = -234.6061, z = 38.05, robbed = false},
	[5] = {x = -626.8935, y = -233.0814, z = 38.05, robbed = false},
	[6] = {x = -627.9514, y = -233.8582, z = 38.05, robbed = false},
	[7] = {x = -624.5250, y = -231.0555, z = 38.05, robbed = false},
	[8] = {x = -623.0003, y = -233.0833, z = 38.05, robbed = false},
	[9] = {x = -620.1098, y = -233.3672, z = 38.05, robbed = false},
	[10] = {x = -620.2979, y = -234.4196, z = 38.05, robbed = false},
	[11] = {x = -619.0646, y = -233.5629, z = 38.05, robbed = false},
	[12] = {x = -617.4846, y = -230.6598, z = 38.05, robbed = false},
	[13] = {x = -618.3619, y = -229.4285, z = 38.05, robbed = false},
	[14] = {x = -619.6064, y = -230.5518, z = 38.05, robbed = false},
	[15] = {x = -620.8951, y = -228.6519, z = 38.05, robbed = false},
	[16] = {x = -619.7905, y = -227.5623, z = 38.05, robbed = false},
	[17] = {x = -620.6110, y = -226.4467, z = 38.05, robbed = false},
	[18] = {x = -623.9951, y = -228.1755, z = 38.05, robbed = false},
	[19] = {x = -624.8832, y = -227.8645, z = 38.05, robbed = false},
	[20] = {x = -623.6746, y = -227.0025, z = 38.05, robbed = false},
}


---------------------------------------------------------
-----------------------FUNCTIONS-------------------------
---------------------------------------------------------

-- Load animation dictionary
local function loadAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

---------------------------------------------------------

-- Find case by looking up its corresponding index in the array
local function findCaseByArrayIndex(index)
    return cases[index]
end

---------------------------------------------------------

-- Function to check if all cases are robbed
local function areAllCasesRobbed()
    for _, case in pairs(cases) do
        if not case.isRobbed then
            return false
        end
    end
    return true
end

---------------------------------------------------------

-- Compare the weapon hash of the current player weapon to whitelisted weapons
local function isWeaponWhitelisted(weaponHash)
    for _, whitelistedWeapon in pairs(Config.WhitelistedWeapons) do
        if weaponHash == whitelistedWeapon then
            return true
        end
    end
    if Config.Debug then
        print("weapon not whitelisted, hud message here")
    end
    return false
end

---------------------------------------------------------

-- Function to find the index of the case the player is facing
function findFacingCaseIndex()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    for index, case in pairs(cases) do
        local caseCoords = vector3(case.x, case.y, case.z)
        local caseHeading = math.deg(math.atan2(caseCoords.y - playerCoords.y, caseCoords.x - playerCoords.x))
        local headingDifference = caseHeading - playerHeading

        if headingDifference < -180.0 then headingDifference = headingDifference + 360.0 end
        if headingDifference > 180.0 then headingDifference = headingDifference - 360.0 end

        if math.abs(headingDifference) < 30.0 then
            -- Player is facing this case within a 30-degree angle
            return index
        end
    end

    if Config.Debug then
        print("can't find case")
    end
    return nil -- Return nil if no case is found in the player's facing direction
end


---------------------------------------------------------

-- Function to make the player walk to the case and perform smash n grab animation
local function robCase(caseIndex)
    local playerPed = PlayerPedId()
    local caseCoords = vector3(cases[caseIndex].x, cases[caseIndex].y, cases[caseIndex].z)
    
    -- Check if player is too far from the case
    local distance = #(GetEntityCoords(playerPed) - caseCoords)
    if distance > 5.0 then
        TaskGoStraightToCoord(playerPed, caseCoords.x, caseCoords.y, caseCoords.z, 1.0, -1, 0.0, 0.0)
        while distance > 1.5 do
            Citizen.Wait(0)
            distance = #(GetEntityCoords(playerPed) - caseCoords)
        end
        ClearPedTasks(playerPed)
    end

    -- Face the case
    local playerHeading = GetEntityHeading(playerPed)
    local caseHeading = math.deg(math.atan2(caseCoords.y - GetEntityCoords(playerPed).y, caseCoords.x - GetEntityCoords(playerPed).x))
    local headingDifference = caseHeading - playerHeading
    if headingDifference < -180.0 then headingDifference = headingDifference + 360.0 end
    if headingDifference > 180.0 then headingDifference = headingDifference - 360.0 end
    TaskTurnPedToFaceCoord(playerPed, caseCoords.x, caseCoords.y, caseCoords.z, -1)

    -- Wait for the ped to face the case
    while headingDifference > 5.0 or headingDifference < -5.0 do
        Citizen.Wait(0)
        headingDifference = caseHeading - playerHeading
        if headingDifference < -180.0 then headingDifference = headingDifference + 360.0 end
        if headingDifference > 180.0 then headingDifference = headingDifference - 360.0 end
    end

    -- Play the smash n grab animation
    loadAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
    TaskPlayAnim(playerPed, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 0, 0, false, false, false)
    Citizen.Wait(5000) -- Adjust the wait time based on the duration of your animation

    -- Clear tasks and perform additional logic for robbing the case
    ClearPedTasks(playerPed)
    cases[caseIndex].isRobbed = true
end

---------------------------------------------------------
-----------------------THREADS---------------------------
---------------------------------------------------------

CreateThread(function()
    local playerPed = PlayerPedID()
    local caseIndex = findFacingCaseIndex()
    
    if not areAllCasesRobbed() then
        robCase(caseIndex)
    end
    Config.IsStoreOnCooldown = true
end)