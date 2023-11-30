ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory
local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.location) do
		if Config.Target == 'ox_target' then
			exports[Config.Target]:addBoxZone({
				coords = vector3(v.coords.x,v.coords.y,v.coords.z),
				size = v.size,
				rotation = v.rotation,
				debug = false,
				options = {
					{
						name = 'evidence_Lockers',
						icon = 'fa-solid fa-cube',
						groups = v.job,
						event = 'Evidence:openInventory',
						label = v.TargetLabel,
						canInteract = function(entity, distance, coords, name)
							return true
						end,
					}
				}
			})
		elseif Config.Target == 'qtarget' then
			exports[Config.Target]:AddBoxZone('evidence_Lockers', vector3(v.coords.x,v.coords.y,v.coords.z), 3, 2, {
                name='evidence_Lockers',
                heading = v.h,
                debugPoly=false,
				minZ = 1.58,
				maxZ = 4.56
            }, {
                options = {
                    {
                    event = 'Evidence:openInventory',
                    icon = 'fas fa-door-open',
                    label = v.TargetLabel,
                    },
                },
				job = {v.job},
                distance = 2.5
            })  
		end
	end
end)

RegisterNetEvent('Evidence:lockerOptions')
AddEventHandler('Evidence:lockerOptions', function(args)
	if args.selection == "delete" then
		local lockerID = args.inventory
		TriggerServerEvent("Evidence:deleteLocker", lockerID)
		Notify("Schließfach gelöscht!")
	elseif args.selection == "open" then
		local lockerID = args.inventory
		if Config.Inv == 'ox' then
			TriggerServerEvent('ox:loadStashes')
			ox_inventory:openInventory('Stash', lockerID)
		elseif Config.Inv == 'qs' then
			TriggerEvent("inventory:client:SetCurrentStash", lockerID)
		end
	end
end)

RegisterNetEvent('Evidence:openInventory')
AddEventHandler('Evidence:openInventory',function()
	refreshjob()
	for k,v in pairs(Config.location) do
		if v.cop == true and v.job == PlayerData.job.name and PlayerData.job.grade >= v.AllowedRank then
			lib.showContext('chiefmenu')
		elseif v.cop == true and v.job == PlayerData.job.name then
			lib.showContext('openInventory')
		elseif v.cop == false and v.job == PlayerData.job.name then
			lib.showContext('other_lockers')
		end
	end
end)

RegisterNetEvent('Evidence:confirmorcancel')
AddEventHandler('Evidence:confirmorcancel', function(args)
	if args.selection == "confirm" then
		local evidenceID = args.inventory
		TriggerServerEvent("Evidence:createInventory", evidenceID)
		Citizen.Wait(1000)
		if Config.Inv == 'ox' then
			TriggerServerEvent('ox:loadStashes')
			ox_inventory:openInventory('Stash', evidenceID)
		elseif Config.Inv == 'qs' then
			exports['qs-inventory']:RegisterStash(Config.slots, Config.weight, evidenceID)
		end
	end
end)

RegisterNetEvent('Evidence:evidenceOptions')
AddEventHandler('Evidence:evidenceOptions', function(args)
	if args.selection == "delete" then
		local evidenceID = args.inventory
		TriggerServerEvent("Evidence:deleteEvidence", evidenceID)
		Notify("Beweise gelöscht!")
	elseif args.selection == "open" then
		local evidenceID = args.inventory
		Citizen.Wait(1000)
		if Config.Inv == 'ox' then
			TriggerServerEvent('ox:loadStashes')
			ox_inventory:openInventory('Stash', evidenceID)
		elseif Config.Inv == 'qs' then
			TriggerEvent("inventory:client:SetCurrentStash", evidenceID)
		end
	end
end)

RegisterNetEvent('Evidence:ChiefMenu')
AddEventHandler('Evidence:ChiefMenu',function()
	lib.showContext('chooseOption')
end)

RegisterNetEvent('Evidence:confirmLocker')
AddEventHandler('Evidence:confirmLocker', function(args)
	if args.selection == "confirm" then
		local lockerID = args.inventory
		TriggerServerEvent("Evidence:createLocker", lockerID)
		Citizen.Wait(1000)
		if Config.Inv == 'ox' then
			TriggerServerEvent('ox:loadStashes')
			ox_inventory:openInventory('Stash', lockerID)
		elseif Config.Inv == 'qs' then
			TriggerEvent("inventory:client:SetCurrentStash", lockerID)
		end
	end
end)

RegisterNetEvent('Evidence:ChieflockerOptions')
AddEventHandler('Evidence:ChieflockerOptions', function(args)
	if args.selection == "delete" then
		local lockerID = args.inventory
		TriggerServerEvent("Evidence:deleteLocker", lockerID)
		Notify("Deleted Locker!")
	elseif args.selection == "open" then
		local lockerID = args.inventory
		if Config.Inv == 'ox' then
			TriggerServerEvent('ox:loadStashes')
			ox_inventory:openInventory('Stash', lockerID)
		elseif Config.Inv == 'qs' then
			TriggerEvent("inventory:client:SetCurrentStash", lockerID)
		end
	end
end)

RegisterNetEvent('Evidence:OtherlockerOptions')
AddEventHandler('Evidence:OtherlockerOptions', function(args)
	if args.selection == "delete" then
		local OtherlockerID = args.inventory
		TriggerServerEvent("Evidence:deleteLocker", OtherlockerID)
		Notify("Deleted Locker!")
	elseif args.selection == "open" then
		local OtherlockerID = args.inventory
		if Config.Inv == 'ox' then
			TriggerServerEvent('ox:loadStashes')
			ox_inventory:openInventory('Stash', OtherlockerID)
		elseif Config.Inv == 'qs' then
			TriggerEvent("inventory:client:SetCurrentStash", OtherlockerID)
		end
	end
end)

RegisterNetEvent('Evidence:confirmorcancelOthers')
AddEventHandler('Evidence:confirmorcancelOthers', function(args)
	if args.selection == "confirm" then
		local OtherlockerID = args.inventory
		TriggerServerEvent("Evidence:createOtherLocker", OtherlockerID)
		Citizen.Wait(1000)
		if Config.Inv == 'ox' then
			TriggerServerEvent('ox:loadStashes')
			ox_inventory:openInventory('Stash', OtherlockerID)
		elseif Config.Inv == 'qs' then
			TriggerEvent("inventory:client:SetCurrentStash", OtherlockerID)
		end
	end
end)

     -- Context

lib.registerContext({
	id = 'chiefmenu',
	title = 'Schließfächer',
	options = {
		{
			title = 'Chief Optionen',
			description = 'Chief Optionen',
			arrow = true,
			event = 'Evidence:ChiefMenu',
		},
		{
			title = 'Schließfach öffnen',
			description = 'Personal Schließfach',
			arrow = true,
			event = 'Evidence:lockerCallbackEvent',
		},
		{
			title = 'Beweismittelschrank öffnen',
			description = 'Beweiskisten öffnen',
			arrow = true,
			event = 'Evidence:triggerEvidenceMenu',
		}
	},
})

lib.registerContext({
	id = 'openInventory',
	title = 'Beweismittelschränke!',
	options = {
		{
			title = 'Schließfach öffnen',
			description = 'Personal Schließfach',
			arrow = true,
			event = 'Evidence:lockerCallbackEvent',
		},
		{
			title = 'Beweismittelschrank öffnen',
			description = 'Beweiskisten öffnen',
			arrow = true,
			event = 'Evidence:triggerEvidenceMenu',
		}
	},
})

RegisterNetEvent('Evidence:triggerEvidenceMenu')
AddEventHandler('Evidence:triggerEvidenceMenu', function()
	local input = lib.inputDialog('LSPD Beweise', {'Incident Number (#...)'})

	if not input then 
		lib.hideContext(false)
		return 
	end
	local evidenceID = ("Case :#"..input[1])

	ESX.TriggerServerCallback('Evidence:getInventory', function(exists)
		if not exists then
			lib.registerContext({
				id = 'confirmCreate',
				title = 'Confirm or Cancel',
				options = {
					{
						title = 'Neues Beweisinventar erstellen?',
						description = 'Beweisinventarsystem'
					},
					{
						title = 'Erstellung bestätigen?',
						description = 'Beweismittelspeicher erstellen?',
						arrow = true,
						event = 'Evidence:confirmorcancel',
						args = {
							selection = 'confirm', 
							inventory = evidenceID
						}
					},
					{
						title = 'Erstellung abbrechen?',
						description = 'Die Erstellung dieses Beweisspeichers abbrechen?',
						arrow = true,
						event = 'Evidence:confirmorcancel',
						args = {
							selection = 'cancel'
						}
					}
				},
			})

			lib.showContext('confirmCreate')
		else
			lib.registerContext({
				id = 'evidenceOption',
				title = 'Evidence Options',
				options = {
					{
						title = 'Beweise löschen/öffnen'
					},
					{
						title = 'Beweise öffnen?',
						description = 'Offene Beweismittelaufbewahrung?',
						arrow = true,
						event = 'Evidence:evidenceOptions',
						args = {
							selection = "open",
							inventory = evidenceID
						}
					},
					{
						title = 'Inventar löschen?',
						description = 'Diesen Beweisspeicher löschen?',
						arrow = true,
						event = 'Evidence:evidenceOptions',
						args = {
							selection = "delete",
							inventory = evidenceID
						}
					}
				},
			})
			lib.showContext('evidenceOption')
		end
	end, evidenceID)
end)

function lockerOption(lockerID)
	lib.registerContext({
		id = 'lockerOption',
		title = 'Bestätigen oder abbrechen',
		options = {
			{
				title = 'Schließfachoptionen',
				description = 'Schließfach löschen/öffnen'
			},
			{
				title = 'Schließfach öffnen?',
				description = 'Ein persönliches Schließfach öffnen?',
				arrow = true,
				event = 'Evidence:lockerOptions',
				args = {
					selection = 'open', 
					inventory = lockerID
				},
				metadata = {
					{label = lockerID}
				}
			},
			{
				title = 'Locker löschen?',
				description = 'Persönliches Schließfach löschen?',
				arrow = true,
				event = 'Evidence:confirmorcancel',
				args = {
					selection = "delete",
					inventory = lockerID
				}
			}
		},
	})

	lib.showContext('lockerOption')
end

RegisterNetEvent('Evidence:lockerCallbackEvent')
AddEventHandler('Evidence:lockerCallbackEvent', function()
    ESX.TriggerServerCallback('Evidence:getPlayerName', function(data)
        if data ~= nil then
			local lockerID = ("Name: "..data.firstname.." "..data.lastname)
			ESX.TriggerServerCallback('Evidence:getLocker', function(locker)
				if locker then
					local lockerID = ("Name: "..data.firstname.." "..data.lastname)
					lib.registerContext({
						id = 'lockerCreate',
						title = 'Bestätigen oder abbrechen',
						options = {
							{
								title = 'Neues Schließfach erstellen?',
								description = 'Schließfachinventarsystem'
							},
							{
								title = 'Erstellung bestätigen?',
								description = 'Ein persönliches Schließfach erstellen?',
								arrow = true,
								event = 'Evidence:confirmLocker',
								args = {selection = 'confirm', inventory = lockerID}
							},
							{
								title = 'Erstellung abbrechen?',
								description = 'Die Erstellung dieses persönlichen Schließfachs abbrechen?',
								arrow = true,
								event = 'Evidence:confirmLocker',
								args = {selection = 'cancel'}
							}
						},
					})
				
					lib.showContext('lockerCreate')
				else
					local lockerID = ("Name: "..data.firstname.." "..data.lastname)
					lib.registerContext({
						id = 'lockerOption',
						title = 'Bestätigen oder abbrechen',
						options = {
							{
								title = 'Schließfachoptionen',
								description = 'Schließfach löschen/öffnen'
							},
							{
								title = 'Schließfach öffnen?',
								description = 'Ein persönliches Schließfach öffnen?',
								arrow = true,
								event = 'Evidence:lockerOptions',
								args = {
									selection = 'open', 
									inventory = lockerID
								},
								metadata = {
									{label = lockerID}
								}
							},
							{
								title = 'Schließfach löschen?',
								description = 'Persönliches Schließfach löschen?',
								arrow = true,
								event = 'Evidence:confirmorcancel',
								args = {
									selection = "delete",
									inventory = lockerID
								}
							}
						},
					})
				
					lib.showContext('lockerOption')
				end
			end,lockerID)
		else
            Notify(3, "Informationen können nicht gefunden werden!")
        end
    end,data)
end)

lib.registerContext({
	id = 'chooseOption',
	title = 'Options...',
	options = {
		{
			title = 'Choose Option',
			description = 'Pick an Option below for Locker/Evidence Opening!'
		},
		{
			title = 'Open Locker?',
			description = 'Open a Personal Locker?',
			arrow = true,
			event = 'Evidence:ChiefLookup',
		},
		{
			title = 'Open Case?',
			description = 'Open an Evidence Storage?',
			arrow = true,
			event = 'Evidence:ChiefCaseMenu',
		}
	},
})

function ChooseOption()
	lib.showContext('chooseOption')
end

RegisterNetEvent('Evidence:ChiefLookup')
AddEventHandler('Evidence:ChiefLookup', function()
	local input = lib.inputDialog('Police locker', {'First Name', 'Last Name'})

	if not input then 
		lib.hideContext(false)
		return 
	end
	local lockerID = ("LEO: "..input[1].. " "..input[2])
	ESX.TriggerServerCallback('Evidence:getLocker', function(exists)
		if not exists then
			lib.registerContext({
				id = 'lockerOption',
				title = 'Confirm or Cancel',
				options = {
					{
						title = 'Locker Options',
						description = 'Locker Delete/Open'
					},
					{
						title = 'Open Locker?',
						description = 'Open a Personal Locker?',
						arrow = true,
						event = 'Evidence:lockerOptions',
						args = {
							selection = 'open', 
							inventory = lockerID
						},
						metadata = {
							{label = lockerID}
						}
					},
					{
						title = 'Delete Locker?',
						description = 'Delete Your Personal Locker?',
						arrow = true,
						event = 'Evidence:confirmorcancel',
						args = {
							selection = "delete",
							inventory = lockerID
						}
					}
				},
			})
		
			lib.showContext('lockerOption')
		else
			Notify(3,string.format('No Lockers with name: '..lockerID))	
		end
	end, lockerID)
end)

RegisterNetEvent('Evidence:ChiefCaseMenu')
AddEventHandler('Evidence:ChiefCaseMenu', function()
	local input = lib.inputDialog('LSPD Cases', {'Enter Case#'})

	if not input then 
		lib.hideContext(false)
		return 
	end
	local evidenceID = ("Case :#"..input[1])
	ESX.TriggerServerCallback('Evidence:getInventory', function(exists)
		if exists then
			lib.registerContext({
				id = 'evidenceOption',
				title = 'Evidence Options',
				options = {
					{
						title = 'Evidence Delete/Open'
					},
					{
						title = 'Open Evidence?',
						description = 'Open Evidence Storage?',
						arrow = true,
						event = 'Evidence:evidenceOptions',
						args = {
							selection = "open",
							inventory = evidenceID
						}
					},
					{
						title = 'Delete Inventory?',
						description = 'Delete this Evidence Storage?',
						arrow = true,
						event = 'Evidence:evidenceOptions',
						args = {
							selection = "delete",
							inventory = evidenceID
						}
					}
				},
			})
			lib.showContext('evidenceOption')
		else
			Notify(3, string.format('No Evidence Storages with name: '..evidenceID))
		end
	end, evidenceID)
end)

RegisterNetEvent('Evidence:ChiefLockerCheck')
AddEventHandler('Evidence:ChiefLockerCheck',function(ID)
	ESX.TriggerServerCallback('Evidence:getLocker', function(exists)
		if exists then
			lockerOption(ID)
		else
			Notify(3,string.format('No Lockers with name: '..ID))	
		end
	end, ID)
end)

function ChieflockerOption(ID)
	lib.registerContext({
		id = 'ChieflockerOption',
		title = 'Confirm or Cancel',
		options = {
			{
				title = 'Locker Options',
				description = 'Locker Delete/Open'
			},
			{
				title = 'Open Storage?',
				description = 'Open an Evidence Locker?',
				arrow = true,
				event = 'Evidence:lockerOptions',
				args = {
					selection = 'open', 
					inventory = ID
				},
				metadata = {
					{label = ID, value = 'Personal'},
				}
			},
			{
				title = 'Delete Locker?',
				description = 'Delete Your Evidence Locker?',
				arrow = true,
				event = 'Evidence:confirmorcancel',
				args = {
					selection = "delete",
					inventory = lockerID
				}
			}
		},
	})

	lib.showContext('ChieflockerOption')
end



function Notify(noty_type, message)
    if noty_type and message then
        if Config.NotificationType.client == 'esx' then
            ESX.ShowNotification(message)

        elseif Config.NotificationType.client == 'ox' then
            if noty_type == 1 then
				lib.notify({
					title = 'Evidence',
					description = message,
					type = 'success'
				})
                exports['okokNotify']:Alert("Evidence", message, 10000, 'success')
            elseif noty_type == 2 then
				lib.notify({
					title = 'Evidence',
					description = message,
					type = 'inform'
				})
            elseif noty_type == 3 then
				lib.notify({
					title = 'Evidence',
					description = message,
					type = 'error'
				})
            end

        elseif Config.NotificationType.client == 'okokNotify' then
            if noty_type == 1 then
                exports['okokNotify']:Alert("Evidence", message, 10000, 'success')
            elseif noty_type == 2 then
                exports['okokNotify']:Alert("Evidence", message, 10000, 'info')
            elseif noty_type == 3 then
                exports['okokNotify']:Alert("Evidence", message, 10000, 'error')
            end

        elseif Config.NotificationType.client == 'mythic' then
            if noty_type == 1 then
                exports['mythic_notify']:SendAlert('success', message, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
            elseif noty_type == 2 then
                exports['mythic_notify']:SendAlert('inform', message, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
            elseif noty_type == 3 then
                exports['mythic_notify']:SendAlert('error', message, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
            end

        elseif Config.NotificationType.client == 'chat' then
            TriggerEvent('chatMessage', message)
            
        elseif Config.NotificationType.client == 'other' then
            --add your own notification.
            
        end
    end
end

lib.registerContext({
	id = 'other_lockers',
	title = 'Personal Lockers!',
	options = {
		{
			title = 'Open Locker Room',
			description = 'Open Locker Room',
			arrow = true,
			event = 'Evidence:OtherlockerCallbackEvent',
		}
	},
})

RegisterNetEvent('Evidence:OtherlockerCallbackEvent')
AddEventHandler('Evidence:OtherlockerCallbackEvent', function()
    ESX.TriggerServerCallback('Evidence:getPlayerName', function(data)
        if data ~= nil then
			local OtherlockerID = (PlayerData.job.label.. ": " ..data.firstname.." "..data.lastname)
			ESX.TriggerServerCallback('Evidence:getOtherInventories', function(Otherlocker)
				if Otherlocker then
					local OtherlockerID = (PlayerData.job.label.. ": " ..data.firstname.." "..data.lastname)
					lib.registerContext({
						id = 'Other_lockerOption',
						title = 'Confirm or Cancel',
						options = {
							{
								title = 'Locker Options',
								description = 'Locker Delete/Open'
							},
							{
								title = 'Open Locker?',
								description = 'Open a Personal Locker?',
								arrow = true,
								event = 'Evidence:OtherlockerOptions',
								args = {
									selection = 'open', 
									inventory = OtherlockerID
								}
							},
							{
								title = 'Delete Locker?',
								description = 'Delete Your Personal Locker?',
								arrow = true,
								event = 'Evidence:confirmorcancel',
								args = {
									selection = "delete",
									inventory = lockerID
								}
							}
						},
					})
				
					lib.showContext('Other_lockerOption')
				else
					local OtherlockerID = (PlayerData.job.label.. ": " ..data.firstname.." "..data.lastname)
					lib.registerContext({
						id = 'Other_lockerCreate',
						title = 'Confirm or Cancel',
						options = {
							{
								title = 'Create New Locker?',
								description = 'Locker Inventory System'
							},
							{
								title = 'Confirm Creation?',
								description = 'Create a Personal Locker?',
								arrow = true,
								event = 'Evidence:confirmorcancelOthers',
								args = {selection = 'confirm', inventory = OtherlockerID}
							},
							{
								title = 'Cancel Creation?',
								description = 'Cancel The Creation of this Personal Locker?',
								arrow = true,
								event = 'Evidence:confirmorcancelOthers',
								args = {selection = 'cancel'}
							}
						},
					})
				
					lib.showContext('Other_lockerCreate')
				end
			end,OtherlockerID)
		else
            Notify(3, "Info can\'t be found!")
        end
    end,data)
end)

function refreshjob()
    Citizen.Wait(0)
    PlayerData = ESX.GetPlayerData()
end
