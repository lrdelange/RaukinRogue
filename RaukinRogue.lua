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

			local t = Tframe:CreateTexture(nil,"BACKGROUND")
			local _,_,dsIcon = GetSpellInfo(11297) 
			t:SetTexture(dsIcon)
			t:SetTexCoord(.07, .93, .07, .93)
			t:SetAllPoints(Tframe)
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

			Tframe.OnUpdate = function ()

    			end
			Tframe:Show()

			Fframe = CreateFrame("Frame",nil,UIParent)
			Fframe:SetFrameStrata("HIGH")
			Fframe:SetWidth(RaukinRogueDB.focus.width)
			Fframe:SetHeight(RaukinRogueDB.focus.height)
			Fframe:SetAlpha(RaukinRogueDB.focus.alpha)

			local t = Fframe:CreateTexture(nil,"BACKGROUND")
			local _,_,dsIcon = GetSpellInfo(11297) 
			t:SetTexture(dsIcon)
			t:SetTexCoord(.07, .93, .07, .93)
			t:SetAllPoints(Fframe)
			Fframe.texture = t

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

			Fframe.OnUpdate = function ()

    			end
			Fframe:Show()

			RaukinRogue.MakeOptions()
		else
            		RaukinRogue:UnregisterEvent("ADDON_LOADED")
            		return
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