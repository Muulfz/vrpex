local Weapons = {}
local Config = {}

Config.RealWeapons = {
	{ ['name'] = "WEAPON_PUMPSHOTGUN_MK2", ['bone'] = 24818, ['x'] = 0.12, ['y'] = -0.14, ['z'] = 0.08, ['xRot'] = 0.0, ['yRot'] = 180.0, ['zRot'] = 5.0, ['model'] = "w_sg_pumpshotgunmk2" },
	{ ['name'] = "WEAPON_SMG", ['bone'] = 24818, ['x'] = 0.12, ['y'] = -0.14, ['z'] = 0.04, ['xRot'] = 0.0, ['yRot'] = 135.0, ['zRot'] = 5.0, ['model'] = "w_sb_smg" },
	{ ['name'] = "WEAPON_COMBATPDW", ['bone'] = 24818, ['x'] = 0.12, ['y'] = -0.14, ['z'] = 0.04, ['xRot'] = 0.0, ['yRot'] = 135.0, ['zRot'] = 5.0, ['model'] = "w_sb_pdw" },
	{ ['name'] = "WEAPON_ASSAULTSMG", ['bone'] = 24818, ['x'] = 0.12, ['y'] = -0.14, ['z'] = -0.07, ['xRot'] = 0.0, ['yRot'] = 135.0, ['zRot'] = 5.0, ['model'] = "w_sb_assaultsmg" },
	{ ['name'] = "WEAPON_ASSAULTRIFLE", ['bone'] = 24818, ['x'] = 0.08, ['y'] = -0.14, ['z'] = 0.08, ['xRot'] = 0.0, ['yRot'] = 135.0, ['zRot'] = 5.0, ['model'] = "w_ar_assaultrifle" },
	{ ['name'] = "WEAPON_CARBINERIFLE", ['bone'] = 24818, ['x'] = 0.12, ['y'] = -0.14, ['z'] = 0.04, ['xRot'] = 0.0, ['yRot'] = 135.0, ['zRot'] = 5.0, ['model'] = "w_ar_carbinerifle" },
	{ ['name'] = "WEAPON_MUSKET", ['bone'] = 24818, ['x'] = -0.1, ['y'] = -0.14, ['z'] = 0.0, ['xRot'] = 0.0, ['yRot'] = 0.8, ['zRot'] = 5.0, ['model'] = "w_ar_musket" },
	{ ['name'] = "WEAPON_GUSENBERG", ['bone'] = 24818, ['x'] = 0.12, ['y'] = -0.14, ['z'] = 0.04, ['xRot'] = 0.0, ['yRot'] = 135.0, ['zRot'] = 5.0, ['model'] = "w_sb_gusenberg" }
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		for i=1,#Config.RealWeapons,1 do
			local ped = PlayerPedId()
			local weaponHash = GetHashKey(Config.RealWeapons[i].name)
			if HasPedGotWeapon(ped,weaponHash,false) then
				local empunhar = false
				for k,entity in pairs(Weapons) do
					if entity then
						if entity.weapon == Config.RealWeapons[i].name then
							empunhar = true
							break
						end
					end
				end
				if not empunhar and weaponHash ~= GetSelectedPedWeapon(ped) then
					SetGear(Config.RealWeapons[i].name)
				elseif empunhar and weaponHash == GetSelectedPedWeapon(ped) then
					RemoveGear(Config.RealWeapons[i].name)
				end
			else
				RemoveGear(Config.RealWeapons[i].name)
			end
		end
	end
end)

function RemoveGear(weapon)
	local _Weapons = {}
	for i, entity in pairs(Weapons) do
		if entity.weapon ~= weapon then
			_Weapons[i] = entity
		else
			Citizen.InvokeNative(0xAD738C3085FE7E11,entity.obj,true,true)
			SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(entity.obj))
			DeleteObject(entity.obj)
		end
	end
	Weapons = _Weapons
end

function SpawnObject(model,coords,cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	if not IsModelInCdimage(model) then return 0 end
	Citizen.CreateThread(function()
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(10)
		end
		local obj = CreateObject(model,coords.x,coords.y,coords.z,true,true,true)
		if cb then
			cb(obj)
		end
	end)
end

function SetGear(weapon)
	local bone       = nil
	local boneX      = 0.0
	local boneY      = 0.0
	local boneZ      = 0.0
	local boneXRot   = 0.0
	local boneYRot   = 0.0
	local boneZRot   = 0.0
	local ped  = PlayerPedId()
	local model      = nil

	for i=1,#Config.RealWeapons,1 do
		if Config.RealWeapons[i].name == weapon then
			bone     = Config.RealWeapons[i].bone
			boneX    = Config.RealWeapons[i].x
			boneY    = Config.RealWeapons[i].y
			boneZ    = Config.RealWeapons[i].z
			boneXRot = Config.RealWeapons[i].xRot
			boneYRot = Config.RealWeapons[i].yRot
			boneZRot = Config.RealWeapons[i].zRot
			model    = Config.RealWeapons[i].model
			break
		end
	end

	SpawnObject(model,{ x = x, y = y, z = z },function(obj)
		local boneIndex = GetPedBoneIndex(ped,bone)
		AttachEntityToEntity(obj,ped,boneIndex,boneX,boneY,boneZ,boneXRot,boneYRot,boneZRot,false,false,false,false,2,true)
		Citizen.InvokeNative(0xAD738C3085FE7E11,obj,true,true)
		table.insert(Weapons,{ weapon = weapon, obj = obj })
	end)
end

local weapon_types = {
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_SMG",
	"WEAPON_COMBATPDW",
	"WEAPON_ASSAULTSMG",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_CARBINERIFLE",
	"WEAPON_MUSKET",
	"WEAPON_GUSENBERG"
}

function getWeapons()
	local ammo_types = {}
	local weapons = {}
	for k,v in pairs(weapon_types) do
		local hash = GetHashKey(v)
		local ped = PlayerPedId()
		if HasPedGotWeapon(ped,hash) then
			local weapon = {}
			weapons[v] = weapon
			local atype = Citizen.InvokeNative(0x7FEAD38B326B9F74,ped,hash)
			if ammo_types[atype] == nil then
				ammo_types[atype] = true
				weapon.ammo = GetAmmoInPedWeapon(ped,hash)
			else
				weapon.ammo = 0
			end
		end
	end
	return weapons
end