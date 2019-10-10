local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vRPN = {}
Tunnel.bindInterface("vrp_identidade",vRPN)
Proxy.addInterface("vrp_identidade",vRPN)
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRPN.Identidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local cash = vRP.getMoney(user_id)
		local banco = vRP.getBankMoney(user_id)
		local identity = vRP.getUserIdentity(user_id)
		local multas = vRP.getUData(user_id,"vRP:multas")
		local mymultas = json.decode(multas) or 0
		local paypal = vRP.getUData(user_id,"vRP:paypal")
		local mypaypal = json.decode(paypal) or 0
		if identity then
			return vRP.format(parseInt(cash)),vRP.format(parseInt(banco)),identity.name,identity.firstname,identity.user_id,identity.registration,identity.age,identity.phone,vRP.format(parseInt(mymultas)),vRP.format(parseInt(mypaypal))
		end
	end
end