-- __  ____  ___   _____ __            ___     
-- \ \/ /  |/  /  / ___// /___  ______/ (_)___ 
--  \  / /|_/ /   \__ \/ __/ / / / __  / / __ \
--  / / /  / /   ___/ / /_/ /_/ / /_/ / / /_/ /
-- /_/_/  /_/   /____/\__/\__,_/\__,_/_/\____/ 

-- Network string
util.AddNetworkString("MOTD.Show")
util.AddNetworkString("MOTD.ButtonFunc")



/********************************************************
		[SERVER-SIDE FUNCTIONS]
********************************************************/
function MOTD.Open(ply)
	net.Start("MOTD.Show")
	net.Send(ply)
end

function MOTD.DoBtnFunc(ply, btnindex)
	local func = MOTD.Cfg.Buttons[btnindex].SVFUNC
	local msg = "Error. The function not found"

	if !func then
		if !IsValid(ply) then print(msg) return end

		ply:ChatPrint(msg)

		return
	end

	func(ply, MOTD.Cfg.Buttons[btnindex])
end



/********************************************************
		[NETWORKING]
********************************************************/
net.Receive("MOTD.ButtonFunc", function(_, ply)
	MOTD.DoBtnFunc(ply, net.ReadInt(4))
end)



/********************************************************
		[HOOKS]
********************************************************/
-- hook.Add("PlayerInitialSpawn", "MOTD.OpenOnJoin", function(ply)
-- 	if MOTD.Cfg.enabled and MOTD.Cfg.OpenOnJoin then
-- 		timer.Simple(1, function()
-- 			MOTD.Open(ply)
-- 		end)
-- 	end
-- end)

hook.Add("PlayerSay", "MOTD.OpenOnCommand", function(ply, txt)
	if MOTD.Cfg.enabled then

		if MOTD.Cfg.cmds[txt] then
			MOTD.Open(ply)
		end

	end
end)