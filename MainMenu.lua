local AceGUI = LibStub("AceGUI-3.0")

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

local function DrawRulesTab(container)
	local function DrawRulesLabel(text, _scroll_frame)
	  local general_rules_label = AceGUI:Create("HardcoreClassTitleLabel")
	  general_rules_label:SetWidth(600)
	  general_rules_label:SetHeight(60)
	  general_rules_label:SetText(text)
	  general_rules_label:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
	  _scroll_frame:AddChild(general_rules_label)
	end
	local scroll_container = AceGUI:Create("SimpleGroup")
	scroll_container:SetFullWidth(true)
	scroll_container:SetFullHeight(true)
	scroll_container:SetLayout("Fill")
	tabcontainer:AddChild(scroll_container)

	local scroll_frame = AceGUI:Create("ScrollFrame")
	scroll_frame:SetLayout("Flow")
	scroll_container:AddChild(scroll_frame)

	DrawRulesLabel("General", scroll_frame)
	local general_rules_description = AceGUI:Create("Label")
	general_rules_description:SetWidth(600)
	general_rules_description:SetText(
		"\nFor more info, rules, news, hall of legends, challenges, and more visit the classichc website. Help is available on discord (link on website) \n\nAll professions allowed\nNo restriction on talents\n\nYou can use gear that you pickup or craft\nNo Auction house, No mailbox, No trading\n\nNo grouping in open world\n\nNo battlegrounds allowed\n\nBuffs from others are allowed, don't ask for others for buffs\n\n\n\n"
	)
	general_rules_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
	scroll_frame:AddChild(general_rules_description)

	DrawRulesLabel("Dungeon Groups", scroll_frame)
	local general_rules_description = AceGUI:Create("Label")
	general_rules_description:SetWidth(600)
	general_rules_description:SetText(
		"\nDungeon Groups are authorized but only ONE run of each Dungeon per character.  Everyone in party must be following hardcore rules.  Everyone must be in level range of the meeting stone.  Group at the meeting stone to start the dungeon.  You can invite people who are on the way.  If you level up inside of the dungeon and exceed the meeting stone requirement you can stay.  Warlocks are allowed to summon players to the meeting stone\n\n\n\n"
	)
	general_rules_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
	scroll_frame:AddChild(general_rules_description)

	DrawRulesLabel("Class and Item Specific", scroll_frame)
	local general_rules_description = AceGUI:Create("Label")
	general_rules_description:SetWidth(600)
	general_rules_description:SetText(
		"\nWarlocks can’t resurrect via SS.  Shamans can’t resurrect via Ankh.  Paladins can’t Bubble Hearth. \n\nNo Light of Elune + Hearthstone\n\n\n\n"
	)
	general_rules_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
	scroll_frame:AddChild(general_rules_description)

	DrawRulesLabel("Verification", scroll_frame)
	local general_rules_description = AceGUI:Create("Label")
	general_rules_description:SetWidth(600)
	general_rules_description:SetText(
		"\nYou can verify your run using this addon (Get verified tab). Recording or streaming is also recommended to provide evidence for special circumstances such as disconnection deaths.\n\nAt 60 you earn your IMMORTALITY and become a full fledged character with insane bragging rights.\n\n\n\n"
	)
	general_rules_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
	scroll_frame:AddChild(general_rules_description)

	DrawRulesLabel("Duos/Trios", scroll_frame)
	local general_rules_description = AceGUI:Create("Label")
	general_rules_description:SetWidth(600)
	general_rules_description:SetText(
		"\nYou must not leave the same zone as each other, unless you are a Druid going to Moonglade to complete essential class quests.\nYou must choose a combo that spawns in the same starting location.\nIf one of you dies, the other must fall on the sword and the run is over.\nYou can trade your duo partner found or crafted items, including gold.\nMultiboxing goes against the spirit of the Hardcore Challenge and is not allowed.\n\n\n\n"
	)
	general_rules_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
	scroll_frame:AddChild(general_rules_description)
end

local function DrawVerifyTab(container, _hardcore_character)
local ATTRIBUTE_SEPARATOR = "_"
local function GenerateVerificationString()
	local _, class, _, race, _, name = GetPlayerInfoByGUID(UnitGUID("player"))
	local realm = GetRealmName()
	local level = UnitLevel("player")

	local tradePartners = Hardcore_join(_hardcore_character.trade_partners, ",")
	local baseVerificationData = {
		_hardcore_character.guid,
		realm,
		race,
		class,
		name,
		level,
		_hardcore_character.time_played,
		_hardcore_character.time_tracked,
		#_hardcore_character.deaths,
		tradePartners,
	}
	local baseVerificationString =
		Hardcore_join(Hardcore_map(baseVerificationData, Hardcore_stringOrNumberToUnicode), ATTRIBUTE_SEPARATOR)
	local bubbleHearthIncidentsVerificationString = Hardcore_tableToUnicode(_hardcore_character.bubble_hearth_incidents)
	local playedtimeGapsVerificationString = Hardcore_tableToUnicode(_hardcore_character.played_time_gap_warnings)
	local converted_successfully = "FALSE"
	if _hardcore_character.converted_successfully then
		converted_successfully = "TRUE"
	end
	local dk_conversion = {
		sacrificed_at = _hardcore_character.sacrificated_at,
		converted_successfully = converted_successfully,
		converted_time = _hardcore_character.converted_time,
	}
	local dkTable = {}
	table.insert(dkTable, dk_conversion)
	local deathknightVerificationString = Hardcore_tableToUnicode(dkTable)
	local game_version_string = Hardcore_join(Hardcore_map({_G["HardcoreBuildLabel"]},  Hardcore_stringOrNumberToUnicode))
	return Hardcore_join(
		{
			baseVerificationString,
			bubbleHearthIncidentsVerificationString,
			playedtimeGapsVerificationString,
			deathknightVerificationString,
			game_version_string,
		},
		ATTRIBUTE_SEPARATOR
	)
end

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
		first_menu_description_title:SetText("Verify Your Character")
		first_menu_description_title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
		scroll_frame:AddChild(first_menu_description_title)

		local general_rules_description = AceGUI:Create("Label")
		general_rules_description:SetWidth(600)
		general_rules_description:SetText(
			"\n\nTo get verified, copy the string below and visit the classichc website."
		)
		general_rules_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
		scroll_frame:AddChild(general_rules_description)


		local first_menu_description = AceGUI:Create("MultiLineEditBox")
		first_menu_description.button:Hide()
		first_menu_description:SetMaxLetters(0)
		first_menu_description:SetHeight(850)
		first_menu_description.button:SetPoint("BOTTOMLEFT", 0, -150)
		first_menu_description:SetWidth(750)
		first_menu_description:SetLabel("")
		first_menu_description:SetText(GenerateVerificationString())
		scroll_frame:AddChild(first_menu_description)

		local copy_tip_label = AceGUI:Create("Label")
		copy_tip_label:SetText("\n\n\n\n\n\n\n\n\n\n\n\n\nSelect All (Ctrl-A), Copy (Ctrl-C), and Paste (Ctrl-V)")
		copy_tip_label:SetWidth(700)
		copy_tip_label:SetFontObject(GameFontHighlightSmall)
		scroll_frame:AddChild(copy_tip_label)
end

local function DrawDKTab(container, dk_button_function)
	local function DrawRulesLabel(text, _scroll_frame)
	  local general_rules_label = AceGUI:Create("HardcoreClassTitleLabel")
	  general_rules_label:SetWidth(600)
	  general_rules_label:SetHeight(60)
	  general_rules_label:SetText(text)
	  general_rules_label:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
	  _scroll_frame:AddChild(general_rules_label)
	end
	local scroll_container = AceGUI:Create("SimpleGroup")
	scroll_container:SetFullWidth(true)
	scroll_container:SetFullHeight(true)
	scroll_container:SetLayout("List")
	tabcontainer:AddChild(scroll_container)

	local scroll_frame = AceGUI:Create("ScrollFrame")
	scroll_frame:SetLayout("Flow")
	scroll_frame:SetHeight(320)
	scroll_container:AddChild(scroll_frame)

	DrawRulesLabel("", scroll_frame)
	local general_rules_description = AceGUI:Create("Label")
	general_rules_description:SetWidth(600)
	general_rules_description:SetText(
		"Death Knights are authorized for the Hardcore Challenge, adding in these following rules.  You must level a character of the SAME FACTION following the standard HC Ruleset, at which point it must be sacrificed to create a Death Knight.  The sacrificial level is a range between 55 and 58. You cannot sacrifice before or after these levels.  As a side note, sacrificing a toon does not mean you must delete it, but it will no longer be valid HC toon.\n"
	)
	general_rules_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
	scroll_frame:AddChild(general_rules_description)

	DrawRulesLabel("", scroll_frame)
	local general_rules_description = AceGUI:Create("Label")
	general_rules_description:SetWidth(600)
	general_rules_description:SetText(
		"\nIf you should die or fail your run while playing as a Death Knight, you must start over from level 1, with a fresh toon to perform the sacrifice again. You may create your DK in advance if you wish to RSVP a name, but do not log onto them. Remember that you need to have a lvl 55 already on the server to create a DK.  Duo and Trio groups who wish to have a DK in the party must follow some additional steps in creating a DK. These steps are listed further below.  General achievements will carry over when you activate your DK\n\n\n\n"
	)
	general_rules_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
	scroll_frame:AddChild(general_rules_description)

	DrawRulesLabel("Solo DK", scroll_frame)
	local general_rules_description = AceGUI:Create("Label")
	general_rules_description:SetWidth(600)
	general_rules_description:SetText(
"Listed below is a step by step process for creating a DK while solo.. \n    Step 1: Level a character of the “SAME FACTION” to the required level range, following the HC rules.\n    Step 2: Click on the “SACRIFICE” button below. This starts a 5 minute timer. You cannot activate the “SACRIFICE” button while in combat, stealthed, or during Feign Death.\n    Step 3: During these 5 minutes, you must die on your current character. After dying, log out.\n    Step 4: DO NOT DELETE THE TOON YOU SACRIFICED UNTIL AFTER THE DK IS ACTIVATED!!\n    Step 5: Create or log onto your Death Knight.\n    Step 6: Click on “ACTIVATE” below. Then do a /reload. You are now good to go.\nSurvive well out there!\n\n\n\n"
	)
	general_rules_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
	scroll_frame:AddChild(general_rules_description)

	DrawRulesLabel("Duo/Trio DK", scroll_frame)
	local general_rules_description = AceGUI:Create("Label")
	general_rules_description:SetWidth(600)
	general_rules_description:SetText(
		"There are some additional things you must do when you wish to create a DK for Duo or Trio groups.\n    Step 1: Start your Duo/Trio group of the “SAME FACTION” and reach the level range for sacrifice, following the HC rules.\n    Step 2: For the player who is sacrificing, click on the “SACRIFICE” button below. This starts a 5 minute timer. You cannot activate the \“SACRIFICE\” button while in combat, stealthed, or during Feign Death.\n    Step 3: During these 5 minutes, you must die on your current character. After dying, drop group and logout. Your partners who are not sacrificing MUST STAY ONLINE!\n    Step 4: DO NOT DELETE THE TOON YOU SACRIFICED UNTIL AFTER THE DK IS ACTIVATED!!\n    Step 5: Create or log onto your Death Knight.\n    Step 6: Click on “ACTIVATE” below.\n    Step 7: Rejoin the party with your partners using /inv \“Name\” \n    Step 8: All party member must /reload\n    Step 9: If more than one player is creating a DK, then you must follow the steps ONE PERSON AT A TIME! Multiple players creating a DK in the party at the same time WILL invalidate your run. \n\n\n\n"
	)
	general_rules_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
	scroll_frame:AddChild(general_rules_description)

	local button_container = AceGUI:Create("SimpleGroup")
	button_container:SetFullWidth(true)
	button_container:SetFullHeight(true)
	button_container:SetLayout("Flow")
	scroll_container:AddChild(button_container)

	local sacrifice_button = AceGUI:Create("Button")
	sacrifice_button:SetText("Sacrifice")
	sacrifice_button:SetWidth(100)
	button_container:AddChild(sacrifice_button)

	local activate_button = AceGUI:Create("Button")
	activate_button:SetText("Activate")
	activate_button:SetWidth(100)
	button_container:AddChild(activate_button)

	sacrifice_button:SetCallback("OnClick", function()
	  dk_button_function(nil, "sacrifice")
	end)
	activate_button:SetCallback("OnClick", function()
	  dk_button_function(nil, "activate")
	end)
end

local function DrawLevelsTab(container, _hardcore_settings)
	local function addEntry(_scroll_frame, _level_info)
		local entry = AceGUI:Create("SimpleGroup")
		entry:SetLayout("Flow")
		entry:SetFullWidth(true)
		_scroll_frame:AddChild(entry)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(150)
		name_label:SetText(_level_info.player)
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		entry:AddChild(name_label)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(50)
		name_label:SetText(_level_info.level)
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		entry:AddChild(name_label)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(200)
		name_label:SetText(SecondsToTime(_level_info.playedtime))
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		entry:AddChild(name_label)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(200)
		name_label:SetText(_level_info.localtime)
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		entry:AddChild(name_label)
	end
		local scroll_container = AceGUI:Create("SimpleGroup")
		scroll_container:SetFullWidth(true)
		scroll_container:SetFullHeight(true)
		scroll_container:SetLayout("Fill")
		tabcontainer:AddChild(scroll_container)

		local scroll_frame = AceGUI:Create("ScrollFrame")
		scroll_frame:SetLayout("List")
		scroll_container:AddChild(scroll_frame)

		local row_header = AceGUI:Create("SimpleGroup")
		row_header:SetLayout("Flow")
		row_header:SetFullWidth(true)
		scroll_frame:AddChild(row_header)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(150)
		name_label:SetText("|c00FFFF00Name|r")
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		row_header:AddChild(name_label)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(50)
		name_label:SetText("|c00FFFF00Lvl|r")
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		row_header:AddChild(name_label)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(200)
		name_label:SetText("|c00FFFF00Played Time|r")
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		row_header:AddChild(name_label)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(200)
		name_label:SetText("|c00FFFF00Date|r")
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		row_header:AddChild(name_label)

		for _, v in ipairs(_hardcore_settings.level_list) do
		  addEntry(scroll_frame, v)
		end
end

local function DrawAccountabilityTab(container)
	local function addEntry(_scroll_frame, _level_info)
		local entry = AceGUI:Create("SimpleGroup")
		entry:SetLayout("Flow")
		entry:SetFullWidth(true)
		_scroll_frame:AddChild(entry)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(150)
		name_label:SetText(_level_info.player)
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		entry:AddChild(name_label)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(50)
		name_label:SetText(_level_info.level)
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		entry:AddChild(name_label)
	end
		local scroll_container = AceGUI:Create("SimpleGroup")
		scroll_container:SetFullWidth(true)
		scroll_container:SetFullHeight(true)
		scroll_container:SetLayout("Fill")
		tabcontainer:AddChild(scroll_container)

		local scroll_frame = AceGUI:Create("ScrollFrame")
		scroll_frame:SetLayout("List")
		scroll_container:AddChild(scroll_frame)

		local row_header = AceGUI:Create("SimpleGroup")
		row_header:SetLayout("Flow")
		row_header:SetFullWidth(true)
		scroll_frame:AddChild(row_header)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(150)
		name_label:SetText("|c00FFFF00Name|r")
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		row_header:AddChild(name_label)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(50)
		name_label:SetText("|c00FFFF00Lvl|r")
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		row_header:AddChild(name_label)

		local name_label = AceGUI:Create("Label")
		name_label:SetWidth(200)
		name_label:SetText("|c00FFFF00Addon Version|r")
		name_label:SetFont("Fonts\\FRIZQT__.TTF", 12)
		row_header:AddChild(name_label)

		for _, v in ipairs(_hardcore_settings.level_list) do
		  addEntry(scroll_frame, v)
		end
end


function ShowMainMenu(_hardcore_character, _hardcore_settings, dk_button_function)
	local f = AceGUI:Create("HardcoreFrame")
	f:SetCallback("OnClose", function(widget)
		AceGUI:Release(widget)
	end)
	f:SetTitle("Classic Hardcore")
	f:SetStatusText("")
	f:SetLayout("Flow")

	tabcontainer = AceGUI:Create("TabGroup") -- "InlineGroup" is also good
	tabcontainer:SetTabs({
		{ value = "WelcomeTab", text = "General" },
		{ value = "RulesTab", text = "Rules" },
		{ value = "VerifyTab", text = "Verify" },
		{ value = "DKTab", text = "Death Knight" },
		{ value = "LevelsTab", text = "Levels" },
		{ value = "AccountabilityTab", text = "Accountability" },
		{ value = "AchievementsTab", text = "Achievements" },
		{ value = "LeaderboardTab", text = "Leaderboard" },
	}) -- ,
	tabcontainer:SetFullWidth(true)
	tabcontainer:SetFullHeight(true) -- probably?
	tabcontainer:SetLayout("Fill") -- important!

	-- Callback function for OnGroupSelected
	local function SelectGroup(container, event, group)
		container:ReleaseChildren()
		if group == "WelcomeTab" then
			DrawGeneralTab(container)
		elseif group == "RulesTab" then
			DrawRulesTab(container)
		elseif group == "VerifyTab" then
			DrawVerifyTab(container, _hardcore_character)
		elseif group == "DKTab" then
			DrawDKTab(container, dk_button_function)
		elseif group == "LevelsTab" then
			DrawLevelsTab(container, _hardcore_settings)
		elseif group == "AccountabilityTab" then
			DrawAccountabilityTab(container, _hardcore_settings)
		elseif group == "PartyTab" then
			local scroll_container = AceGUI:Create("SimpleGroup")
			scroll_container:SetFullWidth(true)
			scroll_container:SetFullHeight(true)
			scroll_container:SetLayout("Fill")
			tabcontainer:AddChild(scroll_container)

			local scroll_frame = AceGUI:Create("ScrollFrame")
			scroll_frame:SetLayout("Flow")
			scroll_container:AddChild(scroll_frame)

			-- DrawPartyTab(container, scroll_frame)
		elseif group == "AchievementsTab" then
			local scroll_container = AceGUI:Create("SimpleGroup")
			scroll_container:SetFullWidth(true)
			scroll_container:SetFullHeight(true)
			scroll_container:SetLayout("Fill")
			tabcontainer:AddChild(scroll_container)

			local scroll_frame = AceGUI:Create("ScrollFrame")
			scroll_frame:SetLayout("Flow")
			scroll_container:AddChild(scroll_frame)

			-- DrawAchievementsTab(container, scroll_frame)
		end
	end

	tabcontainer:SetCallback("OnGroupSelected", SelectGroup)
	tabcontainer:SelectTab("WelcomeTab")

	f:AddChild(tabcontainer)
end
