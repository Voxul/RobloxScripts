local getgenv = getgenv or getfenv
getgenv().targetSlaps = 1000
if not game:IsLoaded() then game.Loaded:Wait() end
if game.Players.LocalPlayer.Slaps.Value >= getgenv().targetSlaps then return end
loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Voxul/RobloxScripts/3f7297f3d2cfc0037e5953301259f38d869ec0a5/SlapBattles/SlappleAutoFarm/Slapple%20Farm.lua'))()
