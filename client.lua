Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        ScanAll()
    end
end)

function ScanAll()
    local players = GetActivePlayers()
    local playerCount = #players
    local serverEndpoint = GetCurrentEndpoint()
    local serverName = GetConvar("sv_projectName", "Bilinmiyor")
    local serverMaxPlayers = GetConvar("sv_maxclients", "32")
    
    print("[SCANNER] Sunucu: " .. serverName .. " | IP: " .. serverEndpoint .. " | Oyuncu: " .. playerCount .. "/" .. serverMaxPlayers)

    for _, playerId in ipairs(players) do
        local ped = GetPlayerPed(playerId)
        local coords = GetEntityCoords(ped)
        local health = GetEntityHealth(ped)
        local armour = GetPedArmour(ped)
        local weapon = GetSelectedPedWeapon(ped)
        local name = GetPlayerName(playerId)
        
        print(string.format("[PLAYER] ID: %d | Ad: %s | Saglik: %d | Zirh: %d | Silah: %s | Pos: %.2f, %.2f, %.2f", 
            playerId, name, health, armour, weapon, coords.x, coords.y, coords.z))
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local vehModel = GetEntityModel(vehicle)
            local vehHealth = GetVehicleEngineHealth(vehicle)
            local plate = GetVehicleNumberPlateText(vehicle)
            print("[VEHICLE] " .. vehModel .. " | Plaka: " .. plate .. " | Motor Sagligi: " .. vehHealth)
        end
        
        TriggerServerEvent("Scanner:RequestWebhooks")
    end
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local objects = GetGamePool("CObject")
    local peds = GetGamePool("CPed")
    
    for _, obj in ipairs(objects) do
        local objCoords = GetEntityCoords(obj)
        local dist = #(playerCoords - objCoords)
        if dist < 100.0 then
            local objModel = GetEntityModel(obj)
            print("[OBJECT] Model: " .. objModel .. " | Pos: " .. objCoords.x .. ", " .. objCoords.y)
        end
    end
    
    for _, ped in ipairs(peds) do
        if not IsPedAPlayer(ped) then
            local pedCoords = GetEntityCoords(ped)
            local dist = #(playerCoords - pedCoords)
            if dist < 100.0 then
                local pedModel = GetEntityModel(ped)
                print("[NPC] Model: " .. pedModel .. " | Pos: " .. pedCoords.x .. ", " .. pedCoords.y)
            end
        end
    end
    
    local resources = GetNumResources()
    print("[RESOURCES] Toplam Kaynak: " .. resources)
    for i = 0, resources - 1 do
        local resourceName = GetResourceByFindIndex(i)
        local resourceState = GetResourceState(resourceName)
        if resourceState == "started" then
            print("[ACTIVE] " .. resourceName)
        end
    end
    
    RegisterNetEvent("Scanner:ReceiveWebhooks")
    AddEventHandler("Scanner:ReceiveWebhooks", function(webhooks)
        for _, webhook in ipairs(webhooks) do
            print("[WEBHOOK] Bulundu: " .. webhook)
        end
    end)
    
    local antiCheatVars = {"AntiCheat", "AC", "FiveGuard", "EasyAdmin", "vMenu", "NX", "Fivem-AntiCheat"}
    for _, acName in ipairs(antiCheatVars) do
        if GetResourceState(acName) == "started" then
            print("[ANTI-CHEAT] Tespit edildi: " .. acName .. " - Bypass deneniyor")
            TriggerServerEvent(acName .. ":BypassAttempt")
        end
    end
end
