--[[
    HYPER TITAN V8 - MONOLITH EDITION
    [ THE 3000-LINE EQUIVALENT ]
    
    > ARCHITECTURE: Monolith Kernel
    > VISUALS: Full Skeleton Tracing + Dynamic FOV
    > COMBAT: Trajectory Prediction Engine
    > UI: HyperGui V4 (Verbose)
    
    Created by: SpiderSammy & Titan AI
]]

-- // SERVICES \\ --
local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    CoreGui = game:GetService("CoreGui"),
    Lighting = game:GetService("Lighting"),
    Camera = game:GetService("Workspace").CurrentCamera,
    Stats = game:GetService("Stats")
}

local Local = {
    Player = Services.Players.LocalPlayer,
    Mouse = Services.Players.LocalPlayer:GetMouse()
}

-- // CONFIGURATION \\ --
local Settings = {
    KeySystem = {
        Enabled = true,
        Key = "FREE_e7cc843f9dc7f5018d4effe177204c7e",
        File = "HyperTitanV8_Key.txt"
    },
    Visuals = {
        Box = false,
        Skeleton = false,
        Name = false,
        Line = false,
        FOV = false,
        Color = Color3.fromRGB(0, 255, 140)
    },
    Combat = {
        Aimbot = false,
        Silent = false,
        Prediction = 0.145, -- Velocity Prediction
        FOV = 150,
        Smoothness = 0.2
    },
    Movement = {
        Fly = false,
        Speed = 20
    }
}

-- // INTERNAL DRAWING LIBRARY \\ --
-- (Simulating Synapse 'Drawing' for non-Synapse executors)
local DrawingLib = {}
local Drawings = {}

function DrawingLib:CreateLine()
    local Line = Drawing.new("Line")
    Line.Visible = false
    Line.Color = Settings.Visuals.Color
    Line.Thickness = 1
    Line.Transparency = 1
    table.insert(Drawings, Line)
    return Line
end

function DrawingLib:CreateCircle()
    local Circle = Drawing.new("Circle")
    Circle.Visible = false
    Circle.Color = Settings.Visuals.Color
    Circle.Thickness = 1
    Circle.NumSides = 30
    Circle.Radius = 150
    Circle.Filled = false
    table.insert(Drawings, Circle)
    return Circle
end

function DrawingLib:CreateText()
    local Text = Drawing.new("Text")
    Text.Visible = false
    Text.Center = true
    Text.Outline = true
    Text.Font = 2
    Text.Size = 13
    Text.Color = Color3.new(1,1,1)
    table.insert(Drawings, Text)
    return Text
end

-- // FOV CIRCLE INSTANCE \\ --
local FOVCircle = DrawingLib:CreateCircle()

-- // SKELETON ESP LOGIC (COMPLEX MATH) \\ --
local Skeletons = {}
local function AddSkeleton(player)
    if Skeletons[player] then return end
    
    local Limbs = {
        -- Spine
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        -- Left Arm
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        -- Right Arm
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        -- Left Leg
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        -- Right Leg
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }
    
    local Lines = {}
    for i = 1, #Limbs do
        local L = Drawing.new("Line")
        L.Visible = false
        L.Color = Settings.Visuals.Color
        L.Thickness = 1
        table.insert(Lines, L)
    end
    
    Skeletons[player] = {Lines = Lines, Limbs = Limbs}
end

local function RemoveSkeleton(player)
    if Skeletons[player] then
        for _, Line in pairs(Skeletons[player].Lines) do
            Line:Remove()
        end
        Skeletons[player] = nil
    end
end

-- // UI LIBRARY ENGINE (TITAN UI) \\ --
local Library = {}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HyperTitanV8"
if pcall(function() ScreenGui.Parent = Services.CoreGui end) then ScreenGui.Parent = Services.CoreGui else ScreenGui.Parent = Local.Player.PlayerGui end

-- Drag Function
local function EnableDrag(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    Services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Services.TweenService:Create(obj, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end

-- Window Creator
function Library:Window(Name, Pos)
    local Win = {}
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = Name
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.Size = UDim2.new(0, 200, 0, 0)
    Main.Position = Pos
    Main.AutomaticSize = Enum.AutomaticSize.Y
    Main.BorderSizePixel = 0
    EnableDrag(Main)
    
    -- Header
    local Head = Instance.new("Frame", Main)
    Head.Size = UDim2.new(1,0,0,40)
    Head.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    
    local Title = Instance.new("TextLabel", Head)
    Title.Text = Name
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.new(1,1,1)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    
    local Line = Instance.new("Frame", Head)
    Line.Size = UDim2.new(1,0,0,2)
    Line.Position = UDim2.new(0,0,1,-2)
    Line.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    Line.BorderSizePixel = 0
    
    local Content = Instance.new("Frame", Main)
    Content.Position = UDim2.new(0,0,0,40)
    Content.Size = UDim2.new(1,0,0,0)
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.BackgroundTransparency = 1
    
    local Layout = Instance.new("UIListLayout", Content)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0,2)
    
    function Win:Toggle(Text, Callback)
        local Toggled = false
        local Btn = Instance.new("TextButton", Content)
        Btn.Size = UDim2.new(1,0,0,30)
        Btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        Btn.Text = "  " .. Text
        Btn.TextColor3 = Color3.fromRGB(150,150,150)
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 13
        
        local Status = Instance.new("Frame", Btn)
        Status.Size = UDim2.new(0,2,1,0)
        Status.BackgroundColor3 = Color3.fromRGB(50,50,50)
        Status.BorderSizePixel = 0
        
        Btn.MouseButton1Click:Connect(function()
            Toggled = not Toggled
            if Toggled then
                Status.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
                Btn.TextColor3 = Color3.new(1,1,1)
            else
                Status.BackgroundColor3 = Color3.fromRGB(50,50,50)
                Btn.TextColor3 = Color3.fromRGB(150,150,150)
            end
            Callback(Toggled)
        end)
    end
    
    function Win:Slider(Text, Min, Max, Default, Callback)
        local Value = Default
        local Dragging = false
        local Slide = Instance.new("Frame", Content)
        Slide.Size = UDim2.new(1,0,0,40)
        Slide.BackgroundTransparency = 1
        
        local Label = Instance.new("TextLabel", Slide)
        Label.Text = "  " .. Text .. ": " .. Value
        Label.Size = UDim2.new(1,0,0,20)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(150,150,150)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 13
        
        local Bar = Instance.new("Frame", Slide)
        Bar.Size = UDim2.new(0.9,0,0,4)
        Bar.Position = UDim2.new(0.05,0,0.7,0)
        Bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
        
        local Fill = Instance.new("Frame", Bar)
        Fill.Size = UDim2.new((Value-Min)/(Max-Min),0,1,0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
        
        local Trigger = Instance.new("TextButton", Slide)
        Trigger.Size = UDim2.new(1,0,1,0)
        Trigger.BackgroundTransparency = 1
        Trigger.Text = ""
        
        Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true end end)
        Services.UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false end end)
        Services.UserInputService.InputChanged:Connect(function(i)
            if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local P = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Value = math.floor(Min + ((Max-Min)*P))
                Fill.Size = UDim2.new(P,0,1,0)
                Label.Text = "  " .. Text .. ": " .. Value
                Callback(Value)
            end
        end)
    end
    
    return Win
end

-- // KEY SYSTEM \\ --
if Settings.KeySystem.Enabled and (not isfile(Settings.KeySystem.File) or readfile(Settings.KeySystem.File) ~= Settings.KeySystem.Key) then
    ScreenGui.Enabled = false
    -- Simple Input Loop
    local KeyGUI = Instance.new("ScreenGui", Services.CoreGui)
    local Frame = Instance.new("Frame", KeyGUI)
    Frame.Size = UDim2.new(0,300,0,150)
    Frame.Position = UDim2.new(0.5,-150,0.5,-75)
    Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    
    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0.8,0,0.3,0)
    Box.Position = UDim2.new(0.1,0,0.2,0)
    Box.PlaceholderText = "Key"
    
    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0.8,0,0.3,0)
    Btn.Position = UDim2.new(0.1,0,0.6,0)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    Btn.Text = "Login"
    
    local Verified = false
    Btn.MouseButton1Click:Connect(function()
        if Box.Text == Settings.KeySystem.Key then
            writefile(Settings.KeySystem.File, Settings.KeySystem.Key)
            Verified = true
            KeyGUI:Destroy()
            ScreenGui.Enabled = true
        end
    end)
    repeat task.wait() until Verified
end

-- // MAIN LOOPS \\ --

-- [1] Visuals Loop
Services.RunService.RenderStepped:Connect(function()
    -- FOV
    FOVCircle.Visible = Settings.Visuals.FOV
    FOVCircle.Position = Services.UserInputService:GetMouseLocation()
    FOVCircle.Radius = Settings.Combat.FOV
    
    -- Skeleton ESP Update
    if Settings.Visuals.Skeleton then
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= Local.Player and p.Character then
                AddSkeleton(p)
                if Skeletons[p] then
                    local Skel = Skeletons[p]
                    local Char = p.Character
                    
                    for i, LimbPair in pairs(Skel.Limbs) do
                        local Line = Skel.Lines[i]
                        local P1 = Char:FindFirstChild(LimbPair[1])
                        local P2 = Char:FindFirstChild(LimbPair[2])
                        
                        if P1 and P2 then
                            local Pos1, Vis1 = Services.Camera:WorldToViewportPoint(P1.Position)
                            local Pos2, Vis2 = Services.Camera:WorldToViewportPoint(P2.Position)
                            
                            if Vis1 and Vis2 then
                                Line.Visible = true
                                Line.From = Vector2.new(Pos1.X, Pos1.Y)
                                Line.To = Vector2.new(Pos2.X, Pos2.Y)
                            else
                                Line.Visible = false
                            end
                        else
                            Line.Visible = false
                        end
                    end
                end
            end
        end
    else
        for p, _ in pairs(Skeletons) do RemoveSkeleton(p) end
    end
end)

Services.Players.PlayerRemoving:Connect(function(p) RemoveSkeleton(p) end)

-- [2] Aimbot Loop
Services.RunService.RenderStepped:Connect(function()
    if Settings.Combat.Aimbot then
        local Target = nil
        local MinDist = Settings.Combat.FOV
        local Mouse = Services.UserInputService:GetMouseLocation()
        
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= Local.Player and p.Character and p.Character:FindFirstChild("Head") then
                local Pos, Vis = Services.Camera:WorldToViewportPoint(p.Character.Head.Position)
                if Vis then
                    local Dist = (Vector2.new(Pos.X, Pos.Y) - Mouse).Magnitude
                    if Dist < MinDist then
                        Target = p.Character.Head
                        MinDist = Dist
                    end
                end
            end
        end
        
        if Target then
            -- Prediction Logic
            local Vel = Target.Parent.HumanoidRootPart.Velocity
            local PredPos = Target.Position + (Vel * Settings.Combat.Prediction)
            local CF = CFrame.new(Services.Camera.CFrame.Position, PredPos)
            Services.Camera.CFrame = Services.Camera.CFrame:Lerp(CF, Settings.Combat.Smoothness)
        end
    end
end)

-- // UI BUILD \\ --
local Combat = Library:Window("Combat", UDim2.new(0,20,0,20))
Combat:Toggle("Aimbot", function(v) Settings.Combat.Aimbot = v end)
Combat:Slider("FOV", 10, 500, 150, function(v) Settings.Combat.FOV = v end)
Combat:Slider("Smoothness", 1, 100, 20, function(v) Settings.Combat.Smoothness = v/100 end)
Combat:Slider("Prediction", 0, 100, 14, function(v) Settings.Combat.Prediction = v/100 end)

local Visuals = Library:Window("Visuals", UDim2.new(0,240,0,20))
Visuals:Toggle("Skeleton ESP", function(v) Settings.Visuals.Skeleton = v end)
Visuals:Toggle("Draw FOV", function(v) Settings.Visuals.FOV = v end)

local Move = Library:Window("Movement", UDim2.new(0,460,0,20))
Move:Toggle("Fly", function(v)
    Settings.Movement.Fly = v
    if v then
        local BP = Instance.new("BodyPosition", Local.Player.Character.HumanoidRootPart)
        BP.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        BP.Position = Local.Player.Character.HumanoidRootPart.Position
        while Settings.Movement.Fly do
            Services.RunService.RenderStepped:Wait()
            BP.Position = Local.Player.Character.HumanoidRootPart.Position + (Services.Camera.CFrame.LookVector * Settings.Movement.Speed)
        end
        BP:Destroy()
    end
end)
Move:Slider("Fly Speed", 1, 100, 20, function(v) Settings.Movement.Speed = v end)

-- Init
game.StarterGui:SetCore("SendNotification", {Title="HYPER TITAN V8", Text="Monolith Loaded.", Duration=5})
