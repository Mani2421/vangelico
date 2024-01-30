--[[
    VANGELICO HEIST SCRIPT
    COFIG FILE
    AUTHOR: MANI
]]

Config = {}

Config.Debug = false -- Additional info for testing and debugging

Config.CooldownTimeInMinutes = 30 -- 30 Minute cooldown after robbery by default, change the value here

Config.IsStoreOnCooldown = true -- Cooldown starts after the whole store has been robbed, we check this with areAllCasesRobbed()

Config.WhitelistedWeapons = { -- Stores weapon hashes whitelisted for robbing case
    [1] = GetHashKey("weapon_carbinerifle"),
    [2] = GetHashKey("weapon_assaultrifle"),
    [3] = GetHashKey("weapon_specialcarbine"),
    [4] = GetHashKey("weapon_bullpuprifle"),
}

Config.Cases = {
    [1] = {
        ['coords'] = vector3(-626.83, -235.35, 38.05),
        ['isRobbed'] = false,
    },
    [2] = {
        ['coords'] = vector3(-625.81, -234.7, 38.05),
        ['isRobbed'] = false,
    },
    [3] = {
        ['coords'] = vector3(-626.95, -233.14, 38.05),
        ['isRobbed'] = false,
    },
    [4] = {
        ['coords'] = vector3(-628.0, -233.86, 38.05),
        ['isRobbed'] = false,
    },
    [5] = {
        ['coords'] = vector3(-625.7, -237.8, 38.05),
        ['isRobbed'] = false,
    },
    [6] = {
        ['coords'] = vector3(-626.7, -238.58, 38.05),
        ['isRobbed'] = false,
    },
    [7] = {
        ['coords'] = vector3(-624.55, -231.06, 38.05),
        ['isRobbed'] = false,
    },
    [8] = {
        ['coords'] = vector3(-623.13, -232.94, 38.05),
        ['isRobbed'] = false,
    },
    [9] = {
        ['coords'] = vector3(-620.29, -234.44, 38.05),
        ['isRobbed'] = false,
    },
    [10] = {
        ['coords'] = vector3(-619.15, -233.66, 38.05),
        ['isRobbed'] = false,
    },
    [11] = {
        ['coords'] = vector3(-620.19, -233.44, 38.05),
        ['isRobbed'] = false,
    },
    [12] = {
        ['coords'] = vector3(-617.63, -230.58, 38.05),
        ['isRobbed'] = false,
    },
    [13] = {
        ['coords'] = vector3(-618.33, -229.55, 38.05),
        ['isRobbed'] = false,
    },
    [14] = {
        ['coords'] = vector3(-619.7, -230.33, 38.05),
        ['isRobbed'] = false,
    },
    [15] = {
        ['coords'] = vector3(-620.95, -228.6, 38.05),
        ['isRobbed'] = false,
    },
    [16] = {
        ['coords'] = vector3(-619.79, -227.6, 38.05),
        ['isRobbed'] = false,
    },
    [17] = {
        ['coords'] = vector3(-620.42, -226.6, 38.05),
        ['isRobbed'] = false,
    },
    [18] = {
        ['coords'] = vector3(-623.94, -227.18, 38.05),
        ['isRobbed'] = false,
    },
    [19] = {
        ['coords'] = vector3(-624.91, -227.87, 38.05),
        ['isRobbed'] = false,
    },
    [20] = {
        ['coords'] = vector3(-623.94, -228.05, 38.05),
        ['isRobbed'] = false,
    }
}
