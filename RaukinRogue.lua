RaukinRogue = CreateFrame("Frame","RaukinRogue")

RaukinRogue:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

media = LibStub("LibSharedMedia-3.0")

RaukinRogue:RegisterEvent("ADDON_LOADED")

function RaukinRogue.ADDON_LOADED(self,event,arg1)
	if arg1=="RaukinRogue" then

	local a,b = UnitClass("player")
		if b=="ROGUE" then
			RaukinRogueDB = RaukinRogueDB or {}
			RaukinRogueDB.target = RaukinRogueDB.target or {}
        		RaukinRogueDB.target.posX = RaukinRogueDB.target.posX or 0
       		 	RaukinRogueDB.target.posY = RaukinRogueDB.target.posY or 20
        		RaukinRogueDB.target.width = RaukinRogueDB.target.width or 34
        		RaukinRogueDB.target.height = RaukinRogueDB.target.height or 34	
			RaukinRogueDB.target.alpha = RaukinRogueDB.target.alpha or 1
        
        		RaukinRogueDB.focus = RaukinRogueDB.focus or {}
        		RaukinRogueDB.focus.posX = RaukinRogueDB.focus.posX or 0
        		RaukinRogueDB.focus.posY = RaukinRogueDB.focus.posY or -20
        		RaukinRogueDB.focus.width = RaukinRogueDB.focus.width or 34
        		RaukinRogueDB.focus.height = RaukinRogueDB.focus.height or 34	
			RaukinRogueDB.focus.alpha = RaukinRogueDB.focus.alpha or 1
		
			RaukinRogueDB.target.sap = RaukinRogueDB.target.sap or 1
			RaukinRogueDB.target.kidney = RaukinRogueDB.target.kidney or 1
			RaukinRogueDB.target.kick = RaukinRogueDB.target.kick or 1

			RaukinRogueDB.focus.sap = RaukinRogueDB.focus.sap or 1
			RaukinRogueDB.focus.kidney = RaukinRogueDB.focus.kidney or 1
			RaukinRogueDB.focus.kick = RaukinRogueDB.focus.kick or 1
    
			Tframe = CreateFrame("Frame",nil,UIParent)
			Tframe:SetFrameStrata("HIGH")
			Tframe:SetWidth(RaukinRogueDB.target.width)
			Tframe:SetHeight(RaukinRogueDB.target.height)
			Tframe:SetAlpha(RaukinRogueDB.target.alpha)

			tT = Tframe:CreateTexture(nil,"BACKGROUND")
			_,_,dsIcon = GetSpellInfo(6770) 
			tT:SetTexture(dsIcon)
			tT:SetTexCoord(.07, .93, .07, .93)
			tT:SetAllPoints(Tframe)
			Tframe.texture = t

			Tframe:SetPoint("CENTER",UIParent,"CENTER",RaukinRogueDB.target.posX,RaukinRogueDB.target.posY)

			Tframe:SetMovable(true)
			Tframe:EnableMouse(true)
			Tframe:RegisterForDrag("LeftButton")
			Tframe:SetScript("OnDragStart", Tframe.StartMoving)
			Tframe:SetScript("OnDragStop", 
				function() 
					Tframe:StopMovingOrSizing() 
					local point, relativeTo, relativePoint, xOfs, yOfs = Tframe:GetPoint() 
					RaukinRogueDB.target.posX = xOfs 
					RaukinRogueDB.target.posY = yOfs 
				end)

			Fframe = CreateFrame("Frame",nil,UIParent)
			Fframe:SetFrameStrata("HIGH")
			Fframe:SetWidth(RaukinRogueDB.focus.width)
			Fframe:SetHeight(RaukinRogueDB.focus.height)
			Fframe:SetAlpha(RaukinRogueDB.focus.alpha)

			tF = Fframe:CreateTexture(nil,"BACKGROUND")
			_,_,dsIcon = GetSpellInfo(6770) 
			tF:SetTexture(dsIcon)
			tF:SetTexCoord(.07, .93, .07, .93)
			tF:SetAllPoints(Fframe)
			Fframe.texture = tF

			Fframe:SetPoint("CENTER",UIParent,"CENTER",RaukinRogueDB.focus.posX,RaukinRogueDB.focus.posY)

			Fframe:SetMovable(true)
			Fframe:EnableMouse(true)
			Fframe:RegisterForDrag("LeftButton")
			Fframe:SetScript("OnDragStart", Fframe.StartMoving)
			Fframe:SetScript("OnDragStop", 
				function() 
					Fframe:StopMovingOrSizing() 
					local point, relativeTo, relativePoint, xOfs, yOfs = Fframe:GetPoint() 
					RaukinRogueDB.focus.posX = xOfs 
					RaukinRogueDB.focus.posY = yOfs 
				end)

			Fframe:SetScript("OnUpdate", RaukinRogue.Onupdate)
			Fframe:Show()
			Tframe:Show()
			RaukinRogue.MakeOptions()
		else
            		RaukinRogue:UnregisterEvent("ADDON_LOADED")
            		return
		end
	end
end

function RaukinRogue.Onupdate()
	if UnitExists("focus") then 
		Fframe:SetAlpha(RaukinRogueDB.focus.alpha)

		local Energy=UnitMana("player")
		local isDead = UnitIsDead("focus")
		local ComboP=0  --GetComboPoints("player", "target")
		local _,_,_,_,_,_,Int=UnitCastingInfo("focus")
  		local Type=UnitCreatureType("focus")
    		local Combat=UnitAffectingCombat("focus")
    		local Harm=UnitIsEnemy("player","focus")
    		local n,Class=UnitClass("focus")
    		local Power=UnitPower("focus", Energy)
    		local Exists = UnitExists("focus")
		local n,kidCd = GetSpellCooldown(408)
		local n,kickCd = GetSpellCooldown(1766)
		local selectF=0

    		if ((Type=="Humanoid" or (Class=="DRUID" and Power>0)) and Harm and Combat==nil and Exists and Energy>=32 and selectF==0 and isDead==nil) then
			tF = Fframe:CreateTexture(nil,"BACKGROUND")
			 _,_,dsIcon = GetSpellInfo(6770) 
			tF:SetTexture(dsIcon)
			Fframe.texture = tF
			selectF=1
    		elseif (Harm and Combat and Exists and kidCd<2 and Energy>=25 and ComboP>0 and selectF==0 and isDead==nil) then
			tF = Fframe:CreateTexture(nil,"BACKGROUND")
			 _,_,dsIcon = GetSpellInfo(408) 
			tF:SetTexture(dsIcon)
			Fframe.texture = tF
			selectF=1
		elseif (Int==false and Harm and Energy>=25 and kickCd<2 and Exists and Combat and selectF==0 and isDead==nil) then
			tF = Fframe:CreateTexture(nil,"BACKGROUND")
			 _,_,dsIcon = GetSpellInfo(45356) 
			tF:SetTexture(dsIcon)
			Fframe.texture = tF
			selectF=1
		else
			Fframe:SetAlpha(0)
			selectF=0
		end	

	else
		Fframe:SetAlpha(0)
	end

	if UnitExists("target") then 
		Tframe:SetAlpha(RaukinRogueDB.focus.alpha)

		local Energy=UnitMana("player")
		local isDead = UnitIsDead("focus")
		local ComboP=GetComboPoints("player", "target")
		local _,_,_,_,_,_,Int=UnitCastingInfo("target")
  		local Type=UnitCreatureType("target")
    		local Combat=UnitAffectingCombat("target")
    		local Harm=UnitIsEnemy("player","target")
    		local n,Class=UnitClass("target")
    		local Power=UnitPower("target", Energy)
    		local Exists = UnitExists("target")
		local n,kidCd = GetSpellCooldown(408)
		local n,kickCd = GetSpellCooldown(1766)
		local selectT=0

    		if ((Type=="Humanoid" or (Class=="DRUID" and Power>0)) and Harm and Combat==nil and Exists and Energy>=32 and selectT==0 and isDead==nil) then
			tT = Tframe:CreateTexture(nil,"BACKGROUND")
			 _,_,dsIcon = GetSpellInfo(6770) 
			tT:SetTexture(dsIcon)
			Tframe.texture = tT
			selectF=1
    		elseif (Harm and Combat and Exists and kidCd<2 and Energy>=25 and ComboP>0 and selectT==0 and isDead==nil) then
			tT = Tframe:CreateTexture(nil,"BACKGROUND")
			 _,_,dsIcon = GetSpellInfo(408) 
			tT:SetTexture(dsIcon)
			Tframe.texture = tT
			selectF=1
		elseif (Int==false and Harm and Energy>=25 and kickCd<2 and Exists and Combat and selectT==0 and isDead==nil) then
			tT = Tframe:CreateTexture(nil,"BACKGROUND")
			 _,_,dsIcon = GetSpellInfo(45356) 
			tT:SetTexture(dsIcon)
			Tframe.texture = tT
			selectF=1
		else
			Tframe:SetAlpha(0)
			selectT=0
		end
	else
		Tframe:SetAlpha(0)
	end
end

function RaukinRogue.UpdateFrames()
	Tframe:SetWidth(RaukinRogueDB.target.width)
	Tframe:SetHeight(RaukinRogueDB.target.height)
	Tframe:SetAlpha(RaukinRogueDB.target.alpha)

	local point, relativeTo, relativePoint, xOfs, yOfs = Tframe:GetPoint() 
	RaukinRogueDB.target.posX = xOfs 
	RaukinRogueDB.target.posY = yOfs 

	Fframe:SetWidth(RaukinRogueDB.focus.width)
	Fframe:SetHeight(RaukinRogueDB.focus.height)
	Fframe:SetAlpha(RaukinRogueDB.focus.alpha)

	local point, relativeTo, relativePoint, xOfs, yOfs = Fframe:GetPoint() 
	RaukinRogueDB.focus.posX = xOfs 
	RaukinRogueDB.focus.posY = yOfs 
end

function RaukinRogue.MakeOptions(self)

    local opt = {
		type = 'group',
        name = "RaukinRogue",
        args = {},
	}
    opt.args.general = {
        type = "group",
        name = "Sizing options",
        order = 1,
        args = {
            SizeT = {
                type = "group",
                name = "Target Sizing",
                guiInline = true,
                order = 1,
                args = {
                    size = {
                        name = "Target Icon Size",
                        type = "range",
                        get = function(info) return RaukinRogueDB.target.width end,
                        set = function(info, s) RaukinRogueDB.target.width = s; RaukinRogueDB.target.height = s; RaukinRogue.UpdateFrames(); end,
                        min = 1,
                        max = 400,
                        step = 1,
                    },
                },
            },
            SizeF = {
                type = "group",
                name = "Focus Sizing",
                guiInline = true,
                order = 2,
                args = {
                    size = {
                        name = "Focus Icon Size",
                        type = "range",
                        get = function(info) return RaukinRogueDB.focus.width end,
                        set = function(info, s) RaukinRogueDB.focus.width = s; RaukinRogueDB.focus.height = s; RaukinRogue.UpdateFrames(); end,
                        min = 1,
                        max = 400,
                        step = 1,
                    },
                },
            },
            AlphaFT = {
                type = "group",
                name = "Aplha of Frames",
                guiInline = true,
                order = 3,
                args = {
                    alpha = {
                        name = "Alpha of Icons",
                        type = "range",
                        get = function(info) return RaukinRogueDB.focus.alpha end,
                        set = function(info, s) RaukinRogueDB.focus.alpha = s; RaukinRogueDB.target.alpha = s; RaukinRogue.UpdateFrames(); end,
                        min = 0,
                        max = 1,
                        step = 0.1,
                    },
                },
            },
            ShowCCTarget = {
                type = "group",
                name = "Show Target CC",
                guiInline = true,
                order = 4,
                args = {
                    sap = {
                        name = "Show Sap",
                        type = "toggle",
                        get = function(info) return RaukinRogueDB.target.sap end,
                        set = function(info, s) RaukinRogueDB.target.sap = s; end,
                    },
                    kidney = {
                        name = "Show Kidney",
                        type = "toggle",
                        get = function(info) return RaukinRogueDB.target.kidney end,
                        set = function(info, s) RaukinRogueDB.target.kidney = s; end,
                    },
                    kick = {
                        name = "Show Kick",
                        type = "toggle",
                        get = function(info) return RaukinRogueDB.target.kick end,
                        set = function(info, s) RaukinRogueDB.target.kick = s; end,
                    },
                },
            },
            ShowCCFocus = {
                type = "group",
                name = "Show Focus CC",
                guiInline = true,
                order = 5,
                args = {
                    sap = {
                        name = "Show Sap",
                        type = "toggle",
                        get = function(info) return RaukinRogueDB.focus.sap end,
                        set = function(info, s) RaukinRogueDB.focus.sap = s; end,
                    },
                    kidney = {
                        name = "Show Kidney",
                        type = "toggle",
                        get = function(info) return RaukinRogueDB.focus.kidney end,
                        set = function(info, s) RaukinRogueDB.focus.kidney = s; end,
                    },
                    kick = {
                        name = "Show Kick",
                        type = "toggle",
                        get = function(info) return RaukinRogueDB.focus.kick end,
                        set = function(info, s) RaukinRogueDB.focus.kick = s; end,
                    },
                },
            },
        },
    }
    
    local Config = LibStub("AceConfigRegistry-3.0")
    local Dialog = LibStub("AceConfigDialog-3.0")
    
    Config:RegisterOptionsTable("RaukinRogue-Bliz", {name = "RaukinRogue",type = 'group',args = {} })
    Dialog:SetDefaultSize("RaukinRogue-Bliz", 600, 400)
    
    Config:RegisterOptionsTable("RaukinRogue-General", opt.args.general)
    Dialog:AddToBlizOptions("RaukinRogue-General", "RaukinRogue")
    

    SLASH_MBSLASH1 = "/rrog";
    SLASH_MBSLASH2 = "/RaukinRogue";
    SlashCmdList["MBSLASH"] = function() InterfaceOptionsFrame_OpenToFrame("RaukinRogue") end;
end