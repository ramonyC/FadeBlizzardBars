--[[
	Copyright (c) 2026, Vitaliy "Ramony" Chernishev < chernush.vitaly at gmail dot com >
	All rights reserved.
]]

local _, FadeBlizzardBars = ...
_G.FadeBlizzardBars = FadeBlizzardBars
local _G = _G

local function CreateHoverBar(barName, buttonData, isPrefix)
    local bar = _G[barName]
    if not bar
    then return
    end

    bar:SetAlpha(0)
    local fadeTimer = nil

    local function FadeIn()
        if fadeTimer then
            fadeTimer:Cancel()
            fadeTimer = nil
        end

        UIFrameFadeIn(bar, FadeBlizzardBars.FadeConstants.FADE_IN_TIME, bar:GetAlpha(), 1)
    end

    local function FadeOut()
        fadeTimer = C_Timer.NewTimer(FadeBlizzardBars.FadeConstants.FADE_OUT_DELAY, function()
            UIFrameFadeOut(bar, FadeBlizzardBars.FadeConstants.FADE_OUT_TIME, bar:GetAlpha(), 0)
            fadeTimer = nil
        end)
    end

    local function UpdateVisibility()
        if barName == "MainActionBar" and GetActionBarPage() == 2 then
            FadeIn()
        else
            FadeOut()
        end
    end

    local pageWatcher = CreateFrame("Frame")
    pageWatcher:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    pageWatcher:SetScript("OnEvent", UpdateVisibility)

    bar:EnableMouse(true)
    bar:HookScript("OnEnter", FadeIn)
    bar:HookScript("OnLeave", FadeOut)

    if isPrefix then
        for i = 1, 12 do
            local btn = _G[buttonData .. i]
            if btn then
                btn:HookScript("OnEnter", FadeIn)
                btn:HookScript("OnLeave", FadeOut)
            end
        end
    else
        for _, btnName in ipairs(buttonData) do
            local btn = _G[btnName]
            if btn then
                btn:HookScript("OnEnter", FadeIn)
                btn:HookScript("OnLeave", FadeOut)
            end
        end
    end
end

local function ApplyClickThru()
    for _, barData in ipairs(FadeBlizzardBars.ClickThruBars) do
        local bar = _G[barData.frame]
        if bar then
            bar:EnableMouse(false)
            for i = 1, 12 do
                local btn = _G[barData.buttons .. i]
                if btn then btn:EnableMouse(false) end
            end
        end
    end
end

local function ApplyHoverBars()
    for _, barData in ipairs(FadeBlizzardBars.HoverBars) do
        CreateHoverBar(barData.frame, barData.buttons, true)
    end
    for _, barData in ipairs(FadeBlizzardBars.UniqueHoverBars) do
        CreateHoverBar(barData.frame, barData.buttons, false)
    end
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
    ApplyClickThru()
    ApplyHoverBars()
end

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
