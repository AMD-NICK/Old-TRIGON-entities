-- __  ____  ___   _____ __            ___
-- \ \/ /  |/  /  / ___// /___  ______/ (_)___
--  \  / /|_/ /   \__ \/ __/ / / / __  / / __ \
--  / / /  / /   ___/ / /_/ /_/ / /_/ / / /_/ /
-- /_/_/  /_/   /____/\__/\__,_/\__,_/_/\____/

file.CreateDir("ys_scripts/fusion_motd/")

local vgui = vgui
local draw = draw
local surface = surface
local net = net

-- localizing last selected button. Must be out the function for memorize on reopening
local sel_btn = tonumber( file.Read("ys_scripts/fusion_motd/lastbutton.txt","DATA") or 1 )
if !MOTD.Cfg.Buttons[sel_btn] then sel_btn = 1 end -- if button was removed
local size = MOTD.Cfg.frameSize

local main
function MOTD.Open()
	if !IsValid(main) then
		main = nil
	end

	local html -- localizing derma html panel for open in future from any part of code

	/********************************************************
		[MAIN] Frame
	********************************************************/
	main = main or vgui.Create("DFrame")
	main:Dock(FILL)
	main:InvalidateLayout(true)
	main:MakePopup()
	main:SetZPos(100000)

	main:ShowCloseButton(false)
	main:SetDraggable(false)
	main:SetTitle("")
	main:MakePopup()
	main.Init = function(self) self.blurTime = SysTime() end
	main.Paint = function( self, w, h ) Derma_DrawBackgroundBlur( self, self.blurTime) end


	/********************************************************
		[SIDEBAR] Main panel
	********************************************************/
	local bpanel = vgui.Create("DPanel", main)
	bpanel:SetSize(200,ScrH())
	bpanel:SetPos(-200,0)
	bpanel:MoveTo(0,0, MOTD.Cfg.aspeed)
	bpanel.Paint = function(self,w,h)
		MOTD.Skin.SideBarPanel(self, w, h)
		MOTD.Skin.SideBarHeader(self, w, h, "-=TRIGON.IM=-")
	end


	/********************************************************
		[SIDEBAR] Main panel right line
	********************************************************/
	local bpanelline = vgui.Create("DPanel", main)
	bpanelline:SetSize(3,ScrH())
	bpanelline:SetPos(bpanel:GetWide(),ScrH())
	bpanelline:MoveTo(bpanel:GetWide(), 0, MOTD.Cfg.aspeed) --Заставил выезжать снизу. (Слева не прокатывало из за наложений.)
	bpanelline.Paint = function(self,w,h) MOTD.Skin.SideBarPanelLine(self, w, h) end


	/********************************************************
		[SIDEBAR] Buttons scroll panel
	********************************************************/
	local bspanel = vgui.Create("DScrollPanel", main)
	bspanel:SetSize(bpanel:GetWide(),ScrH() - 150)
	bspanel:SetPos(-bpanel:GetWide(),75)
	bspanel:MoveTo(0,75, MOTD.Cfg.aspeed)
	bspanel.Paint = function(self,w,h) MOTD.Skin.SideBarScrollPanel(self, w, h) end

	bspanel.VBar.Paint = function(pnl,w,h) MOTD.Skin.VerBarBack(w,h) end
	bspanel.VBar.btnUp.Paint = function(pnl,w,h) MOTD.Skin.VerBarUpBtn(w,h) end
	bspanel.VBar.btnDown.Paint = function(pnl,w,h) MOTD.Skin.VerBarDwnBtn(w,h) end
	bspanel.VBar.btnGrip.Paint = function(pnl,w,h) MOTD.Skin.VerBarBogie(w,h) end


	/********************************************************
		[SIDEBAR] Buttons layout
	********************************************************/
	local blay = vgui.Create( "DListLayout", bspanel )
	blay:SetSize( bspanel:GetWide(), bspanel:GetTall() )
	blay:SetPos( 0, 0 )



	/********************************************************
		[SIDEBAR] Adding buttons
	********************************************************/
	for i = 1, #MOTD.Cfg.Buttons do
		local cur = MOTD.Cfg.Buttons[i]

		local butt = vgui.Create("DButton",blay)
		butt:SetSize(blay:GetWide(),70)
		butt:SetText("")
		butt.active = false
		if i == sel_btn then butt.active = true end -- select first or last button as active
		butt.Paint = function(self,w,h)
			MOTD.Skin.ButtonsSidebar(self, w, h, cur.NAME, cur.ICO, self.active)
		end
		butt.DoClick = function(self,w,h)
			if !self.active then
				sel_btn = i
				for _, cfgbutton in pairs(MOTD.Cfg.Buttons) do
					cfgbutton.button.active = false -- lol
				end

				self.active = true
				local url = MOTD.Cfg.Buttons[i].URL
				if url then
					html:OpenURL(url)
				end

				if cur.CLFUNC then
					surface.PlaySound("garrysmod/ui_hover.wav")
					cur.CLFUNC(cur)
				elseif cur.SVFUNC then
					surface.PlaySound("garrysmod/ui_hover.wav")
					net.Start("MOTD.ButtonFunc")
						net.WriteInt(i,4)
					net.SendToServer()
				end

				file.Write("ys_scripts/fusion_motd/lastbutton.txt",i)
			end
		end
		cur.button = butt -- присваеваем элементу таблицы из конфига дерма кнопку
		blay:Add(butt)
	end


	/********************************************************
		[HEMIFRAME] Main part of Polyframe
		https://pp.vk.me/c623422/v623422381/40683/36ahOsKIasQ.jpg
	********************************************************/
	local pFrame = vgui.Create("DPanel",main)
	pFrame:SetSize(ScrW() - bpanel:GetWide() - 30,ScrH())
	pFrame:SetPos(bpanel:GetWide() + 30 + (ScrW() - bpanel:GetWide() - 30), 0)
	pFrame:MoveTo(bpanel:GetWide() + 30, 0, MOTD.Cfg.aspeed)
	pFrame.Paint = function(self,w,h)

		local frameOut = {}
		frameOut[1] = {} -- above
		frameOut[1][1] = { x = w, y = 0 }
		frameOut[1][2] = { x = w, y = MOTD.Cfg.frameSize + 5 }
		frameOut[1][3] = { x = size - 5, y = size + 5 }
		frameOut[1][4] = { x = 0, y = 0 }

		frameOut[2] = {} -- middle
		frameOut[2][1] = { x = w, y = h - size }
		frameOut[2][2] = { x = w - size - 5, y = h - size }
		frameOut[2][3] = { x = w - size - 5, y = size }
		frameOut[2][4] = { x = w, y = size }

		frameOut[3] = {} -- below
		frameOut[3][1] = { x = w, y = h - size - 5 }
		frameOut[3][2] = { x = w, y = h }
		frameOut[3][3] = { x = 0, y = h }
		frameOut[3][4] = { x = size - 5, y = h - size - 5 }

		MOTD.Skin.PolyFrameOutline(self, w, h)
		draw.NoTexture()
		for k,v in ipairs(frameOut) do
			surface.DrawPoly( v )
		end

		local frame = {}
		frame[1] = {} -- above
		frame[1][1] = { x = w, y = 0 }
		frame[1][2] = { x = w, y = size }
		frame[1][3] = { x = size, y = size }
		frame[1][4] = { x = 0, y = 0 }

		frame[2] = {} -- middle
		frame[2][1] = { x = w, y = h - size }
		frame[2][2] = { x = w - size, y = h - size }
		frame[2][3] = { x = w - size, y = size }
		frame[2][4] = { x = w, y = size }

		frame[3] = {} -- below
		frame[3][1] = { x = w, y = h - size }
		frame[3][2] = { x = w, y = h }
		frame[3][3] = { x = 0, y = h }
		frame[3][4] = { x = size, y = h - size }

		MOTD.Skin.PolyFrame(self, w, h)
		draw.NoTexture()
		for k,v in ipairs(frame) do
			surface.DrawPoly( v )
		end

		local placeW 	= pFrame:GetWide() - size * 2
		local sectorW 	= placeW / 2 / 3

		-- Outline
		MOTD.Skin.PolyFrameOutline(self, w, h)
		surface.DrawRect( size + sectorW / 2 - 5						, size, sectorW + 5 * 2, 10) -- first on top
		surface.DrawRect( size + placeW / 2 - sectorW / 2 - 5			, size, sectorW + 5 * 2, 10) -- second above
		surface.DrawRect( size + placeW - sectorW / 2 - sectorW - 5	, size, sectorW + 5 * 2, 10) -- third above
		surface.DrawRect( size + sectorW / 2 - 5						, h - size - 10, sectorW + 5 * 2, 10) -- first of bottom
		surface.DrawRect( size + placeW / 2 - sectorW / 2 - 5			, h - size - 10, sectorW + 5 * 2, 10) -- second of bottom
		surface.DrawRect( size + placeW - sectorW / 2 - sectorW - 5	, h - size - 10, sectorW + 5 * 2, 10) -- third of bottom

		-- Main
		MOTD.Skin.PolyFrame(self, w, h)
		surface.DrawRect( size + sectorW / 2						, size, sectorW, 10) -- first on top
		surface.DrawRect( size + placeW / 2 - sectorW / 2			, size, sectorW, 10) -- second above
		surface.DrawRect( size + placeW - sectorW / 2 - sectorW	, size, sectorW, 10) -- third above
		surface.DrawRect( size + sectorW / 2						, h - size - 10, sectorW, 10) -- first of bottom
		surface.DrawRect( size + placeW / 2 - sectorW / 2			, h - size - 10, sectorW, 10) -- second of bottom
		surface.DrawRect( size + placeW - sectorW / 2 - sectorW	, h - size - 10, sectorW, 10) -- third of bottom
	end


	/********************************************************
		[HEMIFRAME] Close Button
	********************************************************/
	local cbutton = vgui.Create("DButton",bpanel)
	cbutton:SetSize(bpanel:GetWide(),75)
	cbutton:SetPos(0, bpanel:GetTall() - 75)
	cbutton:SetText("")
	cbutton.DoClick = function(self,w,h) main:Close() hook.Run("MOTD.OnClose") end
	cbutton.Paint = function(self,w,h) MOTD.Skin.ButtonsClose(self,w,h, "CLOSE") end


	/********************************************************
		[HTML] Frame
	********************************************************/
	local hpanel = vgui.Create("DPanel",pFrame)
	hpanel:SetSize(pFrame:GetWide() - 10 - size * 2, pFrame:GetTall() - 20 - size * 2)
	hpanel:SetPos(size, size + 10)
	hpanel.Paint = function(self,w,h) MOTD.Skin.HtmlFrame(self,w,h) end


	/********************************************************
		[HTML] Core
	********************************************************/
	html = vgui.Create( "HTML", hpanel )
	html:SetSize( hpanel:GetWide() - 10, hpanel:GetTall() - 10 )
	html:SetPos( 5, 5 )
	html:OpenURL( MOTD.Cfg.Buttons[sel_btn].URL ) -- if button was removed

	hook.Run("MOTD.OnOpen",main)
end




hook.Add("InitPostEntity","MOTD.Show",function()
	vgui.Create("tg_loading"):SetCallback(MOTD.Open)
end)


net.Receive("MOTD.Show", MOTD.Open)

--MOTD.Open()