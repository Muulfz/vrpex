local Teleport = {
	["HOSPITAL"] = {
		positionFrom = { ['x'] = 340.37, ['y'] = -592.84, ['z'] = 43.28 },
		positionTo = { ['x'] = 338.53, ['y'] = -583.79, ['z'] = 74.16 }
	},
	["ESCRITORIO"] = {
		positionFrom = { ['x'] = -70.93, ['y'] = -801.04, ['z'] = 44.22 },
		positionTo = { ['x'] = -74.57, ['y'] = -820.91, ['z'] = 243.38 }
	},
	["COMEDY"] = {
		positionFrom = { ['x'] = -430.04, ['y'] = 261.80, ['z'] = 83.00 },
		positionTo = { ['x'] = -458.92, ['y'] = 284.85, ['z'] = 78.52 }
	},
	["TELEFERICO"] = {
		positionFrom = { ['x'] = -741.06, ['y'] = 5593.12, ['z'] = 41.65 },
		positionTo = { ['x'] = 446.15, ['y'] = 5571.72, ['z'] = 781.18 }
	},
	["NECROTERIO"] = {
		positionFrom = { ['x'] = 315.57, ['y'] = -583.07, ['z'] = 43.28 },
		positionTo = { ['x'] = 275.74, ['y'] = -1361.42, ['z'] = 24.53 }
	},
	["HUMANLABS"] = {
		positionFrom = { ['x'] = 319.56, ['y'] = -560.00, ['z'] = 28.74 },
		positionTo = { ['x'] = 3558.83, ['y'] = 3696.21, ['z'] = 30.12 }
	},
	["NECROTERIO2"] = {
		positionFrom = { ['x'] = 243.35, ['y'] = -1366.86, ['z'] = 24.53 },
		positionTo = { ['x'] = 251.66, ['y'] = -1366.49, ['z'] = 39.53 }
	},
	["MOTOCLUB"] = {
		positionFrom = { ['x'] = -80.89, ['y'] = 214.78, ['z'] = 96.55 },
		positionTo = { ['x'] = 1120.96, ['y'] = -3152.57, ['z'] = -37.06 }
	},
	["MOTOCLUB2"] = {
		positionFrom = { ['x'] = 224.60, ['y'] = -1511.02, ['z'] = 29.29 },
		positionTo = { ['x'] = 997.24, ['y'] = -3158.00, ['z'] = -38.90 }
	},
	["ESCRITORIO2"] = {
		positionFrom = { ['x'] = -1194.46, ['y'] = -1189.31, ['z'] = 7.69 },
		positionTo = { ['x'] = 1173.55, ['y'] = -3196.68, ['z'] = -39.00 }
	},
	["ESCRITORIO3"] = {
		positionFrom = { ['x'] = -1007.12, ['y'] = -486.67, ['z'] = 39.97 },
		positionTo = { ['x'] = -1003.05, ['y'] = -477.92, ['z'] = 50.02 }
	},
	["ESCRITORIO4"] = {
		positionFrom = { ['x'] = -1913.48, ['y'] = -574.11, ['z'] = 11.43 },
		positionTo = { ['x'] = -1902.05, ['y'] = -572.42, ['z'] = 19.09 }
	}
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for k,j in pairs(Teleport) do
			local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(),true))
			local unusedBool,coordz = GetGroundZFor_3dCoord(j.positionFrom.x,j.positionFrom.y,j.positionFrom.z,1)
			local unusedBool,coordz2 = GetGroundZFor_3dCoord(j.positionTo.x,j.positionTo.y,j.positionTo.z,1)
			local distance = GetDistanceBetweenCoords(j.positionFrom.x,j.positionFrom.y,coordz,px,py,pz,true)
			local distance2 = GetDistanceBetweenCoords(j.positionTo.x,j.positionTo.y,coordz2,px,py,pz,true)

			if distance <= 30 then
				DrawMarker(1,j.positionFrom.x,j.positionFrom.y,j.positionFrom.z-1,0,0,0,0,0,0,1.0,1.0,1.0,255,255,255,50,0,0,0,0)
				if distance <= 1.5 then
					if IsControlJustPressed(0,38) then
						SetEntityCoords(PlayerPedId(),j.positionTo.x,j.positionTo.y,j.positionTo.z-0.50)
					end
				end
			end

			if distance2 <= 30 then
				DrawMarker(1,j.positionTo.x,j.positionTo.y,j.positionTo.z-1,0,0,0,0,0,0,1.0,1.0,1.0,255,255,255,50,0,0,0,0)
				if distance2 <= 1.5 then
					if IsControlJustPressed(0,38) then
						SetEntityCoords(PlayerPedId(),j.positionFrom.x,j.positionFrom.y,j.positionFrom.z-0.50)
					end
				end
			end
		end
	end
end)