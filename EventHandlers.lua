local _, FadeBlizzardBars = ...

FadeBlizzardBars.PageWatchers = {}

local RegisteredHooks = {}

FadeBlizzardBars.RegisterHook = function(key)
    RegisteredHooks[key] = true
end

FadeBlizzardBars.IsHookRegistered = function(key)
    return RegisteredHooks[key] == true
end