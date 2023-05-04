--[[
    Detect whether or not Synapse is injected via the Garbage Collector (useless since Roblox doesn't allow debug.getconstants or looking through the luau garbage collector)

    The Synapse X init script: https://raw.githubusercontent.com/Acrillis/SynapseX/master/Synapse%20Scripts/InitScript.lua
    The line 'printconsole("Synapse X successfully (re)loaded.", 126, 174, 252)' is what this script detects
    
    Added Synapse X V3 detection as someone leaked the init script to me ^^
]]

local isluaclosure = islclosure or function(...) -- Checks to see whether or not the given function is a C function or a function made in Lua
    local returnval = false
    if debug.getinfo(...).what == "Lua" then
        returnval = true
    end
    return returnval
end

local function ConstantScan(constant) -- Looks through the garbage collector to find a function that has the same constants as the first argument
    for _, Func in pairs(getgc(true)) do -- Checks the garbage collector, this method of detecting Synapse X would be completley possible if Roblox allowed access to the garbage collector and fixed debug.getinfo + debug.getconstant
        if type(Func) == "function" and isluaclosure(Func) and table.find(debug.getconstants(Func), constant) then
            return Func
        end
    end
end

for _,v in pairs(debug.getconstants(ConstantScan("game"))) do
    if v == "Synapse X successfully (re)loaded."  or v == "_http" then -- Looks through the garbage collector to find the Synapse X init script that you can actually see in the 2019 source code leak, this is a constant that is in the script
        warn("Synapse detected")
    end
end
