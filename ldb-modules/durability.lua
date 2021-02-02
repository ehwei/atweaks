local db_dura = CreateFrame("Frame", "atDurability_Text")
db_dura.obj = LibStub("LibDataBroker-1.1"):NewDataObject("atDurability", {type = "data source", text = "datadura", label = "|cffFFD100Durability: |r"})


local function color(durability)
    if durability == 0 then
        return string.format("|cffff0000"..string.format("%.0f%%", durability).."|r") -- #ff0000
    elseif durability > 0 and durability <= 25 then
        return string.format("|cffFFD100"..string.format("%.0f%%", durability).."|r") -- #ffd100
    elseif durability > 25 then
        return string.format("|cff00FF00"..string.format("%.0f%%", durability).."|r") -- #00FF00
    end
end

local itemSlots = {
    "HeadSlot",
    "ShoulderSlot",
    "ChestSlot",
    "WristSlot",
    "HandsSlot",
    "WaistSlot",
    "LegsSlot",
    "FeetSlot",
    "MainHandSlot",
    "SecondaryHandSlot",
}

db_dura:SetScript("OnEvent", function(self)
    local durability, maximum = 0, 0

    for i = 1, #itemSlots do
        local slotId = GetInventorySlotInfo(itemSlots[i])
        local d, m = GetInventoryItemDurability(slotId)
        durability = durability + (d or 0)
        maximum = maximum + (m or 0)
    end

    -- self.obj.text = ("%.0f%%"):format(durability / maximum * 100)
    self.obj.text = color(durability / maximum * 100)

end)

db_dura:RegisterEvent("PLAYER_DEAD")
db_dura:RegisterEvent("MERCHANT_CLOSED")
db_dura:RegisterEvent("PLAYER_REGEN_ENABLED")
db_dura:RegisterEvent("PLAYER_ENTERING_WORLD")
