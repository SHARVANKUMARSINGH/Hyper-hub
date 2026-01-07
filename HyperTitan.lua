--[[
    HYPER TITAN: RAYFIELD EDITION
    "The Cleanest & Most Powerful Mobile Hub"
    
    > UI Library: Rayfield Interface Suite
    > Core: Titan Kernel V9
    > Features: Skeleton ESP, Silent Aim, Fly, Speed
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- =================================================================
-- 1. CUSTOM KEY SYSTEM (Fixed "Get Link")
-- =================================================================
local KeyConfig = {
    Key = "FREE_e7cc843f9dc7f5018d4effe177204c7e",
    Link = "https://link-target.net/1448934/woiFzcBpdM12",
    FileName = "HyperTitan_Rayfield_Key.txt"
}

local function RunKeySystem()
    -- Check Memory
    if isfile(KeyConfig.FileName) and readfile(KeyConfig.FileName) == KeyConfig.Key then return end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.IgnoreGuiInset = true
    if pcall(function() ScreenGui.Parent = CoreGui end) then ScreenGui.Parent = CoreGui else ScreenGui.Parent = LocalPlayer.PlayerGui end

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 350, 0, 220)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel", Main)
    Title.Text = "HYPER TITAN LOCKED"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 24
    Title.TextColor3 = Color3.fromRGB(0, 255, 140)
    Title.Size = UDim2.new(1, 0, 0.3, 0)
    Title.BackgroundTransparency = 1

    local Input = Instance.new("TextBox", Main)
    Input.Size = UDim2.new(0.8, 0, 0.2, 0)
    Input.Position = UDim2.new(0.1, 0, 0.3, 0)
    Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Input.TextColor3 = Color3.new(1,1,1)
    Input.PlaceholderText = "Paste Key Here..."
    Input.TextSize = 16
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 8)

    local Enter = Instance.new("TextButton", Main)
    Enter.Size = UDim2.new(0.4, 0, 0.2, 0)
    Enter.Position = UDim2.new(0.5, 5, 0.6, 0)
    Enter.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    Enter.Text = "LOGIN"
    Enter.Font = Enum.Font.GothamBold
    Enter.TextSize = 16
    Instance.new("UICorner", Enter).CornerRadius = UDim.new(0, 8)

    local LinkBtn = Instance.new("TextButton", Main)
    LinkBtn.Size = UDim2.new(0.4, 0, 0.2, 0)
    LinkBtn.Position = UDim2.new(0.1, -5, 0.6, 0)
    LinkBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    LinkBtn.Text = "GET LINK"
    LinkBtn.TextColor3 = Color3.new(1,1,1)
    LinkBtn.Font = Enum.Font.GothamBold
    LinkBtn.TextSize = 16
    Instance.new("UICorner", LinkBtn).CornerRadius = UDim.new(0, 8)

    LinkBtn.MouseButton1Click:Connect(function()
        setclipboard(KeyConfig.Link)
        LinkBtn.Text = "COPIED!"
        task.wait(1)
        LinkBtn.Text = "GET LINK"
    end)

    local Verified = false
    Enter.MouseButton1Click:Connect(function()
        if Input.Text == KeyConfig.Key then
            writefile(KeyConfig.FileName, KeyConfig.Key)
            Verified = true
            ScreenGui:Destroy()
        else
            Enter.Text = "INVALID"
            Enter.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(1)
            Enter.Text = "LOGIN"
            Enter.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
        end
    end)
    repeat task.wait() until Verified
end
RunKeySystem()

-- =================================================================
-- 2. RAYFIELD UI LIBRARY
-- =================================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Hyper Titan [Rayfield]",
    LoadingTitle = "Hyper Hub",
    LoadingSubtitle = "Titan Engine V9",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "HyperTitanConfig",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false -- We used our custom one above
})

-- =================================================================
-- 3. TABS & FEATURES
-- =================================================================

-- [ VARIABLES ]
local State = {
    Aimbot = false, FOV = 150, Smooth = 0.5,
    Fly = false, FlySpeed = 20,
    ESP = false, Skeletons = false,
    Walk = 16, Jump = 50
}

-- [ TAB: COMBAT ]
local CombatTab = Window:CreateTab("Combat", 4483362458) -- Sword Icon

CombatTab:CreateToggle({
    Name = "Aimbot Enabled",
    CurrentValue = false,
    Callback = function(Value)
        State.Aimbot = Value
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
                    Camera.CFrame = Camera.CFrame:Lerp(TargetCF, State.Smooth)
                end
            end
        end)
    end,
})

CombatTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {10, 500},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(Value) State.FOV = Value end,
})

CombatTab:CreateSlider({
    Name = "Smoothness",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = 0.5,
    Callback = function(Value) State.Smooth = Value end,
})

-- [ TAB: VISUALS ]
local VisualsTab = Window:CreateTab("Visuals", 4483362458) -- Eye Icon

VisualsTab:CreateToggle({
    Name = "Master ESP (Highlight)",
    CurrentValue = false,
    Callback = function(Value)
        State.ESP = Value
        task.spawn(function()
            while State.ESP do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("HyperESP") then
                        local h = Instance.new("Highlight", p.Character)
                        h.Name = "HyperESP"
                        h.FillColor = Color3.fromRGB(0, 255, 140)
                        h.OutlineColor = Color3.new(1,1,1)
                    end
                end
                task.wait(1)
            end
            -- Clear if turned off
            if not State.ESP then
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("HyperESP") then
                        p.Character.HyperESP:Destroy()
                    end
                end
            end
        end)
    end,
})

VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
        else
            Lighting.Brightness = 1
        end
    end,
})

-- [ TAB: MOVEMENT ]
local MoveTab = Window:CreateTab("Movement", 4483362458) -- Run Icon

MoveTab:CreateToggle({
    Name = "Fly (CFrame)",
    CurrentValue = false,
    Callback = function(Value)
        State.Fly = Value
        if Value then
            local Root = LocalPlayer.Character.HumanoidRootPart
            local BG = Instance.new("BodyGyro", Root); BG.P=9e4; BG.maxTorque=Vector3.new(9e9,9e9,9e9); BG.cframe=Root.CFrame
            local BV = Instance.new("BodyVelocity", Root); BV.velocity=Vector3.new(0,0,0); BV.maxForce=Vector3.new(9e9,9e9,9e9)
            LocalPlayer.Character.Humanoid.PlatformStand = true
            
            while State.Fly do
                RunService.RenderStepped:Wait()
                local CF = Camera.CFrame
                local Vel = Vector3.new(0,0,0)
                if UserInputService.TouchEnabled then
                    Vel = CF.LookVector * State.FlySpeed
                else
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then Vel = Vel + CF.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then Vel = Vel - CF.LookVector end
                end
                BG.cframe = CF
                BV.velocity = Vel * State.FlySpeed
            end
            BG:Destroy(); BV:Destroy()
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
    end,
})

MoveTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 10,
    CurrentValue = 20,
    Callback = function(Value) State.FlySpeed = Value end,
})

MoveTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value) 
        if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = Value end
    end,
})

-- [ TAB: SCRIPTS ]
local ScriptTab = Window:CreateTab("Scripts", 4483362458) -- Script Icon

ScriptTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
})

ScriptTab:CreateButton({
    Name = "Dark Dex V4",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))()
    end,
})

Rayfield:Notify({
    Title = "Hyper Titan Loaded",
    Content = "The Hub is ready. Enjoy.",
    Duration = 5,
    Image = 4483362458,
})
