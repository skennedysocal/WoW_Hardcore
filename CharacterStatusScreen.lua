local ICON_SIZE = 40
local TabName = "HC"
local TabID = CharacterFrame.numTabs + 1
local Tab = CreateFrame("Button", "$parentTab" .. TabID, CharacterFrame, "CharacterFrameTabButtonTemplate", TabID)
PanelTemplates_SetNumTabs(CharacterFrame, TabID)
Tab:SetPoint("LEFT", "$parentTab" .. (TabID - 1), "RIGHT", -16, 0)
Tab:SetText(TabName)

local Panel = CreateFrame("Frame", nil, CharacterFrame)
Panel:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", -50, -200)
Panel:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMRIGHT", -200, 0)
local f = CreateFrame("Frame", "YourFrameName", Panel)
f:SetSize(400, 400)
f:SetPoint("CENTER")
f:Hide()

local t = f:CreateTexture(nil, "HIGH")
t:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
t:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 2, -1)
t:SetWidth(256)
t:SetHeight(256)

local tr = f:CreateTexture(nil, "HIGH")
tr:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight")
tr:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 258, -1)
tr:SetWidth(128)
tr:SetHeight(256)

local bl = f:CreateTexture(nil, "HIGH")
bl:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft")
bl:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 2, -257)
bl:SetWidth(256)
bl:SetHeight(256)

local br = f:CreateTexture(nil, "HIGH")
br:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
br:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 258, -257)
br:SetWidth(128)
br:SetHeight(256)

Panel:SetPoint("CENTER", 0, 0)
Panel:Hide()

local AceGUI = LibStub("AceGUI-3.0")
local f2 = AceGUI:Create("HardcoreFrameEmpty")
f2:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 40, -60)
f2:SetWidth(280)
f2:SetHeight(350)
f2:Hide()

hooksecurefunc(CharacterFrame, "Hide", function(self, button)
	HideCharacterHC()
end)

function UpdateCharacterHC(_hardcore_character)
	f2:ReleaseChildren()
	if _hardcore_character == nil then
		return
	end

	local title = AceGUI:Create("HardcoreClassTitleLabel")
	title:SetRelativeWidth(1.0)
	title:SetHeight(60)
	title:SetText("Classic Hardcore")
	title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 22)
	f2:AddChild(title)

	local character_meta_data_container = AceGUI:Create("SimpleGroup")
	character_meta_data_container:SetRelativeWidth(1.0)
	character_meta_data_container:SetHeight(200)
	character_meta_data_container:SetLayout("List")
	f2:AddChild(character_meta_data_container)

	local character_name = AceGUI:Create("HardcoreClassTitleLabel")
	character_name:SetRelativeWidth(1.0)
	character_name:SetHeight(60)
	local player_name, _ = UnitName("player")
	character_name:SetText("Character Name: " .. player_name)
	character_name:SetFont("Fonts\\FRIZQT__.TTF", 12)
	character_meta_data_container:AddChild(character_name)

	local version_name = AceGUI:Create("HardcoreClassTitleLabel")
	version_name:SetRelativeWidth(1.0)
	version_name:SetHeight(60)
	local version = GetAddOnMetadata("Hardcore", "Version")
	version_name:SetText("Addon version: " .. version)
	version_name:SetFont("Fonts\\FRIZQT__.TTF", 12)
	character_meta_data_container:AddChild(version_name)

	local team_title = AceGUI:Create("HardcoreClassTitleLabel")
	team_title:SetRelativeWidth(1.0)
	team_title:SetHeight(60)
	local mode_type_str = "unknown"
	local teammate_1 = "missing_team"
	local teammate_2 = "unknown"

	if _hardcore_character.team ~= nil then
		teammate_1 = _hardcore_character.team[1] or "unknown"
		teammate_2 = _hardcore_character.team[2] or "unknown"
	end
	if _hardcore_character.party_mode ~= nil then
		if _hardcore_character.party_mode == "Solo" then
			mode_type_str = "Solo"
		elseif _hardcore_character.party_mode == "Duo" then
			mode_type_str = "Duo with " .. teammate_1
		elseif _hardcore_character.party_mode == "Trio" then
			mode_type_str = "Trio with " .. teammate_1 .. " and " .. teammate_2
		else
			mode_type_str = "|c00FF0000" .. _hardcore_character.party_mode .. "|r"
		end
	end
	team_title:SetText(mode_type_str)
	version_name:SetFont("Fonts\\FRIZQT__.TTF", 12)
	character_meta_data_container:AddChild(team_title)

	local creation_date_label = AceGUI:Create("HardcoreClassTitleLabel")
	creation_date_label:SetRelativeWidth(1.0)
	creation_date_label:SetHeight(60)
	local start_date = "?"
	if _hardcore_character.first_recorded ~= nil and _hardcore_character.first_recorded ~= -1 then
		start_date = date("%m/%d/%y", _hardcore_character.first_recorded)
	end
	creation_date_label:SetText("Started on " .. start_date)
	version_name:SetFont("Fonts\\FRIZQT__.TTF", 12)
	character_meta_data_container:AddChild(creation_date_label)

	local v_buffer = AceGUI:Create("Label")
	v_buffer:SetRelativeWidth(1.0)
	v_buffer:SetHeight(100)
	v_buffer:SetText("\n\n\n\n\n")
	f2:AddChild(v_buffer)

	local achievements_container = AceGUI:Create("SimpleGroup")
	achievements_container:SetRelativeWidth(1.0)
	achievements_container:SetHeight(100)
	achievements_container:SetLayout("Flow")
	f2:AddChild(achievements_container)

	local achievements_title = AceGUI:Create("HardcoreClassTitleLabel")
	achievements_title:SetRelativeWidth(1.0)
	achievements_title:SetHeight(60)
	achievements_title:SetText("Active Achievements")
	achievements_title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 16)
	achievements_container:AddChild(achievements_title)
	if _hardcore_character.achievements ~= nil then
		for i, v in ipairs(_hardcore_character.achievements) do
			if _G.achievements[v] ~= nil then
				local achievement_icon = AceGUI:Create("Icon")
				achievement_icon:SetWidth(ICON_SIZE)
				achievement_icon:SetHeight(ICON_SIZE)
				achievement_icon:SetImage(_G.achievements[v].icon_path)
				achievement_icon:SetImageSize(ICON_SIZE, ICON_SIZE)
				achievement_icon.image:SetVertexColor(1, 1, 1)
				achievement_icon:SetCallback("OnEnter", function(widget)
					GameTooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR")
					GameTooltip:AddLine(_G.achievements[v].title)
					GameTooltip:AddLine(_G.achievements[v].description, 1, 1, 1, true)
					GameTooltip:Show()
				end)
				achievement_icon:SetCallback("OnLeave", function(widget)
					GameTooltip:Hide()
				end)
				achievements_container:AddChild(achievement_icon)
			end
		end
	end
end

function ShowCharacterHC(_hardcore_character)
	UpdateCharacterHC(_hardcore_character)
	Panel:Show()
	f:Show()
	f2:Show()
end

function HideCharacterHC()
	Panel:Hide()
	f:Hide()
	f2:Hide()
	f2:ReleaseChildren()
end
