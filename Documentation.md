# Vernesity UI Library
## Made by Emmy#4846

<br />

## Getting Loadstring
```
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Emcept/Vernesity-UI-Library/main/source.lua"))()
```
<br />

## Creating a Window
```
local Window = Library:Window(<Title>, <Game Name>, <Theme (optional)>)
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
```
Window:Notify(<Title>, <Description>, <Arguments Table>, <Duration>, <Func>)
```
### The arguments table should be 0-2 strings or 0-2 numbers if you want to use images instead of normal buttons
#### For example, this would create a notification with 2 Buttons
```
Window:Notify("Question", "Do you like this UI Library?", {"Yes", "No"}, 5, function(Text)
	if Text == "Yes" then print("Thank you!") else print(":(") end
end)
```
#### And this would create a notification with 1 ImageButton (you need to enter a valid ImageID)
```
Window:Notify("Notification", "Description", {1234567}, 10, function() print("Button pressed") end)
```
#### This would just create a notification with no buttons
```
Window:Notify("Notification", "Description", {}, 3)
```
<br />

## Creating Tabs
```
local Tab = Window:Tab(<Tab Name>, <ImageID (optional)>)
```
<br />

## Creating Sections
```
local Section = Tab:Section(<Section Name>)
```
<br />

## Creating Buttons
```
local Button = Section:Button(<Button Name>, <Button Description>, <Function>)
```
<br />

## Creating Labels
```
local Label = Section:Label(<Label Name>)
```
<br />

## Creating TextBoxes
```
local TextBox = Section:TextBox(<TextBox Name>, <TextBox Description>, <Default Text>, <Function>)
```
<br />

## Creating Paragraphs
```
local Paragraph = Section:Paragraph(<Text 1>, <Text 2>)
```
<br />

## Creating Interactables
```
local Interactable = Section:Interactable(<Interactable Name>, <Interactable Description>, <Button Text>, <Function>)
```
<br />

## Creating Dropdowns
```
local Dropdown = Section:Dropdown(<Dropdown Name>, <Dropdown List>, <Default Option>, <Function>)
```
### Adding a button inside of a Dropdown
```
local DropdownButton = Dropdown:Button(<Button Name>)
```
#### Just like any other UI element, you can remove or edit it
```
DropdownButton:Edit("Hi")
DropdownButton:Remove()
```
<br />

## Creating Switches
```
local Switch = Section:Switch(<Switch Name>, <Switch Description>, <Enabled (true/false)>, <Function>)
```
<br />

## Creating Toggles
```
local Toggle = Section:Toggle(<Toggle Name>, <Toggle Description>, <Enabled (true/false)>, <Function>)
```
<br />

## Creating Sliders
```
local Slider = Section:Slider(<Slider Name>, <Slider Description>, <Minimum Value>, <Maximum Value>, <Default Value>, <Function>)
```
<br />

## Creating ColorPickers
```
local ColorPicker = Section:ColorPicker(<ColorPicker Name>, <ColorPicker Description>, <Default Color>, <Function>)
```
<br />

## Creating PlayerLists
```
local PlayerList = Section:PlayerList(<PlayerList Name>, <Function>)
```
<br />

## Creating Keybinds
```
local Keybind = Section:Keybind(<Keybind Name>, <Keybind Description>, <Default Keybind>, <Function>)
```
<br /><br /><br />


## Other Functions
<br /><br />
### Getting the current Window's theme
```
local theme = Window:GetTheme()
```
<br />

### Adding themes
#### There are 2 ways to add themes:
```
local Window = Library:Window("Vernesity", "Game Name", {
	TextColor = Color3.fromRGB(235, 235, 235),
	WindowColor = Color3.fromRGB(49, 49, 27),
	TabColor = Color3.fromRGB(71, 71, 40),
	ElementColor = Color3.fromRGB(100, 100, 54),
	SecondaryElementColor = Color3.fromRGB(236, 236, 104)
})
```
#### or
<br />

```
Library:AddTheme("AwfulTheme", {
	TextColor = Color3.fromRGB(235, 235, 235),
	WindowColor = Color3.fromRGB(49, 49, 27),
	TabColor = Color3.fromRGB(71, 71, 40),
	ElementColor = Color3.fromRGB(100, 100, 54),
	SecondaryElementColor = Color3.fromRGB(236, 236, 104)
})
local Window = Library:Window("Vernesity", "Game Name", "AwfulTheme")
```

### If you want to change the theme, there are 2 ways to do it:
```
Window:ChangeTheme(<theme>)
```
#### or
```
Window:Edit("Title", "Game Name", <theme>)
```
<br />

### Changing the transparency of the DropShadow (it's set to 1 by default, so it's invisible)
```
Windows:SetShadowTransparency(<Number 0-1>)
```




## Editing UI Elements:
```
<Element>:Edit(<New Arguments>)
```
### Example:
```
local Window = Library:Window("Vernesity", "Game Name", "DarkTheme")
Window:Edit("New Title", "New Game Name", "PurpleTheme")
```
<br /><br />

## Removing UI Elements:
```
<Element>:Remove()
```
### Example:
```
local Window = Library:Window("Vernesity", "Game Name", "DarkTheme")
Window:Remove()
```
<br /><br />

### And here's the code which will help you add a fully customizable UI
```
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
```
Window:OnClose(function()
	print('Closed')
end)
Window:OnMinimize(function(state)
	print('Minimized:', state)
end)
```
<br /><br /><br />	

## EXAMPLE CODE:
```
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Emcept/Vernesity-UI-Library/main/source.lua"))()
local Window = Library:Window("Vernesity", "Game Name", "DarkTheme")
local Tab = Window:Tab("Tab 1")
local SettingsTab = Window:Tab("Settings", 10846926154)
local Section = Tab:Section("Main")
local Button = Section:Button("Button", "Desc", function()
print("Clicked")
end)
local Label = Section:Label("Label")
local TextBox = Section:TextBox("TextBox", "Desc", "Type here...", function(text)
    print("You typed:", text)
end)
local Dropdown = Section:Dropdown("Dropdown", {"Option 1", "Option 2"}, "Select...", function(selectedOption)
    print(selectedOption)
end)
local Switch = Section:Switch("Switch", "Desc", true, function(state)
    if state then
        print("On")
    else
        print("Off")
    end
end)
local Toggle = Section:Toggle("Toggle", "Desc", true, function(state)
    if state then
        print("On")
    else
        print("Off")
    end
end)
local Slider = Section:Slider("WalkSpeed", "Desc", 0, 100, 16, function(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end)
local Keybind = Section:Keybind("Keybind", "Desc", "F", function()
    print("Pressed the keybind!")
end)

Window:Notify("Question", "Do you like this UI Library?", {"Yes", "No"}, 5, function(Text)
if Text == "Yes" then
    print("Thank you!")
else
    print(":(")
    end
end)

local settingsSection = SettingsTab:Section("Settings")

local theme = Window:GetTheme()
for i, v in pairs(theme) do
	settingsSection:ColorPicker(i, "Changes "..i.."'s theme", v, function(color3)
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
	
local PlayerList = Section:PlayerList("PlayerList", function(plr)
	print(plr)
end)
```
