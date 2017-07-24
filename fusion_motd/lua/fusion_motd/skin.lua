-- __  ____  ___   _____ __            ___     
-- \ \/ /  |/  /  / ___// /___  ______/ (_)___ 
--  \  / /|_/ /   \__ \/ __/ / / / __  / / __ \
--  / / /  / /   ___/ / /_/ /_/ / /_/ / / /_/ /
-- /_/_/  /_/   /____/\__/\__,_/\__,_/_/\____/ 

MOTD.Skin = {}
local skin = MOTD.Skin

local RED 			= Color(220,30,30) 		-- close button, header line
local REDLight 		= Color(230,40,40) 		-- hovered close button
local GRAY 			= Color(67,67,67) 		-- hovered and active sidebar buttons, polygon frame, scrollbar bogie outline
local GRAYLight		= Color(232,232,232) 	-- hovered sidebar button text, header text
local GRAYMedium 	= Color(80,80,80) 		-- sidebar buttons scrollbar middle panel, scrollbar bogie, scrollbar buttons
local GRAYDark		= Color(45,45,45)		-- sidebar line, html panel background
local BRIGHT 		= Color(153,153,153) 	-- inactive sidebar buttons
local WHITE 		= Color(255,255,255) 	-- close button text


/********************************************************
	[SIDEBAR] Panel
********************************************************/
function skin.SideBarPanel(self, w, h)
	surface.SetDrawColor(GRAY)
	surface.DrawRect(0,0,w,h)
end

function skin.SideBarHeader(self, w, h, txt)
	surface.SetFont( "CloseCaption_Bold" )
	local tw, th = surface.GetTextSize( txt )

	surface.SetTextPos( w / 2 - tw / 2, 37 - th / 2 )
	surface.SetTextColor(GRAYLight)
	surface.DrawText( txt )

	surface.SetDrawColor(RED)
	surface.DrawRect(0,75 - 3,w,3)
end

function skin.SideBarPanelLine(self, w, h)
	surface.SetDrawColor(GRAYDark)
	surface.DrawRect(0,0,w,h)
end

function skin.SideBarScrollPanel(self, w, h)
	surface.SetDrawColor(GRAYMedium)
	surface.DrawRect(0,0,w,h)
end


/********************************************************
	[SIDEBAR] Scroll part
********************************************************/
function skin.VerBarBack(w, h)
	surface.SetDrawColor(GRAY) -- main color
	surface.DrawRect(0, 0, w, h)
end

function skin.VerBarUpBtn(w, h)
	surface.SetDrawColor(GRAY) -- outline
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(GRAYMedium) -- main color
	surface.DrawRect(1, 1, w - 1, h - 1)
end

function skin.VerBarDwnBtn(w, h)
	surface.SetDrawColor(GRAY) -- outline
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(GRAYMedium) -- main color
	surface.DrawRect(1, 1, w - 1, h - 1)
end

function skin.VerBarBogie(w, h)
	surface.SetDrawColor(GRAY) -- outline
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(GRAYMedium) -- main color
	surface.DrawRect(1, 1, w - 1, h - 1)
end


/********************************************************
	[HEMIFRAME] Main part of Polyframe
********************************************************/
function skin.PolyFrame(self, w, h)
	surface.SetDrawColor(GRAY)
end

function skin.PolyFrameOutline(self, w, h)
	surface.SetDrawColor(RED)
end


/********************************************************
	[BUTTONS] SideBar Buttons
********************************************************/
function skin.ButtonsSidebar(self, w, h, txt, ico, active)
	if self.Hovered then
		surface.SetDrawColor(GRAY) 			-- background color
		surface.DrawRect(0,0,w,h) 			-- background
		surface.SetDrawColor(GRAYLight) 	-- хз
		surface.SetTextColor(GRAYLight) 	-- text color **your cap**
	elseif active then ---------------------------------------------------------------------------- ДОДЕЛАТЬ ПОЛИГОН С ТРЕУГОЛЬНИЧКОМ
		surface.SetDrawColor(GRAY)
		surface.DrawRect(0,0,w,h)

		local pointer = {}
		pointer[1] = {} -- above
		pointer[1][1] = { x = 0, y = 25 }
		pointer[1][2] = { x = 5, y = h / 2 }
		pointer[1][3] = { x = 0, y = h - 25 }

		surface.SetDrawColor(GRAYLight)
		draw.NoTexture()
		for k,v in ipairs(pointer) do
			surface.DrawPoly( v )
		end

		surface.SetDrawColor(GRAYLight)
		surface.SetTextColor(GRAYLight)
	else
		surface.SetDrawColor( 0,0,0,0 ) 	-- transparent
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(BRIGHT)
		surface.SetTextColor(BRIGHT)
	end

	if ico then
		surface.SetMaterial( Material(ico) )
		surface.DrawTexturedRect( 10,  h / 2 - 17, 32, 32 )
	end

	if txt then
		surface.SetFont( "Trebuchet24" )
		local _, th = surface.GetTextSize( txt )

		surface.SetTextPos( 50, h / 2 - th / 2 )
		surface.DrawText( txt )
	end
end


/********************************************************
	[HTML] Frame
********************************************************/
function skin.HtmlFrame(self, w, h)
	surface.SetDrawColor(GRAYDark)
	surface.DrawRect(0,0,w,h)
end


/********************************************************
	[HEMIFRAME] Close Button
********************************************************/
function skin.ButtonsClose(self, w, h, txt)
	if self.Hovered then
		surface.SetDrawColor(REDLight)
		surface.DrawRect(1, 1, w - 2, h - 2)
		self:SetTextColor(WHITE)
		surface.SetTextColor(WHITE)
	else
		surface.SetDrawColor(RED)
		surface.DrawRect(1, 1, w - 2, h - 2)
		self:SetTextColor(WHITE)
		surface.SetTextColor(WHITE)
	end

	if txt then
		surface.SetFont( "Trebuchet24" )
		local tw, th = surface.GetTextSize( txt )

		surface.SetTextPos( w / 2 - tw / 2, h / 2 - th / 2 )
		surface.DrawText( txt )
	end
end
