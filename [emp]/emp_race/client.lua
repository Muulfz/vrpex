local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP = Tunnel.getInterface("emp_race")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local inrace = false
local timerace = 0
local racepoint = 1
local racepos = 0
local CoordenadaX = 385.29
local CoordenadaY = -1657.45
local CoordenadaZ = 27.30
local PlateIndex = nil
local bomba = nil
local explosive = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local races = {
	[1] = {
		['time'] = 230,
		[1] = { ['x'] = 165.61, ['y'] = -1971.98, ['z'] = 18.12 },
		[2] = { ['x'] = 436.74, ['y'] = -2121.32, ['z'] = 19.62 },
		[3] = { ['x'] = 821.94, ['y'] = -1871.34, ['z'] = 28.69 },
		[4] = { ['x'] = 1269.87, ['y'] = -1662.22, ['z'] = 46.72 },
		[5] = { ['x'] = 1167.91, ['y'] = -1010.36, ['z'] = 44.15 },
		[6] = { ['x'] = 169.37, ['y'] = -1019.16, ['z'] = 28.75 },
		[7] = { ['x'] = 190.38, ['y'] = -770.57, ['z'] = 31.78 },
		[8] = { ['x'] = 91.02, ['y'] = -638.16, ['z'] = 31.01 },
		[9] = { ['x'] = 15.47, ['y'] = -337.53, ['z'] = 42.98 },
		[10] = { ['x'] = -315.46, ['y'] = -179.68, ['z'] = 38.90 },
		[11] = { ['x'] = -407.52, ['y'] = -56.98, ['z'] = 44.37 },
		[12] = { ['x'] = -617.12, ['y'] = 268.80, ['z'] = 81.12 },
		[13] = { ['x'] = -1005.33, ['y'] = 271.99, ['z'] = 66.08 },
		[14] = { ['x'] = -695.31, ['y'] = -364.62, ['z'] = 33.80 },
		[15] = { ['x'] = -643.20, ['y'] = -768.60, ['z'] = 24.98 },
		[16] = { ['x'] = -71.02, ['y'] = -1030.23, ['z'] = 28.02 },
		[17] = { ['x'] = -341.33, ['y'] = -1086.77, ['z'] = 22.39 }
	},
	[2] = {
		['time'] = 170,
		[1] = { ['x'] = 138.75, ['y'] = -1569.08, ['z'] = 28.75 },
		[2] = { ['x'] = 262.13, ['y'] = -937.15, ['z'] = 28.72 },
		[3] = { ['x'] = 111.79, ['y'] = -792.34, ['z'] = 30.82 },
		[4] = { ['x'] = -186.00, ['y'] = -1301.69, ['z'] = 30.66 },
		[5] = { ['x'] = -407.36, ['y'] = -1744.18, ['z'] = 19.36 },
		[6] = { ['x'] = -178.89, ['y'] = -1790.34, ['z'] = 29.26 },
		[7] = { ['x'] = 129.59, ['y'] = -1875.25, ['z'] = 23.31 },
		[8] = { ['x'] = 513.65, ['y'] = -1594.59, ['z'] = 28.67 },
		[9] = { ['x'] = 500.92, ['y'] = -1012.51, ['z'] = 27.38 },
		[10] = { ['x'] = 406.14, ['y'] = -881.92, ['z'] = 28.82 },
		[11] = { ['x'] = 118.88, ['y'] = -941.65, ['z'] = 29.13 },
		[12] = { ['x'] = 203.68, ['y'] = -1087.45, ['z'] = 28.70 },
		[13] = { ['x'] = -341.33, ['y'] = -1086.77, ['z'] = 22.39 }
	},
	[3] = {
		['time'] = 175,
		[1] = { ['x'] = 214.15, ['y'] = -1419.41, ['z'] = 28.70 },
		[2] = { ['x'] = 154.71, ['y'] = -1012.99, ['z'] = 28.76 },
		[3] = { ['x'] = -550.31, ['y'] = -831.70, ['z'] = 27.69 },
		[4] = { ['x'] = -625.90, ['y'] = -449.84, ['z'] = 34.18 },
		[5] = { ['x'] = -1341.41, ['y'] = -49.03, ['z'] = 50.42 },
		[6] = { ['x'] = -1668.49, ['y'] = -479.43, ['z'] = 37.85 },
		[7] = { ['x'] = -1932.74, ['y'] = -436.20, ['z'] = 19.35 },
		[8] = { ['x'] = -1935.61, ['y'] = -513.14, ['z'] = 11.21 },
		[9] = { ['x'] = -1265.27, ['y'] = -733.15, ['z'] = 10.45 },
		[10] = { ['x'] = -687.11, ['y'] = -554.89, ['z'] = 33.51 },
		[11] = { ['x'] = -575.23, ['y'] = -836.39, ['z'] = 25.89 },
		[12] = { ['x'] = -72.89, ['y'] = -1035.51, ['z'] = 27.63 },
		[13] = { ['x'] = -341.33, ['y'] = -1086.77, ['z'] = 22.39 }
	},
	[4] = {
		['time'] = 180,
		[1] = { ['x'] = 480.59, ['y'] = -1660.33, ['z'] = 28.65 },
		[2] = { ['x'] = 434.92, ['y'] = -1860.17, ['z'] = 26.93 },
		[3] = { ['x'] = 658.88, ['y'] = -2062.74, ['z'] = 28.69 },
		[4] = { ['x'] = 828.93, ['y'] = -1831.54, ['z'] = 28.53 },
		[5] = { ['x'] = 423.23, ['y'] = -1589.83, ['z'] = 28.70 },
		[6] = { ['x'] = 449.56, ['y'] = -1447.40, ['z'] = 28.71 },
		[7] = { ['x'] = 503.66, ['y'] = -771.21, ['z'] = 24.27 },
		[8] = { ['x'] = 200.97, ['y'] = -599.41, ['z'] = 28.72 },
		[9] = { ['x'] = -4.09, ['y'] = -873.96, ['z'] = 29.60 },
		[10] = { ['x'] = 678.26, ['y'] = -1021.00, ['z'] = 34.71 },
		[11] = { ['x'] = 565.80, ['y'] = -345.86, ['z'] = 42.97 },
		[12] = { ['x'] = 260.11, ['y'] = -564.07, ['z'] = 42.68 },
		[13] = { ['x'] = 84.17, ['y'] = -604.58, ['z'] = 43.63 },
		[14] = { ['x'] = -156.91, ['y'] = -699.22, ['z'] = 37.26 },
		[15] = { ['x'] = -264.28, ['y'] = -792.08, ['z'] = 31.61 },
		[16] = { ['x'] = -110.73, ['y'] = -924.80, ['z'] = 28.70 },
		[17] = { ['x'] = -81.27, ['y'] = -1058.17, ['z'] = 26.89 },
		[18] = { ['x'] = -341.33, ['y'] = -1086.77, ['z'] = 22.39 }
	},
	[5] = {
		['time'] = 170,
		[1] = { ['x'] = 519.49, ['y'] = -1587.41, ['z'] = 28.65 },
		[2] = { ['x'] = 310.50, ['y'] = -1299.87, ['z'] = 30.65 },
		[3] = { ['x'] = 165.21, ['y'] = -1017.49, ['z'] = 28.75 },
		[4] = { ['x'] = -29.67, ['y'] = -1133.60, ['z'] = 26.11 },
		[5] = { ['x'] = 162.81, ['y'] = -411.53, ['z'] = 40.51 },
		[6] = { ['x'] = -38.10, ['y'] = -248.99, ['z'] = 45.42 },
		[7] = { ['x'] = -53.22, ['y'] = -28.83, ['z'] = 65.98 },
		[8] = { ['x'] = -484.34, ['y'] = 132.44, ['z'] = 63.17 },
		[9] = { ['x'] = -557.28, ['y'] = -16.91, ['z'] = 43.38 },
		[10] = { ['x'] = -231.27, ['y'] = -585.64, ['z'] = 33.81 },
		[11] = { ['x'] = 225.79, ['y'] = -845.90, ['z'] = 29.60 },
		[12] = { ['x'] = 191.65, ['y'] = -1330.94, ['z'] = 28.71 },
		[13] = { ['x'] = 70.44, ['y'] = -1212.79, ['z'] = 28.70 },
		[14] = { ['x'] = -341.33, ['y'] = -1086.77, ['z'] = 22.39 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTRACES
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if not inrace then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if distance <= 30.0 then
				if IsEntityAVehicle(vehicle) and GetVehicleClass(vehicle) ~= 8 and GetPedInVehicleSeat(vehicle,-1) == ped then
					DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.96,0,0,0,0,0,0,10.0,10.0,1.0,0,95,140,50,0,0,0,0)
					if distance <= 5.9 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR A CORRIDA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							inrace = true
							racepos = 1
							racepoint = emP.getRacepoint()
							timerace = races[racepoint].time
							PlateIndex = GetVehicleNumberPlateText(vehicle)
							SetVehicleNumberPlateText(vehicle,"CORREDOR")
							CriandoBlip(races,racepoint,racepos)
							explosive = math.random(100)
							if explosive >= 70 then
								emP.startBombRace()
								bomba = CreateObject(GetHashKey("prop_c4_final_green"),x,y,z,true,true,true)
								AttachEntityToEntity(bomba,vehicle,GetEntityBoneIndexByName(vehicle,"exhaust"),0.0,0.0,0.0,180.0,-90.0,180.0,false,false,false,true,2,true)
								TriggerEvent("Notify","importante","Você começou uma corrida <b>Explosiva</b>, não saia do veículo e termine<br>no tempo estimado, ou então sei veículo vai explodir com você dentro.")
							end
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOINTS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if inrace then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z)
			local distance = GetDistanceBetweenCoords(races[racepoint][racepos].x,races[racepoint][racepos].y,cdz,x,y,z,true)

			if distance <= 100.0 then
				if IsEntityAVehicle(vehicle) and GetVehicleClass(vehicle) ~= 8 then
					DrawMarker(1,races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z-3,0,0,0,0,0,0,12.0,12.0,8.0,255,255,255,25,0,0,0,0)
					DrawMarker(21,races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z+1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,255,0,0,50,1,0,0,1)
					if distance <= 15.1 then
						RemoveBlip(blips)
						if racepos == #races[racepoint] then
							inrace = false
							SetVehicleNumberPlateText(GetPlayersLastVehicle(),PlateIndex)
							PlateIndex = nil
							PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
							if explosive >= 70 then
								explosive = 0
								DeleteObject(bomba)
								emP.removeBombRace()
								emP.paymentCheck(racepoint,2)
							else
								emP.paymentCheck(racepoint,1)
							end
						else
							racepos = racepos + 1
							CriandoBlip(races,racepoint,racepos)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEDRAWN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if inrace and timerace > 0 and GetVehiclePedIsUsing(PlayerPedId()) then
			drawTxt("RESTAM ~b~"..timerace.." SEGUNDOS ~w~PARA CHEGAR AO DESTINO FINAL DA CORRIDA",4,0.5,0.905,0.45,255,255,255,100)
			drawTxt("VENÇA A CORRIDA E SUPERE SEUS PROPRIOS RECORDES ANTES DO TEMPO ACABAR",4,0.5,0.93,0.38,255,255,255,50)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERACE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if inrace and timerace > 0 then
			timerace = timerace - 1
			if timerace <= 0 or not IsPedInAnyVehicle(PlayerPedId()) then
				inrace = false
				RemoveBlip(blips)
				SetVehicleNumberPlateText(GetPlayersLastVehicle(),PlateIndex)
				PlateIndex = nil
				if explosive >= 70 then
					SetTimeout(3000,function()
						explosive = 0
						DeleteObject(bomba)
						emP.removeBombRace()
						AddExplosion(GetEntityCoords(GetPlayersLastVehicle()),1,1.0,true,true,true)
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlip(races,racepoint,racepos)
	blips = AddBlipForCoord(races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,1)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Corrida Clandestina")
	EndTextCommandSetBlipName(blips)
end

RegisterNetEvent("emp_race:unbomb")
AddEventHandler("emp_race:unbomb",function()
	inrace = false
	SetVehicleNumberPlateText(GetPlayersLastVehicle(),PlateIndex)
	PlateIndex = nil
	RemoveBlip(blips)
	if explosive >= 70 then
		explosive = 0
		DeleteObject(bomba)
		emP.removeBombRace()
	end
end)