local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function UILibrary:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 500, 0, 350)
    Frame.Position = UDim2.new(0.5, -250, 0.5, -175)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 120, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Frame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -120, 1, -30)
    ContentContainer.Position = UDim2.new(0, 120, 0, 30)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Frame

    local tabs = {}
    local currentTab = nil

    local function Drag()
        local dragging = false
        local dragInput, dragStart, startPos

        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Frame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                Frame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end
    Drag()

    local Window = {}
    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 16
        TabButton.Font = Enum.Font.SourceSans
        TabButton.Parent = TabContainer

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabContent

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.Parent = TabContent

        local tab = {
            Button = TabButton,
            Content = TabContent,
            Elements = {}
        }

        TabButton.MouseButton1Click:Connect(function()
            if currentTab ~= tab then
                if currentTab then
                    currentTab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    currentTab.Content.Visible = false
                end
                tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                tab.Content.Visible = true
                currentTab = tab
            end
        end)

        table.insert(tabs, tab)
        return tab
    end

    function Window:SelectTab(index)
        if tabs[index] then
            tabs[index].Button:FindFirstChildWhichIsA("TextButton"):MouseButton1Click()
        end
    end

    function Window:Button(tab, text, callback)
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Parent = tab.Content

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        Button.TextSize = 16
        Button.Font = Enum.Font.SourceSans
        Button.Parent = ButtonFrame
        Button.AutoButtonColor = false

        Button.MouseButton1Click:Connect(function()
            callback()
        end)
    end

    function Window:Toggle(tab, text, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = tab.Content

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.8, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 16
        Label.Font = Enum.Font.SourceSans
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        local Toggle = Instance.new("Frame")
        Toggle.Size = UDim2.new(0, 40, 0, 20)
        Toggle.Position = UDim2.new(1, -50, 0.5, -10)
        Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Toggle.BorderSizePixel = 0
        Toggle.Parent = ToggleFrame

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 20, 0, 20)
        Circle.Position = default and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)
        Circle.BackgroundColor3 = default and Color3.fromRGB(60, 120, 60) or Color3.fromRGB(100, 100, 100)
        Circle.BorderSizePixel = 0
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = Circle
        Circle.Parent = Toggle

        local state = default
        ToggleFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                TweenService:Create(Circle, TweenInfo.new(0.2), {
                    Position = state and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = state and Color3.fromRGB(60, 120, 60) or Color3.fromRGB(100, 100, 100)
                }):Play()
                callback(state)
            end
        end)
    end

    function Window:Slider(tab, config)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 60)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = tab.Content

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 0, 20)
        Label.Position = UDim2.new(0, 10, 0, 5)
        Label.BackgroundTransparency = 1
        Label.Text = config.Title
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 16
        Label.Font = Enum.Font.SourceSans
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame

        local Desc = Instance.new("TextLabel")
        Desc.Size = UDim2.new(1, -60, 0, 15)
        Desc.Position = UDim2.new(0, 10, 0, 25)
        Desc.BackgroundTransparency = 1
        Desc.Text = config.Description or ""
        Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
        Desc.TextSize = 12
        Desc.Font = Enum.Font.SourceSans
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        Desc.Parent = SliderFrame

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 50, 0, 20)
        ValueLabel.Position = UDim2.new(1, -60, 0, 5)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(config.Default)
        ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        ValueLabel.TextSize = 16
        ValueLabel.Font = Enum.Font.SourceSans
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame

        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(1, -20, 0, 10)
        SliderBar.Position = UDim2.new(0, 10, 0, 45)
        SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SliderBar.BorderSizePixel = 0
        SliderBar.Parent = SliderFrame

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
        Fill.BorderSizePixel = 0
        Fill.Parent = SliderBar

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 14, 0, 14)
        Knob.Position = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), -7, 0, -2)
        Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        Knob.BorderSizePixel = 0
        Knob.Parent = SliderBar

        local dragging = false
        local onChanged = config.OnChanged or function() end

        local function updateValue(value)
            value = math.clamp(value, config.Min, config.Max)
            if config.Rounding then
                value = math.round(value * 10^config.Rounding) / 10^config.Rounding
            end
            local relative = (value - config.Min) / (config.Max - config.Min)
            Fill.Size = UDim2.new(relative, 0, 1, 0)
            Knob.Position = UDim2.new(relative, -7, 0, -2)
            ValueLabel.Text = tostring(value)
            config.Callback(value)
            onChanged(value)
        end

        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)

        SliderBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local mouseX = input.Position.X
                local sliderX = SliderBar.AbsolutePosition.X
                local sliderWidth = SliderBar.AbsoluteSize.X
                local relative = math.clamp((mouseX - sliderX) / sliderWidth, 0, 1)
                local value = config.Min + (config.Max - config.Min) * relative
                updateValue(value)
            end
        end)

        local slider = {}
        function slider:SetValue(value)
            updateValue(value)
        end

        return slider
    end

    return Window
end

return UILibrary
