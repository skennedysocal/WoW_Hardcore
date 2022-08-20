local _G = _G
local duo_rules = CreateFrame("Frame")
_G.extra_rules.Duo = duo_rules

local max_warn_time = 10 * 60 -- Fails after 10 minutes
local check_rate = 15 -- Checks every 15 seconds
-- General info
duo_rules.name = "Duo"
duo_rules.title = "Duo"
duo_rules.class = "All"
duo_rules.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_default.blp"
duo_rules.description = ""
duo_rules.minimap_button_info = {}
duo_rules.minimap_button = nil
duo_rules.warn_reason = ""

local minimap_button = LibStub("LibDataBroker-1.1"):NewDataObject("Duo", {
	type = "data source",
	text = "Hardcore",
	icon = "Interface\\Addons\\Hardcore\\Media\\duo_minimap.blp",
	OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then
			return
		end
		tooltip:AddLine("Duo status:")
		tooltip:AddLine("|c0000FF00Good|r ")
	end,
})

local function initMinimapButton()
	duo_rules.minimap_button = LibStub("LibDBIcon-1.0", true)
	duo_rules.minimap_button:Register("Duo", minimap_button, duo_rules.minimap_button_info)
end

local function checkHardcoreStatus()
	-- Unit tests
	------------------------
	-- Initialized and passes
	-- other_hardcore_character_cache[UnitName("player")] = {}
	-- other_hardcore_character_cache[UnitName("player")].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[UnitName("player")].party_mode = "Duo"
	-- other_hardcore_character_cache[UnitName("player")].team = {}
	-- other_hardcore_character_cache[duo_rules.teammate_1] = {}
	-- other_hardcore_character_cache[duo_rules.teammate_1].party_mode = "Duo"
	-- other_hardcore_character_cache[duo_rules.teammate_1].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[duo_rules.teammate_1].team = {UnitName("player")}
	------------------------
	-- Initialized and failes; different party member
	-- other_hardcore_character_cache[UnitName("player")] = {}
	-- other_hardcore_character_cache[UnitName("player")].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[UnitName("player")].party_mode = "Duo"
	-- other_hardcore_character_cache[UnitName("player")].team = {}
	-- other_hardcore_character_cache[duo_rules.teammate_1] = {}
	-- other_hardcore_character_cache[duo_rules.teammate_1].party_mode = "Duo"
	-- other_hardcore_character_cache[duo_rules.teammate_1].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[duo_rules.teammate_1].team = {"somewrongplayer"}
	------------------------
	-- Initialized and failes; achievement mismatch
	-- other_hardcore_character_cache[UnitName("player")] = {}
	-- other_hardcore_character_cache[UnitName("player")].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[UnitName("player")].party_mode = "Duo"
	-- other_hardcore_character_cache[UnitName("player")].team = {}
	-- other_hardcore_character_cache[duo_rules.teammate_1] = {}
	-- other_hardcore_character_cache[duo_rules.teammate_1].party_mode = "Duo"
	-- other_hardcore_character_cache[duo_rules.teammate_1].achievements = {"Power From Within"}
	-- other_hardcore_character_cache[duo_rules.teammate_1].team = {UnitName("player")}
	------------------------
	-- Uninitialized
	-- other_hardcore_character_cache[UnitName("player")] = {}
	-- other_hardcore_character_cache[UnitName("player")].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[UnitName("player")].party_mode = "Duo"
	-- other_hardcore_character_cache[UnitName("player")].team = {}
	-- other_hardcore_character_cache[duo_rules.teammate_1] = nil

	local player_name = UnitName("player")
	if other_hardcore_character_cache[player_name] ~= nil then
		if other_hardcore_character_cache[duo_rules.teammate_1] ~= nil then
			-- Check their duo status
			if other_hardcore_character_cache[duo_rules.teammate_1].party_mode ~= "Duo" then
				Hardcore:Print("Duo check: Partner is not in a duo.")
				duo_rules.warning_reason = "Warning - Partner is not in a duo."
				duo_rules:Warn()
				return false
			end

			-- Check that other player thinks this player is part of their duo
			local found_self = false
			for i, other_players_partner in ipairs(other_hardcore_character_cache[duo_rules.teammate_1].team) do
				if other_players_partner == player_name then
					found_self = true
					break
				end
			end
			if found_self == false then
				Hardcore:Print("Duo check: Not found in partner's duo list")
				duo_rules.warning_reason = "Warning - Not found in partner's duo list."
				duo_rules:Warn()
				return false
			end

			-- Check that achievements match
			for _, achievement_check in ipairs(other_hardcore_character_cache[player_name].achievements) do
				local has_achievement = false
				for i, other_achievement in ipairs(other_hardcore_character_cache[duo_rules.teammate_1].achievements) do
					if other_achievement == achievement_check then
						has_achievement = true
						break
					end
				end
				if has_achievement == false then
					Hardcore:Print("Duo check: Partner is missing achievement " .. achievement_check)
					duo_rules.warning_reason = "Warning - Partner is missing achievement " .. achievement_check .. "."
					duo_rules:Warn()
					return false
				end
			end
		end
	end

	return true
end

-- Registers
function duo_rules:Register(fail_function_executor, _hardcore_character)
	if duo_rules.minimap_button == nil then
		initMinimapButton()
	end
	duo_rules.accumulated_warn_time = 0
	duo_rules._hardcore_character_ref = _hardcore_character
	if _hardcore_character.team ~= nil and _hardcore_character.team[1] then
		duo_rules.teammate_1 = _hardcore_character.team[1]
	else
		Hardcore:Print("Error setting up duo registration; character team data nil. Did you enter teammate name?")
	end
	duo_rules.timer_handle = C_Timer.NewTicker(check_rate, function()
		duo_rules:Check()
	end)
	duo_rules:RegisterEvent("PLAYER_DEAD")
	duo_rules.fail_function_executor = fail_function_executor
end

function duo_rules:Unregister()
	if duo_rules.minimap_button ~= nil then
		duo_rules.minimap_button:Hide("Duo")
	end
	if duo_rules.timer_handle ~= nil then
		duo_rules.timer_handle:Cancel()
	end
	duo_rules:UnregisterEvent("PLAYER_DEAD")
	duo_rules.accumulated_warn_time = 0
end

function duo_rules:Warn()
	duo_rules.accumulated_warn_time = duo_rules.accumulated_warn_time + check_rate
	if max_warn_time - duo_rules.accumulated_warn_time > 0 then
		minimap_button.icon = "Interface\\Addons\\Hardcore\\Media\\duo_minimap_warning.blp"
		minimap_button.OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end
			tooltip:AddLine("Duo status:")
			tooltip:AddLine("|c00FFFF00" .. duo_rules.warning_reason .. "|r ")
		end
		Hardcore:Print(
			"Warning - HC Duo: Get back to your duo partner. "
				.. max_warn_time - duo_rules.accumulated_warn_time
				.. " seconds remaining before failing the challenge."
		)
	else
		duo_rules._hardcore_character_ref.party_mode = "Failed Duo"
		Hardcore:Print("Failed Duo")
	end
end

function duo_rules:ResetWarn()
	if duo_rules.accumulated_warn_time > 1 then
		Hardcore:Print("Duo - All conditions met.")

		minimap_button.icon = "Interface\\Addons\\Hardcore\\Media\\duo_minimap.blp"
		minimap_button.OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end
			tooltip:AddLine("Duo status:")
			tooltip:AddLine("|c0000FF00Good|r ")
		end
	end
	duo_rules.accumulated_warn_time = 0
end

function duo_rules:Check()
	local num_members = GetNumGroupMembers()
	if num_members < 2 then
		Hardcore:Print("Duo check: not in group")
		duo_rules.warning_reason = "Warning - not in party with your duo partner."
		duo_rules:Warn()
		return
	end
	local identifiers = {
		"party1",
		"party2",
		"party3",
		"party4",
	}
	local found_member = false
	local member_str = ""
	for i, id in ipairs(identifiers) do
		local member_name = UnitName(id)
		if member_name ~= nil then
			if member_name == duo_rules.teammate_1 then
				found_member = true
				member_str = id
				break
			end
		end
	end

	if found_member == false then
		Hardcore:Print("Duo check: did not find partner in group")
		duo_rules.warning_reason = "Warning - did not find your partner in party."
		duo_rules:Warn()
		return
	end

	local in_follow_range = CheckInteractDistance(member_str, 4)
	if in_follow_range then
		duo_rules:ResetWarn()
		return
	end

	local my_map = C_Map.GetBestMapForUnit("player")
	local teammates_map = C_Map.GetBestMapForUnit(member_str)

	if my_map == 80 or teammates_map == 80 then
		duo_rules:ResetWarn()
	end

	if my_map ~= teammates_map then
		Hardcore:Print("Duo check: Partner is in another subzone")
		duo_rules.warning_reason = "Warning - Partner is in another subzone."
		duo_rules:Warn()
		return
	end
	if checkHardcoreStatus == true then
		duo_rules:ResetWarn()
	end
end

-- Register Definitions
duo_rules:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "PLAYER_DEAD" then
		duo_rules.fail_function_executor.Fail(duo_rules.name)
	end
end)
