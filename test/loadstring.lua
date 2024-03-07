if game.PlaceId ~= 9431156611 or getgenv().SRCheatConfigured then return end
-- CONFIGURATION
getgenv().disableBarriers = true
getgenv().hazardCollision = true -- Whether the hazard should be solid

getgenv().hideCharacterInLobby = true -- Useful for evading noobs yelling at you

getgenv().itemVacEnabled = true

getgenv().bombBus = true
getgenv().permaTruePower = true -- Activates when you have 2 or more True Powers
getgenv().usePermaItems = true -- Automatically use permanent items
getgenv().useIceCubes = true -- Automatically use ice cubes to allow killAll/kill aura oneshots for a few hits

getgenv().instantBusJump = true
getgenv().busJumpLegitMode = false -- Waits for the jump prompt to appear
getgenv().instantLand = true -- Teleports you to the ground instantly

getgenv().safetyHeal = true
getgenv().healthLow = 30 -- When to trigger auto-heal
getgenv().healthOk = 80 -- How much to heal until

getgenv().killAll = true
getgenv().killAllInitDelay = 1 -- How long to wait before starting
getgenv().killAllStudsPerSecond = 440 -- How fast to go towards targets
getgenv().killAllHitOptimizationEnabled = true -- Improves efficiency by not waiting for the client to know if the target got hit
getgenv().killAllIgnoreGliders = false -- Ignore targets if they are gliding
getgenv().killAllLagAdjustmentEnabled = true -- Determines whether or not to adjust for lag (useful for attacking gliders)
getgenv().killAllGliderLagAdjustmentOnly = false -- Only adjust for lag if the target is gliding
getgenv().killAllLagAdjustmentStudsAheadActivation = 5 -- How many studs the target is estimated to be ahead to trigger lag adjustment

-- DO NOT TOUCH
getgenv().SRCheatConfigured = true; loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Voxul/RobloxScripts/main/test/SlapRoyaleTest.lua'))()
