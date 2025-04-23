-- ESP Script: Highlights all players and updates every second

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Table to keep track of highlights
local highlights = {}

-- Function to create or update a highlight for a player
local function createOrUpdateHighlight(player)
    if player == LocalPlayer then return end  -- Skip self
    local character = player.Character
    if not character then return end

    local highlight = highlights[player]

    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = game.CoreGui  -- Makes it visible in all cases
        highlights[player] = highlight
    else
        highlight.Adornee = character
    end
end

-- Function to clean up highlights for players who left
local function cleanupHighlights()
    for player, highlight in pairs(highlights) do
        if not Players:FindFirstChild(player.Name) then
            if highlight then
                highlight:Destroy()
            end
            highlights[player] = nil
        end
    end
end

-- Refresh loop
task.spawn(function()
    while true do
        for _, player in pairs(Players:GetPlayers()) do
            createOrUpdateHighlight(player)
        end
        cleanupHighlights()
        task.wait(1)
    end
end)
