-- Rayfield UI Initialization (unchanged)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "quick script",
   Icon = 0,
   LoadingTitle = "ahh script",
   LoadingSubtitle = "by Lumi_f3m",
   ShowText = "LumiCB",
   Theme = "AmberGlow",

   ToggleUIKeybind = "L",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true 
   },

   KeySystem = false,
   KeySettings = {
      Title = "100% not 12345",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"12345"}
   }
})

Rayfield:Notify({
   Title = "Script Loaded",
   Content = "Script Executed!",
   Duration = 4,
   Image = nil,
})

-- --- CORE LOGIC SETUP ---
local RunService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Corrected Tab and Section Definitions
local MainTab = Window:CreateTab("Main", 4483362458)
local VisualsSection = MainTab:CreateSection("Visuals")
local ESPSection = MainTab:CreateSection("ESP")
local MovementSection = MainTab:CreateSection("Movement")
local ExternalSection = MainTab:CreateSection("External Scripts") -- NEW EXTERNAL SECTION

-- --- Fullbright Variables & Logic ---
local FullbrightActive = false
local defaultBrightness = lighting.Brightness 
local connection = nil -- Heartbeat connection for Fullbright

local function runFullbright()
    connection = RunService.Heartbeat:Connect(function()
        if FullbrightActive then
             -- Set brightness, Ambient, and OutdoorAmbient to high values
             lighting.Brightness = 100
             lighting.Ambient = Color3.new(1, 1, 1)
             lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        end
    end)
end

-- --- ESP Variables & Logic (FIXED) ---
local ESPActive = false
local activeHighlights = {} -- Stores part -> highlight reference
local espConnection = nil -- Heartbeat connection for ESP
local ESP_COLOR = Color3.fromRGB(255, 0, 0) -- Bright Red outline

-- Function to remove all currently active highlights
local function cleanupESP()
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end

    -- Destroy all stored Highlight instances
    for part, highlight in pairs(activeHighlights) do
        highlight:Destroy()
    end
    activeHighlights = {} 
end

-- Function to check for parts and ensure they have a highlight (runs every frame)
local function updateESP()
    -- FIX: Dynamically resolve the path every frame. This handles late loading of objects.
    local currentTarget = workspace:FindFirstChild("storm_related") and workspace.storm_related:FindFirstChild("storms")

    if not currentTarget then 
        -- If the container is missing this frame, clean up any existing highlights
        for part, highlight in pairs(activeHighlights) do
            highlight:Destroy()
        end
        activeHighlights = {}
        return 
    end

    -- 1. Iterate through the target container for new parts
    for _, part in ipairs(currentTarget:GetDescendants()) do
        if part:IsA("BasePart") and not activeHighlights[part] then
            -- Create a new Highlight instance
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillTransparency = 1 
            highlight.OutlineColor = ESP_COLOR
            highlight.DepthMode = Enum.DepthMode.AlwaysOnTop 
            highlight.Parent = part
            
            -- Store the reference
            activeHighlights[part] = highlight
        end
    end

    -- 2. Clean up highlights for parts that have been destroyed or moved
    for part, highlight in pairs(activeHighlights) do
        if not part.Parent or not part:IsDescendantOf(currentTarget) then
             highlight:Destroy()
             activeHighlights[part] = nil
        end
    end
end

-- --- MOVEMENT LOGIC (ANTI-KICK IMPLEMENTED) ---
local function TeleportToCustomCFrame()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Rayfield:Notify({
            Title = "TP Error",
            Content = "Player character or HRP not found.",
            Duration = 4,
        })
        return
    end

    local HRP = LocalPlayer.Character.HumanoidRootPart
    
    -- The CFrame is constructed using all 12 matrix components
    local targetCFrame = CFrame.new(
        17554.9492, 120.593063, -9083.19727,  -- Position (X, Y, Z)
        0, 0, -1,                            -- Right Vector (R00, R10, R20)
        0, 1, 0,                             -- Up Vector (R01, R11, R21)
        1, 0, 0                              -- LookVector (R02, R12, R22)
    )

    local startCFrame = HRP.CFrame
    local steps = 10 -- Number of small jumps to perform

    -- NEW: Iterate the teleport over multiple frames to bypass AC distance checks
    for i = 1, steps do
        local alpha = i / steps -- Interpolation factor (e.g., 0.1, 0.2, ... 1.0)
        
        -- Lerp (linear interpolation) the CFrame
        HRP.CFrame = startCFrame:Lerp(targetCFrame, alpha)
        
        -- Wait for the next frame to update the CFrame
        RunService.Heartbeat:Wait()
    end
    
    -- Ensure final position is exactly the target CFrame
    HRP.CFrame = targetCFrame

    Rayfield:Notify({
        Title = "Teleport Success",
        Content = "Teleported to custom coordinates (AC-safe warp implemented)! Wait 3s.",
        Duration = 3,
    })
end

-- --- UI COMPONENTS (FIXED) ---

-- 1. Fullbright Toggle Component (Uses Visuals Section)
local FullbrightToggle = MainTab:CreateToggle({ 
   Name = "Robust Fullbright",
   Info = "Resets lighting every frame to bypass common anti-exploits.",
   CurrentValue = false,
   Flag = "FullbrightRobust", 
   SectionParent = VisualsSection, 
   Callback = function(Value)
        FullbrightActive = Value 
        
        if FullbrightActive then
            print("Robust Fullbright Activated.")
            runFullbright()
        else
            print("Robust Fullbright Deactivated.")
            
            if connection then
                connection:Disconnect()
                connection = nil
            end
            
            -- Restore original lighting settings
            lighting.Brightness = defaultBrightness 
            lighting.Ambient = Color3.new(0, 0, 0) 
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        end
   end,
})


-- 2. Storm ESP Toggle Component (Uses ESP Section)
local StormESPToggle = MainTab:CreateToggle({ 
   Name = "Storm ESP",
   Info = "Outlines objects under 'storms' (visible through walls).",
   CurrentValue = false,
   Flag = "StormESP", 
   SectionParent = ESPSection, 
   Callback = function(Value)
        ESPActive = Value 
        
        if ESPActive then
            print("Storm ESP Activated.")
            -- Start the frame-based update loop
            espConnection = RunService.Heartbeat:Connect(updateESP) 
        else
            print("Storm ESP Deactivated.")
            cleanupESP() -- Stop the loop and destroy highlights
        end
   end,
})

-- 3. Teleport Button Component (Uses Movement Section)
local TeleportButton = MainTab:CreateButton({ 
   Name = "TP To Coords (Warp)",
   Info = "Teleports player using a frame-by-frame warp to prevent anti-cheat kicks.",
   SectionParent = MovementSection, 
   Callback = TeleportToCustomCFrame,
})

-- 4. Twisted Farm UI Button (NEW - Uses External Section)
local TwistedFarmButton = MainTab:CreateButton({ 
   Name = "Twisted Farm UI",
   Info = "Loads and executes the external Twisted Farm script UI.",
   SectionParent = ExternalSection, 
   Callback = function()
        Rayfield:Notify({
            Title = "Loading Script",
            Content = "Attempting to load Twisted Farm...",
            Duration = 3,
        })
        -- Execute the loadstring for the external UI
        loadstring(request({Url='https://raw.githubusercontent.com/asmr23415/TwistedFarmm/refs/heads/main/Twisted'; Method='GET'}).Body)()
   end,
})

-- 5. Infinite Yield Button (NEW - Uses External Section)
local InfiniteYieldButton = MainTab:CreateButton({ 
   Name = "Infinite Yield",
   Info = "Loads and executes the Infinite Yield script.",
   SectionParent = ExternalSection, 
   Callback = function()
        Rayfield:Notify({
            Title = "Loading Script",
            Content = "Attempting to load Infinite Yield...",
            Duration = 3,
        })
        -- Execute the loadstring for Infinite Yield
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})