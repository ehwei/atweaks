----------------------------------------------------------------------
-- Dampening Display
----------------------------------------------------------------------
local pvpFrame = CreateFrame("Frame", nil , UIParent)
local _
local FindAuraByName = AuraUtil.FindAuraByName
local dampeningtext = GetSpellInfo(110310)


pvpFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
pvpFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
pvpFrame:SetPoint("TOP", UIWidgetTopCenterContainerFrame, "BOTTOM", 0, 0)
pvpFrame:SetSize(200, 11.38) --11,38 is the height of the remaining time
pvpFrame.text = pvpFrame:CreateFontString(nil, "BACKGROUND")
pvpFrame.text:SetFontObject(GameFontNormalSmall)
pvpFrame.text:SetAllPoints()


function pvpFrame:UNIT_AURA(unit)
	--     1	  2		3		4			5			6			7			8				9				  10		11			12				13				14		15		   16
	local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, nameplateShowAll, noIdea, timeMod , percentage = FindAuraByName(dampeningtext, unit, "HARMFUL")

	if percentage then
		if not self:IsShown() then
			self:Show()
		end
		if self.dampening ~= percentage then
			self.dampening = percentage
			self.text:SetText(dampeningtext..": "..percentage.."%")
		end

	elseif self:IsShown() then
		self:Hide()
	end
end

function pvpFrame:PLAYER_ENTERING_WORLD()
	local _, instanceType = IsInInstance()
	if instanceType == "arena" then
		self:RegisterUnitEvent("UNIT_AURA", "player")
	else
		self:UnregisterEvent("UNIT_AURA")
	end
end

----------------------------------------------------------------------
-- Shaman Totem Auras
-- see: https://github.com/rgd87/NugTotemIcon
----------------------------------------------------------------------

local totemEvt = CreateFrame("Frame", nil, UIParent)
totemEvt:RegisterEvent("NAME_PLATE_UNIT_ADDED")
totemEvt:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

totemEvt:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, event, ...)
end)

-- nameplateShowEnemyGuardians = "0",
-- nameplateShowEnemyMinions   = "0",
-- nameplateShowEnemyMinus     = "0",
-- nameplateShowEnemyPets      = "1",
-- nameplateShowEnemyTotems    = "1",

local function GetUnitNPCID(unit)
    local guid = UnitGUID(unit)
    local _, _, _, _, _, npcID = strsplit("-", guid);
    return tonumber(npcID)
end

local totemNpcIDs = {
    -- [npcID] = { spellID, duration }
    [2630] = { 2484, 20 }, -- Earthbind
    [3527] = { 5394, 15 }, -- Healing Stream
    [6112] = { 8512, 120 }, -- Windfury
    [97369] = { 192222, 15 }, -- Liquid Magma
    [5913] = { 8143, 10 }, -- Tremor
    [5925] = { 204336, 3 }, -- Grounding
    [78001] = { 157153, 15 }, -- Cloudburst
    [53006] = { 98008, 6 }, -- Spirit Link
    [59764] = { 108280, 12 }, -- Healing Tide
    [61245] = { 192058, 2 }, -- Static Charge
    [100943] = { 198838, 15 }, -- Earthen Wall
    [97285] = { 192077, 15 }, -- Wind Rush
    [105451] = { 204331, 15 }, -- Counterstrike
    [104818] = { 207399, 30 }, -- Ancestral
    [105427] = { 204330, 15 }, -- Skyfury

    -- Warrior
    [119052] = { 236320, 15 }, -- War Banner
}

local function CreateIcon(nameplate)
    local totemf = CreateFrame("Frame", nil, nameplate)
    totemf:SetSize(33, 33)
    totemf:SetPoint("BOTTOM", nameplate, "TOP", 0, 5)

    local icon = totemf:CreateTexture(nil, "ARTWORK")
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    icon:SetAllPoints()

    local bg = totemf:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\BUTTONS\\WHITE8X8")
    bg:SetVertexColor(0, 0, 0, 0.5)
    bg:SetPoint("TOPLEFT", totemf, "TOPLEFT", -2, 2)
    bg:SetPoint("BOTTOMRIGHT", totemf, "BOTTOMRIGHT", 2, -2)

    totemf.icon = icon
    totemf.bg = bg

    return totemf
end

function totemEvt.NAME_PLATE_UNIT_ADDED(self, event, unit)
    local np = C_NamePlate.GetNamePlateForUnit(unit)
    local npcID = GetUnitNPCID(unit)

    if npcID and totemNpcIDs[npcID] then
        if not np.NugTotemIcon then
            np.NugTotemIcon = CreateIcon(np)
        end

        local iconFrame = np.NugTotemIcon
        iconFrame:Show()

        local totemData = totemNpcIDs[npcID]
        local spellID, duration = unpack(totemData)

        local tex = GetSpellTexture(spellID)

        iconFrame.icon:SetTexture(tex)
    end
end

function totemEvt.NAME_PLATE_UNIT_REMOVED(self, event, unit)
    local np = C_NamePlate.GetNamePlateForUnit(unit)
    if np.NugTotemIcon then
        np.NugTotemIcon:Hide()
    end
end


----------------------------------------------------------------------
-- Automatically release in battlegrounds
----------------------------------------------------------------------

-- LpEvt:RegisterEvent("PLAYER_DEAD");
--
-- if event == "PLAYER_DEAD" then
--
--     -- If player has ability to self-resurrect (soulstone, reincarnation, etc), do nothing and quit
--     if C_DeathInfo.GetSelfResurrectOptions() and #C_DeathInfo.GetSelfResurrectOptions() > 0 then return end
--
--     -- Resurrect if player is in a battleground
--     local InstStat, InstType = IsInInstance()
--     if InstStat and InstType == "pvp" then
--         RepopMe()
--         return
--     end
--
--     -- Resurrect if playuer is in a PvP location
--     local areaID = C_Map.GetBestMapForUnit("player") or 0
--     if areaID == 123 -- Wintergrasp
--     or areaID == 244 -- Tol Barad (PvP)
--     or areaID == 588 -- Ashran
--     or areaID == 622 -- Stormshield
--     or areaID == 624 -- Warspear
--     then
--         RepopMe()
--         return
--     end
--
--     return
--
-- end
