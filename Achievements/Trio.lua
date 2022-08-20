local _G = _G
local trio_rules = CreateFrame("Frame")
_G.extra_rules.Trio = trio_rules

local max_warn_time = 10 * 60 -- Fails after 10 minutes
local check_rate = 15 -- Checks every 15 seconds
-- General info
trio_rules.name = "Trio"
trio_rules.title = "Trio"
trio_rules.class = "All"
trio_rules.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_default.blp"
trio_rules.description = ""
trio_rules.minimap_button_info = {}
trio_rules.minimap_button = nil
trio_rules.warn_reason = ""

local minimap_button = LibStub("LibDataBroker-1.1"):NewDataObject("Trio", {
	type = "data source",
	text = "Hardcore",
	icon = "Interface\\Addons\\Hardcore\\Media\\duo_minimap.blp",
	OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then
			return
		end
		tooltip:AddLine("Trio status:")
		tooltip:AddLine("|c0000FF00Good|r ")
	end,
})

local function initMinimapButton()
	trio_rules.minimap_button = LibStub("LibDBIcon-1.0", true)
	trio_rules.minimap_button:Register("Trio", minimap_button, trio_rules.minimap_button_info)
end

local function checkHardcoreStatus()
	-- Unit tests
	------------------------
	-- Initialized and passes
	-- other_hardcore_character_cache[UnitName("player")] = {}
	-- other_hardcore_character_cache[UnitName("player")].achievements = { "Nudist", "Power From Within" }
	-- other_hardcore_character_cache[UnitName("player")].party_mode = "Trio"
	-- other_hardcore_character_cache[UnitName("player")].team = {}
	-- other_hardcore_character_cache[trio_rules.teammate_1] = {}
	-- other_hardcore_character_cache[trio_rules.teammate_1].party_mode = "Trio"
	-- other_hardcore_character_cache[trio_rules.teammate_1].achievements = { "Nudist", "Power From Within" }
	-- other_hardcore_character_cache[trio_rules.teammate_1].team = { UnitName("player") }
	-- other_hardcore_character_cache[trio_rules.teammate_2] = {}
	-- other_hardcore_character_cache[trio_rules.teammate_2].party_mode = "Trio"
	-- other_hardcore_character_cache[trio_rules.teammate_2].achievements = { "Nudist", "Power From Within" }
	-- other_hardcore_character_cache[trio_rules.teammate_2].team = { UnitName("player") ,   trio_rules.teammate_1 }
	------------------------
	-- Initialized and failes; different party member
	-- other_hardcore_character_cache[UnitName("player")] = {}
	-- other_hardcore_character_cache[UnitName("player")].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[UnitName("player")].party_mode = "Trio"
	-- other_hardcore_character_cache[UnitName("player")].team = {}
	-- other_hardcore_character_cache[trio_rules.teammate_1] = {}
	-- other_hardcore_character_cache[trio_rules.teammate_1].party_mode = "Trio"
	-- other_hardcore_character_cache[trio_rules.teammate_1].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[trio_rules.teammate_1].team = { UnitName("player")}
	-- other_hardcore_character_cache[trio_rules.teammate_2] = {}
	-- other_hardcore_character_cache[trio_rules.teammate_2].party_mode = "Trio"
	-- other_hardcore_character_cache[trio_rules.teammate_2].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[trio_rules.teammate_2].team = {"somewrongplayer"}
	------------------------
	-- Initialized and failes; achievement mismatch
	-- other_hardcore_character_cache[UnitName("player")] = {}
	-- other_hardcore_character_cache[UnitName("player")].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[UnitName("player")].party_mode = "Trio"
	-- other_hardcore_character_cache[UnitName("player")].team = {}
	-- other_hardcore_character_cache[trio_rules.teammate_2] = {}
	-- other_hardcore_character_cache[trio_rules.teammate_2].party_mode = "Trio"
	-- other_hardcore_character_cache[trio_rules.teammate_2].achievements = {"Power From Within"}
	-- other_hardcore_character_cache[trio_rules.teammate_2].team = {UnitName("player")}
	-- other_hardcore_character_cache[trio_rules.teammate_1] = {}
	-- other_hardcore_character_cache[trio_rules.teammate_1].party_mode = "Trio"
	-- other_hardcore_character_cache[trio_rules.teammate_1].achievements = {"Nudist", "Power From Within"}
	-- other_hardcore_character_cache[trio_rules.teammate_1].team = {UnitName("player")}
	------------------------
	-- Uninitialized
	other_hardcore_character_cache[UnitName("player")] = {}
	other_hardcore_character_cache[UnitName("player")].achievements = { "Nudist", "Power From Within" }
	other_hardcore_character_cache[UnitName("player")].party_mode = "Trio"
	other_hardcore_character_cache[UnitName("player")].team = {}
	other_hardcore_character_cache[trio_rules.teammate_1] = nil

	local player_name = UnitName("player")
	if other_hardcore_character_cache[player_name] ~= nil then
		if other_hardcore_character_cache[trio_rules.teammate_1] ~= nil then
			if other_hardcore_character_cache[trio_rules.teammate_2] ~= nil then
				-- Check their trio status
				if other_hardcore_character_cache[trio_rules.teammate_1].party_mode ~= "Trio" then
					Hardcore:Print("Trio check: Partner is not in a trio.")
					trio_rules.warning_reason = "Warning - Partner is not in a trio."
					trio_rules:Warn()
					return false
				end

				if other_hardcore_character_cache[trio_rules.teammate_2].party_mode ~= "Trio" then
					Hardcore:Print("Trio check: Partner is not in a trio.")
					trio_rules.warning_reason = "Warning - Partner is not in a trio."
					trio_rules:Warn()
					return false
				end

				-- Check that other player thinks this player is part of their trio
				local found_self = false
				for i, other_players_partner in ipairs(other_hardcore_character_cache[trio_rules.teammate_1].team) do
					if other_players_partner == player_name then
						found_self = true
						break
					end
				end
				if found_self == false then
					Hardcore:Print("Trio check: Not found in partner's trio list")
					trio_rules.warning_reason = "Warning - Not found in partner's trio list."
					trio_rules:Warn()
					return false
				end

				found_self = false
				for i, other_players_partner in ipairs(other_hardcore_character_cache[trio_rules.teammate_2].team) do
					if other_players_partner == player_name then
						found_self = true
						break
					end
				end
				if found_self == false then
					Hardcore:Print("Trio check: Not found in partner's trio list")
					trio_rules.warning_reason = "Warning - Not found in partner's trio list."
					trio_rules:Warn()
					return false
				end

				-- Check that achievements match
				for _, achievement_check in ipairs(other_hardcore_character_cache[player_name].achievements) do
					-- check partner 1
					local has_achievement = false
					for i, other_achievement in
						ipairs(other_hardcore_character_cache[trio_rules.teammate_1].achievements)
					do
						if other_achievement == achievement_check then
							has_achievement = true
							break
						end
					end
					if has_achievement == false then
						Hardcore:Print("Trio check: Partner is missing achievement " .. achievement_check)
						trio_rules.warning_reason = "Warning - Partner is missing achievement "
							.. achievement_check
							.. "."
						trio_rules:Warn()
						return false
					end

					-- check partner 2
					has_achievement = false
					for i, other_achievement in
						ipairs(other_hardcore_character_cache[trio_rules.teammate_2].achievements)
					do
						if other_achievement == achievement_check then
							has_achievement = true
							break
						end
					end
					if has_achievement == false then
						Hardcore:Print("Trio check: Partner is missing achievement " .. achievement_check)
						trio_rules.warning_reason = "Warning - Partner is missing achievement "
							.. achievement_check
							.. "."
						trio_rules:Warn()
						return false
					end
				end
			end
		end
	end

	return true
end

-- Registers
function trio_rules:Register(fail_function_executor, _hardcore_character)
	if trio_rules.minimap_button == nil then
		initMinimapButton()
	end

	trio_rules.accumulated_warn_time = 0
	trio_rules._hardcore_character_ref = _hardcore_character
	if _hardcore_character.team ~= nil and _hardcore_character.team[1] then
		trio_rules.teammate_1 = _hardcore_character.team[1]
	else
		Hardcore:Print("Error setting up trio registration; character team data nil. Did you enter teammate name?")
	end

	if _hardcore_character.team ~= nil and _hardcore_character.team[2] then
		trio_rules.teammate_2 = _hardcore_character.team[2]
	else
		Hardcore:Print("Error setting up trio registration; character team data nil. Did you enter teammate name?")
	end

	trio_rules.timer_handle = C_Timer.NewTicker(check_rate, function()
		trio_rules:Check()
	end)
	trio_rules:RegisterEvent("PLAYER_DEAD")
	trio_rules.fail_function_executor = fail_function_executor
end

function trio_rules:Unregister()
	if trio_rules.minimap_button ~= nil then
		trio_rules.minimap_button:Hide("Trio")
	end
	if trio_rules.timer_handle ~= nil then
		trio_rules.timer_handle:Cancel()
	end
	trio_rules:UnregisterEvent("PLAYER_DEAD")
	trio_rules.accumulated_warn_time = 0
end

function trio_rules:Warn()
	trio_rules.accumulated_warn_time = trio_rules.accumulated_warn_time + check_rate
	if max_warn_time - trio_rules.accumulated_warn_time > 0 then
		minimap_button.icon = "Interface\\Addons\\Hardcore\\Media\\duo_minimap_warning.blp"
		minimap_button.OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end
			tooltip:AddLine("Trio status:")
			tooltip:AddLine("|c00FFFF00" .. trio_rules.warning_reason .. "|r ")
		end
		Hardcore:Print(
			"Warning - HC Trio: Get back to your trio partner. "
				.. max_warn_time - trio_rules.accumulated_warn_time
				.. " seconds remaining before failing the challenge."
		)
	else
		trio_rules._hardcore_character_ref.party_mode = "Failed Trio"
		Hardcore:Print("Failed Trio")
	end
end

function trio_rules:ResetWarn()
	if trio_rules.accumulated_warn_time > 1 then
		Hardcore:Print("Trio - All conditions met.")

		minimap_button.icon = "Interface\\Addons\\Hardcore\\Media\\duo_minimap.blp"
		minimap_button.OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end
			tooltip:AddLine("Trio status:")
			tooltip:AddLine("|c0000FF00Good|r ")
		end
	end
	trio_rules.accumulated_warn_time = 0
end

function trio_rules:Check()
	local num_members = GetNumGroupMembers()
	if num_members < 3 then
		Hardcore:Print("Trio check: not in big enough group")
		trio_rules.warning_reason = "Warning - Not in big enough group."
		trio_rules:Warn()
		return
	end
	local identifiers = {
		"party1",
		"party2",
		"party3",
		"party4",
	}
	local found_member_1 = false
	local member_str_1 = ""

	local found_member_2 = false
	local member_str_2 = ""

	for i, id in ipairs(identifiers) do
		local member_name = UnitName(id)
		if member_name ~= nil then
			if member_name == trio_rules.teammate_1 then
				found_member_1 = true
				member_str_1 = id
			end
			if member_name == trio_rules.teammate_2 then
				found_member_2 = true
				member_str_2 = id
			end
		end
	end

	if found_member_1 == false or found_member_2 == false then
		Hardcore:Print("Trio check: did not find partner(s) in group")
		trio_rules.warning_reason = "Warning - did not find your partner(s) in party."
		trio_rules:Warn()
		return
	end

	local in_follow_range = CheckInteractDistance(member_str, 4)
	if in_follow_range then
		trio_rules:ResetWarn()
		return
	end

	local my_map = C_Map.GetBestMapForUnit("player")
	local teammates_map_1 = C_Map.GetBestMapForUnit(member_str_1)
	local teammates_map_2 = C_Map.GetBestMapForUnit(member_str_2)

	if my_map == 80 or teammates_map_1 == 80 or teammates_map_2 == 80 then
		trio_rules:ResetWarn()
	end

	if my_map ~= teammates_map_1 or teammates_map_1 ~= teammates_map_2 or my_map ~= teammates_map_2 then
		Hardcore:Print("Trio check: Partner(s) is in another subzone")
		trio_rules.warning_reason = "Warning - Partner(s) is in another subzone."
		trio_rules:Warn()
		return
	end

	if checkHardcoreStatus() == true then
		trio_rules:ResetWarn()
	end
end

-- Register Definitions
trio_rules:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "PLAYER_DEAD" then
		trio_rules.fail_function_executor.Fail(trio_rules.name)
	end
end)
