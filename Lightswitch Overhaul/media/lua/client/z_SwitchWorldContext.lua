local phrases = {
    getText("ContextMenu_Three"),
    getText("ContextMenu_Four"),
    getText("ContextMenu_Five"),
    getText("ContextMenu_Six"),
    getText("ContextMenu_Seven"),
    getText("ContextMenu_Eight"),
    getText("ContextMenu_Nine"),
    getText("ContextMenu_Ten"),
    getText("ContextMenu_Eleven"),
    getText("ContextMenu_Twelve"),
    getText("ContextMenu_Thirteen"),
    getText("ContextMenu_Fourteen"),
    getText("ContextMenu_Fifteen"),
    getText("ContextMenu_Sixteen"),
    getText("ContextMenu_Seventeen"),
    getText("ContextMenu_Eighteen"),
    getText("ContextMenu_Nineteen"),
    getText("ContextMenu_Twenty"),
    getText("ContextMenu_TwentyOne"),
    getText("ContextMenu_TwentyTwo"),
    getText("ContextMenu_TwentyThree"),
    getText("ContextMenu_TwentyFour"),
    getText("ContextMenu_TwentyFive"),
    getText("ContextMenu_TwentySix"),
    getText("ContextMenu_TwentySeven"),
    getText("ContextMenu_TwentyEight"),
    getText("ContextMenu_TwentyNine"),
    getText("ContextMenu_Thirty"),
    getText("ContextMenu_ThirtyOne"),
    getText("ContextMenu_ThirtyTwo"),
    getText("ContextMenu_ThirtyThree"),
    getText("ContextMenu_ThirtyFour"),
    getText("ContextMenu_ThirtyFive"),
    getText("ContextMenu_ThirtySix"),
    getText("ContextMenu_ThirtySeven"),
}
local hasAddedOptions = false -- flag variable
local bulbLevel = SandboxVars.Nipswitch.Bulblevel
local disableBulb = SandboxVars.Nipswitch.Bulbdisabled
local battLevel = SandboxVars.Nipswitch.Batterylevel
local disableBatt = SandboxVars.Nipswitch.Batterydisabled
local dumbText = getText("ContextMenu_One")
local function bulbContext(player_num, context, worldobjects)
    local zapLevel = getSpecificPlayer(player_num):getPerkLevel(Perks.Electricity)
    local blowLevel = zapLevel < battLevel
    local lowLevel = (bulbLevel ~= 0) and (zapLevel < bulbLevel)
    local contextBulbAdd = context:getOptionFromName(getText("ContextMenu_AddLightbulb"))
    local contextBulb = context:getOptionFromName(getText("ContextMenu_RemoveLightbulb"))
    local battAdd = context:getOptionFromName(getText("ContextMenu_AddBattery"))
    local battRem = context:getOptionFromName(getText("ContextMenu_Remove_Battery"))
    local battConnect = context:getOptionFromName(getText("ContextMenu_CraftBatConnector"))
    for _, v in ipairs(worldobjects) do
        local sprProp = v:getSprite():getProperties()
        local sprSwitch = sprProp:Val("CustomName") == "Switch"
        if instanceof(v, "IsoLightSwitch") then
            if sprSwitch then
                local toolTip = ISWorldObjectContextMenu.addToolTip()
                if battAdd then
                    battAdd.iconTexture = getTexture("media/textures/switch.png")
                    if not blowLevel then battAdd.notAvailable = false
                    elseif disableBatt or blowLevel then
                        battAdd.notAvailable = true
                        context:removeOptionByName(getText("ContextMenu_AddBattery"))
                    else context:removeOptionByName(getText("ContextMenu_AddBattery"))
                    end
                end

                if battRem then
                    battRem.iconTexture = getTexture("media/textures/switch.png")
                    if not blowLevel then battRem.notAvailable = false
                    elseif disableBatt or blowLevel then
                        battRem.notAvailable = true
                        context:removeOptionByName(getText("ContextMenu_Remove_Battery"))
                    else context:removeOptionByName(getText("ContextMenu_Remove_Battery"))
                    end
                end

                if battConnect then
                    battConnect.iconTexture = getTexture("media/textures/switch.png")
                    if not blowLevel then battConnect.notAvailable = false
                    elseif disableBatt or blowLevel then
                        battConnect.notAvailable = true
                        context:removeOptionByName(getText("ContextMenu_CraftBatConnector"))
                    else context:removeOptionByName(getText("ContextMenu_CraftBatConnector"))
                    end
                end

                if contextBulbAdd then
                    contextBulbAdd.iconTexture = getTexture("media/textures/switch.png")
                    if not lowLevel then contextBulbAdd.notAvailable = false
                    elseif disableBulb then
                        context:removeOptionByName(getText("ContextMenu_AddLightbulb"))
                    elseif lowLevel then
                        contextBulbAdd.notAvailable = true
                        contextBulbAdd.toolTip = dumbText
                        contextBulbAdd.toolTip = toolTip
                    else context:removeOptionByName(getText("ContextMenu_AddLightbulb"))
                    end
                end

                if contextBulb then
                    contextBulb.iconTexture = getTexture("media/textures/switch.png")
                    if not lowLevel then contextBulb.notAvailable = false
                    elseif disableBulb then
                        context:removeOptionByName(getText("ContextMenu_RemoveLightbulb"))
                    elseif lowLevel then
                        local contextRead = context:insertOptionAfter("Remove Light Bulb", phrases[ZombRand(1, 34)])
                        toolTip.description = dumbText
                        contextRead.iconTexture = getTexture("media/textures/switch.png")
                        contextRead.toolTip = toolTip
                        contextRead.notAvailable = true
                        context:removeOptionByName(getText("ContextMenu_RemoveLightbulb"))
                    else context:removeOptionByName(getText("ContextMenu_RemoveLightbulb"))
                    end
                    break
                end
            end
        end
    end
    -- check if options have been added and reset flag if condition is no longer met
    if hasAddedOptions and not (lowLevel or disableBulb or disableBatt or blowLevel) then
        hasAddedOptions = false
    end

    -- add options if condition is met and flag is not set
    if not hasAddedOptions and (lowLevel or disableBulb or disableBatt or blowLevel) then
        -- existing code here
        hasAddedOptions = true -- set flag to true
    end
end




Events.OnFillWorldObjectContextMenu.Add(bulbContext)