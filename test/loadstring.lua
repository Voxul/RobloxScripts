if game.PlaceId ~= 9431156611 or getgenv().SRCheatConfigured then return end
-- CONFIGURATION
getgenv().disableBarriers = true
getgenv().hazardCollision = true

getgenv().hideCharacterInLobby = true -- Useful for evading noobs yelling at you

getgenv().itemVacEnabled = true

getgenv().bombBus = true
getgenv().permaTruePower = true -- Activates when you have 2 or more True Powers
getgenv().usePermaItems = true -- Automatically use permanent items
getgenv().useIceCubes = false -- Automatically use ice cubes to allow killAll/kill aura oneshots for a few hits

getgenv().instantBusJump = true
getgenv().busJumpLegitMode = false -- Waits for the jump prompt to appear
getgenv().instantLand = true -- Teleports you to the ground instantly

getgenv().safetyHeal = true
getgenv().healthLow = 30
getgenv().healthOk = 80

getgenv().killAll = true
getgenv().killAllInitDelay = 5 -- How long to wait before starting
getgenv().killAllStudsPerSecond = 420
getgenv().killAllHitOptimizationEnabled = true -- Improves efficiency
getgenv().killAllIgnoreGliders = true -- Ignore targets if they are gliding

-- DO NOT TOUCH
getgenv().SRCheatConfigured = true; loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Voxul/RobloxScripts/main/test/SlapRoyaleTest.lua'))()
