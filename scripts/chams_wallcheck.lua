local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Color Palette 🎨
local COLOR_VISIBLE = Color3.fromRGB(0, 255, 127) -- Bright Green
local COLOR_HIDDEN = Color3.fromRGB(255, 38, 38)  -- Bright Red

local function getHighlight(char)
    local hl = char:FindFirstChild("AdaptiveCham")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "AdaptiveCham"
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
    end
    return hl
end

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            
            -- 1. TEAM CHECK: Skip teammates
            if player.Team == LocalPlayer.Team and player.Team ~= nil then
                local existingHl = char:FindFirstChild("AdaptiveCham")
                if existingHl then existingHl:Destroy() end
                continue -- Moves to the next player in the loop
            end

            local head = char:FindFirstChild("Head")
            if head then
                -- 2. Setup Raycast
                local origin = Camera.CFrame.Position
                local direction = (head.Position - origin)
                
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {LocalPlayer.Character, char}
                params.FilterType = Enum.RaycastFilterType.Exclude
                
                local result = workspace:Raycast(origin, direction, params)
                local hl = getHighlight(char)
                
                -- 3. Check Visibility
                if not result then
                    hl.FillColor = COLOR_VISIBLE
                    hl.OutlineColor = COLOR_VISIBLE
                else
                    hl.FillColor = COLOR_HIDDEN
                    hl.OutlineColor = COLOR_HIDDEN
                end
            end
        end
    end
end)
