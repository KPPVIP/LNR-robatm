
ESX = nil

local robbed = false
local bezig = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		if not robbed and nearATM() and IsControlJustReleased(0, 23) then
			exports['progressBars']:startUI(10000, "Connecting phone to ATM")
			TriggerEvent('LNR-robatm:connecting')
			bezig = true
			Citizen.Wait(10000)
			bezig = false
			exports['mythic_notify']:DoHudText('success', 'Brute-forcing started.')
			TriggerEvent("mhacking:show")
			TriggerEvent("mhacking:start",7,35,mycb)
		end
	end
end)

function mycb(succes)
	if succes then
		TriggerEvent('mhacking:hide')
		TriggerServerEvent("LNR-robatm:succes")
		robbed = true
		Citizen.Wait(600000)
		robbed = false
	else
		TriggerEvent('mhacking:hide')
		exports['mythic_notify']:DoHudText('error', 'Brute-forcing failed. Try again later')
		robbed = true
		Citizen.Wait(300000)
		robbed = false
	end
end

RegisterNetEvent('LNR-robatm:connecting')
AddEventHandler('LNR-robatm:connecting', function()
			RequestAnimDict("mini@repair")
			while (not HasAnimDictLoaded("mini@repair")) do
				Citizen.Wait(0)
			end
			TaskPlayAnim(GetPlayerPed(-1), "mini@repair" ,"fixing_a_ped" ,8.0, -8.0, -1, 50, 0, false, false, false )
			Citizen.Wait(10000)
			ClearPedTasks(GetPlayerPed(-1))
end)

function nearATM()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(LNR.atms) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 3 then
			DrawText3Ds(search.x, search.y, search.z+.5, 'Press [F] to rob the ATM.')
			return true
		end
	end
end

Citizen.CreateThread(function()
    while true do
        Wait(10)
        while bezig do
             Wait(0)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 34, true) 
			DisableControlAction(0, 31, true) 
			DisableControlAction(0, 30, true)
			DisableControlAction(0, 22, true) 
			DisableControlAction(0, 44, true) 
        end
     end
end)

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end