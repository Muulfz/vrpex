local pedlist = {
	{ ['x'] = 426.10, ['y'] = 6463.47, ['z'] = 28.77, ['h'] = 315.75, ['hash'] = 0xFCFA9E1E, ['hash2'] = "A_C_Cow" },
	{ ['x'] = 431.42, ['y'] = 6459.22, ['z'] = 28.75, ['h'] = 318.05, ['hash'] = 0xFCFA9E1E, ['hash2'] = "A_C_Cow" },
	{ ['x'] = 436.70, ['y'] = 6454.85, ['z'] = 28.74, ['h'] = 321.40, ['hash'] = 0xFCFA9E1E, ['hash2'] = "A_C_Cow" },
	{ ['x'] = 428.42, ['y'] = 6477.27, ['z'] = 28.78, ['h'] = 134.37, ['hash'] = 0xFCFA9E1E, ['hash2'] = "A_C_Cow" }
}

Citizen.CreateThread(function()
	for k,v in pairs(pedlist) do
		RequestModel(GetHashKey(v.hash2))
		while not HasModelLoaded(GetHashKey(v.hash2)) do
			Citizen.Wait(10)
		end

		local ped = CreatePed(4,v.hash,v.x,v.y,v.z-1,v.h,false,true)
		FreezeEntityPosition(ped,true)
		SetEntityInvincible(ped,true)
	end
end)