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

## Creating Dropdowns
```
local Dropdown = Section:Dropdown(<Dropdown Name>, <Dropdown List>, <Default Option>, <Function>)
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

## Creating Keybinds
```
local Keybind = Section:Keybind(<Keybind Name>, <Keybind Description>, <Default Keybind>, <Function>)
```
<br /><br /><br />

## Editing UI Elements:
```
<Element>:Edit(<New Arguments>)
```
#### Example:
```
local Window = Library:Window("Vernesity", "Game Name", "DarkTheme")
Window:Edit("New Title", "New Game Name", "PurpleTheme")
