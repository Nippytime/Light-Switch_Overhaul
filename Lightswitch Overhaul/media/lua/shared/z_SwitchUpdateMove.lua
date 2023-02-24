--local function fixMoveLevel()
--In this example you generate a new array with all levels and put it to PropertyValueMap without any checks "TY Poltergeist"
local vals = IsoWorld.PropertyValueMap:get("PickUpLevel") or ArrayList.new()
    for i = 1, 10 do
    local val = tostring(i)
    if not vals:contains(val) then vals:add(val) end
    IsoWorld.PropertyValueMap:put("PickUpLevel",vals)
    end
--end

--Events.OnInitGlobalModData.Add(fixMoveLevel)