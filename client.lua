-- FILEPATH: /Mani2421/vangelico/client.lua
--[[                        
    VANGELICO HEIST SCRIPT
    CLIENT-SIDE
    AUTHOR: MANI
]]

---------------------------------------------------------
-----------------------FUNCTIONS-------------------------
---------------------------------------------------------


-- Handle loading visuals of smashing case
local function LoadVisuals(dict, ptfxAsset)
    -- Anim
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    -- Ptfx
	if not HasNamedPtfxAssetLoaded(ptfxAsset) then
    RequestNamedPtfxAsset(ptfxAsset)
    end
    while not HasNamedPtfxAssetLoaded(ptfxAsset) do
    Citizen.Wait(0)
    end
    SetPtfxAssetNextCall(ptfxAsset)
end

-- Draw 3D text at coords
local function Draw3DText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Function to find the case index that the player is facing
local function FindFacingCaseIndex()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local directionVector = GetEntityForwardVector(playerPed)

    local hit, hitCoords, hitNormal, hitMaterial, hitEntity = 
        StartShapeTestRay(playerCoords, playerCoords + (directionVector * 10), -1, playerPed, 7)

    if hit and hitEntity and GetEntityType(hitEntity) == 1 then
        for index, case in pairs(Config.Cases) do
            if case.coords == hitCoords then
                return index -- Return the index of the case hit by the raycast
            end
        end
    end

    DebugPrint("Can't find case index")
    
    return nil -- Return nil if no case is found in front of the player
end

-- Find case coords by index
local function GetCaseCoords(caseIndex)
    local x,y,z = table.unpack(Config.Cases[caseIndex].coords)
    return x,y,z
end


-- Function to check if all cases are robbed
local function HandleCooldown()
    for _, case in pairs(Config.Cases) do
        if not case.isRobbed then
            Config.IsStoreOnCooldown = false
        end
    end
    Config.IsStoreOnCooldown = true

    if Config.IsStoreOnCooldown == false then
        Wait(Config.CooldownTimeInMinutes * 60000)
    end
    
    DebugPrint("Store is already on cooldown")
    
    return nil
end


-- Compare the weapon hash of the current player weapon to whitelisted weapons
local function IsWeaponWhitelisted(weaponHash)
    for _, whitelistedWeapon in pairs(Config.WhitelistedWeapons) do
        if weaponHash == whitelistedWeapon then
            return true
        end
    end

    DebugPrint("weapon not whitelisted, hud message here")

    return false
end


-- handle animation and loot logic
local function RobCase(caseIndex)
    local playerPed = PlayerPedId()
    local caseIndex = FindCaseByArrayIndex(FindFacingCaseIndex())
    local caseCoords = GetCaseCoords(caseIndex)
    local playerHeading = GetEntityHeading(playerPed)
    local caseHeading = math.deg(math.atan2(caseCoords.y - GetEntityCoords(playerPed).y, caseCoords.x - GetEntityCoords(playerPed).x))
    local headingDifference = caseHeading - playerHeading
    
    -- Check how far the ped is from the case and give the task to walk to the case before playing anim
    local distance = #(GetEntityCoords(playerPed) - caseCoords)
    if distance > 5.0 then
        TaskGoStraightToCoord(playerPed, caseCoords.x, caseCoords.y, caseCoords.z, 1.0, -1, 0.0, 0.0)
        Wait(1500)
        -- If the player doesn't reach the coords after wait time, they are stuck so we teleport them.
        if GetEntityCoords(PlayerPedId()) ~= caseCoords then
            SetEntityCoords(playerPed, caseCoords.x, caseCoords.y, caseCoords.z)
            DebugPrint("Player was teleported because they could not reach coords. playerCoords:  " .. playerCoords .. " caseCoords:  " .. caseCoords .. " distance:  " .. distance) -- DEBUG
        end
        ClearPedTasksImmediately(playerPed)
    end

    -- If the player isn't facing the case, turn player to face the case before playing anim
    while headingDifference > 5.0 or headingDifference < -5.0 do
        Citizen.Wait(0)
        if headingDifference < -180.0 then headingDifference = headingDifference + 360.0 end
        if headingDifference > 180.0 then headingDifference = headingDifference - 360.0 end
    end
    TaskTurnPedToFaceCoord(playerPed, caseCoords.x, caseCoords.y, caseCoords.z, -1)
    -- If the player isn't facing the case after turning to face it, clear the task so they don't get stuck
    Wait(3000)
    if headingDifference ~= 0.0 then
        ClearPedTasksImmediately(playerPed)
        DebugPrint("Player could not face case. heading difference:  " .. headingDifference) -- DEBUG
    end

    -- Play the smash n grab animation
    LoadVisuals("missheist_jewel", "scr_jewelheist")
    TaskPlayAnim(PlayerPedId(), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
    StartParticleFxLoopedAtCoord("scr_jewel_cab_smash",caseCoords.x, caseCoords.y, caseCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(5000)

    -- Clear tasks and perform additional logic for robbing the case
    ClearPedTasksImmediately(playerPed)
    Config.Cases[caseIndex].isRobbed = true
end


---------------------------------------------------------
-----------------------MAIN THREAD-----------------------
---------------------------------------------------------
Citizen.CreateThread(function()
    HandleCooldown() -- Call this at the beginning of the thread to check/update the state of Config.IsStoreOnCooldown.
    local caseIndex = FindCaseByArrayIndex(FindFacingCaseIndex())
    local caseCoords = FindCaseCoords(caseIndex)
    local playerDistanceToCase = #(GetEntityCoords(PlayerPedId()) - caseCoords)
    while playerDistanceToCase > 5.0 and not Config.Cases.isRobbed do 
        Wait(1)
        Draw3DText(caseCoords, "Press [E] to smash case!")
    end
    if IsControlJustPressed(0, 38) then
        if Config.IsStoreOnCooldown and IsWeaponWhitelisted(GetSelectedPedWeapon(PlayerPedId())) then
            RobCase(caseIndex)
        end
    end
end)

---------------------------------------------------------
---------------------------DEBUG-------------------------
---------------------------------------------------------
function DebugPrint(msg)
    if Config.Debug then
        print(msg)
    end
end

RegisterCommand("dbg_testVangelicoScenario", function(source, args, rawCommand)
    local caseIndex = args[1]

    if IsControlJustPressed(0, 38) then
        if Config.IsStoreOnCooldown and IsWeaponWhitelisted(GetSelectedPedWeapon(PlayerPedId())) then
            RobCase(caseIndex)
        end
    end
end)