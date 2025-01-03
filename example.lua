-- Load our VGUI parser
local vgui = require('vgui')

-- Helper function to print VGUI object structure recursively
local function printVguiObject(obj, indent)
    indent = indent or 0
    local spacing = string.rep("  ", indent)

    -- Print properties
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

-- Function to find basechat.res in a directory
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

-- Start the search in tf/custom and parse the file
local function parseBaseChatRes()
    local baseChatPath = findBaseChatRes("tf/custom")
    if not baseChatPath then
        print("Could not find basechat.res in tf/custom")
        return
    end

    print("Found basechat.res at: " .. baseChatPath)
    print("Structure:")
    print("---------")

    -- Get directory containing basechat.res
    local rootPath = string.match(baseChatPath, "(.*/).*%.res$")
    local relativeFile = string.match(baseChatPath, ".*/(.*)$")

    -- Parse the VGUI file
    local obj = vgui.VguiSerializer.fromFile(rootPath, relativeFile)
    
    -- Print the full structure recursively
    printVguiObject(obj)
end

-- Run the parser
parseBaseChatRes()
