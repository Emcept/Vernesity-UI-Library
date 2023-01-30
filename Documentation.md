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
