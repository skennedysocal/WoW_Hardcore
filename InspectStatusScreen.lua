local IPanel = CreateFrame("Frame", nil, CharacterFrame)
IPanel:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", -50, -200)
IPanel:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMRIGHT", -200, 0)
local I_f = CreateFrame("Frame", "YourFrameName", IPanel)
I_f:SetSize(400, 400)
I_f:SetPoint("CENTER")
I_f:Hide()

local I_t = I_f:CreateTexture(nil, "HIGH")
I_t:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
I_t:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 2, -1)
I_t:SetWidth(256)
I_t:SetHeight(256)

local I_tr = I_f:CreateTexture(nil, "HIGH")
I_tr:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight")
I_tr:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 258, -1)
I_tr:SetWidth(128)
I_tr:SetHeight(256)

local I_bl = I_f:CreateTexture(nil, "HIGH")
I_bl:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft")
I_bl:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 2, -257)
I_bl:SetWidth(256)
I_bl:SetHeight(256)

local I_br = I_f:CreateTexture(nil, "HIGH")
I_br:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
I_br:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 258, -257)
I_br:SetWidth(128)
I_br:SetHeight(256)

IPanel:SetPoint("CENTER", 0, 0)
IPanel:Hide()

local AceGUI = LibStub("AceGUI-3.0")
local I_f2 = AceGUI:Create("HardcoreFrameEmpty")
I_f2:SetPoint("TOPLEFT", CharacterFrame, "TOPLEFT", 40, -60)
I_f2:SetWidth(280)
I_f2:SetHeight(350)
I_f2:Hide()

function UpdateInspectHC(_hardcore_character, _player_name, _version)
	I_f2:ReleaseChildren()
	if _hardcore_character == nil then
		return
	end

	local title = AceGUI:Create("HardcoreClassTitleLabel")
	title:SetRelativeWidth(1.0)
	title:SetHeight(60)
	title:SetText("Classic Hardcore")
	title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 22)
	I_f2:AddChild(title)

	local character_meta_data_container = AceGUI:Create("SimpleGroup")
	character_meta_data_container:SetRelativeWidth(1.0)
	character_meta_data_container:SetHeight(200)
	character_meta_data_container:SetLayout("List")
	I_f2:AddChild(character_meta_data_container)

	local character_name = AceGUI:Create("HardcoreClassTitleLabel")
	character_name:SetRelativeWidth(1.0)
	character_name:SetHeight(60)
	character_name:SetText("Character Name: " .. _player_name)
	character_name:SetFont("Fonts\\FRIZQT__.TTF", 12)
	character_meta_data_container:AddChild(character_name)

	local version_name = AceGUI:Create("HardcoreClassTitleLabel")
	version_name:SetRelativeWidth(1.0)
	version_name:SetHeight(60)
	if _version ~= nil then
		version_name:SetText("Addon version: " .. _version)
	else
		version_name:SetText("Addon version: ?")
	end
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
	if start_date ~= nil then
		creation_date_label:SetText("Started on " .. start_date)
	else
		creation_date_label:SetText("Started on ?")
	end
	version_name:SetFont("Fonts\\FRIZQT__.TTF", 12)
	character_meta_data_container:AddChild(creation_date_label)

	local v_buffer = AceGUI:Create("Label")
	v_buffer:SetRelativeWidth(1.0)
	v_buffer:SetHeight(100)
	v_buffer:SetText("\n\n\n\n\n")
	I_f2:AddChild(v_buffer)

	local achievements_container = AceGUI:Create("SimpleGroup")
	achievements_container:SetRelativeWidth(1.0)
	achievements_container:SetHeight(100)
	achievements_container:SetLayout("Flow")
	I_f2:AddChild(achievements_container)

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

function ShowInspectHC(_hardcore_character, other_name, version)
	IPanel:SetParent(InspectFrame)
	IPanel:SetPoint("TOPLEFT", InspectFrame, "TOPLEFT", -50, -200)
	IPanel:SetPoint("BOTTOMRIGHT", InspectFrame, "BOTTOMRIGHT", -200, 0)
	I_t:SetPoint("TOPLEFT", InspectFrame, "TOPLEFT", 2, -1)
	I_tr:SetPoint("TOPLEFT", InspectFrame, "TOPLEFT", 258, -1)
	I_bl:SetPoint("TOPLEFT", InspectFrame, "TOPLEFT", 2, -257)
	I_br:SetPoint("TOPLEFT", InspectFrame, "TOPLEFT", 258, -257)
	I_f2:SetPoint("TOPLEFT", InspectFrame, "TOPLEFT", 40, -60)

	UpdateInspectHC(_hardcore_character, other_name, version, I_f2)
	IPanel:Show()
	I_f:Show()
	I_f2:Show()
end

function HideInspectHC()
	IPanel:Hide()
	I_f:Hide()
	I_f2:Hide()
	I_f2:ReleaseChildren()
end
