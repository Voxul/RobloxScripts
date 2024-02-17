local getgenv = getgenv or getfenv

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

getgenv().killAll = false

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local StatsService = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage.Events

local LocalPlr = Players.LocalPlayer
local Character = LocalPlr.Character or LocalPlr.CharacterAdded:Wait()
local HumanoidRootPart:BasePart = Character:WaitForChild("HumanoidRootPart")
local Humanoid:Humanoid = Character:WaitForChild("Humanoid")

local dataPingItem = StatsService.Network:WaitForChild("ServerStatsItem"):WaitForChild("Data Ping")
local function getDataPing():number
	local a
	xpcall(function()
		a = dataPingItem:GetValue()/1000
	end, function()
		a = LocalPlr:GetNetworkPing() + .2
	end)
	return a
end

-- Disable barriers
if getgenv().disableBarriers then
	for _,v:BasePart in workspace.Map.AcidAbnormality:GetChildren() do
		if v.Name == "Acid" and v.ClassName == "Part" and v:FindFirstChild("TouchInterest") then
			print("Disabled Acid")
			v.CanTouch = false
			v.CanCollide = getgenv().hazardCollision
			break
		end
	end
	workspace.Map.DragonDepths:WaitForChild("Lava").CanTouch = false
	workspace.Map.DragonDepths.Lava.CanCollide = getgenv().hazardCollision
	print("Disabled Lava")

	workspace.Map.OriginOffice:WaitForChild("Antiaccess").CanTouch = false
	print("Disabled Antiaccess")

	workspace.Map.AntiUnderMap:ClearAllChildren()
	print("Cleared AntiUnderMap")
end

if getgenv().itemVacEnabled then
	-- Pick up anything new
	workspace.Items.ChildAdded:Connect(function(c)
		if c:IsA("Tool") and c:FindFirstChild("Handle") then
			Events.Item:FireServer(c.Handle)
		end
	end)

	if getgenv().itemVacWaitForBus then
		if workspace:FindFirstChild("Lobby") then
			print("Waiting for bus")
			workspace.Lobby.AncestryChanged:Wait()
		end
	elseif getgenv().itemVacHidePlayer then
		HumanoidRootPart.CFrame += Vector3.new(0, 40, 0)
		local cachedCFrame = HumanoidRootPart.CFrame

		local osS = os.clock()
		while os.clock()-osS < 0.1 do
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			HumanoidRootPart.CFrame = cachedCFrame
			task.wait()
		end

		HumanoidRootPart.Anchored = true

		task.delay(0.5+getDataPing(), function()
			HumanoidRootPart.Anchored = false
			if workspace:FindFirstChild("Lobby") then
				HumanoidRootPart.CFrame = cachedCFrame - Vector3.new(0, 40, 0)
			end
		end)
	end

	local doBruteForcePickup = getgenv().itemVacAllowBruteForce and not workspace:FindFirstChild("Lobby") -- If we're in the bus, do a brute force pickup so other exploiters can't steal
	print("Item Vac started | doBruteForcePickup: "..tostring(doBruteForcePickup))

	-- Hold our ground!
	if doBruteForcePickup then
		HumanoidRootPart.Anchored = true
	end

	for _,v in workspace.Items:GetChildren() do
		if v:IsA("Tool") and v:FindFirstChild("Handle") then
			Events.Item:FireServer(v.Handle)

			if doBruteForcePickup then 
				v.Handle.Massless = true
				v.Handle.Anchored = false 
				Humanoid:EquipTool(v)
			end
		end
	end
	Humanoid:UnequipTools()
	task.wait(getDataPing())
	Humanoid:UnequipTools()
	HumanoidRootPart.Anchored = false
end

local permanentItems = {"Boba", "Bull's essence", "Frog Brew", "Frog Potion", "Potion of Strength", "Speed Brew", "Speed Potion", "Strength Brew"}
local healingItems = {"Apple", "Bandage", "Boba", "First Aid Kit", "Forcefield Crystal", "Healing Brew", "Healing Potion"}

if getgenv().safetyHeal then
	local debounce = false
	Humanoid.HealthChanged:Connect(function(health)
		if debounce then return end
		debounce = true

		if health > getgenv().healthLow then return end

		for _,v in LocalPlr.Backpack:GetChildren() do
			if v:IsA("Tool") and table.find(healingItems, v.Name) then
				Humanoid:EquipTool(v)
				v:Activate()

				task.wait(getDataPing()+0.05)
				if Humanoid.Health >= getgenv().healthOk then break end
			end
		end

		debounce = false
	end)
end

if getgenv().bombBus then
	if workspace:FindFirstChild("Lobby") then
		print("Waiting for Bus")
		workspace.Lobby.AncestryChanged:Wait()
	end

	for _,v in LocalPlr.Backpack:GetChildren() do
		if v:IsA("Tool") and v.Name == "Bomb" then
			Humanoid:EquipTool(v)
			v:Activate()
		end
	end
end

if workspace:FindFirstChild("Lobby") then
	print("Waiting for Bus")
	workspace.Lobby.AncestryChanged:Wait()
end

local gloveName = LocalPlr.Glove.Value

if getgenv().permaTruePower then
	local firstTruePower = nil
	for _,v in LocalPlr.Backpack:GetChildren() do
		if v:IsA("Tool") and v.Name == "True Power" then
			if firstTruePower then
				print("2 True Powers found!")

				Humanoid:EquipTool(firstTruePower)
				firstTruePower:Activate()
				Humanoid:EquipTool(v)
				v:Activate()

				task.wait(5.5)
				break
			end

			firstTruePower = v
		end
	end
end

if getgenv().instantBusJump then
	task.wait()
	Events.BusJumping:FireServer()

	if getgenv().teleportToGroundOnBusJump then
		local rayParam = RaycastParams.new()
		rayParam.FilterDescendantsInstances = {workspace.Terrain}
		rayParam.FilterType = Enum.RaycastFilterType.Include
		
		local rayCast
		for i = 1, 3 do
			rayCast = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0,-500,0), rayParam)
			if rayCast then break end
			task.wait(0.02)
		end
		
		local landingPos
		if rayCast then
			landingPos = CFrame.new(rayCast.Position + Vector3.new(0,2.5,0))
		else
			warn("Failed to get landing spot, falling back to set")
			landingPos = HumanoidRootPart.CFrame - Vector3.new(0,100,0)
		end

		local jumpTimeoutStart = os.clock()
		while landingPos and os.clock()-jumpTimeoutStart < 3 and not Character:FindFirstChild(gloveName) and not LocalPlr.Backpack:FindFirstChild(gloveName) do
			HumanoidRootPart.CFrame = landingPos
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			task.wait()
		end
		task.wait(0.2)
	end
end

if getgenv().usePermaItems then
	for _,v in LocalPlr.Backpack:GetChildren() do
		if v:IsA("Tool") and table.find(permanentItems, v.Name) then
			Humanoid:EquipTool(v)
			v:Activate()
		end
	end
end
