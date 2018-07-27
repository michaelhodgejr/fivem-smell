local currentSmell = nil
local notifiedPlayers = {}

RegisterNetEvent("smell:set")
AddEventHandler("smell:set", function(smell)
  TriggerEvent('chatMessage', "System", {200,0,0} , "Smell Set!")
  currentSmell = smell
  notifiedPlayers = {}
end)

RegisterNetEvent("smell:get")
AddEventHandler("smell:get", function(test)
  if currentSmell == nil then
    TriggerEvent('chatMessage', "System", {200,0,0} , "You have no smell")
  else
    TriggerEvent('chatMessage', "System", {200,0,0} , "You smell like " .. currentSmell)
  end
end)

RegisterNetEvent("smell:notify")
AddEventHandler("smell:notify", function(smell)
  TriggerEvent('chatMessage', "System", {200,0,0} , "You notice the smell of " .. smell .. " on a nearby player.")
end)

RegisterNetEvent("smell:clear")
AddEventHandler("smell:clear", function()
  currentSmell = nil
  TriggerEvent('chatMessage', "System", {200,0,0} , "Your smell has been removed")
end)


Citizen.CreateThread(function()
  while true do
    local closestPlayerHandle, distance = GetClosestPlayer()

    if closestPlayerHandle ~= nil or closestPlayerHandle ~= -1 then

      local playerId = GetPlayerServerId(closestPlayerHandle)

      if has_value(notifiedPlayers, playerId) then
        playerHasNotBeenNotified = false
      else
        playerHasNotBeenNotified = true
      end

      if shouldNotifyPlayer(distance, currentSmell, closestPlayerHandle) and playerHasNotBeenNotified then
        TriggerServerEvent('smell:notifyPlayer', playerId, currentSmell)
        table.insert(notifiedPlayers, playerId)
      end
    end

    Citizen.Wait(1000)
  end
end)

--[[
  Determines if the client should notify the closestPlayer about their current
  smell status

  Params
    distance
    integer distance from the player
  currentSmell
    string (or nil) the players current smell
  playerId
    integer ID of the closest player

  Notes

  This method will return true if any of the following conditions exist
     The player has a current smell AND
     The distance is less than the value defined (defaults to 3) AND
     (
       Both the currentPlayer and the closestPlayer are not in their vehicles OR
       The current player is in their vehicle and the cloestPlayer is not
     )
]]
function shouldNotifyPlayer(distance, currentSmell, playerId)
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

  if distance < 3 then
    distanceMet = true
  else
    distanceMet = false
  end

  if closestPlayerInVehicle == false and isPlayerInVehicle == false and distanceMet then
    return true
  end

  if isPlayerInVehicle and closestPlayerInVehicle == false then
    return true
  end

  return false
end

--[[
  Determines which player connected to the server is closest to the
  current player

  Returns
    closestPlayer
    integer ID of the player
  distance
    float distance from current player
]]
function GetClosestPlayer()
  local players = GetPlayers()
  local closestDistance = -1
  local closestPlayer = -1
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)

  for index,value in ipairs(players) do
    local target = GetPlayerPed(value)
    if(target ~= ply) then
      local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
      local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
      if(closestDistance == -1 or closestDistance > distance) then
        closestPlayer = value
        closestDistance = distance
      end
    end
  end

  return closestPlayer, closestDistance
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
