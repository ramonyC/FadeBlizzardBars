local _, FadeBlizzardBars = ...

FadeBlizzardBars.PageWatchers = {}

local RegisteredFadeHooks = {}

local RegisteredShowInCombatHooks = {}

FadeBlizzardBars.RegisterFadeHook = function(key)
    RegisteredFadeHooks[key] = true
end

FadeBlizzardBars.IsFadeHookRegistered = function(key)
    return RegisteredFadeHooks[key] == true
end

FadeBlizzardBars.RegisterShowInCombatHook = function(key)
    RegisteredShowInCombatHooks[key] = true
end

FadeBlizzardBars.IsShowInCombatHookRegistered = function(key)
    return RegisteredShowInCombatHooks[key] == true
end