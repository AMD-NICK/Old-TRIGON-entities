include("shared.lua")


function ENT:Draw()
self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	surface.SetFont("HUDNumber5")

	Ang:RotateAroundAxis(Ang:Forward(),  90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
	cam.Start3D2D(Pos + Ang:Up() * 16, Ang, 0.10)
		draw.SimpleTextOutlined( "Раздатчик для ГО", "DermaLarge", 0, - 130,Color( 0, math.sin( CurTime() * 2 ) * 255, 255, 255 ),1,2,2, Color( 0, 0, 0, 255 ) )
		draw.DrawText("• Патроны\n• Броня 100%\n• Здоровье 100%","DermaLarge",-250,-80, Color(228,228,228,200), TEXT_ALIGN_LEFT)
	cam.End3D2D()
end