local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
vRPgarage = Tunnel.getInterface("vrp_adv_garages")

vRP._prepare("vRP/move_vehicle","UPDATE vrp_user_vehicles SET user_id = @tuser_id WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("vRP/add_vehicle","INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle) VALUES(@user_id,@vehicle)")
vRP._prepare("vRP/remove_vehicle","DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("vRP/get_vehicles","SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP._prepare("vRP/get_vehicle","SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("vRP/get_detido","SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("vRP/set_detido","UPDATE vrp_user_vehicles SET detido = @detido, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("vRP/get_maxcars","SELECT COUNT(vehicle) as quantidade FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP._prepare("vRP/set_vehstatus","UPDATE vrp_user_vehicles SET engine = @engine, body = @body, fuel = @fuel WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("vRP/count_vehicle","SELECT COUNT(*) as qtd FROM vrp_user_vehicles WHERE vehicle = @vehicle")

local cfg = module("vrp_adv_garages","cfg/garages")
local cfg_inventory = module("vrp","cfg/inventory")

local garage_types = cfg.garage_types
local totalgaragem = 3

local veh_models_ids = Tools.newIDGenerator()
local veh_models = {}

for group,vehicles in pairs(garage_types) do
	for veh_model,_ in pairs(vehicles) do
		if not veh_models[veh_model] then
			veh_models[veh_model] = veh_models_ids:gen()
		end
	end
end

local carros = {
	["blista"] = { price = 60000 },
	["brioso"] = { price = 30000 },
	["dilettante"] = { price = 60000 },
	["issi2"] = { price = 90000 },
	["panto"] = { price = 5000 },
	["prairie"] = { price = 10000 },
	["rhapsody"] = { price = 7000 },
	["cogcabrio"] = { price = 120000 },
	["exemplar"] = { price = 80000 },
	["f620"] = { price = 55000 },
	["felon"] = { price = 70000 },
	["ingot"] = { price = 160000 },
	["felon2"] = { price = 80000 },
	["jackal"] = { price = 60000 },
	["oracle"] = { price = 60000 },
	["oracle2"] = { price = 80000 },
	["sentinel"] = { price = 50000 },
	["sentinel2"] = { price = 60000 },
	["windsor"] = { price = 150000 },
	["windsor2"] = { price = 170000 },
	["zion"] = { price = 50000 },
	["zion2"] = { price = 60000 },
	["blade"] = { price = 100000 },
	["buccaneer"] = { price = 120000 },
	["buccaneer2"] = { price = 240000 },
	["primo"] = { price = 120000 },
	["primo2"] = { price = 240000 },
	["chino"] = { price = 120000 },
	["chino2"] = { price = 240000 },
	["coquette3"] = { price = 170000 },
	["dominator"] = { price = 180000 },
	["dukes"] = { price = 150000 },
	["faction"] = { price = 150000 },
	["faction2"] = { price = 200000 },
	["faction3"] = { price = 350000 },
	["gauntlet"] = { price = 145000 },
	["hermes"] = { price = 280000 },
	["hotknife"] = { price = 180000 },
	["moonbeam"] = { price = 180000 },
	["moonbeam2"] = { price = 220000 },
	["nightshade"] = { price = 270000 },
	["picador"] = { price = 150000 },
	["ratloader2"] = { price = 180000 },
	["ruiner"] = { price = 150000 },
	["sabregt"] = { price = 240000 },
	["sabregt2"] = { price = 150000 },
	["slamvan"] = { price = 150000 },
	["slamvan2"] = { price = 190000 },
	["slamvan3"] = { price = 200000 },
	["stalion"] = { price = 150000 },
	["tampa"] = { price = 170000 },
	["vigero"] = { price = 170000 },
	["virgo"] = { price = 150000 },
	["virgo2"] = { price = 250000 },
	["virgo3"] = { price = 180000 },
	["voodoo"] = { price = 220000 },
	["yosemite"] = { price = 350000 },
	["bfinjection"] = { price = 80000 },
	["bifta"] = { price = 190000 },
	["bodhi2"] = { price = 170000 },
	["dubsta3"] = { price = 240000 },
	["mesa3"] = { price = 160000 },
	["rancherxl"] = { price = 200000 },
	["rebel"] = { price = 220000 },
	["rebel2"] = { price = 250000 },
	["riata"] = { price = 250000 },
	["dloader"] = { price = 150000 },
	["sandking"] = { price = 350000 },
	["sandking2"] = { price = 300000 },
	["baller"] = { price = 120000 },
	["baller2"] = { price = 130000 },
	["baller3"] = { price = 140000 },
	["baller4"] = { price = 150000 },
	["baller5"] = { price = 300000 },
	["baller6"] = { price = 310000 },
	["bjxl"] = { price = 100000 },
	["cavalcade"] = { price = 110000 },
	["cavalcade2"] = { price = 130000 },
	["contender"] = { price = 240000 },
	["dubsta"] = { price = 150000 },
	["dubsta2"] = { price = 180000 },
	["fq2"] = { price = 100000 },
	["granger"] = { price = 280000 },
	["gresley"] = { price = 150000 },
	["habanero"] = { price = 100000 },
	["seminole"] = { price = 110000 },
	["serrano"] = { price = 150000 },
	["xls"] = { price = 150000 },
	["xls2"] = { price = 350000 },
	["asea"] = { price = 50000 },
	["asterope"] = { price = 60000 },
	["cog55"] = { price = 200000 },
	["cog552"] = { price = 350000 },
	["cognoscenti"] = { price = 250000 },
	["cognoscenti2"] = { price = 350000 },
	["stanier"] = { price = 60000 },
	["stratum"] = { price = 70000 },
	["superd"] = { price = 200000 },
	["surge"] = { price = 100000 },
	["tailgater"] = { price = 100000 },
	["warrener"] = { price = 90000 },
	["washington"] = { price = 120000 },
	["alpha"] = { price = 160000 },
	["banshee"] = { price = 240000 },
	["bestiagts"] = { price = 220000 },
	["blista2"] = { price = 50000 },
	["blista3"] = { price = 70000 },
	["buffalo"] = { price = 240000 },
	["buffalo2"] = { price = 240000 },
	["carbonizzare"] = { price = 250000 },
	["comet2"] = { price = 200000 },
	["comet3"] = { price = 230000 },
	["coquette"] = { price = 200000 },
	["elegy"] = { price = 260000 },
	["elegy2"] = { price = 280000 },
	["feltzer2"] = { price = 200000 },
	["furoregt"] = { price = 250000 },
	["fusilade"] = { price = 180000 },
	["futo"] = { price = 150000 },
	["jester"] = { price = 120000 },
	["khamelion"] = { price = 180000 },
	["kuruma"] = { price = 240000 },
	["massacro"] = { price = 290000 },
	["ninef"] = { price = 250000 },
	["ninef2"] = { price = 250000 },
	["omnis"] = { price = 210000 },
	["pariah"] = { price = 400000 },
	["penumbra"] = { price = 120000 },
	["raiden"] = { price = 210000 },
	["rapidgt"] = { price = 220000 },
	["rapidgt2"] = { price = 240000 },
	["ruston"] = { price = 300000 },
	["schafter3"] = { price = 180000 },
	["schafter4"] = { price = 190000 },
	["schwarzer"] = {  price = 150000 },
	["sentinel3"] = { price = 150000 },
	["seven70"] = { price = 300000 },
	["specter"] = { price = 280000 },
	["specter2"] = { price = 310000 },
	["streiter"] = { price = 200000 },
	["sultan"] = { price = 150000 },
	["surano"] = { price = 270000 },
	["tampa2"] = { price = 180000 },
	["tropos"] = { price = 150000 },
	["verlierer2"] = { price = 330000 },
	["btype"] = { price = 320000 },
	["btype2"] = { price = 400000 },
	["btype3"] = { price = 340000 },
	["casco"] = { price = 310000 },
	["cheetah"] = { price = 370000 },
	["coquette2"] = { price = 250000 },
	["feltzer3"] = { price = 200000 },
	["gt500"] = { price = 250000 },
	["infernus2"] = { price = 250000 },
	["jb700"] = { price = 200000 },
	["mamba"] = { price = 240000 },
	["manana"] = { price = 120000 },
	["monroe"] = { price = 240000 },
	["peyote"] = { price = 150000 },
	["pigalle"] = { price = 250000 },
	["rapidgt3"] = { price = 190000 },
	["retinue"] = { price = 150000 },
	["stinger"] = { price = 200000 },
	["stingergt"] = { price = 230000 },
	["torero"] = { price = 160000 },
	["tornado"] = { price = 140000 },
	["tornado2"] = { price = 160000 },
	["tornado5"] = { price = 250000 },
	["turismo2"] = { price = 250000 },
	["viseris"] = {  price = 210000 },
	["ztype"] = { price = 400000 },
	["adder"] = { price = 500000 },
	["autarch"] = { price = 610000 },
	["banshee2"] = {  price = 300000 },
	["bullet"] = { price = 350000 },
	["cheetah2"] = { price = 210000 },
	["entityxf"] = { price = 400000 },
	["fmj"] = { price = 450000 },
	["gp1"] = { price = 430000 },
	["infernus"] = { price = 410000 },
	["nero"] = { price = 390000 },
	["nero2"] = { price = 420000 },
	["osiris"] = { price = 400000 },
	["penetrator"] = { price = 420000 },
	["pfister811"] = { price = 460000 },
	["reaper"] = { price = 500000 },
	["sc1"] = { price = 430000 },
	["sultanrs"] = { price = 300000 },
	["t20"] = { price = 500000 },
	["tempesta"] = { price = 520000 },
	["turismor"] = { price = 500000 },
	["tyrus"] = { price = 500000 },
	["vacca"] = { price = 500000 },
	["visione"] = { price = 600000 },
	["voltic"] = { price = 380000 },
	["zentorno"] = { price = 700000 },
	["sadler"] = { price = 180000 },
	["bison"] = { price = 200000 },
	["bison2"] = { price = 180000 },
	["bobcatxl"] = { price = 240000 },
	["burrito"] = { price = 240000 },
	["burrito2"] = { price = 240000 },
	["burrito3"] = { price = 240000 },
	["burrito4"] = { price = 240000 },
	["minivan"] = { price = 100000 },
	["minivan2"] = { price = 200000 },
	["paradise"] = { price = 240000 },
	["pony"] = { price = 240000 },
	["pony2"] = { price = 240000 },
	["rumpo"] = { price = 240000 },
	["rumpo2"] = { price = 240000 },
	["rumpo3"] = { price = 250000 },
	["speedo"] = { price = 240000 },
	["surfer"] = { price = 50000 },
	["youga"] = { price = 240000 },
	["youga2"] = { price = 240000 },
	["huntley"] = { price = 100000 },
	["landstalker"] = { price = 130000 },
	["mesa"] = { price = 90000 },
	["patriot"] = { price = 250000 },
	["radi"] = { price = 100000 },
	["rocoto"] = { price = 100000 },
	["tyrant"] = { price = 600000 },
	["entity2"] = { price = 480000 },
	["cheburek"] = { price = 150000 },
	["hotring"] = { price = 300000 },
	["jester3"] = { price = 240000 },
	["flashgt"] = { price = 320000 },
	["ellie"] = { price = 300000 },
	["michelli"] = { price = 160000 },
	["fagaloa"] = { price = 300000 },
	["dominator3"] = { price = 300000 },
	["issi3"] = { price = 160000 },
	["taipan"] = { price = 500000 },
	["gb200"] = { price = 170000 },
	["stretch"] = { price = 500000 },
	["guardian"] = { price = 500000 },
	["kamacho"] = { price = 400000 },
	["neon"] = { price = 300000 },
	["cyclone"] = { price = 800000 },
	["italigtb"] = { price = 520000 },
	["italigtb2"] = { price = 530000 },
	["vagner"] = { price = 590000 },
	["xa21"] = { price = 550000 },
	["tezeract"] = { price = 800000 },
	["prototipo"] = { price = 900000 },
	["ferrariitalia"] = { price = 1500000 },
	["fordmustang"] = { price = 1000000 },
	["nissangtr"] = { price = 1150000 },
	["nissangtrnismo"] = { price = 1200000 },
	["teslaprior"] = { price = 700000 },
	["nissanskyliner34"] = { price = 1100000 },
	["audirs6"] = { price = 850000 },
	["bmwm3f80"] = { price = 900000 },
	["bmwm4gts"] = { price = 950000 },
	["lancerevolutionx"] = { price = 850000 },
	["toyotasupra"] = { price = 1050000 },
	["nissan370z"] = { price = 550000 },
	["lamborghinihuracan"] = { price = 1300000 },
	["dodgechargersrt"] = { price = 1400000 },
	["patriot2"] = { price = 550000 },
	["speedo4"] = { price = 240000 },
	["stafford"] = { price = 400000 },
	["swinger"] = { price = 250000 },
	["brutus"] = { price = 350000 },
	["clique"] = { price = 360000 },
	["deveste"] = { price = 800000 },
	["deviant"] = { price = 300000 },
	["impaler"] = { price = 300000 },
	["imperator"] = { price = 400000 },
	["italigto"] = { price = 700000 },
	["schlagen"] = { price = 600000 },
	["toros"] = { price = 310000 },
	["tulip"] = { price = 300000 },
	["vamos"] = { price = 320000 },
	["mazdarx7"] = { price = 1000000 },
	["akuma"] = { price = 420000 },
	["avarus"] = { price = 350000 },
	["bagger"] = { price = 240000 },
	["bati"] = { price = 300000 },
	["bf400"] = { price = 260000 },
	["carbonrs"] = { price = 300000 },
	["chimera"] = { price = 280000 },
	["cliffhanger"] = { price = 250000 },
	["daemon"] = { price = 200000 },
	["daemon2"] = { price = 200000 },
	["defiler"] = { price = 380000 },
	["diablous"] = { price = 350000 },
	["diablous2"] = { price = 380000 },
	["double"] = { price = 300000 },
	["enduro"] = { price = 160000 },
	["esskey"] = { price = 260000 },
	["faggio"] = { price = 4000 },
	["faggio2"] = { price = 5000 },
	["faggio3"] = { price = 5000 },
	["fcr"] = { price = 320000 },
	["fcr2"] = { price = 320000 },
	["gargoyle"] = { price = 280000 },
	["hakuchou"] = { price = 310000 },
	["hakuchou2"] = { price = 450000 },
	["hexer"] = { price = 180000 },
	["innovation"] = { price = 210000 },
	["lectro"] = { price = 310000 },
	["manchez"] = { price = 290000 },
	["nemesis"] = { price = 280000 },
	["nightblade"] = { price = 340000 },
	["pcj"] = { price = 180000 },
	["ruffian"] = { price = 280000 },
	["sanchez"] = { price = 150000 },
	["sanchez2"] = { price = 150000 },
	["sanctus"] = {  price = 350000 },
	["sovereign"] = { price = 240000 },
	["thrust"] = { price = 300000 },
	["vader"] = { price = 280000 },
	["vindicator"] = { price = 250000 },
	["vortex"] = { price = 300000 },
	["wolfsbane"] = { price = 230000 },
	["zombiea"] = { price = 230000 },
	["zombieb"] = { price = 235000 },
	["blazer"] = { price = 200000 },
	["blazer4"] = { price = 300000 },
	["deathbike"] = { price = 350000 },
	["shotaro"] = { price = 1000000 },
	["coach"] = { price = 20000 },
	["policiacharger2018"] = { price = 20000 },
	["policiasilverado"] = { price = 20000 },
	["policiatahoe"] = { price = 20000 },
	["policiataurus"] = { price = 20000 },
	["policiavictoria"] = { price = 20000 },
	["policiabmwr1200"] = { price = 20000 },
	["policiaheli"] = { price = 20000 },
	["paramedicoambu"] = { price = 20000 },
	["paramedicocharger2014"] = { price = 20000 },
	["paramedicoheli"] = { price = 20000 },
	["pbus"] = { price = 20000 },
	["flatbed"] = { price = 20000 },
	["taxi"] = { price = 20000 },
	["boxville2"] = { price = 20000 },
	["tribike3"] = { price = 20000 },
	["trash"] = { price = 20000 },
	["trash2"] = { price = 20000 },
	["scorcher"] = { price = 2000 },
	["tribike"] = { price = 2000 },
	["tribike2"] = { price = 2000 },
	["fixter"] = { price = 2000 },
	["cruiser"] = { price = 2000 },
	["bmx"] = { price = 2000 },
	["dinghy"] = { price = 100000 },
	["jetmax"] = { price = 100000 },
	["marquis"] = { price = 100000 },
	["seashark3"] = { price = 100000 },
	["speeder"] = { price = 100000 },
	["speeder2"] = { price = 100000 },
	["squalo"] = { price = 100000 },
	["suntrap"] = { price = 100000 },
	["toro"] = { price = 100000 },
	["toro2"] = { price = 100000 },
	["tropic"] = { price = 100000 },
	["tropic2"] = { price = 100000 }
}

local idveh = {}
RegisterServerEvent("vrp_adv_garages_id")
AddEventHandler("vrp_adv_garages_id",function(netid,enginehealth,bodyhealth,fuel)
	if idveh[netid] and netid ~= 0 then
		local user_id = idveh[netid][1]
		local carname = idveh[netid][2]
		local player = vRP.getUserSource(user_id)
		if player then
			vRPgarage.despawnGarageVehicle2(player,carname)
		end
		local rows = vRP.query("vRP/get_detido",{ user_id = user_id, vehicle = carname })
		if #rows > 0 then
			vRP.execute("vRP/set_vehstatus",{ user_id = user_id, vehicle = carname, engine = parseInt(enginehealth), body = parseInt(bodyhealth), fuel = parseInt(fuel) })
		end
	end
end)

RegisterServerEvent("vrp_adv_garages_id2")
AddEventHandler("vrp_adv_garages_id2",function(carname,enginehealth,bodyhealth,fuel)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/set_vehstatus",{ user_id = user_id, vehicle = carname, engine = parseInt(enginehealth), body = parseInt(bodyhealth), fuel = parseInt(fuel) })
	end
end)

function openGarage(source,gid,pos,head,payprice)
	local source = source
	local user_id = vRP.getUserId(source)
	local vehicles = garage_types[gid]
	local gtypes = vehicles._config.gtype
	local mods = vehicles._shop
	local menu = { name = gid }

	for _,gtype in pairs(gtypes) do
		if gtype == "personal" then
			menu["Possuídos"] = { function(player,choice)
				local user_id = vRP.getUserId(source)
				if user_id then
					local kitems = {}
					local submenu = { name = "Possuídos" }
					submenu.onclose = function()
						vRP.openMenu(source,menu)
					end

					local choose = function(player,choice)
						local vname = kitems[choice]
						if vname then
							local rows = vRP.query("vRP/get_detido",{ user_id = user_id, vehicle = vname })
							local data = vRP.getSData("custom:u"..user_id.."veh_"..vname)
							local custom = json.decode(data)
							if not payprice then
								vRP.closeMenu(source)
								local cond,netid,carname = vRPgarage.spawnGarageVehicle(source,vname,pos,head,custom,parseInt(rows[1].engine),parseInt(rows[1].body),parseInt(rows[1].fuel))
								if cond then
									idveh[netid] = { user_id,carname }
								else
									TriggerClientEvent("Notify",source,"aviso","Já tem um veículo deste modelo fora da garagem.")
								end
							else
								if (vRP.getBankMoney(user_id)+vRP.getMoney(user_id)) >= parseInt(carros[vname].price*0.005) then
									vRP.closeMenu(source)
									local cond,netid,carname = vRPgarage.spawnGarageVehicle(source,vname,pos,head,custom,parseInt(rows[1].engine),parseInt(rows[1].body),parseInt(rows[1].fuel))
									if cond and vRP.tryFullPayment(user_id,parseInt(carros[vname].price*0.005)) then
										idveh[netid] = { user_id,carname }
									else
										TriggerClientEvent("Notify",source,"aviso","Já tem um veículo deste modelo fora da garagem.")
									end
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							end
						end
					end

					local choosedetido = function(player,choice)
						local vname = kitems[choice]
						if vname then
							local ok = vRP.request(source,"Veículo na detenção, deseja acionar o seguro pagando <b>$"..vRP.format(parseInt(carros[vname].price*0.1)).."</b> dólares?",60)
							if ok then
								if vRP.tryFullPayment(user_id,parseInt(carros[vname].price*0.1)) then
									vRP.closeMenu(source)
									vRP.execute("vRP/set_detido",{ user_id = user_id, vehicle = vname, detido = 0, time = 0 })
									TriggerClientEvent("Notify",source,"sucesso","Veículo liberado.")
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							end
						end
					end

					local choosedetidotime = function(source,choice)
						local vname = kitems[choice]
						if vname then
							local ok = vRP.request(source,"Veículo na retenção, deseja acionar o seguro pagando <b>$"..vRP.format(parseInt(carros[vname].price*0.5)).."</b> dólares?",60)
							if ok then
								if vRP.tryFullPayment(user_id,parseInt(carros[vname].price*0.5)) then
									vRP.closeMenu(source)
									TriggerClientEvent("Notify",source,"sucesso","Seguradora foi acionada, aguarde a notificação da liberação.")
									TriggerClientEvent("progress",source,30000,"liberando")
									SetTimeout(30000,function()
										vRP.execute("vRP/set_detido",{ user_id = user_id, vehicle = vname, detido = 0, time = 0 })
										TriggerClientEvent("Notify",source,"sucesso","Veículo liberado.")
									end)
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							end
						end
					end

					local pvehicles = vRP.query("vRP/get_vehicles",{ user_id = user_id })
					for k,v in pairs(pvehicles) do
						local vehicle
						for x,garage in pairs(garage_types) do
							vehicle = garage[v.vehicle]
							if vehicle then break end
						end

						if vehicle then
							local rows = vRP.query("vRP/get_detido",{ user_id = user_id, vehicle = v.vehicle })
							if parseInt(rows[1].detido) <= 0 then
								submenu[vehicle[1]] = { choose,"<text01>Lataria:</text01> <text02>"..vRP.format(parseInt(rows[1].body*0.1)).."%</text02><text01>Motor:</text01> <text02>"..vRP.format(parseInt(rows[1].engine*0.1)).."%</text02><text01>Gasolina:</text01> <text02>"..vRP.format(parseInt(rows[1].fuel)).."%</text02><text01>Seguro:</text01> <text02>$"..vRP.format(parseInt(carros[rows[1].vehicle].price*0.005)).."</text02><text01>Detenção:</text01> <text02>$"..vRP.format(parseInt(carros[rows[1].vehicle].price*0.1)).."</text02><text01>Retenção:</text01> <text02>$"..vRP.format(parseInt(carros[rows[1].vehicle].price*0.5)).."</text02>" }
							else
								if os.time() <= parseInt(rows[1].time+24*60*60) then
									submenu[vehicle[1]] = { choosedetidotime,"<text01>Lataria:</text01> <text02>"..vRP.format(parseInt(rows[1].body*0.1)).."%</text02><text01>Motor:</text01> <text02>"..vRP.format(parseInt(rows[1].engine*0.1)).."%</text02><text01>Gasolina:</text01> <text02>"..vRP.format(parseInt(rows[1].fuel)).."%</text02><text01>Seguro:</text01> <text02>$"..vRP.format(parseInt(carros[rows[1].vehicle].price*0.005)).."</text02><text01>Detenção:</text01> <text02>$"..vRP.format(parseInt(carros[rows[1].vehicle].price*0.1)).."</text02><text01>Retenção:</text01> <text02>$"..vRP.format(parseInt(carros[rows[1].vehicle].price*0.5)).."</text02>" }
								else
									submenu[vehicle[1]] = { choosedetido,"<text01>Lataria:</text01> <text02>"..vRP.format(parseInt(rows[1].body*0.1)).."%</text02><text01>Motor:</text01> <text02>"..vRP.format(parseInt(rows[1].engine*0.1)).."%</text02><text01>Gasolina:</text01> <text02>"..vRP.format(parseInt(rows[1].fuel)).."%</text02><text01>Seguro:</text01> <text02>$"..vRP.format(parseInt(carros[rows[1].vehicle].price*0.005)).."</text02><text01>Detenção:</text01> <text02>$"..vRP.format(parseInt(carros[rows[1].vehicle].price*0.1)).."</text02><text01>Retenção:</text01> <text02>$"..vRP.format(parseInt(carros[rows[1].vehicle].price*0.5)).."</text02>" }
								end
							end
							kitems[vehicle[1]] = v.vehicle
						end
					end
					vRP.openMenu(source,submenu)
				end
			end }

			menu["Guardar"] = { function(player,choice)
				local ok,name = vRPgarage.getNearestOwnedVehicle(source,30)
				if ok then
					vRPgarage.despawnGarageVehicle(source,name)
				else
					TriggerClientEvent('deletarveiculo',source,30)
				end
			end }
		elseif gtype == "rent" then
			menu["Aluguel"] = { function(player,choice)
				local user_id = vRP.getUserId(source)
				if user_id then
					local kitems = {}
					local submenu = { name = "Aluguel" }
					submenu.onclose = function()
						vRP.openMenu(source,menu)
					end

					local choose = function(player,choice)
						local vname = kitems[choice]
						if vname then
							local data = vRP.getSData("custom:u"..user_id.."veh_"..vname)
							local custom = json.decode(data) or false
							local cond,netid,carname = vRPgarage.spawnGarageVehicle(source,vname,pos,head,custom,1000,1000,100)
							if cond then
								idveh[netid] = { user_id,carname }
							else
								TriggerClientEvent("Notify",source,"aviso","Já tem um veículo deste modelo fora da garagem.")
							end
							vRP.closeMenu(source)
						end
					end

					local _pvehicles = vRP.query("vRP/get_vehicles",{ user_id = user_id })
					local pvehicles = {}
					for k,v in pairs(_pvehicles) do
						pvehicles[string.lower(v.vehicle)] = true
					end

					for k,v in pairs(vehicles) do
						if k ~= "_config" and k ~= "_shop" and pvehicles[string.lower(k)] == nil then
							submenu[v[1]] = { choose }
							kitems[v[1]] = k
						end
					end
					vRP.openMenu(source,submenu)
				end
			end }

			menu["Guardar"] = { function(player,choice)
				local ok,name = vRPgarage.getNearestOwnedVehicle(source,30)
				if ok then
					vRPgarage.despawnGarageVehicle(source,name)
				else
					TriggerClientEvent('deletarveiculo',source,30)
				end
			end }
		elseif gtype == "store" then
			menu["Comprar"] = { function(player,choice)
				local user_id = vRP.getUserId(source)
				if user_id then
					local kitems = {}
					local submenu = { name = "Comprar" }
					submenu.onclose = function()
						vRP.openMenu(source,menu)
					end

					local choose = function(player,choice)
						local vname = kitems[choice]
						if vname then
							local vehicle = vehicles[vname]
							if vehicle then
								local rows = vRP.query("vRP/count_vehicle",{ vehicle = vname })
								if vehicle[4] ~= -1 and parseInt(rows[1].qtd) >= vehicle[4] then
									TriggerClientEvent("Notify",source,"importante","Estoque indisponivel.")
								else
									local totalv = vRP.query("vRP/get_maxcars",{ user_id = user_id })
									if vRP.hasPermission(user_id,"bronze.permissao") then
										if parseInt(totalv[1].quantidade) >= totalgaragem + 1 then
											TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.")
											return
										end
									elseif vRP.hasPermission(user_id,"prata.permissao") then
										if parseInt(totalv[1].quantidade) >= totalgaragem + 3 then
											TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.")
											return
										end
									elseif vRP.hasPermission(user_id,"ouro.permissao") then
										if parseInt(totalv[1].quantidade) >= totalgaragem + 5 then
											TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.")
											return
										end
									elseif vRP.hasPermission(user_id,"platina.permissao") then
										if parseInt(totalv[1].quantidade) >= totalgaragem + 10 then
											TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.")
											return
										end
									else
										if parseInt(totalv[1].quantidade) >= totalgaragem then
											TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.")
											return
										end
									end
									local ok = vRP.request(source,"Tem certeza que deseja <b>comprar</b> este veículo?",30)
									if ok then
										if vRP.tryFullPayment(user_id,vehicle[2]) then
											vRP.execute("vRP/add_vehicle",{ user_id = user_id, vehicle = vname })
											if vehicle[2] > 0 then
												TriggerClientEvent("Notify",source,"sucesso","Pagou <b>$"..vRP.format(parseInt(vehicle[2])).." dólares</b>.")
											end
											vRP.closeMenu(source)
										else
											TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
										end
									end
								end
							end
						end
					end

					local _pvehicles = vRP.query("vRP/get_vehicles",{ user_id = user_id })
					local pvehicles = {}
					for k,v in pairs(_pvehicles) do
						pvehicles[string.lower(v.vehicle)] = true
					end

					for k,v in pairs(vehicles) do
						if k ~= "_config" and k ~= "_shop" and pvehicles[string.lower(k)] == nil then
							if v[2] > 0 then
								submenu[v[1]] = { choose,"<text01>Valor:</text01> <text02>$"..v[2].."</text02><text01>P-Mala:</text01> <text02>"..v[3].."</text02>" }
							else
								submenu[v[1]] = { choose }
							end
							kitems[v[1]] = k
						end
					end
					vRP.openMenu(source,submenu)
				end
			end }
			menu["Vender"] = { function(player,choice)
				local user_id = vRP.getUserId(source)
				if user_id then
					local kitems = {}
					local submenu = { name = "Vender" }
					submenu.onclose = function()
						vRP.openMenu(source,menu)
					end

					local choose = function(player,choice)
						local vname = kitems[choice]
						if vname then
							local vehicle = vehicles[vname]
							if vehicle then
								local price = math.ceil(vehicle[2]*0.7)
								local rows = vRP.query("vRP/get_vehicle",{ user_id = user_id, vehicle = vname })
								local drows = vRP.query("vRP/get_detido",{ user_id = user_id, vehicle = vname })
								if parseInt(drows[1].detido) >= 1 then
									TriggerClientEvent("Notify",source,"aviso","Acione a seguradora antes de vender.")
									return
								end
								if #rows > 0 then
									local ok = vRP.request(source,"Tem certeza que deseja <b>vender</b> este veículo?",30)
									if ok then
										vRP.execute("vRP/remove_vehicle",{ user_id = user_id, vehicle = vname })
										vRP.setSData("custom:u"..user_id.."veh_"..vname,json.encode())
										vRP.giveMoney(user_id,parseInt(price))
										if parseInt(price) > 0 then
											TriggerClientEvent("Notify",source,"sucesso","Recebeu <b>$"..vRP.format(parseInt(price)).." dólares</b>.")
										end
										vRP.closeMenu(source)
									end
								else
									TriggerClientEvent("Notify",source,"aviso","Não encontrado.")
								end
							end
						end
					end

					local _pvehicles = vRP.query("vRP/get_vehicles",{ user_id = user_id })
					local pvehicles = {}
					for k,v in pairs(_pvehicles) do
						pvehicles[string.lower(v.vehicle)] = true
					end

					for k,v in pairs(pvehicles) do
						local vehicle = vehicles[k]
						if vehicle then
							if vehicle[2] > 0 then
								submenu[vehicle[1]] = { choose,"<b>Valor:</b> $"..parseInt(math.ceil(vehicle[2]*0.7)) }
							else
								submenu[vehicle[1]] = { choose }
							end
							kitems[vehicle[1]] = k
						end
					end
					vRP.openMenu(source,submenu)
				end
			end }
		elseif gtype == "shop" then
			menu["Loja"] = { function(player,choice)
				local user_id = vRP.getUserId(source)
				local tosub = false
				if user_id then
					local submenu = { name = "Loja" }
					submenu.onclose = function()
						if not tosub then
							vRP.openMenu(source,menu)
						end
					end

					local ch_color = function(player,choice)
						local old_vname,old_custom = vRPgarage.getVehicleMods(source)
						local subsubmenu = { name = "Cores" }
						subsubmenu.onclose = function()
							tosub = false
							local vname,custom = vRPgarage.getVehicleMods(source)
							if custom then
								if vRP.tryFullPayment(user_id,3000) then
									if vname then
										local mPlaca = vRPclient.ModelName(player,7)
										local mPlacaUser = vRP.getUserByRegistration(mPlaca)
										if mPlacaUser then
											vRP.setSData("custom:u"..mPlacaUser.."veh_"..vname,json.encode(custom))
										end
										TriggerClientEvent("Notify",player,"sucesso","Pagou <b>$3.000 dólares</b>.")
									end
								else
									vRPgarage.setVehicleMods(source,old_custom)
									TriggerClientEvent("Notify",player,"negado","Dinheiro insuficiente.")
								end
							end
						vRP.openMenu(source,submenu)
					end

					local ch_pri = function(player,choice,mod)
						vRPgarage.scrollVehiclePrimaryColour(source,mod)
					end

					local ch_sec = function(player,choice,mod)
						vRPgarage.scrollVehicleSecondaryColour(source,mod)
					end

					local ch_primaria = function(player,choice)
						local rgb = vRP.prompt(source,"RGB Color(255 255 255):","")
						rgb = sanitizeString(rgb,"\"[]{}+=?!_()#@%/\\|,.",false)
						local r,g,b = table.unpack(splitString(rgb," "))
						vRPgarage.setCustomPrimaryColour(source,tonumber(r),tonumber(g),tonumber(b))
					end

					local ch_secundaria = function(player,choice)
						local rgb = vRP.prompt(source,"RGB Color(255 255 255):","")
						rgb = sanitizeString(rgb,"\"[]{}+=?!_()#@%/\\|,.",false)
						local r,g,b = table.unpack(splitString(rgb," "))
						vRPgarage.setCustomSecondaryColour(source,tonumber(r),tonumber(g),tonumber(b))
					end

					local ch_perolada = function(player,choice,mod)
						vRPgarage.scrollVehiclePearlescentColour(source,mod)
					end

					local ch_rodas = function(player,choice,mod)
						vRPgarage.scrollVehicleWheelColour(source,mod)
					end

					local ch_fumaca = function(player,choice)
						local rgb = vRP.prompt(source,"RGB Color(255 255 255):","")
						rgb = sanitizeString(rgb,"\"[]{}+=?!_()#@%/\\|,.",false)
						local r,g,b = table.unpack(splitString(rgb," "))
						vRPgarage.setSmokeColour(source,tonumber(r),tonumber(g),tonumber(b))
					end

					subsubmenu["Primária"] = { ch_pri }
					subsubmenu["Secundária"] = { ch_sec }
					subsubmenu["Primária RGB"] = { ch_primaria }
					subsubmenu["Secundária RGB"] = { ch_secundaria }
					subsubmenu["Perolada"] = { ch_perolada }
					subsubmenu["Rodas"] = { ch_rodas }
					subsubmenu["Fumaça"] = { ch_fumaca }

					tosub = true
					vRP.openMenu(source,subsubmenu)
				end

				submenu["Cores"] = { ch_color,"<text01>Valor:</text01> <text02>$3.000</text02>" }

				local ch_neon = function(player,choice)
					local old_vname,old_custom = vRPgarage.getVehicleMods(source)
					local subsubmenu = { name = "Neon" }
					subsubmenu.onclose = function()
						tosub = false
						local vname,custom = vRPgarage.getVehicleMods(source)
						if custom then
							if vRP.tryFullPayment(user_id,3000) then
								if vname then
									local mPlaca = vRPclient.ModelName(player,7)
									local mPlacaUser = vRP.getUserByRegistration(mPlaca)
									if mPlacaUser then
										vRP.setSData("custom:u"..mPlacaUser.."veh_"..vname,json.encode(custom))
									end
									TriggerClientEvent("Notify",player,"sucesso","Pagou <b>$3.000 dólares</b>.")
								end
							else
								vRPgarage.setVehicleMods(source,old_custom)
								TriggerClientEvent("Notify",player,"negado","Dinheiro insuficiente.")
							end
						end
						vRP.openMenu(source,submenu)
					end

					local ch_nleft = function(player,choice)
						vRPgarage.toggleNeon(source,0)
					end

					local ch_nright = function(player,choice)
						vRPgarage.toggleNeon(source,1)
					end

					local ch_nfront = function(player,choice)
						vRPgarage.toggleNeon(source,2)
					end

					local ch_nback = function(player,choice)
						vRPgarage.toggleNeon(source,3)
					end

					local ch_ncolor = function(player,choice)
						local rgb = vRP.prompt(source,"RGB Color(255 255 255):","")
						rgb = sanitizeString(rgb,"\"[]{}+=?!_()#@%/\\|,.",false)
						local r,g,b = table.unpack(splitString(rgb," "))
						vRPgarage.setNeonColour(source,tonumber(r),tonumber(g),tonumber(b))
					end

					subsubmenu["Traseiro"] = { ch_nback }
					subsubmenu["Dianteiro"] = { ch_nfront }
					subsubmenu["Esquerdo"] = { ch_nleft }
					subsubmenu["Direito"] = { ch_nright }
					subsubmenu["Cor"] = { ch_ncolor }
					tosub = true
					vRP.openMenu(source,subsubmenu)
				end

				submenu["Neon"] = { ch_neon,"<text01>Valor:</text01> <text02>$3.000</text02>" }

				local ch_mods = function(player,choice)
					local kitems = {}
					local old_vname,old_custom = vRPgarage.getVehicleMods(source)
					local subsubmenu = { name = "Modificações" }
					subsubmenu.onclose = function()
						tosub = false
						local vname,custom = vRPgarage.getVehicleMods(source)
						local price = 0
						local items = {}
						if custom then
							for k,v in pairs(custom.mods) do
								local old = old_custom.mods[k]
								local mod = mods[k]
								if mod then
									if old ~= v then
										if mod[4] then
											items[k] = { mod[4],mod[2] }
										else
											price = price + mod[2]
										end
									end
								end
							end
							if vRP.tryFullPayment(user_id,price) then
								if vname then
									local mPlaca = vRPclient.ModelName(player,7)
									local mPlacaUser = vRP.getUserByRegistration(mPlaca)
									if mPlacaUser then
										vRP.setSData("custom:u"..mPlacaUser.."veh_"..vname,json.encode(custom))
									end
									if price > 0 then
										TriggerClientEvent("Notify",source,"sucesso","Pagou <b>$"..vRP.format(parseInt(price)).." dólares</b>.")
									end
								end
							else
								vRPgarage.setVehicleMods(source,old_custom)
								TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
							end
						end
						vRP.openMenu(source,submenu)
					end

					local ch_mod = function(player,choice,mod)
						vRPgarage.scrollVehicleMods(source,kitems[choice],mod)
					end

					for k,v in pairs(mods) do
						if v[2] > 0 then
							subsubmenu[v[1]] = { ch_mod,"<text01>Valor:</text01> <text02>$"..parseInt(math.max(v[2],0)).."</text02>" }
						else
							subsubmenu[v[1]] = { ch_mod }
						end
						kitems[v[1]] = k
					end
					tosub = true
					vRP.openMenu(source,subsubmenu)
				end

				submenu["Modificações"] = { ch_mods }
				vRP.openMenu(source,submenu)
				end
			end }
		end
	end
	vRP.openMenu(source,menu)
end

local function build_garages(source)
	local source = source
	local user_id = vRP.getUserId(source)
	local address = vRP.getUserAddress(user_id)
	if user_id then
		if #address > 0 then
			for k,v in pairs(cfg.garages) do
				local i,x,y,z,x2,y2,z2,h,opac,pay = table.unpack(v)
				local g = cfg.garage_types[i]

				if g then
					for kk,vv in pairs(address) do
						local cfg = g._config
						if not cfg.ghome or cfg.ghome == vv.home then
							local garage_enter = function(player,area)
								if user_id and vRP.hasPermissions(user_id,cfg.permissions or {}) then
									openGarage(source,i,{x2,y2,z2},h,pay)
								end
							end

							local garage_leave = function(player,area)
								vRP.closeMenu(source)
							end

							vRPclient._addMarker(source,23,x,y,z-0.95,2,2,0.5,0,95,140,opac,100)
							vRP.setArea(source,"vRP:garage"..k,x,y,z,1.0,1.0,garage_enter,garage_leave)
						end
					end
				end
			end
		else
			for k,v in pairs(cfg.garages) do
				local i,x,y,z,x2,y2,z2,h,opac,pay = table.unpack(v)
				local g = cfg.garage_types[i]

				if g then
					local cfg = g._config
						if not cfg.ghome then
							local garage_enter = function(player,area)
							if user_id and vRP.hasPermissions(user_id,cfg.permissions or {}) then
								openGarage(source,i,{x2,y2,z2},h,pay)
							end
						end

						local garage_leave = function(player,area)
							vRP.closeMenu(source)
						end

						vRPclient._addMarker(source,23,x,y,z-0.95,2,2,0.5,0,95,140,opac,100)
						vRP.setArea(source,"vRP:garage"..k,x,y,z,1.0,1.0,garage_enter,garage_leave)
					end
				end
			end
		end
	end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		build_garages(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDER O VEÍCULO PARA OUTRO JOGADOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('vehs',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local menu = vRP.buildMenu("vehicle",{ user_id = user_id, player = source, vname = name })
		menu.name = "Veículos"

		local kitems = {}
		local choose = function(source,choice)
			local tosub = false
			local vehicle = choice
			local vname = kitems[vehicle]
			local submenu = { name = vehicle }
			submenu.onclose = function()
				tosub = false
				vRP.openMenu(source,menu)
			end

			local ch_sell = function(source,choice)
				local nplayer = vRPclient.getNearestPlayer(source,3)
				if nplayer then
					local tuser_id = vRP.getUserId(nplayer)
					local totalv = vRP.query("vRP/get_maxcars",{ user_id = tuser_id })
					if vRP.hasPermission(tuser_id,"bronze.permissao") then
						if parseInt(totalv[1].quantidade) >= totalgaragem + 1 then
							TriggerClientEvent("Notify",source,"importante","A pessoa atingiu o número máximo de veículos na garagem.")
							return
						end
					elseif vRP.hasPermission(tuser_id,"prata.permissao") then
						if parseInt(totalv[1].quantidade) >= totalgaragem + 3 then
							TriggerClientEvent("Notify",source,"importante","A pessoa atingiu o número máximo de veículos na garagem.")
							return
						end
					elseif vRP.hasPermission(tuser_id,"ouro.permissao") then
						if parseInt(totalv[1].quantidade) >= totalgaragem + 5 then
							TriggerClientEvent("Notify",source,"importante","A pessoa atingiu o número máximo de veículos na garagem.")
							return
						end
					elseif vRP.hasPermission(tuser_id,"platina.permissao") then
						if parseInt(totalv[1].quantidade) >= totalgaragem + 10 then
							TriggerClientEvent("Notify",source,"importante","A pessoa atingiu o número máximo de veículos na garagem.")
							return
						end
					else
						if parseInt(totalv[1].quantidade) >= totalgaragem then
							TriggerClientEvent("Notify",source,"importante","A pessoa atingiu o número máximo de veículos na garagem.")
							return
						end
					end
					local owned = vRP.query("vRP/get_vehicle",{ user_id = tuser_id, vehicle = vname })
					if #owned == 0 then
						local price = tonumber(sanitizeString(vRP.prompt(source,"Valor:",""),"\"[]{}+=?!_()#@%/\\|,.",false))
						local ok = vRP.request(nplayer,"Aceita comprar um <b>"..vehicle.."</b> por <b>$"..vRP.format(parseInt(price)).."</b> dólares?",30)
						if ok then
							if parseInt(price) > 0 then
								if vRP.tryFullPayment(tuser_id,parseInt(price)) then
									vRP.execute("vRP/move_vehicle",{ user_id = user_id, tuser_id = tuser_id, vehicle = vname })
									local data = vRP.getSData("custom:u"..user_id.."veh_"..vname)
									local custom = json.decode(data)
									vRP.setSData("custom:u"..tuser_id.."veh_"..vname, json.encode(custom))
									vRP.setSData("custom:u"..user_id.."veh_"..vname, json.encode())
									vRP.giveMoney(user_id,parseInt(price))
									TriggerClientEvent("Notify",nplayer,"sucesso","Pagou <b>$"..vRP.format(parseInt(price)).." dólares</b>.")
									TriggerClientEvent("Notify",source,"sucesso","Recebeu <b>$"..vRP.format(parseInt(price)).." dólares</b>.")
								else
									TriggerClientEvent("Notify",nplayer,"negado","Dinheiro insuficiente.")
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							end
						end
					else
						TriggerClientEvent("Notify",nplayer,"importante","Veículo ja possuído.")
						TriggerClientEvent("Notify",source,"importante","Veículo ja possuído.")
					end
				end
			end
			submenu["Vender"] = { ch_sell }
			tosub = true
			vRP.openMenu(source,submenu)
		end

		local choosedetido = function(source,choice)
			TriggerClientEvent("Notify",source,"importante","Veículo roubado ou detido pela policia, acione a seguradora.")
		end

		local pvehicles = vRP.query("vRP/get_vehicles",{ user_id = user_id })
		for k,v in pairs(pvehicles) do
			local vehicle
			for x,garage in pairs(garage_types) do
				vehicle = garage[v.vehicle]
				if vehicle then break end
			end

			if vehicle then
				local rows = vRP.query("vRP/get_detido",{ user_id = user_id, vehicle = v.vehicle })
				if parseInt(rows[1].detido) <= 0 then
					menu[vehicle[1]] = { choose }
				else
					menu[vehicle[1]] = { choosedetido }
				end
				kitems[vehicle[1]] = v.vehicle
			end
		end

		vRP.openMenu(source,menu)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOTÃO L PARA TRANCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("buttonLock")
AddEventHandler("buttonLock",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local mPlaca = vRPclient.ModelName(source,7)
	local mPlacaUser = vRP.getUserByRegistration(mPlaca)
	if user_id == mPlacaUser then
		vRPgarage.toggleLock(source)
		TriggerClientEvent("vrp_sound:source",source,'lock',0.1)
	end
end)

RegisterServerEvent("tryLock")
AddEventHandler("tryLock",function(nveh)
	TriggerClientEvent("syncLock",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOTÃO PAGEUP PARA ABRIR PORTA-MALAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("buttonTrunk")
AddEventHandler("buttonTrunk",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local mPlaca,mName,mNet,mPrice,mBanido,mLock = vRPclient.ModelName(source,7)
	if not mLock then
		if mPlaca then
			if mName then
				if mBanido then
					TriggerClientEvent("Notify",source,"negado","Veículos de serviço ou alugados não podem utilizar o Porta-Malas.")
					return
				end
				local mPlacaUser = vRP.getUserByRegistration(mPlaca)
				if mPlacaUser then
					local chestname = "u"..mPlacaUser.."veh_"..string.lower(mName)
					local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(mName)] or 50

					local cb_out = function(idname,amount)
						if parseInt(amount) > 0 then
							TriggerClientEvent("Notify",source,"sucesso","Retirado <b>"..amount.."x "..vRP.getItemName(idname).."</b>.")
						end
					end

					local cb_in = function(idname,amount)
						if parseInt(amount) > 0 then
							TriggerClientEvent("Notify",source,"sucesso","Colocado <b>"..amount.."x "..vRP.getItemName(idname).."</b>.")
						end
					end

					vRPgarage.toggleTrunk(source)
					vRP.openChest(source,chestname,max_weight,function()
						vRPgarage.toggleTrunk(source)
					end,cb_in,cb_out)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANCORAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ancorar',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local mPlaca = vRPclient.ModelName(source,7)
	local mPlacaUser = vRP.getUserByRegistration(mPlaca)
	if user_id == mPlacaUser then
		vRPgarage.toggleAnchor(source)
	end
end)