# Lua VGUI Parser

A robust Lua library for parsing Valve GUI (VGUI) resource files, specifically designed for LMAOBOX and Lua 5.1. This library provides a complete toolkit for lexing, parsing, and manipulating VGUI resource files with support for preprocessing directives.

## Features

- Full VGUI resource file parsing
- Support for #base preprocessing directives
- Recursive file inclusion handling
- Flag and property merging
- Object-oriented design
- Whitespace and comment handling
- Robust error handling
- File system traversal utilities

## Installation

1. Download `vgui.lua` and place it in your LMAOBOX scripts directory
2. Require the module in your script:

```lua
local vgui = require('vgui')
```

## Usage

### Basic Parsing

```lua
-- Parse a VGUI resource file
local obj = vgui.VguiSerializer.fromFile("tf/custom/my_hud", "basechat.res")

-- Access properties
local property = obj:get("propertyName")

-- Check if object has a value
if obj:isValue() then
    print(obj.value)
end
```

### Recursive Directory Search

```lua
-- Find and parse basechat.res in custom directory
local function findBaseChatRes(directory)
    local baseChat = nil
    filesystem.EnumerateDirectory(directory .. "/*", function(filename, attributes)
        if attributes & E_FileAttribute.FILE_ATTRIBUTE_DIRECTORY ~= 0 then
            if filename ~= "." and filename ~= ".." then
                local result = findBaseChatRes(directory .. "/" .. filename)
                if result then
                    baseChat = result
                end
            end
        elseif filename:lower() == "basechat.res" then
            baseChat = directory .. "/" .. filename
        end
    end)
    return baseChat
end
```

### Pretty Printing

```lua
local function printVguiObject(obj, indent)
    indent = indent or 0
    local spacing = string.rep("  ", indent)

    for name, prop in pairs(obj.properties) do
        if prop:isValue() then
            print(spacing .. name .. " = " .. tostring(prop.value))
        else
            print(spacing .. name .. " {")
            printVguiObject(prop, indent + 1)
            print(spacing .. "}")
        end
    end
end
```

## Core Components

### TokenType

Enumeration of token types used in lexical analysis:
- LeftBrace
- RightBrace
- Flag
- String
- Name

### VguiObject

Main class for representing VGUI elements:
- Properties management
- Flag comparison
- Property merging
- Value handling

### Lexer

Handles tokenization of input text:
- Whitespace skipping
- Comment handling
- String parsing
- Name and flag token generation

### Parser

Converts token stream into structured data:
- Value parsing
- Property list handling
- Root object construction

### Preprocessor

Handles file inclusion and preprocessing:
- #base directive support
- Recursive file processing
- Source provider interface

## Advanced Features

### Flag Handling

```lua
-- Compare flags between objects
local matches = obj1:compareFlags(obj2)

-- Get name and flags as a key
local key = obj:getNameFlagKey()
```

### Property Merging

```lua
-- Merge properties from another object
local success = obj1:tryMerge(obj2)

-- Add or merge a single property
obj:mergeOrAddProperty(property)
```

## Error Handling

The library includes robust error handling for common issues:
- Missing files
- Invalid syntax
- Malformed tokens
- Recursive inclusion loops

## Requirements

- Lua 5.1
- LMAOBOX
- File system access permissions

## Limitations

- Only supports VGUI resource file format
- Requires LMAOBOX environment
- Limited to local filesystem access

## Credits

https://github.com/dresswithpockets/Vgui - For inspiration
