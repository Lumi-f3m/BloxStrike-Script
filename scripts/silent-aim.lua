-- Variables
local players = game.GetService("Players")
local player = players.LocalPlayer
local mouse = player:GetMouse()
local camera = game:GetService("WorkSpace").CurrentCamera

-- Fucnitons
function notBehindWall(target)
    local ray = Ray.new(player.Character.Head.Position, (target.Position - player.Character.Head.Position).Unit * 300)
    local part, position = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, {player.Character}, false, true)
    if part then
        local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            humanoid.Parent.Parent:FindFirstChildOfClass("Humanoid")
        end
        if humanoid and target and humanoid.Parent == target.Parent then
            local pos, visible = camera:WorldToScreenPoint(target.Position)
            if visible then
                return true
            end
        end
    end
end

function getPlayerClosestToMouse()
    local target = nil
    local maxDist = 100 -- May change later
    for _,v in pairs(players:GetPlayers()) do
        if v.Character then 
            if v.Character.FindFirstChild("Humanoid") and v.Character.Humanoid.Health == 0  and v.Character:FindFirstChild("HumanoidRootPart") and v.TeamColor ~= player.TeamColor then
                local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).magnitude
                if dist  < maxDist and vis then
                    local torsoPos = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    local torsoDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(torsoPos.X, torsoPos.Y)).magnitude
                    local headPos = camera:WorldToViewportPoint(v.Character.Head.Position)
                    local headDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(headPos.X, headPos.Y)).magnitude
                    if torsoDist > headDist then
                        if notBehindWall(v.Character.Head) then
                            target = v.Character.Head
                        end
                    else
                        if notBehindWall(v.Character.HumanoidRootPart) then
                            target = v.Character.HumanoidRootPart
                        end
                    end
                    maxDist = dist
                end
            end
        end
    end
    return target
end

local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall

gmt.__namecall = newcclosure(function(self, ...) 
    local Args = {...}
    local method = getnamecallmethod()
    if tostring(self) == "HitPart" and tostring(method) == "FireServer" then
        Args[1] = getPlayerClosestToMouse()
        Argsgs[2] = getPlayerClosestToMouse().Position
        return self.FireServer(self, unpack(Args))    
    end
    return oldNamecall(self, ...)
end)
-- Total skid btw
