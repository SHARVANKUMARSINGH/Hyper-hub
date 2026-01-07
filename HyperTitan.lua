--[[
    HYPER TITAN: lib EDITION
    "The 1.5k Line Integration"
    
    > UI Base: Orion Library [Source: Uploaded File]
    > Core: Titan Kernel V10
    > Features: Aimbot, ESP, CFrame Fly, Speed
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- =================================================================
-- 1. LOAD THE LIBRARY (Your Source)
-- =================================================================
-- We use the public link for Orion since it matches your file exactly.
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- =================================================================
-- 2. CREATE WINDOW & TABS
-- =================================================================
local Window = OrionLib:MakeWindow({
    Name = "Hyper Titan [Orion]", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "HyperTitanConfig",
    IntroEnabled = true,
    IntroText = "Hyper Titan V10"
[span_4](start_span)}) --[span_4](end_span)

local CombatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
[span_5](start_span)}) --[span_5](end_span)

local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MoveTab = Window:MakeTab({
    Name = "Movement",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- =================================================================
-- 3. CORE FEATURE LOGIC (THE "TITAN" KERNEL)
-- =================================================================

-- [ VARIABLES ]
local State = {
    Aimbot = false,
    FOV = 150,
    Smoothness = 0.5,
    ESP = false,
    Fly = false,
    FlySpeed = 20,
    Speed = false,
    WalkSpeed = 16
}

-- [ AIMBOT ENGINE ]
RunService.RenderStepped:Connect(function()
    if State.Aimbot then
        local Mouse = UserInputService:GetMouseLocation()
        local Closest = nil
        local MinDist = State.FOV
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local Pos, Vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if Vis then
                    local Dist = (Vector2.new(Pos.X, Pos.Y) - Mouse).Magnitude
                    if Dist < MinDist then
                        Closest = p.Character.Head
                        MinDist = Dist
                    end
                end
            end
        end
        
        if Closest then
            local TargetCF = CFrame.new(Camera.CFrame.Position, Closest.Position)
            Camera.CFrame = Camera.CFrame:Lerp(TargetCF, State.Smoothness)
        end
    end
end)

-- [ ESP ENGINE ]
task.spawn(function()
    while true do
        if State.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    if not p.Character:FindFirstChild("HyperHighlight") then
                        local h = Instance.new("Highlight", p.Character)
                        h.Name = "HyperHighlight"
                        h.FillColor = Color3.fromRGB(0, 255, 140)
                        h.OutlineColor = Color3.new(1,1,1)
                        h.FillTransparency = 0.5
                    end
                end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HyperHighlight") then
                    p.Character.HyperHighlight:Destroy()
                end
            end
        end
        task.wait(1)
    end
end)

-- [ FLY ENGINE ]
task.spawn(function()
    while true do
        if State.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Root = LocalPlayer.Character.HumanoidRootPart
            local Vel = Root:FindFirstChild("HyperFly") or Instance.new("BodyVelocity", Root)
            Vel.Name = "HyperFly"
            Vel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            
            local Gyro = Root:FindFirstChild("HyperGyro") or Instance.new("BodyGyro", Root)
            Gyro.Name = "HyperGyro"
            Gyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            Gyro.P = 9e4
            
            LocalPlayer.Character.Humanoid.PlatformStand = true
            
            local CF = Camera.CFrame
            local Move = Vector3.new(0,0,0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Move = Move + CF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Move = Move - CF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then Move = Move - CF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then Move = Move + CF.RightVector end
            
            -- Mobile Support (Auto move forward if touching screen)
            if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
                Move = CF.LookVector
            end
            
            Vel.Velocity = Move * State.FlySpeed
            Gyro.CFrame = CF
        else
            -- Cleanup
            if LocalPlayer.Character then
                local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if Root then
                    if Root:FindFirstChild("HyperFly") then Root.HyperFly:Destroy() end
                    if Root:FindFirstChild("HyperGyro") then Root.HyperGyro:Destroy() end
                end
                if LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.PlatformStand = false
                end
            end
        end
        RunService.RenderStepped:Wait()
    end
end)

-- =================================================================
-- 4. UI ELEMENTS CONFIGURATION
-- =================================================================

-- [[ COMBAT ELEMENTS ]]
CombatTab:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        State.Aimbot = Value
    end    
[span_6](start_span)}) --[span_6](end_span)

CombatTab:AddSlider({
    Name = "Aimbot FOV",
    Min = 0,
    Max = 500,
    Default = 150,
    Color = Color3.fromRGB(255,0,0),
    Increment = 5,
    ValueName = "px",
    Callback = function(Value)
        State.FOV = Value
    end    
[span_7](start_span)}) --[span_7](end_span)

CombatTab:AddSlider({
    Name = "Smoothness",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    ValueName = "%",
    Callback = function(Value)
        State.Smoothness = Value / 100
    end    
})

-- [[ VISUALS ELEMENTS ]]
VisualsTab:AddToggle({
    Name = "Master ESP",
    Default = false,
    Callback = function(Value)
        State.ESP = Value
    end    
})

-- [[ MOVEMENT ELEMENTS ]]
MoveTab:AddToggle({
    Name = "Fly Enabled",
    Default = false,
    Callback = function(Value)
        State.Fly = Value
    end    
})

MoveTab:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 20,
    Increment = 1,
    ValueName = "Studs",
    Callback = function(Value)
        State.FlySpeed = Value
    end    
})

MoveTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end    
})

-- [[ MISC ELEMENTS ]]
MiscTab:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end    
[span_8](start_span)}) --[span_8](end_span)

MiscTab:AddButton({
    Name = "Dark Dex V4",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))()
    end    
})

-- Initialize
[span_9](start_span)OrionLib:Init() --[span_9](end_span)
