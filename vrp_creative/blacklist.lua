-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKLIST VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
blackVehicles = {
	"taco",
	"bus",
	"mule",
	"mule2",
	"mule3",
	"mule4",
	"pounder",
	"biff"
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		checkCar(GetVehiclePedIsIn(PlayerPedId()))
		x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		for k,v in pairs(blackVehicles) do
			checkCar(GetClosestVehicle(x,y,z,300.0,GetHashKey(v),70))
		end
	end
end)

function checkCar(vehicle)
	if vehicle then
		local model = GetEntityModel(vehicle)
		if isCarBlacklisted(model) then
			Citizen.InvokeNative(0xAE3CBE5BF394C9C9,Citizen.PointerValueIntInitialized(vehicle))
		end
	end
end

function isCarBlacklisted(model)
	for k,v in pairs(blackVehicles) do
		if model == GetHashKey(v) then
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKLIST WEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
blackWeapons = {
	"WEAPON_APPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_FLAREGUN",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_REVOLVER_MK2",
	"WEAPON_DOUBLEACTION",
	"WEAPON_RAYPISTOL",
	"WEAPON_SMG_MK2",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_MINISMG",
	"WEAPON_RAYCARBINE",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_BULLPUPSHOTGUN",
	"WEAPON_HEAVYSHOTGUN",
	"WEAPON_DBSHOTGUN",
	"WEAPON_AUTOSHOTGUN",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_BULLPUPRIFLE_MK2",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_MG",
	"WEAPON_COMBATMG",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_SNIPERRIFLE",
	"WEAPON_HEAVYSNIPER",
	"WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_MARKSMANRIFLE",
	"WEAPON_MARKSMANRIFLE_MK2",
	"WEAPON_RPG",
	"WEAPON_GRENADELAUNCHER",
	"WEAPON_GRENADELAUNCHER_SMOKE",
	"WEAPON_MINIGUN",
	"WEAPON_FIREWORK",
	"WEAPON_RAILGUN",
	"WEAPON_HOMINGLAUNCHER",
	"WEAPON_COMPACTLAUNCHER",
	"WEAPON_RAYMINIGUN",
	"WEAPON_GRENADE",
	"WEAPON_BZGAS",
	"WEAPON_MOLOTOV",
	"WEAPON_STICKYBOMB",
	"WEAPON_PROXMINE",
	"WEAPON_SNOWBALL",
	"WEAPON_PIPEBOMB",
	"WEAPON_BALL",
	"WEAPON_SMOKEGRENADE"
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		for k,v in ipairs(blackWeapons) do
			if HasPedGotWeapon(PlayerPedId(),GetHashKey(v),false) == 1 then
				RemoveWeaponFromPed(PlayerPedId(),GetHashKey(v))
			end
		end
	end
end)