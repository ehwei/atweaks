----------------------------------------------------------------------
--                          atweaks                                 --
----------------------------------------------------------------------
-- atweaks = LibStub("AceAddon-3.0"):NewAddon("atweaks", "AceHook-3.0")
-- local addon = LibStub("AceAddon-3.0"):GetAddon("DTweaks")

-- function atweaks:OnEnable()
--   -- Hook ActionButton_UpdateHotkeys, overwriting the secure status
--   self:Hook("ActionButton_UpdateHotkeys", true)
-- end
--
-- function atweaks:ActionButton_UpdateHotkeys(button, type)
--   print(button:GetName() .. " is updating its HotKey")
-- end
--
-- local aEvt = CreateFrame("FRAME")
-- aEvt:RegisterEvent("ADDON_LOADED")
-- aEvt:RegisterEvent("PLAYER_LOGIN")

----------------------------------------------------------------------
-- Accept party invites from friends
----------------------------------------------------------------------


----------------------------------------------------------------------
-- Quest dialog
----------------------------------------------------------------------


----------------------------------------------------------------------
-- Press enter to delete rare items
----------------------------------------------------------------------
StaticPopupDialogs["DELETE_ITEM"].enterClicksFirstButton = 1
StaticPopupDialogs["DELETE_QUEST_ITEM"].enterClicksFirstButton = 1

StaticPopupDialogs["DELETE_GOOD_ITEM"] = StaticPopupDialogs["DELETE_ITEM"]
StaticPopupDialogs["DELETE_GOOD_QUEST_ITEM"] = StaticPopupDialogs["DELETE_QUEST_ITEM"]

----------------------------------------------------------------------
-- Press enter to equip BOEs
----------------------------------------------------------------------
StaticPopupDialogs["EQUIP_BIND"].enterClicksFirstButton = 1
StaticPopupDialogs["EQUIP_BIND_TRADEABLE"].enterClicksFirstButton = 1

----------------------------------------------------------------------
-- Auto vendor grays
----------------------------------------------------------------------

local g = CreateFrame("Frame")
g:RegisterEvent("MERCHANT_SHOW")

g:SetScript("OnEvent", function()
  totalPrice = 0
  for bags = 0,4 do
    for slots = 1, GetContainerNumSlots(bags) do
      CurrentItemLink = GetContainerItemLink(bags, slots)
      if CurrentItemLink then
        _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(CurrentItemLink)
        _, itemCount = GetContainerItemInfo(bags, slots)
        if itemRarity == 0 and itemSellPrice ~= 0 then
          totalPrice = totalPrice + (itemSellPrice * itemCount)
          UseContainerItem(bags, slots)
          PickupMerchantItem()
        end
      end
    end
  end

  if totalPrice ~= 0 then
    print('Sold gray items for ' .. GetCoinTextureString(totalPrice))
  end
----------------------------------------------------------------------
  -- Auto repair
---------------------------------------------------------------------
  if(CanMerchantRepair()) then
    local cost = GetRepairAllCost()
    if cost > 0 then
      local money = GetMoney()
      if money > cost then
        RepairAllItems()
        print('Repaired items for ' .. GetCoinTextureString(cost))
      else
        print("Not enough gold to cover the repair cost.")
      end
    end
  end
end)

----------------------------------------------------------------------
-- Hide talking head frame
----------------------------------------------------------------------
-- Function to hide the talking frame
local function NoTalkingHeads()
    hooksecurefunc(TalkingHeadFrame, "Show", function(self)
        self:Hide()
    end)
end

-- Run function when Blizzard addon is loaded
if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
    NoTalkingHeads()
else
    local waitFrame = CreateFrame("FRAME")
    waitFrame:RegisterEvent("ADDON_LOADED")
    waitFrame:SetScript("OnEvent", function(self, event, arg1)
        if arg1 == "Blizzard_TalkingHeadUI" then
            NoTalkingHeads()
            waitFrame:UnregisterAllEvents()
        end
    end)
end
----------------------------------------------------------------------
-- Auto-insert keystones
----------------------------------------------------------------------
local function InsertKeystone()
    ChallengesKeystoneFrame:HookScript("OnShow", function()
        for Bag = 0, NUM_BAG_SLOTS do
            for Slot = 1, GetContainerNumSlots(Bag) do
                local ID = GetContainerItemID(Bag, Slot)

                if (ID and ID == 180653) then
                    return UseContainerItem(Bag, Slot)
                end
            end
        end
    end)
end

if IsAddOnLoaded("Blizzard_ChallengesUI") then
    InsertKeystone()
else
    local waitFrame = CreateFrame("FRAME")
    waitFrame:RegisterEvent("ADDON_LOADED")
    waitFrame:SetScript("OnEvent", function(self, event, arg1)
        if arg1 == "Blizzard_ChallengesUI" then
            InsertKeystone()
            waitFrame:UnregisterAllEvents()
        end
    end)
end
