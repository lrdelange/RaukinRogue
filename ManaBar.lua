ManaBar = CreateFrame("Frame","ManaBar")

ManaBar:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

media = LibStub("LibSharedMedia-3.0")

ManaBar:RegisterEvent("ADDON_LOADED")

function ManaBar.ADDON_LOADED(self,event,arg1)
    if arg1 == "ManaBar" then
        ManaBarDB = ManaBarDB or {}
        ManaBarDB.posX = ManaBarDB.posX or 0
        ManaBarDB.posY = ManaBarDB.posY or 0
        ManaBarDB.align = ManaBarDB.align or "CENTER"
        ManaBarDB.visibility = ManaBarDB.visibility or "Combat"
        ManaBarDB.font = ManaBarDB.font or "Arial Narrow"
        ManaBarDB.fontSize = ManaBarDB.fontSize or 20
        ManaBarDB.TextColor = ManaBarDB.TextColor or {0.98,1,1}
        
        ManaBarDB.ticker = ManaBarDB.ticker or {}
        ManaBarDB.ticker.color = ManaBarDB.ticker.color or {0.12,0.56,1}
	ManaBarDB.ticker.colorfivesec = ManaBarDB.ticker.colorfivesec or {0.19,0.8,0.19}
        ManaBarDB.ticker.alphaBG = ManaBarDB.ticker.alphaBG or 0.5
        ManaBarDB.ticker.offsetX = ManaBarDB.ticker.offsetX or 0
        ManaBarDB.ticker.offsetY = ManaBarDB.ticker.offsetY or 0
        ManaBarDB.ticker.width = ManaBarDB.ticker.width or 160
        ManaBarDB.ticker.height = ManaBarDB.ticker.height or 18
        ManaBarDB.ticker.texture = ManaBarDB.ticker.texture or "Aluminium"
    
        ManaBar.hasmana = UnitPowerType("player");
        if ManaBar.hasmana == 0 then
            ManaBar.color = ManaBarDB.TextColor
            ManaBar.frame, ManaBar.text = ManaBar.CreateFrame(60,50,"ManaBarFrame")
            ManaBar.ticker = ManaBar.CreateTickerFrame("ManaBarTicker")
            ManaBar:RegisterEvent("UNIT_MANA")
        else
            ManaBar:UnregisterEvent("ADDON_LOADED")
            return
        end
        
        ManaBar.UpdateBehavior(ManaBarDB.visibility)
        
        ManaBar:RegisterEvent("PLAYER_ENTERING_WORLD")
        ManaBar.PLAYER_ENTERING_WORLD = ManaBar.UNIT_MANA
        ManaBar.MakeOptions()
    end
end

function ManaBar.UNIT_MANA(self)
	ManaBar.text:SetText("Full Mana")
end

function ManaBar.UpdateBehavior(state)
    if state == "Combat" then
        ManaBar:RegisterEvent("PLAYER_REGEN_ENABLED")
        ManaBar:RegisterEvent("PLAYER_REGEN_DISABLED")
    elseif state == "Always" then
        ManaBar:UnregisterEvent("PLAYER_REGEN_ENABLED")
        ManaBar:UnregisterEvent("PLAYER_REGEN_DISABLED")
        ManaBar.frame:Show()
        ManaBarTicker:Show()
    end
        
end

function ManaBar.UpdateHide(state)
    if state == "Combat" and ManaBar.combat then
        ManaBar.frame:Show()
        ManaBarTicker:Show()
        return true
    elseif state == "Always" then
        ManaBar.frame:Show()
        ManaBarTicker:Show()
        return true
    else
        ManaBar.frame:Hide()
        ManaBarTicker:Hide()
    end
    return nil
end

function ManaBar.PLAYER_REGEN_ENABLED()
    ManaBar.combat = false
    ManaBar.UpdateHide(ManaBarDB.visibility)
end

function ManaBar.PLAYER_REGEN_DISABLED()
    ManaBar.combat = true
    ManaBar.UpdateHide(ManaBarDB.visibility)
end

function ManaBar.COMBAT_LOG_EVENT_UNFILTERED(self, event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName, spellSchool, auraType)

end

function ManaBar.MakeOptions(self)

    local alignValues = {
        ["LEFT"]        = "Left",
        ["CENTER"]      = "Center",
        ["RIGHT"]       = "Right",
    }
    local visibilityValues = {
        ["Combat"]     = "Combat",
        ["Always"]     = "Always",
    }
    
    local fonts,bars = {},{}
    for i,v in pairs(media:List('font')) do
        fonts[v] = v
    end
    for i,v in pairs(media:List('statusbar')) do
        bars[v] = v
    end
    media.RegisterCallback(ManaBar, "LibSharedMedia_Registered",
        function(event, mediatype, key)
            if mediatype == 'font' then
                fonts[key] = key
                if key == ManaBarDB.font then
                    ManaBar.text:SetFont(media:Fetch('font',ManaBarDB.font),ManaBarDB.fontSize)
                end
            elseif mediatype == 'statusbar' then
                bars[key] = key
                if key == ManaBarDB.ticker.texture then
                    if ManaBarTickerBar then ManaBarTickerBar:SetTexture(media:Fetch('statusbar',ManaBarDB.ticker.texture)) end
                end
            end
        end)

    local opt = {
		type = 'group',
        name = "ManaBar",
        args = {},
	}
    opt.args.general = {
        type = "group",
        name = "General",
        order = 1,
        args = {
            showPositon = {
                type = "group",
                name = "Frame Position",
                guiInline = true,
                order = 1,
                args = {
                    posX = {
                        name = "Pos X",
                        type = "range",
                        desc = "Horizontal position, relative to center",
                        get = function(info) return ManaBarDB.posX end,
                        set = function(info, s) ManaBarDB.posX = s; ManaBar.frame:SetPoint("CENTER",UIParent,"CENTER",ManaBarDB.posX,ManaBarDB.posY); end,
                        min = -900,
                        max = 900,
                        step = 5,
                    },
                    posY = {
                        name = "Pos Y",
                        type = "range",
                        desc = "Vertical position, relative to center",
                        get = function(info) return ManaBarDB.posY end,
                        set = function(info, s) ManaBarDB.posY = s; ManaBar.frame:SetPoint("CENTER",UIParent,"CENTER",ManaBarDB.posX,ManaBarDB.posY); end,
                        min = -700,
                        max = 700,
                        step = 5,
                    },
                },
            },
            showScale = {
                type = "group",
                name = "Scale & Font",
                guiInline = true,
                order = 2,
                args = {
                    align = {
                        type = "select",
                        name = "Align",
                        desc = "Align of text",
                        values = alignValues,
                        get = function(info)
                            return ManaBarDB.align
                        end,
                        set = function(info, s)
                            ManaBarDB.align = s
                            ManaBar.text:SetJustifyH(ManaBarDB.align)
                        end,
                    },
                    font = {
                        type = "select",
                        name = "Font",
                        desc = "Choose font",
                        values = fonts,
                        order = 1,
                        get = function(info)
                            return ManaBarDB.font
                        end,
                        set = function(info, s)
                            ManaBarDB.font = s
                            ManaBar.text:SetFont(media:Fetch('font',ManaBarDB.font),ManaBarDB.fontSize)
                        end,
                    },
                    fontSize = {
                        name = "Font Size",
                        type = "range",
                        order = 2,
                        get = function(info) return ManaBarDB.fontSize end,
                        set = function(info, s)
                            ManaBarDB.fontSize = s;
                            ManaBar.text:SetFont(media:Fetch('font',ManaBarDB.font),ManaBarDB.fontSize)
                        end,
                        min = 5,
                        max = 35,
                        step = 1,
                    },
                    visibility = {
                        type = "select",
                        name = "Visible when...",
                        desc = "",
                        values = visibilityValues,
                        get = function(info)
                            return ManaBarDB.visibility
                        end,
                        set = function(info, s)
                            ManaBarDB.visibility = s
                            ManaBar.UpdateBehavior(ManaBarDB.visibility)
                        end,
                    },
                }
            },
            showColors = {
                type = "group",
                name = "Colors",
                guiInline = true,
                order = 3,
                args = {
                    manaColor = {
                        name = "Text Color",
                        type = 'color',
                        desc = "mana color",
                        order = 1,
                        get = function(info)
                            local r,g,b = unpack(ManaBarDB.TextColor)
                            return r,g,b
                        end,
                        set = function(info, r, g, b)
                            ManaBarDB.TextColor = { r, g, b }
                        end,
                    },
                    tickerColor = {
                        name = "Ticker Color",
                        type = 'color',
                        desc = "TickBar color",
                        order = 2,
                        get = function(info)
                            local r,g,b = unpack(ManaBarDB.ticker.color)
                            return r,g,b
                        end,
                        set = function(info, r, g, b)
                            ManaBarDB.ticker.color = { r, g, b }
                        end,
                    },
                    tickerColorfivesec = {
                        name = "Ticker Color 5sec",
                        type = 'color',
                        desc = "TickBar color 5sec",
                        order = 3,
                        get = function(info)
                            local r,g,b = unpack(ManaBarDB.ticker.colorfivesec)
                            return r,g,b
                        end,
                        set = function(info, r, g, b)
                            ManaBarDB.ticker.colorfivesec = { r, g, b }
                        end,
                    },
                    tickeralphaBG = {
                        name = "Ticker BG alpha",
                        type = "range",
                        desc = "...",
                        order = 4,
                        get = function(info) return ManaBarDB.ticker.alphaBG end,
                        set = function(info, s) ManaBarDB.ticker.alphaBG = s; ManaBarTickerBackground:SetTexture(0,0,0,ManaBarDB.ticker.alphaBG) end,
                        min = 0,
                        max = 1,
                        step = 0.1,
                    },
                },
            },
            tickerOpts = {
                type = "group",
                name = "Ticker",
                guiInline = true,
                order = 4,
                args = {
                    offsetX = {
                        name = "Offset X",
                        type = "range",
                        desc = "Horizontal offset, relative to main frame",
                        order = 1,
                        get = function(info) return ManaBarDB.ticker.offsetX end,
                        set = function(info, s) ManaBarDB.ticker.offsetX = s; ManaBarTicker:SetPoint("CENTER",ManaBar.frame,"CENTER",ManaBarDB.ticker.offsetX,ManaBarDB.ticker.offsetY); end,
                        min = -900,
                        max = 900,
                        step = 5,
                    },
                    offsetY = {
                        name = "Offset Y",
                        type = "range",
                        desc = "Vertical offset, relative to main frame",
                        order = 2,
                        get = function(info) return ManaBarDB.ticker.offsetY end,
                        set = function(info, s) ManaBarDB.ticker.offsetY = s; ManaBarTicker:SetPoint("CENTER",ManaBar.frame,"CENTER",ManaBarDB.ticker.offsetX,ManaBarDB.ticker.offsetY); end,
                        min = -700,
                        max = 700,
                        step = 5,
                    },
                    width = {
                        name = "Width",
                        type = "range",
                        desc = "ppc",
                        order = 3,
                        get = function(info) return ManaBarDB.ticker.width end,
                        set = function(info, s) ManaBarDB.ticker.width = s; ManaBarTicker:SetWidth(ManaBarDB.ticker.width) end,
                        min = 20,
                        max = 200,
                        step = 2,
                    },
                    height = {
                        name = "Height",
                        type = "range",
                        desc = "eh",
                        order = 4,
                        get = function(info) return ManaBarDB.ticker.height end,
                        set = function(info, s) ManaBarDB.ticker.height = s; ManaBarTicker:SetHeight(ManaBarDB.ticker.height) end,
                        min = 2,
                        max = 100,
                        step = 2,
                    },
                    texure = {
                        type = "select",
                        name = "Texture",
                        desc = "Choose ticker texture",
                        values = bars,
                        order = 5,
                        get = function(info)
                            return ManaBarDB.ticker.texture
                        end,
                        set = function(info, s)
                            ManaBarDB.ticker.texture = s
                            ManaBarTickerBar:SetTexture(media:Fetch('statusbar',ManaBarDB.ticker.texture))
                        end,
                    },
                },
            },
        },
    }
    
    local Config = LibStub("AceConfigRegistry-3.0")
    local Dialog = LibStub("AceConfigDialog-3.0")
    
    Config:RegisterOptionsTable("ManaBar-Bliz", {name = "ManaBar",type = 'group',args = {} })
    Dialog:SetDefaultSize("ManaBar-Bliz", 600, 400)
    
    Config:RegisterOptionsTable("ManaBar-General", opt.args.general)
    Dialog:AddToBlizOptions("ManaBar-General", "ManaBar")
    

    SLASH_MBSLASH1 = "/mb";
    SLASH_MBSLASH2 = "/ManaBar";
    SlashCmdList["MBSLASH"] = function() InterfaceOptionsFrame_OpenToFrame("ManaBar") end;
end

function ManaBar.CreateFrame(width,height,frameName)
    local f = CreateFrame("Frame",frameName,UIParent);
    f:SetFrameStrata("MEDIUM")
    f:SetWidth(width)
    f:SetHeight(height)

    f:SetPoint("CENTER",UIParent,"CENTER",ManaBarDB.posX,ManaBarDB.posY)

    text = f:CreateFontString(nil, "OVERLAY");
    text:SetFont(media:Fetch('font',ManaBarDB.font),ManaBarDB.fontSize)
    text:ClearAllPoints()
    text:SetWidth(width*4)
    text:SetHeight(height*2)
    text:SetPoint("CENTER", f, "CENTER",0,0)
    text:SetJustifyH(ManaBarDB.align)
    text:SetVertexColor(unpack(ManaBar.color))
    
    f:Hide()
    return f, text
end


function ManaBar.CreateTickerFrame(frameName)
    local f = CreateFrame("Frame",frameName,UIParent)
    f:SetFrameStrata("MEDIUM")
    f:SetWidth(ManaBarDB.ticker.width)
    f:SetHeight(ManaBarDB.ticker.height)
    
    f:SetPoint("CENTER",ManaBar.frame,"CENTER",ManaBarDB.ticker.offsetX,ManaBarDB.ticker.offsetY)
    
    local bg = f:CreateTexture(frameName.."Background","BACKGROUND")
    bg:SetWidth(ManaBarDB.ticker.width)
    bg:SetHeight(ManaBarDB.ticker.height)
    bg:SetTexture(0,0,0,ManaBarDB.ticker.alphaBG)
    bg:SetAllPoints(f)
    
    local b = f:CreateTexture(frameName.."Bar","ARTWORK")
    b:SetWidth(ManaBarDB.ticker.width)
    b:SetHeight(ManaBarDB.ticker.height)
    b:SetTexture(media:Fetch('statusbar',ManaBarDB.ticker.texture))

    b:SetPoint("TOPLEFT",f,"TOPLEFT",0,0)
    b:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,0)
    b:SetVertexColor(unpack(ManaBarDB.ticker.color))

    ManaBar.LastMana = UnitMana("player")
    ManaBar.lastTime = GetTime()
    ManaBar.fivesec = false
    ManaBar.fivesectime = GetTime()

    ManaBar.OnUpdate = function ()
	ManaBar.UpdateHide(ManaBarDB.visibility)
	ManaBar.HasMana = UnitPowerType("player");
        ManaBar.CurrentMana = UnitMana("player")
	ManaBar.MaxMana = UnitManaMax("player")
	ManaBar.base, ManaBar.casting = GetManaRegen("player")
	local now = GetTime()
	if ManaBar.HasMana==0 then
		if ManaBar.CurrentMana < ManaBar.LastMana then
			ManaBar.LastMana = ManaBar.CurrentMana
			ManaBar.fivesec = true
			ManaBar.fivesectime = now + 5
		end

		if ManaBar.CurrentMana > ManaBar.LastMana then
			ManaBar.LastMana = ManaBar.CurrentMana
			ManaBar.lastTime = now
		end

		if now > ManaBar.fivesectime then
			ManaBar.fivesec = false
		end
	
        	if (now > ManaBar.lastTime + 2) and (ManaBar.fivesec==false) then
           		ManaBar.lastTime = now
        	end

		if ManaBar.CurrentMana==ManaBar.MaxMana then
			ManaBarTickerBar:SetWidth(ManaBarDB.ticker.width)
			ManaBar.text:SetText("Full Mana")
		elseif (now <= ManaBar.fivesectime) and (ManaBar.fivesec==true) then
			ManaBar.text:SetText("5 Seconds")
			b:SetVertexColor(unpack(ManaBarDB.ticker.colorfivesec))
			ManaBarTickerBar:SetWidth((ManaBar.fivesectime - GetTime()) * ManaBarDB.ticker.width / 5)
		else
			local msg=tostring(floor(ManaBar.base*2))
			ManaBar.text:SetText(msg .. " Mana Regen")
        		b:SetVertexColor(unpack(ManaBarDB.ticker.color))
			ManaBarTickerBar:SetWidth((GetTime() - ManaBar.lastTime) * ManaBarDB.ticker.width / 2)
    		end
	else
		ManaBar.frame:Hide()
        	if ManaBarTicker then ManaBarTicker:Hide() end
	end
    end
    
    f:SetScript("OnUpdate",ManaBar.OnUpdate)
    
    f:Hide()
    return f
end