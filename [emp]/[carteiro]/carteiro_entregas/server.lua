local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = {}
Tunnel.bindInterface("carteiro_entregas",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function func.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(4,8)
	end
end

function func.checkPayment()
	func.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"encomenda",quantidade[source]) then
			vRP.giveMoney(user_id,math.random(80,90)*quantidade[source])
			quantidade[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..quantidade[source].."x Encomendas</b>.")
		end
	end
end