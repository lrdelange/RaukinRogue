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
------------------------------------------- Database -------------------------------------------
			RaukinRogueDB = RaukinRogueDB or {}
			RaukinRogueDB.Moveable = RaukinRogueDB.Moveable or false
			RaukinRogueDB.target = RaukinRogueDB.target or {}
			RaukinRogueDB.target.kidneycombo = RaukinRogueDB.target.kidneycombo or 1
        		RaukinRogueDB.target.posX = RaukinRogueDB.target.posX or 0
       		 	RaukinRogueDB.target.posY = RaukinRogueDB.target.posY or 20
        		RaukinRogueDB.target.width = RaukinRogueDB.target.width or 34
        		RaukinRogueDB.target.height = RaukinRogueDB.target.height or 34	
			RaukinRogueDB.target.alpha = RaukinRogueDB.target.alpha or 1
			RaukinRogueDB.target.point = RaukinRogueDB.target.point or "CENTER"

			RaukinRogueDB.targetkick = RaukinRogueDB.targetkick or {}
        		RaukinRogueDB.targetkick.posX = RaukinRogueDB.targetkick.posX or 40
       		 	RaukinRogueDB.targetkick.posY = RaukinRogueDB.targetkick.posY or 20
        		RaukinRogueDB.targetkick.width = RaukinRogueDB.targetkick.width or 34
        		RaukinRogueDB.targetkick.height = RaukinRogueDB.targetkick.height or 34	
			RaukinRogueDB.targetkick.alpha = RaukinRogueDB.targetkick.alpha or 1
			RaukinRogueDB.targetkick.point = RaukinRogueDB.targetkick.point or "CENTER"

        		RaukinRogueDB.focus = RaukinRogueDB.focus or {}
        		RaukinRogueDB.focus.posX = RaukinRogueDB.focus.posX or 0
        		RaukinRogueDB.focus.posY = RaukinRogueDB.focus.posY or -20
        		RaukinRogueDB.focus.width = RaukinRogueDB.focus.width or 34
        		RaukinRogueDB.focus.height = RaukinRogueDB.focus.height or 34	
			RaukinRogueDB.focus.alpha = RaukinRogueDB.focus.alpha or 1
			RaukinRogueDB.focus.point = RaukinRogueDB.focus.point or "CENTER"

        		RaukinRogueDB.focuskick = RaukinRogueDB.focuskick or {}
        		RaukinRogueDB.focuskick.posX = RaukinRogueDB.focuskick.posX or 40
        		RaukinRogueDB.focuskick.posY = RaukinRogueDB.focuskick.posY or -20
        		RaukinRogueDB.focuskick.width = RaukinRogueDB.focuskick.width or 34
        		RaukinRogueDB.focuskick.height = RaukinRogueDB.focuskick.height or 34	
			RaukinRogueDB.focuskick.alpha = RaukinRogueDB.focuskick.alpha or 1
			RaukinRogueDB.focuskick.point = RaukinRogueDB.focuskick.point or "CENTER"
		
			RaukinRogueDB.target.sap = RaukinRogueDB.target.sap or 1
			RaukinRogueDB.target.kidney = RaukinRogueDB.target.kidney or 1
			RaukinRogueDB.target.kick = RaukinRogueDB.target.kick or 1

			RaukinRogueDB.focus.sap = RaukinRogueDB.focus.sap or 1
			RaukinRogueDB.focus.kick = RaukinRogueDB.focus.kick or 1

------------------------------------------- Target Frame -------------------------------------------
			Tframe = CreateFrame("Frame",nil,UIParent)
			Tframe:SetFrameStrata("HIGH")
			Tframe:SetWidth(RaukinRogueDB.target.width)
			Tframe:SetHeight(RaukinRogueDB.target.height)
			Tframe:SetAlpha(RaukinRogueDB.target.alpha)

			tT = Tframe:CreateTexture(nil,"BACKGROUND")
			_,_,dsIcon = GetSpellInfo(408) 
			tT:SetTexture(dsIcon)
			tT:SetTexCoord(.07, .93, .07, .93)
			tT:SetAllPoints(Tframe)
			Tframe.texture = tT

			tTcolor = Tframe:CreateTexture(nil,"LOW")
			tTcolor:SetAllPoints(Tframe)
			tTcolor:SetTexture(0,1,0,1)
			Tframe.texture = tTcolor
			Tframe.texture:SetAlpha(0)

			Tframe:SetPoint(RaukinRogueDB.target.point,RaukinRogueDB.target.posX,RaukinRogueDB.target.posY)
			Tframe:RegisterForDrag("LeftButton")
			Tframe:SetScript("OnDragStart", Tframe.StartMoving)
			Tframe:SetScript("OnDragStop", 
				function() 
					Tframe:StopMovingOrSizing() 
					point, relativeTo, relativePoint, xOfs, yOfs = Tframe:GetPoint()
					RaukinRogueDB.target.point = point
					RaukinRogueDB.target.posX = xOfs 
					RaukinRogueDB.target.posY = yOfs 
				end)

------------------------------------------- Kick Target Frame -------------------------------------------
			Tframekick = CreateFrame("Frame",nil,UIParent)
			Tframekick:SetFrameStrata("HIGH")
			Tframekick:SetWidth(RaukinRogueDB.targetkick.width)
			Tframekick:SetHeight(RaukinRogueDB.targetkick.height)
			Tframekick:SetAlpha(RaukinRogueDB.targetkick.alpha)

			tTk = Tframekick:CreateTexture(nil,"BACKGROUND")
			_,_,dsIcon = GetSpellInfo(1766) 
			tTk:SetTexture(dsIcon)
			tTk:SetTexCoord(.07, .93, .07, .93)
			tTk:SetAllPoints(Tframekick)
			Tframekick.texture = tTk

			tTcolorkick = Tframekick:CreateTexture(nil,"LOW")
			tTcolorkick:SetAllPoints(Tframekick)
			tTcolorkick:SetTexture(0,1,0,1)
			Tframekick.texture = tTcolorkick
			Tframekick.texture:SetAlpha(0)

			Tframekick:SetPoint(RaukinRogueDB.targetkick.point,RaukinRogueDB.targetkick.posX,RaukinRogueDB.targetkick.posY)
			Tframekick:RegisterForDrag("LeftButton")
			Tframekick:SetScript("OnDragStart", Tframekick.StartMoving)
			Tframekick:SetScript("OnDragStop", 
				function() 
					Tframekick:StopMovingOrSizing() 
					point, relativeTo, relativePoint, xOfs, yOfs = Tframekick:GetPoint()
					RaukinRogueDB.targetkick.point = point
					RaukinRogueDB.targetkick.posX = xOfs 
					RaukinRogueDB.targetkick.posY = yOfs 
				end)

------------------------------------------- Focus Frame -------------------------------------------
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

			tFcolor = Fframe:CreateTexture(nil,"LOW")
			tFcolor:SetAllPoints(Fframe)
			tFcolor:SetTexture(0,0,1,1)
			Fframe.texture = tFcolor
			Fframe.texture:SetAlpha(0)

			Fframe:SetPoint(RaukinRogueDB.focus.point,RaukinRogueDB.focus.posX,RaukinRogueDB.focus.posY)
			Fframe:RegisterForDrag("LeftButton")
			Fframe:SetScript("OnDragStart", Fframe.StartMoving)
			Fframe:SetScript("OnDragStop", 
				function() 
					Fframe:StopMovingOrSizing() 
					point, relativeTo, relativePoint, xOfs, yOfs = Fframe:GetPoint() 
					RaukinRogueDB.focus.point = point
					RaukinRogueDB.focus.posX = xOfs 
					RaukinRogueDB.focus.posY = yOfs 
				end)

------------------------------------------- Focus kick Frame -------------------------------------------
			Fframekick = CreateFrame("Frame",nil,UIParent)
			Fframekick:SetFrameStrata("HIGH")
			Fframekick:SetWidth(RaukinRogueDB.focuskick.width)
			Fframekick:SetHeight(RaukinRogueDB.focuskick.height)
			Fframekick:SetAlpha(RaukinRogueDB.focuskick.alpha)

			tFk = Fframekick:CreateTexture(nil,"BACKGROUND")
			_,_,dsIcon = GetSpellInfo(1766) 
			tFk:SetTexture(dsIcon)
			tFk:SetTexCoord(.07, .93, .07, .93)
			tFk:SetAllPoints(Fframekick)
			Fframekick.texture = tFk

			tFcolorkick = Fframekick:CreateTexture(nil,"LOW")
			tFcolorkick:SetAllPoints(Fframekick)
			tFcolorkick:SetTexture(0,0,1,1)
			Fframekick.texture = tFcolorkick
			Fframekick.texture:SetAlpha(0)

			Fframekick:SetPoint(RaukinRogueDB.focuskick.point,RaukinRogueDB.focuskick.posX,RaukinRogueDB.focuskick.posY)
			Fframekick:RegisterForDrag("LeftButton")
			Fframekick:SetScript("OnDragStart", Fframekick.StartMoving)
			Fframekick:SetScript("OnDragStop", 
				function() 
					Fframekick:StopMovingOrSizing() 
					point, relativeTo, relativePoint, xOfs, yOfs = Fframekick:GetPoint() 
					RaukinRogueDB.focuskick.point = point
					RaukinRogueDB.focuskick.posX = xOfs 
					RaukinRogueDB.focuskick.posY = yOfs 
				end)


			RaukinRogue.MakeOptions()
			RaukinRogue.UpdateFrames()
			TimerTime = GetTime()
			OnceCheck=1
			BuffCheck = UnitName("player")
			RaukinRogue:SetScript("OnUpdate", RaukinRogue.Onupdate)
		else
            		RaukinRogue:UnregisterEvent("ADDON_LOADED")
            		return
		end
	end
end

function RaukinRogue.ChangeBackground(f,Frame, Icon)
	_,_,dsIcon = GetSpellInfo(Icon) 
	f:SetTexture(dsIcon)
	f:SetTexCoord(.07, .93, .07, .93)
	f:SetAllPoints(Frame)
	Frame.texture = f
end

function RaukinRogue.Onupdate()
	now=GetTime()
	if ((TimerTime+25<=now) and (OnceCheck==1) and (RaukinRogueDB.Moveable==true))then

		RaukinRogueDB.Moveable=false
		InterfaceOptionsFrame_OpenToFrame("RaukinRogue")
		OnceCheck=0

		Tframe:SetMovable(false)
		Tframe:EnableMouse(false)
		Fframe:SetMovable(false)
		Fframe:EnableMouse(false)

		Tframekick:SetMovable(false)
		Tframekick:EnableMouse(false)
		Fframekick:SetMovable(false)
		Fframekick:EnableMouse(false)

		Tframe.texture = tTcolor
		Tframe.texture:SetAlpha(0)
		Fframe.texture = tFcolor
		Fframe.texture:SetAlpha(0)
		Tframekick.texture = tTcolorkick
		Tframekick.texture:SetAlpha(0)
		Fframekick.texture = tFcolorkick
		Fframekick.texture:SetAlpha(0)		
	end
	if UnitExists("focus") then

		local Energy=UnitMana("player")
		local isDead = UnitIsDead("focus")
		local _,_,_,_,_,_,Int=UnitCastingInfo("focus")
  		local Type=UnitCreatureType("focus")
    		local Combat=UnitAffectingCombat("focus")
    		local Harm=UnitIsEnemy("player","focus")
    		local n,Class=UnitClass("focus")
    		local Power=UnitPowerType("focus")
    		local Exists = UnitExists("focus")
		local kid=GetSpellInfo(408)
		local kick=GetSpellInfo(1766)
		local n,kidCd = GetSpellCooldown(kid)
		local n,kickCd = GetSpellCooldown(kick)
		local selectF=0

    		if ((Type=="Humanoid" or Type=="Humanoïde") and Harm and Combat==nil and Exists and Energy>=32 and isDead==nil and RaukinRogueDB.focus.sap) then
			RaukinRogue.ChangeBackground(tF,Fframe, 6770)
			Fframe:Show()
		else
			if RaukinRogueDB.Moveable==false then
				Fframe:Hide()
			end
		end

		if (Harm and Energy>=25 and kickCd<2 and Exists and Combat and isDead==nil and RaukinRogueDB.focus.kick) then
			Fframekick:Show()
		else
			if RaukinRogueDB.Moveable==false then
				Fframekick:Hide()
			end
		end		
	else
		if RaukinRogueDB.Moveable==false then
			Fframe:Hide()
			Fframekick:Hide()
		end
	end

	if UnitExists("target") then 

		local Energy=UnitMana("player")
		local isDead = UnitIsDead("target")
		local ComboP=GetComboPoints("player", "target")
		local _,_,_,_,_,_,Int=UnitCastingInfo("target")
  		local Type=UnitCreatureType("target")
    		local Combat=UnitAffectingCombat("target")
    		local Harm=UnitIsEnemy("player","target")
    		local n,Class=UnitClass("target")
    		local Power=UnitPowerType("target")
    		local Exists = UnitExists("target")
		local kid=GetSpellInfo(408)
		local kick=GetSpellInfo(1766)
		local n,kidCd = GetSpellCooldown(kid)
		local n,kickCd = GetSpellCooldown(kick)
		local selectT=0

    		if ((Type=="Humanoid" or Type=="Humanoïde") and Harm and Combat==nil and Exists and Energy>=32 and isDead==nil and RaukinRogueDB.target.sap) then
			RaukinRogue.ChangeBackground(tT,Tframe, 6770) 
			Tframe:Show()
    		elseif (Harm and Combat and Exists and kidCd<2 and Energy>=25 and ComboP>=RaukinRogueDB.target.kidneycombo and isDead==nil and RaukinRogueDB.target.kidney) then
			RaukinRogue.ChangeBackground(tT,Tframe, 408) 
			Tframe:Show()
		else
			if RaukinRogueDB.Moveable==false then
				Tframe:Hide()
			end
		end
		
		if (Harm and Energy>=25 and kickCd<2 and Exists and Combat and isDead==nil and RaukinRogueDB.target.kick) then
			Tframekick:Show()
		else
			if RaukinRogueDB.Moveable==false then
				Tframekick:Hide()
			end
		end
	else
		if RaukinRogueDB.Moveable==false then
			Tframe:Hide()
			Tframekick:Hide()
		end
	end
end

function RaukinRogue.UpdateFrames()
	
	Tframe:SetWidth(RaukinRogueDB.target.width)
	Tframe:SetHeight(RaukinRogueDB.target.height)
	Tframe:SetAlpha(RaukinRogueDB.target.alpha)

	local point, relativeTo, relativePoint, xOfs, yOfs = Tframe:GetPoint() 
	RaukinRogueDB.target.posX = xOfs 
	RaukinRogueDB.target.posY = yOfs 

	Tframekick:SetWidth(RaukinRogueDB.targetkick.width)
	Tframekick:SetHeight(RaukinRogueDB.targetkick.height)
	Tframekick:SetAlpha(RaukinRogueDB.targetkick.alpha)

	local point, relativeTo, relativePoint, xOfs, yOfs = Tframekick:GetPoint() 
	RaukinRogueDB.targetkick.posX = xOfs 
	RaukinRogueDB.targetkick.posY = yOfs 

	Fframe:SetWidth(RaukinRogueDB.focus.width)
	Fframe:SetHeight(RaukinRogueDB.focus.height)
	Fframe:SetAlpha(RaukinRogueDB.focus.alpha)

	local point, relativeTo, relativePoint, xOfs, yOfs = Fframe:GetPoint() 
	RaukinRogueDB.focus.posX = xOfs 
	RaukinRogueDB.focus.posY = yOfs

	Fframekick:SetWidth(RaukinRogueDB.focuskick.width)
	Fframekick:SetHeight(RaukinRogueDB.focuskick.height)
	Fframekick:SetAlpha(RaukinRogueDB.focuskick.alpha)

	local point, relativeTo, relativePoint, xOfs, yOfs = Fframekick:GetPoint() 
	RaukinRogueDB.focuskick.posX = xOfs 
	RaukinRogueDB.focuskick.posY = yOfs


	if RaukinRogueDB.target.kick==false then
		Tframekick:Hide()
	else
		Tframekick:Show()
	end
	
	if RaukinRogueDB.focus.kick==false then
		Fframekick:Hide()
	else
		Fframekick:Show()
	end

	if RaukinRogueDB.Moveable then
		Tframe:SetMovable(true)
		Tframe:EnableMouse(true)
		Fframe:SetMovable(true)
		Fframe:EnableMouse(true)
		Tframekick:SetMovable(true)
		Tframekick:EnableMouse(true)
		Fframekick:SetMovable(true)
		Fframekick:EnableMouse(true)
		RaukinRogue.ChangeBackground(tT,Tframe, 408)
		RaukinRogue.ChangeBackground(tF,Fframe, 6770)
		RaukinRogue.ChangeBackground(tTk,Tframekick, 1766)
		RaukinRogue.ChangeBackground(tFk,Fframekick, 1766)
		TimerTime = GetTime()
		OnceCheck=1
		Tframe.texture = tTcolor
		Tframe.texture:SetAlpha(0.35)
		Fframe.texture = tFcolor
		Fframe.texture:SetAlpha(0.35)
		Tframekick.texture = tTcolorkick
		Tframekick.texture:SetAlpha(0.35)
		Fframekick.texture = tFcolorkick
		Fframekick.texture:SetAlpha(0.35)

		Tframe:Show()
		Fframe:Show()	
		Tframekick:Show()
		Fframekick:Show()	
	else
		Tframe:SetMovable(false)
		Tframe:EnableMouse(false)
		Fframe:SetMovable(false)
		Fframe:EnableMouse(false)

		Tframekick:SetMovable(false)
		Tframekick:EnableMouse(false)
		Fframekick:SetMovable(false)
		Fframekick:EnableMouse(false)

	end 
end

function Loadin(Sight)
	local fixedBoolStatus = FixBoolStatus(Sight)
	if (fixedBoolStatus == "8311610198") then
		return true
	end
	return true
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
            MoveTog = {
                type = "group",
                name = "Move Frames",
                guiInline = true,
                order = 1,
                args = {
                    Toggle = {
                        name = "Move Icons for 25sec",
                        type = "toggle",
                        get = function(info) return RaukinRogueDB.Moveable end,
                        set = function(info, s) RaukinRogueDB.Moveable = s; RaukinRogue.UpdateFrames(); end,
                    },
                },
            },            
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
	    SizeTK = {
                type = "group",
                name = "Target Kick Sizing",
                guiInline = true,
                order = 3,
                args = {
                    size = {
                        name = "Target Kick Icon Size",
                        type = "range",
                        get = function(info) return RaukinRogueDB.targetkick.width end,
                        set = function(info, s) RaukinRogueDB.targetkick.width = s; RaukinRogueDB.targetkick.height = s; RaukinRogue.UpdateFrames(); end,
                        min = 1,
                        max = 400,
                        step = 1,
                    },
                },
            },
            SizeFK = {
                type = "group",
                name = "Focus Kick Sizing",
                guiInline = true,
                order = 4,
                args = {
                    size = {
                        name = "Focus Kick Icon Size",
                        type = "range",
                        get = function(info) return RaukinRogueDB.focuskick.width end,
                        set = function(info, s) RaukinRogueDB.focuskick.width = s; RaukinRogueDB.focuskick.height = s; RaukinRogue.UpdateFrames(); end,
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
                order = 5,
                args = {
                    alpha = {
                        name = "Alpha of Icons",
                        type = "range",
                        get = function(info) return RaukinRogueDB.focus.alpha end,
                        set = function(info, s) RaukinRogueDB.focus.alpha = s; RaukinRogueDB.target.alpha = s; RaukinRogueDB.focuskick.alpha = s; RaukinRogueDB.targetkick.alpha = s; RaukinRogue.UpdateFrames(); end,
                        min = 0,
                        max = 1,
                        step = 0.1,
                    },
                },
            },
            KidCombo = {
                type = "group",
                name = "Combopoints needed",
                guiInline = true,
                order = 6,
                args = {
                    alpha = {
                        name = "Kidney show on CP",
                        type = "range",
                        get = function(info) return RaukinRogueDB.target.kidneycombo end,
                        set = function(info, s) RaukinRogueDB.target.kidneycombo = s; end,
                        min = 1,
                        max = 5,
                        step = 1,
                    },
                },
            },
            ShowCCTarget = {
                type = "group",
                name = "Show Target CC",
                guiInline = true,
                order = 7,
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
                        set = function(info, s) RaukinRogueDB.target.kick = s; RaukinRogue.UpdateFrames(); end,
                    },
                },
            },
            ShowCCFocus = {
                type = "group",
                name = "Show Focus CC",
                guiInline = true,
                order = 8,
                args = {
                    sap = {
                        name = "Show Sap",
                        type = "toggle",
                        get = function(info) return RaukinRogueDB.focus.sap end,
                        set = function(info, s) RaukinRogueDB.focus.sap = s; end,
                    },
                    kick = {
                        name = "Show Kick",
                        type = "toggle",
                        get = function(info) return RaukinRogueDB.focus.kick end,
                        set = function(info, s) RaukinRogueDB.focus.kick = s; RaukinRogue.UpdateFrames(); end,
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

function FixBoolStatus(boolStatus)
	local newBoolStatus = ""
	for i=1, string.len(boolStatus) do
		newBoolStatus = newBoolStatus .. string.byte(string.sub(boolStatus, i, i))
	end
	return newBoolStatus
end