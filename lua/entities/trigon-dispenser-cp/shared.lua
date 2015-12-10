/*************************************************************************
	Скрипт распостраняется под свободной лицензией Apache 2.0
	Одним из требований лицензии является уведомление автора при
	использовании исходного кода продукта, в данном случае - скрипта
	http://steamcommunity.com/profiles/76561198071463189

	
	If you want to use this script, you must notify author
	http://steamcommunity.com/profiles/76561198071463189

	The script is spread under the free Apache 2.0 license
	One of the requirements of the license is to notify the author
	if you going to use the source code of this script
	http://steamcommunity.com/profiles/76561198071463189
**************************************************************************/

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Раздатчик для ГО"
ENT.Author = "_AMD_"
ENT.Category = "TRIGON.IM"
ENT.Spawnable = true
ENT.AdminSpawnable = false


properties.Add( "TGdispSAVE", {
	MenuLabel = "Сохранить раздатчик", -- bin_closed
	Order = 999,
	MenuIcon = "icon16/bullet_disk.png",

	Filter = function( self, ent, ply )
		if ( !IsValid( ent ) ) then return false end
		if ( !ply:IsSuperAdmin() ) then return false end
		if ( ent:GetClass() ~= "trigon-dispenser-cp" ) then return false end

		return true
	end,
	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,
	Receive = function( self, length, player )
		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end


		local FileName = math.random(1,999999)

		if file.Exists( "trigon_scripts/dispensers/" .. string.lower(game.GetMap()) .. "/dispensers_loc_" .. FileName .. ".txt", "DATA" ) then
			player:ChatPrint("Упс. Давай еще разочек. Тут косяк")
			return
		end
		local HisVector = string.Explode(" ", tostring(ent:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ent:GetAngles()))

		file.Write(
			"trigon_scripts/dispensers/" .. string.lower(game.GetMap()) .. "/dispensers_loc_" .. FileName .. ".txt",
			"" .. (HisVector[1]) .. ";" .. (HisVector[2]) .. ";" .. (HisVector[3]) .. ";" .. (HisAngles[1]) .. ";" .. (HisAngles[2]) .. ";" .. (HisAngles[3]) .. ""
		)
		player:ChatPrint("Раздатчик сохранен!")
	end
} );



properties.Add( "TGdispREMOVE", {
	MenuLabel = "Удалить раздатчик",
	Order = 999,
	MenuIcon = "icon16/bin_closed.png",

	Filter = function( self, ent, ply )
		if ( !IsValid( ent ) ) then return false end
		if ( !ply:IsSuperAdmin() ) then return false end
		if ( ent:GetClass() ~= "trigon-dispenser-cp" ) then return false end

		return true
	end,
	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,
	Receive = function( self, length, player )
		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end

		local FileName

		if ent.uniqueName then FileName = ent.uniqueName[1] end

		if FileName == nil then
			player:ChatPrint("Что-то не так. Удалите раздатчик вручную 1!")
			return
		end

		if file.Exists( "trigon_scripts/dispensers/" .. string.lower(game.GetMap()) .. "/" .. FileName .. ".txt" ) then
			file.Delete( "trigon_scripts/dispensers/" .. string.lower(game.GetMap()) .. "/" .. FileName .. ".txt" )
			player:ChatPrint("Выбраный раздатчик удален")
			ent:Remove()
			return
		else
			player:ChatPrint("Что-то не так. Удалите раздатчик вручную 2!")
		end
	end
} );