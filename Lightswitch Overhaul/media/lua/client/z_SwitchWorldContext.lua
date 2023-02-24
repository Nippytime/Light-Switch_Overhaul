if isServer() then return end -- if server, don't run this code
local ISWorldObjectContextMenu = ISWorldObjectContextMenu -- localize globals for performance
local ZombRand = ZombRand
local getText = getText
local ipairs = ipairs
local getSpecificPlayer = getSpecificPlayer
local getTexture = getTexture
local phrases = {
    "Lightbulb scary, no touch.",
    "Me no smart lightbulbs.",
    "Does my finger in the socket?!",
    "How lightbulbs work, hmm?",
    "Lightbulbs make me cross-eyed.",
    "Lightbulbs... what do?",
    "Lightbulb hurt brain, ouch.",
    "Lightbulbs... not my thing.",
    "Change lightbulb? Not today.",
    "Confusing things these are...",
    "Lightbulbs elude my understanding.",
    "No clue about lightbulbs.",
    "Lightbulbs are too complex.",
    "Lightbulbs... my nemesis!",
    "Can't change lightbulbs...",
    "Lightbulbs scare me!",
    "Lightbulbs, not my forte.",
    "No lightbulb understandy.",
    "I need a lightbulb expert.",
    "Lightbulbs baffle me completely.",
    "Lightbulbs are not my strong suit.",
    "Lost with lightbulbs...",
    "No idea about lightbulbs.",
    "Lightbulbs too tricky.",
    "Lightbulbs confuse me.",
    "Don't ask me about lightbulbs!",
    "Lightbulbs beyond my comprehension.",
    "I avoid lightbulbs..",
    "Lightbulbs make me nervous.",
    "Lightbulbs not my thing.",
    "Can't help with lightbulbs.",
    "Lightbulbs frustrate me.",
    "Lightbulbs, no comprende.",
    "Me and lightbulbs. Enemies!",
    "Lightbulbs... What is life?",
    "You see a lightbulb socket and become intimidated...",
    "You wish you knew more about lightbulbs...",
    "Does my finger go in the light socket..?"
}
local bulbLevel = SandboxVars.Nipswitch.Bulblevel
local disableBulb = SandboxVars.Nipswitch.Bulbdisabled
local function bulbContext(player_num, context, worldobjects)
    for _, v in ipairs(worldobjects) do
        local sprProp = v:getSprite():getProperties()
        local sprDirs = {"Noffset", "Soffset", "Woffset", "Eoffset"}
        for _, sprDir in ipairs(sprDirs) do
            local sprSwitch = sprProp:Val("CustomName") == "Switch"
            if not sprProp:Val(sprDir) and not sprSwitch then context:removeOptionByName(getText("ContextMenu_RemoveLightbulb")) end
            if not sprSwitch then return end
            local function updateLightbulbOption(context, contextMenuText, lowLevel, toolTip)
                local contextOption = context:getOptionFromName(getText(contextMenuText))
                if disableBulb then return context:removeOptionByName(getText(contextMenuText)) end
                if contextOption and lowLevel then
                    local dumbText = getText("ContextMenu_One") -- get text for dumb context menu option from translations
                    toolTip.description = dumbText -- set tooltip to dumb text
                    local newPhrase = phrases[ZombRand(1, 39)]
                    local contextRead = context:insertOptionAfter("Remove Light Bulb", newPhrase)
                    contextRead.toolTip = toolTip
                    contextRead.iconTexture = getTexture("media/textures/switch.png")
                    contextRead.notAvailable = true
                    context:removeOptionByName(getText(contextMenuText))
                end
            end
            local zapLevel = getSpecificPlayer(player_num):getPerkLevel(Perks.Electricity)
            local battLevel = SandboxVars.Nipswitch.Batterylevel
            local disableBatt = SandboxVars.Nipswitch.Batterydisabled
            local blowLevel = zapLevel < battLevel
            local lowLevel = (bulbLevel ~= 0) and (zapLevel < bulbLevel)
            local previousPhrase = ""

            local toolTip = ISWorldObjectContextMenu.addToolTip()

            --if not disableBulb then
            local contextBulbAdd = context:getOptionFromName(getText("ContextMenu_AddLightbulb")) -- get "add bulb" context menu option
            if contextBulbAdd then
                contextBulbAdd.iconTexture = getTexture("media/textures/switch.png")
                previousPhrase = updateLightbulbOption(context, "ContextMenu_AddLightbulb", lowLevel, toolTip, previousPhrase)
                --else
                if disableBulb then context:removeOptionByName(getText("ContextMenu_AddLightbulb")) end
            end
            local contextBulb = context:getOptionFromName(getText("ContextMenu_RemoveLightbulb")) -- get "remove bulb" context menu option
            if contextBulb then
                contextBulb.iconTexture = getTexture("media/textures/switch.png")
                previousPhrase = updateLightbulbOption(context, "ContextMenu_RemoveLightbulb", lowLevel, toolTip, previousPhrase)
                --else
                if disableBulb then context:removeOptionByName(getText("ContextMenu_RemoveLightbulb")) end
            end
            --end


            local battAdd = context:getOptionFromName(getText("ContextMenu_AddBattery"))
            if battAdd then
                battAdd.iconTexture = getTexture("media/textures/switch.png")
                if blowLevel then
                    battAdd.notAvailable = true
                elseif disableBatt then
                    context:removeOptionByName(getText("ContextMenu_AddBattery"))
                end
            end

            local battRem = context:getOptionFromName(getText("ContextMenu_Remove_Battery"))
            if battRem then
                battRem.iconTexture = getTexture("media/textures/switch.png")
                if blowLevel then
                    battRem.notAvailable = true
                elseif disableBatt then
                    context:removeOptionByName(getText("ContextMenu_Remove_Battery"))
                end
            end

            local battConnect = context:getOptionFromName(getText("ContextMenu_CraftBatConnector"))
            if battConnect then
                battConnect.iconTexture = getTexture("media/textures/switch.png")
                if blowLevel or disableBatt then
                    battConnect.notAvailable = true
                    context:removeOptionByName(getText("ContextMenu_CraftBatConnector"))
                end
            end
        end
    end
end
        --end
    --end
--end

    Events.OnFillWorldObjectContextMenu.Add(bulbContext)