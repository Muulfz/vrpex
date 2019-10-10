local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPNserver = Tunnel.getInterface("vrp_identidade")
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
local css = [[
	.div_registro {
		background: rgba(15,15,15,0.7);
		color: #999;
		bottom: 9%;
		right: 2.2%;
		position: absolute;
		padding: 20px 30px;
		font-family: Arial;
		line-height: 30px;
		border-right: 3px solid #13c52b;
		letter-spacing: 1.7px;
		border-radius: 10px;
	}
	.div_registro b {
		color: #13c52b;
		padding: 0 4px 0 0;
	}
]]

local identity = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,344) and GetEntityHealth(PlayerPedId()) > 100 then
			if identity then
				vRP._removeDiv("registro")
				identity = false
			else
				local carteira,banco,nome,sobrenome,user_id,identidade,idade,telefone,multas,paypal = vRPNserver.Identidade()
				if parseInt(multas) > 0 then
					vRP._setDiv("registro",css,"<b>Passaporte:</b> "..user_id.."<br><b>Nome:</b> "..nome.." "..sobrenome.."<br><b>Identidade:</b> "..identidade.."<br><b>Telefone:</b> "..telefone.."<br><b>Carteira:</b> "..carteira.."<br><b>Banco:</b> "..banco.."<br><b>Paypal:</b> "..paypal.."<br><b>Multas Pendentes:</b> "..multas)
				else
					vRP._setDiv("registro",css,"<b>Passaporte:</b> "..user_id.."<br><b>Nome:</b> "..nome.." "..sobrenome.."<br><b>Identidade:</b> "..identidade.."<br><b>Telefone:</b> "..telefone.."<br><b>Carteira:</b> "..carteira.."<br><b>Banco:</b> "..banco.."<br><b>Paypal:</b> "..paypal)
				end
				identity = true
			end
		end
	end
end)