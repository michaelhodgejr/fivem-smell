RegisterCommand('setsmell', function(source, args)
  TriggerClientEvent('smell:set', source, args[1])
end)

RegisterCommand('smell', function(source, args)
  TriggerClientEvent('smell:get', source)
end)

RegisterCommand('clearsmell', function(source, args)
  TriggerClientEvent('smell:clear', source)
end)

RegisterServerEvent('smell:notifyPlayer')
AddEventHandler('smell:notifyPlayer', function(player, smell)
  TriggerClientEvent('smell:notify', player, smell)
end)
