local achievement_icons = {}
local CLASSES = {
	-- Classic:
	[1] = "Warrior",
	[2] = "Paladin",
	[3] = "Hunter",
	[4] = "Rogue",
	[5] = "Priest",
	[6] = "Death Knight",
	[7] = "Shaman",
	[8] = "Mage",
	[9] = "Warlock",
	[11] = "Druid",
}

local function FormatStrForParty(input_str)
	local ouput_str = string.lower(input_str)
	output_str = ouput_str:gsub("^%l", string.upper)
	return output_str
end

function ShowFirstMenu(_hardcore_character, _hardcore_settings, _failure_function_executor)
	local AceGUI = LibStub("AceGUI-3.0")
	local f = AceGUI:Create("HardcoreFrame")
	f:SetCallback("OnClose", function(widget)
		AceGUI:Release(widget)
	end)
	f:SetTitle("Classic Hardcore")
	f:SetStatusText("")
	f:SetLayout("Flow")

	-- function that draws the widgets for the second tab
	local function DrawAchievementRow(achievement, _scroll_frame)
		local btn_container = AceGUI:Create("SimpleGroup")
		btn_container:SetWidth(800)
		btn_container:SetHeight(60)
		btn_container:SetLayout("Flow")
		_scroll_frame:AddChild(btn_container)

		btn_container_frame = AceGUI:Create("SimpleGroup")
		btn_container_frame:SetLayout("Flow")

		-- Create a button
		local achievement_icon = AceGUI:Create("Icon")
		achievement_icons[achievement.name] = achievement_icon
		achievement_icon:SetWidth(60)
		achievement_icon:SetHeight(60)
		achievement_icon:SetImage(achievement.icon_path)
		achievement_icon:SetImageSize(60, 60)
		achievement_icon.image:SetVertexColor(0.2, 0.2, 0.2)
		if _hardcore_character.achievements == nil then
			_hardcore_character.achievements = {}
		end
		for i, v in ipairs(_hardcore_character.achievements) do
			if v == achievement.name then
				achievement_icon.image:SetVertexColor(1, 1, 1)
			end
		end
		achievement_icon:SetCallback("OnClick", function()
			local activate = true
			for i, v in ipairs(_hardcore_character.achievements) do
				if v == achievement.name then
					activate = false
					table.remove(_hardcore_character.achievements, i)
					achievement_icon.image:SetVertexColor(0.1, 0.1, 0.1)
					achievement:Unregister()
					Hardcore:Print("Removed " .. achievement.name .. " challenge!")
				end
			end

			if activate then
				local _, _, _class_id = UnitClass("player")
				if CLASSES[_class_id] ~= achievement.class and achievement.class ~= "All" then
					Hardcore:Print(
						"Cannot start achievement " .. achievement.title .. " as class " .. CLASSES[_class_id]
					)
				elseif
					achievement.restricted_game_versions ~= nil
					and achievement.restricted_game_versions[_G["HardcoreBuildLabel"]] ~= nil
				then
					Hardcore:Print(
						"Achievement " .. achievement.title .. " is not supported in " .. _G["HardcoreBuildLabel"]
					)
				else
					table.insert(_hardcore_character.achievements, achievement.name)
					achievement_icon.image:SetVertexColor(1, 1, 1)
					achievement:Register(_failure_function_executor, _hardcore_character)
					Hardcore:Print("Added " .. achievement.name .. " challenge!")

					if achievement.forces ~= nil then
						for i, other_a in ipairs(achievement.forces) do
							if _G.achievements[other_a] ~= nil then
								local already_active = false
								for _i, _a in ipairs(_hardcore_character.achievements) do
									if _a == other_a then
										already_active = true
									end
								end
								if already_active == false then
									table.insert(_hardcore_character.achievements, _G.achievements[other_a].name)
									achievement_icons[other_a].image:SetVertexColor(1, 1, 1)
									_G.achievements[other_a]:Register(_failure_function_executor, _hardcore_character)
									Hardcore:Print("Added " .. _G.achievements[other_a].name .. " challenge!")
								end
							end
						end
					end
				end
			end
		end)
		btn_container:AddChild(achievement_icon)

		local buffer_frame = AceGUI:Create("SimpleGroup")
		buffer_frame:SetWidth(30)
		buffer_frame:SetHeight(30)
		buffer_frame:SetLayout("Flow")
		btn_container:AddChild(buffer_frame)

		local btn_container_frame = AceGUI:Create("SimpleGroup")
		btn_container_frame:SetLayout("Flow")
		btn_container:AddChild(btn_container_frame)

		local title = AceGUI:Create("Label")
		title:SetWidth(550)
		title:SetText(achievement.title)
		title:SetPoint("TOP", 2, 5)
		title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
		btn_container_frame:AddChild(title)

		local description = AceGUI:Create("InteractiveLabel")
		description:SetWidth(520)
		description:SetFont("", 16)
		local description_text = achievement.description
		if achievement.forces ~= nil then
			description_text = description_text .. "\n |c00FFFF00Selecting " .. achievement.title .. " forces "
			for i = 1, #achievement.forces do
				if i == #achievement.forces and #achievement.forces > 1 then
					description_text = description_text .. "and "
				end
				description_text = description_text .. _G.achievements[achievement.forces[i]].title
				if i ~= #achievement.forces then
					description_text = description_text .. ", "
				end
			end
			description_text = description_text .. ".|r"
		end

		if
			achievement.restricted_game_versions ~= nil
			and achievement.restricted_game_versions[_G["HardcoreBuildLabel"]] ~= nil
		then
			description_text = description_text
				.. "\n |c00FF0000This achievement is not available for "
				.. _G["HardcoreBuildLabel"]
				.. ".|r"
		end

		if achievement.warnings ~= nil then
			for _, _warning_msg in ipairs(achievement.warnings) do
				description_text = description_text .. "\n |c00FFFF00 " .. _warning_msg .. "|r"
			end
		end

		description:SetText(description_text)
		description:SetPoint("BOTTOM", 200, 5)
		btn_container_frame:AddChild(description)
	end

	-- function that draws the widgets for the second tab
	local function DrawPassiveAchievementRow(achievement, _scroll_frame)
		local btn_container = AceGUI:Create("SimpleGroup")
		btn_container:SetWidth(800)
		btn_container:SetHeight(60)
		btn_container:SetLayout("Flow")
		_scroll_frame:AddChild(btn_container)

		btn_container_frame = AceGUI:Create("SimpleGroup")
		btn_container_frame:SetLayout("Flow")

		-- Create a button
		local achievement_icon = AceGUI:Create("Icon")
		achievement_icons[achievement.name] = achievement_icon
		achievement_icon:SetWidth(60)
		achievement_icon:SetHeight(60)
		achievement_icon:SetImage(achievement.icon_path)
		achievement_icon:SetImageSize(60, 60)
		achievement_icon.image:SetVertexColor(0.2, 0.2, 0.2)
		if _hardcore_character.achievements == nil then
			_hardcore_character.achievements = {}
		end
		for i, v in ipairs(_hardcore_character.achievements) do
			if v == achievement.name then
				achievement_icon.image:SetVertexColor(1, 1, 1)
			end
		end
		btn_container:AddChild(achievement_icon)

		local buffer_frame = AceGUI:Create("SimpleGroup")
		buffer_frame:SetWidth(30)
		buffer_frame:SetHeight(30)
		buffer_frame:SetLayout("Flow")
		btn_container:AddChild(buffer_frame)

		local btn_container_frame = AceGUI:Create("SimpleGroup")
		btn_container_frame:SetLayout("Flow")
		btn_container:AddChild(btn_container_frame)

		local title = AceGUI:Create("Label")
		title:SetWidth(550)
		title:SetText(achievement.title)
		title:SetPoint("TOP", 2, 5)
		title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
		btn_container_frame:AddChild(title)

		local description = AceGUI:Create("InteractiveLabel")
		description:SetWidth(520)
		description:SetFont("", 16)
		local description_text = achievement.description
		if achievement.forces ~= nil then
			description_text = description_text .. "\n |c00FFFF00Selecting " .. achievement.title .. " forces "
			for i = 1, #achievement.forces do
				if i == #achievement.forces and #achievement.forces > 1 then
					description_text = description_text .. "and "
				end
				description_text = description_text .. _G.achievements[achievement.forces[i]].title
				if i ~= #achievement.forces then
					description_text = description_text .. ", "
				end
			end
			description_text = description_text .. ".|r"
		end

		if
			achievement.restricted_game_versions ~= nil
			and achievement.restricted_game_versions[_G["HardcoreBuildLabel"]] ~= nil
		then
			description_text = description_text
				.. "\n |c00FF0000This achievement is not available for "
				.. _G["HardcoreBuildLabel"]
				.. ".|r"
		end

		if achievement.warnings ~= nil then
			for _, _warning_msg in ipairs(achievement.warnings) do
				description_text = description_text .. "\n |c00FFFF00 " .. _warning_msg .. "|r"
			end
		end

		description:SetText(description_text)
		description:SetPoint("BOTTOM", 200, 5)
		btn_container_frame:AddChild(description)
	end

	local function DrawGeneralTab(container)
		local scroll_container = AceGUI:Create("SimpleGroup")
		scroll_container:SetFullWidth(true)
		scroll_container:SetFullHeight(true)
		scroll_container:SetLayout("Fill")
		tabcontainer:AddChild(scroll_container)

		local scroll_frame = AceGUI:Create("ScrollFrame")
		scroll_frame:SetLayout("Flow")
		scroll_container:AddChild(scroll_frame)

		local first_menu_description_title = AceGUI:Create("Label")
		first_menu_description_title:SetWidth(500)
		first_menu_description_title:SetText("Welcome to Classic hardcore!")
		first_menu_description_title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
		-- first_menu_description_title:SetPoint("TOP", 2,5)
		scroll_frame:AddChild(first_menu_description_title)

		local first_menu_description = AceGUI:Create("Label")
		first_menu_description:SetWidth(550)
		first_menu_description:SetText(
			"\n\nIf playing in a duo or trio, click the `Party` tab.\n\nTo select achievements, click on an icon in the achievement tab.\n\nAt any point during the run, open the HC tab on the character screen to check party status and achievements. \n\nThis window will not appear past level 2 and configuration cannot be changed later so make sure to fill these out correctly."
		)
		first_menu_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
		-- first_menu_description:SetPoint("TOP", 2,5)
		scroll_frame:AddChild(first_menu_description)
	end

	local function DrawClassTitleRow(_scroll_frame, _title)
		local row_container = AceGUI:Create("SimpleGroup")
		row_container:SetWidth(800)
		row_container:SetHeight(60)
		row_container:SetLayout("Flow")
		_scroll_frame:AddChild(row_container)

		local title = AceGUI:Create("HardcoreClassTitleLabel")
		title:SetWidth(700)
		title:SetHeight(60)
		local CLASS_COLOR_BY_NAME = {
			["Druid"] = "FF7C0A",
			["Warlock"] = "8788EE",
			["Warrior"] = "C69B6D",
			["Mage"] = "3FC7EB",
			["Hunter"] = "AAD372",
			["Priest"] = "FFFFFF",
			["Shaman"] = "0070DD",
			["Paladin"] = "F48CBA",
			["Rogue"] = "FFF468",
			["Death Knight"] = "C41E3A",
			["General"] = "FFFFFF",
			["General Passive"] = "FFFFFF",
			["Horde Only"] = "8C1616",
			["Alliance Only"] = "004A93",
		}
		title:SetText("|c00" .. CLASS_COLOR_BY_NAME[_title] .. _title .. "|r Achievements")
		title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
		row_container:AddChild(title)
	end

	local function DrawPartyTab(container, _scroll_frame)
		local title = AceGUI:Create("Label")
		title:SetWidth(700)
		title:SetHeight(60)
		title:SetText("Rules for Duos and Trios\n\n")
		title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
		_scroll_frame:AddChild(title)

		local first_menu_description = AceGUI:Create("Label")
		first_menu_description:SetWidth(620)
		first_menu_description:SetText(
			"1. For new runs, all players need to start with the new Hardcore addon.\n2. You must choose a combo that spawns in the same starting location (unless you can find a way to travel to other players at level 1).\n3. You must stay in the same zone together eg Darkshore (unless you are a Druid going to Moonglade to complete essential class quests). \n4. You must be logged on together at the same time even if not questing.\n5. You are Soulbound and share one life. If one of you dies, the other/s must fall on the sword and the run is over.\n6. You can trade any solo self found items or crafted items to each other including conjurables and gold.\n\n\n\n\n"
		)
		first_menu_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
		first_menu_description:SetPoint("TOP", 2, 5)
		_scroll_frame:AddChild(first_menu_description)

		local row_container = AceGUI:Create("SimpleGroup")
		row_container:SetWidth(800)
		row_container:SetHeight(60)
		row_container:SetLayout("Flow")
		_scroll_frame:AddChild(row_container)

		local first_menu_description = AceGUI:Create("Label")
		first_menu_description:SetWidth(300)
		first_menu_description:SetText("Enter your party mode and partners.\n")
		first_menu_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
		first_menu_description:SetPoint("TOP", 2, 5)
		row_container:AddChild(first_menu_description)

		local dropdown = AceGUI:Create("Dropdown")
		dropdown:SetWidth(80)
		dropdown:SetLabel("Party type\n")
		dropdown:AddItem("Solo", "Solo")
		dropdown:AddItem("Duo", "Duo")
		dropdown:AddItem("Trio", "Trio")
		dropdown:SetValue(_hardcore_character.party_mode)
		dropdown:SetPoint("TOP", 2, 5)
		row_container:AddChild(dropdown)

		local tm1 = AceGUI:Create("EditBox")
		tm1:SetWidth(120)
		tm1:SetDisabled(true)
		tm1:SetLabel("Teammate 1\n")
		tm1:SetPoint("TOP", 2, 5)
		if _hardcore_character.team ~= nil then
			if _hardcore_character.team[1] ~= nil then
				tm1:SetText(_hardcore_character.team[1])
			end
		end
		tm1:SetPoint("TOP", 2, 5)
		tm1:DisableButton(true)
		row_container:AddChild(tm1)

		local tm2 = AceGUI:Create("EditBox")
		tm2:SetWidth(120)
		tm2:SetDisabled(true)
		tm2:SetLabel("Teammate 2\n")
		tm2:SetPoint("TOP", 2, 5)
		if _hardcore_character.team ~= nil then
			if _hardcore_character.team[2] ~= nil then
				tm2:SetText(_hardcore_character.team[2])
			end
		end
		tm2:DisableButton(true)
		row_container:AddChild(tm2)

		dropdown:SetCallback("OnValueChanged", function(args)
			local new_mode = dropdown:GetValue()
			tm1:SetText("")
			tm2:SetText("")
			_hardcore_character.party_mode = new_mode
			_hardcore_character.team = {}
			if new_mode == "Solo" then
				tm1:SetDisabled(true)
				tm2:SetDisabled(true)
			elseif new_mode == "Duo" then
				tm1:SetDisabled(false)
				tm2:SetDisabled(true)
			elseif new_mode == "Trio" then
				tm1:SetDisabled(false)
				tm2:SetDisabled(false)
			end
		end)
		tm1:SetCallback("OnTextChanged", function()
			_hardcore_character.team = {}
			table.insert(_hardcore_character.team, FormatStrForParty(tm1:GetText()))
			table.insert(_hardcore_character.team, FormatStrForParty(tm2:GetText()))
		end)

		tm2:SetCallback("OnTextChanged", function()
			_hardcore_character.team = {}
			table.insert(_hardcore_character.team, FormatStrForParty(tm1:GetText()))
			table.insert(_hardcore_character.team, FormatStrForParty(tm2:GetText()))
		end)
	end

	local function DrawAchievementsTab(container, _scroll_frame)
		DrawClassTitleRow(_scroll_frame, "General")
		for k, achievement_name in pairs(_G.achievements_order) do
			local achievement = _G.achievements[achievement_name]
			if achievement ~= nil then
				if achievement.class == "All" then
					DrawAchievementRow(achievement, _scroll_frame)
				end
			end
		end

		local class_list = { "Paladin", "Priest", "Rogue", "Shaman", "Druid", "Mage", "Hunter", "Warlock", "Warrior" }

		for i, class in ipairs(class_list) do
			DrawClassTitleRow(_scroll_frame, class)
			for k, achievement in pairs(_G.achievements) do
				if achievement.class == class then
					DrawAchievementRow(achievement, _scroll_frame)
				end
			end
		end
		local bottom_buffer = AceGUI:Create("SimpleGroup")
		bottom_buffer:SetWidth(1)
		bottom_buffer:SetHeight(5)
		bottom_buffer:SetLayout("Flow")
		_scroll_frame:AddChild(bottom_buffer)
	end

local function DrawPassiveAchievementsTab2(container, scroll_container)
	local function DrawClassContainer(class_container, low, top, size)
		local c = 0
		for idx, id in pairs(_G.passive_achievements_order) do
			local v = _G.passive_achievements[id]
			if v.level_cap >= low and v.level_cap <= top then
				c = c + 1
				local achievement_icon = AceGUI:Create("Icon")
				achievement_icon:SetWidth(size)
				achievement_icon:SetHeight(size)
				achievement_icon:SetImage(v.icon_path)
				achievement_icon:SetImageSize(size, size)
				achievement_icon.image:SetVertexColor(1, 1, 1)
				achievement_icon:SetCallback("OnEnter", function(widget)
					GameTooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR")
					GameTooltip:AddLine(v.title)
					GameTooltip:AddLine(v.description, 1, 1, 1, true)
					GameTooltip:Show()
				end)
				achievement_icon:SetCallback("OnLeave", function(widget)
					GameTooltip:Hide()
				end)
				class_container:AddChild(achievement_icon)
			end
		end

		local achievement_icon = AceGUI:Create("Icon")
		achievement_icon:SetWidth(1)
		achievement_icon:SetHeight(10)
		class_container:AddChild(achievement_icon)
	end

	local function addEntry(_scroll_frame, _player_name, _self_name) end

	local achievements_container = AceGUI:Create("SimpleGroup")
	achievements_container:SetRelativeWidth(1.0)
	achievements_container:SetHeight(50)
	achievements_container:SetLayout("CenteredFlow")
	scroll_container:AddChild(achievements_container)

	local achievements_container_second_row = AceGUI:Create("SimpleGroup")
	achievements_container_second_row:SetRelativeWidth(1.0)
	achievements_container_second_row:SetHeight(50)
	achievements_container_second_row:SetLayout("CenteredFlow")
	scroll_container:AddChild(achievements_container_second_row)

	local achievements_title = AceGUI:Create("HardcoreClassTitleLabel")
	achievements_title:SetRelativeWidth(1.0)
	achievements_title:SetHeight(40)
	achievements_title:SetText("Questing Achievements")
	achievements_title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
	achievements_container:AddChild(achievements_title)

	local achievements_title = AceGUI:Create("Label")
	achievements_title:SetRelativeWidth(1.0)
	achievements_title:SetHeight(40)
	achievements_title:SetText("Lvl 1-15")
	achievements_title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 16)
	achievements_container:AddChild(achievements_title)
	DrawClassContainer(achievements_container, 1, 15, 50)

	local achievements_title = AceGUI:Create("Label")
	achievements_title:SetRelativeWidth(1.0)
	achievements_title:SetHeight(40)
	achievements_title:SetText("Lvl 16-30")
	achievements_title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 16)
	achievements_container:AddChild(achievements_title)
	DrawClassContainer(achievements_container, 16, 30, 50)

	local achievements_title = AceGUI:Create("Label")
	achievements_title:SetRelativeWidth(1.0)
	achievements_title:SetHeight(40)
	achievements_title:SetText("Lvl 31-40")
	achievements_title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 16)
	achievements_container:AddChild(achievements_title)
	DrawClassContainer(achievements_container, 31, 40, 50)

	local achievements_title = AceGUI:Create("Label")
	achievements_title:SetRelativeWidth(1.0)
	achievements_title:SetHeight(40)
	achievements_title:SetText("Lvl 41-50")
	achievements_title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 16)
	achievements_container:AddChild(achievements_title)
	DrawClassContainer(achievements_container, 41, 50, 50)

	local achievements_title = AceGUI:Create("Label")
	achievements_title:SetRelativeWidth(1.0)
	achievements_title:SetHeight(40)
	achievements_title:SetText("Lvl 51-60")
	achievements_title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 16)
	achievements_container:AddChild(achievements_title)
	DrawClassContainer(achievements_container, 51, 60, 50)

	local achievements_container = AceGUI:Create("SimpleGroup")
	achievements_container:SetRelativeWidth(1.0)
	achievements_container:SetHeight(200)
	achievements_container:SetLayout("CenteredFlow")
	scroll_container:AddChild(achievements_container)
end

	local function DrawPassiveAchievementsTab(container, _scroll_frame)
		DrawClassTitleRow(_scroll_frame, "General Passive")
		for k, achievement_name in pairs(_G.passive_achievements_order) do
			local achievement = _G.passive_achievements[achievement_name]
			if achievement ~= nil then
				if achievement.class == "All" then
					DrawPassiveAchievementRow(achievement, _scroll_frame)
				end
			end
		end

		local class_list = { "Alliance Only", "Horde Only" }

		for i, class in ipairs(class_list) do
			DrawClassTitleRow(_scroll_frame, class)
			for k, achievement in pairs(_G.achievements) do
				if achievement.class == class then
					DrawAchievementRow(achievement, _scroll_frame)
				end
			end
		end

		local bottom_buffer = AceGUI:Create("SimpleGroup")
		bottom_buffer:SetWidth(1)
		bottom_buffer:SetHeight(5)
		bottom_buffer:SetLayout("Flow")
		_scroll_frame:AddChild(bottom_buffer)
	end

	tabcontainer = AceGUI:Create("TabGroup") -- "InlineGroup" is also good
	tabcontainer:SetTabs({
		{ value = "WelcomeTab", text = "General" },
		{ value = "PartyTab", text = "Party" },
		{ value = "AchievementsTab", text = "Active Achievements" },
		-- { value = "PassiveAchievementsTab", text = "Passive Achievements" },
	}) -- ,
	tabcontainer:SetFullWidth(true)
	tabcontainer:SetFullHeight(true) -- probably?
	tabcontainer:SetLayout("Fill") -- important!

	-- Callback function for OnGroupSelected
	local function SelectGroup(container, event, group)
		container:ReleaseChildren()
		if group == "WelcomeTab" then
			DrawGeneralTab(container)
		elseif group == "PartyTab" then
			local scroll_container = AceGUI:Create("SimpleGroup")
			scroll_container:SetFullWidth(true)
			scroll_container:SetFullHeight(true)
			scroll_container:SetLayout("Fill")
			tabcontainer:AddChild(scroll_container)

			local scroll_frame = AceGUI:Create("ScrollFrame")
			scroll_frame:SetLayout("Flow")
			scroll_container:AddChild(scroll_frame)

			DrawPartyTab(container, scroll_frame)
		elseif group == "AchievementsTab" then
			local scroll_container = AceGUI:Create("SimpleGroup")
			scroll_container:SetFullWidth(true)
			scroll_container:SetFullHeight(true)
			scroll_container:SetLayout("Fill")
			tabcontainer:AddChild(scroll_container)

			local scroll_frame = AceGUI:Create("ScrollFrame")
			scroll_frame:SetLayout("Flow")
			scroll_container:AddChild(scroll_frame)

			DrawAchievementsTab(container, scroll_frame)
		elseif group == "PassiveAchievementsTab" then
			local scroll_container = AceGUI:Create("SimpleGroup")
			scroll_container:SetFullWidth(true)
			scroll_container:SetFullHeight(true)
			scroll_container:SetLayout("Fill")
			tabcontainer:AddChild(scroll_container)

			local scroll_frame = AceGUI:Create("ScrollFrame")
			scroll_frame:SetLayout("Flow")
			scroll_container:AddChild(scroll_frame)

			DrawPassiveAchievementsTab2(container, scroll_frame)
		end
	end

	tabcontainer:SetCallback("OnGroupSelected", SelectGroup)
	tabcontainer:SelectTab("WelcomeTab")

	f:AddChild(tabcontainer)
	f:SetCallback("OnClose", function()
		local party_modes = {
			"Solo",
			"Duo",
			"Trio",
		}
		for i, mode in ipairs(party_modes) do
			if _G.extra_rules[mode] ~= nil then
				_G.extra_rules[mode]:Unregister()
			end
		end
		if _G.extra_rules[_hardcore_character.party_mode] ~= nil then
			_G.extra_rules[_hardcore_character.party_mode]:Register(_, _hardcore_character, _hardcore_settings)
		end
	end)
end
