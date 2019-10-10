local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = {}
Tunnel.bindInterface("vrp_trafico",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,perm)
end

local src = {
	[1] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "adubo", ['itemqtd'] = 2 },
	[2] = { ['re'] = "adubo", ['reqtd'] = 2, ['item'] = "fertilizante", ['itemqtd'] = 2 },
	[3] = { ['re'] = "fertilizante", ['reqtd'] = 2, ['item'] = "maconha", ['itemqtd'] = 4 },

	[4] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "capsula", ['itemqtd'] = 20 },
	[5] = { ['re'] = "capsula", ['reqtd'] = 20, ['item'] = "polvora", ['itemqtd'] = 20 },
	[6] = { ['re'] = "polvora", ['reqtd'] = 20, ['item'] = "wammo|WEAPON_ASSAULTSMG", ['itemqtd'] = 20 }
}

function func.checkPayment(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if src[id].re ~= nil then
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(src[id].item)*src[id].itemqtd <= vRP.getInventoryMaxWeight(user_id) then
				if vRP.tryGetInventoryItem(user_id,src[id].re,src[id].reqtd,false) then
					vRP.giveInventoryItem(user_id,src[id].item,src[id].itemqtd,false)
					return true
				end
			end
		else
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(src[id].item)*src[id].itemqtd <= vRP.getInventoryMaxWeight(user_id) then
				vRP.giveInventoryItem(user_id,src[id].item,src[id].itemqtd,false)
				return true
			end
		end
	end
end