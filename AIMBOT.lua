-- Basic Aimbot Script (Team-Based)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local ToggleKey = Enum.KeyCode.E  -- Press E to toggle aimbot
local AimbotEnabled = false
local AimPartName = "Head"  -- Change to "HumanoidRootPart" or another part if needed
local AimRadius = 200  -- Pixels from the mouse where the aimbot will search

-- Function to get the closest enemy to your mouse
local function getClosestEnemy()
    local mousePos = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local shortestDistance = AimRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
            local part = player.Character:FindFirstChild(AimPartName)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = part
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Aiming logic
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local targetPart = getClosestEnemy()
        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end
end)

-- Toggle aimbot on key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == ToggleKey then
        AimbotEnabled = not AimbotEnabled
        print("Aimbot " .. (AimbotEnabled and "Enabled" or "Disabled"))
    end
end)
