local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ RAY HUB | Counter Blox 💣",
   LoadingTitle = "RAY HUB Systems Loading...",
   LoadingSubtitle = "Global Edition Active!",
   ConfigurationSaving = { Enabled = true, FolderName = "RayHubConfigs", FileName = "CB_Ray_Global" },
   KeybindSource = "RightShift" 
})

-- [🚫 INTERFACE CLEANUP - ULTRA STEALTH]
pcall(function()
    local rf = game:GetService("CoreGui"):FindFirstChild("Rayfield")
    if rf then
        local main = rf:FindFirstChild("Main")
        if main then
            if main:FindFirstChild("ResizeBar") then main.ResizeBar:Destroy() end
            if rf:FindFirstChild("ContainerButton") then rf.ContainerButton:Destroy() end
        end
    end
end)

-- [🛡️ VARIABLES]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

_G.AimbotEnabled = false
_G.TeamCheck = true
_G.ESPEnabled = false
_G.NoSmoke = false
_G.FOVSize = 100
_G.FOVVisible = true

-- [🎯 FOV CIRCLE]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.8
FOVCircle.Visible = false

-- [💨 NO SMOKE LOGIC]
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.NoSmoke then
        pcall(function()
            for _, v in pairs(workspace.Ray_Ignore.Smokes:GetChildren()) do
                if v:IsA("Part") or v:IsA("BasePart") then
                    v.Transparency = 1 
                    v.CanCollide = false
                end
            end
        end)
    end
end)

-- [🎯 AIMBOT & FOV LOOP]
game:GetService("RunService").RenderStepped:Connect(function()
    FOVCircle.Visible = _G.FOVVisible
    FOVCircle.Radius = _G.FOVSize
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)

    if _G.AimbotEnabled then
        local Target = nil
        local ShortestDistance = _G.FOVSize
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
                if not _G.TeamCheck or v.Team ~= LocalPlayer.Team then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                    if OnScreen then
                        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if Distance < ShortestDistance then
                            Target = v
                            ShortestDistance = Distance
                        end
                    end
                end
            end
        end

        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    end
end)

-- [👁️ ESP SYSTEM]
game:GetService("RunService").RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("RayHighlight")
            if _G.ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight", player.Character)
                    highlight.Name = "RayHighlight"
                end
                highlight.FillColor = (player.Team == LocalPlayer.Team) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.5
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- [📑 TABS]
local CombatTab = Window:CreateTab("🎯 Combat", 4483362458)
local VisualTab = Window:CreateTab("👁️ Visuals", 4483362458)
local AdminTab = Window:CreateTab("⚡ Admin", 4483345998)

-- COMBAT SETTINGS
CombatTab:CreateSection("Aimbot Settings")

CombatTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(v) _G.AimbotEnabled = v end,
})

CombatTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = true,
   Callback = function(v) _G.TeamCheck = v end,
})

CombatTab:CreateSlider({
   Name = "Aimbot FOV Size",
   Range = {50, 500},
   Increment = 10,
   CurrentValue = 100,
   Callback = function(v) _G.FOVSize = v end,
})

-- VISUAL SETTINGS
VisualTab:CreateSection("Visual Enhancements")

VisualTab:CreateToggle({
   Name = "Enable Wallhack (ESP)",
   CurrentValue = false,
   Callback = function(v) _G.ESPEnabled = v end,
})

VisualTab:CreateToggle({
   Name = "No Smoke",
   CurrentValue = false,
   Callback = function(v) _G.NoSmoke = v end,
})

VisualTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = true,
   Callback = function(v) _G.FOVVisible = v end,
})

-- ADMIN SETTINGS
AdminTab:CreateSection("Admin Panel")

AdminTab:CreateButton({
   Name = "Load Infinite Yield",
   Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end,
})

Rayfield:Notify({Title = "RAY HUB READY", Content = "Global version initialized successfully!", Duration = 5})
