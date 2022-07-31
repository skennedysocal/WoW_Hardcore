function ShowFirstMenu(_hardcore_character)
  local AceGUI = LibStub("AceGUI-3.0")
  local f = AceGUI:Create("HardcoreFrame")
  f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
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
    achievement_icon:SetWidth(60)
    achievement_icon:SetHeight(60)
    achievement_icon:SetImage(achievement.icon_path)
    achievement_icon:SetImageSize(60,60)
    achievement_icon.image:SetVertexColor(.2,.2,.2)
    if (_hardcore_character.achievements == nil) then
      _hardcore_character.achievements = {}
    end
    for i,v in ipairs(_hardcore_character.achievements) do
      if  (v == achievement.name) then
        achievement_icon.image:SetVertexColor(1,1,1)
      end
    end
    achievement_icon:SetCallback("OnClick", function() 
      local activate = true
      for i,v in ipairs(_hardcore_character.achievements) do
        if  (v == achievement.name) then
          activate = false
					table.remove(_hardcore_character.achievements, i)
          achievement_icon.image:SetVertexColor(.1,.1,.1)
          achievement:Unregister()
          Hardcore:Print("Removed " .. achievement.name .. " challenge!")
        end
      end

      if (activate) then
	local _, _, _class_id = UnitClass("player")
	if (CLASSES[_class_id] ~= achievement.class and achievement.class ~= "All") then 
	  Hardcore:Print("Cannot start achievement " .. achievement.title .. " as class " .. CLASSES[_class_id])
	else
	  table.insert(_hardcore_character.achievements, achievement.name)
	  achievement_icon.image:SetVertexColor(1,1,1) 
	  achievement:Register(failure_function_executor)
	  Hardcore:Print("Added " .. achievement.name .. " challenge!")
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
    title:SetPoint("TOP", 2,5)
    title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
    btn_container_frame:AddChild(title)
    
    local description = AceGUI:Create("InteractiveLabel")
    description:SetWidth(550)
    description:SetFont("", 16)
    description:SetText(achievement.description)
    description:SetPoint("BOTTOM", 200,5)
    btn_container_frame:AddChild(description)
  end

  local function DrawGeneralTab(container)
    local first_menu_description = AceGUI:Create("Label")
    first_menu_description:SetWidth(550)
    first_menu_description:SetText("Welcome to WoW Hardcore!  If playing in a duo or trio, click the `Duos/Trio` tab.  To select an achievement, click on an icon in the achievement tab.  This window will not appear past level 2.")
    first_menu_description:SetFont("Fonts\\FRIZQT__.TTF", 12)
    first_menu_description:SetPoint("TOP", 2,5)
    tabcontainer:AddChild(first_menu_description)
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
      ["General"] = "FFFFFF",
    }
    title:SetText("|c00" .. CLASS_COLOR_BY_NAME[_title] .. _title .. "|r Achievements")
    title:SetFont("Interface\\Addons\\Hardcore\\Media\\BreatheFire.ttf", 20)
    row_container:AddChild(title)
  end

  local function DrawAchievementsTab(container, _scroll_frame)
    DrawClassTitleRow(_scroll_frame, "General")
    for k, achievement in pairs(_G.achievements) do
      if achievement.class == "All" then
	DrawAchievementRow(achievement, _scroll_frame)
      end
    end

    local class_list = {"Paladin", "Priest", "Rogue", "Shaman", "Druid", "Mage", "Hunter", "Warlock", "Warrior"}

    for i, class in ipairs(class_list) do
      DrawClassTitleRow(_scroll_frame, class)
      for k, achievement in pairs(_G.achievements) do
	if achievement.class == class then
	  DrawAchievementRow(achievement, _scroll_frame)
	end
      end
    end
  end


  tabcontainer = AceGUI:Create("TabGroup") -- "InlineGroup" is also good
  tabcontainer:SetTabs({{value="WelcomeTab", text="General"}, {value="PartyTab", text="Duos/Trios"}, {value="AchievementsTab", text="Achievements"}})  -- , 
  tabcontainer:SetFullWidth(true)
  tabcontainer:SetFullHeight(true) -- probably?
  tabcontainer:SetLayout("Fill") -- important!

  -- Callback function for OnGroupSelected
  local function SelectGroup(container, event, group)
     container:ReleaseChildren()
     if group == "WelcomeTab" then
        DrawGeneralTab(container)
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
     end
  end

  tabcontainer:SetCallback("OnGroupSelected", SelectGroup)
  tabcontainer:SelectTab("WelcomeTab")

  f:AddChild(tabcontainer)
end
