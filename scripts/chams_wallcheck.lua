_G.ChamsWallEnabled = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local connection
connection = RunService.RenderStepped:Connect(function()
    -- Kill Switch
    if not _G.ChamsWallEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("NHack_Adaptive")
                if hl then hl:Destroy() end
            end
        end
        connection:Disconnect()
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            
            -- Team Check
            if player.Team == LocalPlayer.Team and player.Team ~= nil then
                local hl = char:FindFirstChild("NHack_Adaptive")
                if hl then hl:Destroy() end
                continue
            end

            local head = char:FindFirstChild("Head")
            if head then
                local ray = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position), RaycastParams.new())
                
                local hl = char:FindFirstChild("NHack_Adaptive") or Instance.new("Highlight")
                hl.Name = "NHack_Adaptive"
                hl.FillTransparency = 0.5
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = char
                
                if not ray then
                    hl.FillColor = Color3.fromRGB(0, 255, 127) -- Visible
                    hl.OutlineColor = Color3.fromRGB(0, 255, 127)
                else
                    hl.FillColor = Color3.fromRGB(255, 38, 38) -- Hidden
                    hl.OutlineColor = Color3.fromRGB(255, 38, 38)
                end
            end
        end
    end
end)
