local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARRAY
-----------------------------------------------------------------------------------------------------------------------------------------
local valores = {
	{ item = "wbody|WEAPON_SNSPISTOL", quantidade = 1, compra = 30000, venda = 15000 },
	{ item = "wbody|WEAPON_MICROSMG", quantidade = 1, compra = 200000, venda = 100000 },
	{ item = "wbody|WEAPON_ASSAULTSMG", quantidade = 1, compra = 120000, venda = 60000 },
	{ item = "wbody|WEAPON_ASSAULTRIFLE", quantidade = 1, compra = 210000, venda = 105000 },
	{ item = "wbody|WEAPON_REVOLVER", quantidade = 1, compra = 100000, venda = 50000 },
	{ item = "wbody|WEAPON_GUSENBERG", quantidade = 1, compra = 150000, venda = 75000 },

	{ item = "wammo|WEAPON_SNSPISTOL", quantidade = 50, compra = 1000, venda = 500 },
	{ item = "wammo|WEAPON_MICROSMG", quantidade = 50, compra = 1000, venda = 500 },
	{ item = "wammo|WEAPON_ASSAULTRIFLE", quantidade = 50, compra = 1200, venda = 600 },
	{ item = "wammo|WEAPON_REVOLVER", quantidade = 50, compra = 1200, venda = 600 },
	{ item = "wammo|WEAPON_GUSENBERG", quantidade = 50, compra = 1200, venda = 600 },

	{ item = "algemas", quantidade = 1, compra = 20000, venda = 10000 },
	{ item = "capuz", quantidade = 1, compra = 20000, venda = 10000 },
	{ item = "lockpick", quantidade = 1, compra = 10000, venda = 5000 },
	{ item = "masterpick", quantidade = 1, compra = 50000, venda = 25000 },
	{ item = "pendrive", quantidade = 1, compra = 35000, venda = 17500 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPRAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("contrabando-comprar")
AddEventHandler("contrabando-comprar",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(valores) do
			if item == v.item then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
					if vRP.tryGetInventoryItem(user_id,"dinheirosujo",v.compra) then
						vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
						TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.getItemName(v.item).."</b> por <b>$"..vRP.format(parseInt(v.compra)).." dólares sujos</b>.")
					else
						TriggerClientEvent("Notify",source,"negado","Dinheiro sujo insuficiente.")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("contrabando-vender")
AddEventHandler("contrabando-vender",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(valores) do
			if item == v.item then
				if vRP.tryGetInventoryItem(user_id,v.item,parseInt(v.quantidade)) then
					vRP.giveInventoryItem(user_id,"dinheirosujo",parseInt(v.venda))
					TriggerClientEvent("Notify",source,"sucesso","Vendeu <b>"..parseInt(v.quantidade).."x "..vRP.getItemName(v.item).."</b> por <b>$"..vRP.format(parseInt(v.venda)).." dólares sujos</b>.")
				else
					TriggerClientEvent("Notify",source,"negado","Não possui <b>"..parseInt(v.quantidade).."x "..vRP.getItemName(v.item).."</b> em sua mochila.")
				end
			end
		end
	end
end)