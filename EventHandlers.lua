local _, FadeBlizzardBars = ...

FadeBlizzardBars.PageWatchers = {}

local RegisteredFadeHooks = {}

local RegisteredHooks = {}

FadeBlizzardBars.RegisterFadeHook = function(key)
    RegisteredFadeHooks[key] = true
end

FadeBlizzardBars.IsFadeHookRegistered = function(key)
    return RegisteredFadeHooks[key] == true
end

FadeBlizzardBars.RegisterHook = function(key)
    RegisteredHooks[key] = true
end

FadeBlizzardBars.IsHookRegistered = function(key)
    return RegisteredHooks[key] == true
end