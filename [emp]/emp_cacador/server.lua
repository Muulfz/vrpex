local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_cacador",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(item,quantidade)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(item)*quantidade <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem(user_id,item,quantidade)
			random = math.random(100)
			if random >= 98 then
				vRP.giveInventoryItem(user_id,"etiqueta",1)
			end
			return true
		end
	end
end