local _G = _G
local no_hit_achievement = CreateFrame("Frame")
_G.achievements.NoHit = no_hit_achievement

-- General info
no_hit_achievement.name = "NoHit"
no_hit_achievement.title = "Stadic's Challenge"
no_hit_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_no_hit.blp"
no_hit_achievement.description =
	"Complete the hardcore challenge without taking a point of damage.  Falling, drowning, fatigue and other such sources that count as “Environmental Damage” according to the Combat Log are, as such, Damage. This also means that spells that expend life as a resource, such as the Warlock’s Life Tap, do not cause any 'damage' and are as such perfectly viable.  Futhermore, you must accumulate over 30,000 reputation across the four main factions."
no_hit_achievement.class = "All"
no_hit_achievement.alert_on_fail = 1

local faction_indices = {2, 3, 4, 5}

-- Registers
function no_hit_achievement:Register(fail_function_executor)
	no_hit_achievement:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	no_hit_achievement.fail_function_executor = fail_function_executor
	local total_earned_value = 0
	for _,idx in ipairs(faction_indices) do
	  local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith,
	    canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(idx)
	  total_earned_value = total_earned_value + earnedValue
	end
	if total_earned_value > 30000 then
	  no_hit_achievement.description = no_hit_achievement.description .. "\n|c0000FF00Progress: Complete!|r"
	else
	  no_hit_achievement.description = no_hit_achievement.description .. "\n|c00FFFF00Progress: " .. total_earned_value .. "/30,000|r"
	end
end

function no_hit_achievement:Unregister()
	no_hit_achievement:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-- Register Definitions
no_hit_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local combat_log_payload = { CombatLogGetCurrentEventInfo() }
		-- 2: subevent index, 8: dest_guid, 15: amount
		if not (combat_log_payload[8] == nil) then
			if combat_log_payload[8] == UnitGUID("player") then
				if string.find(combat_log_payload[2], "ENVIRONMENTAL_DAMAGE") ~= nil then
					-- 2 holy, 4 fire, 8 nature, 16 frost, 32 shadow, 64 arcane
					if combat_log_payload[13] > 0 then
						print("Failing Stadic's Challenge, took " .. combat_log_payload[13] .. " environmental damage")
						no_hit_achievement.fail_function_executor.Fail(no_hit_achievement.name)
					end
				elseif string.find(combat_log_payload[2], "SWING_DAMAGE") ~= nil then
					-- 2 holy, 4 fire, 8 nature, 16 frost, 32 shadow, 64 arcane
					if combat_log_payload[12] > 0 then
						print("Failing Stadic's Challenge, took " .. combat_log_payload[12] .. " swing damage")
						no_hit_achievement.fail_function_executor.Fail(no_hit_achievement.name)
					end
				elseif string.find(combat_log_payload[2], "_DAMAGE") ~= nil then
					-- 2 holy, 4 fire, 8 nature, 16 frost, 32 shadow, 64 arcane
					if combat_log_payload[15] > 0 then
						print("Failing Stadic's Challenge, took " .. combat_log_payload[15] .. " cast damage")
						no_hit_achievement.fail_function_executor.Fail(no_hit_achievement.name)
					end
				end
			end
		end
	end
end)
