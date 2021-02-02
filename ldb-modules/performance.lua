local ldb = LibStub("LibDataBroker-1.1");
-- local wFPS = "|cffe1a500w|cff69ccf0FPS";

local ms_text = "|cffffd100 ms|r" -- #ffd100
local mem_text = "|cffffd100MB|r" -- #ffd100
local fps_text = "|cffffd100 fps|r" -- #ffd100

local total_text = "\nTotal memory usage"
local blizz_text = "Total with Blizzard addons"

local dataobj = ldb:NewDataObject("atSystem", { type = "data source", text = "-" })
-- value = 1000,
-- suffix = "fps",
-- icon = "interface\\addons\\dataobj\\img\\icon.tga",
-- label = "|cffe1a500w|cff69ccf0FPS",
-- OnClick = function(_,btn)

-- update every 5s
local updateperiod = 5
local elapsed = 0


-- function to color values
local function color(number, text)

    if number == nil or number == 0 then return "-" end

    if text == "latency" then

        if number <= 75 then
            return string.format("|cff00FF00"..number.."|r") -- #00FF00
        elseif number > 75 and number < 120 then
            return string.format("|cffffd100"..number.."|r") -- #ffd100
        elseif number >= 120 then
            return string.format("|cffFF0000"..number.."|r") -- #FF0000
        end

    elseif text == "fps" then

		if number <= 30 then
			return string.format("|cffFF0000"..number.."|r")
		elseif number > 30 and number < 59 then
			return string.format("|cffffd100"..number.."|r")
		elseif number >= 59 then
			return string.format("|cff00FF00"..number.."|r")
		end

    elseif text == "memory" then

		if number >= 3 then
			return string.format("|cffFF0000"..string.format("%.2f mb", number).."|r")
		elseif number > 0.5 and number < 3 then
			return string.format("|cffFFFF00"..string.format("%.2f mb", number).."|r")
		elseif number <= 0.5 then
			return string.format("|cff00FF00"..string.format("%.2f mb", number).."|r")
		end
    end
end

--- tooltip with home and world latency
local world = color(select(4,GetNetStats()) or 0, "latency")
local home = color(select(3,GetNetStats()) or 0, "latency")
local memTbl, sortTbl = {}, {}

local mySort = function(x,y)
	return x > y
end

function dataobj.OnTooltipShow(tooltip)
    if not tooltip or not tooltip.AddLine then return end

    tooltip:AddLine("System\n\n")
    tooltip:AddLine("Latency\n")
	tooltip:AddDoubleLine("World (Server): ", world..ms_text, 1, 1, 1, 1, 1, 1)
    tooltip:AddDoubleLine("Home (Realm): ", home..ms_text, 1, 1, 1, 1, 1, 1)
    tooltip:AddLine("\nAddon Memory Usage:\n")

    local t = debugprofilestop()
	UpdateAddOnMemoryUsage()
	local shouldBlock = debugprofilestop()-t
	if shouldBlock > 105 then -- Kill if over 105 ms to prevent script too long errors in combat
		inCombat = "block"
	end

	local grandtotal = collectgarbage("count")
	local total = 0

	for i = 1, GetNumAddOns() do
		local memused = GetAddOnMemoryUsage(i)
		if memused > 0 then
			total = total + memused
			memTbl[memused] = GetAddOnInfo(i)
			sortTbl[#sortTbl+1] = memused
		end
	end

	table.sort(sortTbl, mySort)
	local killPoint = 10 -- set max # of addons to show = 10
	for i=1, #sortTbl do
		local val = sortTbl[i]
		tooltip:AddDoubleLine(format("%s", memTbl[val]), color(val/1024, "memory"), 1, 1, 1, 1, 1, 1) -- 1,1,0 = yellow = FFFF00 RGBpercent
		if i == killPoint then break end
	end
	wipe(memTbl)
	wipe(sortTbl)

	tooltip:AddDoubleLine(total_text, "\n"..color(total/1024, "memory"), 1, 1, 1, 0, 1, 0)
	tooltip:AddDoubleLine(blizz_text, color(grandtotal/1024, "memory"), 1, 1, 1, 0, 1, 0)

end

-- Update FPS and Latency text
local UpdateBroker = CreateFrame("Frame")
UpdateBroker:SetScript("OnUpdate", function(self, elap)
	elapsed = elapsed + elap
    if elapsed < updateperiod then
        return
    else
        elapsed = 0
        dataobj.text = color(floor(GetFramerate()) or 0, "fps")..fps_text.." "..color(select(4,GetNetStats()) or 0, "latency")..ms_text
        -- dataobj.value =
	end

end)
