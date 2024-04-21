local link = "https://github.com/Voxul/RobloxScripts/raw/main/SlapBattles/SlappleAutoFarm/Slapple%20Farm.lua"
local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local function touchPart(p:BasePart,oP:BasePart,s:boolean?,d:number?)
	firetouchinterest(p,oP,s or 0)
	if d then task.wait(d) end
	if not s then firetouchinterest(p,oP,1) end
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
-- perform two HTTP GET at same time
task.spawn(function()
	for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/6403373529/servers/Public?sortOrder=Asc&limit=100")).data) do
		if v.playing and type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
			table.insert(serverList,v.id)
		end
	end
	completed = true
end)

queue_on_teleport("getgenv().TargetSlaps = "..getgenv().TargetSlaps..";"..game:HttpGet(""))

while not completed do task.wait() end

if serverList[1] then
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, serverList[math.random(1, #serverList)])
else
	warn("No servers found")
end
