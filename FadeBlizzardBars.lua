--[[
	MIT License
	Copyright (c) 2026, Vitaliy "Ramony" Chernishev < chernush.vitaly at gmail dot com >
	See LICENSE for details.
]]

local _, FadeBlizzardBars = ...
FadeBlizzardBars = LibStub("AceAddon-3.0"):NewAddon(FadeBlizzardBars, "FadeBlizzardBars", "AceEvent-3.0", "AceConsole-3.0");
_G.FadeBlizzardBars = FadeBlizzardBars

function FadeBlizzardBars:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("FadeBlizzardBarsDB", FadeBlizzardBars.DbDefaults)
    self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")

    FadeBlizzardBars.OptionsConfig.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    FadeBlizzardBars.OptionsConfig.args.profiles.type = "group"
    FadeBlizzardBars.OptionsConfig.args.profiles.order = 99


    LibStub("AceConfig-3.0"):RegisterOptionsTable("FadeBlizzardBars", FadeBlizzardBars.OptionsConfig)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FadeBlizzardBars", "FadeBlizzardBars")

    if self.db.profile.enabled then
        FadeBlizzardBars:EnableAddon()
    end

    print("|cff00ff00FadeBlizzardBars:|r Available commands: |cff00ffff/fbb on|r to enable," ..
    " |cff00ffff/fbb off|r to disable, |cff00ffff/fbb|r to configure")
end

function FadeBlizzardBars:OnProfileChanged()
    self:RestoreBlizzardDefaults()
    self:ApplyClickThrough()
    self:ApplyFade()
    self:ApplyScale()
    self:ApplyHideHotKeys()
end

FadeBlizzardBars:RegisterEvent("PLAYER_ENTERING_WORLD", function()
    FadeBlizzardBars:RestoreBlizzardDefaults()
    FadeBlizzardBars:ApplyClickThrough()
    FadeBlizzardBars:ApplyFade()
    FadeBlizzardBars:ApplyScale()
    FadeBlizzardBars:ApplyHideHotKeys()
end)

SLASH_FBB1 = "/fbb"
SlashCmdList["FBB"] = function(msg)
    if msg == "off" then
        FadeBlizzardBars:DisableAddon()
        print("|cff00ff00FadeBlizzardBars:|r Disabled")
    elseif msg == "on" then
        FadeBlizzardBars:EnableAddon()
        print("|cff00ff00FadeBlizzardBars:|r Enabled")
    else
        LibStub("AceConfigDialog-3.0"):Open("FadeBlizzardBars")
    end
end
