local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_desmanche",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"motoclub.permissao")
end

function emP.checkVehicle()
	local source = source
	local user_id = vRP.getUserId(source)
	local mPlaca,mName,mPrice,mBanido = vRPclient.ModelName2(source)
	local placa_user = vRP.getUserByRegistration(mPlaca)
	if placa_user then
		local rows = vRP.query("vRP/get_detido",{ user_id = placa_user, vehicle = mName })
		if #rows <= 0 then
			TriggerClientEvent("Notify",source,"aviso","Veículo não encontrado na lista do proprietário.")
			return
		end
		if mName then
			if parseInt(rows[1].detido) == 1 then
				TriggerClientEvent("Notify",source,"aviso","Veículo encontra-se apreendido na seguradora.")
				return
			end
			if mBanido then
				TriggerClientEvent("Notify",source,"aviso","Veículos de serviço ou alugados não podem ser desmanchados.")
				return
			end
		end
		return true
	end
end

function emP.removeVehicles(mPlaca,mName,mPrice,mNet)
	local source = source
	local user_id = vRP.getUserId(source)
	local placa_user = vRP.getUserByRegistration(mPlaca)
	if placa_user then
		vRP.execute("vRP/set_detido",{ user_id = placa_user, vehicle = mName, detido = 1, time = parseInt(os.time()) })
		vRP.giveInventoryItem(user_id,"dinheirosujo",parseInt(mPrice)*0.15)
		TriggerClientEvent('syncdeleteentity',-1,mNet)
	end
end