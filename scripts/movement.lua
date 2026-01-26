_G.BhopEnabled = true
_G.AutoStrafe = true
_G.NoSlow = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local lastMousePos = UserInputService:GetMouseLocation().X

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- 1. THE "NO SLOW" (Owner God-Speed)
    -- Forces WalkSpeed to 16 if the game tries to slow you down
    if _G.NoSlow then
        if hum.WalkSpeed < 16 then
            hum.WalkSpeed = 16
        end
    end

    -- 2. AUTO BHOP
    -- If holding Space, jump the millisecond you hit the ground
    if _G.BhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    -- 3. SOURCE-STYLE AUTO STRAFE
    -- This increases your air control based on mouse movement
    if _G.AutoStrafe and hum.FloorMaterial == Enum.Material.Air then
        local currentMousePos = UserInputService:GetMouseLocation().X
        local delta = currentMousePos - lastMousePos
        
        if delta > 0 then -- Moving Mouse Right
            hrp.CFrame = hrp.CFrame * CFrame.new(-0.05, 0, 0)
        elseif delta < 0 then -- Moving Mouse Left
            hrp.CFrame = hrp.CFrame * CFrame.new(0.05, 0, 0)
        end
        
        lastMousePos = currentMousePos
    end
end)
