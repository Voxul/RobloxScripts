if game.PlaceId ~= 9431156611 then return end
getgenv().disableBarriers = true
getgenv().hazardCollision = true

getgenv().hidePlayerInLobby = true -- Useful for evading noobs yelling at you

getgenv().itemVacEnabled = true

getgenv().bombBus = true
getgenv().permaTruePower = true -- Activates when you have 2 or more True Powers
getgenv().usePermaItems = true

getgenv().instantBusJump = true
getgenv().busJumpLegitMode = false
getgenv().teleportToGroundOnBusJump = true

getgenv().safetyHeal = true
getgenv().healthLow = 30
getgenv().healthOk = 80

getgenv().killAll = true
getgenv().killAllStudsPerSecond = 420

if getgenv().SRCheatConfigured then return end
getgenv().SRCheatConfigured = true
loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Voxul/RobloxScripts/main/test/SlapRoyaleTest.lua'))()
