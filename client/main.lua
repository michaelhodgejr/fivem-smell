-- The current smell associated with the playre
local currentSmell = nil

-- A table of players already notified for the current smell
local notifiedPlayers = {}

-- The distance to with the smell:notify event will occur
local  notificationDistance = 3

RegisterNetEvent("smell:set")
AddEventHandler("smell:set", function(smell)
  TriggerEvent('chatMessage', "SMELL", {200,0,0} , "Smell Set!")
  currentSmell = smell
  notifiedPlayers = {}
end)

RegisterNetEvent("smell:get")
AddEventHandler("smell:get", function(test)
  if currentSmell == nil then
    TriggerEvent('chatMessage', "SMELL", {200,0,0} , "You have no smell set for your character.")
  else
    TriggerEvent('chatMessage', "SMELL", {200,0,0} , "You smell like " .. currentSmell)
  end
end)

RegisterNetEvent("smell:notify")
AddEventHandler("smell:notify", function(smell)
  SetNotificationTextEntry('STRING');
  AddTextComponentString("You notice the smell of " .. smell .. " on a nearby player");
  DrawNotification(false, true);
end)

RegisterNetEvent("smell:clear")
AddEventHandler("smell:clear", function()
  currentSmell = nil
  TriggerEvent('chatMessage', "SMELL", {200,0,0} , "Your smell has been removed")
end)


Citizen.CreateThread(function()
  while true do
    if currentSmell ~= nil then
      local players = GetNearbyPlayers(notificationDistance)

      for index,player in ipairs(players) do

        local playerId = GetPlayerServerId(player)

        if has_value(notifiedPlayers, playerId) then
          playerHasNotBeenNotified = false
        else
          playerHasNotBeenNotified = true
        end

        if shouldNotifyPlayer(currentSmell, player) and playerHasNotBeenNotified then
          TriggerServerEvent('smell:notifyPlayer', playerId, currentSmell)
          table.insert(notifiedPlayers, playerId)
        end
      end

      Citizen.Wait(5000)
    end
  end
end)

--[[
  Determines if the client should notify the closestPlayer about their current
  smell status

  Params
  currentSmell
    string (or nil) the players current smell
  playerId
    integer ID of the closest player

  Notes

  This method will return true if any of the following conditions exist
     The player has a current smell AND
     (
       Both the currentPlayer and the closestPlayer are not in their vehicles OR
       The current player is in their vehicle and the closestPlayer is not
     )
]]
function shouldNotifyPlayer(currentSmell, playerId)
  if currentSmell == nil then
    return false
  end

  ply = GetPlayerPed(playerId)

  if IsPedInAnyVehicle(ply, true) then
    closestPlayerInVehicle = true
  else
    closestPlayerInVehicle = false
  end

  if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
    isPlayerInVehicle = true
  else
    isPlayerInVehicle = false
  end

  if closestPlayerInVehicle == false and isPlayerInVehicle == false then
    return true
  end

  if isPlayerInVehicle and closestPlayerInVehicle == false then
    return true
  end

  return false
end

--[[
  Determines which players connected to the server are within range of the
  current player

  Returns
    returnablePlayers
      table - list of player ids within the distance of the player
]]
function GetNearbyPlayers(distance)
  local players = GetPlayers()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local returnablePlayers = {}

  for index,value in ipairs(players) do
    local target = GetPlayerPed(value)
    if(target ~= ply) then
      local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
      local player_distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
      if(distance > player_distance) then
        table.insert(returnablePlayers, value)
      end
    end
  end

  return returnablePlayers
end

--[[
  Gets a list of current players on the server

  Returns
    Table
]]
function GetPlayers()
  local players = {}

  for i = 0, 31 do
    if NetworkIsPlayerActive(i) then
      table.insert(players, i)
    end
  end

  return players
end

--[[
  Determines if a table has a value in it

  Params
    tab - Table
    val - value to search

  Returns
    boolean
]]
function has_value (tab, val)
  for index, value in ipairs(tab) do
    if value == val then
        return true
    end
  end

  return false
end
