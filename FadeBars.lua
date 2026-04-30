local _, FadeBlizzardBars = ...
local _G = _G
local MainActionBar = FadeBlizzardBars.ActionBarNames.MainActionBar

local function SetBarAlpha(bar, alpha, skip)
    if not bar or skip == true then
        return
    end

    bar:SetAlpha(alpha or 0)
end

local function IsFadeEnabled(barKey)
    return FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "fade") == true
        and FadeBlizzardBars.Utilities.AddonEnabled() == true
end

local function IsShowOnPageChangeEnabled()
    return FadeBlizzardBars.Utilities.GetDBBarOption("mainActionBar", "additionalOptions").showOnPageChange == true
end

local function ShouldShowOnPageChange()
    return GetActionBarPage() ~= 1 and IsShowOnPageChangeEnabled()
end

local function LockActionBarInCombat(barKey)
    return InCombatLockdown() == true and FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "showInCombat") == true
end

local function LockActionBarOnMount(barKey)
    return IsMounted() == true and FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "showOnMount") == true
end

local function SpellFlyoutOnHideHook()
    if FadeBlizzardBars.IsHookRegistered("SpellFlyoutOnHideHook") then
        return
    end

    FadeBlizzardBars.RegisterHook("SpellFlyoutOnHideHook")
    SpellFlyout:HookScript("OnHide", function()
        FadeBlizzardBars:ApplyFade()
    end)
end

local function LockSpellFlyoutIsShown(barKey)
    if (SpellFlyout:IsShown() == true) then
        local parentButtonName = SpellFlyout:GetParent():GetName()
        if parentButtonName and string.find(parentButtonName:lower(), barKey:lower()) then
            SpellFlyoutOnHideHook()

            return true
        end
     end

     return false
end

local function LockMainActionBarOnVehicle()
    local vehicleButton = _G[FadeBlizzardBars.ActionBarNames.VehicleLeaveButton]
    if vehicleButton then
        return vehicleButton:IsShown()
    end

    return false
end

local function UpdateVisibility(page, showOnPageChange, fadeInCallback, fadeOutCallback)
    if page ~= 1 and showOnPageChange then
        fadeInCallback()
    else
        fadeOutCallback()
    end
end

local function RegisterFadeHook(bar, barKey, buttons, fadeInCallback, fadeOutCallback)
    if FadeBlizzardBars.IsHookRegistered(barKey) then
        return
    end

    FadeBlizzardBars.RegisterHook(barKey)
    bar:HookScript("OnEnter", fadeInCallback)
    bar:HookScript("OnLeave", fadeOutCallback)

    for _, buttonKey in ipairs(buttons) do
        local btn = _G[buttonKey]
        if btn then
            btn:HookScript("OnEnter", fadeInCallback)
            btn:HookScript("OnLeave", fadeOutCallback)
        end
    end
end

local function RegisterCombatHook()
    if FadeBlizzardBars.IsHookRegistered("FadeCombatHook") then
        return
    end

    FadeBlizzardBars.RegisterHook("FadeCombatHook")
    FadeBlizzardBars:RegisterEvent("PLAYER_REGEN_DISABLED", function()
        LibStub("AceConfigDialog-3.0"):Close("FadeBlizzardBars")
        for _, barData in ipairs(FadeBlizzardBars.ActionBarCollection) do
            if FadeBlizzardBars.Utilities.GetDBBarOption(barData.key, "showInCombat") == true then
                local bar = _G[barData.frame]
                SetBarAlpha(bar, 1)
            end
        end
    end)

    FadeBlizzardBars:RegisterEvent("PLAYER_REGEN_ENABLED", function()
        for _, barData in ipairs(FadeBlizzardBars.ActionBarCollection) do
            if FadeBlizzardBars.Utilities.GetDBBarOption(barData.key, "showInCombat") == true then
                FadeBlizzardBars:ApplyFade(barData.key)
            end
        end
    end)
end

local function RegisterOnMountHook()
    if FadeBlizzardBars.IsHookRegistered("FadeOnMountHook") then
        return
    end

    FadeBlizzardBars.RegisterHook("FadeOnMountHook")
    FadeBlizzardBars:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED", function()
        FadeBlizzardBars:ApplyShowOnMount()
    end)
end

local function RegisterMainActionBarPageWatcher(barKey, fadeInCallback, fadeOutCallback)
    if FadeBlizzardBars.PageWatchers[barKey] ~= nil then
        return
    end

    local pageWatcher = CreateFrame("Frame")
    pageWatcher:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    pageWatcher:SetScript("OnEvent", function(_, _)
        UpdateVisibility(GetActionBarPage(), IsShowOnPageChangeEnabled(), fadeInCallback, fadeOutCallback)
    end)
    FadeBlizzardBars.PageWatchers[barKey] = pageWatcher
end

local function RegisterOnVehicleSecureHook()
    if FadeBlizzardBars.IsHookRegistered("FadeOnVehicleHook") then
        return
    end

    FadeBlizzardBars.RegisterHook("FadeOnVehicleHook")
    hooksecurefunc(_G[FadeBlizzardBars.ActionBarNames.VehicleLeaveButton], "Show",
    function()
        local mainActionBar = _G[FadeBlizzardBars.ActionBarNames.MainActionBar]
        SetBarAlpha(mainActionBar, 1)
    end)

    hooksecurefunc(_G[FadeBlizzardBars.ActionBarNames.VehicleLeaveButton], "Hide",
    function()
        FadeBlizzardBars:ApplyFade("mainActionBar")
    end)
end

local function ShouldApplyFadeIn(key, bar)
    if not IsFadeEnabled(key) or LockActionBarInCombat(key) then
        return false
    end

    if InCombatLockdown() == true then
        SetBarAlpha(bar, 1)
        return false
    end

    return true
end

local function ShouldApplyFadeOut(key, bar, isMainActionBar, alpha)
    if not IsFadeEnabled(key)
        or (isMainActionBar and ShouldShowOnPageChange())
        or (isMainActionBar and LockMainActionBarOnVehicle())
        or LockActionBarInCombat(key)
        or LockActionBarOnMount(key)
        or LockSpellFlyoutIsShown(key)
    then
        return false
    end

    if InCombatLockdown() == true then
        SetBarAlpha(bar, alpha or 0)
        return false
    end

    return true
end

function FadeBlizzardBars:HandleFadeBars(optionKey)
    local userProfile = self.db and self.db.profile or nil
    if not userProfile then
        return
    end

    local options = {}
    if optionKey == nil then
        options = userProfile.barOptions
    else
        options[optionKey] = userProfile.barOptions[optionKey]
    end

    RegisterCombatHook()
    RegisterOnMountHook()
    RegisterOnVehicleSecureHook()
    for key, option in pairs(options) do
        local barData = self.Utilities.GetBarFromCollection(key)
        local bar = _G[barData.frame]

        if bar and option.fade then
            local isMainActionBar = barData.frame == MainActionBar
            SetBarAlpha(bar, option.alpha, ShouldShowOnPageChange())

            local fadeTimer = nil

            local function FadeIn()
                if not ShouldApplyFadeIn(key, bar) then
                    return
                end

                if fadeTimer then
                    fadeTimer:Cancel()
                    fadeTimer = nil
                end

                local userOptions = FadeBlizzardBars.Utilities.GetDBBarOptions(key)
                UIFrameFadeIn(bar, userOptions.fadeSettings.fadeInTime, bar:GetAlpha(), 1)
            end

            local function FadeOut()
                if not ShouldApplyFadeOut(key, bar, isMainActionBar, option.alpha) then
                    return
                end

                local userOptions = FadeBlizzardBars.Utilities.GetDBBarOptions(key)
                fadeTimer = C_Timer.NewTimer(userOptions.fadeSettings.fadeOutDelay,
                    function()
                        UIFrameFadeOut(bar, userOptions.fadeSettings.fadeOutTime, bar:GetAlpha(), userOptions.alpha)
                        fadeTimer = nil
                    end)
            end

            RegisterFadeHook(bar, key, barData.buttons, FadeIn, FadeOut)
            if isMainActionBar == true then
                RegisterMainActionBarPageWatcher(key, FadeIn, FadeOut)
            end
        elseif bar then
            SetBarAlpha(bar, 1)
        end
    end
end
