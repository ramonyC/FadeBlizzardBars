local _, FadeBlizzardBars = ...

FadeBlizzardBars.FadeConstants = {
    FADE_IN_TIME = 0.2,
    FADE_OUT_TIME = 0.2,
    FADE_OUT_DELAY = 0.2,
}

local MaxActionBarCount = 12;

local function GetActionBarButtonNameCollection(buttonPrefix)
    local collection = {}
    for i = 1, MaxActionBarCount do
        table.insert(collection, buttonPrefix .. i)
    end
    return collection
end

FadeBlizzardBars.ActionBarNames = {
    MainActionBar = "MainActionBar",
    MultiBarBottomLeft = "MultiBarBottomLeft",
    MultiBarBottomRight = "MultiBarBottomRight",
    MultiBarRight = "MultiBarRight",
    MultiBarLeft = "MultiBarLeft",
    MultiBar5 = "MultiBar5",
    MultiBar6 = "MultiBar6",
    MultiBar7 = "MultiBar7",
    PetActionBar = "PetActionBar",
    StanceBar = "StanceBar",
    BagsBar = "BagsBar",
    MicroMenuContainer = "MicroMenuContainer",
}

FadeBlizzardBars.ActionBarCollection = {
    { key = "mainActionBar", frame = "MainActionBar",   buttons = GetActionBarButtonNameCollection("ActionButton") }, -- Main Action Bar
    { key = "multiBarBottomLeft", frame = "MultiBarBottomLeft", buttons = GetActionBarButtonNameCollection("MultiBarBottomLeftButton") }, -- Bar 2
    { key = "multiBarBottomRight", frame = "MultiBarBottomRight", buttons = GetActionBarButtonNameCollection("MultiBarBottomRightButton") }, -- Bar 3
    { key = "multiBarRight", frame = "MultiBarRight", buttons = GetActionBarButtonNameCollection("MultiBarRightButton") }, -- Bar 4
    { key = "multiBarLeft", frame = "MultiBarLeft", buttons = GetActionBarButtonNameCollection("MultiBarLeftButton") }, -- Bar 5
    { key = "multiBar5", frame = "MultiBar5", buttons = GetActionBarButtonNameCollection("MultiBar5Button") }, -- Bar 6
    { key = "multiBar6", frame = "MultiBar6", buttons = GetActionBarButtonNameCollection("MultiBar6Button") }, -- Bar 7
    { key = "multiBar7", frame = "MultiBar7", buttons = GetActionBarButtonNameCollection("MultiBar7Button") }, -- Bar 8

    { key = "petActionBar", frame = "PetActionBar", buttons = GetActionBarButtonNameCollection("PetActionButton") }, -- Pet Action Bar
    { key = "stanceBar", frame = "StanceBar", buttons = GetActionBarButtonNameCollection("StanceButton") }, -- Stance Bar

    { key = "bagsBar", frame = "BagsBar", buttons = {
        "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot",
        "MainMenuBarBackpackButton", "CharacterReagentBag0Slot", "CharacterReagentBag1Slot", "CharacterReagentBag2Slot", "CharacterReagentBag3Slot"
    } }, -- Bags Bar
    { key = "microMenuContainer", frame = "MicroMenuContainer", buttons = {
        "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton", "AchievementMicroButton",
        "QuestLogMicroButton", "GuildMicroButton", "ProfessionMicroButton", "PlayerSpellsMicroButton", "HousingMicroButton", "LFDMicroButton",
        "CollectionsMicroButton", "EJMicroButton", "StoreMicroButton", "MainMenuMicroButton"
    } }, -- Micro Menu Bar
}

FadeBlizzardBars.DbDefaults = {
	profile = {
		enabled = true,
        barOptions = {
            mainActionBar = { fade = false, clickThrough = false },
            multiBarBottomLeft = { fade = false, clickThrough = false },
            multiBarBottomRight = { fade = false, clickThrough = false },
            multiBarRight = { fade = false, clickThrough = false },
            multiBarLeft = { fade = false, clickThrough = false },
            multiBar5 = { fade = false, clickThrough = false },
            multiBar6 = { fade = false, clickThrough = false },
            multiBar7 = { fade = false, clickThrough = false },
            petActionBar = { fade = false, clickThrough = false },
            stanceBar = { fade = false, clickThrough = false },
            bagsBar = { fade = false, clickThrough = false },
            microMenuContainer = { fade = false, clickThrough = false },
        },
	}
}

-- Obsolete, will be removed in favor of ActionBarNameCollection
FadeBlizzardBars.ClickThruBars = {
    { frame = "MultiBar6", buttons = "MultiBar6Button" }, -- Bar 7
    { frame = "MultiBar7", buttons = "MultiBar7Button" }, -- Bar 8
}

FadeBlizzardBars.HoverBars = {
    { frame = "MainActionBar",   buttons = "ActionButton" }, -- Main Action Bar
    { frame = "MultiBarBottomLeft", buttons = "MultiBarBottomLeftButton" }, -- Bar 2
    { frame = "MultiBarBottomRight", buttons = "MultiBarBottomRightButton" }, -- Bar 3
    { frame = "MultiBarRight", buttons = "MultiBarRightButton" }, -- Bar 4
    { frame = "MultiBarLeft", buttons = "MultiBarLeftButton" }, -- Bar 5
    { frame = "MultiBar5", buttons = "MultiBar5Button" }, -- Bar 6
    { frame = "PetActionBar", buttons = "PetActionButton" }, -- Pet Action Bar
    { frame = "StanceBar", buttons = "StanceButton" }, -- Stance Bar
}

FadeBlizzardBars.UniqueHoverBars = {
    { frame = "BagsBar", buttons = {
        "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot",
        "MainMenuBarBackpackButton", "CharacterReagentBag0Slot", "CharacterReagentBag1Slot", "CharacterReagentBag2Slot", "CharacterReagentBag3Slot"
    } }, -- Bags Bar
    { frame = "MicroMenuContainer", buttons = {
        "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton", "AchievementMicroButton",
        "QuestLogMicroButton", "GuildMicroButton", "ProfessionMicroButton", "PlayerSpellsMicroButton", "HousingMicroButton", "LFDMicroButton",
        "CollectionsMicroButton", "EJMicroButton", "StoreMicroButton", "MainMenuMicroButton"
    } }, -- Micro Menu Bar
}
