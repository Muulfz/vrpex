-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "carnedecormorao" then
		TriggerServerEvent("cacador-vender","carnedecormorao")
	elseif data == "carnedecorvo" then
		TriggerServerEvent("cacador-vender","carnedecorvo")
	elseif data == "carnedeaguia" then
		TriggerServerEvent("cacador-vender","carnedeaguia")
	elseif data == "carnedecervo" then
		TriggerServerEvent("cacador-vender","carnedecervo")
	elseif data == "carnedecoelho" then
		TriggerServerEvent("cacador-vender","carnedecoelho")
	elseif data == "carnedecoyote" then
		TriggerServerEvent("cacador-vender","carnedecoyote")
	elseif data == "carnedelobo" then
		TriggerServerEvent("cacador-vender","carnedelobo")
	elseif data == "carnedepuma" then
		TriggerServerEvent("cacador-vender","carnedepuma")
	elseif data == "carnedejavali" then
		TriggerServerEvent("cacador-vender","carnedejavali")
	elseif data == "etiqueta" then
		TriggerServerEvent("cacador-vender","etiqueta")
	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		Citizen.Wait(1)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),985.87,-2121.18,30.47,true)
		if distance <= 30 then
			DrawMarker(23,985.87,-2121.18,30.47-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
			if distance <= 1.2 then
				if IsControlJustPressed(0,38) then
					ToggleActionMenu()
				end
			end
		end
	end
end)