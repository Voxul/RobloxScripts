if game.PlaceId ~= 9431156611 then warn("Not Slap Royale!") return end
local getgenv = getgenv or getfenv
if not getgenv().SRCheatConfigured then
	getgenv().SRCheatConfigured = true

	getgenv().disableBarriers = true
	getgenv().hazardCollision = true

	getgenv().itemVacEnabled = true
	getgenv().itemVacHidePlayer = true
	getgenv().itemVacWaitForBus = false -- This will override itemVacHidePlayer
	getgenv().itemVacAllowBruteForce = true
	
	getgenv().stealItems = false -- Steals items from other players (including their gloves)

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
end

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

local function pivotModelTo(Model:Model, cFrame:CFrame, removeVelocity:boolean?)
	Model:PivotTo(cFrame)
	for _,v in Model:GetDescendants() do
		if v:IsA("BasePart") then
			v.AssemblyLinearVelocity = Vector3.zero
			v.AssemblyAngularVelocity = Vector3.zero
		end
	end
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

local itemStealsInProgress = 0
local function stealTool(tool:Tool)
	if tool:IsA("Tool") and tool.Name ~= "Glider" and tool:FindFirstChild("Handle") and tool.Parent ~= Character and not tool:IsDescendantOf(LocalPlr) then
		if getgenv().stealItems and (tool.Parent:FindFirstChild("Humanoid") or tool.Parent:IsA("Backpack")) then
			print("Stealing item from player")

			if tool:FindFirstChild("Glove") then
				tool.Glove.Massless = true
			else
				tool.AncestryChanged:Connect(function(_, p)
					if p ~= Character then return end
					print("Auto-activate "..tool.Name)
					task.defer(tool.Activate, tool)
				end)
			end

			itemStealsInProgress += 1

			local original = HumanoidRootPart.CFrame
			for _,v in Character:GetChildren() do
				if v:IsA("BasePart") then
					v.Anchored = true
					v.AssemblyLinearVelocity = Vector3.zero
					v.AssemblyAngularVelocity = Vector3.zero
				end
			end
			task.delay(0.3+getDataPing(), function()
				itemStealsInProgress -= 1
				if itemStealsInProgress ~= 0 then return end
				for _,v in Character:GetChildren() do
					if v:IsA("BasePart") then
						v.Anchored = false
						v.AssemblyLinearVelocity = Vector3.zero
						v.AssemblyAngularVelocity = Vector3.zero
					end
				end
				HumanoidRootPart.CFrame = original
			end)
		end
		
		Events.Item:FireServer(tool.Handle)
		tool.Handle.Massless = true
	end
end

if getgenv().itemVacEnabled then
	-- Pick up anything new
	workspace.DescendantAdded:Connect(stealTool)
	
	if getgenv().itemVacWaitForBus then
		if workspace:FindFirstChild("Lobby") then
			print("Waiting for bus")
			workspace.Lobby.AncestryChanged:Wait()
		end
	elseif getgenv().itemVacHidePlayer then
		local cachedCFrame = HumanoidRootPart.CFrame
		pivotModelTo(Character, HumanoidRootPart.CFrame + Vector3.new(0, 38, 0), true)

		task.delay(0.4+getDataPing()*2, function()
			if workspace:FindFirstChild("Lobby") then
				pivotModelTo(Character, cachedCFrame, true)
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
			v.Handle.Massless = true
			
			if doBruteForcePickup then 
				v.Handle.Anchored = false
				v.Handle.CFrame = HumanoidRootPart.CFrame
				Humanoid:EquipTool(v)
			end

			v.AncestryChanged:Connect(function(_, p)
				if p ~= Character then return end
				print("Auto-activate "..v.Name)
				task.defer(v.Activate, v)
			end)
		end
	end
	
	Humanoid:UnequipTools()
	task.wait(getDataPing())
	Humanoid:UnequipTools()
	HumanoidRootPart.Anchored = false
end

if getgenv().stealItems then
	Players.DescendantAdded:Connect(stealTool)
end

local permanentItems = {"Boba", "Bull's essence", "Frog Brew", "Frog Potion", "Potion of Strength", "Speed Brew", "Speed Potion", "Strength Brew"}
local healingItems = {"Apple", "Bandage", "Boba", "First Aid Kit", "Forcefield Crystal", "Healing Brew", "Healing Potion"}

if getgenv().safetyHeal then
	local debounce = false
	Humanoid.HealthChanged:Connect(function(health)
		if debounce or Character:FindFirstChild("Dead") then return end
		debounce = true

		if health > getgenv().healthLow then return end 

		for _,v in LocalPlr.Backpack:GetChildren() do
			if v:IsA("Tool") and table.find(healingItems, v.Name) then
				Humanoid:EquipTool(v)
				v:Activate()

				task.wait(getDataPing()+0.05)
				if Humanoid.Health >= getgenv().healthOk or Character:FindFirstChild("Dead") then break end
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

				task.wait(5.2)
				break
			end

			firstTruePower = v
		end
	end
end

if getgenv().instantBusJump then
	task.wait(getDataPing() + 0.05)
	while Character.Ragdolled.Value do
		task.wait()
	end

	Events.BusJumping:FireServer()

	if getgenv().teleportToGroundOnBusJump then
		local rayParam = RaycastParams.new()
		rayParam.FilterDescendantsInstances = {workspace.Terrain}
		rayParam.FilterType = Enum.RaycastFilterType.Include

		local rayCast
		for i = 1, 10 do
			rayCast = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0,-400,0), rayParam)
			if rayCast then break end
			task.wait(0.01)
		end

		local landingPos
		if rayCast then
			landingPos = CFrame.new(rayCast.Position + Vector3.new(0,2.5,0))
		else
			warn("Failed to get landing spot, falling back to setPos")
			landingPos = HumanoidRootPart.CFrame - Vector3.new(0,300,0)
		end

		local jumpTimeoutStart = os.clock()
		while landingPos and (os.clock()-jumpTimeoutStart < 3 or Character.Ragdolled.Value) and not Character:FindFirstChild(gloveName) and not LocalPlr.Backpack:FindFirstChild(gloveName) do
			pivotModelTo(Character, landingPos, true)
			task.wait()
		end
		pivotModelTo(Character, landingPos, true)
		task.wait(getDataPing())
		pivotModelTo(Character, landingPos, true)
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
	if not char.Parent then return false end

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

local function getClosestHittableCharacter(position:Vector3, ignore:Model?):Model
	local closest, closestMagnitude = nil, nil

	for _,plr in Players:GetPlayers() do
		if plr == LocalPlr then continue end
		if plr.Character == ignore or not canHitChar(plr.Character) then continue end

		local magnitude = (plr.Character.HumanoidRootPart.Position-HumanoidRootPart.Position).Magnitude
		if not closest or magnitude < closestMagnitude then
			closest = plr.Character
			closestMagnitude = magnitude
		end
	end

	return closest, closestMagnitude
end

task.wait(15)
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

local target, distance = getClosestHittableCharacter(HumanoidRootPart.Position)
while task.wait() and not Character:FindFirstChild("Dead") do
	if not target then
		target, distance = getClosestHittableCharacter(HumanoidRootPart.Position)
		continue 
	end

	local moveToStart = os.clock()
	local moveToTick = os.clock()

	local ignore = nil
	while canHitChar(target) and not Character:FindFirstChild("Dead") do
		if os.clock()-moveToStart > distance/studsPerSecond+getDataPing()+2 then
			warn("Target timed out!")
			ignore = target
			break
		end

		if not Character:FindFirstChild(gloveName) then
			if LocalPlr.Backpack:FindFirstChild(gloveName) then
				Humanoid:EquipTool(LocalPlr.Backpack[gloveName])
			else
				error("Glove missing!")
			end
		end
		
		if gloveStealsInProgress == 0 then
			pivotModelTo(Character, HumanoidRootPart.CFrame:Lerp(target.HumanoidRootPart.CFrame, (moveToStart/os.clock() / (target.HumanoidRootPart.Position-HumanoidRootPart.Position).Magnitude*studsPerSecond)*(os.clock()-moveToTick)), true)
		else
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		end
			
		moveToTick = os.clock()
		task.wait()
	end
	target, distance = getClosestHittableCharacter(HumanoidRootPart.Position, ignore)
end
