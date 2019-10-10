local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_caminhao",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local gas = 1
local cars = 1
local show = 1
local woods = 1
local diesel = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local paylist = {
	["diesel"] = {
		[1] = { pay = math.random(2400,3000) },
		[2] = { pay = math.random(2400,3000) },
		[3] = { pay = math.random(2400,3000) },
		[4] = { pay = math.random(2400,3000) },
		[5] = { pay = math.random(2600,3400) },
		[6] = { pay = math.random(2400,3000) }
	},
	["gas"] = {
		[1] = { pay = math.random(2000,2600) },
		[2] = { pay = math.random(1300,2200) },
		[3] = { pay = math.random(1300,2200) },
		[4] = { pay = math.random(1300,2200) },
		[5] = { pay = math.random(1300,2200) },
		[6] = { pay = math.random(1300,2200) },
		[7] = { pay = math.random(1300,2200) },
		[8] = { pay = math.random(1300,2200) },
		[9] = { pay = math.random(1300,2200) },
		[10] = { pay = math.random(1800,2600) },
		[11] = { pay = math.random(1800,2600) },
		[12] = { pay = math.random(1500,2600) }
	},
	["cars"] = {
		[1] = { pay = math.random(1200,1800) },
		[2] = { pay = math.random(1200,1800) },
		[3] = { pay = math.random(1200,1800) },
		[4] = { pay = math.random(1400,2000) },
		[5] = { pay = math.random(2200,2800) }
	},
	["woods"] = {
		[1] = { pay = math.random(2800,3600) },
		[2] = { pay = math.random(1800,2400) },
		[3] = { pay = math.random(1200,1800) },
		[4] = { pay = math.random(1200,1800) }
	},
	["show"] = {
		[1] = { pay = math.random(2000,2600) },
		[2] = { pay = math.random(1200,1800) },
		[3] = { pay = math.random(1200,1800) },
		[4] = { pay = math.random(1300,1800) }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(id,mod,health)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.giveMoney(user_id,parseInt(paylist[mod][id].pay+health))
		if mod == "cars" then
			local value = vRP.getSData("meta:concessionaria")
			local metas = json.decode(value) or 0
			if metas then
				vRP.setSData("meta:concessionaria",json.encode(parseInt(metas+1)))
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)
		diesel = math.random(#paylist["diesel"])
		gas = math.random(#paylist["gas"])
		cars = math.random(#paylist["cars"])
		woods = math.random(#paylist["woods"])
		show = math.random(#paylist["show"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETTRUCKPOINT
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.getTruckpoint(point)
	if point == "diesel" then
		return parseInt(diesel)
	elseif point == "gas" then
		return parseInt(gas)
	elseif point == "cars" then
		return parseInt(cars)
	elseif point == "woods" then
		return parseInt(woods)
	elseif point == "show" then
		return parseInt(show)
	end
end