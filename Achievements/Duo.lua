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

-- Registers
function duo_rules:Register(fail_function_executor, _hardcore_character)
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
	duo_rules.fail_function_executor = fail_function_executor
end

function duo_rules:Unregister()
	if duo_rules.timer_handle ~= nil then
		duo_rules.timer_handle:Cancel()
	end
	duo_rules.accumulated_warn_time = 0
end

function duo_rules:Warn()
	duo_rules.accumulated_warn_time = duo_rules.accumulated_warn_time + check_rate
	if max_warn_time - duo_rules.accumulated_warn_time > 0 then
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
		Hardcore:Print("Duo group gathered back together.")
	end
	duo_rules.accumulated_warn_time = 0
end

function duo_rules:Check()
	local num_members = GetNumGroupMembers()
	if num_members < 2 then
		Hardcore:Print("Duo check: not in group")
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
	member_str = ""
	for i, id in ipairs(identifiers) do
		local member_name = UnitName(identifiers)
		if member_name ~= nil then
			if member_name == duo_rules.teammate_1 then
				found_member = true
				member_str = id
				break
			end
		end
	end

	if found_member == false then
		Hardcore:Print("Duo check: did not find teammate in group")
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
	if my_map ~= teammates_map then
		Hardcore:Print("Duo check: Teammate is in another subzone")
		duo_rules:Warn()
		return
	end
	duo_rules:ResetWarn()
end

-- Register Definitions
duo_rules:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
end)
