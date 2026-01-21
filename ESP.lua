local Players = game.GetService("Players")
local LocalPlayer = Players.LocalPlayers

local highlights = {}
local enabled = false

local function addHighlight(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    if highlights[player] then return end

    local hightlight = Instance.new("Highlight")
    hightlight.Name = "AdminHighlight"
    hightlight.Adrornee = player.Character
    highlight.FillTransparency = 0.7
    hightlight.OutlineTransparency = 0
    highlight.Parent = player.Character

    -- Experimental Team ESP
    if player.Team then
        hightlight.FillColor = player.Team.TeamColor.Color
    else
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
    end

    highlight[player] = highlight
end

local function removeHighlight(player)
    if highlights[player] then
        hightlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function enableESP()
    enabled = true

    for _, player in ipairs(Players:GetPlayers()) do
        addHighlight(player)
    end
end

local function disableESP()
	enabled = false

	for _, player in pairs(highlights) do
		player:Destroy()
	end
	highlights = {}
end

-- Removing and adding ESP for people joining and leaving
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if enabled then 
            task.wait(1)
            addHighlight(player)
        end
    end)
end)
