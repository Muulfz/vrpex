Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for id = 0,31 do
			if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
				if IsEntityVisible(GetPlayerPed(id)) ~= PlayerPedId() then
					x1,y1,z1 = table.unpack(GetEntityCoords(PlayerPedId()))
					x2,y2,z2 = table.unpack(GetEntityCoords(GetPlayerPed(id)))
					distance = math.floor(GetDistanceBetweenCoords(x1,y1,z1,x2,y2,z2,true))
					if distance <= 5 then
						if NetworkIsPlayerTalking(id) then
							DrawMarker(25,x2,y2,z2-0.97,0,0,0,0,0,0,0.7,0.7,0.5,65,194,222,30,0,0,2,0,0,0,0)
						end
					end
				end
			end
		end
	end
end)