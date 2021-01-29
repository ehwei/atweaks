----------------------------------------------------------------------
--                          SLASH COMMANDS                          --
----------------------------------------------------------------------
SlashCmdList["READYCHECK"] = function() DoReadyCheck() end
SlashCmdList["LEAVEGROUP"] = function() C_PartyInfo.LeaveParty() end
SlashCmdList["TOUT"] = function() LFGTeleport(true) end
SlashCmdList["TIN"] = function() LFGTeleport() end
SlashCmdList["TELE"] = function() LFGTeleport(IsInInstance()) end
SlashCmdList["GREATVAULT"] = function() LoadAddOn("Blizzard_WeeklyRewards"); local wrf=WeeklyRewardsFrame if wrf:IsVisible() then wrf:Hide() else wrf:Show() end end
SlashCmdList["SOULBINDVIEW"] = function() LoadAddOn("Blizzard_Soulbinds"); local sbf=SoulbindViewer if sbf:IsVisible() then sbf:Hide() else sbf:Open() end end
SlashCmdList["RELOADSAY"] = function() if IsInGroup() then SendChatMessage("reloading", "INSTANCE_CHAT") end ReloadUI() end
-- SlashCmdList["RELOADSAY"] = function() if IsInGroup() then SendChatMessage("reloading", IsInRaid() and "RAID" or IsInGroup() and "PARTY" or IsInInstance() and "INSTANCE_CHAT") end ReloadUI() end
SlashCmdList["INVJAMIE"] = function() SendChatMessage("123", "WHISPER", nil, "Luckerdog"); SendChatMessage("123", "WHISPER", nil, "Shouldbeokay") end

SLASH_READYCHECK1   = "/rc"
SLASH_LEAVEGROUP1   = "/lg" -- leave group
SLASH_TOUT1         = "/tout" -- teleport out of instance
SLASH_TIN1          = "/tin" -- teleport into instance
SLASH_TELE1         = "/tele" -- teleport in/out of instance
SLASH_GREATVAULT1   = "/gv" -- open weekly vault
SLASH_SOULBINDVIEW1 = "/sb"
SLASH_RELOADSAY1    = "/rls" -- sends 'reloading' to relevant chat before reloading
SLASH_INVJAMIE1     = "/123" -- sends 123 to jamie
