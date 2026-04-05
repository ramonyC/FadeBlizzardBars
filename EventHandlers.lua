local _, FadeBlizzardBars = ...

FadeBlizzardBars.PageWatchers = {}

local RegisteredFadeHooks = {}

FadeBlizzardBars.RegisterFadeHook = function(key)
    RegisteredFadeHooks[key] = true
end

FadeBlizzardBars.IsFadeHookRegistered = function(key)
    return RegisteredFadeHooks[key] == true
end