local getgenv = getgenv or getfenv
if not getgenv().targetSlaps then getgenv().targetSlaps = 1000 end

if not game:IsLoaded() then game.Loaded:Wait() end
local LPLR = game:GetService("Players").LocalPlayer
local char = LPLR.Character or LPLR.CharacterAdded:Wait()
local hrm = char:WaitForChild("HumanoidRootPart")
local tp1 = workspace.Lobby.Teleport1

local function touchPart(part, otherPart, state)
	if type(firetouchinterest)=="function" then
		firetouchinterest(part,otherPart,state or 0)
		if not state then firetouchinterest(part,otherPart,1) end
	end
	part.CFrame = otherPart.CFrame
end

while not char:FindFirstChild("entered") do
	touchPart(tp1,hrm)
	task.wait()
end

for _,v in workspace.Arena.island5.Slapples:GetDescendants() do
	if v.Name=="Glove" and v:FindFirstChild("TouchInterest") then
		touchPart(v,hrm)
	end
end

local serverList = {}
for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
	if v.playing and type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
		table.insert(serverList,v.id)
	end
end

if #serverList > 0 then
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, serverList[math.random(1, #serverList)])
else
	error("No servers found")
end
