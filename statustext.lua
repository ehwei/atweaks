StatsFrame = CreateFrame("Frame", "StatsFrame", UIParent)
StatsFrame:ClearAllPoints()
StatsFrame:SetPoint('BOTTOMRIGHT', UIParent, "BOTTOMRIGHT", 0, 5)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)

  local color
  if customColor == false then
    color = {r = 1, g = 1, b = 1}
  else
    local _, class = UnitClass("player")
    color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
  end

  local function getFPS()
    return "|c00ffffff" .. floor(GetFramerate()) .. "|r fps"
  end

  local function getLatencyWorld()
    return "|c00ffffff" .. select(4, GetNetStats()) .. "|r ms"
  end

  local function getLatency()
    return "|c00ffffff" .. select(3, GetNetStats()) .. "|r ms"
  end

  StatsFrame:SetWidth(50)
  StatsFrame:SetHeight(14)
  StatsFrame.text = StatsFrame:CreateFontString(nil, "BACKGROUND")
  StatsFrame.text:SetPoint("CENTER", StatsFrame)
  StatsFrame.text:SetFont("FONTS\\FRIZQT__.TTF", 11, "OUTLINE")
  StatsFrame.text:SetTextColor(color.r, color.g, color.b)

  local lastUpdate = 0

  local function update(self, elapsed)
    lastUpdate = lastUpdate + elapsed
    if lastUpdate > 1 then
      lastUpdate = 0
      if showClock == true then
        StatsFrame.text:SetText(getFPS() .. " " .. getLatency())
      else
        StatsFrame.text:SetText(getFPS() .. " " .. getLatency())
      end
      self:SetWidth(StatsFrame.text:GetStringWidth())
      self:SetHeight(StatsFrame.text:GetStringHeight())
    end
  end

  StatsFrame:SetScript("OnUpdate", update)

end)
