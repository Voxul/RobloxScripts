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

getgenv().killAll = true
getgenv().killAllStudsPerSecond = 420

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local StatsService = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage.Events

local LocalPlr = Players.LocalPlayer
local Character = LocalPlr.Character or LocalPlr.CharacterAdded:Wait()
local HumanoidRootPart:BasePart = Character:WaitForChild("HumanoidRootPart")
local Humanoid:Humanoid = Character:WaitForChild("Humanoid")

Character.PrimaryPart = HumanoidRootPart

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
			v.CanTouch = false
			v.CanCollide = getgenv().hazardCollision
			print("Disabled Acid")
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
		local cachedCFrame = HumanoidRootPart.CFrame

		task.delay(0.6, function()
			Character:PivotTo(HumanoidRootPart.CFrame + Vector3.new(0, 38, 0))
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		end)

		task.delay(0.8+getDataPing(), function()
			if workspace:FindFirstChild("Lobby") then
				Character:PivotTo(cachedCFrame)
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
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
	task.wait()
	
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
	while Character.Ragdolled.Value do
		task.wait()
	end
	
	Events.BusJumping:FireServer()

	if getgenv().teleportToGroundOnBusJump then
		local rayParam = RaycastParams.new()
		rayParam.FilterDescendantsInstances = {workspace.Terrain}
		rayParam.FilterType = Enum.RaycastFilterType.Include
		
		local rayCast
		for i = 1, 5 do
			rayCast = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0,-500,0), rayParam)
			if rayCast then break end
			task.wait()
		end
		
		local landingPos
		if rayCast then
			landingPos = CFrame.new(rayCast.Position + Vector3.new(0,2.5,0))
		else
			warn("Failed to get landing spot, falling back to set")
			landingPos = HumanoidRootPart.CFrame - Vector3.new(0,100,0)
		end

		local jumpTimeoutStart = os.clock()
		while landingPos and (os.clock()-jumpTimeoutStart < 3 or Character.Ragdolled.Value) and not Character:FindFirstChild(gloveName) and not LocalPlr.Backpack:FindFirstChild(gloveName) do
			Character:PivotTo(landingPos)
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			task.wait()
		end
		Character:PivotTo(landingPos)
		task.wait(getDataPing())
		Character:PivotTo(landingPos)
	end
	
	task.spawn(function()
		repeat task.wait() until LocalPlr.PlayerGui:FindFirstChild("JumpPrompt")
		LocalPlr.PlayerGui.JumpPrompt:Destroy()
	end)
end

if getgenv().usePermaItems then
	for _,v in LocalPlr.Backpack:GetChildren() do
		if v:IsA("Tool") and table.find(permanentItems, v.Name) then
			Humanoid:EquipTool(v)
			v:Activate()
		end
	end
end

-- Kill All
if not getgenv().killAll then return end

local function canHitChar(char:Model)
	local charHRM:BasePart = char:FindFirstChild("HumanoidRootPart")
	-- Instance sanity
	if not charHRM or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("Head") or not char:FindFirstChild("inMatch") or not char:FindFirstChild("Ragdolled") or not char:FindFirstChild("Vulnerable") then 
		return false 
	end

	-- Check if they're dead
	if not char.inMatch.Value or char.Humanoid.Health <= 0 or char:FindFirstChild("Dead") then
		return false
	end
	
	-- Additional checks
	if char.Ragdolled.Value or not char.Vulnerable.Value or char:FindFirstChild("Glider") or char.Head.Transparency == 1 then 
		return false 
	end
	
	-- Position sanity
	local CHRMPOS = charHRM.Position
	if math.abs(CHRMPOS.X) > 2000 or math.abs(CHRMPOS.Z) > 2000 or CHRMPOS.Y < - 160 or CHRMPOS.Y > 600 then
		return false
	end
	
	return true
end

local function getModelClosestChild(model:Model, position:Vector3)
	local closestPart, closestMagnitude = nil, nil
	
	for _,v in model:GetChildren() do
		if v:IsA("BasePart") then
			local magnitude = (v.Position-position).Magnitude
			if not closestPart or magnitude < closestMagnitude then
				closestPart = v
				closestMagnitude = magnitude
			end
		end
	end
	
	return closestPart
end

local function getClosestHittableCharacter(position:Vector3):Model
	local closest, closestMagnitude = nil, nil
	
	for _,plr in Players:GetPlayers() do
		if plr == LocalPlr then continue end
		if not plr.Character or not canHitChar(plr.Character) then continue end
		
		local magnitude = (plr.Character.HumanoidRootPart.Position-HumanoidRootPart.Position).Magnitude
		if not closest or magnitude < closestMagnitude then
			closest = plr.Character
			closestMagnitude = magnitude
		end
	end
	
	return closest, closestMagnitude
end

task.wait(2)
print("Initialize kill all")

Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
Humanoid.Seated:Connect(function(active)
	if active then
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Slap Thread
task.spawn(function()
	while task.wait() do
		for _,plr in Players:GetPlayers() do
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and not plr.Character:FindFirstChild("Dead") and (plr.Character.HumanoidRootPart.Position-HumanoidRootPart.Position).Magnitude < 20 then
				Events.Slap:FireServer(getModelClosestChild(plr.Character, HumanoidRootPart.Position))
				Events.Slap:FireServer(plr.Character.HumanoidRootPart)
			end
		end
	end
end)

local studsPerSecond = getgenv().killAllStudsPerSecond
while task.wait() and not Character:FindFirstChild("Dead") do
	local target, distance = getClosestHittableCharacter(HumanoidRootPart.Position)
	if not target then continue end
	
	local moveToStart = os.clock()
	local moveToTick = os.clock()
	
	while os.clock()-moveToStart < distance/studsPerSecond+getDataPing()+2 and canHitChar(target) and not Character:FindFirstChild("Dead") do
		if not Character:FindFirstChild(gloveName) then
			if LocalPlr.Backpack:FindFirstChild(gloveName) then
				Humanoid:EquipTool(LocalPlr.Backpack[gloveName])
			else
				error("Glove missing!")
			end
		end	
		
		Character:PivotTo(HumanoidRootPart.CFrame:Lerp(target.HumanoidRootPart.CFrame, (moveToStart/os.clock() / (target.HumanoidRootPart.Position-HumanoidRootPart.Position).Magnitude*studsPerSecond)*(os.clock()-moveToTick)))
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		
		moveToTick = os.clock()
		task.wait()
	end
end
