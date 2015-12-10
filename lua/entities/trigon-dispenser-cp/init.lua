AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local dispenser

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_ar2.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)

	self.LastFired = 0
	self.Delay = 2

	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	dispenser = ents.Create("trigon-dispenser-cp")
	dispenser:SetPos(SpawnPos)
	dispenser:Spawn()
	dispenser:Activate()
end

local function SpawnDispensers()
	if not file.IsDir("trigon_scripts/dispensers/", "DATA") then
		file.CreateDir("trigon_scripts/dispensers/", "DATA")
	end

	if not file.IsDir("trigon_scripts/dispensers/" .. string.lower(game.GetMap()) .. "", "DATA") then
		file.CreateDir("trigon_scripts/dispensers/" .. string.lower(game.GetMap()) .. "", "DATA")
	end

	for k, v in pairs(file.Find("trigon_scripts/dispensers/" .. string.lower(game.GetMap()) .. "/*.txt", "DATA")) do
		local PositionFile = file.Read("trigon_scripts/dispensers/" .. string.lower(game.GetMap()) .. "/" .. v, "DATA")
		local ThePosition = string.Explode(";", PositionFile)
		local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
		local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])

		dispenser = ents.Create("trigon-dispenser-cp")
		dispenser:SetPos(TheVector)
		dispenser:SetAngles(TheAngle)
		dispenser.uniqueName = string.Explode(".txt", v)
		dispenser:Spawn()
	end
end

timer.Simple(5, SpawnDispensers)

function ENT:Use(activator, caller)
	if self.LastFired <= CurTime() then
		self.LastFired = CurTime() + self.Delay

		if not caller:IsCP() then
			DarkRP.notify(caller, 1, 4, "Этот раздатчик только для ГО")

			return
		end

		self:ResetSequence(self:LookupSequence("close"))
		self:SetPlaybackRate(0.1)
		self:EmitSound("items/ammocrate_open.wav")

		timer.Simple(0.5, function()
			if caller:IsPlayer() and caller:Alive() then
				wep = caller:GetActiveWeapon()

				if IsValid(wep) then
					am = wep:GetPrimaryAmmoType()

					if am ~= -1 then
						amc = caller:GetAmmoCount(am)

						if wep.Primary and wep.Primary.ClipSize then
							mag = wep:Clip1()

							if math.Round(
								wep.Primary.ClipSize * 12 * (wep.MaxAmmoMod and wep.MaxAmmoMod or 1)) + math.Clamp(wep.Primary.ClipSize - mag, 0, wep.Primary.ClipSize) > amc then
								caller:EmitSound("items/ammo_pickup.wav", 60, 100)
								ammo = math.Clamp(amc + (wep.Primary.ClipSize > 50 and wep.Primary.ClipSize / 2 or wep.Primary.ClipSize) * (wep.GiveAmmoMod and wep.GiveAmmoMod or 1), 0, math.Round(wep.Primary.ClipSize * 12 * (wep.MaxAmmoMod and wep.MaxAmmoMod or 1)) + math.Clamp(wep.Primary.ClipSize - mag, 0, wep.Primary.ClipSize))
								caller:SetAmmo(ammo, am)
							end
						end
					end

					cl = wep:GetClass()

					for k2, v2 in ipairs(caller:GetWeapons()) do
						am = v2:GetPrimaryAmmoType()
						amc = caller:GetAmmoCount(am)

						if amc == 0 and v2:Clip1() == 0 and cl ~= v2:GetClass() then
							if v2.Primary and v2.Primary.ClipSize then
								caller:SetAmmo(v2.Primary.ClipSize * 0.5, am)
							else
								caller:SetAmmo(15, am)
							end
						end
					end

					if wep.Secondary and wep.Secondary.Ammo ~= "none" and caller:GetAmmoCount(wep.Secondary.Ammo) < 12 then
						caller:GiveAmmo(1, wep.Secondary.Ammo)
					end
				else
					SafeRemoveEntity(self)
				end
			end
		end)

		timer.Simple(1, function()
			self:EmitSound("items/ammocrate_close.wav")
			self:ResetSequence(self:LookupSequence("open"))
		end)
	end
end