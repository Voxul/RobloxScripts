if game.PlaceId ~= 9431156611 then return end
getgenv().disableBarriers = true
getgenv().hazardCollision = true

getgenv().itemVacEnabled = true
getgenv().itemVacHidePlayer = false
getgenv().itemVacWaitForBus = true -- This will override itemVacHidePlayer
getgenv().itemVacAllowBruteForce = true

getgenv().stealItems = false -- Steals items from other players (excluding their gloves)
getgenv().disableGloves = false -- Disables all gloves for other players, you will get all of them but only the one you equipped works, use in lobby.
getgenv().breakGame = false -- Breaks the entire game

getgenv().bombBus = true
getgenv().permaTruePower = true -- Activates when you have 2 or more True Powers
getgenv().usePermaItems = true
	
getgenv().instantWin = false -- Kills everyone instantly

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
