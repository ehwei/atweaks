local db_location = CreateFrame("Frame", "atLocation_Text")
db_location.obj = LibStub("LibDataBroker-1.1"):NewDataObject("atLocation", {type = "data source", text = "db_location"})


local GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local GetBestMapForUnit = C_Map.GetBestMapForUnit
local format = string.format
local CTimerAfter = C_Timer.After
local zonetext = GetMinimapZoneText()

local function color(location)
    local zonetype, _ = GetZonePVPInfo()

    if zonetype == "arena" or zonetype == "combat" or zonetype == "hostile" then
        return string.format("|cffFF0000"..location.."|r") -- #FF0000
    elseif zonetype == "contested" or zonetype == "nil" then
        return string.format("|cffFFA500"..location.."|r") -- #FFA500
    elseif zonetype == "friendly" then
        return string.format("|cffffd100"..location.."|r") -- #ffd100
    elseif zonetype == "sanctuary" then
        return string.format("|cff87ceff"..location.."|r") -- #87ceff
    end

end

local function getcoords()
	CTimerAfter(1, coords)
	local map = C_Map.GetBestMapForUnit("player")
	if map then
		local position = C_Map.GetPlayerMapPosition(map, "player")
		if position then
			db_location.obj.text = color(zonetext)..format("  |cffffd100(%.1f, %.1f)|r", position.x*100, position.y*100)
		else
			db_location.obj.text = "00.0, 00.0"
		end
	end
end
getcoords()
