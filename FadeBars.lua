local _, FadeBlizzardBars = ...
local _G = _G

local MainActionBar = FadeBlizzardBars.ActionBarNames.MainActionBar

FadeBlizzardBars.HandleFadeBar = function(barName, buttonData, isPrefix)
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
        fadeTimer = C_Timer.NewTimer(FadeBlizzardBars.FadeConstants.FADE_OUT_DELAY,
        function()
            UIFrameFadeOut(bar, FadeBlizzardBars.FadeConstants.FADE_OUT_TIME, bar:GetAlpha(), 0)
            fadeTimer = nil
        end)
    end

    local function UpdateVisibility()
        if barName == MainActionBar and GetActionBarPage() == 2 then
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