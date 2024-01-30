--[[
    VANGELICO HEIST SCRIPT
    SERVER-SIDE 
    AUTHOR: MANI
]]

---------------------------------------------------------
-----------------------EVENTS----------------------------
---------------------------------------------------------

AddEventHandler("dispatch-police")
RegisterServerEvent("dispatch-police", function()
    local playerPed = PlayerPedId()
    for _, case in pairs(Config.Cases) do
        if case.isRobbed then -- If any of the cases get robbed...
            -- Dispatch police
        end
    end
end)
