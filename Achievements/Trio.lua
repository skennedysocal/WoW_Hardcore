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

-- Registers
function trio_rules:Register(fail_function_executor, _hardcore_character)
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
	trio_rules.fail_function_executor = fail_function_executor
end

function trio_rules:Unregister()
	if trio_rules.timer_handle ~= nil then
		trio_rules.timer_handle:Cancel()
	end
	trio_rules.accumulated_warn_time = 0
end

function trio_rules:Warn()
	trio_rules.accumulated_warn_time = trio_rules.accumulated_warn_time + check_rate
	if max_warn_time - trio_rules.accumulated_warn_time > 0 then
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
		Hardcore:Print("Trio group gathered back together.")
	end
	trio_rules.accumulated_warn_time = 0
end

function trio_rules:Check()
	local num_members = GetNumGroupMembers()
	if num_members < 3 then
		Hardcore:Print("Trio check: not in big enough group")
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
		local member_name = UnitName(identifiers)
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
	if my_map ~= teammates_map_1 or teammates_map_1 ~= teammates_map_2 or my_map ~= teammates_map_2 then
		Hardcore:Print("Trio check: Teammate is in another subzone")
		trio_rules:Warn()
		return
	end

	trio_rules:ResetWarn()
end

-- Register Definitions
trio_rules:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
end)
