--[[
	MIT License
	Copyright (c) 2026, Vitaliy "Ramony" Chernishev < chernush.vitaly at gmail dot com >
	See LICENSE for details.
]]

local _, FadeBlizzardBars = ...
FadeBlizzardBars = LibStub("AceAddon-3.0")
    :NewAddon(FadeBlizzardBars, "FadeBlizzardBars", "AceEvent-3.0", "AceConsole-3.0");

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

    -- Native Menu Options
    local panel = CreateFrame("Frame")
    panel.name = "FadeBlizzardBars"

    -- Header
    local label = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    label:SetPoint("TOPLEFT", 16, -16)
    label:SetText("FadeBlizzardBars")

    -- Divider
    local divider = panel:CreateTexture(nil, "ARTWORK")
    divider:SetPoint("TOPLEFT", 16, -55)
    divider:SetSize(300, 1)
    divider:SetColorTexture(0.4, 0.4, 0.4, 0.8)

    -- Commands
    local commands = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    commands:SetPoint("TOPLEFT", 16, -70)
    commands:SetTextColor(1, 1, 1)
    commands:SetText("Commands:")

    local cmd1 = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    cmd1:SetPoint("TOPLEFT", 16, -90)
    cmd1:SetText("|cff00ffff/fbb|r — Open configuration window")

    local cmd2 = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    cmd2:SetPoint("TOPLEFT", 16, -110)
    cmd2:SetText("|cff00ffff/fbb on|r — Enable FadeBlizzardBars")

    local cmd3 = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    cmd3:SetPoint("TOPLEFT", 16, -130)
    cmd3:SetText("|cff00ffff/fbb off|r — Disable FadeBlizzardBars")

    -- Button
    local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", 16, -160)
    button:SetSize(140, 24)
    button:SetText("Open Options")
    button:SetScript("OnClick", function()
        if InCombatLockdown() then
            print("|cff00ff00FadeBlizzardBars:|r Cannot change settings while in combat.")
            return
        end

        LibStub("AceConfigDialog-3.0"):Open("FadeBlizzardBars")
    end)

    local category = Settings.RegisterCanvasLayoutCategory(panel, "FadeBlizzardBars")
    Settings.RegisterAddOnCategory(category)
    -- End of Native Menu Options

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
    self:ApplyShowOnMount()
end

FadeBlizzardBars:RegisterEvent("PLAYER_ENTERING_WORLD", function()
    FadeBlizzardBars:RestoreBlizzardDefaults()
    FadeBlizzardBars:ApplyClickThrough()
    FadeBlizzardBars:ApplyFade()
    FadeBlizzardBars:ApplyScale()
    FadeBlizzardBars:ApplyHideHotKeys()
    FadeBlizzardBars:ApplyShowOnMount()
end)

SLASH_FBB1 = "/fbb"
SlashCmdList["FBB"] = function(msg)
    if InCombatLockdown() then
        print("|cff00ff00FadeBlizzardBars:|r Cannot change settings while in combat.")
        return
    end

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
