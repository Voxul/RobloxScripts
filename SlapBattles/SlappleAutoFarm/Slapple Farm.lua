local LocalPlayer = game:GetService("Players").LocalPlayer
if LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Slaps").Value >= (getgenv().TargetSlaps or 1000) then
	return
end
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local function touchPart(p:BasePart,oP:BasePart--[[,s:boolean?,d:number?]])
	--[[firetouchinterest(p,oP,s or 0)
	if d then task.wait(d) end
	if not s then firetouchinterest(p,oP,1) end]]
	p.CFrame = oP.CFrame -- because codex just can't have working firetouchinterest
end

while not Character:FindFirstChild("entered") do
	touchPart(workspace:WaitForChild("Lobby"):WaitForChild("Teleport1"), HRP)
	task.wait()
end

for _,v:Model in workspace.Arena.island5.Slapples:GetChildren() do
	if v:FindFirstChild("Glove") then
		touchPart(v.Glove,HRP)
	end
end

local serverList, completed = {}, false
task.spawn(function()
	for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/6403373529/servers/Public?sortOrder=Asc&limit=100")).data) do
		if v.playing and type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
			table.insert(serverList,v.id)
		end
	end
	completed = true
end)

queue_on_teleport("getgenv().TargetSlaps = "..(getgenv().TargetSlaps or "1000")..";"..readfile("Voxul_SlappleFarm.txt"))

while not completed do task.wait() end
if identifyexecutor and identifyexecutor():lower():find("codex") then game:GetService("ContentProvider"):PreloadAsync({game:GetService("CoreGui"), game:GetService("CoreGui"):WaitForChild("Codex"):WaitForChild("gui")});task.wait(0.6) end

if serverList[1] then
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, serverList[math.random(1, #serverList)])
else
	warn("No servers found")
end
