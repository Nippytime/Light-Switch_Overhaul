local ScriptManager = ScriptManager.instance
local bookItem = ScriptManager:getItem("Lightswitches_fordummies")
--This section is the code that sets the page length of the book base on the sandbox option setting.
local function nipboxOptions()
    if bookItem then -- if book is in inventory
        local pageLength = SandboxVars.Nipswitch.Pagelength or 500 -- get page length from SandboxVars
        bookItem:DoParam("NumberOfPages ="..pageLength) -- set page length of book to page length from SandboxVars
    end
end

Events.OnInitGlobalModData.Add(nipboxOptions)