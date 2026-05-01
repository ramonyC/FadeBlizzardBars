local _, FadeBlizzardBars = ...

local DefaultFadeConstants = {
    fadeItTime = 0,
    fadeOutTime = 0,
    fadeOutDelay = 0.5,
}

local MaxActionBarCount = 12;

local BugsButtonNames =  {
    "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot", "MainMenuBarBackpackButton",
    "CharacterReagentBag0Slot", "CharacterReagentBag1Slot", "CharacterReagentBag2Slot", "CharacterReagentBag3Slot"
}

local MicroMenuButtonNames = {
    "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton", "AchievementMicroButton",
    "QuestLogMicroButton", "GuildMicroButton", "ProfessionMicroButton", "PlayerSpellsMicroButton", "HousingMicroButton",
    "LFDMicroButton", "CollectionsMicroButton", "EJMicroButton", "StoreMicroButton", "MainMenuMicroButton",
    "QueueStatusButton"
}

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
    VehicleLeaveButton = "MainMenuBarVehicleLeaveButton",
}

local function GetActionBarButtonNameCollection(buttonPrefix)
    local collection = {}
    for i = 1, MaxActionBarCount do
        table.insert(collection, buttonPrefix .. i)
    end

    return collection
end

local function BuildActionBarCollectionItem(key, frame, buttons)
    return {
        key = key,
        frame = frame,
        buttons = buttons,
    }
end

FadeBlizzardBars.ActionBarCollection = {
    BuildActionBarCollectionItem("mainActionBar", "MainActionBar",
        GetActionBarButtonNameCollection("ActionButton")), -- Main Action Bar
    BuildActionBarCollectionItem("multiBarBottomLeft", "MultiBarBottomLeft",
        GetActionBarButtonNameCollection("MultiBarBottomLeftButton")), -- Bar 2
    BuildActionBarCollectionItem("multiBarBottomRight", "MultiBarBottomRight",
        GetActionBarButtonNameCollection("MultiBarBottomRightButton")), -- Bar 3
    BuildActionBarCollectionItem("multiBarRight", "MultiBarRight",
        GetActionBarButtonNameCollection("MultiBarRightButton")), -- Bar 4
    BuildActionBarCollectionItem("multiBarLeft", "MultiBarLeft",
        GetActionBarButtonNameCollection("MultiBarLeftButton")), -- Bar 5
    BuildActionBarCollectionItem("multiBar5", "MultiBar5",
        GetActionBarButtonNameCollection("MultiBar5Button")), -- Bar 6
    BuildActionBarCollectionItem("multiBar6", "MultiBar6",
        GetActionBarButtonNameCollection("MultiBar6Button")), -- Bar 7
    BuildActionBarCollectionItem("multiBar7", "MultiBar7",
        GetActionBarButtonNameCollection("MultiBar7Button")), -- Bar 8

    BuildActionBarCollectionItem("petActionBar", "PetActionBar",
        GetActionBarButtonNameCollection("PetActionButton")), -- Pet Action Bar
    BuildActionBarCollectionItem("stanceBar", "StanceBar",
        GetActionBarButtonNameCollection("StanceButton")), -- Stance Bar

    BuildActionBarCollectionItem("bagsBar", "BagsBar", BugsButtonNames), -- Bags Bar
    BuildActionBarCollectionItem("microMenuContainer", "MicroMenuContainer", MicroMenuButtonNames), -- Micro Menu Bar
}


local DefaultFadeSettings = {
    fadeInTime = DefaultFadeConstants.fadeItTime,
    fadeOutTime = DefaultFadeConstants.fadeOutTime,
    fadeOutDelay = DefaultFadeConstants.fadeOutDelay,
}

local DefaultScaleSettings = {
    scale = 1,
    enabled = false,
}

local function BuildDefaultDbBarOption(additionalOptions)
    local option = {
        fade = false,
        clickThrough = false,
        showInCombat = false,
        showOnMount = false,
        alpha = 0,
        hideHotKeys = false,
        hideMacrosNames = false,
        fadeSettings = DefaultFadeSettings,
        scaleSettings = DefaultScaleSettings,
    }

    if additionalOptions ~= nil then
        option.additionalOptions = additionalOptions
    end

    return option
end

FadeBlizzardBars.DbDefaults = {
	profile = {
		enabled = true,
        barOptions = {
            mainActionBar = BuildDefaultDbBarOption({ showOnPageChange = false }),
            multiBarBottomLeft = BuildDefaultDbBarOption(),
            multiBarBottomRight = BuildDefaultDbBarOption(),
            multiBarRight = BuildDefaultDbBarOption(),
            multiBarLeft = BuildDefaultDbBarOption(),
            multiBar5 = BuildDefaultDbBarOption(),
            multiBar6 = BuildDefaultDbBarOption(),
            multiBar7 = BuildDefaultDbBarOption(),
            petActionBar = BuildDefaultDbBarOption(),
            stanceBar = BuildDefaultDbBarOption(),
            bagsBar = BuildDefaultDbBarOption(),
            microMenuContainer = BuildDefaultDbBarOption(),
        },
	}
}
