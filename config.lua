--[[
    VANGELICO HEIST SCRIPT
    COFIG FILE
    AUTHOR: MANI
]]

Config = {}

Config.Debug = false -- Additional info for testing and debugging
Config.CooldownTimeInMinutes = 30 -- 30 Minute cooldown after robbery by default, change the value here
Config.IsStoreOnCooldown = false -- Cooldown starts after the whole store has been robbed, we check this with areAllCasesRobbed()
Config.WhitelistedWeapons = { -- Stores weapon hashes whitelisted for robbing case,
    GetHashKey("weapon_carbinerifle"),
    GetHashKey("weapon_assaultrifle"),
    GetHashKey("weapon_specialcarbine"),
    GetHashKey("weapon_bullpuprifle"),
}
