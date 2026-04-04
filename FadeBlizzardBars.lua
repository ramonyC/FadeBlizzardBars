--[[
	Copyright (c) 2026, Vitaliy "Ramony" Chernishev < chernush.vitaly at gmail dot com >
	All rights reserved.
]]

local _, FadeBlizzardBars = ...
_G.FadeBlizzardBars = FadeBlizzardBars
local _G = _G


local function ApplyHoverBars()
    for _, barData in ipairs(FadeBlizzardBars.HoverBars) do
        FadeBlizzardBars.HandleFadeBar(_G, barData.frame, barData.buttons, true)
    end

    for _, barData in ipairs(FadeBlizzardBars.UniqueHoverBars) do
        FadeBlizzardBars.HandleFadeBar(_G, barData.frame, barData.buttons, false)
    end
end

local function ApplyClickThrough()
    FadeBlizzardBars.HandleClickThrough(_G)
end

local function DisableAddon()
    for _, barData in ipairs(FadeBlizzardBars.HoverBars) do
        local bar = _G[barData.frame]
        if bar then bar:SetAlpha(1) end
    end

    for _, barData in ipairs(FadeBlizzardBars.UniqueHoverBars) do
        local bar = _G[barData.frame]
        if bar then bar:SetAlpha(1) end
    end

    for _, barData in ipairs(FadeBlizzardBars.ClickThruBars) do
        local bar = _G[barData.frame]
        if bar then
            bar:EnableMouse(true)
            for i = 1, 12 do
                local btn = _G[barData.buttons .. i]
                if btn then btn:EnableMouse(true) end
            end
        end
    end
end

local function EnableAddon()
    ApplyClickThrough()
    ApplyHoverBars()
end

local init = CreateFrame("Frame")
init:RegisterEvent("PLAYER_LOGIN")
init:SetScript("OnEvent", function()
    EnableAddon()
    print("|cff00ff00FadeBlizzardBars:|r Type |cff00ffff/fbb on|r to enable, |cff00ffff/fbb off|r to disable")
end)

SLASH_FBB1 = "/fbb"
SlashCmdList["FBB"] = function(msg)
    if msg == "off" then
        DisableAddon()
        print("|cff00ff00FadeBlizzardBars:|r Disabled")
    elseif msg == "on" then
        EnableAddon()
        print("|cff00ff00FadeBlizzardBars:|r Enabled")
    else
        print("|cff00ff00FadeBlizzardBars:|r /fbb on | /fbb off")
    end
end
