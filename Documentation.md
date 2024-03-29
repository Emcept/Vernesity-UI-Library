# Vernesity UI Library
## Version 2 is out! https://github.com/Emcept/Vernesity-V2
### Made by Emmy (Discord: emcept)

<br />

## Getting Loadstring
```Lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Emcept/Vernesity-UI-Library/main/source.lua"))()
```
<br />

## Adding Key System
```Lua
Library:EnableKeySystem(<Title>, <Subtitle>, <Note>, <Key>)
```

<br />

## Creating a Window
```Lua
local Window = Library:Window(<Title>, <Subtitle>, <Theme (optional)>)
```
<br />

### Themes:
> DarkTheme  
> LightTheme  
> BlueTheme  
> PurpleTheme  
> RedTheme  
> GreenTheme  

<br />

## Creating Notifications
```Lua
Window:Notify(<Title>, <Description>, <Arguments Table>, <Duration>, <Func>)
```
### The arguments in the table should be 0-2 strings or 0-2 numbers if you want to use images instead of normal buttons
#### For example, this would create a notification with 2 Buttons
```Lua
Window:Notify("Question", "Do you like this UI Library?", {"Yes", "No"}, 5, function(Text)
	if Text == "Yes" then print("Thank you!") else print(":(") end
end)
```
#### And this would create a notification with 1 ImageButton (you need to enter a valid ImageID)
```Lua
Window:Notify("Notification", "Description", {1234567}, 10, function() print("Button pressed") end)
```
#### This would just create a notification with no buttons
```Lua
Window:Notify("Notification", "Description", {}, 3)
```
<br />

## Creating Tabs
```Lua
local Tab = Window:Tab(<Tab Name>, <ImageID (optional)>)
```
<br />

## Creating Sections
```Lua
local Section = Tab:Section(<Section Name>)
```
<br />

## Creating Buttons
```Lua
local Button = Section:Button(<Button Name>, <Button Description>, <Function>)
```
<br />

## Creating Labels
```Lua
local Label = Section:Label(<Label Name>)
```
<br />

## Creating TextBoxes
```Lua
local TextBox = Section:TextBox(<TextBox Name>, <TextBox Description>, <Default Text>, <Function>)
```
<br />

## Creating Paragraphs
```Lua
local Paragraph = Section:Paragraph(<Text 1>, <Text 2>)
```
<br />

## Creating Interactables
```Lua
local Interactable = Section:Interactable(<Interactable Name>, <Interactable Description>, <Button Text>, <Function>)
```
<br />

## Creating Dropdowns
```Lua
local Dropdown = Section:Dropdown(<Dropdown Name>, <Dropdown List>, <Default Option>, <Function>)
```
### Adding a button inside of a Dropdown
```Lua
local DropdownButton = Dropdown:Button(<Button Name>)
```
#### Just like any other UI element, you can remove or edit it
```Lua
DropdownButton:Edit("Hi")
DropdownButton:Remove()
```
<br />

## Creating Switches
```Lua
local Switch = Section:Switch(<Switch Name>, <Switch Description>, <Enabled (true/false)>, <Function>)
```
<br />

## Creating Toggles
```Lua
local Toggle = Section:Toggle(<Toggle Name>, <Toggle Description>, <Enabled (true/false)>, <Function>)
```
<br />

## Creating Sliders
```Lua
local Slider = Section:Slider(<Slider Name>, <Slider Description>, <Minimum Value>, <Maximum Value>, <Default Value>, <Function>)
```
<br />

## Creating ColorPickers
```Lua
local ColorPicker = Section:ColorPicker(<ColorPicker Name>, <ColorPicker Description>, <Default Color>, <Function>)
```
<br />

## Creating PlayerLists
```Lua
local PlayerList = Section:PlayerList(<PlayerList Name>, <Function>)
```
<br />

## Creating Keybinds
```Lua
local Keybind = Section:Keybind(<Keybind Name>, <Keybind Description>, <Default Keybind>, <Function>)
```
<br /><br /><br />


## Other Functions
<br /><br />
### Getting the current Window's theme
```Lua
local theme = Window:GetTheme()
```
<br />

### Adding themes
#### There are 2 ways to add themes:
```Lua
local Window = Library:Window("Title", "Subtitle", {
	TextColor = Color3.fromRGB(235, 235, 235),
	WindowColor = Color3.fromRGB(49, 49, 27),
	TabColor = Color3.fromRGB(71, 71, 40),
	ElementColor = Color3.fromRGB(100, 100, 54),
	SecondaryElementColor = Color3.fromRGB(236, 236, 104)
})
```
#### or
<br />

```Lua
Library:AddTheme("AwfulTheme", {
	TextColor = Color3.fromRGB(235, 235, 235),
	WindowColor = Color3.fromRGB(49, 49, 27),
	TabColor = Color3.fromRGB(71, 71, 40),
	ElementColor = Color3.fromRGB(100, 100, 54),
	SecondaryElementColor = Color3.fromRGB(236, 236, 104)
})
local Window = Library:Window("Title", "Subtitle", "AwfulTheme")
```

### If you want to change the theme, there are 2 ways to do it:
```Lua
Window:ChangeTheme(<theme>)
```
#### or
```Lua
Window:Edit("Title", "Subtitle", <theme>)
```
<br />

### Changing the transparency of the DropShadow (it's set to 1 by default, so it's invisible)
```Lua
Windows:SetShadowTransparency(<Number 0-1>)
```




## Editing UI Elements:
```Lua
<Element>:Edit(<New Arguments>)
```
### Example:
```Lua
local Window = Library:Window("Title", "Subtitle", "DarkTheme")
Window:Edit("New Title", "New Subtitle", "PurpleTheme")
```
<br /><br />

## Removing UI Elements:
```Lua
<Element>:Remove()
```
### Example:
```Lua
local Window = Library:Window("Title", "Subtitle", "DarkTheme")
Window:Remove()
```
<br /><br />

### And here's the code which will help you add a fully customizable UI
```Lua
local theme = Window:GetTheme()
for i, v in pairs(theme) do
	settingsSection:ColorPicker(i, "Changes "..i.."'s theme", v, function(color3)
		theme = Window:GetTheme()
		theme[i] = color3
		Window:ChangeTheme(theme)
	end)
end
```
<br />

### Other Useless Functions: :OnClose() and :OnMinimize(<Function>)
```Lua
Window:OnClose(function()
	print('Closed')
end)
Window:OnMinimize(function(state)
	print('Minimized:', state)
end)
```
<br /><br /><br />	

## EXAMPLE CODE:
```Lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Emcept/Vernesity-UI-Library/main/source.lua"))()
Library:EnableKeySystem('Title', 'Key System', 'Note here', '1234')
local Window = Library:Window('Vernesity', 'Game Name', 'DarkTheme')
local Tab = Window:Tab('Tab 1')
local SettingsTab = Window:Tab('Settings', 10846926154)
local Section = Tab:Section('Main')
local Button = Section:Button('Button', 'Desc', function()
	print('Clicked')
end)
local Label = Section:Label('Label')
local Paragraph = Section:Paragraph('Text 1', 'Text 2')
local TextBox = Section:TextBox('TextBox', 'Desc', 'Type here...', function(text)
	print('You typed:', text)
end)
local Interactable = Section:Interactable('Interactable', 'Desc', 'Click Me!', function()
	print('Clicked!')
end)
local Dropdown = Section:Dropdown('Dropdown', {'Option 1', 'Option 2'}, 'Select...', function(selectedOption)
	print(selectedOption)
end)
local Switch = Section:Switch('Switch', 'Desc', true, function(state)
	if state then
		print('On')
	else
		print('Off')
	end
end)
local Toggle = Section:Toggle('Toggle', 'Desc', true, function(state)
	if state then
		print('On')
	else
		print('Off')
	end
end)
local Slider = Section:Slider('WalkSpeed', 'Desc', 0, 100, 16, function(speed)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end)
local Keybind = Section:Keybind('Keybind', 'Desc', 'F', function()
	print('Pressed the keybind!')
end)

Window:Notify('Question', 'Do you like this UI Library?', {'Yes', 'No'}, 5, function(Text)
	if Text == 'Yes' then
		print('Thank you!')
	else
		print(':(')
	end
end)

local settingsSection = SettingsTab:Section('Settings')

local theme = Window:GetTheme()
for i, v in pairs(theme) do
	settingsSection:ColorPicker(i, "Changes "..i, v, function(color3)
		theme = Window:GetTheme()
		theme[i] = color3
		Window:ChangeTheme(theme)
	end)
end

Window:OnClose(function()
	print('Closed')
end)
Window:OnMinimize(function(state)
	print('Minimized:', state)
end)

local PlayerList = Section:PlayerList('PlayerList', function(plr)
	print(plr)
end)
```
