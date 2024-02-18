if game.PlaceId ~= 9431156611 then return end
getgenv().disableBarriers = true
getgenv().hazardCollision = true

getgenv().itemVacEnabled = true
getgenv().itemVacHidePlayer = true
getgenv().itemVacWaitForBus = false -- This will override itemVacHidePlayer
getgenv().itemVacAllowBruteForce = true

getgenv().bombBus = true
getgenv().permaTruePower = true -- Activates when you have 2 or more True Powers
getgenv().usePermaItems = true

getgenv().instantBusJump = true
getgenv().teleportToGroundOnBusJump = true

getgenv().safetyHeal = true
getgenv().healthLow = 30
getgenv().healthOk = 80

getgenv().killAll = true
getgenv().killAllStudsPerSecond = 420

if getgenv().SRCheatConfigured then return end
getgenv().SRCheatConfigured = true
loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Voxul/RobloxScripts/main/test/SlapRoyaleTest.lua'))()
