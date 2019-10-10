local Config = {}

-- 100 = Admin
-- 80 = Platina
-- 60 = Ouro
-- 40 = Prata
-- 20 = Bronze

Config.Priority = {
	["steam:110000112b2556e"] = 100, -- SUMMERZ
	["steam:1100001064a24a9"] = 100, -- MINNIE
	["steam:1100001061540ce"] = 100, -- MIYA
	["steam:1100001176c1519"] = 100, -- OLAVO
	["steam:1100001178b17d3"] = 100, -- CAIO
	["steam:11000010f172344"] = 80, -- 24
	["steam:11000011290dbaf"] = 80, -- 38
	["steam:11000010ab5cc40"] = 80, -- 179
	["steam:1100001176fe3d9"] = 80, -- 96
	["steam:110000103bb19a2"] = 80, -- 53
	["steam:110000132e017cb"] = 80, -- 61
	["steam:11000010d426281"] = 80, -- 265
	["steam:110000135e5778c"] = 80, -- 131
	["steam:110000102e747e3"] = 80, -- 731
	["steam:1100001162d6a1a"] = 80, -- 36
	["steam:11000010f83dfd0"] = 80, -- 33
	["steam:110000119a6f03e"] = 80, -- 677
	["steam:110000105950212"] = 80, -- 92
	["steam:11000011468afe9"] = 80, -- 100
	["steam:1100001034235ca"] = 80, -- 715
	["steam:11000011618c165"] = 80, -- 326
	["steam:110000101f41632"] = 80, -- 44
	["steam:11000011982d080"] = 80, -- 941
	["steam:11000010e23c8f5"] = 80, -- 327
	["steam:11000011a795829"] = 80, -- 815
	["steam:11000011a4b7a4d"] = 80, -- 196
	["steam:11000010c6fece6"] = 80, -- 136
	["steam:110000104043f8f"] = 80, -- 82
	["steam:110000110a01802"] = 80, -- 861
	["steam:1100001093250c0"] = 60, -- 770
	["steam:11000010cf3564e"] = 60, -- 293
	["steam:11000010a8db787"] = 60, -- 589
	["steam:1100001070a8dfd"] = 60, -- 80
	["steam:11000010a1a6be3"] = 60, -- 35
	["steam:11000010651fa21"] = 40, -- 3
	["steam:110000109650c06"] = 40, -- 641
	["steam:11000010ce0b649"] = 40, -- 123
	["steam:11000010e22a13d"] = 20, -- 15
	["steam:11000010bcc87e8"] = 20, -- 448
	["steam:110000118ac43c5"] = 20, -- 41
	["steam:11000010bcc87e8"] = 20, -- 448
	["steam:1100001095b65a0"] = 20, -- 63
	["steam:1100001121b105b"] = 20 -- 1040
}

Config.RequireSteam = true
Config.PriorityOnly = false

Config.IsBanned = function(src,callback)
	callback(false)
end

Config.Language = {
	joining = "Entrando...",
	connecting = "Conectando...",
	err = "Não foi possível identificar sua Steam ou Social Club.",
	_err = "Você foi desconectado por demorar demais na fila.",
	pos = "Você é o %d/%d da fila, aguarde sua conexão",
	connectingerr = "Não foi possível adiciona-lo na fila.",
    wlonly = "Você não está aprovado na whitelist.",
	banned = "Seu passaporte foi revogado na cidade.",
	steam = "Você precisa estar com a Steam aberta para conectar."
}

local Queue = {}
Queue.QueueList = {}
Queue.PlayerList = {}
Queue.PlayerCount = 0
Queue.Priority = {}
Queue.Connecting = {}
Queue.ThreadCount = 0

local debug = false
local displayQueue = false
local initHostName = false
local maxPlayers = 32

local tostring = tostring
local tonumber = tonumber
local ipairs = ipairs
local pairs = pairs
local string_sub = string.sub
local string_format = string.format
local string_lower = string.lower
local math_abs = math.abs
local math_floor = math.floor
local os_time = os.time
local table_insert = table.insert
local table_remove = table.remove

for k,v in pairs(Config.Priority) do
	Queue.Priority[string_lower(k)] = v
end

function Queue:HexIdToSteamId(hexId)
	local cid = math_floor(tonumber(string_sub(hexId, 7), 16))
	local steam64 = math_floor(tonumber(string_sub( cid, 2)))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math_floor(math_abs(6561197960265728 - steam64 - a) / 2)
	local sid = "steam_0:"..a..":"..(a == 1 and b -1 or b)
	return sid
end

function Queue:IsSteamRunning(src)
	for k,v in ipairs(GetPlayerIdentifiers(src)) do
		if string.sub(v,1,5) == "steam" then
			return true
		end
	end
	return false
end

function Queue:IsInQueue(ids,rtnTbl,bySource,connecting)
	for genericKey1,genericValue1 in ipairs(connecting and self.Connecting or self.QueueList) do
		local inQueue = false

		if not bySource then
			for genericKey2,genericValue2 in ipairs(genericValue1.ids) do
				if inQueue then break end

				for genericKey3,genericValue3 in ipairs(ids) do
					if genericValue3 == genericValue2 then inQueue = true break end
				end
			end
		else
			inQueue = ids == genericValue1.source
		end

		if inQueue then
			if rtnTbl then
				return genericKey1, connecting and self.Connecting[genericKey1] or self.QueueList[genericKey1]
			end

			return true
		end
	end
	return false
end

function Queue:IsPriority(ids)
	for k,v in ipairs(ids) do
		v = string_lower(v)

		if string_sub(v,1,5) == "steam" and not self.Priority[v] then
			local steamid = self:HexIdToSteamId(v)
			if self.Priority[steamid] then
				return self.Priority[steamid] ~= nil and self.Priority[steamid] or false
			end
		end

		if self.Priority[v] then
			return self.Priority[v] ~= nil and self.Priority[v] or false
		end
	end
end

function Queue:AddToQueue(ids,connectTime,name,src,deferrals)
	if self:IsInQueue(ids) then
		return
	end

	local tmp = {
		source = src,
		ids = ids,
		name = name,
		firstconnect = connectTime,
		priority = self:IsPriority(ids) or (src == "debug" and math.random(0,15)),
		timeout = 0,
		deferrals = deferrals
	}

	local _pos = false
	local queueCount = self:GetSize() + 1

	for k,v in ipairs(self.QueueList) do
		if tmp.priority then
			if not v.priority then
				_pos = k
			else
				if tmp.priority > v.priority then
					_pos = k
				end
			end
			if _pos then
				break
			end
		end
	end

	if not _pos then
		_pos = self:GetSize() + 1
	end

	table_insert(self.QueueList,_pos,tmp)
end

function Queue:RemoveFromQueue(ids,bySource)
	if self:IsInQueue(ids,false,bySource) then
		local pos, data = self:IsInQueue(ids,true,bySource)
		table_remove(self.QueueList,pos)
	end
end

function Queue:GetSize()
	return #self.QueueList
end

function Queue:ConnectingSize()
	return #self.Connecting
end

function Queue:IsInConnecting(ids,bySource,refresh)
	local inConnecting,tbl = self:IsInQueue(ids,refresh and true or false,bySource and true or false,true)

	if not inConnecting then
		return false
	end

	if refresh and inConnecting and tbl then
		self.Connecting[inConnecting].timeout = 0
	end
	return true
end

function Queue:RemoveFromConnecting(ids,bySource)
	for k,v in ipairs(self.Connecting) do
		local inConnecting = false

		if not bySource then
			for i,j in ipairs(v.ids) do
				if inConnecting then
					break
				end

				for q,e in ipairs(ids) do
					if e == j then inConnecting = true break end
				end
			end
		else
			inConnecting = ids == v.source
		end

		if inConnecting then
			table_remove(self.Connecting,k)
			return true
		end
	end
	return false
end

function Queue:AddToConnecting(ids,ignorePos,autoRemove,done)
	local function removeFromQueue()
	if not autoRemove then
		return
	end

	done(Config.Language.connectingerr)
		self:RemoveFromConnecting(ids)
		self:RemoveFromQueue(ids)
	end

	if self:ConnectingSize() >= 5 then
		removeFromQueue()
		return false
	end

	if ids[1] == "debug" then
		table_insert(self.Connecting,{ source = ids[1], ids = ids, name = ids[1], firstconnect = ids[1], priority = ids[1], timeout = 0 })
		return true
	end

	if self:IsInConnecting(ids) then
		self:RemoveFromConnecting(ids)
	end

	local pos,data = self:IsInQueue(ids,true)
	if not ignorePos and (not pos or pos > 1) then
		removeFromQueue()
		return false
	end

	table_insert(self.Connecting,data)
	self:RemoveFromQueue(ids)
	return true
end

function Queue:GetIds(src)
	local ids = GetPlayerIdentifiers(src)
	local ip = GetPlayerEndpoint(src)

	ids = (ids and ids[1]) and ids or (ip and {"ip:" .. ip} or false)
	ids = ids ~= nil and ids or false

	if ids and #ids > 1 then
		for k,v in ipairs(ids) do
			if string.sub(v, 1, 3) == "ip:" then table_remove(ids, k) end
		end
	end

	return ids
end

function Queue:AddPriority(id,power)
	if not id then return false end

	if type(id) == "table" then
		for k, v in pairs(id) do
			if k and type(k) == "string" and v and type(v) == "number" then
				self.Priority[k] = v
			else
				return false
			end
		end

		return true
	end

	power = (power and type(power) == "number") and power or 10
	self.Priority[string_lower(id)] = power

	return true
end

function Queue:RemovePriority(id)
	if not id then
		return false
	end
	self.Priority[id] = nil
	return true
end

function Queue:UpdatePosData(src,ids,deferrals)
	local pos,data = self:IsInQueue(ids,true)
	self.QueueList[pos].source = src
	self.QueueList[pos].ids = ids
	self.QueueList[pos].timeout = 0
	self.QueueList[pos].deferrals = deferrals
end

function Queue:NotFull(firstJoin)
	local canJoin = self.PlayerCount + self:ConnectingSize() < maxPlayers and self:ConnectingSize() < 5
	if firstJoin and canJoin then
		canJoin = self:GetSize() <= 1
	end
	return canJoin
end

function Queue:SetPos(ids,newPos)
	local pos,data = self:IsInQueue(ids,true)
	table_remove(self.QueueList,pos)
	table_insert(self.QueueList,newPos,data)
end

function AddPriority(id,power)
	return Queue:AddPriority(id,power)
end

function RemovePriority(id)
	return Queue:RemovePriority(id)
end

Citizen.CreateThread(function()
	local function playerConnect(name,setKickReason,deferrals)
		debug = GetConvar("sv_debugqueue", "true") == "true" and true or false
		displayQueue = GetConvar("sv_displayqueue", "true") == "true" and true or false
		initHostName = not initHostName and GetConvar("sv_hostname") or initHostName

		local src = source
		local ids = Queue:GetIds(src)
		local connectTime = os_time()
		local connecting = true

		deferrals.defer()

		Citizen.CreateThread(function()
			while connecting do
				Citizen.Wait(500)
				if not connecting then
					return
				end
				deferrals.update(Config.Language.connecting)
			end
		end)

		Citizen.Wait(1000)

		local function done(msg)
			connecting = false
			Citizen.CreateThread(function()
				if msg then
					deferrals.update(tostring(msg) and tostring(msg) or "")
				end

				Citizen.Wait(1000)

				if msg then
					deferrals.done(tostring(msg) and tostring(msg) or "")
					CancelEvent()
				end
			end)
		end

		local function update(msg)
			connecting = false
			deferrals.update(tostring(msg) and tostring(msg) or "")
		end

		if not ids then
			done(Config.Language.err)
			CancelEvent()
			return
		end

		if Config.RequireSteam and not Queue:IsSteamRunning(src) then
			done(Config.Language.steam)
			CancelEvent()
			return
		end

		local banned

		Config.IsBanned(src,function(_banned,_reason)
			banned = _banned
			_reason = _reason and tostring(_reason) or ""

			if _banned then
				done(string.format(Config.Language.banned, _reason and _reason or "Unknown"))
				Queue:RemoveFromQueue(ids)
				Queue:RemoveFromConnecting(ids)
			end
		end)

		while banned == nil do Citizen.Wait(1) end
		if banned then
			CancelEvent()
			return
		end

		local reason = "You were kicked from joining the queue"

		local function setReason(msg)
			reason = tostring(msg)
		end

		TriggerEvent("queue:playerJoinQueue", src, setReason)

		if WasEventCanceled() then
			done(reason)

			Queue:RemoveFromQueue(ids)
			Queue:RemoveFromConnecting(ids)

			CancelEvent()
			return
		end

		if Config.PriorityOnly and not Queue:IsPriority(ids) then
			done(Config.Language.wlonly)
			return
		end

		local rejoined = false

		if Queue:IsInQueue(ids) then
			rejoined = true
			Queue:UpdatePosData(src,ids,deferrals)
		else
			Queue:AddToQueue(ids,connectTime,name,src,deferrals)
		end

		if Queue:IsInConnecting(ids,false,true) then
			Queue:RemoveFromConnecting(ids)

			if Queue:NotFull() then
				local added = Queue:AddToConnecting(ids,true,true,done)
				if not added then
					CancelEvent()
					return
				end

				done()
				TriggerEvent("queue:playerConnecting",src,ids,name,setKickReason,deferrals)

				return
			else
				Queue:AddToQueue(ids,connectTime,name,src,deferrals)
				Queue:SetPos(ids,1)
			end
		end

		local pos,data = Queue:IsInQueue(ids,true)

		if not pos or not data then
			done(Config.Language._err)
			RemoveFromQueue(ids)
			RemoveFromConnecting(ids)
			CancelEvent()
			return
		end

		if Queue:NotFull(true) then
			local added = Queue:AddToConnecting(ids,true,true,done)
			if not added then
				CancelEvent()
				return
			end

			done()

			TriggerEvent("queue:playerConnecting",src,ids,name,setKickReason,deferrals)

			return
		end

		update(string_format(Config.Language.pos,pos,Queue:GetSize()))

		Citizen.CreateThread(function()
			if rejoined then
				return
			end

			Queue.ThreadCount = Queue.ThreadCount + 1
			local dotCount = 0

			while true do
				Citizen.Wait(1000)
				local dots = ""

				dotCount = dotCount + 1
				if dotCount > 3 then
					dotCount = 0
				end

				for i = 1,dotCount do dots = dots .. "." end

				local pos,data = Queue:IsInQueue(ids,true)

				if not pos or not data then
					if data and data.deferrals then
						data.deferrals.done(Config.Language._err)
					end
					CancelEvent()
					Queue:RemoveFromQueue(ids)
					Queue:RemoveFromConnecting(ids)
					Queue.ThreadCount = Queue.ThreadCount - 1
					return
				end

				if pos <= 1 and Queue:NotFull() then
					local added = Queue:AddToConnecting(ids)
					data.deferrals.update(Config.Language.joining)
					Citizen.Wait(500)

					if not added then
						data.deferrals.done(Config.Language.connectingerr)
						CancelEvent()
						Queue.ThreadCount = Queue.ThreadCount - 1
						return
					end

					data.deferrals.update("Loading into server")

					Queue:RemoveFromQueue(ids)
					Queue.ThreadCount = Queue.ThreadCount - 1

					TriggerEvent("queue:playerConnecting",data.source,data.ids,name,setKickReason,data.deferrals)
					
					return
				end

				local msg = string_format("Creative Roleplay\n\n"..Config.Language.pos.."%s\nEvite punições, fique por dentro das regras de conduta.\nAtualizações frequentes, deixe sua sugestão em nosso discord.",pos,Queue:GetSize(),dots)
				data.deferrals.update(msg)
			end
		end)
	end

	AddEventHandler("playerConnecting",playerConnect)

	local function checkTimeOuts()
		local i = 1
		while i <= Queue:GetSize() do
			local data = Queue.QueueList[i]
			local lastMsg = GetPlayerLastMsg(data.source)

			if lastMsg == 0 or lastMsg >= 30000 then
				data.timeout = data.timeout + 1
			else
				data.timeout = 0
			end

			if not data.ids or not data.name or not data.firstconnect or data.priority == nil or not data.source then
				data.deferrals.done(Config.Language._err)
				table_remove(Queue.QueueList, i)
			elseif (data.timeout >= 120) and data.source ~= "debug" and os_time() - data.firstconnect > 5 then
				data.deferrals.done(Config.Language._err)
				Queue:RemoveFromQueue(data.source,true)
				Queue:RemoveFromConnecting(data.source,true)
			else
				i = i + 1
			end
		end

		i = 1

		while i <= Queue:ConnectingSize() do
			local data = Queue.Connecting[i]
			local lastMsg = GetPlayerLastMsg(data.source)
			data.timeout = data.timeout + 1

			if ((data.timeout >= 300 and lastMsg >= 35000) or data.timeout >= 340) and data.source ~= "debug" and os_time() - data.firstconnect > 5 then
				Queue:RemoveFromQueue(data.source, true)
				Queue:RemoveFromConnecting(data.source, true)
			else
				i = i + 1
			end
		end

		local qCount = Queue:GetSize()

		if displayQueue and initHostName then
			SetConvar("sv_hostname",(qCount > 0 and "[" .. tostring(qCount) .. "] " or "") .. initHostName)
		end

		SetTimeout(1000,checkTimeOuts)
	end
	checkTimeOuts()
end)

local function playerActivated()
	local src = source
	local ids = Queue:GetIds(src)

	if not Queue.PlayerList[src] then
		Queue.PlayerCount = Queue.PlayerCount + 1
		Queue.PlayerList[src] = true
		Queue:RemoveFromQueue(ids)
		Queue:RemoveFromConnecting(ids)
	end
end

RegisterServerEvent("Queue:playerActivated")
AddEventHandler("Queue:playerActivated",playerActivated)

local function playerDropped()
	local src = source
	local ids = Queue:GetIds(src)

	if Queue.PlayerList[src] then
		Queue.PlayerCount = Queue.PlayerCount - 1
		Queue.PlayerList[src] = nil
		Queue:RemoveFromQueue(ids)
		Queue:RemoveFromConnecting(ids)
	end
end

AddEventHandler("playerDropped",playerDropped)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if exports and exports.connectqueue then
			TriggerEvent("queue:onReady")
			return
		end
	end
end)

AddEventHandler("queue:playerConnectingRemoveQueues",function(ids)
	Queue:RemoveFromQueue(ids)
	Queue:RemoveFromConnecting(ids)
end)

AddEventHandler("onResourceStop", function(resource)
	if displayQueue and resource == GetCurrentResourceName() then
		SetConvar("sv_hostname", initHostName)
	end
end)