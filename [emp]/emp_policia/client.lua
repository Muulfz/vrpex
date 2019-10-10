local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP = Tunnel.getInterface("emp_policia")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0
local CoordenadaX = 455.93
local CoordenadaY = -979.41
local CoordenadaZ = 30.68
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = 252.08, ['y'] = -1043.34, ['z'] = 28.85 },
	[2] = { ['x'] = 209.85, ['y'] = -1267.18, ['z'] = 28.76 },
	[3] = { ['x'] = -12.10, ['y'] = -1583.68, ['z'] = 28.84 },
	[4] = { ['x'] = 106.97, ['y'] = -1844.10, ['z'] = 24.86 },
	[5] = { ['x'] = 141.52, ['y'] = -2020.56, ['z'] = 17.80 },
	[6] = { ['x'] = 343.32, ['y'] = -1950.74, ['z'] = 23.97 },
	[7] = { ['x'] = 512.34, ['y'] = -1714.34, ['z'] = 28.77 },
	[8] = { ['x'] = 938.17, ['y'] = -1770.60, ['z'] = 30.69 },
	[9] = { ['x'] = 930.86, ['y'] = -2059.95, ['z'] = 29.96 },
	[10] = { ['x'] = 897.18, ['y'] = -2441.59, ['z'] = 27.98 },
	[11] = { ['x'] = 788.28, ['y'] = -2091.75, ['z'] = 28.77 },
	[12] = { ['x'] = 1214.76, ['y'] = -2066.85, ['z'] = 43.82 },
	[13] = { ['x'] = 1415.89, ['y'] = -1776.45, ['z'] = 65.78 },
	[14] = { ['x'] = 1158.19, ['y'] = -1744.54, ['z'] = 35.14 },
	[15] = { ['x'] = 1321.20, ['y'] = -1629.83, ['z'] = 51.64 },
	[16] = { ['x'] = 1166.94, ['y'] = -966.67, ['z'] = 46.59 },
	[17] = { ['x'] = 1198.82, ['y'] = -778.58, ['z'] = 56.66 },
	[18] = { ['x'] = 1210.27, ['y'] = -391.22, ['z'] = 67.91 },
	[19] = { ['x'] = 905.76, ['y'] = -592.52, ['z'] = 56.86 },
	[20] = { ['x'] = 1173.79, ['y'] = -762.16, ['z'] = 57.16 },
	[21] = { ['x'] = 1265.66, ['y'] = -561.65, ['z'] = 68.48 },
	[22] = { ['x'] = 1013.67, ['y'] = -184.72, ['z'] = 70.10 },
	[23] = { ['x'] = 537.94, ['y'] = 79.89, ['z'] = 95.87 },
	[24] = { ['x'] = 440.28, ['y'] = 292.11, ['z'] = 102.49 },
	[25] = { ['x'] = 36.18, ['y'] = 279.73, ['z'] = 109.05 },
	[26] = { ['x'] = -45.20, ['y'] = 55.51, ['z'] = 71.77 },
	[27] = { ['x'] = -223.52, ['y'] = 237.92, ['z'] = 90.89 },
	[28] = { ['x'] = -640.15, ['y'] = 278.44, ['z'] = 80.80 },
	[29] = { ['x'] = -854.33, ['y'] = 424.08, ['z'] = 86.56 },
	[30] = { ['x'] = -1442.72, ['y'] = 289.75, ['z'] = 60.88 },
	[31] = { ['x'] = -1401.01, ['y'] = -150.57, ['z'] = 47.17 },
	[32] = { ['x'] = -1620.99, ['y'] = -274.13, ['z'] = 52.31 },
	[33] = { ['x'] = -2167.53, ['y'] = -323.29, ['z'] = 12.63 },
	[34] = { ['x'] = -1718.92, ['y'] = -559.12, ['z'] = 36.85 },
	[35] = { ['x'] = -1308.32, ['y'] = -891.34, ['z'] = 11.09 },
	[36] = { ['x'] = -1208.50, ['y'] = -1230.02, ['z'] = 6.65 },
	[37] = { ['x'] = -1160.15, ['y'] = -1480.58, ['z'] = 3.87 },
	[38] = { ['x'] = -1058.83, ['y'] = -1322.13, ['z'] = 5.00 },
	[39] = { ['x'] = -997.30, ['y'] = -1130.55, ['z'] = 1.66 },
	[40] = { ['x'] = -1399.95, ['y'] = -930.18, ['z'] = 10.56 },
	[41] = { ['x'] = -1414.83, ['y'] = -759.22, ['z'] = 22.35 },
	[42] = { ['x'] = -1101.34, ['y'] = -746.89, ['z'] = 19.04 },
	[43] = { ['x'] = -782.34, ['y'] = -1097.14, ['z'] = 10.20 },
	[44] = { ['x'] = -613.50, ['y'] = -859.39, ['z'] = 24.69 },
	[45] = { ['x'] = -540.60, ['y'] = -681.40, ['z'] = 32.73 },
	[46] = { ['x'] = -150.01, ['y'] = -714.54, ['z'] = 34.24 },
	[47] = { ['x'] = 147.12, ['y'] = -809.33, ['z'] = 30.69 },
	[48] = { ['x'] = 478.82, ['y'] = -339.70, ['z'] = 45.33 },
	[49] = { ['x'] = 956.09, ['y'] = -304.17, ['z'] = 66.47 },
	[50] = { ['x'] = 1210.94, ['y'] = -353.52, ['z'] = 68.63 },
	[51] = { ['x'] = 1196.12, ['y'] = -741.57, ['z'] = 58.08 },
	[52] = { ['x'] = 427.51, ['y'] = -853.95, ['z'] = 29.26 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if not servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if distance <= 30.0 then
				DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
				if distance <= 1.5 then
					if IsControlJustPressed(0,38) and emP.checkPermission() then
						servico = true
						selecionado = 1
						CriandoBlip(locs,selecionado)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

			if distance <= 30.0 then
				DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z+0.30,0,0,0,0,180.0,130.0,2.0,2.0,1.0,240,200,80,20,1,0,0,1)
				if distance <= 2.5 then
					if IsControlJustPressed(0,38) and emP.checkPermission() then
						if IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey("policiacharger2018")) or IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey("policiasilverado")) or IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey("policiabmwr1200")) or IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey("policiatahoe")) or IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey("policiataurus")) or IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey("policiavictoria")) then
							RemoveBlip(blips)
							if selecionado == 52 then
								selecionado = 1
							else
								selecionado = selecionado + 1
							end
							emP.checkPayment()
							CriandoBlip(locs,selecionado)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if servico then
			if IsControlJustPressed(0,168) then
				servico = false
				RemoveBlip(blips)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rota de Patrulha")
	EndTextCommandSetBlipName(blips)
end