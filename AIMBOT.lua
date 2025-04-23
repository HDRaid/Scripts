-- Aimbot that locks the camera to the enemy when holding left-click
-- Targets enemies only (not on the same team)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local AimPartName = "Head"  -- Change to "HumanoidRootPart" if you prefer
local AimRadius = 250  -- Max pixels from mouse to target
local IsMouseDown = false

-- Check if a player is an enemy
local function isEnemy(player)
    return player ~= LocalPlayer and player.Team ~= LocalPlayer.Team
end

-- Get closest enemy part near the mouse cursor
local function getClosestEnemyPart()
    local mousePos = UserInputService:GetMouseLocation()
    local closestPart = nil
    local shortestDistance = AimRadius

    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character then
            local part = player.Character:FindFirstChild(AimPartName)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPart = part
                    end
                end
            end
        end
    end

    return closestPart
end

-- Lock camera every frame while mouse is held
RunService.RenderStepped:Connect(function()
    if IsMouseDown then
        local targetPart = getClosestEnemyPart()
        if targetPart then
            -- Lock camera toward the target
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end
end)

-- Mouse hold detection
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsMouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsMouseDown = false
    end
end)
