ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory
local qs_inventory = exports['qs-inventory']
Discord_url = "https://ptb.discord.com/api/webhooks/1179835780617740340/pIiLwh4w4kw7l12H0V_9ZcI5ctmt6-tlU8DzhcqOeUUe9dgp0Em66gtjKoGujlvY4chS"

RegisterNetEvent('Evidence:createInventory')
AddEventHandler('Evidence:createInventory', function(evidenceID)
  local xPlayer = ESX.GetPlayerFromId(source)
  local name = xPlayer.getName()
  local id = evidenceID
  local label = evidenceID  
  local slots = Config.slots
  local maxWeight = Config.weight
  if Config.Inv == 'ox' then
      ox_inventory:RegisterStash(id, label, slots, maxWeight,nil)
  elseif Config.Inv == 'qs' then
      qs_inventory:RegisterStash(source, id, slots, maxWeight)
  end
  sendCreateDiscord(source, name, "Created Evidence", evidenceID)
end)

ESX.RegisterServerCallback('Evidence:getInventory', function(source, cb, evidenceID)
  local inv = exports['qs-inventory']:GetInventory(evidenceID, false)

  if not inv then
      local source = source
      local lockerID = evidenceID
      local slots = Config.slots
      local weight = Config.weight

      exports['qs-inventory']:RegisterStash(source, lockerID, slots, weight)

      inv = true
  end

  if inv then
      cb(true)
  else
      cb(false)
  end
end)

-- RegisterNetEvent('Evidence:deleteEvidence')
-- AddEventHandler('Evidence:deleteEvidence', function(evidenceID)
-- end)

RegisterNetEvent('Evidence:createLocker')
AddEventHandler('Evidence:createLocker', function(lockerID)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()
    local id = lockerID
    local label = lockerID  
    local slots = 25 
    local maxWeight = 5000 
    
    if Config.Inv == 'ox' then
      ox_inventory:RegisterStash(id, label, slots, maxWeight,nil)
    elseif Config.Inv == 'qs' then
      qs_inventory:RegisterStash(source, id, slots, maxWeight)
    end
    sendCreateDiscord(source, name, "Created Locker",label)
end)

ESX.RegisterServerCallback('Evidence:getOtherInventories', function(source, cb, Otherlocker)
  local inv = exports['qs-inventory']:GetInventory(Otherlocker, false)

  if not inv and exports['qs-inventory'] then
      local source = source
      local lockerID = Otherlocker
      local slots = Config.slots
      local weight = Config.weight

      exports['qs-inventory']:RegisterStash(source, lockerID, slots, weight)

      inv = true
  end

  if inv then
      cb(true)
  else
      cb(false)
  end
end)

RegisterNetEvent('Evidence:createOtherLocker')
AddEventHandler('Evidence:createOtherLocker', function(OtherlockerID)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()
    local id = OtherlockerID  
    local label = OtherlockerID  
    local slots = 25 
    local maxWeight = 5000 
    
    if Config.Inv == 'ox' then
      ox_inventory:RegisterStash(id, label, slots, maxWeight,nil)
    elseif Config.Inv == 'qs' then
      qs_inventory:RegisterStash(source, id, slots, maxWeight)
    end
    sendCreateDiscord(source, name, "Created Job Locker",label)
end)

ESX.RegisterServerCallback('Evidence:getLocker', function(source, cb, lockerID)
  local inv = exports['qs-inventory']:GetInventory(lockerID, false)

  if not inv and exports['qs-inventory'] then
      local source = source
      local slots = Config.slots
      local weight = Config.weight

      exports['qs-inventory']:RegisterStash(source, lockerID, slots, weight)

      inv = true
  end

  if inv then
      cb(true)
  else
      cb(false)
  end
end)

RegisterNetEvent('Evidence:deleteLocker')
AddEventHandler('Evidence:deleteLocker', function(lockerID)
  print(string.format("deleting locker for identifier '%s'",lockerID))
end)

sendDeleteDiscord = function(color, name, message, footer)
  local embed = {
        {
            ["color"] = 3085967,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer,
            },
            ["author"] = {
              ["name"] = 'Made by | J.C.',
              ['icon_url'] = 'https://media.discordapp.net/attachments/1160098579302592602/1160098929552138340/f26cdcfaaf820e21a00aaaa9590bfe20.webp?ex=657406d2&is=656191d2&hm=c4e494d244c3084282dc8d9f8ccff05e8a0709ac7beb4202241b74a002f20e38&=&format=webp'
            }
        }
    }

  PerformHttpRequest(Discord_url, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

sendCreateDiscord = function(color, name, message, footer)
  local embed = {
        {
            ["color"] = 3085967,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer,
            },
            ["author"] = {
              ["name"] = 'Made by | J.C.',
              ['icon_url'] = 'https://media.discordapp.net/attachments/1160098579302592602/1160098929552138340/f26cdcfaaf820e21a00aaaa9590bfe20.webp?ex=657406d2&is=656191d2&hm=c4e494d244c3084282dc8d9f8ccff05e8a0709ac7beb4202241b74a002f20e38&=&format=webp'
            }
        }
    }

  PerformHttpRequest(Discord_url, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('Evidence:getPlayerName', function(source,cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.fetchAll('SELECT `firstname`,`lastname` FROM `users` WHERE `identifier` = @identifier',{
      ['@identifier'] = xPlayer.identifier}, 
    function(results)
      if results[1] then
        local data = {
          firstname = results[1].firstname,
          lastname  = results[1].lastname,
        }
        cb(data)
      else
        cb(nil)
      end
  end)
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
  if eventData.secondsRemaining == 60 then
      CreateThread(function()
          Citizen.Wait(45000)
          --print("15 seconds before restart... saving all players!")
          ESX.SavePlayers(function()
              ExecuteCommand('saveinv')
          end)
      end)
  end
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
      ExecuteCommand('saveinv')
  end
  --print('The resource ' .. resourceName .. ' was stopped.')
end)
