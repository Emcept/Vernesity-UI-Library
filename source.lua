-- // Vernesity UI Library // -- 
-- // Made by Emmy#4846 // --

local Vernesity = {}

Vernesity.Themes = {
	DarkTheme = {
		TextColor = Color3.fromRGB(235, 235, 235),
		WindowColor = Color3.fromRGB(44, 47, 49),
		TabColor = Color3.fromRGB(49, 51, 54),
		ElementColor = Color3.fromRGB(59, 62, 64),
		SecondaryElementColor = Color3.fromRGB(53, 141, 236)
	},
	LightTheme = {
		TextColor = Color3.fromRGB(57, 57, 57),
		WindowColor = Color3.fromRGB(197, 206, 217),
		TabColor = Color3.fromRGB(215, 230, 239),
		ElementColor = Color3.fromRGB(207, 217, 229),
		SecondaryElementColor = Color3.fromRGB(123, 191, 255)
	},
	PurpleTheme = {
		TextColor = Color3.fromRGB(235, 235, 235),
		WindowColor = Color3.fromRGB(42, 27, 49),
		TabColor = Color3.fromRGB(62, 39, 71),
		ElementColor = Color3.fromRGB(87, 55, 100),
		SecondaryElementColor = Color3.fromRGB(185, 104, 236)
	},
	BlueTheme = {
		TextColor = Color3.fromRGB(235, 235, 235),
		WindowColor = Color3.fromRGB(29, 40, 53),
		TabColor = Color3.fromRGB(41, 57, 75),
		ElementColor = Color3.fromRGB(46, 73, 102),
		SecondaryElementColor = Color3.fromRGB(103, 160, 236)
	},
	GreenTheme = {
		TextColor = Color3.fromRGB(235, 235, 235),
		WindowColor = Color3.fromRGB(27, 49, 40),
		TabColor = Color3.fromRGB(40, 71, 56),
		ElementColor = Color3.fromRGB(55, 100, 70),
		SecondaryElementColor = Color3.fromRGB(106, 236, 177)
	},
	RedTheme = {
		TextColor = Color3.fromRGB(235, 235, 235),
		WindowColor = Color3.fromRGB(25, 0, 0),
		TabColor = Color3.fromRGB(71, 30, 30),
		ElementColor = Color3.fromRGB(121, 0, 0),
		SecondaryElementColor = Color3.fromRGB(236, 40, 40)
	}
}

local tostr = tostring
local MainOriginalSize = UDim2.new(0, 486, 0, 300)
local shadowTransparency = 1

function Vernesity:AddTheme(ThemeName, THEME)
	if THEME.TextColor and THEME.WindowColor and THEME.TabColor and THEME.ElementColor and THEME.SecondaryElementColor then
		Vernesity.Themes[ThemeName] = THEME
	end
end

function Tween(instance, speed, style, direction, props)
	game:GetService('TweenService'):Create(instance, TweenInfo.new(speed, style, direction), props):Play()
end

function checkDevice()
	if game:GetService('UserInputService').TouchEnabled then
		return 'Mobile'
	else
		return 'PC'
	end
end

function addTypeValue(INSTANCE, val)
	local value = Instance.new('RayValue')
	value.Name = tostr(val)
	value.Parent = INSTANCE
end

function getSizeValue(INSTANCE)
	local a = nil
	for _, value in pairs(INSTANCE:GetChildren()) do
		if value.ClassName == 'StringValue' then
			a = tostr(value.Value)
			return a
		end
	end
	if a == nil then
		return nil
	end
end

local conns = {}
local module = {}
local dragging = false
local UIParent = game.Players.LocalPlayer.PlayerGui
local idklol = Instance.new('ScreenGui')
pcall(function()
	idklol.Parent = game.CoreGui
end)
if idklol.Parent == game.CoreGui then
	UIParent = game.CoreGui
end
idklol:Destroy()

function Vernesity:MakeDraggable(obj, Dragger, smoothness)
	local UIS = game:GetService('UserInputService')
	smoothness = smoothness or 0
	local dragInput, dragStart
	local startPos = obj.Position 
	local dragger = Dragger or obj	
	local function updateInput(input)
		local offset = input.Position - dragStart
		local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + offset.X, startPos.Y.Scale, startPos.Y.Offset + offset.Y)
		game:GetService('TweenService'):Create(obj, TweenInfo.new(smoothness), {Position = Position}):Play()
	end
	conns[obj] = conns[obj] or {}
	if conns[obj].db then
		conns[obj].db:Disconnect()
		conns[obj].db = nil
	end
	conns[obj].db =	dragger.InputBegan:Connect(function(input)
		if dragging and module.dragged ~= obj then return end
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not UIS:GetFocusedTextBox() then
			dragging = true
			dragStart = input.Position
			startPos = obj.Position
			module.dragged = obj
			if conns[obj].ic then
				conns[obj].ic:Disconnect()
				conns[obj].ic = nil
			end
			conns[obj].ic = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false	
					conns[obj].ic:Disconnect()
					conns[obj].ic = nil
				end
			end)
		end
	end)
	if conns[obj].dc then
		conns[obj].dc:Disconnect()
		conns[obj].dc = nil
	end
	conns[obj].dc =	dragger.InputChanged:Connect(function(input)
		if module.dragged ~= obj then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	if conns[obj].uc then
		conns[obj].uc:Disconnect()
		conns[obj].uc = nil
	end
	conns[obj].uc =	UIS.InputChanged:Connect(function(input)
		if module.dragged ~= obj then return end
		if input == dragInput and dragging then
			updateInput(input)
		end
	end)
end

function Vernesity:Window(title1, title2, Theme)
	local DragNumber = 0
	local theme = Theme or Vernesity.Themes.DarkTheme
	local selectedTab = nil
	local allTabs = {}
	local Windows = {}
	table.insert(Windows, title1)
	local onclose, onminimize = function() end, function() end
	function Windows:OnClose(func)
		onclose = func
	end
	function Windows:OnMinimize(func)
		onminimize = func
	end
	local function SetTheme(newtheme)
		local ThemeTable = nil
		if type(newtheme) == 'string' then
			if Vernesity.Themes[newtheme] then
				ThemeTable = Vernesity.Themes[newtheme]
			end
		elseif type(newtheme) == 'table' then
			if newtheme.TextColor and newtheme.TabColor and newtheme.WindowColor and newtheme.ElementColor and newtheme.SecondaryElementColor then
				ThemeTable = newtheme
			end
		end
		if ThemeTable == nil then
			warn('Invalid theme, automatically changed the theme to DarkTheme.')
			ThemeTable = Vernesity.Themes.DarkTheme
		end
		return ThemeTable
	end
	theme = SetTheme(theme)
	function Windows:GetTheme()
		return theme
	end
	local function enableRippleEffect(v, m)
		local g = m or v
		v.MouseButton1Click:Connect(function()
			local ms = game.Players.LocalPlayer:GetMouse()
			local Circle = Instance.new('ImageLabel')
			Circle.Name = 'Circle'
			Circle.Parent = g
			Circle.BackgroundColor3 = theme.TextColor
			Circle.ImageColor3 = theme.TextColor
			Circle.BackgroundTransparency = 1
			Circle.BorderSizePixel = 0
			Circle.Image = 'http://www.roblox.com/asset/?id=4560909609'
			Circle.ImageTransparency = 0.600
			Circle.ImageTransparency = .7
			g.ClipsDescendants = true
			local len, size = 1, nil
			local c = Circle
			local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
			c.Position = UDim2.new(0, x, 0, y)
			if g.AbsoluteSize.X >= g.AbsoluteSize.Y then
				size = (g.AbsoluteSize.X * 1.5)
			else
				size = (g.AbsoluteSize.Y * 1.5)
			end
			c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
			for i = 1, 20 do
				c.ImageTransparency = c.ImageTransparency + 0.05
				wait(len / 12)
			end
			c:Destroy()
		end)
	end
	local WindowTemplate = Instance.new('ScreenGui')
	WindowTemplate.Name = tostr(title1)
	WindowTemplate.ResetOnSpawn = false
	WindowTemplate.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	addTypeValue(WindowTemplate, 'Window')
	WindowTemplate.DescendantAdded:Connect(function(c)
		if c.ClassName == 'UIListLayout' then
			if c.Parent.ClassName == 'ScrollingFrame' then
				c:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
					c.Parent.CanvasSize = UDim2.new(0, c.AbsoluteContentSize.X, 0, c.AbsoluteContentSize.Y)
				end)
			end
		end
	end)
	local UI = Instance.new('Frame')
	UI.Name = 'UI'
	UI.ZIndex = 0
	UI.Size = UDim2.new(0, 512, 0, 325)
	UI.BackgroundTransparency = 1
	UI.Position = UDim2.new(0.296, 0, 0.255, 0)
	UI.BackgroundColor3 = theme.WindowColor
	UI.Parent = WindowTemplate
	local DropShadow = Instance.new('ImageLabel')
	DropShadow.Name = 'DropShadow'
	DropShadow.ZIndex = 0
	DropShadow.Size = UDim2.new(0, 512, 0, 325)
	DropShadow.BackgroundTransparency = 1
	DropShadow.ImageTransparency = shadowTransparency
	DropShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DropShadow.ImageColor3 = theme.SecondaryElementColor
	DropShadow.Image = 'http://www.roblox.com/asset/?id=11505440242'
	DropShadow.Parent = UI
	local Main = Instance.new('Frame')
	Main.ClipsDescendants = true
	Main.Name = 'Main'
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Size = UDim2.new(0, 486, 0, 300)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.BackgroundColor3 = theme.WindowColor
	Main.Parent = DropShadow
	local function setElementSizeXY(size)
		local xS, xO, yS, yO = Main.Size.X.Scale - (MainOriginalSize.X.Scale - size.X.Scale), Main.Size.X.Offset - (MainOriginalSize.X.Offset - size.X.Offset), Main.Size.Y.Scale - (MainOriginalSize.Y.Scale - size.Y.Scale), Main.Size.Y.Offset - (MainOriginalSize.Y.Offset - size.Y.Offset)
		return UDim2.new(xS, xO, yS, yO)
	end
	local function setElementSizeX(size)
		local xS, xO, yS, yO = Main.Size.X.Scale - (MainOriginalSize.X.Scale - size.X.Scale), Main.Size.X.Offset - (MainOriginalSize.X.Offset - size.X.Offset), size.Y.Scale, size.Y.Offset
		return UDim2.new(xS, xO, yS, yO)
	end
	local function setElementSizeY(size)
		local xS, xO, yS, yO = size.X.Scale, size.X.Offset, Main.Size.Y.Scale - (MainOriginalSize.Y.Scale - size.Y.Scale), Main.Size.Y.Offset - (MainOriginalSize.Y.Offset - size.Y.Offset)
		return UDim2.new(xS, xO, yS, yO)
	end
	local UICorner = Instance.new('UICorner')
	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = Main
	local Tabs = Instance.new('Folder')
	Tabs.Name = 'Tabs'
	Tabs.Parent = Main
	local LeftSide = Instance.new('Frame')
	LeftSide.Name = 'LeftSide'
	LeftSide.Size = setElementSizeY(UDim2.new(0, 146, 0, 300))
	LeftSide.BorderColor3 = Color3.fromRGB(27, 42, 53)
	LeftSide.BorderSizePixel = 0
	LeftSide.BackgroundColor3 = theme.WindowColor
	LeftSide.BackgroundTransparency = 1
	LeftSide.ZIndex = 2
	LeftSide.Parent = Main
	local UICorner = Instance.new('UICorner')
	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = LeftSide
	local Title = Instance.new('TextLabel')
	Title.Name = 'Title'
	Title.Size = UDim2.new(0, 150, 0, 36)
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 13, 0, 0)
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.FontSize = Enum.FontSize.Size18
	Title.TextTransparency = 0
	Title.TextSize = 15
	Title.TextColor3 = theme.TextColor
	Title.Text = tostr(title1)
	Title.Font = Enum.Font.GothamMedium
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = LeftSide
	local Title2 = Instance.new('TextLabel')
	Title2.Name = 'Title2'
	Title2.Size = UDim2.new(0, 150, 0, 40)
	Title2.BackgroundTransparency = 1
	Title2.Position = UDim2.new(0, 13, 0, 20)
	Title2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title2.FontSize = Enum.FontSize.Size14
	Title2.TextTransparency = 0.3
	Title2.TextSize = 13
	Title2.TextColor3 = theme.TextColor
	Title2.Text = tostr(title2)
	Title2.Font = Enum.Font.Gotham
	Title2.TextXAlignment = Enum.TextXAlignment.Left
	Title2.Parent = LeftSide
	local idk = Instance.new('Frame')
	idk.Name = 'idk'
	idk.Size = UDim2.new(0, 126, 0, 2)
	idk.Position = UDim2.new(0, 13, 0, 57)
	idk.BackgroundColor3 = theme.SecondaryElementColor
	idk.Parent = LeftSide
	idk.BorderSizePixel = 0
	local UICorner1 = Instance.new('UICorner')
	UICorner1.CornerRadius = UDim.new(0, 69)
	UICorner1.Parent = idk
	local UIGradient = Instance.new('UIGradient')
	UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.25), NumberSequenceKeypoint.new(0.5, 0.25), NumberSequenceKeypoint.new(1, 1)})
	UIGradient.Parent = idk
	local Menu = Instance.new('ScrollingFrame')
	Menu.Name = 'Menu'
	Menu.Size = setElementSizeY(UDim2.new(0, 147, 0, 227))
	Menu.BackgroundTransparency = 1
	Menu.Position = UDim2.new(0, 0, 0.223, 0)
	Menu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Menu.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	Menu.ScrollBarImageTransparency = 1
	Menu.ScrollBarThickness = 0
	Menu.Parent = LeftSide
	Menu.CanvasSize = UDim2.new(0, 0, 0, 0)
	local Value69420 = Instance.new('StringValue')
	Value69420.Value = 'Y'
	Value69420.Parent = Menu
	local UIListLayout = Instance.new('UIListLayout')
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 2)
	UIListLayout.Parent = Menu
	local Topbar = Instance.new('Frame')
	Topbar.Name = 'Topbar'
	Topbar.AnchorPoint = Vector2.new(0.96, 0)
	Topbar.Size = setElementSizeX(UDim2.new(0, 328, 0, 36))
	Topbar.BackgroundTransparency = 1
	Topbar.Position = UDim2.new(0.96, 0, 0, 0)
	Topbar.BorderSizePixel = 0
	Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Topbar.ZIndex = 2
	Topbar.Parent = Main
	local UICorner = Instance.new('UICorner')
	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = Topbar
	local UIListLayout1 = Instance.new('UIListLayout')
	UIListLayout1.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout1.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout1.Padding = UDim.new(0, 10)
	UIListLayout1.Parent = Topbar
	local e_Close = Instance.new('ImageButton')
	e_Close.Name = 'e_Close'
	e_Close.LayoutOrder = 4
	e_Close.ZIndex = 2
	e_Close.AnchorPoint = Vector2.new(0.98, 0.5)
	e_Close.Size = UDim2.new(0, 22, 0, 22)
	e_Close.BackgroundTransparency = 1
	e_Close.Position = UDim2.new(0.98, 0, 0.5, 0)
	e_Close.ImageTransparency = 0.1
	e_Close.ImageRectOffset = Vector2.new(284, 4)
	e_Close.Image = 'rbxassetid://3926305904'
	e_Close.ImageRectSize = Vector2.new(24, 24)
	e_Close.Parent = Topbar
	e_Close.ImageColor3 = theme.TextColor
	local d_Minimize = Instance.new('ImageButton')
	d_Minimize.Name = 'd_Minimize'
	d_Minimize.LayoutOrder = 6
	d_Minimize.ZIndex = 2
	d_Minimize.AnchorPoint = Vector2.new(0.86, 0.5)
	d_Minimize.Size = UDim2.new(0, 22, 0, 22)
	d_Minimize.BackgroundTransparency = 1
	d_Minimize.Position = UDim2.new(0.86, 0, 0.5, 0)
	d_Minimize.ImageTransparency = 0.1
	d_Minimize.ImageRectOffset = Vector2.new(884, 284)
	d_Minimize.Image = 'rbxassetid://3926307971'
	d_Minimize.ImageRectSize = Vector2.new(36, 36)
	d_Minimize.Parent = Topbar
	d_Minimize.ImageColor3 = theme.TextColor
	local c_Search = Instance.new('ImageButton')
	c_Search.Name = 'c_Search'
	c_Search.LayoutOrder = 5
	c_Search.ZIndex = 2
	c_Search.AnchorPoint = Vector2.new(0.75, 0.5)
	c_Search.Size = UDim2.new(0, 22, 0, 22)
	c_Search.BackgroundTransparency = 1
	c_Search.Position = UDim2.new(0.75, 0, 0.5, 0)
	c_Search.ImageTransparency = 0.1
	c_Search.ImageRectOffset = Vector2.new(964, 324)
	c_Search.Image = 'rbxassetid://3926305904'
	c_Search.ImageRectSize = Vector2.new(36, 36)
	c_Search.ImageColor3 = theme.TextColor
	c_Search.Parent = Topbar
	local b_SearchBox = Instance.new('TextBox')
	b_SearchBox.Name = 'b_SearchBox'
	b_SearchBox.AnchorPoint = Vector2.new(0.5, 0.5)
	b_SearchBox.Size = UDim2.new(0, 0, 0, 20)
	b_SearchBox.BorderSizePixel = 0
	b_SearchBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	b_SearchBox.BackgroundColor3 = theme.ElementColor
	b_SearchBox.FontSize = Enum.FontSize.Size14
	b_SearchBox.TextSize = 14
	b_SearchBox.TextColor3 = theme.TextColor
	b_SearchBox.TextTransparency = 0.1
	b_SearchBox.Text = 'Search...'
	b_SearchBox.Font = Enum.Font.Gotham
	b_SearchBox.Parent = Topbar
	b_SearchBox.ClipsDescendants = true
	local UICorner2 = Instance.new('UICorner')
	UICorner2.CornerRadius = UDim.new(0, 5)
	UICorner2.Parent = b_SearchBox
	local UIStroke = Instance.new('UIStroke')
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Transparency = 1
	UIStroke.Color = theme.SecondaryElementColor
	UIStroke.Parent = b_SearchBox
	local Value69 = Instance.new('StringValue')
	Value69.Value = 'X'
	Value69.Parent = Topbar
	local Dragger = Instance.new('Frame')
	Dragger.Name = 'Dragger'
	Dragger.Selectable = true
	Dragger.Size = setElementSizeX(UDim2.new(0, 486, 0, 35))
	Dragger.BorderSizePixel = 0
	Dragger.BackgroundTransparency = 0
	Dragger.Active = true
	Dragger.BackgroundColor3 = theme.WindowColor
	Dragger.Parent = Main
	local UICorner2 = Instance.new('UICorner')
	UICorner2.CornerRadius = UDim.new(0, 5)
	UICorner2.Parent = Dragger
	local Value1 = Instance.new('StringValue')
	Value1.Value = 'X'
	Value1.Parent = Dragger
	local ResizeButton = Instance.new('ImageButton')
	ResizeButton.Name = 'ResizeButton'
	ResizeButton.Selectable = true
	ResizeButton.AnchorPoint = Vector2.new(1, 1)
	ResizeButton.Size = UDim2.new(0, 25, 0, 25)
	ResizeButton.BackgroundTransparency = 1
	ResizeButton.Position = UDim2.new(1, 0, 1, 0)
	ResizeButton.Active = true
	ResizeButton.BackgroundColor3 = theme.SecondaryElementColor
	ResizeButton.ImageTransparency = 1
	ResizeButton.ImageColor3 = theme.SecondaryElementColor
	ResizeButton.Image = 'http://www.roblox.com/asset/?id=11457659804'
	ResizeButton.Parent = Main
	local Value3 = Instance.new('StringValue')
	Value3.Value = 'XY'
	Value3.Parent = DropShadow
	local Value4 = Instance.new('StringValue')
	Value4.Value = 'XY'
	Value4.Parent = UI
	local Notifications = Instance.new('Frame')
	Notifications.Name = 'Notifications'
	Notifications.AnchorPoint = Vector2.new(0.99, 0.97)
	Notifications.Size = UDim2.new(0.153, 0, 0.992, 0)
	Notifications.BackgroundTransparency = 1
	Notifications.Position = UDim2.new(0.99, 0, 0.962, 0)
	Notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Notifications.Parent = WindowTemplate
	local Mobile_Keybinds = Instance.new('Frame')
	Mobile_Keybinds.Name = 'Mobile_Keybinds'
	Mobile_Keybinds.AnchorPoint = Vector2.new(0.99, 0)
	Mobile_Keybinds.Size = UDim2.new(0.694, 0, 0.063, 0)
	Mobile_Keybinds.BackgroundTransparency = 1
	Mobile_Keybinds.Position = UDim2.new(0.99, 0, 0.008, 0)
	Mobile_Keybinds.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Mobile_Keybinds.Parent = WindowTemplate
	local UIListLayout = Instance.new('UIListLayout')
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 15)
	UIListLayout.Parent = Mobile_Keybinds
	local UIListLayout2 = Instance.new('UIListLayout')
	UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout2.Padding = UDim.new(0, 5)
	UIListLayout2.Parent = Notifications
	DropShadow.Size = setElementSizeXY(UDim2.new(0, 512, 0, 325))
	UI.Size = setElementSizeXY(UDim2.new(0, 512, 0, 325))
	WindowTemplate.Parent = UIParent
	Vernesity:MakeDraggable(UI, Dragger, DragNumber)
	function Windows:ChangeTheme(newtheme)
		newtheme = SetTheme(newtheme)
		theme = newtheme
		for i, v in pairs(WindowTemplate:FindFirstChild('Mobile_Keybinds'):GetChildren()) do
			task.spawn(function()
				if v.ClassName == 'Frame' then
					v.BackgroundColor3 = theme.ElementColor
				end
			end)
		end

		for i, v in pairs(WindowTemplate:FindFirstChild('Notifications'):GetChildren()) do
			task.spawn(function()
				if v.ClassName == 'Frame' then
					v.BackgroundColor3 = theme.WindowColor
					v:FindFirstChild('Bar').BackgroundColor3 = theme.SecondaryElementColor
					for a, b in pairs(v:GetChildren()) do
						task.spawn(function()
							if b.ClassName == 'TextButton' then
								b.BackgroundColor3 = theme.ElementColor
							end
						end)
					end
				end
			end)
		end

		if WindowTemplate:FindFirstChild('UI') then
			local ui = WindowTemplate:FindFirstChild('UI')
			ui.BackgroundColor3 = theme.WindowColor
			ui:FindFirstChild('DropShadow').ImageColor3 = theme.SecondaryElementColor
			ui:FindFirstChild('DropShadow'):FindFirstChild('Main').BackgroundColor3 = theme.WindowColor
			ui:FindFirstChild('DropShadow'):FindFirstChild('Main'):FindFirstChild('Topbar').BackgroundColor3 = theme.WindowColor
			ui:FindFirstChild('DropShadow'):FindFirstChild('Main'):FindFirstChild('LeftSide'):FindFirstChild('idk').BackgroundColor3 = theme.SecondaryElementColor
			ui:FindFirstChild('DropShadow'):FindFirstChild('Main'):FindFirstChild('Dragger').BackgroundColor3 = theme.WindowColor
			ui:FindFirstChild('DropShadow'):FindFirstChild('Main'):FindFirstChild('Topbar'):FindFirstChild('b_SearchBox').BackgroundColor3 = theme.ElementColor
			for i, v in pairs(WindowTemplate:GetDescendants()) do
				task.spawn(function()
					if v.ClassName == 'TextBox' or v.ClassName == 'TextButton' or v.ClassName == 'TextLabel' then
						v.TextColor3 = theme.TextColor
					end
					if v.ClassName == 'UIStroke' then
						if v.Parent.Name == 'Marker' then
							v.Color = theme.WindowColor
						else
							v.Color = theme.SecondaryElementColor
						end
					end
					if v.ClassName == 'ImageLabel' or v.ClassName == 'ImageButton' then
						if v.Name == 'CoolValue' or v.Name == 'RGB' or v.Name == 'DropShadow' or v.Name == 'ResizeButton' then
						else
							v.ImageColor3 = theme.TextColor
						end
						if v.Name == 'DropShadow' then
							v.ImageColor3 = theme.SecondaryElementColor
						end
					end
					if v.ClassName == 'RayValue' then
						local obj = v.Parent
						if v.Name == 'Tab' then
							obj.BackgroundColor3 = theme.TabColor
						end
						if v.Name == 'Button' then
							obj.BackgroundColor3 = theme.ElementColor
						end
						if v.Name == 'Label' then
							obj.BackgroundColor3 = theme.ElementColor
						end
						if v.Name == 'Interactable' then
							obj.BackgroundColor3 = theme.ElementColor
							for i, v in pairs(obj:GetChildren()) do
								task.spawn(function()
									if v.ClassName == 'TextButton' and v.Name == 'Interactable' then
										v.BackgroundColor3 = theme.SecondaryElementColor
									end
								end)
							end
						end
						if v.Name == 'Paragraph' then
							obj.BackgroundColor3 = theme.ElementColor
						end
						if v.Name == 'TextBox' then
							obj.BackgroundColor3 = theme.ElementColor
							for i, v in pairs(obj:GetChildren()) do
								task.spawn(function()
									if v.ClassName == 'TextBox' and v.Name == 'TextBox' then
										v.BackgroundColor3 = theme.WindowColor
									end
								end)
							end
						end
						if v.Name == 'Slider' then
							obj.BackgroundColor3 = theme.ElementColor
							for i, v in pairs(obj:GetChildren()) do
								task.spawn(function()
									if v.ClassName == 'TextButton' and v.Name == 'Slider' then
										v.BackgroundColor3 = theme.WindowColor
										v:FindFirstChild('Bar').BackgroundColor3 = theme.SecondaryElementColor
									end
								end)
							end
						end
						if v.Name == 'Keybind' then
							obj.BackgroundColor3 = theme.ElementColor
							for i, v in pairs(obj:GetChildren()) do
								task.spawn(function()
									if v.ClassName == 'TextButton' or v.ClassName == 'TextBox' then
										if v.Name == 'Keybind' then
											v.BackgroundColor3 = theme.WindowColor
										end
									end
								end)
							end
						end
						if v.Name == 'Dropdown' then
							obj.BackgroundColor3 = theme.ElementColor
							obj:FindFirstChild('Buttons'):FindFirstChild('SearchBox').BackgroundColor3 = theme.WindowColor
						end
						if v.Name == 'ColorPicker' then
							obj.BackgroundColor3 = theme.ElementColor
							obj:FindFirstChild('ApplyButton').BackgroundColor3 = theme.SecondaryElementColor
						end
						if v.Name == 'Toggle' then
							obj.BackgroundColor3 = theme.ElementColor
							for i, v in pairs(obj:GetChildren()) do
								task.spawn(function()
									if v.ClassName == 'Frame' and v.Name == 'Toggle' then
										v.BackgroundColor3 = theme.WindowColor
									end
								end)
							end
						end
						if v.Name == 'Switch' then
							obj.BackgroundColor3 = theme.ElementColor
							for i, v in pairs(obj:GetChildren()) do
								task.spawn(function()
									if v.ClassName == 'Frame' and v.Name == 'Switch' then
										v:FindFirstChild('Circle').BackgroundColor3 = theme.TextColor
										if obj:FindFirstChild("Toggled").Value then
											v.BackgroundColor3 = theme.SecondaryElementColor
										else
											v.BackgroundColor3 = theme.WindowColor
										end
									end
								end)
							end
						end
					end
				end)
			end
		end
	end
	local searching = false
	c_Search.MouseButton1Click:Connect(function()
		searching = not searching
		if searching then
			Tween(b_SearchBox, .65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
				Size = UDim2.new(0, 200, 0, 20)
			})
			Tween(UIStroke, .65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
				Transparency = 0
			})
			b_SearchBox:CaptureFocus()
			for i, tab in pairs(Tabs:GetChildren()) do
				for i, v in pairs(tab.Elements:GetChildren()) do
					if v.ClassName == 'Frame' then
						for i, obj in pairs(v:GetChildren()) do
							if obj.ClassName == 'Frame' then
								obj.Visible = true
							end
						end
					end
				end
			end
		else
			Tween(b_SearchBox, .65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
				Size = UDim2.new(0, 0, 0, 20)
			})
			Tween(UIStroke, .65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
				Transparency = 1
			})
			searching = false
			for i, v in pairs(Tabs:GetChildren()) do
				if v.ClassName == 'Frame' then
					for i, b in pairs(v.Elements:GetChildren()) do
						if b.ClassName == 'Frame' then
							b.Visible = true
							for i, k in pairs(b:GetChildren()) do
								if k.ClassName == 'Frame' then
									k.Visible = true
								end
							end
						end
					end
				end
			end
		end
	end)
	b_SearchBox:GetPropertyChangedSignal('Text'):Connect(function()
		if selectedTab ~= nil then
			for i, v in pairs(Tabs:GetChildren()) do
				if v.ClassName == 'Frame' and v.Name ~= selectedTab then
					for i, b in pairs(v.Elements:GetChildren()) do
						if b.ClassName == 'Frame' then
							b.Visible = true
							for i, k in pairs(b:GetChildren()) do
								if k.ClassName == 'Frame' then
									k.Visible = true
								end
							end
						end
					end
				end
			end
			for i, v in pairs(Tabs[selectedTab].Elements:GetChildren()) do
				local smth = false
				if v.ClassName == 'Frame' then
					if string.find(v.Name:lower(), b_SearchBox.Text:lower()) then
						smth = true
						v.Visible = true
						for _, n in pairs(v:GetChildren()) do
							if n.ClassName == 'Frame' then
								n.Visible = true
								n.Parent.Visible = true
							end
						end
					end
					for a, b in pairs(v:GetChildren()) do
						if b.ClassName == 'Frame' then
							if string.find(b.Name:lower(), b_SearchBox.Text:lower()) or string.find(v.Name:lower(), b_SearchBox.Text:lower()) then
								smth = true
								b.Visible = true
								b.Parent.Visible = true
							else
								b.Visible = false
								if smth == false then
									b.Parent.Visible = false
								end
							end
						end
					end
				end
			end
		end
	end)
	local minimized = false
	local pui = nil
	local pmain = nil
	local pdropshadow = nil
	local g = 0.75
	d_Minimize.MouseButton1Click:Connect(function()
		minimized = not minimized
		onminimize(minimized)
		if minimized then
			pui = UI.Size
			pmain = Main.Size
			pdropshadow = DropShadow.Size
			Tween(DropShadow, g - 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
				ImageTransparency = 1
			})
			Tween(UI, g, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
				Size = UDim2.new(0, UI.Size.X.Offset, 0, 61)
			})
			Tween(Main, g, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
				Size = UDim2.new(0, Main.Size.X.Offset, 0, 35)
			})
			Tween(DropShadow, g, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
				Size = UDim2.new(0, DropShadow.Size.X.Offset, 0, 61)
			})
			for i, v in pairs(Tabs:GetChildren()) do
				Tween(v, g, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					Size = UDim2.new(0, v.Size.X.Offset, 0, 34)
				})
				Tween(v:FindFirstChild('Elements'), g, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					Size = UDim2.new(0, v:FindFirstChild('Elements').Size.X.Offset, 0, 36)
				})
			end
		else
			Tween(DropShadow, g + 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
				ImageTransparency = shadowTransparency
			})
			Tween(UI, g, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
				Size = pui
			})
			Tween(Main, g, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
				Size = pmain
			})
			Tween(DropShadow, g, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
				Size = pdropshadow
			})
			for i, v in pairs(Tabs:GetChildren()) do
				Tween(v, g, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					Size = UDim2.new(pmain.X.Scale, pmain.X.Offset - 145, pmain.Y.Scale, pmain.Y.Offset - 35)
				})
				Tween(v:FindFirstChild('Elements'), g, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					Size = UDim2.new(pmain.X.Scale, pmain.X.Offset - 152, pmain.Y.Scale, pmain.Y.Offset - 41)
				})
			end
		end
	end)

	local j = 0.5
	e_Close.MouseButton1Click:Connect(function()
		onclose()
		Tween(UI, j, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
			Size = UDim2.new(0, 0, 0, 0)
		})
		Tween(Main, j, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
			Size = UDim2.new(0, 0, 0, 0)
		})
		Tween(DropShadow, j, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
			Size = UDim2.new(0, 0, 0, 0)
		})
		wait(j)
		WindowTemplate:Destroy()
	end)

	local Mouse = game.Players.LocalPlayer:GetMouse()
	local Frame = Main
	local Btn = Frame:FindFirstChild('ResizeButton')
	local Offset = nil
	local MinimumX, MinimumY = 300, 200
	local MaxX, MaxY = 1000, 600
	local Resizing = false
	local UIS = game:GetService('UserInputService')
	Btn.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			Tween(Btn, 0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
				ImageTransparency = 0
			})
			local Mouse = input.Position
			Offset = Vector2.new(Mouse.X-(Frame.AbsolutePosition.X+Frame.AbsoluteSize.X),Mouse.Y-(Frame.AbsolutePosition.Y+Frame.AbsoluteSize.Y))
			Resizing = true
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Resizing = false
					Tween(Btn, 0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						ImageTransparency = 1
					})
				end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if Resizing then
				local oldPosX, oldPosY = Frame.Size.X.Offset, Frame.Size.Y.Offset
				local mousePos = Vector2.new(Mouse.X - Offset.X,Mouse.Y - Offset.Y)
				local finalSize = Vector2.new(math.clamp(mousePos.X - Frame.AbsolutePosition.X, MinimumX, MaxX), math.clamp(mousePos.Y - Frame.AbsolutePosition.Y ,MinimumY, MaxY))
				Frame.Size = UDim2.fromOffset(finalSize.X,finalSize.Y)
				local newPosX, newPosY = Frame.Size.X.Offset, Frame.Size.Y.Offset
				for i, v in pairs(WindowTemplate:GetDescendants()) do
					local Type = getSizeValue(v)
					if Type == nil then
					else
						if Type == 'X' then
							v.Size = UDim2.new(0, v.Size.X.Offset + ((newPosX - oldPosX)), 0, v.Size.Y.Offset)
						elseif Type == 'Y' then
							v.Size = UDim2.new(0, v.Size.X.Offset, 0, v.Size.Y.Offset + ((newPosY - oldPosY)))
						elseif Type == 'XY' then
							v.Size = UDim2.new(0, v.Size.X.Offset + ((newPosX - oldPosX)), 0, v.Size.Y.Offset + ((newPosY - oldPosY)))
						end
					end
				end
				pui = UI.Size
				pmain = Main.Size
				pdropshadow = DropShadow.Size
			end
		end
	end)

	function Windows:SetShadowTransparency(number)
		shadowTransparency = number
		DropShadow.ImageTransparency = number
	end

	function Windows:Notify(title, desc, argsTable, duration, callback)
		task.spawn(function()
			if WindowTemplate then
				local NotificationGui = WindowTemplate
				local FUNC = callback
				local NOTIFICATIONTEMPLATE = nil
				local stuff = {}
				local z = UDim2.new(0, 0, 0, 0)
				local runNotification = true
				local otherStuff = {
					['Title'] = UDim2.new(1, 0, 0.15, 0),
					['Bar'] = UDim2.new(1, 0, 0.03, 0)
				}
				if #argsTable > 2 then warn('Error: Cannot add more than 2 buttons.') runNotification = false end
				if #argsTable == 0 then
					local NotificationTemplate = Instance.new('Frame')
					NotificationTemplate.Name = 'Notification'
					NotificationTemplate.Size = z
					NotificationTemplate.Position = UDim2.new(0, 0, 0.7, 0)
					NotificationTemplate.BorderSizePixel = 0
					NotificationTemplate.BackgroundColor3 = theme.WindowColor
					local UICorner = Instance.new('UICorner')
					UICorner.CornerRadius = UDim.new(0, 4)
					UICorner.Parent = NotificationTemplate
					local Bar = Instance.new('Frame')
					Bar.Name = 'Bar'
					Bar.AnchorPoint = Vector2.new(0, 1)
					Bar.Size = z
					Bar.Position = UDim2.new(0, 0, 1, 0)
					Bar.BorderSizePixel = 0
					Bar.BackgroundColor3 = theme.SecondaryElementColor
					Bar.Parent = NotificationTemplate
					local UICorner1 = Instance.new('UICorner')
					UICorner1.CornerRadius = UDim.new(0, 69)
					UICorner1.Parent = Bar
					local Notification = Instance.new('RayValue')
					Notification.Name = 'Notification'
					Notification.Parent = NotificationTemplate
					local Title = Instance.new('TextLabel')
					Title.Name = 'Title'
					Title.Size = z
					Title.BackgroundTransparency = 1
					Title.Position = UDim2.new(0, 0, 0.07, 0)
					Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Title.FontSize = Enum.FontSize.Size18
					Title.TextTransparency = 0.1
					Title.TextScaled = true
					Title.TextSize = 16
					Title.TextColor3 = theme.TextColor
					Title.Text = tostr(title)
					Title.Font = Enum.Font.GothamMedium
					Title.Parent = NotificationTemplate
					local Description = Instance.new('TextLabel')
					Description.Name = 'Description'
					Description.Size = z
					Description.BackgroundTransparency = 1
					Description.Position = UDim2.new(0.115, 0, 0.305, 0)
					Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Description.FontSize = Enum.FontSize.Size14
					Description.TextTransparency = 0.2
					Description.TextSize = 14
					Description.TextColor3 = theme.TextColor
					Description.Text = tostr(desc)
					Description.TextYAlignment = Enum.TextYAlignment.Top
					Description.TextWrapped = true
					Description.Font = Enum.Font.Gotham
					Description.TextWrap = true
					Description.Parent = NotificationTemplate
					NotificationTemplate.Parent = Notifications
					NOTIFICATIONTEMPLATE = NotificationTemplate
					stuff = {
						['Description'] = UDim2.new(0.765, 0, 0.555, 0),
					}
				elseif #argsTable == 1 then
					if type(argsTable[1]) == 'string' then
						local NotificationTemplate = Instance.new('Frame')
						NotificationTemplate.Name = 'Notification'
						NotificationTemplate.Size = z
						NotificationTemplate.Position = UDim2.new(0, 0, 0.7, 0)
						NotificationTemplate.BorderSizePixel = 0
						NotificationTemplate.BackgroundColor3 = theme.WindowColor
						local UICorner = Instance.new('UICorner')
						UICorner.CornerRadius = UDim.new(0, 4)
						UICorner.Parent = NotificationTemplate
						local Bar = Instance.new('Frame')
						Bar.Name = 'Bar'
						Bar.AnchorPoint = Vector2.new(0, 1)
						Bar.Size = z
						Bar.Position = UDim2.new(0, 0, 1, 0)
						Bar.BorderSizePixel = 0
						Bar.BackgroundColor3 = theme.SecondaryElementColor
						Bar.Parent = NotificationTemplate
						local UICorner1 = Instance.new('UICorner')
						UICorner1.CornerRadius = UDim.new(0, 69)
						UICorner1.Parent = Bar
						local Notification = Instance.new('RayValue')
						Notification.Name = 'Notification'
						Notification.Parent = NotificationTemplate
						local Title = Instance.new('TextLabel')
						Title.Name = 'Title'
						Title.Size = z
						Title.BackgroundTransparency = 1
						Title.Position = UDim2.new(0, 0, 0.069, 0)
						Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Title.FontSize = Enum.FontSize.Size18
						Title.TextTransparency = 0.1
						Title.TextScaled = true
						Title.TextSize = 16
						Title.TextColor3 = theme.TextColor
						Title.Text = tostr(title)
						Title.Font = Enum.Font.GothamMedium
						Title.Parent = NotificationTemplate
						local Button = Instance.new('TextButton')
						Button.Name = 'Button'
						Button.Size = z
						Button.ClipsDescendants = true
						Button.Position = UDim2.new(0.11, 0, 0.75, 0)
						Button.BorderSizePixel = 0
						Button.BackgroundColor3 = theme.ElementColor
						Button.AutoButtonColor = false
						Button.FontSize = Enum.FontSize.Size12
						Button.LineHeight = 0.99
						Button.TextTransparency = 0.1
						Button.TextSize = 12
						Button.TextColor3 = theme.TextColor
						Button.Text = tostr(argsTable[1])
						Button.Font = Enum.Font.Gotham
						Button.Parent = NotificationTemplate
						local UICorner2 = Instance.new('UICorner')
						UICorner2.CornerRadius = UDim.new(0, 3)
						UICorner2.Parent = Button
						local Description = Instance.new('TextLabel')
						Description.Name = 'Description'
						Description.Size = z
						Description.BackgroundTransparency = 1
						Description.Position = UDim2.new(0.115, 0, 0.305, 0)
						Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Description.FontSize = Enum.FontSize.Size14
						Description.TextTransparency = 0.2
						Description.TextSize = 14
						Description.TextColor3 = theme.TextColor
						Description.Text = tostr(desc)
						Description.TextYAlignment = Enum.TextYAlignment.Top
						Description.TextWrapped = true
						Description.Font = Enum.Font.Gotham
						Description.TextWrap = true
						Description.Parent = NotificationTemplate
						NotificationTemplate.Parent = Notifications
						NOTIFICATIONTEMPLATE = NotificationTemplate
						stuff = {
							['Description'] = UDim2.new(0.765, 0, 0.409, 0),
							['Button'] = UDim2.new(0.76, 0, 0.145, 0)
						}
						Button.MouseButton1Click:Connect(function()
							FUNC(Button.Text)
							runNotification = false
							Tween(NOTIFICATIONTEMPLATE, .15, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								Size = z
							})
							wait(.35)
							NOTIFICATIONTEMPLATE:Destroy()
						end)
					elseif type(argsTable[1]) == 'number' then
						local NotificationTemplate = Instance.new('Frame')
						NotificationTemplate.Name = 'Notification'
						NotificationTemplate.Size = z
						NotificationTemplate.Position = UDim2.new(0, 0, 0.7, 0)
						NotificationTemplate.BorderSizePixel = 0
						NotificationTemplate.BackgroundColor3 = theme.WindowColor
						local UICorner = Instance.new('UICorner')
						UICorner.CornerRadius = UDim.new(0, 4)
						UICorner.Parent = NotificationTemplate
						local Bar = Instance.new('Frame')
						Bar.Name = 'Bar'
						Bar.AnchorPoint = Vector2.new(0, 1)
						Bar.Size = z
						Bar.Position = UDim2.new(0, 0, 1, 0)
						Bar.BorderSizePixel = 0
						Bar.BackgroundColor3 = theme.SecondaryElementColor
						Bar.Parent = NotificationTemplate
						local UICorner1 = Instance.new('UICorner')
						UICorner1.CornerRadius = UDim.new(0, 69)
						UICorner1.Parent = Bar
						local Notification = Instance.new('RayValue')
						Notification.Name = 'Notification'
						Notification.Parent = NotificationTemplate
						local Title = Instance.new('TextLabel')
						Title.Name = 'Title'
						Title.Size = z
						Title.BackgroundTransparency = 1
						Title.Position = UDim2.new(0, 0, 0.069, 0)
						Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Title.FontSize = Enum.FontSize.Size18
						Title.TextTransparency = 0.1
						Title.TextScaled = true
						Title.TextSize = 16
						Title.TextColor3 = theme.TextColor
						Title.Text = tostr(title)
						Title.Font = Enum.Font.GothamMedium
						Title.Parent = NotificationTemplate
						local Description = Instance.new('TextLabel')
						Description.Name = 'Description'
						Description.Size = z
						Description.BackgroundTransparency = 1
						Description.Position = UDim2.new(0.115, 0, 0.305, 0)
						Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Description.FontSize = Enum.FontSize.Size14
						Description.TextTransparency = 0.2
						Description.TextSize = 14
						Description.TextColor3 = theme.TextColor
						Description.Text = tostr(desc)
						Description.TextYAlignment = Enum.TextYAlignment.Top
						Description.TextWrapped = true
						Description.Font = Enum.Font.Gotham
						Description.TextWrap = true
						Description.Parent = NotificationTemplate
						local Button = Instance.new('ImageButton')
						Button.Name = 'Button'
						Button.Size = z
						Button.BackgroundTransparency = 1
						Button.Position = UDim2.new(0.11, 0, 0.74, 0)
						Button.BorderSizePixel = 0
						Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Button.ScaleType = Enum.ScaleType.Fit
						Button.Image = 'http://www.roblox.com/asset/?id='..argsTable[1]
						Button.Parent = NotificationTemplate
						Button.ImageColor3 = theme.TextColor
						NotificationTemplate.Parent = Notifications
						NOTIFICATIONTEMPLATE = NotificationTemplate
						stuff = {
							['Description'] = UDim2.new(0.765, 0, 0.442, 0),
							['Button'] = UDim2.new(0.76, 0, 0.182, 0)
						}
						Button.MouseButton1Click:Connect(function()
							FUNC('Button')
							runNotification = false
							Tween(NOTIFICATIONTEMPLATE, .15, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								Size = z
							})
							wait(.35)
							NOTIFICATIONTEMPLATE:Destroy()
						end)
					end
				elseif #argsTable == 2 then
					if type(argsTable[1]) == 'string' and type(argsTable[2]) == 'string' then
						local NotificationTemplate = Instance.new('Frame')
						NotificationTemplate.Name = 'Notification'
						NotificationTemplate.Size = z
						NotificationTemplate.Position = UDim2.new(0, 0, 0.7, 0)
						NotificationTemplate.BorderSizePixel = 0
						NotificationTemplate.BackgroundColor3 = theme.WindowColor
						local UICorner = Instance.new('UICorner')
						UICorner.CornerRadius = UDim.new(0, 4)
						UICorner.Parent = NotificationTemplate
						local Bar = Instance.new('Frame')
						Bar.Name = 'Bar'
						Bar.AnchorPoint = Vector2.new(0, 1)
						Bar.Size = z
						Bar.Position = UDim2.new(0, 0, 1, 0)
						Bar.BorderSizePixel = 0
						Bar.BackgroundColor3 = theme.SecondaryElementColor
						Bar.Parent = NotificationTemplate
						local UICorner1 = Instance.new('UICorner')
						UICorner1.CornerRadius = UDim.new(0, 69)
						UICorner1.Parent = Bar
						local Notification = Instance.new('RayValue')
						Notification.Name = 'Notification'
						Notification.Parent = NotificationTemplate
						local Title = Instance.new('TextLabel')
						Title.Name = 'Title'
						Title.Size = z
						Title.BackgroundTransparency = 1
						Title.Position = UDim2.new(0, 0, 0.069, 0)
						Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Title.FontSize = Enum.FontSize.Size18
						Title.TextTransparency = 0.1
						Title.TextSize = 16
						Title.TextScaled = true
						Title.TextColor3 = theme.TextColor
						Title.Text = tostr(title)
						Title.Font = Enum.Font.GothamMedium
						Title.Parent = NotificationTemplate
						local Button1 = Instance.new('TextButton')
						Button1.Name = 'Button1'
						Button1.Size = z
						Button1.ClipsDescendants = true
						Button1.Position = UDim2.new(0.11, 0, 0.7, 0)
						Button1.BorderSizePixel = 0
						Button1.BackgroundColor3 = theme.ElementColor
						Button1.AutoButtonColor = false
						Button1.FontSize = Enum.FontSize.Size12
						Button1.LineHeight = 0.99
						Button1.TextTransparency = 0.1
						Button1.TextSize = 12
						Button1.TextColor3 = theme.TextColor
						Button1.Text = tostr(argsTable[1])
						Button1.Font = Enum.Font.Gotham
						Button1.Parent = NotificationTemplate
						local UICorner2 = Instance.new('UICorner')
						UICorner2.CornerRadius = UDim.new(0, 3)
						UICorner2.Parent = Button1
						local Description = Instance.new('TextLabel')
						Description.Name = 'Description'
						Description.Size = z
						Description.BackgroundTransparency = 1
						Description.Position = UDim2.new(0.115, 0, 0.305, 0)
						Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Description.FontSize = Enum.FontSize.Size14
						Description.TextTransparency = 0.2
						Description.TextSize = 14
						Description.TextColor3 = theme.TextColor
						Description.Text = tostr(desc)
						Description.TextYAlignment = Enum.TextYAlignment.Top
						Description.TextWrapped = true
						Description.Font = Enum.Font.Gotham
						Description.TextWrap = true
						Description.Parent = NotificationTemplate
						local Button2 = Instance.new('TextButton')
						Button2.Name = 'Button2'
						Button2.Size = z
						Button2.ClipsDescendants = true
						Button2.Position = UDim2.new(0.53, 0, 0.7, 0)
						Button2.BorderSizePixel = 0
						Button2.BackgroundColor3 = theme.ElementColor
						Button2.AutoButtonColor = false
						Button2.FontSize = Enum.FontSize.Size12
						Button2.LineHeight = 0.99
						Button2.TextTransparency = 0.1
						Button2.TextSize = 12
						Button2.TextColor3 = theme.TextColor
						Button2.Text = tostr(argsTable[2])
						Button2.Font = Enum.Font.Gotham
						Button2.Parent = NotificationTemplate
						local UICorner3 = Instance.new('UICorner')
						UICorner3.CornerRadius = UDim.new(0, 3)
						UICorner3.Parent = Button2
						NotificationTemplate.Parent = Notifications
						NOTIFICATIONTEMPLATE = NotificationTemplate
						stuff = {
							['Description'] = UDim2.new(0.765, 0, 0.409, 0),
							['Button1'] = UDim2.new(0.339, 0, 0.145, 0),
							['Button2'] = UDim2.new(0.339, 0, 0.145, 0)
						}
						Button1.MouseButton1Click:Connect(function()
							FUNC(Button1.Text)
							runNotification = false
							Tween(NOTIFICATIONTEMPLATE, .15, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								Size = z
							})
							wait(.35)
							NOTIFICATIONTEMPLATE:Destroy()
						end)
						Button2.MouseButton1Click:Connect(function()
							FUNC(Button2.Text)
							runNotification = false
							Tween(NOTIFICATIONTEMPLATE, .15, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								Size = z
							})
							wait(.35)
							NOTIFICATIONTEMPLATE:Destroy()
						end)
					elseif type(argsTable[1]) == 'number' and type(argsTable[2]) == 'number' then
						local NotificationTemplate = Instance.new('Frame')
						NotificationTemplate.Name = 'NotificationTemplate'
						NotificationTemplate.Size = UDim2.new(1, 0, 0.32, 0)
						NotificationTemplate.Position = UDim2.new(0, 0, 0.7, 0)
						NotificationTemplate.BorderSizePixel = 0
						NotificationTemplate.BackgroundColor3 = theme.WindowColor
						local UICorner = Instance.new('UICorner')
						UICorner.CornerRadius = UDim.new(0, 4)
						UICorner.Parent = NotificationTemplate
						local Bar = Instance.new('Frame')
						Bar.Name = 'Bar'
						Bar.AnchorPoint = Vector2.new(0, 1)
						Bar.Size = z
						Bar.Position = UDim2.new(0, 0, 1, 0)
						Bar.BorderSizePixel = 0
						Bar.BackgroundColor3 = theme.SecondaryElementColor
						Bar.Parent = NotificationTemplate
						local UICorner1 = Instance.new('UICorner')
						UICorner1.CornerRadius = UDim.new(0, 69)
						UICorner1.Parent = Bar
						local Notification = Instance.new('RayValue')
						Notification.Name = 'Notification'
						Notification.Parent = NotificationTemplate
						local Title = Instance.new('TextLabel')
						Title.Name = 'Title'
						Title.Size = UDim2.new(1, 0, 0.15, 0)
						Title.BackgroundTransparency = 1
						Title.TextScaled = true
						Title.Position = UDim2.new(0, 0, 0.069, 0)
						Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Title.FontSize = Enum.FontSize.Size18
						Title.TextTransparency = 0.1
						Title.TextSize = 16
						Title.TextColor3 = theme.TextColor
						Title.Text = tostr(title)
						Title.TextWrapped = true
						Title.Font = Enum.Font.GothamMedium
						Title.TextWrap = true
						Title.TextScaled = true
						Title.Parent = NotificationTemplate
						local Description = Instance.new('TextLabel')
						Description.Name = 'Description'
						Description.Size = UDim2.new(0.76, 0, 0.4, 0)
						Description.BackgroundTransparency = 1
						Description.Position = UDim2.new(0.115, 0, 0.305, 0)
						Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Description.FontSize = Enum.FontSize.Size14
						Description.TextTransparency = 0.2
						Description.TextSize = 14
						Description.TextColor3 = theme.TextColor
						Description.Text = tostr(desc)
						Description.TextYAlignment = Enum.TextYAlignment.Top
						Description.TextWrapped = true
						Description.Font = Enum.Font.Gotham
						Description.TextWrap = true
						Description.Parent = NotificationTemplate
						local Button2 = Instance.new('ImageButton')
						Button2.Name = 'Button2'
						Button2.Size = UDim2.new(0.33, 0, 0.18, 0)
						Button2.BackgroundTransparency = 1
						Button2.Position = UDim2.new(0.53, 0, 0.74, 0)
						Button2.BorderSizePixel = 0
						Button2.BackgroundColor3 = theme.ElementColor
						Button2.ScaleType = Enum.ScaleType.Fit
						Button2.Image = 'http://www.roblox.com/asset/?id='..argsTable[2]
						Button2.Parent = NotificationTemplate
						local Button1 = Instance.new('ImageButton')
						Button1.Name = 'Button1'
						Button1.Size = UDim2.new(0.33, 0, 0.18, 0)
						Button1.BackgroundTransparency = 1
						Button1.Position = UDim2.new(0.11, 0, 0.74, 0)
						Button1.BorderSizePixel = 0
						Button1.BackgroundColor3 = theme.ElementColor
						Button1.ScaleType = Enum.ScaleType.Fit
						Button1.Image = 'http://www.roblox.com/asset/?id='..argsTable[1]
						Button1.Parent = NotificationTemplate
						NotificationTemplate.Parent = Notifications
						NOTIFICATIONTEMPLATE = NotificationTemplate
						stuff = {
							['Description'] = UDim2.new(0.765, 0, 0.409, 0),
							['Button1'] = UDim2.new(0.339, 0, 0.182, 0),
							['Button2'] = UDim2.new(0.339, 0, 0.182, 0)
						}
						Button1.MouseButton1Click:Connect(function()
							FUNC('Button1')
							runNotification = false
							Tween(NOTIFICATIONTEMPLATE, .15, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								Size = z
							})
							wait(.35)
							NOTIFICATIONTEMPLATE:Destroy()
						end)
						Button2.MouseButton1Click:Connect(function()
							FUNC('Button2')
							runNotification = false
							Tween(NOTIFICATIONTEMPLATE, .15, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								Size = z
							})
							wait(.35)
							NOTIFICATIONTEMPLATE:Destroy()
						end)
					elseif type(argsTable[1]) == 'number' and type(argsTable[2]) == 'string' or type(argsTable[1]) == 'string' and type(argsTable[2]) == 'number' then
						warn('Error: Please make the both arguments either strings or numbers.')
						runNotification = false
					end
				end
				NOTIFICATIONTEMPLATE.ClipsDescendants = true
				addTypeValue(NOTIFICATIONTEMPLATE, 'Notification')
				if stuff ~= {} and runNotification and NOTIFICATIONTEMPLATE ~= nil then
					Tween(NOTIFICATIONTEMPLATE, 0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Size = UDim2.new(1, 0, 0.174, 0)
					})
					for i, v in pairs(stuff) do
						NOTIFICATIONTEMPLATE:FindFirstChild(i).Size = v
					end
					for i, v in pairs(otherStuff) do
						NOTIFICATIONTEMPLATE:FindFirstChild(i).Size = v
					end
					wait(0.25)
					Tween(NOTIFICATIONTEMPLATE:FindFirstChild('Bar'), duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Size = UDim2.new(0, 0, 0.03, 0)
					})
					wait(duration)
					if runNotification then
						Tween(NOTIFICATIONTEMPLATE, .15, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = z
						})
						wait(.35)
						if NOTIFICATIONTEMPLATE then
							NOTIFICATIONTEMPLATE:Destroy()
						end
					end
				end
			end
		end)
	end

	function Windows:Edit(newTitle1, newTitle2, newTheme)
		Title.Text = tostr(newTitle1)
		Title2.Text = tostr(newTitle2)
		WindowTemplate.Name = tostr(newTitle1)
		theme = SetTheme(newTheme)
		Windows:ChangeTheme(theme)
		local found = table.find(Windows, title1)
		if found ~= nil then
			table.remove(Windows, found)
			table.insert(Windows, newTitle1)
		end
		title1 = newTitle1
		title2 = newTitle2
	end

	function Windows:Remove()
		title1 = nil
		title2 = nil
		WindowTemplate:Destroy()
		local found = table.find(Windows, title1)
		if found ~= nil then
			table.remove(Windows, found)
		end
	end

	function Windows:Tab(tabName, ImageId)
		local Tab = {}
		table.insert(Tab, tabName)
		local imageId
		if not ImageId then
			imageId = 0
		else
			imageId = ImageId
		end
		local MENUBUTTON = nil
		local TabTemplate = nil
		local function selectTab(TABNAME, animation)
			selectedTab = TABNAME
			for i, v in pairs(Tabs:GetChildren()) do
				if v:IsA('Frame') then
					if v.Name == TABNAME then
						v.Visible = true
					else
						v.Visible = false
					end
				end
			end
			for i, v in pairs(Menu:GetChildren()) do
				if v:IsA('Frame') then
					if v.Name == TABNAME then
						if animation then
							Tween(v:FindFirstChild('Text'), 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								TextTransparency = 0.1
							})
							if v:FindFirstChild('Image') then
								Tween(v:FindFirstChild('Image'), 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
									ImageTransparency = 0.1
								})
							end
						else
							v:FindFirstChild('Text').TextTransparency = 0.1
							if v:FindFirstChild('Image') then
								v:FindFirstChild('Image').ImageTransparency = 0.1
							end
						end
					else
						if v:FindFirstChild('Text').TextTransparency ~= 0.5 then
							if animation then
								Tween(v:FindFirstChild('Text'), 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
									TextTransparency = 0.5
								})
								if v:FindFirstChild('Image') then
									Tween(v:FindFirstChild('Image'), 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
										ImageTransparency = 0.5
									})
								end
							else
								v:FindFirstChild('Text').TextTransparency = 0.5
								if v:FindFirstChild('Image') then
									v:FindFirstChild('Image').ImageTransparency = 0.5
								end
							end
						end
					end
				end
			end
		end
		pcall(function()
			if allTabs[table.find(allTabs, tabName)] then
				return warn('Please choose a different Tab Name!')
			else
				TabTemplate = Instance.new('Frame')
				addTypeValue(TabTemplate, 'Tab')
				TabTemplate.Name = tostr(tabName)
				TabTemplate.AnchorPoint = Vector2.new(1, 1)
				TabTemplate.Size = setElementSizeXY(UDim2.new(0, 341, 0, 265))
				TabTemplate.Position = UDim2.new(1, 0, 1, 0)
				TabTemplate.BorderSizePixel = 0
				TabTemplate.BackgroundColor3 = theme.TabColor
				TabTemplate.Active = true
				TabTemplate.Visible = false
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 5)
				UICorner.Parent = TabTemplate
				local Elements = Instance.new('ScrollingFrame')
				Elements.Name = 'Elements'
				Elements.AnchorPoint = Vector2.new(1, .5)
				Elements.Size = setElementSizeXY(UDim2.new(0, 334, 0, 259))
				Elements.BackgroundTransparency = 1
				Elements.Position = UDim2.new(1, 0, .5, 0)
				Elements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Elements.CanvasSize = UDim2.new(0, 0, 0, 0)
				Elements.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
				Elements.ScrollBarImageTransparency = 1
				Elements.ScrollBarThickness = 0
				Elements.Active = true
				Elements.Parent = TabTemplate
				local UIListLayout = Instance.new('UIListLayout')
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 5)
				UIListLayout.Parent = Elements
				local Value = Instance.new('StringValue')
				Value.Value = 'XY'
				Value.Parent = Elements
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'XY'
				Value1.Parent = TabTemplate
				TabTemplate.Parent = Tabs
				if imageId == 0 then
					local MenuButton2 = Instance.new('Frame')
					MenuButton2.Name = tostr(tabName)
					MenuButton2.Size = UDim2.new(0, 146, 0, 30)
					MenuButton2.BackgroundTransparency = 1
					MenuButton2.BorderSizePixel = 0
					MenuButton2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					local Text = Instance.new('TextLabel')
					Text.Name = 'Text'
					Text.AnchorPoint = Vector2.new(0.4, 0.5)
					Text.Size = UDim2.new(0, 96, 0, 25)
					Text.BackgroundTransparency = 1
					Text.Position = UDim2.new(0.4, 0, 0.5, 0)
					Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Text.FontSize = Enum.FontSize.Size18
					Text.TextTransparency = 0.5
					Text.TextSize = 15
					Text.TextColor3 = theme.TextColor
					Text.Text = tostr(tabName)
					Text.Font = Enum.Font.GothamMedium
					Text.TextXAlignment = Enum.TextXAlignment.Left
					Text.Parent = MenuButton2
					MENUBUTTON = MenuButton2
				else
					local MenuButton1 = Instance.new('Frame')
					MenuButton1.Name = tostr(tabName)
					MenuButton1.Size = UDim2.new(0, 146, 0, 30)
					MenuButton1.BackgroundTransparency = 1
					MenuButton1.BorderSizePixel = 0
					MenuButton1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					local Text = Instance.new('TextLabel')
					Text.Name = 'Text'
					Text.AnchorPoint = Vector2.new(0, 0.5)
					Text.Size = UDim2.new(0, 96, 0, 25)
					Text.BackgroundTransparency = 1
					Text.Position = UDim2.new(0.272871, 0, 0.5, 0)
					Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Text.FontSize = Enum.FontSize.Size18
					Text.TextSize = 15
					Text.TextColor3 = theme.TextColor
					Text.Text = tostr(tabName)
					Text.Font = Enum.Font.GothamMedium
					Text.TextXAlignment = Enum.TextXAlignment.Left
					Text.Parent = MenuButton1
					Text.TextTransparency = 0.5
					local Image = Instance.new('ImageLabel')
					Image.Name = 'Image'
					Image.AnchorPoint = Vector2.new(0, 0.5)
					Image.LayoutOrder = 6
					Image.Selectable = true
					Image.ZIndex = 2
					Image.Size = UDim2.new(0, 22, 0, 22)
					Image.BackgroundTransparency = 1
					Image.Position = UDim2.new(0.07, 0, 0.5, 0)
					Image.Active = true
					Image.Image = 'http://www.roblox.com/asset/?id='..imageId
					Image.ImageColor3 = theme.TextColor
					Image.Parent = MenuButton1
					Image.ImageTransparency = 0.5
					MENUBUTTON = MenuButton1
				end
				MENUBUTTON.Parent = Menu
				local Button = Instance.new('TextButton')
				Button.Name = 'Button'
				Button.Size = UDim2.new(0, 146, 0, 30)
				Button.BackgroundTransparency = 1
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.FontSize = Enum.FontSize.Size14
				Button.TextSize = 14
				Button.TextColor3 = Color3.fromRGB(0, 0, 0)
				Button.Text = ''
				Button.Font = Enum.Font.SourceSans
				Button.Parent = MENUBUTTON
				enableRippleEffect(Button)
				MENUBUTTON.Button.MouseButton1Click:Connect(function()
					selectTab(tostr(tabName), true)
				end)
				if selectedTab == nil then
					selectTab(tostr(tabName), false)
				end
				table.insert(allTabs, tabName)
			end
		end)

		function Tab:Remove()
			table.remove(Tab, table.find(Tab, tabName))
			table.remove(allTabs, table.find(allTabs, tabName))
			TabTemplate:Destroy()
			MENUBUTTON:Destroy()
			if selectedTab == tabName and #allTabs ~= 0 then
				selectTab(allTabs[1])
			end
			if #allTabs == 0 then
				selectedTab = nil
			end
		end

		function Tab:Edit(newTabName, newImageId)
			local NewImageId = newImageId or 0
			table.remove(Tab, table.find(Tab, tabName))
			table.insert(Tab, newTabName)
			table.remove(allTabs, table.find(allTabs, tabName))
			table.insert(allTabs, newTabName)
			tabName = newTabName
			if ImageId == NewImageId then
			elseif ImageId == 0 and NewImageId ~= 0 or ImageId ~= 0 and NewImageId == 0 then
				warn('Unknown error')
			elseif ImageId ~= 0 and NewImageId ~= 0 then
				local name = Menu:FindFirstChild(TabTemplate.Name)
				for i, v in pairs(Menu:GetChildren()) do
					if v.ClassName == 'Frame' and v.Name == name then
						v:FindFirstChild('Image').Image = newImageId
						ImageId = NewImageId
					end
				end
			end
		end

		function Tab:Section(sectionName)
			local Section = {}
			table.insert(Section, sectionName)
			local SectionTemplate = Instance.new('Frame')
			addTypeValue(SectionTemplate, 'Section')
			SectionTemplate.Name = tostr(sectionName)
			SectionTemplate.Active = true
			SectionTemplate.AnchorPoint = Vector2.new(0.5, 1)
			SectionTemplate.Size = UDim2.new(0, 0, 0, 0)
			SectionTemplate.ClipsDescendants = true
			SectionTemplate.BackgroundTransparency = 1
			SectionTemplate.Position = UDim2.new(0.4880952, 0, 0.7900374, 0)
			SectionTemplate.BorderSizePixel = 0
			SectionTemplate.BackgroundColor3 = theme.ElementColor
			local UICorner = Instance.new('UICorner')
			UICorner.CornerRadius = UDim.new(0, 5)
			UICorner.Parent = SectionTemplate
			local Text = Instance.new('TextLabel')
			Text.Name = 'Text'
			Text.AnchorPoint = Vector2.new(0.5, 0.5)
			Text.Size = setElementSizeX(UDim2.new(0, 327, 0, 20))
			Text.BackgroundTransparency = 1
			Text.Position = UDim2.new(0.516855, 0, 0.7115384, 0)
			Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Text.FontSize = Enum.FontSize.Size14
			Text.TextTransparency = 0.1
			Text.TextSize = 14
			Text.TextColor3 = theme.TextColor
			Text.Text = tostr(sectionName)
			Text.Font = Enum.Font.GothamMedium
			Text.TextXAlignment = Enum.TextXAlignment.Left
			Text.TextYAlignment = Enum.TextYAlignment.Bottom
			Text.Parent = SectionTemplate
			local UIListLayout = Instance.new('UIListLayout')
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)
			UIListLayout.Parent = SectionTemplate
			local Value = Instance.new('StringValue')
			Value.Value = 'X'
			Value.Parent = SectionTemplate
			SectionTemplate.Parent = TabTemplate:FindFirstChild('Elements')
			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				local c = UIListLayout
				SectionTemplate.Size = UDim2.new(0, c.AbsoluteContentSize.X, 0, c.AbsoluteContentSize.Y)
			end)

			function Section:Edit(newSectionName)
				Text.Text = tostr(newSectionName)
				sectionName = tostr(newSectionName)
				SectionTemplate.Name = tostr(newSectionName)
			end

			function Section:Remove()
				SectionTemplate:Destroy()
			end

			function Section:Button(btnName, info, func)
				local button = {}
				table.insert(button, btnName)
				local FUNC = func
				local ButtonTemplate = Instance.new('Frame')
				addTypeValue(ButtonTemplate, 'Button')
				ButtonTemplate.Name = tostr(btnName)
				ButtonTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				ButtonTemplate.ClipsDescendants = true
				ButtonTemplate.Position = UDim2.new(0, 0, 0.1256732, 0)
				ButtonTemplate.BorderSizePixel = 0
				ButtonTemplate.Active = true
				ButtonTemplate.BackgroundColor3 = theme.ElementColor
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = ButtonTemplate
				local Text = Instance.new('TextLabel')
				Text.Name = 'Text'
				Text.AnchorPoint = Vector2.new(0.22, 0.5)
				Text.Size = setElementSizeX(UDim2.new(0, 272, 0, 40))
				Text.BackgroundTransparency = 1
				Text.Active = true
				Text.Position = UDim2.new(0.22, 0, 0, 20)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.FontSize = Enum.FontSize.Size14
				Text.TextSize = 14
				Text.TextColor3 = theme.TextColor
				Text.Text = tostr(btnName)
				Text.Font = Enum.Font.GothamMedium
				Text.TextXAlignment = Enum.TextXAlignment.Left
				Text.TextTransparency = 0.1
				Text.Parent = ButtonTemplate
				local Value = Instance.new('StringValue')
				Value.Value = 'X'
				Value.Parent = Text
				local Button = Instance.new('TextButton')
				Button.Name = 'Button'
				Button.Size = setElementSizeX(UDim2.new(0, 285, 0, 40))
				Button.BackgroundTransparency = 1
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.FontSize = Enum.FontSize.Size14
				Button.TextSize = 14
				Button.TextColor3 = Color3.fromRGB(0, 0, 0)
				Button.Text = ''
				Button.Font = Enum.Font.SourceSans
				Button.Parent = ButtonTemplate
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'X'
				Value1.Parent = Button
				local viewInfo = Instance.new("TextButton")
				viewInfo.Name = "viewInfo"
				viewInfo.AnchorPoint = Vector2.new(1, 0)
				viewInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(1, 0, 0, 0)
				viewInfo.Size = UDim2.new(0, 43, 0, 40)
				viewInfo.Font = Enum.Font.SourceSans
				viewInfo.Text = ""
				viewInfo.TextColor3 = Color3.fromRGB(0, 0, 0)
				viewInfo.TextSize = 14
				local ViewInfo = Instance.new("ImageLabel")
				ViewInfo.Name = "ViewInfo"
				ViewInfo.Active = true
				ViewInfo.AnchorPoint = Vector2.new(0.5, 0.5)
				ViewInfo.BackgroundTransparency = 1
				ViewInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
				ViewInfo.Selectable = true
				ViewInfo.Size = UDim2.new(0, 22, 0, 22)
				ViewInfo.Image = "rbxassetid://3926305904"
				ViewInfo.ImageColor3 = theme.TextColor
				ViewInfo.ImageRectOffset = Vector2.new(564, 284)
				ViewInfo.ImageRectSize = Vector2.new(36, 36)
				ViewInfo.Parent = viewInfo
				viewInfo.Parent = ButtonTemplate
				local Info = Instance.new('TextLabel')
				Info.Name = 'Info'
				Info.AnchorPoint = Vector2.new(0.5, 0.5)
				Info.Size = setElementSizeX(UDim2.new(0, 303, 0, 22))
				Info.BackgroundTransparency = 1
				Info.Position = UDim2.new(0.497, 0, 0, 47)
				Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Info.FontSize = Enum.FontSize.Size14
				Info.TextTransparency = 0.2
				Info.TextSize = 13
				Info.TextColor3 = theme.TextColor
				Info.Text = tostr(info)
				Info.Font = Enum.Font.Gotham
				Info.Active = true
				Info.TextXAlignment = Enum.TextXAlignment.Left
				Info.Parent = ButtonTemplate
				local Value2 = Instance.new('StringValue')
				Value2.Value = 'X'
				Value2.Parent = Info
				local Value3 = Instance.new('StringValue')
				Value3.Value = 'X'
				Value3.Parent = ButtonTemplate
				enableRippleEffect(Button, ButtonTemplate)
				ButtonTemplate.Parent = SectionTemplate
				Button.MouseButton1Click:Connect(function()
					FUNC()
				end)
				local f, idk = false, 0.45
				local style, dir = Enum.EasingStyle.Quad, Enum.EasingDirection.InOut
				viewInfo.MouseButton1Click:Connect(function()
					f = not f
					if f then
						Tween(ButtonTemplate, idk, style, dir, {
							Size = UDim2.new(0, ButtonTemplate.Size.X.Offset, 0, 65)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 180,
							ImageColor3 = theme.SecondaryElementColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
					else
						Tween(ButtonTemplate, idk, style, dir, {
							Size = UDim2.new(0, ButtonTemplate.Size.X.Offset, 0, 40)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 0,
							ImageColor3 = theme.TextColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
					end
				end)
				function button:Edit(newName, newInfo, newFunc)
					FUNC = newFunc
					Info.Text = tostr(newInfo)
					Text.Text = tostr(newName)
					ButtonTemplate.Name = tostr(newName)
					button[btnName] = newName
					btnName = newName
				end
				function button:Remove()
					FUNC = function() end
					table.remove(button, table.find(button, btnName))
					ButtonTemplate:Destroy()
				end
				return button
			end

			function Section:Interactable(name, info, buttonName, func)
				local interactable = {}
				table.insert(interactable, name)
				local FUNC = func
				local InteractableTemplate = Instance.new('Frame')
				addTypeValue(InteractableTemplate, 'Interactable')
				InteractableTemplate.Name = tostr(name)
				InteractableTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				InteractableTemplate.Position = UDim2.new(-0.39, 0, -0.19, 0)
				InteractableTemplate.BorderSizePixel = 0
				InteractableTemplate.BackgroundColor3 = theme.ElementColor
				InteractableTemplate.ClipsDescendants = true
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = InteractableTemplate
				local Text = Instance.new('TextLabel')
				Text.Name = 'Text'
				Text.AnchorPoint = Vector2.new(0.22, 0.5)
				Text.Size = setElementSizeX(UDim2.new(0, 272, 0, 40))
				Text.BackgroundTransparency = 1
				Text.Position = UDim2.new(0.22, 0, 0, 20)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.FontSize = Enum.FontSize.Size14
				Text.TextSize = 14
				Text.TextColor3 = theme.TextColor
				Text.Text = tostr(name)
				Text.Font = Enum.Font.GothamMedium
				Text.TextXAlignment = Enum.TextXAlignment.Left
				Text.Parent = InteractableTemplate
				Text.TextTransparency = 0.1
				local Value = Instance.new('StringValue')
				Value.Value = 'X'
				Value.Parent = Text
				local Button = Instance.new('TextButton')
				Button.Name = 'Button'
				Button.Size = setElementSizeX(UDim2.new(0, 208, 0, 40))
				Button.BackgroundTransparency = 1
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.FontSize = Enum.FontSize.Size14
				Button.TextSize = 14
				Button.TextColor3 = Color3.fromRGB(0, 0, 0)
				Button.Text = ''
				Button.Font = Enum.Font.SourceSans
				Button.Parent = InteractableTemplate
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'X'
				Value1.Parent = Button
				local viewInfo = Instance.new("TextButton")
				viewInfo.Name = "viewInfo"
				viewInfo.AnchorPoint = Vector2.new(1, 0)
				viewInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(1, 0, 0, 0)
				viewInfo.Size = UDim2.new(0, 43, 0, 40)
				viewInfo.Font = Enum.Font.SourceSans
				viewInfo.Text = ""
				viewInfo.TextColor3 = Color3.fromRGB(0, 0, 0)
				viewInfo.TextSize = 14
				local ViewInfo = Instance.new("ImageLabel")
				ViewInfo.Name = "ViewInfo"
				ViewInfo.Active = true
				ViewInfo.AnchorPoint = Vector2.new(0.5, 0.5)
				ViewInfo.BackgroundTransparency = 1
				ViewInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
				ViewInfo.Selectable = true
				ViewInfo.Size = UDim2.new(0, 22, 0, 22)
				ViewInfo.Image = "rbxassetid://3926305904"
				ViewInfo.ImageColor3 = theme.TextColor
				ViewInfo.ImageRectOffset = Vector2.new(564, 284)
				ViewInfo.ImageRectSize = Vector2.new(36, 36)
				ViewInfo.Parent = viewInfo
				viewInfo.Parent = InteractableTemplate
				local Interactable = Instance.new('TextButton')
				Interactable.Name = 'Interactable'
				Interactable.AnchorPoint = Vector2.new(0.83, 0.5)
				Interactable.Size = UDim2.new(0, 75, 0, 25)
				Interactable.Position = UDim2.new(0.83, 0, 0, 20)
				Interactable.BackgroundColor3 = theme.SecondaryElementColor
				Interactable.AutoButtonColor = false
				Interactable.FontSize = Enum.FontSize.Size14
				Interactable.TextTransparency = 0.2
				Interactable.TextSize = 13
				Interactable.TextColor3 = theme.TextColor
				Interactable.Text = tostr(buttonName)
				Interactable.Font = Enum.Font.GothamMedium
				Interactable.Parent = InteractableTemplate
				local UICorner1 = Instance.new('UICorner')
				UICorner1.CornerRadius = UDim.new(0, 4)
				UICorner1.Parent = Interactable
				local Value2 = Instance.new('StringValue')
				Value2.Value = 'X'
				Value2.Parent = InteractableTemplate
				local Info = Instance.new('TextLabel')
				Info.Name = 'Info'
				Info.AnchorPoint = Vector2.new(0.5, 0.5)
				Info.Size = setElementSizeX(UDim2.new(0, 303, 0, 22))
				Info.BackgroundTransparency = 1
				Info.Position = UDim2.new(0.497, 0, 0, 47)
				Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Info.FontSize = Enum.FontSize.Size14
				Info.TextTransparency = 0.2
				Info.TextSize = 13
				Info.TextColor3 = theme.TextColor
				Info.Text = tostr(info)
				Info.Font = Enum.Font.Gotham
				Info.TextXAlignment = Enum.TextXAlignment.Left
				Info.Parent = InteractableTemplate
				local Value3 = Instance.new('StringValue')
				Value3.Value = 'X'
				Value3.Parent = Info
				enableRippleEffect(Interactable)
				enableRippleEffect(Button, InteractableTemplate)
				InteractableTemplate.Parent = SectionTemplate
				Interactable.MouseButton1Click:Connect(function()
					FUNC()
				end)
				local f, idk = false, 0.45
				local style, dir = Enum.EasingStyle.Quad, Enum.EasingDirection.InOut
				local a = function()
					f = not f
					if f then
						Tween(InteractableTemplate, idk, style, dir, {
							Size = UDim2.new(0, InteractableTemplate.Size.X.Offset, 0, 65)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 180,
							ImageColor3 = theme.SecondaryElementColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
					else
						Tween(InteractableTemplate, idk, style, dir, {
							Size = UDim2.new(0, InteractableTemplate.Size.X.Offset, 0, 40)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 0,
							ImageColor3 = theme.TextColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
					end
				end
				viewInfo.MouseButton1Click:Connect(a)
				Button.MouseButton1Click:Connect(a)
				function interactable:Edit(newName, newInfo, newButtonName, newFunc)
					FUNC = newFunc
					Info.Text = tostr(newInfo)
					Interactable.Text = tostr(newButtonName)
					Text.Text = tostr(newName)
					InteractableTemplate.Name = tostr(newName)
					interactable[name] = newName
					name = newName
				end
				function interactable:Remove()
					FUNC = function() end
					table.remove(interactable, table.find(interactable, name))
					InteractableTemplate:Destroy()
				end
				return interactable
			end

			function Section:Label(text)
				local label = {}
				table.insert(label, text)
				local LabelTemplate = Instance.new('Frame')
				addTypeValue(LabelTemplate, 'Label')
				LabelTemplate.Name = tostr(text)
				LabelTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				LabelTemplate.Position = UDim2.new(0, 0, 0.045, 0)
				LabelTemplate.BorderSizePixel = 0
				LabelTemplate.BackgroundColor3 = theme.ElementColor
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = LabelTemplate
				local Text = Instance.new('TextLabel')
				Text.Name = 'Text'
				Text.AnchorPoint = Vector2.new(0.5, 0.5)
				Text.Size = setElementSizeX(UDim2.new(0, 303, 0, 40))
				Text.BackgroundTransparency = 1
				Text.Position = UDim2.new(0.5, 0, 0, 20)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.FontSize = Enum.FontSize.Size14
				Text.TextSize = 14
				Text.TextColor3 = theme.TextColor
				Text.Font = Enum.Font.GothamMedium
				Text.TextXAlignment = Enum.TextXAlignment.Left
				Text.Parent = LabelTemplate
				Text.Text = tostr(text)
				Text.TextTransparency = 0.1
				local Value = Instance.new('StringValue')
				Value.Value = 'X'
				Value.Parent = Text
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'X'
				Value1.Parent = LabelTemplate
				LabelTemplate.Parent = SectionTemplate
				function label:Edit(newText)
					label[text] = newText
					text = newText
					Text.Text = tostr(text)
					LabelTemplate.Name = tostr(newText)
				end
				function label:Remove()
					table.remove(label, table.find(label, text))
					LabelTemplate:Destroy()
				end
				return label
			end
			function Section:Paragraph(name, name2)
				local paragraph = {}
				table.insert(paragraph, name)
				local ParagraphTemplate = Instance.new('Frame')
				addTypeValue(ParagraphTemplate, 'Paragraph')
				ParagraphTemplate.Name = tostr(name)
				ParagraphTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 55))
				ParagraphTemplate.Position = UDim2.new(0, 0, 0.9124088, 0)
				ParagraphTemplate.BorderSizePixel = 0
				ParagraphTemplate.BackgroundColor3 = theme.ElementColor
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = ParagraphTemplate
				local Text1 = Instance.new('TextLabel')
				Text1.Name = 'Text1'
				Text1.AnchorPoint = Vector2.new(0.22, 0.12)
				Text1.Size = setElementSizeX(UDim2.new(0, 272, 0, 25))
				Text1.BackgroundTransparency = 1
				Text1.Position = UDim2.new(0.22, 0, 0, 6)
				Text1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text1.FontSize = Enum.FontSize.Size14
				Text1.TextTransparency = 0.2
				Text1.TextSize = 14
				Text1.TextColor3 = theme.TextColor
				Text1.Text = tostr(name)
				Text1.Font = Enum.Font.GothamBold
				Text1.TextXAlignment = Enum.TextXAlignment.Left
				Text1.Parent = ParagraphTemplate
				local Value = Instance.new('StringValue')
				Value.Value = 'X'
				Value.Parent = Text1
				local Text2 = Instance.new('TextLabel')
				Text2.Name = 'Text2'
				Text2.AnchorPoint = Vector2.new(0.22, 0.88)
				Text2.Size = setElementSizeX(UDim2.new(0, 272, 0, 25))
				Text2.BackgroundTransparency = 1
				Text2.Position = UDim2.new(0.22, 0, 0, 48)
				Text2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text2.FontSize = Enum.FontSize.Size14
				Text2.TextTransparency = 0.2
				Text2.TextSize = 14
				Text2.TextColor3 = theme.TextColor
				Text2.Text = tostr(name2)
				Text2.Font = Enum.Font.Gotham
				Text2.TextXAlignment = Enum.TextXAlignment.Left
				Text2.Parent = ParagraphTemplate
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'X'
				Value1.Parent = Text2
				local Value2 = Instance.new('StringValue')
				Value2.Value = 'X'
				Value2.Parent = ParagraphTemplate
				ParagraphTemplate.Parent = SectionTemplate
				function paragraph:Edit(newName, newName2)
					paragraph[name] = newName
					Text1.Text = tostr(newName)
					Text2.Text = tostr(newName2)
					ParagraphTemplate.Name = tostr(newName)
					name = newName
				end
				function paragraph:Remove()
					table.remove(paragraph, table.find(paragraph, name))
					ParagraphTemplate:Destroy()
				end
				return paragraph
			end
			function Section:TextBox(name, info, defaulttext, func)
				local textbox = {}
				table.insert(textbox, name)
				local FUNC = func
				local TextBoxTemplate = Instance.new('Frame')
				addTypeValue(TextBoxTemplate, 'TextBox')
				TextBoxTemplate.Name = tostr(name)
				TextBoxTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				TextBoxTemplate.Position = UDim2.new(0, 0, 0.2, 0)
				TextBoxTemplate.BorderSizePixel = 0
				TextBoxTemplate.BackgroundColor3 = theme.ElementColor
				TextBoxTemplate.ClipsDescendants = true
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = TextBoxTemplate
				local Text = Instance.new('TextLabel')
				Text.Name = 'Text'
				Text.AnchorPoint = Vector2.new(0.08, 0.5)
				Text.Size = setElementSizeX(UDim2.new(0, 162, 0, 40))
				Text.BackgroundTransparency = 1
				Text.Position = UDim2.new(0.076, 0, 0, 20)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.FontSize = Enum.FontSize.Size14
				Text.TextSize = 14
				Text.TextColor3 = theme.TextColor
				Text.Text = tostr(name)
				Text.Font = Enum.Font.GothamMedium
				Text.TextXAlignment = Enum.TextXAlignment.Left
				Text.Parent = TextBoxTemplate
				Text.TextTransparency = 0.1
				local Value = Instance.new('StringValue')
				Value.Value = 'X'
				Value.Parent = Text
				local viewInfo = Instance.new("TextButton")
				viewInfo.Name = "viewInfo"
				viewInfo.AnchorPoint = Vector2.new(1, 0)
				viewInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(1, 0, 0, 0)
				viewInfo.Size = UDim2.new(0, 43, 0, 40)
				viewInfo.Font = Enum.Font.SourceSans
				viewInfo.Text = ""
				viewInfo.TextColor3 = Color3.fromRGB(0, 0, 0)
				viewInfo.TextSize = 14
				local ViewInfo = Instance.new("ImageLabel")
				ViewInfo.Name = "ViewInfo"
				ViewInfo.Active = true
				ViewInfo.AnchorPoint = Vector2.new(0.5, 0.5)
				ViewInfo.BackgroundTransparency = 1
				ViewInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
				ViewInfo.Selectable = true
				ViewInfo.Size = UDim2.new(0, 22, 0, 22)
				ViewInfo.Image = "rbxassetid://3926305904"
				ViewInfo.ImageColor3 = theme.TextColor
				ViewInfo.ImageRectOffset = Vector2.new(564, 284)
				ViewInfo.ImageRectSize = Vector2.new(36, 36)
				ViewInfo.Parent = viewInfo
				viewInfo.Parent = TextBoxTemplate
				local TextBox = Instance.new('TextBox')
				TextBox.Name = 'TextBox'
				TextBox.AnchorPoint = Vector2.new(0.8, 0.5)
				TextBox.Size = UDim2.new(0, 105, 0, 21)
				TextBox.Position = UDim2.new(0.8, 0, 0, 20)
				TextBox.BackgroundColor3 = theme.WindowColor
				TextBox.FontSize = Enum.FontSize.Size14
				TextBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
				TextBox.TextSize = 14
				TextBox.TextColor3 = theme.TextColor
				TextBox.TextTransparency = 0.1
				TextBox.Text = tostr(defaulttext)
				TextBox.Font = Enum.Font.Gotham
				TextBox.Parent = TextBoxTemplate
				local UICorner1 = Instance.new('UICorner')
				UICorner1.CornerRadius = UDim.new(0, 5)
				UICorner1.Parent = TextBox
				local UIStroke = Instance.new('UIStroke')
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke.Transparency = 1
				UIStroke.Color = theme.SecondaryElementColor
				UIStroke.Parent = TextBox
				local Info = Instance.new('TextLabel')
				Info.Name = 'Info'
				Info.AnchorPoint = Vector2.new(0.5, 0.5)
				Info.Size = setElementSizeX(UDim2.new(0, 303, 0, 22))
				Info.BackgroundTransparency = 1
				Info.Position = UDim2.new(0.497, 0, 0, 47)
				Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Info.FontSize = Enum.FontSize.Size14
				Info.TextTransparency = 0.2
				Info.TextSize = 13
				Info.TextColor3 = theme.TextColor
				Info.Text = tostr(info)
				Info.Font = Enum.Font.Gotham
				Info.TextXAlignment = Enum.TextXAlignment.Left
				Info.Parent = TextBoxTemplate
				local Value2 = Instance.new('StringValue')
				Value2.Value = 'X'
				Value2.Parent = Info
				local Value3 = Instance.new('StringValue')
				Value3.Value = 'X'
				Value3.Parent = TextBoxTemplate
				TextBoxTemplate.Parent = SectionTemplate
				enableRippleEffect(viewInfo, TextBoxTemplate)
				TextBox.FocusLost:Connect(function()
					FUNC(TextBox.Text)
					Tween(UIStroke, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Transparency = 1
					})
				end)
				TextBox.Focused:Connect(function()
					Tween(UIStroke, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Transparency = 0
					})
				end)
				local f, idk = false, 0.45
				local style, dir = Enum.EasingStyle.Quad, Enum.EasingDirection.InOut
				viewInfo.MouseButton1Click:Connect(function()
					f = not f
					if f then
						Tween(TextBoxTemplate, idk, style, dir, {
							Size = UDim2.new(0, TextBoxTemplate.Size.X.Offset, 0, 65)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 180,
							ImageColor3 = theme.SecondaryElementColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
					else
						Tween(TextBoxTemplate, idk, style, dir, {
							Size = UDim2.new(0, TextBoxTemplate.Size.X.Offset, 0, 40)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 0,
							ImageColor3 = theme.TextColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
					end
				end)
				function textbox:Edit(newName, newInfo, newDefaultText, newFunc)
					textbox[name] = newName
					TextBoxTemplate.Name = tostr(newName)
					Text.Text = tostr(newName)
					Info.Text = newInfo
					TextBox.Text = tostr(newDefaultText)
					FUNC = newFunc
					name = newName
				end
				function textbox:Remove()
					FUNC = function() end
					table.remove(textbox, table.find(textbox, name))
					TextBoxTemplate:Destroy()
				end
				return textbox
			end
			function Section:Slider(name, info, minvalue, maxvalue, defaultvalue, func)
				local slider = {}
				table.insert(slider, name)
				local FUNC = func
				local SliderTemplate = Instance.new('Frame')
				addTypeValue(SliderTemplate, 'Slider')
				SliderTemplate.Name = tostr(name)
				SliderTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 55))
				SliderTemplate.ClipsDescendants = true
				SliderTemplate.Position = UDim2.new(0, 0, 0.63, 0)
				SliderTemplate.BorderSizePixel = 0
				SliderTemplate.BackgroundColor3 = theme.ElementColor
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = SliderTemplate
				local viewInfo = Instance.new("TextButton")
				viewInfo.Name = "viewInfo"
				viewInfo.AnchorPoint = Vector2.new(1, 0)
				viewInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(1, 0, 0, 0)
				viewInfo.Size = UDim2.new(0, 43, 0, 40)
				viewInfo.Font = Enum.Font.SourceSans
				viewInfo.Text = ""
				viewInfo.TextColor3 = Color3.fromRGB(0, 0, 0)
				viewInfo.TextSize = 14
				local ViewInfo = Instance.new("ImageLabel")
				ViewInfo.Name = "ViewInfo"
				ViewInfo.Active = true
				ViewInfo.AnchorPoint = Vector2.new(0.5, 0.5)
				ViewInfo.BackgroundTransparency = 1
				ViewInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
				ViewInfo.Selectable = true
				ViewInfo.Size = UDim2.new(0, 22, 0, 22)
				ViewInfo.Image = "rbxassetid://3926305904"
				ViewInfo.ImageColor3 = theme.TextColor
				ViewInfo.ImageRectOffset = Vector2.new(564, 284)
				ViewInfo.ImageRectSize = Vector2.new(36, 36)
				ViewInfo.Parent = viewInfo
				viewInfo.Parent = SliderTemplate
				local Button = Instance.new('TextButton')
				Button.Name = 'Button'
				Button.Active = true
				Button.Size = setElementSizeX(UDim2.new(0, 328, 0, 55))
				Button.BackgroundTransparency = 1
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.FontSize = Enum.FontSize.Size14
				Button.TextSize = 14
				Button.TextColor3 = Color3.fromRGB(0, 0, 0)
				Button.Text = ''
				Button.Font = Enum.Font.SourceSans
				local Value = Instance.new('StringValue')
				Value.Value = 'X'
				Value.Parent = Button
				Button.Parent = SliderTemplate
				local Value = Instance.new('StringValue')
				Value.Value = 'X'
				Value.Parent = Button
				local Slider = Instance.new('TextButton')
				Slider.Name = 'Slider'
				Slider.Active = true
				Slider.AnchorPoint = Vector2.new(0.3, 0.75)
				Slider.Size = setElementSizeX(UDim2.new(0, 273, 0, 7))
				Slider.Position = UDim2.new(0.3, 0, 0, 41)
				Slider.BorderSizePixel = 0
				Slider.BackgroundColor3 = theme.WindowColor
				Slider.AutoButtonColor = false
				Slider.FontSize = Enum.FontSize.Size14
				Slider.TextSize = 14
				Slider.TextColor3 = Color3.fromRGB(0, 0, 0)
				Slider.Text = ''
				Slider.Font = Enum.Font.SourceSans
				Slider.Parent = SliderTemplate
				local UICorner1 = Instance.new('UICorner')
				UICorner1.CornerRadius = UDim.new(0, 69)
				UICorner1.Parent = Slider
				local Bar = Instance.new('Frame')
				Bar.Name = 'Bar'
				Bar.Selectable = true
				Bar.AnchorPoint = Vector2.new(0, 0.5)
				Bar.Size = UDim2.new(0, 102, 0, 7)
				Bar.Position = UDim2.new(0, 0, 0.5, 0)
				Bar.BorderSizePixel = 0
				Bar.BackgroundColor3 = theme.SecondaryElementColor
				Bar.Parent = Slider
				local UICorner2 = Instance.new('UICorner')
				UICorner2.CornerRadius = UDim.new(0, 69)
				UICorner2.Parent = Bar
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'X'
				Value1.Parent = Slider
				local SliderValue = Instance.new('TextBox')
				SliderValue.Name = 'Value'
				SliderValue.AnchorPoint = Vector2.new(1, 0.8)
				SliderValue.Size = UDim2.new(0, 27, 0, 15)
				SliderValue.BackgroundTransparency = 1
				SliderValue.Position = UDim2.new(1, 0, 0, 44)
				SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderValue.FontSize = Enum.FontSize.Size14
				SliderValue.TextSize = 14
				SliderValue.TextColor3 = theme.TextColor
				SliderValue.Text = '0'
				SliderValue.Font = Enum.Font.GothamMedium
				SliderValue.TextXAlignment = Enum.TextXAlignment.Left
				SliderValue.Parent = SliderTemplate
				local Text = Instance.new('TextLabel')
				Text.Name = 'Text'
				Text.AnchorPoint = Vector2.new(0.12, 0)
				Text.Size = setElementSizeX(UDim2.new(0, 213, 0, 35))
				Text.BackgroundTransparency = 1
				Text.Active = true
				Text.Position = UDim2.new(0.12, 0, 0, 0)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.FontSize = Enum.FontSize.Size14
				Text.TextSize = 14
				Text.TextColor3 = theme.TextColor
				Text.TextTransparency = 0.1 
				Text.Text = tostr(name)
				Text.Font = Enum.Font.GothamMedium
				Text.TextXAlignment = Enum.TextXAlignment.Left
				Text.Parent = SliderTemplate
				local Value3 = Instance.new('StringValue')
				Value3.Value = 'X'
				Value3.Parent = Text
				local Info = Instance.new('TextLabel')
				Info.Name = 'Info'
				Info.AnchorPoint = Vector2.new(0.5, 0.5)
				Info.Size = setElementSizeX(UDim2.new(0, 303, 0, 22))
				Info.BackgroundTransparency = 1
				Info.Position = UDim2.new(0.512, 0, 0, 61)
				Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Info.FontSize = Enum.FontSize.Size14
				Info.TextTransparency = 0.2
				Info.TextSize = 13
				Info.TextColor3 = theme.TextColor
				Info.Text = tostr(info)
				Info.Font = Enum.Font.Gotham
				Info.TextXAlignment = Enum.TextXAlignment.Left
				Info.Parent = SliderTemplate
				local Value4 = Instance.new('StringValue')
				Value4.Value = 'X'
				Value4.Parent = Info
				local Value5 = Instance.new('StringValue')
				Value5.Value = 'X'
				Value5.Parent = SliderTemplate
				SliderTemplate.Parent = SectionTemplate
				enableRippleEffect(Button)
				local bar = Bar
				local textbox = SliderValue
				local mouse = game.Players.LocalPlayer:GetMouse()
				local held = false
				local ev = 9e9
				local sv = -9e9
				local minval = minvalue
				local maxval = maxvalue
				local percentage = 0
				if maxval == 0 then
					maxval = 1 / string.rep(9e9*9e9, 10)
				end
				percentage = defaultvalue
				textbox.Text = tostr(defaultvalue)
				bar.Size = UDim2.new((defaultvalue - minval) / (maxval - minval), 0, 1, 0)
				Slider.MouseButton1Down:Connect(function()
					held = true
					Tween(bar, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Size = UDim2.new(math.clamp((mouse.X - Slider.AbsolutePosition.X)/Slider.AbsoluteSize.X,0,1),0,1,0)
					})
					task.wait(0.06)
					percentage = math.floor(((bar.Size.X.Scale * maxval) / maxval) * (maxval - minval) + minval)
					textbox.Text = percentage
				end)
				game:GetService('UserInputService').InputEnded:Connect(function(input, gp)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						held = false
					end
				end)
				mouse.Move:Connect(function()
					if held then
						Tween(bar, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(math.clamp((mouse.X - Slider.AbsolutePosition.X)/Slider.AbsoluteSize.X,0,1),0,1,0)
						})
						task.wait(0.06)
						percentage = math.floor(((bar.Size.X.Scale * maxval) / maxval) * (maxval - minval) + minval)
						textbox.Text = percentage
					end
				end)
				textbox.FocusLost:Connect(function()
					if typeof(tonumber(textbox.Text)) == 'number' then
						percentage = tonumber(textbox.Text)
						Tween(bar, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new((textbox.Text - minval) / (maxval - minval), 0, 1, 0)
						})
					else
						warn('Please enter a number')
						textbox.Text = percentage
					end
				end)
				local e = true
				textbox:GetPropertyChangedSignal('Text'):Connect(function()
					if e then
						FUNC(percentage)
					end
				end)
				local f, idk = false, 0.45
				local style, dir = Enum.EasingStyle.Quad, Enum.EasingDirection.InOut
				local a = function()
					f = not f
					if f then
						Tween(SliderTemplate, idk, style, dir, {
							Size = UDim2.new(0, SliderTemplate.Size.X.Offset, 0, 75)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 180,
							ImageColor3 = theme.SecondaryElementColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
					else
						Tween(SliderTemplate, idk, style, dir, {
							Size = UDim2.new(0, SliderTemplate.Size.X.Offset, 0, 55)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 0,
							ImageColor3 = theme.TextColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
					end
				end
				Button.MouseButton1Click:Connect(a)
				function slider:Edit(newName, newInfo, newMinVal, newMaxVal, newDefaultVal, newFunc)
					Info.Text = tostr(newInfo)
					minval = newMinVal
					maxval = newMaxVal
					e = false
					defaultvalue = newDefaultVal
					percentage = defaultvalue
					bar.Size = UDim2.new((defaultvalue - minval) / (maxval - minval), 0, 1, 0)
					Text.Text = tostr(newName)
					SliderTemplate.Name = tostr(newName)
					FUNC = newFunc
					e = true
					textbox.Text = defaultvalue
					slider[name] = newName
					name = newName
				end
				function slider:Remove()
					table.remove(slider, table.find(slider, name))
					FUNC = function() end
					SliderTemplate:Destroy()
				end
				return slider
			end
			function Section:ColorPicker(name, info, defaultcolor, func)
				local colorpicker = {}
				table.insert(colorpicker, name)
				local FUNC = func
				local ColorPickerTemplate = Instance.new('Frame')
				addTypeValue(ColorPickerTemplate, 'ColorPicker')
				ColorPickerTemplate.Name = tostr(name)
				ColorPickerTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				ColorPickerTemplate.ClipsDescendants = true
				ColorPickerTemplate.Position = UDim2.new(0.43, 0, 0.51, 0)
				ColorPickerTemplate.BorderSizePixel = 0
				ColorPickerTemplate.Active = true
				ColorPickerTemplate.BackgroundColor3 = theme.ElementColor
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = ColorPickerTemplate
				local viewInfo = Instance.new("TextButton")
				viewInfo.Name = "viewInfo"
				viewInfo.Active = true
				viewInfo.AnchorPoint = Vector2.new(1, 0)
				viewInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(1, 0, 0, 0)
				viewInfo.Size = UDim2.new(0, 43, 0, 40)
				viewInfo.Font = Enum.Font.SourceSans
				viewInfo.Text = ""
				viewInfo.TextColor3 = Color3.fromRGB(0, 0, 0)
				viewInfo.TextSize = 14
				local ViewInfo = Instance.new("ImageLabel")
				ViewInfo.Name = "ViewInfo"
				ViewInfo.Active = true
				ViewInfo.AnchorPoint = Vector2.new(0.5, 0.5)
				ViewInfo.BackgroundTransparency = 1
				ViewInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
				ViewInfo.Selectable = true
				ViewInfo.Size = UDim2.new(0, 22, 0, 22)
				ViewInfo.Image = "rbxassetid://3926305904"
				ViewInfo.ImageColor3 = theme.TextColor
				ViewInfo.ImageRectOffset = Vector2.new(564, 284)
				ViewInfo.ImageRectSize = Vector2.new(36, 36)
				ViewInfo.Parent = viewInfo
				viewInfo.Parent = ColorPickerTemplate
				local Button = Instance.new('TextButton')
				Button.Name = 'Button'
				Button.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				Button.BackgroundTransparency = 1
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.FontSize = Enum.FontSize.Size14
				Button.TextSize = 14
				Button.ZIndex = 2
				Button.TextColor3 = Color3.fromRGB(0, 0, 0)
				Button.Text = ''
				Button.Font = Enum.Font.SourceSans
				Button.Parent = ColorPickerTemplate
				local Value77777 = Instance.new('StringValue')
				Value77777.Value = 'X'
				Value77777.Parent = Button
				local Value77777 = Instance.new('StringValue')
				Value77777.Value = 'X'
				Value77777.Parent = ColorPickerTemplate
				local Text = Instance.new('TextLabel')
				Text.Name = 'Text'
				Text.AnchorPoint = Vector2.new(0.12, 0.5)
				Text.Size = setElementSizeX(UDim2.new(0, 213, 0, 40))
				Text.BackgroundTransparency = 1
				Text.Position = UDim2.new(0.12, 0, 0, 20)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.FontSize = Enum.FontSize.Size14
				Text.TextSize = 14
				Text.Active = true
				Text.TextColor3 = theme.TextColor
				Text.Text = tostr(name)
				Text.TextTransparency = 0.1
				Text.Font = Enum.Font.GothamMedium
				Text.TextXAlignment = Enum.TextXAlignment.Left
				Text.Parent = ColorPickerTemplate
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'X'
				Value1.Parent = Text
				local Info = Instance.new('TextLabel')
				Info.Name = 'Info'
				Info.AnchorPoint = Vector2.new(0.5, 1)
				Info.Size = setElementSizeX(UDim2.new(0, 300, 0, 25))
				Info.BackgroundTransparency = 1
				Info.Position = UDim2.new(0.5, 0, 0, 203)
				Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Info.FontSize = Enum.FontSize.Size14
				Info.TextTransparency = 0.2
				Info.TextSize = 13
				Info.Active = true
				Info.TextColor3 = theme.TextColor
				Info.Text = tostr(info)
				Info.TextYAlignment = Enum.TextYAlignment.Top
				Info.Font = Enum.Font.Gotham
				Info.TextXAlignment = Enum.TextXAlignment.Left
				Info.Parent = ColorPickerTemplate
				local Value2 = Instance.new('StringValue')
				Value2.Value = 'X'
				Value2.Parent = Info
				local Preview = Instance.new('Frame')
				Preview.Name = 'Preview'
				Preview.ZIndex = 4
				Preview.Active = true
				Preview.AnchorPoint = Vector2.new(0.5, 0.54)
				Preview.Size = UDim2.new(0, 20, 0, 119)
				Preview.BorderColor3 = Color3.fromRGB(40, 40, 40)
				Preview.Position = UDim2.new(0, 303, 0, 110)
				Preview.BorderSizePixel = 2
				Preview.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Preview.Parent = ColorPickerTemplate
				local UICorner1 = Instance.new('UICorner')
				UICorner1.CornerRadius = UDim.new(0, 4)
				UICorner1.Parent = Preview
				local RGB = Instance.new('ImageLabel')
				RGB.Name = 'RGB'
				RGB.ZIndex = 4
				RGB.AnchorPoint = Vector2.new(0.5, 0.54)
				RGB.Size = UDim2.new(0, 238, 0, 119)
				RGB.BorderColor3 = Color3.fromRGB(40, 40, 40)
				RGB.Position = UDim2.new(0, 135, 0, 110)
				RGB.BorderSizePixel = 2
				RGB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				RGB.Image = 'rbxassetid://1433361550'
				RGB.SliceCenter = Rect.new(10, 10, 90, 90)
				RGB.Parent = ColorPickerTemplate
				local Marker = Instance.new('Frame')
				Marker.Name = 'Marker'
				Marker.ZIndex = 5
				Marker.AnchorPoint = Vector2.new(0.5, 0.5)
				Marker.Size = UDim2.new(0, 7, 0, 7)
				Marker.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Marker.Position = UDim2.new(0.5, 0, 1, 0)
				Marker.BorderSizePixel = 2
				Marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Marker.Parent = RGB
				local UICorner2 = Instance.new('UICorner')
				UICorner2.Parent = Marker
				local UIStroke = Instance.new('UIStroke')
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke.Thickness = 2
				UIStroke.Color = theme.WindowColor
				UIStroke.Parent = Marker
				local UICorner3 = Instance.new('UICorner')
				UICorner3.CornerRadius = UDim.new(0, 5)
				UICorner3.Parent = RGB
				local CoolValue = Instance.new('ImageLabel')
				CoolValue.Name = 'CoolValue'
				CoolValue.ZIndex = 4
				CoolValue.AnchorPoint = Vector2.new(0.5, 0.54)
				CoolValue.Size = UDim2.new(0, 20, 0, 119)
				CoolValue.BorderColor3 = Color3.fromRGB(40, 40, 40)
				CoolValue.Position = UDim2.new(0, 273, 0, 110)
				CoolValue.BorderSizePixel = 0
				CoolValue.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				CoolValue.Image = 'rbxassetid://359311684'
				CoolValue.SliceCenter = Rect.new(10, 10, 90, 90)
				CoolValue.Parent = ColorPickerTemplate
				local Marker1 = Instance.new('Frame')
				Marker1.Name = 'Marker'
				Marker1.ZIndex = 5
				Marker1.AnchorPoint = Vector2.new(0.5, 0.5)
				Marker1.Size = UDim2.new(1, 4, 0.0244559, 2)
				Marker1.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Marker1.Position = UDim2.new(0.4999993, 0, 0.0122279, 0)
				Marker1.BorderSizePixel = 2
				Marker1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Marker1.Parent = CoolValue
				local UICorner4 = Instance.new('UICorner')
				UICorner4.Parent = Marker1
				local UIStroke1 = Instance.new('UIStroke')
				UIStroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke1.Thickness = 2
				UIStroke1.Color = theme.WindowColor
				UIStroke1.Parent = Marker1
				local ApplyButton = Instance.new('TextButton')
				ApplyButton.Name = 'ApplyButton'
				ApplyButton.AnchorPoint = Vector2.new(0.94, 0.97)
				ApplyButton.AutoButtonColor = false
				ApplyButton.Size = UDim2.new(0, 85, 0, 23)
				ApplyButton.Position = UDim2.new(0, 308, 0, 194)
				ApplyButton.BackgroundColor3 = theme.SecondaryElementColor
				ApplyButton.FontSize = Enum.FontSize.Size14
				ApplyButton.TextSize = 14
				ApplyButton.Active = true
				ApplyButton.TextColor3 = theme.TextColor
				ApplyButton.Text = 'Apply'
				ApplyButton.Font = Enum.Font.GothamMedium
				ApplyButton.Parent = ColorPickerTemplate
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = ApplyButton
				ColorPickerTemplate.Parent = SectionTemplate
				enableRippleEffect(ApplyButton)
				enableRippleEffect(Button)
				local player = game.Players.LocalPlayer
				local mouse = player:GetMouse()
				local UIS = game:GetService('UserInputService')
				local rgb = ColorPickerTemplate:WaitForChild('RGB')
				local value = ColorPickerTemplate:WaitForChild('CoolValue')
				local preview = ColorPickerTemplate:WaitForChild('Preview')
				local selectedColor = Color3.fromHSV(1,1,1)
				local colorData = {1,1,1}
				local mouse1down = false
				local mouse1down2 = false
				Preview.BackgroundColor3 = defaultcolor
				CoolValue.ImageColor3 = defaultcolor
				local function setColor(hue,sat,val)
					colorData = {hue or colorData[1],sat or colorData[2],val or colorData[3]}
					selectedColor = Color3.fromHSV(colorData[1],colorData[2],colorData[3])
					preview.BackgroundColor3 = selectedColor
					value.ImageColor3 = Color3.fromHSV(colorData[1],colorData[2],1)
				end
				local function inBounds(frame)
					local x,y = mouse.X - frame.AbsolutePosition.X,mouse.Y - frame.AbsolutePosition.Y
					local maxX,maxY = frame.AbsoluteSize.X,frame.AbsoluteSize.Y
					if x >= 0 and y >= 0 and x <= maxX and y <= maxY then
						return x/maxX,y/maxY
					end
				end
				local function updateRGB()
					if mouse1down then
						local x,y = inBounds(rgb)
						if x and y then
							rgb:WaitForChild('Marker').Position = UDim2.new(x,0,y,0)
							setColor(1 - x,1 - y)
						end
					elseif mouse1down2 then
						local x,y = inBounds(value)
						if x and y then
							value:WaitForChild('Marker').Position = UDim2.new(0.5,0,y,0)
							setColor(nil,nil,1 - y)
						end
					end
				end
				RGB.InputBegan:Connect(function(input)
					if mouse1down2 == false then
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							mouse1down = true
							input.Changed:Connect(function()
								if input.UserInputState == Enum.UserInputState.End then
									mouse1down = false
								end
							end)
						end
					end
				end)
				CoolValue.InputBegan:Connect(function(input)
					if mouse1down == false then
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							mouse1down2 = true
							input.Changed:Connect(function()
								if input.UserInputState == Enum.UserInputState.End then
									mouse1down2 = false
								end
							end)
						end
					end
				end)
				UIS.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						if mouse1down or mouse1down2 then
							updateRGB()
						end
					end
				end)
				ApplyButton.MouseButton1Click:Connect(function()
					FUNC(Preview.BackgroundColor3)
				end)
				local f, idk = false, 0.45
				local style, dir = Enum.EasingStyle.Quad, Enum.EasingDirection.InOut
				local a = function()
					f = not f
					if f then
						Tween(ColorPickerTemplate, idk, style, dir, {
							Size = UDim2.new(0, ColorPickerTemplate.Size.X.Offset, 0, 200)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 180,
							ImageColor3 = theme.SecondaryElementColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
					else
						Tween(ColorPickerTemplate, idk, style, dir, {
							Size = UDim2.new(0, ColorPickerTemplate.Size.X.Offset, 0, 40)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 0,
							ImageColor3 = theme.TextColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
					end
				end
				Button.MouseButton1Click:Connect(a)
				function colorpicker:Edit(newName, newInfo, newDefaultColor, newFunc)
					colorpicker[name] = newName
					FUNC = newFunc
					Text.Text = tostr(newName)
					Info.Text = tostr(newInfo)
					ColorPickerTemplate.Name = tostr(newName)
					Preview.BackgroundColor3 = newDefaultColor
					name = newName
				end

				function colorpicker:Remove()
					table.remove(colorpicker, table.find(colorpicker, name))
					FUNC = function() end
					ColorPickerTemplate:Destroy()
				end
				return colorpicker
			end
			function Section:Toggle(name, info, Toggled, func)
				local FUNC = func
				local toggle = {}
				table.insert(toggle, name)
				local toggled = Toggled
				local ToggleTemplate = Instance.new('Frame')
				addTypeValue(ToggleTemplate, 'Toggle')
				ToggleTemplate.Name = tostr(name)
				ToggleTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				ToggleTemplate.ClipsDescendants = true
				ToggleTemplate.Position = UDim2.new(0.43, 0, 0.45, 0)
				ToggleTemplate.BorderSizePixel = 0
				ToggleTemplate.BackgroundColor3 = theme.ElementColor
				local Value0 = Instance.new('StringValue')
				Value0.Value = 'X'
				Value0.Parent = ToggleTemplate
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = ToggleTemplate
				local viewInfo = Instance.new("TextButton")
				viewInfo.Name = "viewInfo"
				viewInfo.AnchorPoint = Vector2.new(1, 0)
				viewInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(1, 0, 0, 0)
				viewInfo.Size = UDim2.new(0, 43, 0, 40)
				viewInfo.Font = Enum.Font.SourceSans
				viewInfo.Text = ""
				viewInfo.TextColor3 = Color3.fromRGB(0, 0, 0)
				viewInfo.TextSize = 14
				local ViewInfo = Instance.new("ImageLabel")
				ViewInfo.Name = "ViewInfo"
				ViewInfo.Active = true
				ViewInfo.AnchorPoint = Vector2.new(0.5, 0.5)
				ViewInfo.BackgroundTransparency = 1
				ViewInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
				ViewInfo.Selectable = true
				ViewInfo.Size = UDim2.new(0, 22, 0, 22)
				ViewInfo.Image = "rbxassetid://3926305904"
				ViewInfo.ImageColor3 = theme.TextColor
				ViewInfo.ImageRectOffset = Vector2.new(564, 284)
				ViewInfo.ImageRectSize = Vector2.new(36, 36)
				ViewInfo.Parent = viewInfo
				viewInfo.Parent = ToggleTemplate
				local Button2 = Instance.new("TextButton")
				Button2.Name = "Button2"
				Button2.Size = setElementSizeX(UDim2.new(0, 290, 0, 40))
				Button2.BackgroundTransparency = 1
				Button2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button2.FontSize = Enum.FontSize.Size14
				Button2.TextSize = 14
				Button2.TextColor3 = Color3.fromRGB(0, 0, 0)
				Button2.Text = ""
				Button2.Font = Enum.Font.SourceSans
				Button2.Parent = ToggleTemplate
				local Value = Instance.new('StringValue')
				Value.Value = 'X'
				Value.Parent = Button2
				local Text = Instance.new('TextLabel')
				Text.Name = 'Text'
				Text.AnchorPoint = Vector2.new(0.12, 0.5)
				Text.Size = setElementSizeX(UDim2.new(0, 213, 0, 40))
				Text.BackgroundTransparency = 1
				Text.Position = UDim2.new(0.12, 0, 0, 20)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.FontSize = Enum.FontSize.Size14
				Text.TextSize = 14
				Text.TextColor3 = theme.TextColor
				Text.TextTransparency = 0.1
				Text.Text = tostr(name)
				Text.Font = Enum.Font.GothamMedium
				Text.TextXAlignment = Enum.TextXAlignment.Left
				Text.Parent = ToggleTemplate
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'X'
				Value1.Parent = Text
				local Info = Instance.new('TextLabel')
				Info.Name = 'Info'
				Info.AnchorPoint = Vector2.new(0.5, 0.5)
				Info.Size = setElementSizeX(UDim2.new(0, 303, 0, 22))
				Info.BackgroundTransparency = 1
				Info.Position = UDim2.new(0.497, 0, 0, 47)
				Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Info.FontSize = Enum.FontSize.Size14
				Info.TextTransparency = 0.2
				Info.TextSize = 13
				Info.TextColor3 = theme.TextColor
				Info.Text = tostr(info)
				Info.Font = Enum.Font.Gotham
				Info.TextXAlignment = Enum.TextXAlignment.Left
				Info.Parent = ToggleTemplate
				local Value2 = Instance.new('StringValue')
				Value2.Value = 'X'
				Value2.Parent = Info
				local Toggle = Instance.new('Frame')
				Toggle.Name = 'Toggle'
				Toggle.AnchorPoint = Vector2.new(0.86, 0.5)
				Toggle.Size = UDim2.new(0, 23, 0, 23)
				Toggle.Position = UDim2.new(0.86, 0, 0, 20)
				Toggle.BackgroundColor3 = theme.WindowColor
				Toggle.BorderSizePixel = 0
				Toggle.Parent = ToggleTemplate
				local UICorner1 = Instance.new('UICorner')
				UICorner1.CornerRadius = UDim.new(0, 5)
				UICorner1.Parent = Toggle
				local UIStroke = Instance.new('UIStroke')
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke.Transparency = 1
				UIStroke.Color = theme.TextColor
				UIStroke.Parent = Toggle
				local Checkmark = Instance.new('ImageLabel')
				Checkmark.Name = 'Checkmark'
				Checkmark.LayoutOrder = 5
				Checkmark.Selectable = true
				Checkmark.BackgroundTransparency = 1
				Checkmark.BorderSizePixel = 0
				Checkmark.ImageColor3 = theme.TextColor
				Checkmark.AnchorPoint = Vector2.new(0.5, 0.4)
				Checkmark.Size = UDim2.new(0, 18, 0, 18)
				if toggled then
					Checkmark.ImageTransparency = 0
				else
					Checkmark.ImageTransparency = 1
				end
				Checkmark.Position = UDim2.new(0.5, 0, 0.4, 0)
				Checkmark.Active = true
				Checkmark.ImageRectOffset = Vector2.new(312, 4)
				Checkmark.ImageRectSize = Vector2.new(24, 24)
				Checkmark.Image = 'rbxassetid://3926305904'
				Checkmark.ImageColor3 = theme.TextColor
				Checkmark.Parent = Toggle
				local ToggleBtn = Instance.new('TextButton')
				ToggleBtn.Name = 'ToggleBtn'
				ToggleBtn.AnchorPoint = Vector2.new(0.5, 0.5)
				ToggleBtn.Size = UDim2.new(0, 23, 0, 23)
				ToggleBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
				ToggleBtn.BackgroundTransparency = 1
				ToggleBtn.AutoButtonColor = false
				ToggleBtn.BorderSizePixel = 0
				ToggleBtn.Text = ''
				ToggleBtn.Parent = Toggle
				ToggleTemplate.Parent = SectionTemplate
				local f, idk = false, 0.45
				local style, dir = Enum.EasingStyle.Quad, Enum.EasingDirection.InOut
				local a = function()
					f = not f
					if f then
						Tween(ToggleTemplate, idk, style, dir, {
							Size = UDim2.new(0, ToggleTemplate.Size.X.Offset, 0, 65)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 180,
							ImageColor3 = theme.SecondaryElementColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
					else
						Tween(ToggleTemplate, idk, style, dir, {
							Size = UDim2.new(0, ToggleTemplate.Size.X.Offset, 0, 40)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 0,
							ImageColor3 = theme.TextColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
					end
				end
				Button2.MouseButton1Click:Connect(a)
				ToggleBtn.MouseButton1Click:Connect(function()
					Toggled = not Toggled
					FUNC(Toggled)
					if Toggled then
						Tween(Checkmark, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							ImageTransparency = 0
						})
					else
						Tween(Checkmark, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							ImageTransparency = 1
						})
					end
				end)
				function toggle:Edit(newName, newInfo, newToggled, newFunc)
					FUNC = newFunc
					toggle[name] = newName
					ToggleTemplate.Name = tostr(newName)
					Info.Text = tostr(newInfo)
					Text.Text = tostr(newName)
					Toggled = newToggled
					name = newName
					if Toggled then
						Tween(Checkmark, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							ImageTransparency = 0
						})
					else
						Tween(Checkmark, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							ImageTransparency = 1
						})
					end
				end
				function toggle:Remove()
					FUNC = function() end
					table.remove(toggle, table.find(toggle, name))
					ToggleTemplate:Destroy()
				end
				return toggle
			end
			function Section:Switch(name, info, Toggled, func)
				local FUNC = func
				local switch = {}
				table.insert(switch, name)
				local SwitchTemplate = Instance.new('Frame')
				addTypeValue(SwitchTemplate, 'Switch')
				SwitchTemplate.Name = tostr(name)
				SwitchTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				SwitchTemplate.ClipsDescendants = true
				SwitchTemplate.Position = UDim2.new(0.43, 0, 0.38, 0)
				SwitchTemplate.BorderSizePixel = 0
				SwitchTemplate.BackgroundColor3 = theme.ElementColor
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = SwitchTemplate
				local viewInfo = Instance.new("TextButton")
				viewInfo.Name = "viewInfo"
				viewInfo.AnchorPoint = Vector2.new(1, 0)
				viewInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(1, 0, 0, 0)
				viewInfo.Size = UDim2.new(0, 43, 0, 40)
				viewInfo.Font = Enum.Font.SourceSans
				viewInfo.Text = ""
				viewInfo.TextColor3 = Color3.fromRGB(0, 0, 0)
				viewInfo.TextSize = 14
				local ViewInfo = Instance.new("ImageLabel")
				ViewInfo.Name = "ViewInfo"
				ViewInfo.Active = true
				ViewInfo.AnchorPoint = Vector2.new(0.5, 0.5)
				ViewInfo.BackgroundTransparency = 1
				ViewInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
				ViewInfo.Selectable = true
				ViewInfo.Size = UDim2.new(0, 22, 0, 22)
				ViewInfo.Image = "rbxassetid://3926305904"
				ViewInfo.ImageColor3 = theme.TextColor
				ViewInfo.ImageRectOffset = Vector2.new(564, 284)
				ViewInfo.ImageRectSize = Vector2.new(36, 36)
				ViewInfo.Parent = viewInfo
				viewInfo.Parent = SwitchTemplate
				local Switch = Instance.new('Frame')
				Switch.Name = 'Switch'
				Switch.AnchorPoint = Vector2.new(0.85, 0.5)
				Switch.Size = UDim2.new(0, 42, 0, 20)
				Switch.Position = UDim2.new(0.85, 0, 0, 20)
				Switch.BorderSizePixel = 0
				if Toggled then
					Switch.BackgroundColor3 = theme.SecondaryElementColor
				else
					Switch.BackgroundColor3 = theme.WindowColor
				end
				Switch.Parent = SwitchTemplate
				local UICorner1 = Instance.new('UICorner')
				UICorner1.CornerRadius = UDim.new(0, 10)
				UICorner1.Parent = Switch
				local Circle = Instance.new('TextButton')
				Circle.Name = 'Circle'
				Circle.AnchorPoint = Vector2.new(1, 0.5)
				Circle.Size = UDim2.new(0, 16, 0, 16)
				Circle.BorderSizePixel = 0
				Circle.BackgroundColor3 = theme.TextColor
				if Toggled then
					Circle.Position = UDim2.new(0.94, 0, 0.5, 0)
				else
					Circle.Position = UDim2.new(0.43, 0, 0.5, 0)
				end
				Circle.AutoButtonColor = false
				Circle.FontSize = Enum.FontSize.Size14
				Circle.TextSize = 14
				Circle.TextColor3 = Color3.fromRGB(0, 0, 0)
				Circle.Text = ''
				Circle.Font = Enum.Font.SourceSans
				Circle.Parent = Switch
				viewInfo.Parent = SwitchTemplate
				local Button2 = Instance.new("TextButton")
				Button2.Name = "Button2"
				Button2.Size = setElementSizeX(UDim2.new(0, 290, 0, 40))
				Button2.BackgroundTransparency = 1
				Button2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button2.FontSize = Enum.FontSize.Size14
				Button2.TextSize = 14
				Button2.TextColor3 = Color3.fromRGB(0, 0, 0)
				Button2.Text = ""
				Button2.Font = Enum.Font.SourceSans
				local Value = Instance.new("StringValue")
				Value.Value = "X"
				Value.Parent = Button2
				Button2.Parent = SwitchTemplate
				local Text = Instance.new('TextLabel')
				Text.Name = 'Text'
				Text.AnchorPoint = Vector2.new(0.12, 0.5)
				Text.Size = setElementSizeX(UDim2.new(0, 213, 0, 40))
				Text.BackgroundTransparency = 1
				Text.Position = UDim2.new(0.12, 0, 0, 20)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.FontSize = Enum.FontSize.Size14
				Text.TextSize = 14
				Text.TextColor3 = theme.TextColor
				Text.Text = tostr(name)
				Text.Font = Enum.Font.GothamMedium
				Text.TextTransparency = 0.1
				Text.TextXAlignment = Enum.TextXAlignment.Left
				Text.Parent = SwitchTemplate
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'X'
				Value1.Parent = Text
				local Info = Instance.new('TextLabel')
				Info.Name = 'Info'
				Info.AnchorPoint = Vector2.new(0.5, 0.5)
				Info.Size = setElementSizeX(UDim2.new(0, 303, 0, 22))
				Info.BackgroundTransparency = 1
				Info.Position = UDim2.new(0.497, 0, 0, 47)
				Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Info.FontSize = Enum.FontSize.Size14
				Info.TextTransparency = 0.2
				Info.TextSize = 13
				Info.TextColor3 = theme.TextColor
				Info.Text = tostr(info)
				Info.Font = Enum.Font.Gotham
				Info.TextXAlignment = Enum.TextXAlignment.Left
				Info.Parent = SwitchTemplate
				local Value2 = Instance.new('StringValue')
				Value2.Value = 'X'
				Value2.Parent = Info
				local UICorner2 = Instance.new('UICorner')
				UICorner2.CornerRadius = UDim.new(0, 10)
				UICorner2.Parent = Circle
				local Value3 = Instance.new('StringValue')
				Value3.Value = 'X'
				Value3.Parent = SwitchTemplate
				local BoolValue = Instance.new('BoolValue')
				BoolValue.Value = Toggled
				BoolValue.Name = 'Toggled'
				BoolValue.Parent = SwitchTemplate
				SwitchTemplate.Parent = SectionTemplate
				local f, idk = false, 0.45
				local style, dir = Enum.EasingStyle.Quad, Enum.EasingDirection.InOut
				local a = function()
					f = not f
					if f then
						Tween(SwitchTemplate, idk, style, dir, {
							Size = UDim2.new(0, SwitchTemplate.Size.X.Offset, 0, 65)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 180,
							ImageColor3 = theme.SecondaryElementColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
					else
						Tween(SwitchTemplate, idk, style, dir, {
							Size = UDim2.new(0, SwitchTemplate.Size.X.Offset, 0, 40)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 0,
							ImageColor3 = theme.TextColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
					end
				end
				viewInfo.MouseButton1Click:Connect(a)
				Button2.MouseButton1Click:Connect(function()
					Toggled = not Toggled
					BoolValue.Value = Toggled
					FUNC(Toggled)
					if Toggled then
						Tween(Circle, 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, {
							Position = UDim2.new(0.94, 0, 0.5, 0),
						})
						Tween(Switch, 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, {
							BackgroundColor3 = theme.SecondaryElementColor
						})
					else
						Tween(Circle, 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, {
							Position = UDim2.new(0.44, 0, 0.5, 0)
						})
						Tween(Switch, 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, {
							BackgroundColor3 = theme.WindowColor
						})
					end
				end)
				function switch:Edit(newName, newInfo, newToggled, newFunc)
					FUNC = newFunc
					switch[name] = newName
					SwitchTemplate.Name = tostr(newName)
					Info.Text = tostr(newInfo)
					Text.Text = tostr(newName)
					Toggled = newToggled
					BoolValue.Value = Toggled
					name = newName
					if Toggled then
						Tween(Circle, 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, {
							Position = UDim2.new(0.94, 0, 0.5, 0),
						})
						Tween(Switch, 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, {
							BackgroundColor3 = theme.SecondaryElementColor
						})
					else
						Tween(Circle, 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, {
							Position = UDim2.new(0.44, 0, 0.5, 0)
						})
						Tween(Switch, 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, {
							BackgroundColor3 = theme.WindowColor
						})
					end
				end
				function switch:Remove()
					FUNC = function() end
					table.remove(switch, table.find(switch, name))
					SwitchTemplate:Destroy()
				end
				return switch
			end
			function Section:Keybind(name, info, defaultkey, func)
				local FUNC = func
				local keybind = {}
				table.insert(keybind, name)
				local device = checkDevice()
				local keybindinput = nil
				local KeybindTemplate = Instance.new('Frame')
				addTypeValue(KeybindTemplate, 'Keybind')
				KeybindTemplate.Name = tostr(name)
				KeybindTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				KeybindTemplate.ClipsDescendants = true
				KeybindTemplate.Position = UDim2.new(0.433, 0, 0.385, 0)
				KeybindTemplate.BorderSizePixel = 0
				KeybindTemplate.BackgroundColor3 = theme.ElementColor
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = KeybindTemplate
				local viewInfo = Instance.new("TextButton")
				viewInfo.Name = "viewInfo"
				viewInfo.AnchorPoint = Vector2.new(1, 0)
				viewInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(1, 0, 0, 0)
				viewInfo.Size = UDim2.new(0, 43, 0, 40)
				viewInfo.Font = Enum.Font.SourceSans
				viewInfo.Text = ""
				viewInfo.TextColor3 = Color3.fromRGB(0, 0, 0)
				viewInfo.TextSize = 14
				local ViewInfo = Instance.new("ImageLabel")
				ViewInfo.Name = "ViewInfo"
				ViewInfo.Active = true
				ViewInfo.AnchorPoint = Vector2.new(0.5, 0.5)
				ViewInfo.BackgroundTransparency = 1
				ViewInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
				ViewInfo.Selectable = true
				ViewInfo.Size = UDim2.new(0, 22, 0, 22)
				ViewInfo.Image = "rbxassetid://3926305904"
				ViewInfo.ImageColor3 = theme.TextColor
				ViewInfo.ImageRectOffset = Vector2.new(564, 284)
				ViewInfo.ImageRectSize = Vector2.new(36, 36)
				ViewInfo.Parent = viewInfo
				viewInfo.Parent = KeybindTemplate
				local Button = Instance.new('TextButton')
				Button.Name = 'Button'
				Button.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				Button.BackgroundTransparency = 1
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.FontSize = Enum.FontSize.Size14
				Button.TextSize = 14
				Button.TextColor3 = Color3.fromRGB(0, 0, 0)
				Button.Text = ''
				Button.Font = Enum.Font.SourceSans
				Button.Parent = KeybindTemplate
				local Value = Instance.new('StringValue')
				Value.Value = 'X'
				Value.Parent = Button
				local Text = Instance.new('TextLabel')
				Text.Name = 'Text'
				Text.AnchorPoint = Vector2.new(0.12, 0.5)
				Text.Size = setElementSizeX(UDim2.new(0, 213, 0, 40))
				Text.BackgroundTransparency = 1
				Text.Position = UDim2.new(0.12, 0, 0, 20)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.FontSize = Enum.FontSize.Size14
				Text.TextSize = 14
				Text.TextColor3 = theme.TextColor
				Text.Text = tostr(name)
				Text.Font = Enum.Font.GothamMedium
				Text.TextTransparency = 0.1
				Text.TextXAlignment = Enum.TextXAlignment.Left
				Text.Parent = KeybindTemplate
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'X'
				Value1.Parent = Text
				if device == 'Mobile' then
					local MobileKeybind = Instance.new('TextBox')
					MobileKeybind.Name = 'Keybind'
					MobileKeybind.AnchorPoint = Vector2.new(0.85, 0.5)
					MobileKeybind.Size = UDim2.new(0, 44, 0, 24)
					MobileKeybind.Position = UDim2.new(0.85, 0, 0, 20)
					MobileKeybind.BackgroundColor3 = theme.WindowColor
					MobileKeybind.FontSize = Enum.FontSize.Size14
					MobileKeybind.TextSize = 14
					MobileKeybind.TextColor3 = theme.TextColor
					MobileKeybind.TextTransparency = 0.2
					MobileKeybind.Text = defaultkey
					MobileKeybind.Font = Enum.Font.GothamSemibold
					MobileKeybind.MultiLine = true
					MobileKeybind.Parent = KeybindTemplate
					local UICorner1 = Instance.new('UICorner')
					UICorner1.CornerRadius = UDim.new(0, 4)
					UICorner1.Parent = MobileKeybind
					local UIStroke = Instance.new('UIStroke')
					UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					UIStroke.Transparency = 1
					UIStroke.Color = theme.SecondaryElementColor
					UIStroke.Parent = MobileKeybind
					keybindinput = MobileKeybind
				end
				if device == 'PC' then
					local Keybind = Instance.new('TextButton')
					Keybind.Name = 'Keybind'
					Keybind.AnchorPoint = Vector2.new(0.85, 0.5)
					Keybind.Size = UDim2.new(0, 44, 0, 24)
					Keybind.Position = UDim2.new(0.85, 0, 0, 20)
					Keybind.BackgroundColor3 = theme.WindowColor
					Keybind.AutoButtonColor = false
					Keybind.FontSize = Enum.FontSize.Size14
					Keybind.TextTransparency = 0.2
					Keybind.TextSize = 14
					Keybind.TextColor3 = theme.TextColor
					Keybind.Text = defaultkey
					Keybind.Font = Enum.Font.GothamSemibold
					Keybind.Parent = KeybindTemplate
					local UICorner2 = Instance.new('UICorner')
					UICorner2.CornerRadius = UDim.new(0, 4)
					UICorner2.Parent = Keybind
					local UIStroke = Instance.new('UIStroke')
					UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					UIStroke.Transparency = 1
					UIStroke.Color = theme.SecondaryElementColor
					UIStroke.Parent = Keybind
					keybindinput = Keybind
				end
				local Info = Instance.new('TextLabel')
				Info.Name = 'Info'
				Info.AnchorPoint = Vector2.new(0.5, 0.5)
				Info.Size = setElementSizeX(UDim2.new(0, 303, 0, 22))
				Info.BackgroundTransparency = 1
				Info.Position = UDim2.new(0.497, 0, 0, 47)
				Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Info.FontSize = Enum.FontSize.Size14
				Info.TextTransparency = 0.2
				Info.TextSize = 13
				Info.TextColor3 = theme.TextColor
				Info.Text = tostr(info)
				Info.Font = Enum.Font.Gotham
				Info.TextXAlignment = Enum.TextXAlignment.Left
				Info.Parent = KeybindTemplate
				local Value2 = Instance.new('StringValue')
				Value2.Value = 'X'
				Value2.Parent = Info
				local Value3 = Instance.new('StringValue')
				Value3.Value = 'X'
				Value3.Parent = KeybindTemplate
				KeybindTemplate.Parent = SectionTemplate
				local f, idk = false, 0.45
				local style, dir = Enum.EasingStyle.Quad, Enum.EasingDirection.InOut
				local a = function()
					f = not f
					if f then
						Tween(KeybindTemplate, idk, style, dir, {
							Size = UDim2.new(0, KeybindTemplate.Size.X.Offset, 0, 65)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 180,
							ImageColor3 = theme.SecondaryElementColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
					else
						Tween(KeybindTemplate, idk, style, dir, {
							Size = UDim2.new(0, KeybindTemplate.Size.X.Offset, 0, 40)
						})
						Tween(ViewInfo, idk, style, dir, {
							Rotation = 0,
							ImageColor3 = theme.TextColor
						})
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
						Tween(Info, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
					end
				end
				Button.MouseButton1Click:Connect(a)
				local currentKey = defaultkey
				local mobile_key = nil
				local choosing = false
				local function e()
					local g = keybindinput
					local ms = game.Players.LocalPlayer:GetMouse()
					local Circle = Instance.new('ImageLabel')
					Circle.Name = 'Circle'
					Circle.Parent = g
					Circle.BackgroundColor3 = theme.SecondaryElementColor
					Circle.ImageColor3 = theme.SecondaryElementColor
					Circle.BackgroundTransparency = 1
					Circle.BorderSizePixel = 0
					Circle.Image = 'http://www.roblox.com/asset/?id=4560909609'
					Circle.ImageTransparency = .6
					g.ClipsDescendants = true
					local len, size = 1, nil
					local c = Circle
					c.Position = UDim2.new(-0.5, 0, 0.5, 0)
					if g.AbsoluteSize.X >= g.AbsoluteSize.Y then
						size = (g.AbsoluteSize.X * 1.5)
					else
						size = (g.AbsoluteSize.Y * 1.5)
					end
					Tween(c, len, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						ImageTransparency = 1
					})
					c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
					wait(len+0.1)
					c:Destroy()
				end
				if device == 'PC' then
					keybindinput.MouseButton1Click:Connect(function()
						choosing = true
						Tween(keybindinput:FindFirstChild('UIStroke'), 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Transparency = 0
						})
						Tween(keybindinput, 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = theme.SecondaryElementColor
						})
						keybindinput.Text = '. . .'
						local input = game:GetService('UserInputService').InputBegan:Wait()
						if input.KeyCode.Name ~= 'Unknown' and input.UserInputType == Enum.UserInputType.Keyboard then
							currentKey = input.KeyCode.Name
							keybindinput.Text = currentKey
							task.spawn(function()
								task.wait(0.05)
								choosing = false
							end)
							Tween(keybindinput, 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								TextColor3 = theme.TextColor
							})
							Tween(keybindinput:FindFirstChild('UIStroke'), 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								Transparency = 1
							})
						else
							repeat 
								input = game:GetService('UserInputService').InputBegan:Wait()
								choosing = true
							until
							input.KeyCode.Name ~= 'Unknown' and input.UserInputType == Enum.UserInputType.Keyboard
							currentKey = input.KeyCode.Name
							keybindinput.Text = currentKey
							task.spawn(function()
								task.wait(0.05)
								choosing = false
							end)
							Tween(keybindinput, 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								TextColor3 = theme.TextColor
							})
							Tween(keybindinput:FindFirstChild('UIStroke'), 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
								Transparency = 1
							})
						end
					end)
					game:GetService('UserInputService').InputBegan:Connect(function(input, gameProcessed)
						if not game:GetService('UserInputService'):GetFocusedTextBox() and choosing == false then
							if input.KeyCode.Name:upper() == currentKey:upper() then
								FUNC(currentKey)
								e()
							end
						end
					end)
				elseif device == 'Mobile' then
					keybindinput.Focused:Connect(function()
						Tween(keybindinput:FindFirstChild('UIStroke'), 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Transparency = 0
						})
						Tween(keybindinput, 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = theme.SecondaryElementColor
						})
					end)
					if mobile_key == nil then
						local MobileKeybindButton = Instance.new('Frame')
						addTypeValue(MobileKeybindButton, 'MobileKeybind')
						MobileKeybindButton.Name = KeybindTemplate:FindFirstChild('Text').Text
						MobileKeybindButton.Size = UDim2.new(0.049, 0, 1, 0)
						MobileKeybindButton.BorderSizePixel = 0
						MobileKeybindButton.BackgroundColor3 = theme.ElementColor
						local UICorner = Instance.new('UICorner')
						UICorner.CornerRadius = UDim.new(0, 69)
						UICorner.Parent = MobileKeybindButton
						local UIStroke = Instance.new('UIStroke')
						UIStroke.Thickness = 2
						UIStroke.Color = theme.SecondaryElementColor
						UIStroke.Parent = MobileKeybindButton
						local Text = Instance.new('TextLabel')
						Text.Name = 'Text'
						Text.AnchorPoint = Vector2.new(0.5, 0.5)
						Text.Size = UDim2.new(0.75, 0, 0.75, 0)
						Text.BackgroundTransparency = 1
						Text.Position = UDim2.new(0.5, 0, 0.5, 0)
						Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Text.FontSize = Enum.FontSize.Size14
						Text.LineHeight = 1.1
						Text.TextTransparency = 0.1
						Text.TextSize = 14
						Text.TextColor3 = theme.TextColor
						Text.Text = keybindinput.Text
						Text.TextWrapped = true
						Text.Font = Enum.Font.SourceSans
						Text.TextWrap = true
						Text.TextScaled = true
						Text.Parent = MobileKeybindButton
						local Button = Instance.new('TextButton')
						Button.Name = 'Button'
						Button.AnchorPoint = Vector2.new(0.5, 0.5)
						Button.Size = UDim2.new(1, 0, 1, 0)
						Button.BackgroundTransparency = 1
						Button.Position = UDim2.new(0.5, 0, 0.5, 0)
						Button.BorderSizePixel = 0
						Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Button.AutoButtonColor = false
						Button.FontSize = Enum.FontSize.Size14
						Button.TextTransparency = 1
						Button.TextSize = 14
						Button.TextColor3 = Color3.fromRGB(0, 0, 0)
						Button.Text = ''
						Button.Font = Enum.Font.SourceSans
						local UIAspectRatioConstraint = Instance.new('UIAspectRatioConstraint')
						UIAspectRatioConstraint.Parent = Button
						Button.Parent = MobileKeybindButton
						local UIAspectRatioConstraint = Instance.new('UIAspectRatioConstraint')
						UIAspectRatioConstraint.Parent = MobileKeybindButton
						MobileKeybindButton.Parent = Mobile_Keybinds
						mobile_key = MobileKeybindButton
						Button.MouseButton1Click:Connect(function()
							FUNC(keybindinput.Text)
							e()
						end)
					end
					keybindinput.FocusLost:Connect(function()
						if mobile_key ~= nil then
							mobile_key:FindFirstChild('Text').Text = keybindinput.Text
						end
						Tween(keybindinput, 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = theme.TextColor
						})
						Tween(keybindinput:FindFirstChild('UIStroke'), 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Transparency = 1
						})
					end)
				end

				function keybind:Edit(newName, newInfo, newDefaultKey, newFunc)
					KeybindTemplate.Name = newName
					Info.Text = newInfo
					KeybindTemplate:FindFirstChild('Text').Text = newName
					keybindinput.Text = newDefaultKey
					currentKey = newDefaultKey
					keybind[name] = newName
					if mobile_key ~= nil then
						mobile_key:FindFirstChild('Text').Text = newName
					end
					FUNC = newFunc
					name = newName
				end

				function keybind:Remove()
					FUNC = function() end
					KeybindTemplate:Destroy()
					if mobile_key ~= nil then
						mobile_key:Destroy()
					end
					table.remove(keybind, table.find(keybind, name))
				end
				return keybind
			end

			function Section:Dropdown(name, list, default, func)
				local dropdown = {}
				table.insert(dropdown, name)
				local FUNC = func
				local amountOfButtons = 0
				local DropdownTemplate = Instance.new('Frame')
				addTypeValue(DropdownTemplate, 'Dropdown')
				DropdownTemplate.Name = tostr(name)
				DropdownTemplate.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				DropdownTemplate.ClipsDescendants = true
				DropdownTemplate.Position = UDim2.new(0, 0, 1.85, 0)
				DropdownTemplate.BorderSizePixel = 0
				DropdownTemplate.BackgroundColor3 = theme.ElementColor
				local UICorner = Instance.new('UICorner')
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = DropdownTemplate
				local Objects = Instance.new('ScrollingFrame')
				Objects.Name = 'Objects'
				Objects.Position = UDim2.new(0.5, 0, 1, 0)
				Objects.AnchorPoint = Vector2.new(0.5, 1)
				Objects.Size = setElementSizeX(UDim2.new(0, 328, 0, 0))
				Objects.BackgroundTransparency = 1
				Objects.Active = true
				Objects.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Objects.CanvasSize = UDim2.new(0, 0, 1, 0)
				Objects.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
				Objects.ScrollBarImageTransparency = 1
				Objects.ScrollBarThickness = 0
				Objects.Parent = DropdownTemplate
				local UIListLayout = Instance.new('UIListLayout')
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Parent = Objects
				local viewInfo = Instance.new("TextButton")
				viewInfo.Name = "viewInfo"
				viewInfo.AnchorPoint = Vector2.new(1, 0)
				viewInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(1, 0, 0, 0)
				viewInfo.Size = UDim2.new(0, 43, 0, 40)
				viewInfo.Font = Enum.Font.SourceSans
				viewInfo.Text = ""
				viewInfo.TextColor3 = Color3.fromRGB(0, 0, 0)
				viewInfo.TextSize = 14
				local DropdownButton = Instance.new('ImageLabel')
				DropdownButton.Name = 'DropdownButton'
				DropdownButton.LayoutOrder = 4
				DropdownButton.Selectable = true
				DropdownButton.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownButton.Size = UDim2.new(0, 22, 0, 22)
				DropdownButton.BackgroundTransparency = 1
				DropdownButton.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownButton.Active = true
				DropdownButton.ImageRectOffset = Vector2.new(324, 524)
				DropdownButton.ImageRectSize = Vector2.new(36, 36)
				DropdownButton.Image = 'rbxassetid://3926307971'
				DropdownButton.ImageColor3 = theme.TextColor
				DropdownButton.Parent = viewInfo
				viewInfo.Parent = DropdownTemplate
				local Buttons = Instance.new('Frame')
				Buttons.Name = 'Buttons'
				Buttons.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				Buttons.BackgroundTransparency = 1
				Buttons.BorderSizePixel = 0
				Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Buttons.Parent = DropdownTemplate
				local Button = Instance.new('TextButton')
				Button.Name = 'Button'
				Button.Size = setElementSizeX(UDim2.new(0, 328, 0, 40))
				Button.BackgroundTransparency = 1
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.FontSize = Enum.FontSize.Size14
				Button.TextSize = 14
				Button.TextColor3 = Color3.fromRGB(0, 0, 0)
				Button.Text = ''
				Button.Font = Enum.Font.SourceSans
				Button.Parent = Buttons
				local SearchBox = Instance.new('TextBox')
				SearchBox.Name = 'SearchBox'
				SearchBox.AnchorPoint = Vector2.new(0.8, 0.5)
				SearchBox.Size = UDim2.new(0, 107, 0, 21)
				SearchBox.Position = UDim2.new(0.8, 0, 0.5, 0)
				SearchBox.BackgroundColor3 = theme.WindowColor
				SearchBox.FontSize = Enum.FontSize.Size14
				SearchBox.TextSize = 14
				SearchBox.TextColor3 = theme.TextColor
				SearchBox.TextTransparency = 0.1
				SearchBox.ZIndex = 2
				SearchBox.Text = 'Search...'
				SearchBox.Font = Enum.Font.Gotham
				SearchBox.Parent = Buttons
				local UICorner1 = Instance.new('UICorner')
				UICorner1.CornerRadius = UDim.new(0, 5)
				UICorner1.Parent = SearchBox
				local UIStroke = Instance.new('UIStroke')
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke.Transparency = 1
				UIStroke.Color = theme.SecondaryElementColor
				UIStroke.Parent = SearchBox
				local Text = Instance.new('TextLabel')
				Text.Name = 'Text'
				Text.AnchorPoint = Vector2.new(0.22, 0.5)
				Text.Size = setElementSizeX(UDim2.new(0, 272, 0, 40))
				Text.BackgroundTransparency = 1
				Text.Position = UDim2.new(0.22, 0, 0, 20)
				Text.Active = true
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.FontSize = Enum.FontSize.Size14
				Text.TextTransparency = 0.1
				Text.TextSize = 14
				Text.TextColor3 = theme.TextColor
				Text.Text = tostr(name)..': '..default
				Text.Font = Enum.Font.GothamMedium
				Text.TextXAlignment = Enum.TextXAlignment.Left
				Text.Parent = Buttons
				local Value = Instance.new('StringValue')
				Value.Value = 'X'
				Value.Parent = Text
				local Value1 = Instance.new('StringValue')
				Value1.Value = 'X'
				Value1.Parent = Objects
				local Value2 = Instance.new('StringValue')
				Value2.Value = 'X'
				Value2.Parent = DropdownTemplate
				local Value3 = Instance.new('StringValue')
				Value3.Value = 'X'
				Value3.Parent = Buttons
				local Value4 = Instance.new('StringValue')
				Value4.Value = 'X'
				Value4.Parent = Button
				DropdownTemplate.Parent = SectionTemplate
				amountOfButtons = #list
				local size;
				local opened = false
				local idk = 0.5
				local style, dir = Enum.EasingStyle.Quad, Enum.EasingDirection.InOut
				local function changeSize()
					if amountOfButtons > 5 then
						size = 130
						local canvas = Objects.CanvasSize
						Objects.CanvasSize = UDim2.new(canvas.X.Scale, canvas.X.Offset, canvas.Y.Scale, 105 + (amountOfButtons - 4) * 25)
					end
					if amountOfButtons == 5 then
						size = 130
					end
					if amountOfButtons == 4 then
						size = 105
					end
					if amountOfButtons == 3 then
						size = 80
					end
					if amountOfButtons == 2 then
						size = 55
					end
					if amountOfButtons == 1 then
						size = 30
					end
					if amountOfButtons == 0 then
						size = 0
					end
					Tween(Objects, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						Size = UDim2.new(0, Objects.Size.X.Offset, 0, size)
					})
					Tween(DropdownTemplate, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						Size = UDim2.new(0, DropdownTemplate.Size.X.Offset, 0, size + 40)
					})
				end
				Button.MouseButton1Click:Connect(function()
					opened = not opened
					if opened then
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.SecondaryElementColor
						})
						Tween(DropdownButton, idk, style, dir, {
							Rotation = 180
						})
						changeSize()
					else
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
						Tween(DropdownButton, idk, style, dir, {
							Rotation = 0
						})
						Tween(Objects, idk, style, dir, {
							Size = UDim2.new(0, Objects.Size.X.Offset, 0, 0)
						})
						Tween(DropdownTemplate, idk, style, dir, {
							Size = UDim2.new(0, DropdownTemplate.Size.X.Offset, 0, 40)
						})
					end
				end)
				local function createDropdownButton(Name)
					local Drop_Button = Instance.new('Frame')
					Drop_Button.Name = tostr(Name)
					Drop_Button.Size = setElementSizeX(UDim2.new(0, 316, 0, 25))
					Drop_Button.BackgroundTransparency = 1
					Drop_Button.Position = UDim2.new(0.035, 0, 0, 0)
					Drop_Button.BorderSizePixel = 0
					Drop_Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					local Text2 = Instance.new('TextLabel')
					Text2.Name = 'Text2'
					Text2.AnchorPoint = Vector2.new(0.5, 0.5)
					Text2.Size = setElementSizeX(UDim2.new(0, 281, 0, 20))
					Text2.BackgroundTransparency = 1
					Text2.Position = UDim2.new(0.5, 0, 0.5, 0)
					Text2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Text2.FontSize = Enum.FontSize.Size14
					Text2.TextTransparency = 0.4
					Text2.TextSize = 14
					Text2.TextColor3 = theme.TextColor
					Text2.Text = tostr(Name)
					Text2.Font = Enum.Font.Gotham
					Text2.TextXAlignment = Enum.TextXAlignment.Left
					Text2.Parent = Drop_Button
					local Button = Instance.new('TextButton')
					Button.Name = 'Button'
					Button.Selectable = false
					Button.AnchorPoint = Vector2.new(0.5, 0.5)
					Button.Size = setElementSizeX(UDim2.new(0, 327, 0, 20))
					Button.BackgroundTransparency = 1
					Button.Position = UDim2.new(0.5, 0, 0.5, 0)
					Button.Active = false
					Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Button.FontSize = Enum.FontSize.Size14
					Button.TextTransparency = 1
					Button.TextSize = 14
					Button.TextColor3 = Color3.fromRGB(255, 255, 255)
					Button.Text = ''
					Button.Font = Enum.Font.Gotham
					Button.TextXAlignment = Enum.TextXAlignment.Left
					Button.Parent = Drop_Button
					local Value = Instance.new('StringValue')
					Value.Value = 'X'
					Value.Parent = Button
					local Value1 = Instance.new('StringValue')
					Value1.Value = 'X'
					Value1.Parent = Drop_Button
					local Value2 = Instance.new('StringValue')
					Value2.Value = 'X'
					Value2.Parent = Text2
					Drop_Button.Parent = Objects
					Drop_Button.MouseEnter:Connect(function()
						Tween(Text2, .5, style, dir, {
							TextTransparency = 0.05
						})
					end)
					Drop_Button.MouseLeave:Connect(function()
						Tween(Text2, .5, style, dir, {
							TextTransparency = 0.4
						})
					end)
					Button.MouseButton1Click:Connect(function()
						Text.Text = tostr(name)..': '..Text2.Text
						opened = false
						FUNC(Text2.Text)
						Tween(Text, idk, style, dir, {
							TextColor3 = theme.TextColor
						})
						Tween(DropdownButton, idk, style, dir, {
							Rotation = 0
						})
						Tween(Objects, idk, style, dir, {
							Size = UDim2.new(0, Objects.Size.X.Offset, 0, 0)
						})
						Tween(DropdownTemplate, idk, style, dir, {
							Size = UDim2.new(0, DropdownTemplate.Size.X.Offset, 0, 40)
						})
					end)
					return Drop_Button
				end
				for i, btnname in pairs(list) do
					createDropdownButton(btnname)
				end
				SearchBox.FocusLost:Connect(function()
					Tween(UIStroke, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Transparency = 1
					})
				end)
				SearchBox.Focused:Connect(function()
					Tween(UIStroke, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Transparency = 0
					})
				end)
				SearchBox:GetPropertyChangedSignal('Text'):Connect(function()
					for i, v in pairs(Objects:GetChildren()) do
						if v.ClassName == 'Frame' then
							local txt = v:FindFirstChild('Text2').Text
							if string.find(txt:lower(), SearchBox.Text:lower()) then
								v.Visible = true
							else
								v.Visible = false
							end
						end
					end
				end)
				function dropdown:Edit(newName, newList, newDefault, newFunc)
					name = newName
					list = newList
					default = newDefault
					Text.Text = tostr(name)..': '..default
					FUNC, func = newFunc, newFunc
					for i, v in pairs(Objects:GetChildren()) do
						if v.ClassName == 'Frame' then
							v:Destroy()
						end
					end
					for i, v in pairs(newList) do
						createDropdownButton(v)
					end
					amountOfButtons = #newList
					if opened then
						changeSize()
					else
						if amountOfButtons > 3 then
							size = 80
							local canvas = Objects.CanvasSize
							Objects.CanvasSize = UDim2.new(canvas.X.Scale, canvas.X.Offset, canvas.Y.Scale, 105 + (amountOfButtons - 4) * 25)
						end
						if amountOfButtons == 3 then
							size = 80
						end
						if amountOfButtons == 2 then
							size = 55
						end
						if amountOfButtons == 1 then
							size = 30
						end
						if amountOfButtons == 0 then
							size = 0
						end
					end
				end
				function dropdown:Remove()
					name = nil
					list = nil
					FUNC, func = function()end, function()end
					for i, v in pairs(Objects:GetChildren()) do
						if v.ClassName == 'Frame' then
							v:Destroy()
						end
					end
					DropdownTemplate:Destroy()
					amountOfButtons = 0
				end
				function dropdown:Button(btnName)
					local dropdownButton = {}
					table.insert(dropdownButton, btnName)
					createDropdownButton(btnName)
					amountOfButtons = amountOfButtons + 1
					if opened then
						changeSize()
					else
						if amountOfButtons > 3 then
							size = 80
							local canvas = Objects.CanvasSize
							Objects.CanvasSize = UDim2.new(canvas.X.Scale, canvas.X.Offset, canvas.Y.Scale, 105 + (amountOfButtons - 4) * 25)
						end
						if amountOfButtons == 3 then
							size = 80
						end
						if amountOfButtons == 2 then
							size = 55
						end
						if amountOfButtons == 1 then
							size = 30
						end
						if amountOfButtons == 0 then
							size = 0
						end
					end
					function dropdownButton:Edit(newname)
						Objects:FindFirstChild(btnName):FindFirstChild('Text2').Text = newname
						Objects:FindFirstChild(btnName).Name = newname
						btnName = newname
					end
					function dropdownButton:Remove()
						Objects:FindFirstChild(btnName):Destroy()
						amountOfButtons = amountOfButtons - 1
						if opened then
							changeSize()
						else
							if amountOfButtons > 3 then
								size = 80
								local canvas = Objects.CanvasSize
								Objects.CanvasSize = UDim2.new(canvas.X.Scale, canvas.X.Offset, canvas.Y.Scale, 105 + (amountOfButtons - 4) * 25)
							end
							if amountOfButtons == 3 then
								size = 80
							end
							if amountOfButtons == 2 then
								size = 55
							end
							if amountOfButtons == 1 then
								size = 30
							end
							if amountOfButtons == 0 then
								size = 0
							end
						end
					end
					return dropdownButton
				end
				return dropdown
			end
			function Section:PlayerList(name, func)
				local playerlist = {}
				table.insert(playerlist, name)
				local run = true
				local plrtable = {}
				for i, v in pairs(game.Players:GetPlayers()) do
					table.insert(plrtable, v.Name)
				end
				local playerList = Section:Dropdown(name, plrtable, plrtable[1], func)
				game.Players.PlayerAdded:Connect(function(player)
					if run then
						table.insert(plrtable, player.Name)
						playerList:Edit(name, plrtable, plrtable[1], func)
					end
				end)
				game.Players.PlayerRemoving:Connect(function(player)
					if run then
						table.remove(plrtable, table.find(plrtable, player.Name))
						playerList:Edit(name, plrtable, plrtable[1], func)
					end
				end)
				function playerlist:Edit(newName, newFunc)
					name = newName
					func = newFunc
					playerList:Edit(name, plrtable, plrtable[1], func)
				end
				function playerlist:Remove()
					run = false
					playerList:Remove()
				end
				return playerlist
			end
			return Section
		end
		return Tab
	end
	return Windows
end
return Vernesity
