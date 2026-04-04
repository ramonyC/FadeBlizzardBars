std = "lua51"
max_line_length = false
exclude_files = {
	"libs/",
	"locale/find-locale-strings.lua",
	".luacheckrc"
}

ignore = {}

globals = {
    "_G",
    "LibStub",
    "CreateFrame",
    "UIFrameFadeIn",
    "UIFrameFadeOut",
    "C_Timer",
    "ReloadUI",
    "GetActionBarPage",
}
