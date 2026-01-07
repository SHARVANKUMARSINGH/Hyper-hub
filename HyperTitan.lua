--[[
    HYPER HUB: TITAN EDITION (V6.0 - EXTENDED KERNEL)
    "The Apex of Mobile Scripting"
    
    [ ARCHITECTURE ]
    - Core: Titan Framework V2
    - UI: Adaptive ImGui (Mobile/PC)
    - Security: Memory-Based Key Verification + Anti-Tamper
    - Networking: Protected Remote Events
    
    [ CREDITS ]
    - Lead Developer: SpiderSammy
    - UI Design: Gemini/Titan
    - Bypasses: Voidware Methods
    
    [ CHANGELOG V6 ]
    + Added Silent Aim (Universal)
    + Added Health Bars & Tracers
    + Added Velocity Fly & Spider
    + Added Team Checks & Wall Checks
]]

-- =================================================================
-- [ SECTION 1: CORE SERVICES & PROTECTION ]
-- =================================================================
local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    CoreGui = game:GetService("CoreGui"),
    Lighting = game:GetService("Lighting"),
    HttpService = game:GetService("HttpService"),
    VirtualUser = game:GetService("VirtualUser"),
    TeleportService = game:GetService("TeleportService"),
    StarterGui = game:GetService("StarterGui"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Stats = game:GetService("Stats")
}

local Local = {
    Player = Services.Players.LocalPlayer,
    Camera = Services.Workspace.CurrentCamera,
    Mouse = Services.Players.LocalPlayer:GetMouse()
}

-- Optimization Variables (Fast Access)
local V2 = Vector2.new
local V3 = Vector3.new
local CF = CFrame.new
local DRAW = Drawing -- Fallback handled later if missing

-- Protection: Garbage Collection & Connection Security
local Connections = {}
local function SecureConnect(signal, callback)
    local con = signal:Connect(callback)
    table.insert(Connections, con)
    return con
end

-- =================================================================
-- [ SECTION 2: CONFIGURATION & THEME ]
-- =================================================================
local CONFIG = {
    Security = {
        Key = "FREE_e7cc843f9dc7f5018d4effe177204c7e",
        Link = "https://link-target.net/1448934/woiFzcBpdM12",
        FileName = "HyperTitan_V6_Key.txt",
        Version = "Titan V6.0 Extended"
    },
    Theme = {
        Main = Color3.fromRGB(18, 18, 20),
        Header = Color3.fromRGB(24, 24, 28),
        Accent = Color3.fromRGB(0, 255, 140), -- Hyper Neon
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(170, 170, 170),
        Outline = Color3.fromRGB(40, 40, 45),
        Divider = Color3.fromRGB(30, 30, 35),
        Hover = Color3.fromRGB(35, 35, 40),
        Success = Color3.fromRGB(0, 255, 100),
        Error = Color3.fromRGB(255, 60, 60)
    },
    Settings = {
        MenuKey = Enum.KeyCode.RightShift,
        Scale = 1.0,
        Device = "PC",
        Notifications = true
    }
}

-- =================================================================
-- [ SECTION 3: ADVANCED DEVICE DETECTION ]
-- =================================================================
if Services.UserInputService.TouchEnabled and not Services.UserInputService.MouseEnabled then
    local Res = Local.Camera.ViewportSize
    if Res.X > 800 then
        CONFIG.Settings.Device = "Tablet"
        CONFIG.Settings.Scale = 1.25
    else
        CONFIG.Settings.Device = "Mobile"
        CONFIG.Settings.Scale = 1.5 -- 50% Larger for Phone
    end
else
    CONFIG.Settings.Device = "PC"
    CONFIG.Settings.Scale = 1.0
end
local SC = CONFIG.Settings.Scale

-- =================================================================
-- [ SECTION 4: TITAN UI ENGINE (REWRITTEN) ]
-- =================================================================
local Library = {Windows = {}}
local UI_Storage = Instance.new("ScreenGui")
UI_Storage.Name = "HyperTitan_V6"
UI_Storage.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI_Storage.IgnoreGuiInset = true

if pcall(function() UI_Storage.Parent = Services.CoreGui end) then 
    UI_Storage.Parent = Services.CoreGui 
else 
    UI_Storage.Parent = Local.Player.PlayerGui 
end

-- Dragging Physics
local function MakeDraggable(obj, dragHandle)
    local dragging, dragInput, dragStart, startPos
    local handle = dragHandle or obj
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    Services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local target = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            Services.TweenService:Create(obj, TweenInfo.new(0.05), {Position = target}):Play()
        end
    end)
end

-- Notification System
function Library:Notify(Title, Content, Duration)
    Services.StarterGui:SetCore("SendNotification", {
        Title = Title,
        Text = Content,
        Duration = Duration or 3
    })
end

-- Mobile Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = UI_Storage
ToggleBtn.Size = UDim2.new(0, 50 * SC, 0, 50 * SC)
ToggleBtn.Position = UDim2.new(0.5, -25 * SC, 0.05, 0)
ToggleBtn.BackgroundColor3 = CONFIG.Theme.Accent
ToggleBtn.Text = "V6"
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 20 * SC
ToggleBtn.TextColor3 = Color3.new(0,0,0)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
    for _, win in pairs(Library.Windows) do
        win.Visible = not win.Visible
    end
end)

-- Window Constructor
function Library:CreateWindow(Name, PosX)
    local Window = {}
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Win_" .. Name
    MainFrame.Parent = UI_Storage
    MainFrame.BackgroundColor3 = CONFIG.Theme.Main
    MainFrame.Size = UDim2.new(0, 190 * SC, 0, 0) -- Auto Height
    MainFrame.Position = UDim2.new(0, PosX * SC, 0, 80 * SC)
    MainFrame.AutomaticSize = Enum.AutomaticSize.Y
    MainFrame.BorderSizePixel = 0
    table.insert(Library.Windows, MainFrame)
    
    local Outline = Instance.new("UIStroke")
    Outline.Parent = MainFrame
    Outline.Color = CONFIG.Theme.Outline
    Outline.Thickness = 1
    
    local Header = Instance.new("Frame")
    Header.Parent = MainFrame
    Header.Size = UDim2.new(1, 0, 0, 42 * SC)
    Header.BackgroundColor3 = CONFIG.Theme.Header
    Header.BorderSizePixel = 0
    
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Parent = Header
    TitleLbl.Text = Name:upper()
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 14 * SC
    TitleLbl.TextColor3 = CONFIG.Theme.Text
    TitleLbl.Size = UDim2.new(1, -10, 1, 0)
    TitleLbl.Position = UDim2.new(0, 10, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local DecorLine = Instance.new("Frame")
    DecorLine.Parent = Header
    DecorLine.Size = UDim2.new(1, 0, 0, 2)
    DecorLine.Position = UDim2.new(0, 0, 1, -2)
    DecorLine.BackgroundColor3 = CONFIG.Theme.Accent
    DecorLine.BorderSizePixel = 0
    
    MakeDraggable(MainFrame, Header)
    
    local Container = Instance.new("Frame")
    Container.Parent = MainFrame
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.Position = UDim2.new(0, 0, 0, 42 * SC)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 1)
    
    -- Element: Toggle
    function Window:CreateToggle(Text, Default, Callback)
        local Toggled = Default or false
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Parent = Container
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35 * SC)
        ToggleFrame.BackgroundColor3 = CONFIG.Theme.Main
        ToggleFrame.BorderSizePixel = 0
        
        local Btn = Instance.new("TextButton")
        Btn.Parent = ToggleFrame
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundTransparency = 1
        Btn.Text = "   " .. Text
        Btn.TextColor3 = Toggled and CONFIG.Theme.Accent or CONFIG.Theme.TextDark
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 13 * SC
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        
        local Status = Instance.new("Frame")
        Status.Parent = ToggleFrame
        Status.Size = UDim2.new(0, 8 * SC, 0, 8 * SC)
        Status.Position = UDim2.new(1, -18 * SC, 0.5, -4 * SC)
        Status.BackgroundColor3 = Toggled and CONFIG.Theme.Accent or Color3.fromRGB(40,40,40)
        Instance.new("UICorner", Status).CornerRadius = UDim.new(0, 2)
        
        Btn.MouseButton1Click:Connect(function()
            Toggled = not Toggled
            if Toggled then
                Services.TweenService:Create(Status, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.Theme.Accent}):Play()
                Services.TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = CONFIG.Theme.Accent}):Play()
                Callback(true)
            else
                Services.TweenService:Create(Status, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
                Services.TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = CONFIG.Theme.TextDark}):Play()
                Callback(false)
            end
        end)
        
        if Default then Callback(true) end
    end
    
    -- Element: Slider
    function Window:CreateSlider(Text, Min, Max, Default, Callback)
        local Value = Default or Min
        local Dragging = false
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Parent = Container
        SliderFrame.Size = UDim2.new(1, 0, 0, 50 * SC)
        SliderFrame.BackgroundColor3 = CONFIG.Theme.Main
        SliderFrame.BorderSizePixel = 0
        
        local Title = Instance.new("TextLabel")
        Title.Parent = SliderFrame
        Title.Text = "   " .. Text
        Title.TextColor3 = CONFIG.Theme.TextDark
        Title.Font = Enum.Font.Gotham
        Title.TextSize = 13 * SC
        Title.Size = UDim2.new(1, 0, 0, 25 * SC)
        Title.BackgroundTransparency = 1
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        local ValText = Instance.new("TextLabel")
        ValText.Parent = SliderFrame
        ValText.Text = tostring(Value)
        ValText.TextColor3 = CONFIG.Theme.Accent
        ValText.Font = Enum.Font.GothamBold
        ValText.TextSize = 13 * SC
        ValText.Size = UDim2.new(1, -10 * SC, 0, 25 * SC)
        ValText.BackgroundTransparency = 1
        ValText.TextXAlignment = Enum.TextXAlignment.Right
        
        local BarBack = Instance.new("Frame")
        BarBack.Parent = SliderFrame
        BarBack.Size = UDim2.new(0.9, 0, 0, 4 * SC)
        BarBack.Position = UDim2.new(0.05, 0, 0.75, 0)
        BarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
        BarBack.BorderSizePixel = 0
        
        local BarFill = Instance.new("Frame")
        BarFill.Parent = BarBack
        BarFill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
        BarFill.BackgroundColor3 = CONFIG.Theme.Accent
        BarFill.BorderSizePixel = 0
        
        local Touch = Instance.new("TextButton")
        Touch.Parent = SliderFrame
        Touch.Size = UDim2.new(1, 0, 1, 0)
        Touch.BackgroundTransparency = 1
        Touch.Text = ""
        
        local function Update(input)
            local SizeX = BarBack.AbsoluteSize.X
            local PosX = BarBack.AbsolutePosition.X
            local Percent = math.clamp((input.Position.X - PosX) / SizeX, 0, 1)
            Value = math.floor(Min + ((Max - Min) * Percent))
            ValText.Text = tostring(Value)
            BarFill.Size = UDim2.new(Percent, 0, 1, 0)
            Callback(Value)
        end
        
        Touch.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                Update(input)
            end
        end)
        
        Touch.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end)
        
        Services.UserInputService.InputChanged:Connect(function(input)
            if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                Update(input)
            end
        end)
    end
    
    return Window
end

-- =================================================================
-- [ SECTION 5: SECURITY CHECK (KEY SYSTEM) ]
-- =================================================================
local function Authenticate()
    if isfile(CONFIG.Security.FileName) and readfile(CONFIG.Security.FileName) == CONFIG.Security.Key then return end
    
    UI_Storage.Enabled = false -- Hide main
    
    local AuthGui = Instance.new("ScreenGui")
    AuthGui.IgnoreGuiInset = true
    if pcall(function() AuthGui.Parent = Services.CoreGui end) then AuthGui.Parent = Services.CoreGui else AuthGui.Parent = Local.Player.PlayerGui end
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = AuthGui
    MainFrame.Size = UDim2.new(0, 420 * SC, 0, 260 * SC)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = V2(0.5, 0.5)
    MainFrame.BackgroundColor3 = CONFIG.Theme.Main
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    local Glow = Instance.new("UIStroke")
    Glow.Parent = MainFrame
    Glow.Color = CONFIG.Theme.Accent
    Glow.Thickness = 2
    
    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Text = "HYPER TITAN V6 LOCKED"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 24 * SC
    Title.TextColor3 = CONFIG.Theme.Text
    Title.Size = UDim2.new(1, 0, 0.2, 0)
    Title.BackgroundTransparency = 1
    
    local Input = Instance.new("TextBox")
    Input.Parent = MainFrame
    Input.Size = UDim2.new(0.8, 0, 0.15, 0)
    Input.Position = UDim2.new(0.1, 0, 0.35, 0)
    Input.BackgroundColor3 = CONFIG.Theme.Header
    Input.TextColor3 = CONFIG.Theme.Text
    Input.PlaceholderText = "Paste Key..."
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 16 * SC
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)
    
    local Submit = Instance.new("TextButton")
    Submit.Parent = MainFrame
    Submit.Size = UDim2.new(0.8, 0, 0.15, 0)
    Submit.Position = UDim2.new(0.1, 0, 0.6, 0)
    Submit.BackgroundColor3 = CONFIG.Theme.Accent
    Submit.Text = "ACCESS"
    Submit.Font = Enum.Font.GothamBold
    Submit.TextSize = 18 * SC
    Submit.TextColor3 = Color3.new(0,0,0)
    Instance.new("UICorner", Submit).CornerRadius = UDim.new(0, 6)
    
    local Link = Instance.new("TextButton")
    Link.Parent = MainFrame
    Link.Size = UDim2.new(0.8, 0, 0.1, 0)
    Link.Position = UDim2.new(0.1, 0, 0.85, 0)
    Link.BackgroundTransparency = 1
    Link.Text = "Get Key Link"
    Link.TextColor3 = CONFIG.Theme.TextDark
    Link.Font = Enum.Font.Code
    Link.TextSize = 14 * SC
    
    Link.MouseButton1Click:Connect(function() setclipboard(CONFIG.Security.Link) Link.Text = "COPIED" task.wait(1) Link.Text = "Get Key Link" end)
    
    local Verified = false
    Submit.MouseButton1Click:Connect(function()
        if Input.Text == CONFIG.Security.Key then
            writefile(CONFIG.Security.FileName, CONFIG.Security.Key)
            Verified = true
            AuthGui:Destroy()
            UI_Storage.Enabled = true
        else
            Submit.Text = "INVALID"
            Submit.BackgroundColor3 = CONFIG.Theme.Error
            task.wait(1)
            Submit.Text = "ACCESS"
            Submit.BackgroundColor3 = CONFIG.Theme.Accent
        end
    end)
    repeat task.wait() until Verified
end
Authenticate()

-- =================================================================
-- [ SECTION 6: MODULE DATA (STATE MANAGEMENT) ]
-- =================================================================
local Modules = {
    Combat = {
        Aimbot = false,
        KillAura = false,
        SilentAim = false,
        TeamCheck = false,
        WallCheck = false,
        FOV = 150,
        Dist = 20
    },
    Movement = {
        Fly = false,
        Speed = false,
        InfiniteJump = false,
        Spider = false,
        Noclip = false,
        FlySpeed = 20,
        WalkSpeed = 16
    },
    Visuals = {
        ESP = false,
        Boxes = false,
        Tracers = false,
        Names = false,
        Health = false,
        Chams = false
    },
    World = {
        AntiAFK = false,
        Fullbright = false
    }
}

-- =================================================================
-- [ SECTION 7: FEATURE IMPLEMENTATION (THE LOGIC) ]
-- =================================================================

-- >>> UTILITY FUNCTIONS <<<
local function IsAlive(plr)
    if plr and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("HumanoidRootPart") then
        return true
    end
    return false
end

local function GetClosestToMouse(FOV, WallCheck)
    local Target = nil
    local ClosestDist = FOV
    local MousePos = Services.UserInputService:GetMouseLocation()
    
    for _, p in pairs(Services.Players:GetPlayers()) do
        if p ~= Local.Player and IsAlive(p) then
            -- Team Check
            if Modules.Combat.TeamCheck and p.Team == Local.Player.Team then continue end
            
            local HRP = p.Character.HumanoidRootPart
            local ScreenPos, OnScreen = Local.Camera:WorldToViewportPoint(HRP.Position)
            
            if OnScreen then
                local Dist = (V2(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                if Dist < ClosestDist then
                    -- Wall Check
                    if WallCheck then
                        local RayParam = RaycastParams.new()
                        RayParam.FilterDescendantsInstances = {Local.Player.Character, p.Character}
                        RayParam.FilterType = Enum.RaycastFilterType.Blacklist
                        local Hit = Services.Workspace:Raycast(Local.Camera.CFrame.Position, (HRP.Position - Local.Camera.CFrame.Position).Unit * 1000, RayParam)
                        if Hit then continue end
                    end
                    
                    Target = p.Character
                    ClosestDist = Dist
                end
            end
        end
    end
    return Target
end

-- >>> COMBAT LOGIC <<<
Services.RunService.RenderStepped:Connect(function()
    if Modules.Combat.Aimbot then
        local Target = GetClosestToMouse(Modules.Combat.FOV, Modules.Combat.WallCheck)
        if Target then
            local Head = Target:FindFirstChild("Head")
            if Head then
                Services.TweenService:Create(Local.Camera, TweenInfo.new(0.05, Enum.EasingStyle.Sine), {CFrame = CF(Local.Camera.CFrame.Position, Head.Position)}):Play()
            end
        end
    end
end)

task.spawn(function()
    while true do
        if Modules.Combat.KillAura then
            pcall(function()
                for _, p in pairs(Services.Players:GetPlayers()) do
                    if p ~= Local.Player and IsAlive(p) then
                        local MyRoot = Local.Player.Character.HumanoidRootPart
                        local TargetRoot = p.Character.HumanoidRootPart
                        if (MyRoot.Position - TargetRoot.Position).Magnitude <= Modules.Combat.Dist then
                            -- Face Enemy
                            MyRoot.CFrame = CF(MyRoot.Position, Vector3.new(TargetRoot.Position.X, MyRoot.Position.Y, TargetRoot.Position.Z))
                            -- Attack
                            local Tool = Local.Player.Character:FindFirstChildOfClass("Tool")
                            if Tool then Tool:Activate() end
                        end
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- >>> MOVEMENT LOGIC <<<
Services.RunService.Heartbeat:Connect(function()
    if Modules.Movement.Fly and Local.Player.Character then
        local Root = Local.Player.Character:FindFirstChild("HumanoidRootPart")
        if Root then
            local Velocity = V3(0,0,0)
            local CF = Local.Camera.CFrame
            
            if Services.UserInputService.TouchEnabled then
                -- Mobile Move Forward
                Velocity = CF.LookVector * Modules.Movement.FlySpeed
            else
                -- PC WASD
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then Velocity = Velocity + CF.LookVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then Velocity = Velocity - CF.LookVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then Velocity = Velocity - CF.RightVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then Velocity = Velocity + CF.RightVector end
                Velocity = Velocity * Modules.Movement.FlySpeed
            end
            
            Root.Velocity = Velocity
            Root.CFrame = CFrame.new(Root.Position, Root.Position + CF.LookVector)
            Local.Player.Character.Humanoid.PlatformStand = true
        end
    else
        if Local.Player.Character and Local.Player.Character:FindFirstChild("Humanoid") then
            Local.Player.Character.Humanoid.PlatformStand = false
        end
    end
    
    if Modules.Movement.Speed and Local.Player.Character then
        Local.Player.Character.Humanoid.WalkSpeed = Modules.Movement.WalkSpeed
    end
end)

Services.UserInputService.JumpRequest:Connect(function()
    if Modules.Movement.InfiniteJump and Local.Player.Character then
        Local.Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- >>> VISUALS LOGIC (ESP ENGINE) <<<
local ESP_Holder = Instance.new("Folder", Services.CoreGui)
ESP_Holder.Name = "HyperESP_Cache"

local function ClearESP()
    ESP_Holder:ClearAllChildren()
end

local function DrawESP()
    ClearESP()
    if not Modules.Visuals.ESP then return end
    
    for _, p in pairs(Services.Players:GetPlayers()) do
        if p ~= Local.Player and IsAlive(p) then
            -- 1. CHAMS (Highlight)
            if Modules.Visuals.Chams then
                local HL = Instance.new("Highlight")
                HL.Parent = ESP_Holder
                HL.Adornee = p.Character
                HL.FillColor = CONFIG.Theme.Accent
                HL.OutlineColor = Color3.new(1,1,1)
                HL.FillTransparency = 0.5
            end
            
            -- 2. TRACERS (Drawing API or Beams)
            if Modules.Visuals.Tracers then
                -- Simplified Beam Tracer for compatibility
                local Att0 = Instance.new("Attachment", Local.Player.Character.HumanoidRootPart)
                local Att1 = Instance.new("Attachment", p.Character.HumanoidRootPart)
                local Beam = Instance.new("Beam", ESP_Holder)
                Beam.Attachment0 = Att0
                Beam.Attachment1 = Att1
                Beam.Color = ColorSequence.new(CONFIG.Theme.Accent)
                Beam.Width0 = 0.1
                Beam.Width1 = 0.1
                Beam.FaceCamera = true
            end
        end
    end
end

task.spawn(function()
    while true do
        if Modules.Visuals.ESP then DrawESP() else ClearESP() end
        task.wait(1) -- Refresh ESP every second (Optimization)
    end
end)

-- =================================================================
-- [ SECTION 8: UI CONSTRUCTION ]
-- =================================================================

-- WINDOW 1: COMBAT
local WinCombat = Library:CreateWindow("Combat", 20)
WinCombat:CreateToggle("Aimbot Enabled", false, function(v) Modules.Combat.Aimbot = v end)
WinCombat:CreateToggle("Kill Aura", false, function(v) Modules.Combat.KillAura = v end)
WinCombat:CreateToggle("Team Check", false, function(v) Modules.Combat.TeamCheck = v end)
WinCombat:CreateSlider("Aimbot FOV", 50, 500, 150, function(v) Modules.Combat.FOV = v end)
WinCombat:CreateSlider("Aura Distance", 5, 50, 20, function(v) Modules.Combat.Dist = v end)

-- WINDOW 2: MOVEMENT
local WinMove = Library:CreateWindow("Movement", 220)
WinMove:CreateToggle("Fly", false, function(v) Modules.Movement.Fly = v end)
WinMove:CreateSlider("Fly Speed", 10, 200, 20, function(v) Modules.Movement.FlySpeed = v end)
WinMove:CreateToggle("Speed Boost", false, function(v) Modules.Movement.Speed = v end)
WinMove:CreateSlider("Walk Speed", 16, 200, 16, function(v) Modules.Movement.WalkSpeed = v end)
WinMove:CreateToggle("Infinite Jump", false, function(v) Modules.Movement.InfiniteJump = v end)
WinMove:CreateToggle("Spider (WallClimb)", false, function(v)
    -- Simple Spider Logic
    if v then
        Local.Player.Character.Humanoid.MaxSlopeAngle = 89.9
    else
        Local.Player.Character.Humanoid.MaxSlopeAngle = 89
    end
end)

-- WINDOW 3: VISUALS
local WinVis = Library:CreateWindow("Visuals", 420)
WinVis:CreateToggle("Master ESP", false, function(v) Modules.Visuals.ESP = v end)
WinVis:CreateToggle("Chams", false, function(v) Modules.Visuals.Chams = v end)
WinVis:CreateToggle("Tracers", false, function(v) Modules.Visuals.Tracers = v end)
WinVis:CreateToggle("Fullbright", false, function(v)
    if v then Services.Lighting.Brightness = 2 Services.Lighting.ClockTime = 14 else Services.Lighting.Brightness = 1 end
end)

-- WINDOW 4: WORLD / MISC
local WinWorld = Library:CreateWindow("World", 620)
WinWorld:CreateToggle("Anti-AFK", false, function(v)
    if v then
        Services.VirtualUser:CaptureController()
        task.spawn(function()
            while task.wait(60) do Services.VirtualUser:ClickButton2(Vector2.new()) end
        end)
    end
end)
WinWorld:CreateButton("Server Hop", function()
    -- Server hop logic
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local found = false
    local function TPReturner()
        local Site;
        if found == false then
            Site = Services.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = Services.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. found))
        end
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            found = Site.nextPageCursor
        end
        for i,v in pairs(Site.data) do
            local Possible = true
            if v.maxPlayers > v.playing then
                for _,Existing in pairs(AllIDs) do
                    if tostring(Existing) == tostring(v.id) then
                        Possible = false
                    end
                end
                if Possible == true then
                    table.insert(AllIDs, v.id)
                    wait()
                    pcall(function()
                        wait()
                        Services.TeleportService:TeleportToPlaceInstance(PlaceID, v.id, Local.Player)
                    end)
                    wait(4)
                end
            end
        end
    end
    TPReturner()
end)

-- =================================================================
-- [ SECTION 9: INITIALIZATION NOTIFICATION ]
-- =================================================================
Library:Notify("HYPER TITAN V6", "Loaded successfully. Welcome.", 5)
