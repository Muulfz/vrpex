local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP = Tunnel.getInterface("emp_desmanche")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local segundos = 0
local roubando = false
local CoordenadaX = 985.76
local CoordenadaY = -138.16
local CoordenadaZ = 73.09
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if not roubando then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),CoordenadaX,CoordenadaY,CoordenadaZ,true)
			if distance <= 50 then
				DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.96,0,0,0,0,0,0,5.0,5.0,0.5,211,176,72,20,0,0,0,0)
				if distance <= 3.1 and IsControlJustPressed(0,38) and GetPedInVehicleSeat(vehicle,-1) == ped and emP.checkPermission() then
					if emP.checkVehicle() then
						roubando = true
						segundos = 30
						FreezeEntityPosition(vehicle,true)

						repeat
							Citizen.Wait(10)
						until segundos == 0

						local mPlaca,mName,mPrice,mBanido,mNet,mVeh = vRP.ModelName2()
						if IsEntityAVehicle(mVeh) then
							TriggerServerEvent("vrp_adv_garages_id",mNet,GetVehicleEngineHealth(mVeh),GetVehicleBodyHealth(mVeh),GetVehicleFuelLevel(mVeh))
							emP.removeVehicles(mPlaca,mName,mPrice,mNet)
						end
						roubando = false
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if roubando then
			if segundos > 0 then
				DisableControlAction(0,75)
				drawTxt("AGUARDE ~y~"..segundos.." SEGUNDOS~w~, ESTAMOS DESATIVANDO O ~g~RASTREADOR ~w~DO VEÍCULO",4,0.5,0.93,0.50,255,255,255,180)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIMINUINDO O TEMPO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if roubando then
			if segundos > 0 then
				segundos = segundos - 1
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