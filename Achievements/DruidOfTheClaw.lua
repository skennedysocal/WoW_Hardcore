local _G = _G
local druid_of_the_claw_achievement = CreateFrame("Frame")
_G.achievements.DruidOfTheClaw = druid_of_the_claw_achievement

-- General info
druid_of_the_claw_achievement.name = "DruidOfTheClaw"
druid_of_the_claw_achievement.title = "Druid of the Claw"
druid_of_the_claw_achievement.class = "Druid"
druid_of_the_claw_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_druid_of_the_claw.blp"
druid_of_the_claw_achievement.description = "Complete the Hardcore challenge without at any point using an ability within the “Balance” tab of your spellbook or using any form other than Bear Form or Dire Bear Form. Only spells listed under “Feral Combat”, “Restoration”, or “General” are allowed. You are allowed to put points into all talent trees, but active abilities thus unlocked that are in the “Balance” tab of your spellbook are not allowed to be used. Teleport: Moonglade is allowed to be used. Travel Form and Aquatic Form are not allowed."

-- Registers
function druid_of_the_claw_achievement:Register(fail_function_executor)
	druid_of_the_claw_achievement:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	druid_of_the_claw_achievement:RegisterEvent("SPELLS_CHANGED")
	druid_of_the_claw_achievement:GatherBlackList()
	druid_of_the_claw_achievement.fail_function_executor = fail_function_executor 
end

function druid_of_the_claw_achievement:Unregister()
	druid_of_the_claw_achievement:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	druid_of_the_claw_achievement:UnregisterEvent("SPELLS_CHANGED")
	druid_of_the_claw_achievement.fail_function_executor = nil 
end

function druid_of_the_claw_achievement:GatherBlackList()
    druid_of_the_claw_achievement.blacklist = {}
    for i=1,4 do 
      local name, texture, offset, numSlots, isGuild, offspecID = GetSpellTabInfo(i)
      if name == "Balance" then
	for j=offset+1,offset+numSlots do
	  local spell_name = GetSpellInfo(j, "")
	  if (spell_name ~= "Bear Form" or spell_name ~= "Dire Bear Form") then
	    table.insert(druid_of_the_claw_achievement.blacklist, spell_name)
	  end
	end
      end
    end
end

-- Register Definitions
druid_of_the_claw_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = {...}
	if (event == "SPELLS_CHANGED") then
	  druid_of_the_claw_achievement:GatherBlackList()
	elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
	  local unit, _, spell_id = ...
	  if unit ~= "player" then
	    return
	  end
	  local spell_name = GetSpellInfo(spell_id)
	  for i, blacklist_spell in ipairs(druid_of_the_claw_achievement.blacklist) do
	    if (spell_name == blacklist_spell) then
	      druid_of_the_claw_achievement.fail_function_executor.Fail(druid_of_the_claw_achievement.name)
	      return
	    end
	  end
	end
end)
