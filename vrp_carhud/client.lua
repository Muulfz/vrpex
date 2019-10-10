local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local hour = 0
local minute = 0
local month = ""
local dayOfMonth = 0
local proximity = 10.001
local voice = 2
local sBuffer = {}
local vBuffer = {}
local CintoSeguranca = false
local ExNoCarro = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATA E HORA
-----------------------------------------------------------------------------------------------------------------------------------------
function CalculateTimeToDisplay()
	hour = GetClockHours()
	minute = GetClockMinutes()
	if hour <= 9 then
		hour = "0" .. hour
	end
	if minute <= 9 then
		minute = "0" .. minute
	end
end

function CalculateDateToDisplay()
	month = GetClockMonth()
	dayOfMonth = GetClockDayOfMonth()
	if month == 0 then
		month = "Janeiro"
	elseif month == 1 then
		month = "Fevereiro"
	elseif month == 2 then
		month = "Março"
	elseif month == 3 then
		month = "Abril"
	elseif month == 4 then
		month = "Maio"
	elseif month == 5 then
		month = "Junho"
	elseif month == 6 then
		month = "Julho"
	elseif month == 7 then
		month = "Agosto"
	elseif month == 8 then
		month = "Setembro"
	elseif month == 9 then
		month = "Outubro"
	elseif month == 10 then
		month = "Novembro"
	elseif month == 11 then
		month = "Dezembro"
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CSS
-----------------------------------------------------------------------------------------------------------------------------------------
local css = [[
	.div_informacoes {
		bottom: 3%;
		right: 2%;
		position: absolute;
	}
	.voice1 {
		content: url(https://i.imgur.com/qODLlmI.png);
		height: 32px;
		width: 32px;
		float: left;
	}
	.voice2 {
		content: url(https://i.imgur.com/0XjvSVh.png);
		height: 32px;
		width: 32px;
		float: left;
	}
	.voice3 {
		content: url(https://i.imgur.com/WGagrXs.png);
		height: 32px;
		width: 32px;
		float: left;
	}
	.voice4 {
		content: url(https://i.imgur.com/dtLNTOn.png);
		height: 32px;
		width: 32px;
		float: left;
	}
	.texto {
		margin-right: 12px;
		height: 32px;
		font-family: Arial;
		font-size: 13px;
		text-shadow: 1px 1px #000;
		color: rgba(255,255,255,0.5);
		text-align: right;
		line-height: 16px;
		float: left;
	}
	.texto b {
		color: rgba(255,255,255,0.7);
	}
	.div_barraserver {
		content: url(https://i.imgur.com/aT4vpi0.png);
		top: 0;
		right: 0;
		position: absolute;
		width: 217px;
		height: 169px;
	}
]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
local barraserver = false
RegisterCommand("server",function(source,args)
	if barraserver then
		vRP._removeDiv("barraserver")
		barraserver = false
	else
		vRP._setDiv("barraserver",css,"")
		barraserver = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerSpawned",function()
	NetworkSetTalkerProximity(proximity)
	vRP._setDiv("informacoes",css,"")
end)

function UpdateOverlay()
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped,false))
	local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
	CalculateTimeToDisplay()
	CalculateDateToDisplay()
	NetworkClearVoiceChannel()
	NetworkSetTalkerProximity(proximity)

	vRP._setDivContent("informacoes","<div class=\"texto\">Hoje é dia "..dayOfMonth.." de "..month.." - "..hour..":"..minute.."<br>Você está na <b>"..street.."</b></div><div class=\"voice"..voice.."\"></div>")
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		UpdateOverlay()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		local ui = GetMinimapAnchor()

		local health = GetEntityHealth(ped)-100
		local varSet1 = (ui.width-0.1182)*(health/100)

		local armor = GetPedArmour(ped)
		if armor > 100.0 then armor = 100.0 end
		local varSet2 = (ui.width-0.0735)*(armor/100)

		if IsPedInAnyVehicle(ped) then
			SetRadarZoom(1000)
			DisplayRadar(true)
			local carro = GetVehiclePedIsIn(ped,false)
			local velocidade = GetEntitySpeed(carro)
			drawTxt(ui.right_x-0.052,ui.bottom_y-0.062,0.42,"~w~"..math.ceil(velocidade*2.236936),255,255,255,255)

			drawRct(ui.right_x-0.006,ui.bottom_y-0.177,0.006,0.16,30,30,30,255)
			drawRct(ui.right_x-0.004,ui.top_y+0.003,0.002,0.16,255,0,0,150)
			drawRct(ui.right_x-0.004,ui.top_y+0.003,0.002,0.16/100*(parseInt(100-GetVehicleFuelLevel(carro))),30,30,30,255)
			drawRct(ui.right_x-0.004,ui.top_y+0.003,0.002,0.16,255,255,255,30)
			drawRct(ui.right_x-0.004,ui.bottom_y-0.158,0.002,0.001,255,255,255,100)
			drawRct(ui.right_x-0.004,ui.bottom_y-0.142,0.002,0.0009,255,255,255,100)
			drawRct(ui.right_x-0.004,ui.bottom_y-0.127,0.002,0.0009,255,255,255,100)
			drawRct(ui.right_x-0.004,ui.bottom_y-0.111,0.002,0.001,255,255,255,100)
			drawRct(ui.right_x-0.004,ui.bottom_y-0.095,0.002,0.001,255,255,255,100)
			drawRct(ui.right_x-0.004,ui.bottom_y-0.079,0.002,0.0009,255,255,255,100)
			drawRct(ui.right_x-0.004,ui.bottom_y-0.064,0.002,0.001,255,255,255,100)
			drawRct(ui.right_x-0.004,ui.bottom_y-0.048,0.002,0.0009,255,255,255,100)
			drawRct(ui.right_x-0.004,ui.bottom_y-0.032,0.002,0.0009,255,255,255,100)

			if CintoSeguranca then
				drawTxt(ui.right_x-0.034,ui.bottom_y-0.062,0.42,"~g~MPH",255,255,255,255)
			else
				drawTxt(ui.right_x-0.034,ui.bottom_y-0.062,0.42,"~o~MPH",255,255,255,255)
			end
		else
			DisplayRadar(false)
		end

		drawRct(ui.x,ui.bottom_y-0.017,ui.width,0.015,30,30,30,255)
		drawRct(ui.x+0.002,ui.bottom_y-0.014,ui.width-0.0735,0.009,50,100,50,255)
		drawRct(ui.x+0.002,ui.bottom_y-0.014,varSet1,0.009,80,156,81,255)
		drawRct(ui.x+0.0715,ui.bottom_y-0.014,ui.width-0.0735,0.009,40,90,117,255)
		drawRct(ui.x+0.0715,ui.bottom_y-0.014,varSet2,0.009,66,140,180,255)

		if IsControlJustPressed(1,212) and GetEntityHealth(ped) > 100 then
			if proximity == 3.001 then
				voice = 2
				proximity = 10.001
			elseif proximity == 10.001 then
				voice = 3
				proximity = 25.001
			elseif proximity == 25.001 then
				voice = 4
				proximity = 50.001
			elseif proximity == 50.001 then
				voice = 1
				proximity = 3.001
			end
			UpdateOverlay()
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CINTO DE SEGURANÇA
-----------------------------------------------------------------------------------------------------------------------------------------
IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end	

Fwv = function (entity)
	local hr = GetEntityHeading(entity) + 90.0
	if hr < 0.0 then
		hr = 360.0 + hr
	end
	hr = hr * 0.0174533
	return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

local segundos = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)

		if car ~= 0 and (ExNoCarro or IsCar(car)) then
			ExNoCarro = true
			if CintoSeguranca then
				DisableControlAction(0,75)
			end

			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not CintoSeguranca and GetEntitySpeedVector(car,true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityHealth(ped,GetEntityHealth(ped)-150)
				SetEntityCoords(ped,co.x+fw.x,co.y+fw.y,co.z-0.47,true,true,true)
				SetEntityVelocity(ped,vBuffer[2].x,vBuffer[2].y,vBuffer[2].z)
				segundos = 20
			end

			vBuffer[2] = vBuffer[1]
			vBuffer[1] = GetEntityVelocity(car)

			if IsControlJustReleased(1,47) then
				TriggerEvent("cancelando",true)
				if CintoSeguranca then
					TriggerEvent("vrp_sound:source",'unbelt',0.5)
					SetTimeout(2000,function()
						CintoSeguranca = false
						TriggerEvent("cancelando",false)
					end)
				else
					TriggerEvent("vrp_sound:source",'belt',0.5)
					SetTimeout(3000,function()
						CintoSeguranca = true
						TriggerEvent("cancelando",false)
					end)
				end
			end
		elseif ExNoCarro then
			ExNoCarro = false
			CintoSeguranca = false
			sBuffer[1],sBuffer[2] = 0.0,0.0
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos > 0 then
			segundos = segundos - 1
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAGDOLL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if segundos > 0 and GetEntityHealth(PlayerPedId()) > 100 then
			SetPedToRagdoll(PlayerPedId(),1000,1000,0,0,0,0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AGACHAR
-----------------------------------------------------------------------------------------------------------------------------------------
local agachar = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		DisableControlAction(0,36,true)
		if not IsPedInAnyVehicle(ped) then
			RequestAnimSet("move_ped_crouched")
			RequestAnimSet("move_ped_crouched_strafing")
			if IsDisabledControlJustPressed(0,36) then
				if agachar then
					ResetPedMovementClipset(ped,0.25)
					ResetPedStrafeClipset(ped)
					agachar = false
				else
					SetPedMovementClipset(ped,"move_ped_crouched",0.25)
					SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
					agachar = true
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x+width/2,y+height/2,width,height,r,g,b,a)
end

function drawTxt(x,y,scale,text,r,g,b,a)
	SetTextFont(4)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end