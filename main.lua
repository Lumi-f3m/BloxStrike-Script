--[[
   Hey!
   I am Lumi, the current developer of this Bloxstike script. Give me time to build it. This will be completely open source and free :D
   This project will NOT be Obfuscated and we'll be testing ESP first :D (Check out the ESP.lua file)
   If you use any component in this script, Please give me some credit atleast. (I wouldn't mind either way)
]]
-- I hope you enjoy it <3

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cleanup old UI
if CoreGui:FindFirstChild("NHack_Premium") then CoreGui.NHack_Premium:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NHack_Premium"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Mobile Toggle Circle
local MobileBtn = Instance.new("TextButton")
MobileBtn.Size = UDim2.new(0, 50, 0, 50)
MobileBtn.Position = UDim2.new(0, 15, 0.5, -25)
MobileBtn.BackgroundColor3 = Color3.fromRGB(255, 38, 38)
MobileBtn.Text = "NH"
MobileBtn.TextColor3 = Color3.new(1, 1, 1)
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.Parent = ScreenGui
Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(1, 0)

-- Main Frame (Matching your Image)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 340)
Main.Position = UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.Text = "NHack"
Logo.TextColor3 = Color3.fromRGB(255, 38, 38)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 22
Logo.BackgroundTransparency = 1
Logo.Parent = Sidebar

-- Pages Container
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -150, 1, -20)
Pages.Position = UDim2.new(0, 150, 0, 10)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    p.Parent = Pages
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    return p
end

local CombatPage = CreatePage("Combat")
local VisualsPage = CreatePage("Visuals")

-- UI COMPONENTS
local function AddToggle(parent, name, url, flag)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = parent
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[flag] = not _G[flag]
        btn.TextColor3 = _G[flag] and Color3.fromRGB(255, 38, 38) or Color3.fromRGB(150, 150, 150)
        if _G[flag] and url then loadstring(game:HttpGet(url))() end
    end)
end

local function AddAddon(parent, name, flag)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    btn.Text = "      └─ " .. name
    btn.TextColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[flag] = not _G[flag]
        btn.TextColor3 = _G[flag] and Color3.fromRGB(255, 38, 38) or Color3.fromRGB(80, 80, 80)
    end)
end

-- Sidebar Navigation
local function AddTab(name, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Sidebar
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        page.Visible = true
    end)
end

Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
AddTab("Combat", CombatPage)
AddTab("Visuals", VisualsPage)

-- POPULATE
local base = "https://raw.githubusercontent.com/Lumi-f3m/BloxStrike-Script/refs/heads/main/scripts/"

-- Combat Section
AddToggle(CombatPage, "Silent Aim", base.."silent_aim.lua", "SilentAimEnabled")
AddAddon(CombatPage, "Silent Wallcheck", "SilentAimWallcheck")
AddAddon(CombatPage, "Auto Shoot", "AutoShoot")

-- Visuals Section
AddToggle(VisualsPage, "Box ESP", base.."boxESP.lua", "BoxEspEnabled")
AddAddon(VisualsPage, "ESP Wallcheck", "VisualsWallcheck")

AddToggle(VisualsPage, "Chams", base.."chams.lua", "ChamsEnabled")
AddAddon(VisualsPage, "Chams Wallcheck", "ChamsWallcheck")

-- Menu Interaction
MobileBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(io, p) 
    if not p and io.KeyCode == Enum.KeyCode.M then Main.Visible = not Main.Visible end 
end)

CombatPage.Visible = true
