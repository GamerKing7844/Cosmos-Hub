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

local Slider = Player:CreateSlider({
   Name = "Speed Power",
   Range = {0, 256},
   Increment = 1,
   Suffix = "studs per second",
   CurrentValue = 16,
   Flag = "Speed", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   local localPlayer = game.Players.LocalPlayer
       
       if localPlayer and localPlayer.Character then
           local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
           if humanoid then
               humanoid.WalkSpeed = Value
           end
       end
   end,
})

local Slider = Player:CreateSlider({
   Name = "Jump Power",
   Range = {0, 250},
   Increment = 1,
   Suffix = "studs per second",
   CurrentValue = 50,
   Flag = "Jump", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   local LocalPlayer = game.Players.LocalPlayer
if LocalPlayer and LocalPlayer.Character then
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.UseJumpPower = true 
        Humanoid.JumpPower = Value
    end
end

   end,
})

local Section = Player:CreateSection("Health Adjustment")

local player = game.Players.LocalPlayer

local Input = Player:CreateInput({
   Name = "Health Adjustment",
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
