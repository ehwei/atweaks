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
-- Custom Fonts
----------------------------------------------------------------------

-- local EventFrame = CreateFrame("Frame")
-- EventFrame:RegisterEvent("VARIABLES_LOADED")
-- EventFrame:SetScript("OnEvent", function(_, event)
--
--    SetCVar ("nameplateSelfTopInset", .55)
--    SetCVar("nameplateSelfAlpha", 1)
--
-- end)
----------------------------------------------------------------------
-- Custom Fonts
----------------------------------------------------------------------
-- UNIT_NAME_FONT     = "Interface\\AddOns\\DTweaks\\DTweaks.ttf"
-- DAMAGE_TEXT_FONT   = "Interface\\AddOns\\DTweaks\\DTweaks.ttf"
-- STANDARD_TEXT_FONT = "Interface\\AddOns\\DTweaks\\DTweaks.ttf"

----------------------------------------------------------------------
-- Default Nameplate fonts
----------------------------------------------------------------------

-- --  Nametag font size
-- local function SetFont(obj,optSize)
--     local fontName=obj:GetFont()
--     obj:SetFont(fontName,optSize,"THINOUTLINE")
-- end
--
-- SetFont(SystemFont_LargeNamePlate,12)
-- SetFont(SystemFont_NamePlate,12)
-- SetFont(SystemFont_LargeNamePlateFixed,12)
-- SetFont(SystemFont_NamePlateFixed,12)

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

----------------------------------------------------------------------
-- Hide Gryphons (I think dominos does this)
----------------------------------------------------------------------
-- MainMenuBarArtFrame.LeftEndCap:Hide();
-- MainMenuBarArtFrame.RightEndCap:Hide();
--      MainMenuBarArtFrameBackground:Hide()

--
-- SetCVar("emphasizeMySpellEffects", 10)
-- SetCVar("TargetPriorityCombatLock", 2)
-- SetCVar("TargetPriorityCombatLockHighlight", 1)
-- SetCVar("TargetPriorityPVP", 3)
-- SetCVar("stopAutoAttackOnTargetChange", 1)
-- SetCVar("Sound_EnableErrorSpeach", 0)
-- SetCVar("autoLootDefault", 1)
-- SetCVar("cameraDistanceMaxZoonFactor", 2.6)
-- SetCVar("checkAddonVersion", 0)
-- SetCvar("ffxDeath", 0)
-- SetCvar("ffxGlow", 0)
-- SetCVar("gxMaxFrameLatency", 5)
-- SetCvar("PreemptiveCastEnable", 1)
-- SetCvar("projectedTextures", 1)
-- SetCvar("screenshotQuality", 10)
-- SetCvar("ShakeStrengthCamera", 0)
-- SetCvar("ShakeStrengthUI", 0)
-- SetCvar("SpellQueueWindow", 80)
-- SetCVar("threatShowNumberic", 1)
-- SetCVar("TurnSpeed", 260)
-- SetCVar("useHighResolutionUITextures", 1)
-- SetCVar("ViolenceLevel", 100)

----------------------------------------------------------------------
-- Update Keybindings
----------------------------------------------------------------------

-- -- Global variables
-- GreyOnCooldown.VERSION = "1.0.6"
-- GreyOnCooldown.AddonBartender4IsPresent = false
-- GreyOnCooldown.Bartender4ButtonsTable = {}
-- -- Function to hook to 'Bartender4.ActionBar.ApplyConfig' to reconfigure all BT4Buttons when Bartender4 ActionBars are loaded or modified
-- function atweaks:HookBartender4atweaksIcons()
-- 	for i = 1, 120 do
-- 		if (not atweaks.Bartender4ButtonsTable[i]) then
-- 			atweaks.Bartender4ButtonsTable[i] = _G["BT4Button"..i]
-- 			local button = atweaks.Bartender4ButtonsTable[i]
-- 			if (button and (not button.GREYONCOOLDOWN_BT4_HOOKED)) then
-- 				-- Hook to 'GetCooldown' (BT4Button) function because we can't hook the local 'UpdateCooldown' (BT4Button) function
-- 				hooksecurefunc(button, 'GetCooldown', ActionButtonatweaks_UpdateCooldown)
-- 				button.GREYONCOOLDOWN_BT4_HOOKED = true
-- 			end
-- 		end
-- 	end
-- end
--
--
-- local map = {
-- 	["Middle Mouse"] = "M3",
-- 	["Mouse Wheel Down"] = "DWN",
-- 	["Mouse Wheel Up"] = "UP",
--     ["Home"] = "Hm",
--     ["Insert"] = "Ins",
--     ["Page Down"] = "PD",
--     ["Page Up"] = "PU",
--     ["Spacebar"] = "SpB",
-- }
--
-- local patterns = {
-- 	["Mouse Button "] = "M", -- M4, M5
-- 	["Num Pad "] = "N",
-- 	["a%-"] = "A", -- alt
-- 	["c%-"] = "C", -- ctrl
-- 	["s%-"] = "S", -- shift
-- }
--
-- local bars = {
-- 	"ActionButton",
-- 	"MultiBarBottomLeftButton",
-- 	"MultiBarBottomRightButton",
-- 	"MultiBarLeftButton",
-- 	"MultiBarRightButton",
-- }
--
-- local function UpdateHotkey(self, actionButtonType)
-- 	local hotkey = self.HotKey
-- 	local text = hotkey:GetText()
-- 	for k, v in pairs(patterns) do
-- 		text = text:gsub(k, v)
-- 	end
-- 	hotkey:SetText(map[text] or text)
-- end
--
-- for _, bar in pairs(bars) do
-- 	for i = 1, NUM_ACTIONBAR_BUTTONS do
-- 		hooksecurefunc(_G[bar..i], "UpdateHotkeys", UpdateHotkey)
-- 	end
-- end
