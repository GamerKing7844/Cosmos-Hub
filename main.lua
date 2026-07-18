local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

Rayfield:LoadConfiguration()

local Window = Rayfield:CreateWindow({
   Name = "Cosmos Hub",
   Icon = "rocket", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Cosmos Hub",
   LoadingSubtitle = "by GamerKing7844 (Nathan F)",
   ShowText = "Cosmos Hub", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "DarkBlue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "P", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   -- ScriptID = "sid_xxxxxxxxxxxx", -- Your Script ID from developer.sirius.menu — enables analytics, managed keys, and script hosting

   ConfigurationSaving = {
      Enabled = true,
      FolderName = CosmosHub, -- Create a custom folder for your hub/game
      FileName = "CosmosData"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Cosmos Hub | Key System",
      Subtitle = "One-time key system for Cosmos Hub.",
      Note = "Go to the GitHub Repo for the key.", -- Use this to tell the user how to get a key
      FileName = "CosmosKey", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"TestKey"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})

local Player = Window:CreateTab("Player", "user-2")

local Section = Player:CreateSection("Power Adjustment")

local player = game.Players.LocalPlayer
local currentWalkSpeed = 16

local Slider = Player:CreateSlider({
   Name = "Speed Power",
   Range = {0, 256},
   Increment = 1,
   Suffix = "studs per second",
   CurrentValue = 16,
   Flag = "Speed",
   Callback = function(Value)
       currentWalkSpeed = Value
       if player and player.Character then
           local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
           if humanoid then
               humanoid.WalkSpeed = Value
           end
       end
   end,
})

player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = currentWalkSpeed
    end
end)


local player = game.Players.LocalPlayer
local currentJumpPower = 50

local Slider = Player:CreateSlider({
   Name = "Jump Power",
   Range = {0, 250},
   Increment = 1,
   Suffix = "studs per second",
   CurrentValue = 50,
   Flag = "Jump",
   Callback = function(Value)
       currentJumpPower = Value
       if player and player.Character then
           local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")
           if Humanoid then
               Humanoid.UseJumpPower = true 
               Humanoid.JumpPower = Value
           end
       end
   end,
})

player.CharacterAdded:Connect(function(character)
    local Humanoid = character:WaitForChild("Humanoid", 5)
    if Humanoid then
        Humanoid.UseJumpPower = true 
        Humanoid.JumpPower = currentJumpPower
    end
end)

local Section = Player:CreateSection("Health Adjustment")

local player = game.Players.LocalPlayer

local Input = Player:CreateInput({
   Name = "Health",
   CurrentValue = "100",
   PlaceholderText = "50",
   RemoveTextAfterFocusLost = false,
   Flag = "Health",
   Callback = function(Text)
       local targetHealth = tonumber(Text)

       if targetHealth then
           if player and player.Character then
               local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
               if humanoid then
                   if targetHealth > humanoid.MaxHealth then
                       humanoid.MaxHealth = targetHealth
                   end
                   humanoid.Health = targetHealth
               end
           end
       end
   end,
})

player.CharacterAdded:Connect(function()
    task.wait(0.5) 
    Input:Set("100")
end)

local Section = Player:CreateSection("Fun Stuff")

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local infiniteJumpEnabled = false

local Toggle = Player:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
       infiniteJumpEnabled = Value
   end,
})

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local floatEnabled = false
local currentFloatForce = nil

local function updateFloat(character)
    if not character then return end
    
    if floatEnabled then
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        if rootPart and not rootPart:FindFirstChild("FloatForce") then
            currentFloatForce = Instance.new("BodyVelocity")
            currentFloatForce.Name = "FloatForce"
            currentFloatForce.Velocity = Vector3.new(0, 20, 0)
            currentFloatForce.MaxForce = Vector3.new(0, 400000, 0)
            currentFloatForce.Parent = rootPart
        end
    else
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local force = rootPart:FindFirstChild("FloatForce")
            if force then force:Destroy() end
        end
        currentFloatForce = nil
    end
end

local Toggle = Player:CreateToggle({
   Name = "Float",
   CurrentValue = false,
   Flag = "Float",
   Callback = function(Value)
       floatEnabled = Value
       if player.Character then
           updateFloat(player.Character)
       end
   end,
})

player.CharacterAdded:Connect(function(character)
    task.wait(0.1)
    if floatEnabled then
        updateFloat(character)
    end
end)

local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local flyEnabled = false
local animConnection = nil

local function stopAnimations(humanoid)
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end
end

local function cleanUpFly()
    RunService:UnbindFromRenderStep("MobileFlyStep")
    if animConnection then animConnection:Disconnect(); animConnection = nil end
    
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if rootPart then
        rootPart.Anchored = false
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
    if humanoid then
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
    end
end

local function startFly(character)
    cleanUpFly()
    if not flyEnabled or not character then return end

    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    local humanoid = character:WaitForChild("Humanoid", 5)
    local animator = humanoid:WaitForChild("Animator", 5)
    if not rootPart or not humanoid then return end

    humanoid.PlatformStand = true
    humanoid.AutoRotate = false
    rootPart.Anchored = true
    stopAnimations(humanoid)

    if animator then
        animConnection = animator.AnimationPlayed:Connect(function(track)
            track:Stop(0)
        end)
    end

    local lockedPosition = rootPart.Position

    RunService:BindToRenderStep("MobileFlyStep", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)
        if not character or not character.Parent or not rootPart or not humanoid then
            cleanUpFly()
            return
        end

        humanoid.PlatformStand = true
        stopAnimations(humanoid)

        local camCFrame = camera.CFrame
        local moveDirection = humanoid.MoveDirection

        if moveDirection.Magnitude > 0 then
            local speed = 50
            local localMove = rootPart.CFrame:VectorToObjectSpace(moveDirection)
            local flightDirection = (camCFrame.LookVector * -localMove.Z) + (camCFrame.RightVector * localMove.X)
            
            if flightDirection.Magnitude > 0 then
                flightDirection = flightDirection.Unit
            end
            
            local targetPosition = lockedPosition + (flightDirection * speed * deltaTime)
            
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {character}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            
            rootPart.Anchored = false
            local ray = workspace:Raycast(lockedPosition, flightDirection * 2, raycastParams)
            rootPart.Anchored = true
            
            if not ray then
                lockedPosition = targetPosition
            end
        end

        local lookVector = camCFrame.LookVector
        rootPart.CFrame = CFrame.new(lockedPosition, lockedPosition + Vector3.new(lookVector.X, lookVector.Y, lookVector.Z))
    end)
end

local Toggle = Player:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
       flyEnabled = Value
       if flyEnabled then
           if player.Character then startFly(player.Character) end
       else
           cleanUpFly()
       end
   end,
})

player.CharacterAdded:Connect(function(character)
    if flyEnabled then startFly(character) end
end)


local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local Button = Player:CreateButton({
   Name = "Ragdoll",
   Callback = function()
       if player.Character then
           local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
           local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
           
           if humanoid and humanoid.Health > 0 and rootPart then
               humanoid.PlatformStand = true
               rootPart.CFrame = rootPart.CFrame * CFrame.Angles(math.rad(10), 0, 0)
               rootPart.AssemblyLinearVelocity = rootPart.CFrame.LookVector * 5
           end
       end
   end,
})

UserInputService.JumpRequest:Connect(function()
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.PlatformStand then
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

local player = game.Players.LocalPlayer

local Button = Player:CreateButton({
   Name = "Fling",
   Callback = function()
       if player.Character then
           local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
           if rootPart then
               local flingForce = Instance.new("BodyVelocity")
               flingForce.Name = "FlingForce"
               flingForce.Velocity = (rootPart.CFrame.LookVector * 300) + Vector3.new(0, 150, 0)
               flingForce.MaxForce = Vector3.new(500000, 500000, 500000)
               flingForce.Parent = rootPart
               
               task.wait(0.1)
               flingForce:Destroy()
           end
       end
   end,
})
