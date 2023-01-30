# Vernesity-UI-Library

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
