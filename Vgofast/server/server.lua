ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent("vgofast:lspd")
AddEventHandler("vgofast:lspd", function()
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
          if xPlayer.job.name == 'police' then
               Citizen.Wait(0)
               TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Poucave', '~b~Message Important', 'Un Gofast est en cours, faites le nécéssaire', 'CHAR_WADE', 7) 
		end
	end
end)

RegisterServerEvent("vgofast:venteduvehicle")
AddEventHandler("vgofast:venteduvehicle", function()
     local xPlayer = ESX.GetPlayerFromId(source)
     local prix = 25000
     xPlayer.addAccountMoney('black_money', prix)
     TriggerClientEvent('esx:showAdvancedNotification', source, 'GoFast', '~r~Inconnu', '~w~C est une bonne affaire, Tiens ! ~r~'..prix..'$', 'CHAR_MALC', 3)
     TriggerClientEvent('esx:showAdvancedNotification', source, 'GoFast', '~r~Inconnu', '~w~Hesite pas a aller blanchir ton argent ;)', 'CHAR_MALC', 3)
end)