    --[[
    HYPER TITAN: CUSTOM TAB ENGINE
    "The 100% Original Interface"
    
    > No External Libraries (No Rayfield/Orion)
    > Zero Watermarks
    > Custom Tab System
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- =================================================================
-- 1. CONFIG & THEME
-- =================================================================
local Settings = {
    Key = "FREE_e7cc843f9dc7f5018d4effe177204c7e",
    Link = "https://link-target.net/1448934/woiFzcBpdM12",
    Theme = {
        Background = Color3.fromRGB(20, 20, 20),
        Sidebar = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 255, 140), -- Hyper Green
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 150),
        Item = Color3.fromRGB(35, 35, 35)
    }
}

-- =================================================================
-- 2. CUSTOM UI ENGINE (THE "TITAN" LIBRARY)
-- =================================================================
local Library = {}
local UI = Instance.new("ScreenGui")
UI.Name = "HyperTitan_Custom"
UI.IgnoreGuiInset = true
if pcall(function() UI.Parent = CoreGui end) then UI.Parent = CoreGui else UI.Parent = LocalPlayer.PlayerGui end

-- Drag Function
local function MakeDraggable(obj)
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
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(obj, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end

function Library:Init()
    -- Main Window
    local Main = Instance.new("Frame", UI)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BackgroundColor3 = Settings.Theme.Background
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    MakeDraggable(Main)

    -- Sidebar (Left)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = Settings.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)
    
    -- Fix Corner (Make right side flat)
    local Fix = Instance.new("Frame", Sidebar)
    Fix.Size = UDim2.new(0, 10, 1, 0)
    Fix.Position = UDim2.new(1, -10, 0, 0)
    Fix.BackgroundColor3 = Settings.Theme.Sidebar
    Fix.BorderSizePixel = 0

    -- Title
    local Title = Instance.new("TextLabel", Sidebar)
    Title.Text = "HYPER\nTITAN"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 24
    Title.TextColor3 = Settings.Theme.Accent
    Title.Size = UDim2.new(1, 0, 0, 80)
    Title.BackgroundTransparency = 1
    
    -- Container (Right)
    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -150, 1, -20)
    Container.Position = UDim2.new(0, 150, 0, 10)
    Container.BackgroundTransparency = 1

    local TabList = Instance.new("UIListLayout", Sidebar)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    
    -- Padding for Title
    local Pad = Instance.new("UIPadding", Sidebar)
    Pad.PaddingTop = UDim.new(0, 80)

    local Tabs = {}
    local FirstTab = true

    function Library:CreateTab(Name)
        -- Tab Button
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.BackgroundColor3 = Settings.Theme.Background
        TabBtn.Text = Name
        TabBtn.TextColor3 = Settings.Theme.TextDark
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 14
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        -- Page Frame
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        
        -- Switch Logic
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                t.Btn.BackgroundColor3 = Settings.Theme.Background
                t.Btn.TextColor3 = Settings.Theme.TextDark
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Settings.Theme.Accent
            TabBtn.TextColor3 = Color3.new(0,0,0)
        end)

        if FirstTab then
            Page.Visible = true
            TabBtn.BackgroundColor3 = Settings.Theme.Accent
            TabBtn.TextColor3 = Color3.new(0,0,0)
            FirstTab = false
        end

        table.insert(Tabs, {Page = Page, Btn = TabBtn})
        
        local Elements = {}
        
        function Elements:CreateToggle(Text, Default, Callback)
            local Toggled = Default or false
            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(1, -10, 0, 40)
            Frame.BackgroundColor3 = Settings.Theme.Item
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Settings.Theme.Text
            Label.Font = Enum.Font.GothamSemiBold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Btn = Instance.new("TextButton", Frame)
            Btn.Size = UDim2.new(0, 40, 0, 20)
            Btn.Position = UDim2.new(1, -50, 0.5, -10)
            Btn.BackgroundColor3 = Toggled and Settings.Theme.Accent or Color3.fromRGB(60,60,60)
            Btn.Text = ""
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
            
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Settings.Theme.Accent or Color3.fromRGB(60,60,60)}):Play()
                Callback(Toggled)
            end)
            if Default then Callback(true) end
        end
        
        function Elements:CreateSlider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(1, -10, 0, 50)
            Frame.BackgroundColor3 = Settings.Theme.Item
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel", Frame)
            Label.Text = Text
            Label.Size = UDim2.new(1, -15, 0, 25)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Settings.Theme.Text
            Label.Font = Enum.Font.GothamSemiBold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local ValLbl = Instance.new("TextLabel", Frame)
            ValLbl.Text = tostring(Value)
            ValLbl.Size = UDim2.new(1, -15, 0, 25)
            ValLbl.BackgroundTransparency = 1
            ValLbl.TextColor3 = Settings.Theme.TextDark
            ValLbl.Font = Enum.Font.Code
            ValLbl.TextSize = 13
            ValLbl.TextXAlignment = Enum.TextXAlignment.Right
            
            local BarBG = Instance.new("Frame", Frame)
            BarBG.Size = UDim2.new(0.9, 0, 0, 4)
            BarBG.Position = UDim2.new(0.05, 0, 0.75, 0)
            BarBG.BackgroundColor3 = Color3.fromRGB(60,60,60)
            
            local BarFill = Instance.new("Frame", BarBG)
            BarFill.Size = UDim2.new((Value-Min)/(Max-Min), 0, 1, 0)
            BarFill.BackgroundColor3 = Settings.Theme.Accent
            
            local Trigger = Instance.new("TextButton", Frame)
            Trigger.Size = UDim2.new(1,0,1,0); Trigger.BackgroundTransparency = 1; Trigger.Text = ""
            
            local Dragging = false
            local function Update(i)
                local P = math.clamp((i.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                Value = math.floor(Min + ((Max-Min)*P))
                ValLbl.Text = tostring(Value)
                BarFill.Size = UDim2.new(P, 0, 1, 0)
                Callback(Value)
            end
            Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true; Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end)
        end
        
        function Elements:CreateButton(Text, Callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.BackgroundColor3 = Settings.Theme.Item
            Btn.Text = Text
            Btn.TextColor3 = Settings.Theme.Text
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Settings.Theme.Item}):Play()
                Callback()
            end)
        end

        return Elements
    end
    return Library
end

-- =================================================================
-- 3. SETUP & FEATURES
-- =================================================================
Library:Init()

local Combat = Library:CreateTab("Combat")
local Visuals = Library:CreateTab("Visuals")
local Move = Library:CreateTab("Movement")
local Scripts = Library:CreateTab("Scripts")

-- [ COMBAT ]
Combat:CreateToggle("Aimbot", false, function(v)
    getgenv().Aimbot = v
    RunService.RenderStepped:Connect(function()
        if getgenv().Aimbot then
            local Mouse = UserInputService:GetMouseLocation()
            local Closest, Dist = nil, 150
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local Pos, Vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if Vis then
                        local Mag = (Vector2.new(Pos.X, Pos.Y) - Mouse).Magnitude
                        if Mag < Dist then Closest = p.Character.Head; Dist = Mag end
                    end
                end
            end
            if Closest then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Closest.Position), 0.5) end
        end
    end)
end)

Combat:CreateToggle("Kill Aura", false, function(v)
    getgenv().Aura = v
    task.spawn(function()
        while getgenv().Aura do
            pcall(function()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 20 then
                            LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- [ VISUALS ]
Visuals:CreateToggle("ESP (Chams)", false, function(v)
    getgenv().ESP = v
    if v then
        task.spawn(function()
            while getgenv().ESP do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("ESP") then
                        local h = Instance.new("Highlight", p.Character)
                        h.Name = "ESP"
                        h.FillColor = Settings.Theme.Accent
                        h.OutlineColor = Color3.new(1,1,1)
                    end
                end
                task.wait(1)
            end
        end)
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESP") then p.Character.ESP:Destroy() end
        end
    end
end)

-- [ MOVEMENT ]
Move:CreateSlider("Speed", 16, 200, 16, function(v)
    if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v end
end)

Move:CreateToggle("Fly", false, function(v)
    getgenv().Fly = v
    if v then
        local Root = LocalPlayer.Character.HumanoidRootPart
        local BV = Instance.new("BodyVelocity", Root)
        BV.MaxForce = Vector3.new(1e9,1e9,1e9)
        while getgenv().Fly do
            BV.Velocity = Camera.CFrame.LookVector * 50
            RunService.RenderStepped:Wait()
        end
        BV:Destroy()
    end
end)

-- [ SCRIPTS ]
Scripts:CreateButton("Infinite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
Scripts:CreateButton("Dark Dex V4", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))() end)

-- Success
game.StarterGui:SetCore("SendNotification", {Title="Hyper Titan", Text="Custom Engine Loaded", Duration=5})
