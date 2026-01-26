local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tactical Red 
local RED_COLOR = Color3.fromRGB(255, 38, 38)

local function applyRedESP(player)
    -- 1. Ignore yourself
    if player == LocalPlayer then return end

    local function setup(char)
        -- 2. TEAM CHECK: Only proceed if they are NOT on your team
        -- (This also works if the game doesn't use teams, as both will be nil)
        if player.Team ~= nil and player.Team == LocalPlayer.Team then
            -- If they are a teammate, remove any existing ESP and stop
            local existing = char:FindFirstChild("PermanentRedESP")
            if existing then existing:Destroy() end
            return 
        end

        local hl = char:FindFirstChild("PermanentRedESP")
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "PermanentRedESP"
            hl.FillColor = RED_COLOR
            hl.OutlineColor = RED_COLOR
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Visible through walls
            hl.Parent = char
        end
    end

    -- Initial setup
    if player.Character then setup(player.Character) end
    
    -- Watch for respawns
    player.CharacterAdded:Connect(setup)
    
    -- Watch for team changes (in case they switch mid-game)
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if player.Character then setup(player.Character) end
    end)
end

-- Initialize for current players
for _, player in pairs(Players:GetPlayers()) do
    applyRedESP(player)
end

-- Watch for new players joining
Players.PlayerAdded:Connect(applyRedESP)
